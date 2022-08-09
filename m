Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8772C25B08
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 19:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbiHITHY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345764AbiHITGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 15:06:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5F95591
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 11:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8095DB81722
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 18:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0855AC433D6;
        Tue,  9 Aug 2022 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660070719;
        bh=dHLpdIzBP7cflSsoXIR0o2GzG5dSl0Sq2HK7x8Gwug0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tl2leLfHION1BZYI0fw/0VrLRmOZZtqnBm6vjAGd5h3lzMkvw26hpnaozglMHX9IM
         hyy22PPkmKbpJp5Eyw6Izkz6eA5AZc5mg68u5qXctIKPsMcYNZnYwAiXaO0pXhdYnR
         H7m8Beht18GiNahhi50rPWksiZB4/jWXvQS3j8omMr/slW/AGU6ayUqJTORhKjvlOE
         TG7LVMOVSubWVtB5OeFN9vnmHXJrvsqLc4pihDGZnpHtALxb1TbTFsoc42FLTqX3t9
         6PQF1Um3FsmjrymR0qHHN6u4mT965AgNjuenF9kfy/9tGRwTrZzaWEETZQ7twBf4Ru
         6+E1A5/gHAzHw==
Date:   Tue, 9 Aug 2022 11:45:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 14/18] xfs: remove parent pointers in unlink
Message-ID: <YvKrPl+SHzKtFNaq@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-15-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:09PM -0700, Allison Henderson wrote:
> This patch removes the parent pointer attribute during unlink
> 
> [bfoster: rebase, use VFS inode generation]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
>            implemented xfs_attr_remove_parent]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c   |  2 +-
>  fs/xfs/libxfs/xfs_attr.h   |  1 +
>  fs/xfs/libxfs/xfs_parent.c | 15 +++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  3 +++
>  fs/xfs/xfs_inode.c         | 29 +++++++++++++++++++++++------
>  5 files changed, 43 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0a458ea7051f..77513ff7e1ec 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -936,7 +936,7 @@ xfs_attr_defer_replace(
>  }
>  
>  /* Removes an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_remove(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index b47417b5172f..2e11e5e83941 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_defer_add(struct xfs_da_args *args);
> +int xfs_attr_defer_remove(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 4ab531c77d7d..03f03f731d02 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -123,6 +123,21 @@ xfs_parent_defer_add(
>  	return xfs_attr_defer_add(args);
>  }
>  
> +int
> +xfs_parent_defer_remove(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_parent_defer	*parent,
> +	xfs_dir2_dataptr_t	diroffset)

Same suggestion about setting args->dp here instead of in
xfs_parent_init.

> +{
> +	struct xfs_da_args	*args = &parent->args;
> +
> +	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
> +	args->trans = tp;
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	return xfs_attr_defer_remove(args);
> +}
> +
>  void
>  xfs_parent_cancel(
>  	xfs_mount_t		*mp,
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 21a350b97ed5..67948f4b3834 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -29,6 +29,9 @@ int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
>  int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode *ip,
>  			 struct xfs_parent_defer *parent,
>  			 xfs_dir2_dataptr_t diroffset);
> +int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *ip,
> +			    struct xfs_parent_defer *parent,
> +			    xfs_dir2_dataptr_t diroffset);
>  void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
>  
>  #endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6e5deb0d42c4..69bb67f2a252 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2464,16 +2464,18 @@ xfs_iunpin_wait(
>   */
>  int
>  xfs_remove(
> -	xfs_inode_t             *dp,
> +	struct xfs_inode	*dp,
>  	struct xfs_name		*name,
> -	xfs_inode_t		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	xfs_mount_t		*mp = dp->i_mount;
> -	xfs_trans_t             *tp = NULL;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_trans	*tp = NULL;
>  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
>  	int			dontcare;
>  	int                     error = 0;
>  	uint			resblks;
> +	xfs_dir2_dataptr_t	dir_offset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_remove(dp, name);
>  
> @@ -2488,6 +2490,12 @@ xfs_remove(
>  	if (error)
>  		goto std_return;
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, ip, NULL, &parent);
> +		if (error)
> +			goto std_return;
> +	}
> +
>  	/*
>  	 * We try to get the real space reservation first, allowing for
>  	 * directory btree deletion(s) implying possible bmap insert(s).  If we
> @@ -2504,7 +2512,7 @@ xfs_remove(
>  			&tp, &dontcare);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
> -		goto std_return;
> +		goto drop_incompat;
>  	}
>  
>  	/*
> @@ -2558,12 +2566,18 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
> +	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
>  	if (error) {
>  		ASSERT(error != -ENOENT);
>  		goto out_trans_cancel;
>  	}
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset);

If it's safe to gate xfs_parent_cancel on "if (parent)" then can we
avoid the atomic bit access by doing that here too?

Otherwise looks good here.

--D

> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * remove transaction goes to disk before returning to
> @@ -2588,6 +2602,9 @@ xfs_remove(
>   out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> + drop_incompat:
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
>   std_return:
>  	return error;
>  }
> -- 
> 2.25.1
> 
