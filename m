Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF3E27F3F
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:11:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDC80304043
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:11:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BrFXhiRpYCDdO235 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:11:03 -0800 (PST)
Date: Thu, 5 Feb 2015 09:10:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] xfs: remove xfs_mod_incore_sb API
Message-ID: <20150205141057.GI31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083249-27493-8-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 07:54:09AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that there are no users of the bitfield based incore superblock
> modification API, just remove the whole damn lot of it, including
> all the bitfield definitions. This finally removes a lot of cruft
> that has been around for a long time.
> 
> Credit goes to Christoph Hellwig for providing a great patch
> connecting all the dots to enale us to do this. This patch is
> derived from that work.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h |  62 ---------------------
>  fs/xfs/xfs_fsops.c         |   4 --
>  fs/xfs/xfs_mount.c         | 136 ---------------------------------------------
>  fs/xfs/xfs_mount.h         |   3 +-
>  4 files changed, 1 insertion(+), 204 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 8eb7189..4daaa66 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -264,68 +264,6 @@ typedef struct xfs_dsb {
>  	/* must be padded to 64 bit alignment */
>  } xfs_dsb_t;
>  
> -/*
> - * Sequence number values for the fields.
> - */
> -typedef enum {
> -	XFS_SBS_MAGICNUM, XFS_SBS_BLOCKSIZE, XFS_SBS_DBLOCKS, XFS_SBS_RBLOCKS,
> -	XFS_SBS_REXTENTS, XFS_SBS_UUID, XFS_SBS_LOGSTART, XFS_SBS_ROOTINO,
> -	XFS_SBS_RBMINO, XFS_SBS_RSUMINO, XFS_SBS_REXTSIZE, XFS_SBS_AGBLOCKS,
> -	XFS_SBS_AGCOUNT, XFS_SBS_RBMBLOCKS, XFS_SBS_LOGBLOCKS,
> -	XFS_SBS_VERSIONNUM, XFS_SBS_SECTSIZE, XFS_SBS_INODESIZE,
> -	XFS_SBS_INOPBLOCK, XFS_SBS_FNAME, XFS_SBS_BLOCKLOG,
> -	XFS_SBS_SECTLOG, XFS_SBS_INODELOG, XFS_SBS_INOPBLOG, XFS_SBS_AGBLKLOG,
> -	XFS_SBS_REXTSLOG, XFS_SBS_INPROGRESS, XFS_SBS_IMAX_PCT, XFS_SBS_ICOUNT,
> -	XFS_SBS_IFREE, XFS_SBS_FDBLOCKS, XFS_SBS_FREXTENTS, XFS_SBS_UQUOTINO,
> -	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
> -	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
> -	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
> -	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
> -	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
> -	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
> -	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
> -	XFS_SBS_FIELDCOUNT
> -} xfs_sb_field_t;
> -
> -/*
> - * Mask values, defined based on the xfs_sb_field_t values.
> - * Only define the ones we're using.
> - */
> -#define	XFS_SB_MVAL(x)		(1LL << XFS_SBS_ ## x)
> -#define	XFS_SB_UUID		XFS_SB_MVAL(UUID)
> -#define	XFS_SB_FNAME		XFS_SB_MVAL(FNAME)
> -#define	XFS_SB_ROOTINO		XFS_SB_MVAL(ROOTINO)
> -#define	XFS_SB_RBMINO		XFS_SB_MVAL(RBMINO)
> -#define	XFS_SB_RSUMINO		XFS_SB_MVAL(RSUMINO)
> -#define	XFS_SB_VERSIONNUM	XFS_SB_MVAL(VERSIONNUM)
> -#define XFS_SB_UQUOTINO		XFS_SB_MVAL(UQUOTINO)
> -#define XFS_SB_GQUOTINO		XFS_SB_MVAL(GQUOTINO)
> -#define XFS_SB_QFLAGS		XFS_SB_MVAL(QFLAGS)
> -#define XFS_SB_SHARED_VN	XFS_SB_MVAL(SHARED_VN)
> -#define XFS_SB_UNIT		XFS_SB_MVAL(UNIT)
> -#define XFS_SB_WIDTH		XFS_SB_MVAL(WIDTH)
> -#define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
> -#define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
> -#define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
> -#define XFS_SB_FEATURES2	(XFS_SB_MVAL(FEATURES2) | \
> -				 XFS_SB_MVAL(BAD_FEATURES2))
> -#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
> -#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
> -#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
> -#define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
> -#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
> -#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
> -#define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
> -#define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
> -#define	XFS_SB_MOD_BITS		\
> -	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
> -	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
> -	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
> -	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
> -	 XFS_SB_FEATURES_COMPAT | XFS_SB_FEATURES_RO_COMPAT | \
> -	 XFS_SB_FEATURES_INCOMPAT | XFS_SB_FEATURES_LOG_INCOMPAT | \
> -	 XFS_SB_PQUOTINO)
> -
>  
>  /*
>   * Misc. Flags - warning - these will be cleared by xfs_repair unless
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a45c82b4..6c248bf 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -686,10 +686,6 @@ xfs_reserve_blocks(
>  	 * what to do. This means that the amount of free space can
>  	 * change while we do this, so we need to retry if we end up
>  	 * trying to reserve more space than is available.
> -	 *
> -	 * We also use the xfs_mod_incore_sb() interface so that we
> -	 * don't have to care about whether per cpu counter are
> -	 * enabled, disabled or even compiled in....
>  	 */
>  retry:
>  	spin_lock(&mp->m_sb_lock);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9499e88..6e6bc40 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1218,142 +1218,6 @@ xfs_mod_frextents(
>  }
>  
>  /*
> - * xfs_mod_incore_sb_unlocked() is a utility routine commonly used to apply
> - * a delta to a specified field in the in-core superblock.  Simply
> - * switch on the field indicated and apply the delta to that field.
> - * Fields are not allowed to dip below zero, so if the delta would
> - * do this do not apply it and return EINVAL.
> - *
> - * The m_sb_lock must be held when this routine is called.
> - */
> -STATIC int
> -xfs_mod_incore_sb_unlocked(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t	field,
> -	int64_t		delta,
> -	int		rsvd)
> -{
> -	int		scounter;	/* short counter for 32 bit fields */
> -	long long	lcounter;	/* long counter for 64 bit fields */
> -
> -	/*
> -	 * With the in-core superblock spin lock held, switch
> -	 * on the indicated field.  Apply the delta to the
> -	 * proper field.  If the fields value would dip below
> -	 * 0, then do not apply the delta and return EINVAL.
> -	 */
> -	switch (field) {
> -	case XFS_SBS_ICOUNT:
> -	case XFS_SBS_IFREE:
> -	case XFS_SBS_FDBLOCKS:
> -	case XFS_SBS_FREXTENTS:
> -		ASSERT(0);
> -		return -EINVAL;
> -	case XFS_SBS_DBLOCKS:
> -		lcounter = (long long)mp->m_sb.sb_dblocks;
> -		lcounter += delta;
> -		if (lcounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_dblocks = lcounter;
> -		return 0;
> -	case XFS_SBS_AGCOUNT:
> -		scounter = mp->m_sb.sb_agcount;
> -		scounter += delta;
> -		if (scounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_agcount = scounter;
> -		return 0;
> -	case XFS_SBS_IMAX_PCT:
> -		scounter = mp->m_sb.sb_imax_pct;
> -		scounter += delta;
> -		if (scounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_imax_pct = scounter;
> -		return 0;
> -	case XFS_SBS_REXTSIZE:
> -		scounter = mp->m_sb.sb_rextsize;
> -		scounter += delta;
> -		if (scounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_rextsize = scounter;
> -		return 0;
> -	case XFS_SBS_RBMBLOCKS:
> -		scounter = mp->m_sb.sb_rbmblocks;
> -		scounter += delta;
> -		if (scounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_rbmblocks = scounter;
> -		return 0;
> -	case XFS_SBS_RBLOCKS:
> -		lcounter = (long long)mp->m_sb.sb_rblocks;
> -		lcounter += delta;
> -		if (lcounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_rblocks = lcounter;
> -		return 0;
> -	case XFS_SBS_REXTENTS:
> -		lcounter = (long long)mp->m_sb.sb_rextents;
> -		lcounter += delta;
> -		if (lcounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_rextents = lcounter;
> -		return 0;
> -	case XFS_SBS_REXTSLOG:
> -		scounter = mp->m_sb.sb_rextslog;
> -		scounter += delta;
> -		if (scounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_rextslog = scounter;
> -		return 0;
> -	default:
> -		ASSERT(0);
> -		return -EINVAL;
> -	}
> -}
> -
> -/*
> - * xfs_mod_incore_sb() is used to change a field in the in-core
> - * superblock structure by the specified delta.  This modification
> - * is protected by the m_sb_lock.  Just use the xfs_mod_incore_sb_unlocked()
> - * routine to do the work.
> - */
> -int
> -xfs_mod_incore_sb(
> -	struct xfs_mount	*mp,
> -	xfs_sb_field_t		field,
> -	int64_t			delta,
> -	int			rsvd)
> -{
> -	int			status;
> -
> -#ifdef HAVE_PERCPU_SB
> -	ASSERT(field < XFS_SBS_IFREE || field > XFS_SBS_FDBLOCKS);
> -#endif
> -
> -	spin_lock(&mp->m_sb_lock);
> -	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
> -	spin_unlock(&mp->m_sb_lock);
> -
> -	return status;
> -}
> -
> -/*
>   * xfs_getsb() is called to obtain the buffer for the superblock.
>   * The buffer is returned locked and read in from disk.
>   * The buffer should be released with a call to xfs_brelse().
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 66f28c1..616e1ba 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -302,9 +302,8 @@ extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
>  extern int	xfs_mountfs(xfs_mount_t *mp);
>  extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
>  				     xfs_agnumber_t *maxagi);
> -
>  extern void	xfs_unmountfs(xfs_mount_t *);
> -extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
> +
>  extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
