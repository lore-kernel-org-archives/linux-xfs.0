Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdF0Kd4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 06:33:56 -0400
Date: Tue, 27 Jun 2017 12:33:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/4] xfs: remove unneeded parameter from XFS_TEST_ERROR
Message-ID: <20170627103346.4elueuvwh2obinbc@eorzea.usersys.redhat.com>
References: <149823570899.31786.10730517727349185585.stgit@birch.djwong.org>
 <149823573624.31786.15640025930541925797.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149823573624.31786.15640025930541925797.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Jun 23, 2017 at 09:35:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since we moved the injected error frequency controls to the mountpoint,
> we can get rid of the last argument to XFS_TEST_ERROR.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_ag_resv.c   |    3 +--
>  fs/xfs/libxfs/xfs_alloc.c     |    6 ++----
>  fs/xfs/libxfs/xfs_bmap.c      |   13 ++++++-------
>  fs/xfs/libxfs/xfs_btree.c     |    6 ++----
>  fs/xfs/libxfs/xfs_dir2.c      |    3 +--
>  fs/xfs/libxfs/xfs_ialloc.c    |    3 +--
>  fs/xfs/libxfs/xfs_inode_buf.c |    3 +--
>  fs/xfs/libxfs/xfs_refcount.c  |    6 ++----
>  fs/xfs/libxfs/xfs_rmap.c      |    3 +--
>  fs/xfs/xfs_error.h            |    4 ++--
>  fs/xfs/xfs_inode.c            |   11 +++++------
>  fs/xfs/xfs_iomap.c            |    2 +-
>  fs/xfs/xfs_log.c              |    3 +--
>  13 files changed, 26 insertions(+), 40 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 33db69b..b008ff3 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -111,8 +111,7 @@ xfs_ag_resv_critical(
>  
>  	/* Critically low if less than 10% or max btree height remains. */
>  	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
> -			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL,
> -			XFS_RANDOM_AG_RESV_CRITICAL);
> +			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index fefa8da..744dcae 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2454,8 +2454,7 @@ xfs_agf_read_verify(
>  	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
>  	else if (XFS_TEST_ERROR(!xfs_agf_verify(mp, bp), mp,
> -				XFS_ERRTAG_ALLOC_READ_AGF,
> -				XFS_RANDOM_ALLOC_READ_AGF))
> +				XFS_ERRTAG_ALLOC_READ_AGF))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> @@ -2842,8 +2841,7 @@ xfs_free_extent(
>  	ASSERT(type != XFS_AG_RESV_AGFL);
>  
>  	if (XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_FREE_EXTENT,
> -			XFS_RANDOM_FREE_EXTENT))
> +			XFS_ERRTAG_FREE_EXTENT))
>  		return -EIO;
>  
>  	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 19480ed..0a98807 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3992,7 +3992,7 @@ xfs_bmapi_read(
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
>  	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> -	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
> @@ -4473,7 +4473,7 @@ xfs_bmapi_write(
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
>  	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> -	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
> @@ -4694,7 +4694,7 @@ xfs_bmapi_remap(
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
>  	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
> -	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
> @@ -6098,7 +6098,7 @@ xfs_bmap_shift_extents(
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
>  	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> -	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmap_shift_extents",
>  				 XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
> @@ -6250,7 +6250,7 @@ xfs_bmap_split_extent_at(
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
>  	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> -	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
>  				 XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
> @@ -6508,8 +6508,7 @@ xfs_bmap_finish_one(
>  		return -EFSCORRUPTED;
>  
>  	if (XFS_TEST_ERROR(false, tp->t_mountp,
> -			XFS_ERRTAG_BMAP_FINISH_ONE,
> -			XFS_RANDOM_BMAP_FINISH_ONE))
> +			XFS_ERRTAG_BMAP_FINISH_ONE))
>  		return -EIO;
>  
>  	switch (type) {
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2f8075a..4da85ff 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -101,8 +101,7 @@ xfs_btree_check_lblock(
>  			be64_to_cpu(block->bb_u.l.bb_rightsib)));
>  
>  	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp,
> -			XFS_ERRTAG_BTREE_CHECK_LBLOCK,
> -			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
> +			XFS_ERRTAG_BTREE_CHECK_LBLOCK))) {
>  		if (bp)
>  			trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> @@ -153,8 +152,7 @@ xfs_btree_check_sblock(
>  		block->bb_u.s.bb_rightsib;
>  
>  	if (unlikely(XFS_TEST_ERROR(!sblock_ok, mp,
> -			XFS_ERRTAG_BTREE_CHECK_SBLOCK,
> -			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
> +			XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
>  		if (bp)
>  			trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 2f389d36..ccf9783 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -218,8 +218,7 @@ xfs_dir_ino_validate(
>  		agblkno != 0 &&
>  		ioff < (1 << mp->m_sb.sb_inopblog) &&
>  		XFS_AGINO_TO_INO(mp, agno, agino) == ino;
> -	if (unlikely(XFS_TEST_ERROR(!ino_ok, mp, XFS_ERRTAG_DIR_INO_VALIDATE,
> -			XFS_RANDOM_DIR_INO_VALIDATE))) {
> +	if (unlikely(XFS_TEST_ERROR(!ino_ok, mp, XFS_ERRTAG_DIR_INO_VALIDATE))) {
>  		xfs_warn(mp, "Invalid inode number 0x%Lx",
>  				(unsigned long long) ino);
>  		XFS_ERROR_REPORT("xfs_dir_ino_validate", XFS_ERRLEVEL_LOW, mp);
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index c514fe9..ffd5a15 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2552,8 +2552,7 @@ xfs_agi_read_verify(
>  	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
>  	else if (XFS_TEST_ERROR(!xfs_agi_verify(bp), mp,
> -				XFS_ERRTAG_IALLOC_READ_AGI,
> -				XFS_RANDOM_IALLOC_READ_AGI))
> +				XFS_ERRTAG_IALLOC_READ_AGI))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 0c970cf..378f8fb 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -105,8 +105,7 @@ xfs_inode_buf_verify(
>  		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
>  			xfs_dinode_good_version(mp, dip->di_version);
>  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> -						XFS_ERRTAG_ITOBP_INOTOBP,
> -						XFS_RANDOM_ITOBP_INOTOBP))) {
> +						XFS_ERRTAG_ITOBP_INOTOBP))) {
>  			if (readahead) {
>  				bp->b_flags &= ~XBF_DONE;
>  				xfs_buf_ioerror(bp, -EIO);
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index e170161..900ea23 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -805,8 +805,7 @@ xfs_refcount_still_have_space(
>  	 */
>  	if (cur->bc_private.a.priv.refc.nr_ops > 2 &&
>  	    XFS_TEST_ERROR(false, cur->bc_mp,
> -			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,
> -			XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE))
> +			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
>  		return false;
>  
>  	if (cur->bc_private.a.priv.refc.nr_ops == 0)
> @@ -1068,8 +1067,7 @@ xfs_refcount_finish_one(
>  			blockcount);
>  
>  	if (XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_REFCOUNT_FINISH_ONE,
> -			XFS_RANDOM_REFCOUNT_FINISH_ONE))
> +			XFS_ERRTAG_REFCOUNT_FINISH_ONE))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index eda275b..55c88a7 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2087,8 +2087,7 @@ xfs_rmap_finish_one(
>  			startoff, blockcount, state);
>  
>  	if (XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_RMAP_FINISH_ONE,
> -			XFS_RANDOM_RMAP_FINISH_ONE))
> +			XFS_ERRTAG_RMAP_FINISH_ONE))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 8915bde..ae8935b 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -135,7 +135,7 @@ extern int xfs_errortag_init(struct xfs_mount *mp);
>  extern void xfs_errortag_del(struct xfs_mount *mp);
>  extern bool xfs_errortag_test(struct xfs_mount *mp, const char *expression,
>  		const char *file, int line, unsigned int error_tag);
> -#define XFS_TEST_ERROR(expr, mp, tag, rf)		\
> +#define XFS_TEST_ERROR(expr, mp, tag)		\
>  	((expr) || xfs_errortag_test((mp), #expr, __FILE__, __LINE__, (tag)))
>  
>  extern int xfs_errortag_get(struct xfs_mount *mp, unsigned int error_tag);
> @@ -146,7 +146,7 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #else
>  #define xfs_errortag_init(mp)			(0)
>  #define xfs_errortag_del(mp)
> -#define XFS_TEST_ERROR(expr, mp, tag, rf)	(expr)
> +#define XFS_TEST_ERROR(expr, mp, tag)		(expr)
>  #define xfs_errortag_set(mp, tag, val)		(ENOSYS)
>  #define xfs_errortag_add(mp, tag)		(ENOSYS)
>  #define xfs_errortag_clearall(mp)		(ENOSYS)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ffbfe7d..67bd563 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3489,7 +3489,7 @@ xfs_iflush_int(
>  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
>  
>  	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
> -			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
> +			       mp, XFS_ERRTAG_IFLUSH_1)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: Bad inode %Lu magic number 0x%x, ptr 0x%p",
>  			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
> @@ -3499,7 +3499,7 @@ xfs_iflush_int(
>  		if (XFS_TEST_ERROR(
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
> -		    mp, XFS_ERRTAG_IFLUSH_3, XFS_RANDOM_IFLUSH_3)) {
> +		    mp, XFS_ERRTAG_IFLUSH_3)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad regular inode %Lu, ptr 0x%p",
>  				__func__, ip->i_ino, ip);
> @@ -3510,7 +3510,7 @@ xfs_iflush_int(
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
> -		    mp, XFS_ERRTAG_IFLUSH_4, XFS_RANDOM_IFLUSH_4)) {
> +		    mp, XFS_ERRTAG_IFLUSH_4)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad directory inode %Lu, ptr 0x%p",
>  				__func__, ip->i_ino, ip);
> @@ -3518,8 +3518,7 @@ xfs_iflush_int(
>  		}
>  	}
>  	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
> -				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5,
> -				XFS_RANDOM_IFLUSH_5)) {
> +				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %Lu, "
>  			"total extents = %d, nblocks = %Ld, ptr 0x%p",
> @@ -3529,7 +3528,7 @@ xfs_iflush_int(
>  		goto corrupt_out;
>  	}
>  	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
> -				mp, XFS_ERRTAG_IFLUSH_6, XFS_RANDOM_IFLUSH_6)) {
> +				mp, XFS_ERRTAG_IFLUSH_6)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: bad inode %Lu, forkoff 0x%x, ptr 0x%p",
>  			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 94e5bdf..304b79d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -543,7 +543,7 @@ xfs_file_iomap_begin_delay(
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
>  	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
> -	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		error = -EFSCORRUPTED;
>  		goto out_unlock;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 98b39cb..2d1112e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1189,8 +1189,7 @@ xlog_iodone(xfs_buf_t *bp)
>  	 * IOABORT state. The IOABORT state is only set in DEBUG mode to inject
>  	 * CRC errors into log recovery.
>  	 */
> -	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR,
> -			   XFS_RANDOM_IODONE_IOERR) ||
> +	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR) ||
>  	    iclog->ic_state & XLOG_STATE_IOABORT) {
>  		if (iclog->ic_state & XLOG_STATE_IOABORT)
>  			iclog->ic_state &= ~XLOG_STATE_IOABORT;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
