Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55618 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbeGaFqJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 01:46:09 -0400
Subject: Re: [PATCH 4/4] xfs: check for unknown v5 feature bits in superblock
 write verifier
References: <153300933773.5164.7520087911614107147.stgit@magnolia>
 <153300936259.5164.13952216512619844940.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eeffe13f-5257-ff85-fe9c-dfed096e9cfb@sandeen.net>
Date: Mon, 30 Jul 2018 23:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <153300936259.5164.13952216512619844940.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/30/18 10:56 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we never try to write the superblock with unknown feature bits
> set.  We checked those at mount time, so if they're set now then memory
> is corrupt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c |   35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)

Meh, a lot of cut and paste of the tests, but I guess it needs different
messages, behaviors, and error codes.  :(

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 05e7ed1b8022..ca1b3a7a9171 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -166,7 +166,40 @@ xfs_validate_sb_write(
>  	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
>  		return 0;
>  
> -	/* XXX: For write validation, we don't need to check feature masks?? */
> +	/*
> +	 * Version 5 superblock feature mask validation. Reject combinations
> +	 * the kernel cannot support since we checked for unsupported bits in
> +	 * the read verifier, which means that memory is corrupt.
> +	 */
> +	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
> +"Corruption detected in superblock compatible features (0x%x)!",
> +			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +		xfs_alert(mp,
> +"Corruption detected in superblock read-only compatible features (0x%x)!",
> +			(sbp->sb_features_ro_compat &
> +					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> +		return -EFSCORRUPTED;
> +	}
> +	if (xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
> +"Corruption detected in superblock incompatible features (0x%x)!",
> +			(sbp->sb_features_incompat &
> +					XFS_SB_FEAT_INCOMPAT_UNKNOWN));
> +		return -EFSCORRUPTED;
> +	}
> +	if (xfs_sb_has_incompat_log_feature(sbp,
> +			XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
> +		xfs_warn(mp,
> +"Corruption detected in superblock incompatible log features (0x%x)!",
> +			(sbp->sb_features_log_incompat &
> +					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> +		return -EFSCORRUPTED;
> +	}
>  
>  	/*
>  	 * We can't read verify the sb LSN because the read verifier is called
> 
