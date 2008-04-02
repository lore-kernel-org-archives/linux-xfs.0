Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 18:11:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m321Aogo014887
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 18:10:52 -0700
Date: Wed, 2 Apr 2008 10:29:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] combined features2 fixup patches (updating/rewriting what was sent in other threads)
Message-ID: <20080402002940.GZ103491721@sgi.com>
References: <47F0546C.9070709@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F0546C.9070709@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Mar 30, 2008 at 10:03:08PM -0500, Eric Sandeen wrote:
> Ensure "both" features2 slots are consistent, and set mp attr2 flag.
> 
> Since older kernels may look in the sb_bad_features2 slot for
> flags, rather than zeroing it out on fixup, we should make it 
> equal to the sb_features2 value.
> 
> Also, if the ATTR2 flag was not found prior to features2
> fixup, it was not set in the mount flags, so re-check after the
> fixup so that the current session will use the feature.
> 
> Also fix up the comments to reflect these changes.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c
> @@ -967,22 +967,26 @@ xfs_mountfs(
>  	xfs_mount_common(mp, sbp);
>  
>  	/*
> -	 * Check for a bad features2 field alignment. This happened on
> -	 * some platforms due to xfs_sb_t not being 64bit size aligned
> -	 * when sb_features was added and hence the compiler put it in
> -	 * the wrong place.
> +	 * Check for a mismatched features2 values.  Older kernels
> +	 * read & wrote into the wrong sb offset for sb_features2
> +	 * on some platforms due to xfs_sb_t not being 64bit size aligned
> +	 * when sb_features2 was added, which made older superblock
> +	 * reading/writing routines swap it as a 64-bit value.
>  	 *
> -	 * If we detect a bad field, we or the set bits into the existing
> -	 * features2 field in case it has already been modified and we
> -	 * don't want to lose any features. Zero the bad one and mark
> -	 * the two fields as needing updates once the transaction subsystem
> -	 * is online.
> +	 * For backwards compatibility, we make both slots equal.
> +	 *
> +	 * If we detect a mismatched field, we OR the set bits into the
> +	 * existing features2 field in case it has already been modified; we
> +	 * don't want to lose any features.  We then update the bad location
> +	 * with the ORed value so that older kernels will see any features2
> +	 * flags, and mark the two fields as needing updates once the 
> +	 * transaction subsystem is online.
>  	 */
> -	if (xfs_sb_has_bad_features2(sbp)) {
> +	if (xfs_sb_has_mismatched_features2(sbp)) {
>  		cmn_err(CE_WARN,
>  			"XFS: correcting sb_features alignment problem");
>  		sbp->sb_features2 |= sbp->sb_bad_features2;
> -		sbp->sb_bad_features2 = 0;
> +		sbp->sb_bad_features2 = sbp->sb_features2;
>  		update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;

Probably should update XFS_MOUNT_ATTR2 here, not later. i.e. before
we mount he log and start recovery.

> @@ -1181,6 +1185,12 @@ xfs_mountfs(
>  		xfs_mount_log_sb(mp, update_flags);
>  
>  	/*
> +	 * Re-check for ATTR2 in case it was found in bad_features2 slot.
> +	 */
> +	if (xfs_sb_version_hasattr2(&mp->m_sb))
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +

Rather than here.

>  /*
> - * Detect a bad features2 field
> + * Detect a mismatched features2 field.  Older kernels read/wrote
> + * this into the wrong slot, so to be safe we keep them in sync.
>   */
> -static inline int xfs_sb_has_bad_features2(xfs_sb_t *sbp)
> +static inline int xfs_sb_has_mismatched_features2(xfs_sb_t *sbp)
>  {
> -	return (sbp->sb_bad_features2 != 0);
> +	return (sbp->sb_bad_features2 != sbp->sb_features2);
>  }

Yep, makes sense.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
