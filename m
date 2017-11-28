Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24413 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdK1SUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 13:20:44 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vASIKg6A013392
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 18:20:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vASIKf6j016261
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 18:20:41 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vASIKf4i023479
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 18:20:41 GMT
Date: Tue, 28 Nov 2017 10:20:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 15/17] Add parent pointers to rename
Message-ID: <20171128182040.GJ21412@magnolia>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-16-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510942905-12897-16-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 17, 2017 at 11:21:43AM -0700, Allison Henderson wrote:
> This patch removes the old parent pointer attribute during the
> rename operation, and re-adds the updated parent pointer
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2.c |  6 ++++--
>  fs/xfs/xfs_inode.c       | 26 ++++++++++++++++++++------
>  2 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 25b370b..ed25203 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -324,10 +324,11 @@ xfs_dir_createname(
>  	else
>  		rval = xfs_dir2_node_addname(args);
>  
> +out_free:
>  	/* return the location that this entry was place in the parent inode */
>  	if (offset)
>  		*offset = args->offset;
> -out_free:
> +
>  	kmem_free(args);
>  	return rval;
>  }
> @@ -496,9 +497,10 @@ xfs_dir_removename(
>  		rval = xfs_dir2_leaf_removename(args);
>  	else
>  		rval = xfs_dir2_node_removename(args);
> +out_free:
>  	if (offset)
>  		*offset = args->offset;
> -out_free:
> +

Why do these labels need to be moved here?  The *offset = ... lines are
new, so why not put them in their final place in the patch that adds
those lines?

>  	kmem_free(args);
>  	return rval;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a289a40..da5c761 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2984,6 +2984,8 @@ xfs_rename(
>  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>  	int			spaceres;
>  	int			error;
> +	xfs_dir2_dataptr_t	new_diroffset;
> +	xfs_dir2_dataptr_t	old_diroffset;
>  
>  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>  
> @@ -3086,13 +3088,12 @@ xfs_rename(
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
>  					   src_ip->i_ino, &first_block, &dfops,
> -					   spaceres, NULL);
> +					   spaceres, &new_diroffset);
>  		if (error)
>  			goto out_bmap_cancel;
>  
>  		xfs_trans_ichgtime(tp, target_dp,
>  					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -

Huh?

>  		if (new_parent && src_is_directory) {
>  			error = xfs_bumplink(tp, target_dp);
>  			if (error)
> @@ -3126,7 +3127,7 @@ xfs_rename(
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
>  					src_ip->i_ino, &first_block, &dfops,
> -					spaceres, NULL);
> +					spaceres, &new_diroffset);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -3161,7 +3162,7 @@ xfs_rename(
>  		 */
>  		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
>  					target_dp->i_ino, &first_block, &dfops,
> -					spaceres, NULL);
> +					spaceres, &new_diroffset);
>  		ASSERT(error != -EEXIST);
>  		if (error)
>  			goto out_bmap_cancel;
> @@ -3200,11 +3201,12 @@ xfs_rename(
>  	 */
>  	if (wip) {
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
> -					&first_block, &dfops, spaceres, NULL);
> +					&first_block, &dfops, spaceres,
> +					&old_diroffset);
>  	} else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>  					   &first_block, &dfops, spaceres,
> -					   NULL);
> +					   &old_diroffset);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -3234,6 +3236,18 @@ xfs_rename(
>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
>  	}
>  
> +	if (new_parent && xfs_sb_version_hasparent(&mp->m_sb)) {

I'm confused about checking new_parent -- does this cause us to forget
to update the pptr for a rename within a directory?

I'm assuming that all of these directory operations will get their own
xfstests in time... (create a file, check pptr; hardlink a file, check
both pptrs; delete one of the links, check pptrs; check pptr after a
rename within a dir; check pptr after a rename between dirs; etc.)

--D

> +		error = xfs_parent_add(tp, target_dp, src_ip, target_name,
> +				       new_diroffset, &dfops, &first_block);
> +		if (error)
> +			goto out_bmap_cancel;
> +
> +		error = xfs_parent_remove(tp, src_dp, src_ip,
> +					  old_diroffset, &dfops, &first_block);
> +		if (error)
> +			goto out_bmap_cancel;
> +	}
> +
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
