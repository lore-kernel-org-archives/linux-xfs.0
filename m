Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49134 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbdK1Shp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 13:37:45 -0500
Date: Tue, 28 Nov 2017 10:37:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 13/17] xfs: add parent attributes to link
Message-ID: <20171128183741.GL21412@magnolia>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-14-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510942905-12897-14-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Fri, Nov 17, 2017 at 11:21:41AM -0700, Allison Henderson wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This patch modifies xfs_link to add a parent pointer to the inode.
> xfs_link will also need to create an attribute fork if the inode does
> not already have one.
> 
> [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> 	   fixed null pointer bugs]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 61 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1c45c73..0ad843d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1451,6 +1451,8 @@ xfs_link(
>  	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t           first_block;
>  	int			resblks;
> +	uint32_t		diroffset;

xfs_dir2_dataptr_t?

> +	bool			first_parent = false;
>  
>  	trace_xfs_link(tdp, target_name);
>  
> @@ -1467,6 +1469,25 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> +	/*
> +	 * If we have parent pointers and there is no attribute fork (i.e. we
> +	 * are linking in a O_TMPFILE created inode) we need to add the
> +	 * attribute fork to the inode. Because we may have an existing data
> +	 * fork, we do this before we start the link transaction as adding an
> +	 * attribute fork requires it's own transaction.

About that -- does the deferred 'add xattr' operation have an implicit
assumption that the inode in question already has an attribute fork?  I
suppose so long as we're careful to ensure that we never queue up a
deferred op until after we've committed the transaction that adds the
attr fork then that assumption is ok.

(I think the xfs_trans_attr() function needs an ASSERT(xfs_inode_hasattr())
so we can check that assumption.)

> +	 */
> +	if (xfs_sb_version_hasparent(&mp->m_sb) && !xfs_inode_hasattr(sip)) {
> +		int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +				XFS_ATTR_SF_ENTSIZE_BYNAME(
> +					sizeof(struct xfs_parent_name_rec),
> +					target_name->len);
> +		ASSERT(VFS_I(sip)->i_nlink == 0);
> +		error = xfs_bmap_add_attrfork(sip, sf_size, 0);
> +		if (error)
> +			goto std_return;
> +		first_parent = true;
> +	}
> +
>  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
>  	if (error == -ENOSPC) {
> @@ -1498,8 +1519,6 @@ xfs_link(
>  			goto error_return;
>  	}
>  
> -	xfs_defer_init(&dfops, &first_block);
> -
>  	/*
>  	 * Handle initial link state of O_TMPFILE inode
>  	 */
> @@ -1509,36 +1528,50 @@ xfs_link(
>  			goto error_return;
>  	}
>  
> +	xfs_defer_init(&dfops, &first_block);
>  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -				   &first_block, &dfops, resblks, NULL);
> +				   &first_block, &dfops, resblks, &diroffset);
>  	if (error)
> -		goto error_return;
> +		goto out_defer_cancel;

Oh good, you fixed the problem where xfs_defer_cancel doesn't get called
on the error jumpout.

>  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>  
>  	error = xfs_bumplink(tp, sip);
>  	if (error)
> -		goto error_return;
> +		goto out_defer_cancel;
>  
>  	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * link transaction goes to disk before returning to
> -	 * the user.
> +	 * If we have parent pointers, we now need to add the parent record to
> +	 * the attribute fork of the inode. If this is the initial parent
> +	 * atribute, we need to create it correctly, otherwise we can just add

"attribute"

--D

> +	 * the parent to the inode.
> +	 */
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		error = xfs_parent_add(tp, tdp, sip, target_name,
> +				       diroffset, &dfops,
> +				       &first_block);
> +		if (error)
> +			goto out_defer_cancel;
> +	}
> +
> +	/*
> +	 * If this is a synchronous mount, make sure that the link transaction
> +	 * goes to disk before returning to the user.
>  	 */
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
>  	error = xfs_defer_finish(&tp, &dfops);
> -	if (error) {
> -		xfs_defer_cancel(&dfops);
> -		goto error_return;
> -	}
> +	if (error)
> +		goto out_defer_cancel;
>  
>  	return xfs_trans_commit(tp);
>  
> - error_return:
> +out_defer_cancel:
> +	xfs_defer_cancel(&dfops);
> +error_return:
>  	xfs_trans_cancel(tp);
> - std_return:
> +std_return:
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
