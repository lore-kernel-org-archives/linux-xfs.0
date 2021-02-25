Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8E9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 23:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0BA564F06
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 23:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBYXWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 18:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBYXWf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 18:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7BDB64EDB;
        Thu, 25 Feb 2021 23:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614295313;
        bh=6fUGIRu5wtBz3TbhYCmcyv7QQmOg8VfXDtqxOiU1zjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oG0sekT2wZjWJLf1cMv29QakLDMl0ApZvBHkAWWcbPiq/nwE/ij9BM2Ab6QoMiL+O
         YAAE7fEkgDKh9zhiC8JvNjlPp2WuWfcIDlSFri9kQhuVbNcx7RsGqiegHN+S2vOw/o
         /eZIFwfAiIzyb4Fe+5l0gS70fpqVJid15Dj5m53Ni8Xp8T4fswAPiU41bgxIdBMdD7
         wo/w4PrmHQVDPqsrKTbYEjBXkhDDecxk5ld+n2Pi474+cFx66OGf4SYN7BZhcZhIiO
         W0mDuB58z5qAsEkzGOd1TuuYtMPGbaFmHfFi2IFVyn7/QoRWJJbQQBud/EjH1ftPFU
         +2xntHwmO8ZYg==
Date:   Thu, 25 Feb 2021 15:21:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: initialise attr fork on inode create
Message-ID: <20210225232153.GM7272@magnolia>
References: <20210222230556.GR4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222230556.GR4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 10:05:56AM +1100, Dave Chinner wrote:
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
>   - 15.30% xfs_init_security
>      - 15.23% security_inode_init_security
> 	- 13.05% xfs_initxattrs
> 	   - 12.94% xfs_attr_set
> 	      - 6.75% xfs_bmap_add_attrfork
> 		 - 5.51% xfs_trans_commit
> 		    - 5.48% __xfs_trans_commit
> 		       - 5.35% xfs_log_commit_cil
> 			  - 3.86% _raw_spin_lock
> 			     - do_raw_spin_lock
> 				  __pv_queued_spin_lock_slowpath
> 		 - 0.70% xfs_trans_alloc
> 		      0.52% xfs_trans_reserve
> 	      - 5.41% xfs_attr_set_args
> 		 - 5.39% xfs_attr_set_shortform.constprop.0
> 		    - 4.46% xfs_trans_commit
> 		       - 4.46% __xfs_trans_commit
> 			  - 4.33% xfs_log_commit_cil
> 			     - 2.74% _raw_spin_lock
> 				- do_raw_spin_lock
> 				     __pv_queued_spin_lock_slowpath
> 			       0.60% xfs_inode_item_format
> 		      0.90% xfs_attr_try_sf_addname
> 	- 1.99% selinux_inode_init_security
> 	   - 1.02% security_sid_to_context_force
> 	      - 1.00% security_sid_to_context_core
> 		 - 0.92% sidtab_entry_to_string
> 		    - 0.90% sidtab_sid2str_get
> 			 0.59% sidtab_sid2str_put.part.0
> 	   - 0.82% selinux_determine_inode_label
> 	      - 0.77% security_transition_sid
> 		   0.70% security_compute_sid.part.0
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
>      - 8.99% xfs_init_security
>          - 9.00% security_inode_init_security
>             - 6.43% xfs_initxattrs
>                - 6.37% xfs_attr_set
>                   - 5.45% xfs_attr_set_args
>                      - 5.42% xfs_attr_set_shortform.constprop.0
>                         - 4.51% xfs_trans_commit
>                            - 4.54% __xfs_trans_commit
>                               - 4.59% xfs_log_commit_cil
>                                  - 2.67% _raw_spin_lock
>                                     - 3.28% do_raw_spin_lock
>                                          3.08% __pv_queued_spin_lock_slowpath
>                                    0.66% xfs_inode_item_format
>                         - 0.90% xfs_attr_try_sf_addname
>                   - 0.60% xfs_trans_alloc
>             - 2.35% selinux_inode_init_security
>                - 1.25% security_sid_to_context_force
>                   - 1.21% security_sid_to_context_core
>                      - 1.19% sidtab_entry_to_string
>                         - 1.20% sidtab_sid2str_get
>                            - 0.86% sidtab_sid2str_put.part.0
>                               - 0.62% _raw_spin_lock_irqsave
>                                  - 0.77% do_raw_spin_lock
>                                       __pv_queued_spin_lock_slowpath
>                - 0.84% selinux_determine_inode_label
>                   - 0.83% security_transition_sid
>                        0.86% security_compute_sid.part.0
> 
> Which indicates the XFS overhead of creating the selinux xattr has
> been halved. This doesn't fix the CIL lock contention problem, just
> means it's not a limiting factor for this workload. Lock contention
> in the security subsystems is going to be an issue soon, though...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - extend use of xfs_ifork_alloc() helper
> - formalise "size == 0" behaviour of xfs_bmap_set_attrforkoff() to
>   mean "use default offset"
> - use xfs_bmap_set_attrforkoff() from xfs_init_new_inode()
> - add xfs_create_need_xattr() helper function to decide if we should
>   init the attr fork during create and document why we are peaking
>   at superblock security gubbins to make that decision.
> 
>  fs/xfs/libxfs/xfs_bmap.c       | 19 ++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 20 +++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  fs/xfs/xfs_inode.c             | 23 ++++++++++++++++++++---
>  fs/xfs/xfs_inode.h             |  5 +++--
>  fs/xfs/xfs_iops.c              | 35 ++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_qm.c                |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  8 files changed, 90 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e0905ad171f0..f7bcb0dfa15f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1027,7 +1027,14 @@ xfs_bmap_add_attrfork_local(
>  	return -EFSCORRUPTED;
>  }
>  
> -/* Set an inode attr fork off based on the format */
> +/*
> + * Set an inode attr fork offset based on the format of the data fork.
> + *
> + * If a size of zero is passed in, then caller does not know the size of
> + * the attribute that might be added (i.e. pre-emptive attr fork creation).
> + * Hence in this case just set the fork offset to the default so that we don't
> + * need to modify the supported attr format in the superblock.

Urk.  Echoing what I said in my other reply... this function is for
callers that already know what size they want for an xattr.  Having a
parameter with a magic value for the one caller that doesn't know makes
this function harder to figure out.

> + */
>  int
>  xfs_bmap_set_attrforkoff(
>  	struct xfs_inode	*ip,
> @@ -1041,6 +1048,11 @@ xfs_bmap_set_attrforkoff(
>  	case XFS_DINODE_FMT_LOCAL:
>  	case XFS_DINODE_FMT_EXTENTS:
>  	case XFS_DINODE_FMT_BTREE:
> +		if (size == 0) {
> +			ASSERT(!version);
> +			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +			break;
> +		}
>  		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>  		if (!ip->i_d.di_forkoff)
>  			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> @@ -1092,10 +1104,7 @@ xfs_bmap_add_attrfork(
>  		goto trans_cancel;
>  	ASSERT(ip->i_afp == NULL);
>  
> -	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone,
> -				      GFP_KERNEL | __GFP_NOFAIL);
> -
> -	ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> +	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
>  	ip->i_afp->if_flags = XFS_IFEXTENTS;
>  	logflags = 0;
>  	switch (ip->i_df.if_format) {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index e080d7e07643..c606c1a77e5a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -282,6 +282,19 @@ xfs_dfork_attr_shortform_size(
>  	return be16_to_cpu(atp->hdr.totsize);
>  }
>  
> +struct xfs_ifork *
> +xfs_ifork_alloc(
> +	enum xfs_dinode_fmt	format,
> +	xfs_extnum_t		nextents)
> +{
> +	struct xfs_ifork	*ifp;
> +
> +	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> +	ifp->if_format = format;
> +	ifp->if_nextents = nextents;
> +	return ifp;
> +}
> +
>  int
>  xfs_iformat_attr_fork(
>  	struct xfs_inode	*ip,
> @@ -293,11 +306,8 @@ xfs_iformat_attr_fork(
>  	 * Initialize the extent count early, as the per-format routines may
>  	 * depend on it.
>  	 */
> -	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> -	ip->i_afp->if_format = dip->di_aformat;
> -	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> -		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
> +				be16_to_cpu(dip->di_anextents));
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 9e2137cd7372..a0717ab0e5c5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -141,6 +141,8 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> +struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
> +				xfs_extnum_t nextents);
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
>  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 636ac13b1df2..95e3a5e6e5e2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -773,6 +773,7 @@ xfs_init_new_inode(
>  	xfs_nlink_t		nlink,
>  	dev_t			rdev,
>  	prid_t			prid,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct inode		*dir = pip ? VFS_I(pip) : NULL;
> @@ -875,6 +876,18 @@ xfs_init_new_inode(
>  		ASSERT(0);
>  	}
>  
> +	/*
> +	 * If we need to create attributes immediately after allocating the
> +	 * inode, initialise an empty attribute fork right now. We use the
> +	 * default fork offset for attributes here as we don't know exactly what
> +	 * size or how many attributes we might be adding. We can do this safely
> +	 * here because we know the data fork is completely empty right now.

Might be worth mentioning that we're doing this to save a transaction.

> +	 */
> +	if (init_xattrs) {
> +		xfs_bmap_set_attrforkoff(ip, 0, NULL);
> +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> +	}
> +
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> @@ -907,6 +920,7 @@ xfs_dir_ialloc(
>  	xfs_nlink_t		nlink,
>  	dev_t			rdev,
>  	prid_t			prid,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct xfs_buf		*agibp;
> @@ -933,7 +947,8 @@ xfs_dir_ialloc(
>  		return error;
>  	ASSERT(ino != NULLFSINO);
>  
> -	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid, ipp);
> +	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid,
> +					init_xattrs, ipp);
>  }
>  
>  /*
> @@ -977,6 +992,7 @@ xfs_create(
>  	struct xfs_name		*name,
>  	umode_t			mode,
>  	dev_t			rdev,
> +	bool			init_xattrs,
>  	xfs_inode_t		**ipp)
>  {
>  	int			is_dir = S_ISDIR(mode);
> @@ -1046,7 +1062,8 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid,
> +				init_xattrs, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1164,7 +1181,7 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_release_dquots;
>  
> -	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index eca333f5f715..4d3caff2a24a 100644
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
>  int xfs_dir_ialloc(struct xfs_trans **tpp, struct xfs_inode *dp, umode_t mode,
> -		   xfs_nlink_t nlink, dev_t dev, prid_t prid,
> +		   xfs_nlink_t nlink, dev_t dev, prid_t prid, bool need_xattr,
>  		   struct xfs_inode **ipp);
>  
>  static inline int
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 00369502fe25..5984760e8a64 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -126,6 +126,37 @@ xfs_cleanup_inode(
>  	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
>  }
>  
> +/*
> + * Check to see if we are likely to need an extended attribute to be added to
> + * the inode we are about to allocate. This allows the attribute fork to be
> + * created during the inode allocation, reducing the number of transactions we
> + * need to do in this fast path.
> + *
> + * The security checks are optimistic, but not guaranteed. The two LSMs that
> + * require xattrs to be added here (selinux and smack) are also the only two
> + * LSMs that add a sb->s_security structure to the superblock. Hence if security
> + * is enabled and sb->s_security is set, we have a pretty good idea that we are
> + * going to be asked to add a security xattr immediately after allocating the
> + * xfs inode and instantiating the VFS inode.
> + */
> +static inline bool
> +xfs_create_need_xattr(
> +	struct inode	*dir,
> +	struct posix_acl *default_acl,
> +	struct posix_acl *acl)
> +{
> +	if (acl)
> +		return true;
> +	if (default_acl)
> +		return true;
> +	if (!IS_ENABLED(CONFIG_SECURITY))
> +		return false;
> +	if (dir->i_sb->s_security)
> +		return true;
> +	return false;
> +}
> +
> +
>  STATIC int
>  xfs_generic_create(
>  	struct inode	*dir,
> @@ -161,7 +192,9 @@ xfs_generic_create(
>  		goto out_free_acl;
>  
>  	if (!tmpfile) {
> -		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
> +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> +				xfs_create_need_xattr(dir, default_acl, acl),
> +				&ip);
>  	} else {
>  		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);

Same question as last time: Do selinux or smack want to set xattr-based
security labels on tempfiles too?

--D

>  	}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 742d1413e2d0..262ea047cb4f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -787,7 +787,7 @@ xfs_qm_qino_alloc(
>  		return error;
>  
>  	if (need_alloc) {
> -		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ipp);
> +		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, false, ipp);
>  		if (error) {
>  			xfs_trans_cancel(tp);
>  			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8565663b16cd..ab42f6e0d26e 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -222,7 +222,7 @@ xfs_symlink(
>  	 * Allocate an inode for the symlink.
>  	 */
>  	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
> -			       prid, &ip);
> +			       prid, false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
