Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884B9C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 12:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D5F322A84
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 12:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgLDMdL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 07:33:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728006AbgLDMdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 07:33:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607085102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dsLEv0+WDVYIuvCyadUVvJmRVAroY/Ju0kLYhRJkEv8=;
        b=IqUXhecH95ZrE5P+lxOYdZgdUXyDF3WpiAVgNrKHwzHLqGw7cxrxWVT2LMsrsypm92lA0F
        Nb/zbEmScby+sbLEbEQy9fFPqJ3pKUnosjmqhkH4x/6oP5iYUoLr3J5RCC66mGwsDOFLjV
        FMJYy40kgCqXfZK1rglc/5630kguXX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-iEM6M9JbNwqffimvR9ur4g-1; Fri, 04 Dec 2020 07:31:40 -0500
X-MC-Unique: iEM6M9JbNwqffimvR9ur4g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4E44809DC3;
        Fri,  4 Dec 2020 12:31:39 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6622C5C1D5;
        Fri,  4 Dec 2020 12:31:39 +0000 (UTC)
Date:   Fri, 4 Dec 2020 07:31:37 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201204123137.GA1404170@bfoster>
References: <20201202232724.1730114-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202232724.1730114-1-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 10:27:24AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we allocate a new inode, we often need to add an attribute to
> the inode as part of the create. This can happen as a result of
> needing to add default ACLs or security labels before the inode is
> made visible to userspace.
> 
> This is highly inefficient right now. We do the create transaction
> to allocate the inode, then we do an "add attr fork" transaction to
> modify the just created empty inode to set the inode fork offset to
> allow attributes to be stored, then we go and do the attribute
> creation.
> 
> This means 3 transactions instead of 1 to allocate an inode, and
> this greatly increases the load on the CIL commit code, resulting in
> excessive contention on the CIL spin locks and performance
> degradation:
> 
>  18.99%  [kernel]                [k] __pv_queued_spin_lock_slowpath
>   3.57%  [kernel]                [k] do_raw_spin_lock
>   2.51%  [kernel]                [k] __raw_callee_save___pv_queued_spin_unlock
>   2.48%  [kernel]                [k] memcpy
>   2.34%  [kernel]                [k] xfs_log_commit_cil
> 
> The typical profile resulting from running fsmark on a selinux enabled
> filesytem is adds this overhead to the create path:
> 
...
> 
> And fsmark creation rate performance drops by ~25%. The key point to
> note here is that half the additional overhead comes from adding the
> attribute fork to the newly created inode. That's crazy, considering
> we can do this same thing at inode create time with a couple of
> lines of code and no extra overhead.
> 
> So, if we know we are going to add an attribute immediately after
> creating the inode, let's just initialise the attribute fork inside
> the create transaction and chop that whole chunk of code out of
> the create fast path. This completely removes the performance
> drop caused by enabling SELinux, and the profile looks like:
> 
...
> 
> Which indicates the XFS overhead of creating the selinux xattr has
> been halved. This doesn't fix the CIL lock contention problem, just
> means it's not a limiting factor for this workload. Lock contention
> in the security subsystems is going to be an issue soon, though...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 20 +++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.h |  1 +
>  fs/xfs/xfs_inode.c             | 24 ++++++++++++++++++++----
>  fs/xfs/xfs_inode.h             |  5 +++--
>  fs/xfs/xfs_iops.c              | 10 +++++++++-
>  fs/xfs/xfs_qm.c                |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  7 files changed, 50 insertions(+), 14 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..9ee2e0b4c6fd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
...
> @@ -918,6 +919,18 @@ xfs_ialloc(
>  		ASSERT(0);
>  	}
>  
> +	/*
> +	 * If we need to create attributes immediately after allocating the
> +	 * inode, initialise an empty attribute fork right now. We use the
> +	 * default fork offset for attributes here as we don't know exactly what
> +	 * size or how many attributes we might be adding. We can do this safely
> +	 * here because we know the data fork is completely empty right now.
> +	 */
> +	if (init_attrs) {
> +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> +		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +	}
> +

