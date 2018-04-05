Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeDEDgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Apr 2018 23:36:07 -0400
Date: Wed, 4 Apr 2018 20:36:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: scrub - remove unused function parameters
Message-ID: <20180405033601.GA7500@magnolia>
References: <b2b1aa4b-9ba9-eb4d-c91c-889a25fdd61e@redhat.com>
 <a8926c11-ea41-e021-9da0-4fb73f6baece@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8926c11-ea41-e021-9da0-4fb73f6baece@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 05:52:41PM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 018aabbd..4ad8877 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -105,8 +105,7 @@
>  /* Cross-reference with the other btrees. */
>  STATIC void
>  xfs_scrub_superblock_xref(
> -	struct xfs_scrub_context	*sc,
> -	struct xfs_buf			*bp)
> +	struct xfs_scrub_context	*sc)
>  {
>  	struct xfs_owner_info		oinfo;
>  	struct xfs_mount		*mp = sc->mp;
> @@ -420,7 +419,7 @@
>  			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
>  		xfs_scrub_block_set_corrupt(sc, bp);
>  
> -	xfs_scrub_superblock_xref(sc, bp);
> +	xfs_scrub_superblock_xref(sc);

Looks ok.

>  
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 127575f..b0d6720 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -64,7 +64,7 @@
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> -	return xfs_scrub_setup_inode_contents(sc, ip, 0);
> +	return xfs_scrub_setup_inode_contents(sc, ip);

This third parameter will be used by the repair patches, so let's keep
them.

>  }
>  
>  /* Extended Attributes */
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 639d14b..c4e85ac 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -75,7 +75,7 @@
>  	}
>  
>  	/* Got the inode, lock it and we're ready to go. */
> -	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> +	error = xfs_scrub_trans_alloc(mp, &sc->tp);

The sm parameter will be used by the repair series, leave this.

