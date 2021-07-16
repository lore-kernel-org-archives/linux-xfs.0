Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2E7C636C9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 00:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1028E613DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 00:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhGPA3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 20:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhGPA3B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jul 2021 20:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10056613DC;
        Fri, 16 Jul 2021 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626395167;
        bh=QNt1bAd5/qEdHvgqTkhryPdqPvVIyF0e7ALdQEbEjHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cPreV8ZHCgWQvuD3IToI4p7QFPw9BAmzIMocDoS3ptO4rWhBo5g6LMyvmLPnxqkNM
         e+1d4k8KgVBpmfsadHPJ1EaMbQVaVDvpJUQAXQ0ikYb9RtUyyTb2SZM8r/SH8OsqqM
         1ru0YtCfsBOHTcxT36e4L9S71OVp4rcFLrpm5TdraAfwZc0jE3759nx7L52tvXmII7
         V89jxQtEig13DdTCNtpkbsUcOofrApHVLJg2Ok7gytBBGPXTF0Lybn2bm2WmJrJUEW
         esVziklDgqZJtVsJy9AcOKIcskaYfBJOzVxfHH9cuZr6MbHF7ZDBMQj87gBk2EeoE/
         6xjUL1usaNCsQ==
Date:   Thu, 15 Jul 2021 17:26:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: open code sb verifier feature checks
Message-ID: <20210716002606.GY22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-12-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:07PM +1000, Dave Chinner wrote:
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
>  fs/xfs/libxfs/xfs_format.h |  29 ---------
>  fs/xfs/libxfs/xfs_sb.c     | 117 +++++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_sb.h     |   1 +
>  3 files changed, 82 insertions(+), 65 deletions(-)

<snip>

> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5eaf14b6fe3c..2a01769b316a 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c

<snip>