Seems reasonable in principle, but why not refactor
xfs_bmap_add_attrfork() such that the internals (i.e. everything within
the transaction/ilock code) can be properly reused in both contexts
rather than open-coding (and thus duplicating) a somewhat stripped down
version? At a glance, it looks like there are some subtle differences in
the initial setup of the attr fork for a device node inode, for example.

Brian

>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> @@ -951,6 +964,7 @@ xfs_dir_ialloc(
>  	xfs_nlink_t	nlink,
>  	dev_t		rdev,
>  	prid_t		prid,		/* project id */
> +	bool		init_attrs,
>  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
>  					   locked. */
>  {
> @@ -980,7 +994,7 @@ xfs_dir_ialloc(
>  	 * the inode(s) that we've just allocated.
>  	 */
>  	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
> -			&ip);
> +			init_attrs, &ip);
>  
>  	/*
>  	 * Return an error if we were unable to allocate a new inode.
> @@ -1050,7 +1064,7 @@ xfs_dir_ialloc(
>  		 * this call should always succeed.
>  		 */
>  		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
> -				  &ialloc_context, &ip);
> +				  &ialloc_context, init_attrs, &ip);
>  
>  		/*
>  		 * If we get an error at this point, return to the caller
> @@ -1112,6 +1126,7 @@ xfs_create(
>  	struct xfs_name		*name,
>  	umode_t			mode,
>  	dev_t			rdev,
> +	bool			init_attrs,
>  	xfs_inode_t		**ipp)
>  {
>  	int			is_dir = S_ISDIR(mode);
> @@ -1182,7 +1197,8 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid,
> +				init_attrs, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1304,7 +1320,7 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 751a3d1d7d84..670dfab334de 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -370,7 +370,8 @@ void		xfs_inactive(struct xfs_inode *ip);
>  int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode **ipp, struct xfs_name *ci_name);
>  int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
> -			   umode_t mode, dev_t rdev, struct xfs_inode **ipp);
> +			   umode_t mode, dev_t rdev, bool need_xattr,
> +			   struct xfs_inode **ipp);
>  int		xfs_create_tmpfile(struct xfs_inode *dp, umode_t mode,
>  			   struct xfs_inode **ipp);
>  int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
> @@ -408,7 +409,7 @@ xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
>  xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>  
>  int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
> -			       xfs_nlink_t, dev_t, prid_t,
> +			       xfs_nlink_t, dev_t, prid_t, bool need_xattr,
>  			       struct xfs_inode **);
>  
>  static inline int
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1414ab79eacf..75b44b82ad1f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -126,6 +126,7 @@ xfs_cleanup_inode(
>  	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
>  }
>  
> +
>  STATIC int
>  xfs_generic_create(
>  	struct inode	*dir,
> @@ -161,7 +162,14 @@ xfs_generic_create(
>  		goto out_free_acl;
>  
>  	if (!tmpfile) {
> -		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
> +		bool need_xattr = false;
> +
> +		if ((IS_ENABLED(CONFIG_SECURITY) && dir->i_sb->s_security) ||
> +		    default_acl || acl)
> +			need_xattr = true;
> +
> +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> +					need_xattr, &ip);
>  	} else {
>  		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);
>  	}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b2a9abee8b2b..45faddfb4234 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -787,7 +787,7 @@ xfs_qm_qino_alloc(
>  		return error;
>  
>  	if (need_alloc) {
> -		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
> +		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, false, ip);
>  		if (error) {
>  			xfs_trans_cancel(tp);
>  			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8e88a7ca387e..20919aaea981 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -224,7 +224,7 @@ xfs_symlink(
>  	 * Allocate an inode for the symlink.
>  	 */
>  	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
> -			       prid, &ip);
> +			       prid, false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.28.0
> 