>  	if (error)
>  		goto out;
>  	sc->ilock_flags |= XFS_ILOCK_EXCL;
> @@ -684,7 +684,7 @@ struct xfs_scrub_bmap_check_rmap_info {
>  	info.lastoff = 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	for_each_xfs_iext(ifp, &icur, &irec) {
> -		if (xfs_scrub_should_terminate(sc, &error))
> +		if (xfs_scrub_should_terminate(&error))

Looks ok.

>  			break;
>  		if (isnullstartblock(irec.br_startblock))
>  			continue;
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 5421816..583a4b7 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -628,7 +628,7 @@ struct check_owner {
>  			error = bs.scrub_rec(&bs, recp);
>  			if (error)
>  				break;
> -			if (xfs_scrub_should_terminate(sc, &error) ||
> +			if (xfs_scrub_should_terminate(&error) ||
>  			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>  				break;
>  
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 8ed91d5..7067c94 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -356,7 +356,6 @@ struct xfs_scrub_rmap_ownedby_info {
>   */
>  int
>  xfs_scrub_count_rmap_ownedby_ag(
> -	struct xfs_scrub_context		*sc,

Looks ok.

So.... do you want to resubmit with only the cleanups that won't be
immediately put back in by the repair series?  Or just wait until I'm
done landing that part?  I prefer the second. :)

--D

>  	struct xfs_btree_cur			*cur,
>  	struct xfs_owner_info			*oinfo,
>  	xfs_filblks_t				*blocks)
> @@ -574,7 +573,7 @@ struct xfs_scrub_rmap_ownedby_info {
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_inode		*ip)
>  {
> -	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
> +	return xfs_scrub_trans_alloc(sc->mp, &sc->tp);
>  }
>  
>  /* Set us up with AG headers and btree cursors. */
> @@ -692,8 +691,7 @@ struct xfs_scrub_rmap_ownedby_info {
>  int
>  xfs_scrub_setup_inode_contents(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_inode		*ip,
> -	unsigned int			resblks)
> +	struct xfs_inode		*ip)
>  {
>  	struct xfs_mount		*mp = sc->mp;
>  	int				error;
> @@ -705,7 +703,7 @@ struct xfs_scrub_rmap_ownedby_info {
>  	/* Got the inode, lock it and we're ready to go. */
>  	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	xfs_ilock(sc->ip, sc->ilock_flags);
> -	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> +	error = xfs_scrub_trans_alloc(mp, &sc->tp);
>  	if (error)
>  		goto out;
>  	sc->ilock_flags |= XFS_ILOCK_EXCL;
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index deaf604..8b6b83d 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -27,7 +27,6 @@
>   */
>  static inline bool
>  xfs_scrub_should_terminate(
> -	struct xfs_scrub_context	*sc,
>  	int				*error)
>  {
>  	if (fatal_signal_pending(current)) {
> @@ -44,7 +43,6 @@
>   */
>  static inline int
>  xfs_scrub_trans_alloc(
> -	struct xfs_scrub_metadata	*sm,
>  	struct xfs_mount		*mp,
>  	struct xfs_trans		**tpp)
>  {
> @@ -145,8 +143,7 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
>  			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
>  				  void *),
>  			void *priv);
> -int xfs_scrub_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
> -				    struct xfs_btree_cur *cur,
> +int xfs_scrub_count_rmap_ownedby_ag(struct xfs_btree_cur *cur,
>  				    struct xfs_owner_info *oinfo,
>  				    xfs_filblks_t *blocks);
>  
> @@ -154,7 +151,7 @@ int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
>  			     struct xfs_inode *ip, bool force_log);
>  int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
>  int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
> -				   struct xfs_inode *ip, unsigned int resblks);
> +				   struct xfs_inode *ip);
>  void xfs_scrub_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
>  
>  #endif	/* __XFS_SCRUB_COMMON_H__ */
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index bffdb7d..db90c85 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -561,7 +561,7 @@
>  			error = scrub_fn(&ds, level, rec);
>  			if (error)
>  				break;
> -			if (xfs_scrub_should_terminate(sc, &error) ||
> +			if (xfs_scrub_should_terminate(&error) ||
>  			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>  				break;
>  
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 38f2980..01126aa 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -49,7 +49,7 @@
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_inode		*ip)
>  {
> -	return xfs_scrub_setup_inode_contents(sc, ip, 0);
> +	return xfs_scrub_setup_inode_contents(sc, ip);
>  }
>  
>  /* Directories */
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 106ca4b..26b67a3 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -157,7 +157,7 @@
>  	bool				inuse;
>  	int				error = 0;
>  
> -	if (xfs_scrub_should_terminate(bs->sc, &error))
> +	if (xfs_scrub_should_terminate(&error))
>  		return error;
>  
>  	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
> @@ -377,8 +377,7 @@
>   */
>  STATIC void
>  xfs_scrub_iallocbt_xref_rmap_btreeblks(
> -	struct xfs_scrub_context	*sc,
> -	int				which)
> +	struct xfs_scrub_context	*sc)
>  {
>  	struct xfs_owner_info		oinfo;
>  	xfs_filblks_t			blocks;
> @@ -402,7 +401,7 @@
>  	}
>  
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> -	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
> +	error = xfs_scrub_count_rmap_ownedby_ag(sc->sa.rmap_cur, &oinfo,
>  			&blocks);
>  	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
>  		return;
> @@ -417,7 +416,6 @@
>  STATIC void
>  xfs_scrub_iallocbt_xref_rmap_inodes(
>  	struct xfs_scrub_context	*sc,
> -	int				which,
>  	xfs_filblks_t			inode_blocks)
>  {
>  	struct xfs_owner_info		oinfo;
> @@ -429,7 +427,7 @@
>  
>  	/* Check that we saw as many inode blocks as the rmap knows about. */
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> -	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
> +	error = xfs_scrub_count_rmap_ownedby_ag(sc->sa.rmap_cur, &oinfo,
>  			&blocks);
>  	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
>  		return;
> @@ -455,7 +453,7 @@
>  	if (error)
>  		return error;
>  
> -	xfs_scrub_iallocbt_xref_rmap_btreeblks(sc, which);
> +	xfs_scrub_iallocbt_xref_rmap_btreeblks(sc);
>  
>  	/*
>  	 * If we're scrubbing the inode btree, inode_blocks is the number of
> @@ -465,7 +463,7 @@
>  	 * to inode chunks with free inodes.
>  	 */
>  	if (which == XFS_BTNUM_INO)
> -		xfs_scrub_iallocbt_xref_rmap_inodes(sc, which, inode_blocks);
> +		xfs_scrub_iallocbt_xref_rmap_inodes(sc, inode_blocks);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index df14930..481cbdb 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -68,7 +68,7 @@
>  		break;
>  	case -EFSCORRUPTED:
>  	case -EFSBADCRC:
> -		return xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> +		return xfs_scrub_trans_alloc(mp, &sc->tp);
>  	default:
>  		return error;
>  	}
> @@ -76,7 +76,7 @@
>  	/* Got the inode, lock it and we're ready to go. */
>  	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	xfs_ilock(sc->ip, sc->ilock_flags);
> -	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> +	error = xfs_scrub_trans_alloc(mp, &sc->tp);
>  	if (error)
>  		goto out;
>  	sc->ilock_flags |= XFS_ILOCK_EXCL;
> @@ -134,7 +134,6 @@
>  STATIC void
>  xfs_scrub_inode_flags(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_dinode		*dip,
>  	xfs_ino_t			ino,
>  	uint16_t			mode,
>  	uint16_t			flags)
> @@ -179,7 +178,6 @@
>  STATIC void
>  xfs_scrub_inode_flags2(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_dinode		*dip,
>  	xfs_ino_t			ino,
>  	uint16_t			mode,
>  	uint16_t			flags,
> @@ -372,7 +370,7 @@
>  			xfs_scrub_ino_set_corrupt(sc, ino);
>  	}
>  
> -	xfs_scrub_inode_flags(sc, dip, ino, mode, flags);
> +	xfs_scrub_inode_flags(sc, ino, mode, flags);
>  
>  	xfs_scrub_inode_extsize(sc, dip, ino, mode, flags);
>  
> @@ -428,7 +426,7 @@
>  	if (dip->di_version >= 3) {
>  		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
>  			xfs_scrub_ino_set_corrupt(sc, ino);
> -		xfs_scrub_inode_flags2(sc, dip, ino, mode, flags, flags2);
> +		xfs_scrub_inode_flags2(sc, ino, mode, flags, flags2);
>  		xfs_scrub_inode_cowextsize(sc, dip, ino, mode, flags,
>  				flags2);
>  	}
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 1fb88c1..03110eb 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -45,7 +45,7 @@
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_inode		*ip)
>  {
> -	return xfs_scrub_setup_inode_contents(sc, ip, 0);
> +	return xfs_scrub_setup_inode_contents(sc, ip);
>  }
>  
>  /* Parent pointers */
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 6ba465e..eda174f 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -224,7 +224,7 @@
>  	}
>  	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
>  	while (1) {
> -		if (xfs_scrub_should_terminate(sc, &error))
> +		if (xfs_scrub_should_terminate(&error))
>  			break;
>  
>  		off = irec.br_startoff + irec.br_blockcount;
> @@ -265,7 +265,7 @@
>  
>  	/* Check all the quota items. */
>  	while (id < ((xfs_dqid_t)-1ULL)) {
> -		if (xfs_scrub_should_terminate(sc, &error))
> +		if (xfs_scrub_should_terminate(&error))
>  			break;
>  
>  		error = xfs_qm_dqget(mp, NULL, id, dqtype, XFS_QMOPT_DQNEXT,
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 400f156..b8d12bb 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -124,7 +124,7 @@ struct xfs_scrub_refcnt_check {
>  	xfs_agblock_t			rc_last;
>  	int				error = 0;
>  
> -	if (xfs_scrub_should_terminate(refchk->sc, &error))
> +	if (xfs_scrub_should_terminate(&error))
>  		return error;
>  
>  	rm_last = rec->rm_startblock + rec->rm_blockcount - 1;
> @@ -411,7 +411,7 @@ struct xfs_scrub_refcnt_check {
>  	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
>  	if (!xfs_scrub_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
>  		return;
> -	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
> +	error = xfs_scrub_count_rmap_ownedby_ag(sc->sa.rmap_cur, oinfo,
>  			&blocks);
>  	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
>  		return;
> @@ -420,7 +420,7 @@ struct xfs_scrub_refcnt_check {
>  
>  	/* Check that we saw as many cow blocks as the rmap knows about. */
>  	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_COW);
> -	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
> +	error = xfs_scrub_count_rmap_ownedby_ag(sc->sa.rmap_cur, oinfo,
>  			&blocks);
>  	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
>  		return;
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 26c7596..46e7bf1 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -138,7 +138,7 @@
>  {
>  	int				error = 0;
>  
> -	if (xfs_scrub_should_terminate(sc, &error))
> +	if (xfs_scrub_should_terminate(&error))
>  		return error;
>  
>  	return 0;
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 3aa3d60..7af7981 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -48,7 +48,7 @@
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> -	return xfs_scrub_setup_inode_contents(sc, ip, 0);
> +	return xfs_scrub_setup_inode_contents(sc, ip);
>  }
>  
>  /* Symbolic links. */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
