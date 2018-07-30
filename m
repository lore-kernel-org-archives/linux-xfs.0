Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56284 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbeGaAoH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 20:44:07 -0400
Subject: Re: [PATCH 1/3] xfs: refactor superblock verifiers
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
 <153292861500.19274.6476856835031792043.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f5a0b50a-bf01-78c1-10a5-de7d666cd109@sandeen.net>
Date: Mon, 30 Jul 2018 18:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <153292861500.19274.6476856835031792043.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/30/18 12:30 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Split the superblock verifier into the common checks, the read-time
> checks, and the write-time check functions.  No functional changes, but
> we're setting up to add more write-only checks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Couple nitpicks below,change them on the way in if you like.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_sb.c |  205 ++++++++++++++++++++++++++----------------------
>  1 file changed, 112 insertions(+), 93 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b3ad15956366..516bef7b0f50 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -96,80 +96,96 @@ xfs_perag_put(
>  	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
>  }
>  
> -/*
> - * Check the validity of the SB found.
> - */
> +/* Check all the superblock fields we care about when reading one in. */
>  STATIC int
> -xfs_mount_validate_sb(
> -	xfs_mount_t	*mp,
> -	xfs_sb_t	*sbp,
> -	bool		check_inprogress,
> -	bool		check_version)
> +xfs_validate_sb_read(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
>  {
> -	uint32_t	agcount = 0;
> -	uint32_t	rem;
> -
> -	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
> -		xfs_warn(mp, "bad magic number");
> -		return -EWRONGFS;
> -	}
> -
> -
> -	if (!xfs_sb_good_version(sbp)) {
> -		xfs_warn(mp, "bad version");
> -		return -EWRONGFS;
> -	}
> +	if (!xfs_sb_version_hascrc(sbp))
> +		return 0;

Can we make this

	if (!(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)) ?

nitpicky but it always bugs me to see "do we have metadata crcs" as a standin
for other available features (like feature flags).  Yes, they go together,
but bleah.

(and the original code tested superblock version, right?)

>  	/*
> -	 * Version 5 superblock feature mask validation. Reject combinations the
> -	 * kernel cannot support up front before checking anything else. For
> -	 * write validation, we don't need to check feature masks.
> +	 * Version 5 superblock feature mask validation. Reject combinations
> +	 * the kernel cannot support up front before checking anything else.
> +	 * For write validation, we don't need to check feature masks.

Huh, I wonder why not.  But ok, keeping the same behavior.

>  	 */
> -	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> -		if (xfs_sb_has_compat_feature(sbp,
> -					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> -			xfs_warn(mp,
> +	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
>  "Superblock has unknown compatible features (0x%x) enabled.",
> -				(sbp->sb_features_compat &
> -						XFS_SB_FEAT_COMPAT_UNKNOWN));
> -			xfs_warn(mp,
> +			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
> +		xfs_warn(mp,
>  "Using a more recent kernel is recommended.");
> -		}
> +	}
>  
> -		if (xfs_sb_has_ro_compat_feature(sbp,
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> -			xfs_alert(mp,
> +	if (xfs_sb_has_ro_compat_feature(sbp,
> +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +		xfs_alert(mp,
>  "Superblock has unknown read-only compatible features (0x%x) enabled.",
> -				(sbp->sb_features_ro_compat &
> -						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -			if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> -				xfs_warn(mp,
> +			(sbp->sb_features_ro_compat &
> +					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> +		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +			xfs_warn(mp,
>  "Attempted to mount read-only compatible filesystem read-write.");
> -				xfs_warn(mp,
> +			xfs_warn(mp,
>  "Filesystem can only be safely mounted read only.");
>  
> -				return -EINVAL;
> -			}
> +			return -EINVAL;
>  		}
> -		if (xfs_sb_has_incompat_feature(sbp,
> -					XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
> -			xfs_warn(mp,
> +	}
> +	if (xfs_sb_has_incompat_feature(sbp,
> +				XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
>  "Superblock has unknown incompatible features (0x%x) enabled.",
> -				(sbp->sb_features_incompat &
> -						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
> -			xfs_warn(mp,
> +			(sbp->sb_features_incompat &
> +					XFS_SB_FEAT_INCOMPAT_UNKNOWN));
> +		xfs_warn(mp,
>  "Filesystem can not be safely mounted by this kernel.");
> -			return -EINVAL;
> -		}
> -	} else if (xfs_sb_version_hascrc(sbp)) {
> -		/*
> -		 * We can't read verify the sb LSN because the read verifier is
> -		 * called before the log is allocated and processed. We know the
> -		 * log is set up before write verifier (!check_version) calls,
> -		 * so just check it here.
> -		 */
> -		if (!xfs_log_check_lsn(mp, sbp->sb_lsn))
> -			return -EFSCORRUPTED;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Check all the superblock fields we care about when writing one out. */
> +STATIC int
> +xfs_validate_sb_write(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
> +{
> +	if (!xfs_sb_version_hascrc(sbp))
> +		return 0;
> +
> +	/*
> +	 * We can't read verify the sb LSN because the read verifier is called
> +	 * before the log is allocated and processed. We know the log is set up
> +	 * before write verifier (!check_version) calls, so just check it here.
> +	 */
> +	if (!xfs_log_check_lsn(mp, sbp->sb_lsn))
> +		return -EFSCORRUPTED;
> +
> +	return 0;
> +}
> +
> +/* Check the validity of the SB. */
> +STATIC int
> +xfs_validate_sb_common(
> +	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp,
> +	struct xfs_sb		*sbp)
> +{
> +	uint32_t		agcount = 0;
> +	uint32_t		rem;
> +
> +	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
> +		xfs_warn(mp, "bad magic number");
> +		return -EWRONGFS;
> +	}
> +
> +

just one newline pls ;)  (even if it was there before)

> +	if (!xfs_sb_good_version(sbp)) {
> +		xfs_warn(mp, "bad version");
> +		return -EWRONGFS;
>  	}
>  
>  	if (xfs_sb_version_has_pquotino(sbp)) {
