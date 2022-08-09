Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B6FC25B06
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 19:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343623AbiHITH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245651AbiHITFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 15:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5D026AF2
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 11:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9CA61296
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 18:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F29C433D6;
        Tue,  9 Aug 2022 18:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660070605;
        bh=usOlRrZqV7dn74f0+hNUK+tzUNCYtiuCAyP203oxvBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tRFLxSHksJ26A0d1MMphJfQOOsKPkSV5DBEncK3DFljTMgUsgug+VIhyFaEp/w+4U
         UhLwkeQoxyY4ceLeczX1cmf5biLi3kSE7/U1uCNgZCJiZ7qd9fwSrwfkaW3Zm6o09B
         VzRhV3LnytSqND+hVIrBuAa/cBmPeIN9rgKq2ildjEA55pDmfl+q6OWUXvj3rgnfhD
         4kEVy63BUjyoG8oMJsJiNk2wjxc5cX0Ha9wklYKm4FQZmxSOsFzracrZpCrpbgs8oO
         lhrEsuEhkUqz1m+eRywFL19YX/MXWI/k9aO9R8CJpGH0mmqEWQeb1vWuwuMyEOOK3r
         NwadoiMQq9lGA==
Date:   Tue, 9 Aug 2022 11:43:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 13/18] xfs: add parent attributes to link
Message-ID: <YvKqzD3vmXSZqdr8@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:08PM -0700, Allison Henderson wrote:
> This patch modifies xfs_link to add a parent pointer to the inode.
> 
> [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>            fixed null pointer bugs]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ef993c3a8963..6e5deb0d42c4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
>  
>  int
>  xfs_link(
> -	xfs_inode_t		*tdp,
> -	xfs_inode_t		*sip,
> +	struct xfs_inode	*tdp,
> +	struct xfs_inode	*sip,
>  	struct xfs_name		*target_name)
>  {
> -	xfs_mount_t		*mp = tdp->i_mount;
> -	xfs_trans_t		*tp;
> +	struct xfs_mount	*mp = tdp->i_mount;
> +	struct xfs_trans	*tp;
>  	int			error, nospace_error = 0;
>  	int			resblks;
> +	xfs_dir2_dataptr_t	diroffset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_link(tdp, target_name);
>  
> @@ -1252,11 +1254,17 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, sip, target_name, &parent);

Why does xfs_parent_init check xfs_has_parent if the callers already do
that?

> +		if (error)
> +			goto std_return;
> +	}
> +
>  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);

Same comment about increasing XFS_LINK_SPACE_RES to accomodate xattr
expansion as I had for the last patch.

>  	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
>  			&tp, &nospace_error);
>  	if (error)
> -		goto std_return;
> +		goto drop_incompat;
>  
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
> @@ -1289,14 +1297,26 @@ xfs_link(
>  	}
>  
>  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -				   resblks, NULL);
> +				   resblks, &diroffset);
>  	if (error)
> -		goto error_return;
> +		goto out_defer_cancel;
>  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>  
>  	xfs_bumplink(tp, sip);
>  
> +	/*
> +	 * If we have parent pointers, we now need to add the parent record to
> +	 * the attribute fork of the inode. If this is the initial parent
> +	 * attribute, we need to create it correctly, otherwise we can just add
> +	 * the parent to the inode.
> +	 */
> +	if (parent) {
> +		error = xfs_parent_defer_add(tp, tdp, parent, diroffset);

A followup to the comments I made to the previous patch about
parent->args.dp --

Since you're partially initializing the xfs_defer_parent structure
before you even have the dir offset, why not delay initializing the
parent and child pointers until the xfs_parent_defer_add step?

int
xfs_parent_init(
	struct xfs_mount		*mp,
	struct xfs_parent_defer		**parentp)
{
	struct xfs_parent_defer		*parent;
	int				error;

	if (!xfs_has_parent(mp))
		return 0;

	error = xfs_attr_grab_log_assist(mp);
	if (error)
		return error;

	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
	if (!parent)
		return -ENOMEM;

	/* init parent da_args */
	parent->args.geo = mp->m_attr_geo;
	parent->args.whichfork = XFS_ATTR_FORK;
	parent->args.attr_filter = XFS_ATTR_PARENT;
	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
	parent->args.name = (const uint8_t *)&parent->rec;
	parent->args.namelen = sizeof(struct xfs_parent_name_rec);

	*parentp = parent;
	return 0;
}

int
xfs_parent_defer_add(
	struct xfs_trans	*tp,
	struct xfs_parent_defer	*parent,
	struct xfs_inode	*dp,
	struct xfs_name		*parent_name,
	xfs_dir2_dataptr_t	parent_offset,
	struct xfs_inode	*child)
{
	struct xfs_da_args	*args = &parent->args;

	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
	args->hashval = xfs_da_hashname(args->name, args->namelen);

	args->trans = tp;
	args->dp = child;
	if (parent_name) {
		args->name = parent_name->name;
		args->valuelen = parent_name->len;
	}
	return xfs_attr_defer_add(args);
}

And then the callsites become:

	/*
	 * If we have parent pointers, we now need to add the parent record to
	 * the attribute fork of the inode. If this is the initial parent
	 * attribute, we need to create it correctly, otherwise we can just add
	 * the parent to the inode.
	 */
	if (parent) {
		error = xfs_parent_defer_add(tp, parent, tdp,
				target_name, diroffset, sip);
		if (error)
			goto out_defer_cancel;
	}

Aside from the API suggestions, the rest looks good to me.

--D

> +		if (error)
> +			goto out_defer_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * link transaction goes to disk before returning to
> @@ -1310,11 +1330,16 @@ xfs_link(
>  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>  	return error;
>  
> - error_return:
> +out_defer_cancel:
> +	xfs_defer_cancel(tp);
> +error_return:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
>  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> - std_return:
> +drop_incompat:
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
> +std_return:
>  	if (error == -ENOSPC && nospace_error)
>  		error = nospace_error;
>  	return error;
> -- 
> 2.25.1
> 
