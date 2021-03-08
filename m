Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED47CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 22:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B206523D
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 22:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHWVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhCHWUq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 17:20:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C4D06523D;
        Mon,  8 Mar 2021 22:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615242046;
        bh=1muGmnAQH1uIVNMXdV4Q1DI5D3095pwW/W+9QO+BtLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZN6XvaIPzInBY+Rb/GTanPWve9rYJxnJ33ZDEq2Uqss7dgL5yHYzfENRh6X84ttR1
         3Sj0vyAb2ipRxWEOE7GY6LWcC7FJofypd/Veo7SPvHkSf6jBFVIbzScPvLjBGj8w51
         uC2lAFa4W8/FKnlNzS66dSi0RiHlkU1SfQCQO7ZhJjPCzm4cUwM7GsPg96d1RVQP7l
         +PnS6ukVt/lJmcdTCHwdy00QUQF+eYVGcv/IhmeDnFQByYq3i3z98NS8hjpUOL6qcF
         B0kGNiJXPJKO7lMRyZ8h531Wpg1B+E47qh1YRX7uU3oGGE2rupZ4fcx4ZoD5cW23wJ
         8qXwovWMtBXYg==
Date:   Mon, 8 Mar 2021 14:20:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/45] xfs: initialise attr fork on inode create
Message-ID: <20210308222044.GY3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:10:59PM +1100, Dave Chinner wrote:
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

Looks good to me now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 20 +++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  fs/xfs/xfs_inode.c             | 24 +++++++++++++++++++++---
>  fs/xfs/xfs_inode.h             |  6 ++++--
>  fs/xfs/xfs_iops.c              | 34 +++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_qm.c                |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  8 files changed, 81 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e0905ad171f0..5574d345d066 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1027,7 +1027,9 @@ xfs_bmap_add_attrfork_local(
>  	return -EFSCORRUPTED;
>  }
>  
> -/* Set an inode attr fork off based on the format */
> +/*
> + * Set an inode attr fork offset based on the format of the data fork.
> + */
>  int
>  xfs_bmap_set_attrforkoff(
>  	struct xfs_inode	*ip,
> @@ -1092,10 +1094,7 @@ xfs_bmap_add_attrfork(
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
> index 46a861d55e48..bed2beb169e4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -774,6 +774,7 @@ xfs_init_new_inode(
>  	xfs_nlink_t		nlink,
>  	dev_t			rdev,
>  	prid_t			prid,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct inode		*dir = pip ? VFS_I(pip) : NULL;
> @@ -877,6 +878,20 @@ xfs_init_new_inode(
>  		ASSERT(0);
>  	}
>  
> +	/*
> +	 * If we need to create attributes immediately after allocating the
> +	 * inode, initialise an empty attribute fork right now. We use the
> +	 * default fork offset for attributes here as we don't know exactly what
> +	 * size or how many attributes we might be adding. We can do this
> +	 * safely here because we know the data fork is completely empty and
> +	 * this saves us from needing to run a separate transaction to set the
> +	 * fork offset in the immediate future.
> +	 */
> +	if (init_xattrs) {
> +		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> +	}
> +
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> @@ -910,6 +925,7 @@ xfs_dir_ialloc(
>  	xfs_nlink_t		nlink,
>  	dev_t			rdev,
>  	prid_t			prid,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct xfs_buf		*agibp;
> @@ -937,7 +953,7 @@ xfs_dir_ialloc(
>  	ASSERT(ino != NULLFSINO);
>  
>  	return xfs_init_new_inode(mnt_userns, *tpp, dp, ino, mode, nlink, rdev,
> -				  prid, ipp);
> +				  prid, init_xattrs, ipp);
>  }
>  
>  /*
> @@ -982,6 +998,7 @@ xfs_create(
>  	struct xfs_name		*name,
>  	umode_t			mode,
>  	dev_t			rdev,
> +	bool			init_xattrs,
>  	xfs_inode_t		**ipp)
>  {
>  	int			is_dir = S_ISDIR(mode);
> @@ -1052,7 +1069,7 @@ xfs_create(
>  	 * pointing to itself.
>  	 */
>  	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, is_dir ? 2 : 1, rdev,
> -			       prid, &ip);
> +			       prid, init_xattrs, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1171,7 +1188,8 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_release_dquots;
>  
> -	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, 0, 0, prid, &ip);
> +	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, 0, 0, prid,
> +				false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 88ee4c3930ae..a2cacdb76d55 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -371,7 +371,8 @@ int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode **ipp, struct xfs_name *ci_name);
>  int		xfs_create(struct user_namespace *mnt_userns,
>  			   struct xfs_inode *dp, struct xfs_name *name,
> -			   umode_t mode, dev_t rdev, struct xfs_inode **ipp);
> +			   umode_t mode, dev_t rdev, bool need_xattr,
> +			   struct xfs_inode **ipp);
>  int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
>  			   struct xfs_inode *dp, umode_t mode,
>  			   struct xfs_inode **ipp);
> @@ -413,7 +414,8 @@ xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>  int		xfs_dir_ialloc(struct user_namespace *mnt_userns,
>  			       struct xfs_trans **tpp, struct xfs_inode *dp,
>  			       umode_t mode, xfs_nlink_t nlink, dev_t dev,
> -			       prid_t prid, struct xfs_inode **ipp);
> +			       prid_t prid, bool need_xattr,
> +			       struct xfs_inode **ipp);
>  
>  static inline int
>  xfs_itruncate_extents(
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 66ebccb5a6ff..a9d466b78646 100644
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
>  	struct user_namespace	*mnt_userns,
> @@ -163,7 +194,8 @@ xfs_generic_create(
>  
>  	if (!tmpfile) {
>  		error = xfs_create(mnt_userns, XFS_I(dir), &name, mode, rdev,
> -				   &ip);
> +				xfs_create_need_xattr(dir, default_acl, acl),
> +				&ip);
>  	} else {
>  		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
>  	}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index bfa4164990b1..6fde318b9fed 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -788,7 +788,7 @@ xfs_qm_qino_alloc(
>  
>  	if (need_alloc) {
>  		error = xfs_dir_ialloc(&init_user_ns, &tp, NULL, S_IFREG, 1, 0,
> -				       0, ipp);
> +				       0, false, ipp);
>  		if (error) {
>  			xfs_trans_cancel(tp);
>  			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1379013d74b8..162cf69bd982 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -223,7 +223,7 @@ xfs_symlink(
>  	 * Allocate an inode for the symlink.
>  	 */
>  	error = xfs_dir_ialloc(mnt_userns, &tp, dp, S_IFLNK | (mode & ~S_IFMT),
> -			       1, 0, prid, &ip);
> +			       1, 0, prid, false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.28.0
> 