> @@ -239,12 +271,42 @@ xfs_validate_sb_common(
>  		return -EWRONGFS;
>  	}
>  
> -	if (xfs_sb_version_haspquotino(sbp)) {
> +	/*
> +	 * Validate feature flags and state
> +	 */
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> +		if (sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> +			xfs_notice(mp,
> +"Block size (%u bytes) too small for Version 5 superblock (minimum %d bytes)",
> +				sbp->sb_blocksize, XFS_MIN_CRC_BLOCKSIZE);
> +			return -EFSCORRUPTED;
> +		}
> +
> +		/* V5 has a separate project quota inode */
>  		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
>  			xfs_notice(mp,
>  			   "Version 5 of Super block has XFS_OQUOTA bits.");
>  			return -EFSCORRUPTED;
>  		}
> +
> +		/*
> +		 * Full inode chunks must be aligned to inode chunk size when
> +		 * sparse inodes are enabled to support the sparse chunk
> +		 * allocation algorithm and prevent overlapping inode records.
> +		 */
> +		if (xfs_sb_has_incompat_feature(sbp,
> +				XFS_SB_FEAT_INCOMPAT_SPINODES)) {

The conversion all looks good to me, with this one exception.  Why does
this still use xfs_sb_has_incompat_feature whereas other feature flag
checks dereference sbp directly, like META_UUID below?

--D

> +			uint32_t	align;
> +
> +			align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
> +					>> sbp->sb_blocklog;
> +			if (sbp->sb_inoalignmt != align) {
> +				xfs_warn(mp,
> +"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
> +					 sbp->sb_inoalignmt, align);
> +				return -EINVAL;
> +			}
> +		}
>  	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>  				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
>  			xfs_notice(mp,
> @@ -252,24 +314,6 @@ xfs_validate_sb_common(
>  			return -EFSCORRUPTED;
>  	}
>  
> -	/*
> -	 * Full inode chunks must be aligned to inode chunk size when
> -	 * sparse inodes are enabled to support the sparse chunk
> -	 * allocation algorithm and prevent overlapping inode records.
> -	 */
> -	if (xfs_sb_version_hassparseinodes(sbp)) {
> -		uint32_t	align;
> -
> -		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
> -				>> sbp->sb_blocklog;
> -		if (sbp->sb_inoalignmt != align) {
> -			xfs_warn(mp,
> -"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
> -				 sbp->sb_inoalignmt, align);
> -			return -EINVAL;
> -		}
> -	}
> -
>  	if (unlikely(
>  	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
>  		xfs_warn(mp,
> @@ -369,7 +413,8 @@ xfs_validate_sb_common(
>  	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
>  	 * would imply the image is corrupted.
>  	 */
> -	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> +	has_dalign = sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT;
> +	if (!!sbp->sb_unit ^ has_dalign) {
>  		xfs_notice(mp, "SB stripe alignment sanity check failed");
>  		return -EFSCORRUPTED;
>  	}
> @@ -378,12 +423,6 @@ xfs_validate_sb_common(
>  			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
>  		return -EFSCORRUPTED;
>  
> -	if (xfs_sb_version_hascrc(sbp) &&
> -	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> -		xfs_notice(mp, "v5 SB sanity check failed");
> -		return -EFSCORRUPTED;
> -	}
> -
>  	/*
>  	 * Currently only very few inode sizes are supported.
>  	 */
> @@ -427,7 +466,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  	 * We need to do these manipilations only if we are working
>  	 * with an older version of on-disk superblock.
>  	 */
> -	if (xfs_sb_version_haspquotino(sbp))
> +	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5)
>  		return;
>  
>  	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
> @@ -520,7 +559,8 @@ __xfs_sb_from_disk(
>  	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
>  	 * feature flag is set; if not set we keep it only in memory.
>  	 */
> -	if (xfs_sb_version_hasmetauuid(to))
> +	if (XFS_SB_VERSION_NUM(to) == XFS_SB_VERSION_5 &&
> +	    (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID))
>  		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
>  	else
>  		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
> @@ -545,7 +585,12 @@ xfs_sb_quota_to_disk(
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
> @@ -553,9 +598,9 @@ xfs_sb_quota_to_disk(
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
> @@ -655,7 +700,7 @@ xfs_sb_to_disk(
>  	to->sb_features2 = cpu_to_be32(from->sb_features2);
>  	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
>  
> -	if (xfs_sb_version_hascrc(from)) {
> +	if (XFS_SB_VERSION_NUM(from) == XFS_SB_VERSION_5) {
>  		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
>  		to->sb_features_ro_compat =
>  				cpu_to_be32(from->sb_features_ro_compat);
> @@ -665,7 +710,7 @@ xfs_sb_to_disk(
>  				cpu_to_be32(from->sb_features_log_incompat);
>  		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
>  		to->sb_lsn = cpu_to_be64(from->sb_lsn);
> -		if (xfs_sb_version_hasmetauuid(from))
> +		if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
>  			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
>  	}
>  }
> @@ -703,7 +748,7 @@ xfs_sb_read_verify(
>  		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
>  			/* Only fail bad secondaries on a known V5 filesystem */
>  			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
> -			    xfs_sb_version_hascrc(&mp->m_sb)) {
> +			    xfs_has_crc(mp)) {
>  				error = -EFSBADCRC;
>  				goto out_error;
>  			}
> @@ -770,7 +815,7 @@ xfs_sb_write_verify(
>  	if (error)
>  		goto out_error;
>  
> -	if (!xfs_sb_version_hascrc(&sb))
> +	if (XFS_SB_VERSION_NUM(&sb) != XFS_SB_VERSION_5)
>  		return;
>  
>  	if (bip)
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 8902f4bfa5df..a5e14740ec9a 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -20,6 +20,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
>  extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
>  extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
> +extern bool	xfs_sb_good_version(struct xfs_sb *sbp);
>  extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
>  
>  extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
> -- 
> 2.31.1
> 
