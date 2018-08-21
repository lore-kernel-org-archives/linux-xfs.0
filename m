Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbeHUQpq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 12:45:46 -0400
Date: Tue, 21 Aug 2018 09:25:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/10] xfs: open code sb verifier feature checks
Message-ID: <20180821132534.GF15030@bfoster>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820044851.414-9-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 20, 2018 at 02:48:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The superblock verifiers are one of the last places that use the sb
> version functions to do feature checks. This are all quite simple
> uses, and there aren't many of them so open code them all.
> 
> Also, move the good version number check into xfs_sb.c instead of it
> being an inline function in xfs_format.h
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |  26 ---------
>  fs/xfs/libxfs/xfs_sb.c     | 116 +++++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_sb.h     |   1 +
>  3 files changed, 81 insertions(+), 62 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index bedf6c6bf990..b83cf8adca1a 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
...
> @@ -485,7 +523,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  	 * We need to do these manipilations only if we are working
>  	 * with an older version of on-disk superblock.
>  	 */
> -	if (xfs_sb_version_haspquotino(sbp))
> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_5)
>  		return;

Isn't this backwards (we want to exit if == XFS_SB_VERSION_5)?

Brian

>  
>  	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
> @@ -578,7 +616,8 @@ __xfs_sb_from_disk(
>  	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
>  	 * feature flag is set; if not set we keep it only in memory.
>  	 */
> -	if (xfs_sb_version_hasmetauuid(to))
> +	if (XFS_SB_VERSION_NUM(to) == XFS_SB_VERSION_5 &&
> +	    (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID))
>  		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
>  	else
>  		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
> @@ -603,7 +642,12 @@ xfs_sb_quota_to_disk(
>  	uint16_t	qflags = from->sb_qflags;
>  
>  	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
> -	if (xfs_sb_version_haspquotino(from)) {
> +
> +	/*
> +	 * The in-memory superblock quota state matches the v5 on-disk format so
> +	 * just write them out and return
> +	 */
> +	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
>  		to->sb_qflags = cpu_to_be16(from->sb_qflags);
>  		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
>  		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
> @@ -611,9 +655,9 @@ xfs_sb_quota_to_disk(
>  	}
>  
>  	/*
> -	 * The in-core version of sb_qflags do not have XFS_OQUOTA_*
> -	 * flags, whereas the on-disk version does.  So, convert incore
> -	 * XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
> +	 * For older superblocks (v4), the in-core version of sb_qflags do not
> +	 * have XFS_OQUOTA_* flags, whereas the on-disk version does.  So,
> +	 * convert incore XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
>  	 */
>  	qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
>  			XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> @@ -713,7 +757,7 @@ xfs_sb_to_disk(
>  	to->sb_features2 = cpu_to_be32(from->sb_features2);
>  	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
>  
> -	if (xfs_sb_version_hascrc(from)) {
> +	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
>  		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
>  		to->sb_features_ro_compat =
>  				cpu_to_be32(from->sb_features_ro_compat);
> @@ -723,7 +767,7 @@ xfs_sb_to_disk(
>  				cpu_to_be32(from->sb_features_log_incompat);
>  		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
>  		to->sb_lsn = cpu_to_be64(from->sb_lsn);
> -		if (xfs_sb_version_hasmetauuid(from))
> +		if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
>  			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
>  	}
>  }
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 8f4cbe2b639c..e136c2517647 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -29,6 +29,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
>  extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
>  extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
> +extern bool	xfs_sb_good_version(struct xfs_sb *sbp);
>  extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
>  
>  extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
> -- 
> 2.17.0
> 
