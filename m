Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7857C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F2C360D07
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhHLA1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232932AbhHLA1v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686F660D07;
        Thu, 12 Aug 2021 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628728047;
        bh=wMyLjyYR+x2pOkORuGAtB0noYzgTNpFXB55OEl5w4Iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CgjqaT/7nkokBJXey5WKpcWJgBr03/KlynC9ehivdhg11E8sHqOpJYq8iPi8VfPkL
         6HrfQVSyZzTFiJAjRr3nXkqnuGn+dhQd5AMfg59Hk+dmjmOsDOZwE0LyA9/wB4SMwK
         1btM3UhaQLQ3mX2+G+mBnkP1WEOH9aGpdgylMetPXSQMhq2sFTM/uZyST5L+hNARhV
         LVOinjzjXSbyXOSeNoXqj/XsJsWYN8SAyE1EVENp9l8wFoCS0KfDbBeSVT2fG41mcS
         7fxxDhSB0hj6FYyah7SokpDYXz372Az6Oy09YZ37DgXAXzFHX1tURVihFhLymuc0VC
         aMVr8KOyDEo+A==
Date:   Wed, 11 Aug 2021 17:27:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210812002727.GV3601466@magnolia>
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

Speaking of log recovery...

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 74349eab5b58..f2b3a7932f3b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
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

...shouldn't this come /after/ the call to xfs_log_mount?

--D

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
