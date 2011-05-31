Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VMSeBi079611 for <xfs@oss.sgi.com>; Tue, 31 May 2011 17:28:40 -0500
Subject: Re: [PATCH] xfs: consolidate & clarify mount sanity checks
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4DD6E291.9030905@redhat.com>
References: <4DD6E291.9030905@redhat.com>
Date: Tue, 31 May 2011 17:28:36 -0500
Message-ID: <1306880916.2865.78.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Pavol Gono <Pavol.Gono@siemens.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, 2011-05-20 at 16:52 -0500, Eric Sandeen wrote:
> Pavol pointed out that there is one silent error case in the mount
> path, and that others are rather uninformative.
> 
> I've taken Pavol's suggested patch and extended it a bit to also:
> 
> * fix a message which says "turned off" but actually errors out
> * consolidate the vaguely differentiated "SB sanity check [12]"
>   messages, and hexdump the superblock for analysis
> 
> Original-patch-by: Pavol Gono <Pavol.Gono@siemens.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.  Based on Linus' message about the 3.0 release,
I'll hold this for 3.1 unless you really feel strongly it belongs
in 3.0.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 8f6fc1a..c13fed8 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -249,6 +249,11 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_MAX_LOG_BYTES \
>  	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
>  
> +/* Used for sanity checks on superblock */
> +#define XFS_MAX_DBLOCKS(s) ((xfs_drfsbno_t)(s)->sb_agcount * (s)->sb_agblocks)
> +#define XFS_MIN_DBLOCKS(s) ((xfs_drfsbno_t)((s)->sb_agcount - 1) *	\
> +			 (s)->sb_agblocks + XFS_MIN_AG_BLOCKS)
> +
>  /*
>   * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
>   */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bb3f9a7..a27dda6 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -348,7 +348,7 @@ xfs_mount_validate_sb(
>  	}
>  
>  	/*
> -	 * More sanity checking. These were stolen directly from
> +	 * More sanity checking.  Most of these were stolen directly from
>  	 * xfs_repair.
>  	 */
>  	if (unlikely(
> @@ -371,23 +371,13 @@ xfs_mount_validate_sb(
>  	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
> -	    (sbp->sb_imax_pct > 100 /* zero sb_imax_pct is valid */))) {
> +	    (sbp->sb_imax_pct > 100 /* zero sb_imax_pct is valid */)	||
> +	    sbp->sb_dblocks == 0					||
> +	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
> +	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
>  		if (loud)
> -			xfs_warn(mp, "SB sanity check 1 failed");
> -		return XFS_ERROR(EFSCORRUPTED);
> -	}
> -
> -	/*
> -	 * Sanity check AG count, size fields against data size field
> -	 */
> -	if (unlikely(
> -	    sbp->sb_dblocks == 0 ||
> -	    sbp->sb_dblocks >
> -	     (xfs_drfsbno_t)sbp->sb_agcount * sbp->sb_agblocks ||
> -	    sbp->sb_dblocks < (xfs_drfsbno_t)(sbp->sb_agcount - 1) *
> -			      sbp->sb_agblocks + XFS_MIN_AG_BLOCKS)) {
> -		if (loud)
> -			xfs_warn(mp, "SB sanity check 2 failed");
> +			XFS_CORRUPTION_ERROR("SB sanity check failed",
> +				XFS_ERRLEVEL_LOW, mp, sbp);
>  		return XFS_ERROR(EFSCORRUPTED);
>  	}
>  
> @@ -864,7 +854,8 @@ xfs_update_alignment(xfs_mount_t *mp)
>  		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
>  		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
>  			if (mp->m_flags & XFS_MOUNT_RETERR) {
> -				xfs_warn(mp, "alignment check 1 failed");
> +				xfs_warn(mp, "alignment check failed: "
> +					 "(sunit/swidth vs. blocksize)");
>  				return XFS_ERROR(EINVAL);
>  			}
>  			mp->m_dalign = mp->m_swidth = 0;
> @@ -875,6 +866,8 @@ xfs_update_alignment(xfs_mount_t *mp)
>  			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
>  			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
>  				if (mp->m_flags & XFS_MOUNT_RETERR) {
> +					xfs_warn(mp, "alignment check failed: "
> +					 	 "(sunit/swidth vs. ag size)");
>  					return XFS_ERROR(EINVAL);
>  				}
>  				xfs_warn(mp,
> @@ -889,8 +882,8 @@ xfs_update_alignment(xfs_mount_t *mp)
>  				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
>  			} else {
>  				if (mp->m_flags & XFS_MOUNT_RETERR) {
> -					xfs_warn(mp,
> -		"stripe alignment turned off: sunit(%d) less than bsize(%d)",
> +					xfs_warn(mp, "alignment check failed: "
> +						"sunit(%d) less than bsize(%d)",
>  						mp->m_dalign,
>  						mp->m_blockmask +1);
>  					return XFS_ERROR(EINVAL);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
