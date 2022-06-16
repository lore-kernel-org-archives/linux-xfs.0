Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B553C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 22:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiFPWj1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiFPWj1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 18:39:27 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A28162101
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 15:39:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2B8AA10E74EC;
        Fri, 17 Jun 2022 08:39:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1y95-007VFw-65; Fri, 17 Jun 2022 08:39:23 +1000
Date:   Fri, 17 Jun 2022 08:39:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 11/17] xfs: add parent attributes to link
Message-ID: <20220616223923.GG227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-12-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62abb11d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=i2HPrIbktj9S3V3ZufUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:54AM -0700, Allison Henderson wrote:
> This patch modifies xfs_link to add a parent pointer to the inode.
> 
> [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>            fixed null pointer bugs]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 78 ++++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_trans.c |  7 +++--
>  fs/xfs/xfs_trans.h |  2 +-
>  3 files changed, 67 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6b1e4cb11b5c..41c58df8e568 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1254,14 +1254,28 @@ xfs_create_tmpfile(
>  
>  int
>  xfs_link(
> -	xfs_inode_t		*tdp,
> -	xfs_inode_t		*sip,
> -	struct xfs_name		*target_name)
> -{
> -	xfs_mount_t		*mp = tdp->i_mount;
> -	xfs_trans_t		*tp;
> -	int			error, nospace_error = 0;
> -	int			resblks;
> +	xfs_inode_t			*tdp,
> +	xfs_inode_t			*sip,
> +	struct xfs_name			*target_name)
> +{
> +	xfs_mount_t			*mp = tdp->i_mount;
> +	xfs_trans_t			*tp;
> +	int				error, nospace_error = 0;
> +	int				resblks;
> +	struct xfs_parent_name_rec	rec;
> +	xfs_dir2_dataptr_t		diroffset;
> +
> +	struct xfs_da_args		args = {
> +		.dp		= sip,
> +		.geo		= mp->m_attr_geo,
> +		.whichfork	= XFS_ATTR_FORK,
> +		.attr_filter	= XFS_ATTR_PARENT,
> +		.op_flags	= XFS_DA_OP_OKNOENT,
> +		.name		= (const uint8_t *)&rec,
> +		.namelen	= sizeof(rec),
> +		.value		= (void *)target_name->name,
> +		.valuelen	= target_name->len,
> +	};

Now that I've had a bit of a think about this, this pattern of
placing the rec on the stack and then using it as a buffer that is
then accessed in xfs_tran_commit() processing feels like a landmine.

That is, we pass transaction contexts around functions as they are
largely independent constructs, but adding this stack variable to
the defer ops attached to the transaction means that the transaction
cannot be passed back to a caller for it to be committed - that will
corrupt the stack buffer and hence silently corrupt the parent attr
that is going to be logged when the transaction is finally committed.

Hence I think this needs to be wrapped up as a dynamically allocated
structure that is freed when the defer ops are done with it. e.g.

struct xfs_parent_defer {
	struct xfs_parent_name_rec	rec;
	xfs_dir2_dataptr_t		diroffset;
	struct xfs_da_args		args;
};

and then here:

>  
>  	trace_xfs_link(tdp, target_name);
>  
> @@ -1278,11 +1292,17 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> +	if (xfs_has_larp(mp)) {
> +		error = xfs_attr_grab_log_assist(mp);
> +		if (error)
> +			goto std_return;
> +	}

	struct xfs_parent_defer		*parent = NULL;
.....

	error = xfs_parent_init(mp, target_name, &parent);
	if (error)
		goto std_return;

and xfs_parent_init() looks something like this:

int
xfs_parent_init(
	.....
	struct xfs_parent_defer		**parentp)
{
	struct xfs_parent_defer		*parent;

	if (!xfs_has_parent_pointers(mp))
		return 0;

	error = xfs_attr_grab_log_assist(mp);
	if (error)
		return error;

	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
	if (!parent)
		return -ENOMEM;

	/* init parent da_args */

	*parentp = parent;
	return 0;
}

With that in place, we then can wrap all this up:

>  
> +	/*
> +	 * If we have parent pointers, we now need to add the parent record to
> +	 * the attribute fork of the inode. If this is the initial parent
> +	 * attribute, we need to create it correctly, otherwise we can just add
> +	 * the parent to the inode.
> +	 */
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		args.trans = tp;
> +		xfs_init_parent_name_rec(&rec, tdp, diroffset);
> +		args.hashval = xfs_da_hashname(args.name,
> +					       args.namelen);
> +		error = xfs_attr_defer_add(&args);
> +		if (error)
> +			goto out_defer_cancel;
> +	}

with:

	if (parent) {
		error = xfs_parent_defer_add(tp, tdp, parent, diroffset);
		if (error)
			goto out_defer_cancel;
	}

and implement it something like:

int
xfs_parent_defer_add(
	struct xfs_trans	*tp,
	struct xfs_inode	*ip,
	struct xfs_parent_defer	*parent,
	xfs_dir2_dataptr_t	diroffset)
{
	struct xfs_da_args	*args = &parent->args;

	xfs_init_parent_name_rec(&parent->rec, ip, diroffset)
	args->trans = tp;
	args->hashval = xfs_da_hashname(args->name, args->namelen);
	return xfs_attr_defer_add(args);
}


> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * link transaction goes to disk before returning to
> @@ -1331,11 +1367,21 @@ xfs_link(
>  	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
>  		xfs_trans_set_sync(tp);
>  
> -	return xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);

with a xfs_parent_free(parent) added here now that we are done with
the parent update.

> +	return error;
>  
> - error_return:
> +out_defer_cancel:
> +	xfs_defer_cancel(tp);
> +error_return:
>  	xfs_trans_cancel(tp);
> - std_return:
> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> +drop_incompat:
> +	if (xfs_has_larp(mp))
> +		xlog_drop_incompat_feat(mp->m_log);

And this can be replace with  xfs_parent_cancel(mp, parent); that
drops the log incompat featuer and frees the parent if it is not
null.

> +std_return:
>  	if (error == -ENOSPC && nospace_error)
>  		error = nospace_error;
>  	return error;
> @@ -2819,7 +2865,7 @@ xfs_remove(
>  	 */
>  	resblks = XFS_REMOVE_SPACE_RES(mp);
>  	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
> -			&tp, &dontcare);
> +			&tp, &dontcare, XFS_ILOCK_EXCL);

So you add this flag here so that link and remove can do different
things in xfs_trans_alloc_dir(), but in the very next patch
this gets changed to zero, so both callers only pass 0 to the
function.

Ideally there should be a patch prior to this one that converts
the locking and joining of both link and remove to use external
inode locking in a single patch, similar to the change in the second
patch that changed the inode locking around xfs_init_new_inode() to
require manual unlock. Then all the locking mods in this and the
next patch go away, leaving just the parent pointer mods in this
patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
