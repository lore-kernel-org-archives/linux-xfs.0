Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9119AC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 23:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D4406101D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 23:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhHKXEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 19:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhHKXEa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 19:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B07276101D;
        Wed, 11 Aug 2021 23:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628723045;
        bh=bsLvPi8lnNMn3RAe6H7yVMYSSMAGc57t08DN0FryDxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mxuo9kbh2udaypUHzwUO1ATwrMcVPvep4NfMoTCd7JBVUYAlvf+bNoBcE5daLKCEh
         4saILRby/aM4XBLMidvvC35LNDBCdYvq0/aQ/uGS8Q5mbzdwuDFuKTg4uXrzg8H/B0
         MtPNPlG+S5ZsFBfZpgSsRiubvQyX1nTA7d8/93ysPHsZqfGGscwlo3m0FklJku/QRK
         0nl++cMc9ZTE7R+tGnUAdfnCDxwRCxPA2Rh00rcHHtLk6knTVTa0voexN7Z+e+ZAnX
         c/+xDlIPsQZRocdaUniSTV6P096jmRmJ8zci/r1kqYNTLXBn/1IjFnkd2jNnioZTaP
         7OIZf6CJQx7Mw==
Date:   Wed, 11 Aug 2021 16:04:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210811230405.GL3601443@magnolia>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052451.41578-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:24:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The attr2 feature is somewhat unique in that it has both a superblock
> feature bit to enable it and mount options to enable and disable it.
> 
> Back when it was first introduced in 2005, attr2 was disabled unless
> either the attr2 superblock feature bit was set, or the attr2 mount
> option was set. If the superblock feature bit was not set but the
> mount option was set, then when the first attr2 format inode fork
> was created, it would set the superblock feature bit. This is as it
> should be - the superblock feature bit indicated the presence of the
> attr2 on disk format.
> 
> The noattr2 mount option, however, did not affect the superblock
> feature bit. If noattr2 was specified, the on-disk superblock
> feature bit was ignored and the code always just created attr1
> format inode forks.  If neither of the attr2 or noattr2 mounts
> option were specified, then the behaviour was determined by the
> superblock feature bit.
> 
> This was all pretty sane.
> 
> Fast foward 3 years, and we are dealing with fallout from the
> botched sb_features2 addition and having to deal with feature
> mismatches between the sb_features2 and sb_bad_features2 fields. The
> attr2 feature bit was one of these flags. The reconciliation was
> done well after mount option parsing and, unfortunately, the feature
> reconciliation had a bug where it ignored the noattr2 mount option.
> 
> For reasons lost to the mists of time, it was decided that resolving
> this issue in commit 7c12f296500e ("[XFS] Fix up noattr2 so that it
> will properly update the versionnum and features2 fields.") required
> noattr2 to clear the superblock attr2 feature bit.  This greatly
> complicated the attr2 behaviour and broke rules about feature bits
> needing to be set when those specific features are present in the
> filesystem.
> 
> By complicated, I mean that it introduced problems due to feature
> bit interactions with log recovery. All of the superblock feature
> bit checks are done prior to log recovery, but if we crash after
> removing a feature bit, then on the next mount we see the feature
> bit in the unrecovered superblock, only to have it go away after the
> log has been replayed.  This means our mount time feature processing
> could be all wrong.
> 
> Hence you can mount with noattr2, crash shortly afterwards, and
> mount again without attr2 or noattr2 and still have attr2 enabled
> because the second mount sees attr2 still enabled in the superblock
> before recovery runs and removes the feature bit. It's just a mess.
> 
> Further, this is all legacy code as the v5 format requires attr2 to
> be enabled at all times and it cannot be disabled.  i.e. the noattr2
> mount option returns an error when used on v5 format filesystems.
> 
> To straighten this all out, this patch reverts the attr2/noattr2
> mount option behaviour back to the original behaviour. There is no
> reason for disabling attr2 these days, so we will only do this when
> the noattr2 mount option is set. This will not remove the superblock
> feature bit. The superblock bit will provide the default behaviour
> and only track whether attr2 is present on disk or not. The attr2
> mount option will enable the creation of attr2 format inode forks,
> and if the superblock feature bit is not set it will be added when
> the first attr2 inode fork is created.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I see the following regression on xfs/187 with this patch applied:

--- /tmp/fstests/tests/xfs/187.out      2021-05-13 11:47:55.849859833 -0700
+++ /var/tmp/fstests/xfs/187.out.bad    2021-08-11 15:59:15.692618610 -0700
@@ -9,6 +9,8 @@
 
 noattr2 fs
 
+MOREBITS
+ATTR2
 
 *** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***
 
@@ -23,6 +25,8 @@
 user.test
 
 ATTR
+MOREBITS
+ATTR2
 
 *** 3. test noattr2 mount and lazy sb ***
 
@@ -36,4 +40,5 @@
 noattr2 fs
 
 MOREBITS
+ATTR2
 LAZYSBCOUNT

I am pretty sure this is a direct result of "This will not remove the
superblock feature bit", correct?  Do you have an adjustment to xfs/187
to avoid regressing QA?

--D

> ---
>  fs/xfs/libxfs/xfs_format.h |  7 -------
>  fs/xfs/xfs_mount.c         | 27 ++++++++++-----------------
>  fs/xfs/xfs_super.c         | 16 +++++++---------
>  3 files changed, 17 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5d8a129150d5..ac739e6a921e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -398,13 +398,6 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
>  	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
>  }
>  
> -static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
> -{
> -	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
> -	if (!sbp->sb_features2)
> -		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
> -}
> -
>  static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
>  {
>  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 74349eab5b58..f2b3a7932f3b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -612,25 +612,8 @@ xfs_mountfs(
>  		xfs_warn(mp, "correcting sb_features alignment problem");
>  		sbp->sb_features2 |= sbp->sb_bad_features2;
>  		mp->m_update_sb = true;
> -
> -		/*
> -		 * Re-check for ATTR2 in case it was found in bad_features2
> -		 * slot.
> -		 */
> -		if (xfs_sb_version_hasattr2(&mp->m_sb) &&
> -		   !(mp->m_flags & XFS_MOUNT_NOATTR2))
> -			mp->m_flags |= XFS_MOUNT_ATTR2;
>  	}
>  
> -	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
> -	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
> -		xfs_sb_version_removeattr2(&mp->m_sb);
> -		mp->m_update_sb = true;
> -
> -		/* update sb_versionnum for the clearing of the morebits */
> -		if (!sbp->sb_features2)
> -			mp->m_update_sb = true;
> -	}
>  
>  	/* always use v2 inodes by default now */
>  	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
> @@ -773,6 +756,16 @@ xfs_mountfs(
>  	if (error)
>  		goto out_fail_wait;
>  
> +	/*
> +	 * Now that we've recovered any pending superblock feature bit
> +	 * additions, we can finish setting up the attr2 behaviour for the
> +	 * mount. If no attr2 mount options were specified, the we use the
> +	 * behaviour specified by the superblock feature bit.
> +	 */
> +	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&
> +	    xfs_sb_version_hasattr2(&mp->m_sb))
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +
>  	/*
>  	 * Log's mount-time initialization. The first part of recovery can place
>  	 * some items on the AIL, to be handled when recovery is finished or
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 53ce25008948..6ab985ee6ba2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -968,14 +968,6 @@ xfs_finish_flags(
>  		return -EINVAL;
>  	}
>  
> -	/*
> -	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
> -	 * told by noattr2 to turn it off
> -	 */
> -	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
> -	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> -
>  	/*
>  	 * prohibit r/w mounts of read-only filesystems
>  	 */
> @@ -1338,7 +1330,6 @@ xfs_fs_parse_param(
>  		return 0;
>  	case Opt_noattr2:
>  		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
> -		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
>  		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
>  		return 0;
>  	default:
> @@ -1362,6 +1353,13 @@ xfs_fs_validate_params(
>  		return -EINVAL;
>  	}
>  
> +	if ((mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) ==
> +			  (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) {
> +		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> +		return -EINVAL;
> +	}
> +
> +
>  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
>  	    (mp->m_dalign || mp->m_swidth)) {
>  		xfs_warn(mp,
> -- 
> 2.31.1
> 
