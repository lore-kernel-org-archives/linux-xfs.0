Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC36C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0317D2388C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLGRPh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:15:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39022 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgLGRPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:15:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7H5PqE066890;
        Mon, 7 Dec 2020 17:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7IjstZBPj5JDI6vlc8sd33+DEbBA3h6kezZQCbGhsOI=;
 b=lItf4T+8lDJzi0QMh0ZmBszby6sKsemkQKEh4qklqwl+gnPQKUZ0kqxuVcPx9T+iqa89
 vypBsXStflq0Bbpf7BDFFCk6dZnKgQPZp3nHPtNTBvF1u4wVb7ZRae3QJYcLvWpUc/gx
 Wa7qbxS021SzXDrgpWFrOqDLU775fXMWw2BVPrOvklIx0C3qBshxLNNdJz5XZ+wKurT2
 9XRPGyXyCxsp/LFrXZM1Y6YCKuxnotL5nuvJO1AyXCT1KgsMTiOSZSQfgE2o/kZAN/3F
 /+azP6SVbPyYFGOiZ34XyNQJO6Kpk18TQlcoaAOlBKbUeKJoZ9U92uZ0ojWXZXV74RyK aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqbpms8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 17:14:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7H4iJP162893;
        Mon, 7 Dec 2020 17:12:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 358ksmf52j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 17:12:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7HCoD5022703;
        Mon, 7 Dec 2020 17:12:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 09:12:48 -0800
Date:   Mon, 7 Dec 2020 09:12:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207171247.GP629293@magnolia>
References: <20201202232724.1730114-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202232724.1730114-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070110
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
>  fs/xfs/libxfs/xfs_inode_fork.c | 20 +++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.h |  1 +
>  fs/xfs/xfs_inode.c             | 24 ++++++++++++++++++++----
>  fs/xfs/xfs_inode.h             |  5 +++--
>  fs/xfs/xfs_iops.c              | 10 +++++++++-
>  fs/xfs/xfs_qm.c                |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  7 files changed, 50 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7575de5cecb1..5d5b466bd787 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -280,6 +280,19 @@ xfs_dfork_attr_shortform_size(
>  	return be16_to_cpu(atp->hdr.totsize);
>  }
>  
> +struct xfs_ifork *
> +xfs_ifork_alloc(
> +	int8_t			format,

enum xfs_dinode_fmt	format, ?

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
> @@ -291,11 +304,8 @@ xfs_iformat_attr_fork(
>  	 * Initialize the extent count early, as the per-format routines may
>  	 * depend on it.
>  	 */
> -	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> -	ip->i_afp->if_format = dip->di_aformat;
> -	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> -		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;

Can we still mount an irix 6.1 filesystem?  I would guess not, but
removing old cruft is a separate patch.  Granted you did say RFC...

> -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
> +				be16_to_cpu(dip->di_anextents));
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index a4953e95c4f3..3ad088c6a9d2 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -80,6 +80,7 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> +struct xfs_ifork *xfs_ifork_alloc(int8_t format, xfs_extnum_t nextents);
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
>  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..9ee2e0b4c6fd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -800,6 +800,7 @@ xfs_ialloc(
>  	dev_t		rdev,
>  	prid_t		prid,
>  	xfs_buf_t	**ialloc_context,
> +	bool		init_attrs,

init_xattrs ?  Just to distinguish them from regular file attrs like
mode/size/owner/etc.

>  	xfs_inode_t	**ipp)
>  {
>  	struct xfs_mount *mp = tp->t_mountp;
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

This should be a separate predicate in case the logic gets more twisty
later.

> +
> +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> +					need_xattr, &ip);
>  	} else {
>  		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);

/me bets O_TMPFILE files can have xattr-based security labels applied to
them too, right?

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
