Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1EAEB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 17:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjF1Ru4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjF1Ruz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 13:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAE12123
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 10:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87FF561407
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 17:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73A1C433C0;
        Wed, 28 Jun 2023 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974652;
        bh=3UcHAnZhL/kwy/SaCNDPfa2pgHnWS1eRyJkCC/ly5Fw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJdfy/4DkjpKNVJ7KUXC+5jkVDiMOhj3+K0Hjztqltc39Smans2hc25ti7X/24j1i
         dw9JcmiQ6vjxqISSYyVXiQyiaY8/oYFk5UY20z9l9y6gdfCJdEg+/Ogu1L96/07Y3x
         TJtQ/tvkHKGiba1R5jqUOtdf1DRIAt+27dnK4OnZAXeO+GhUNejC/d02YdWqlE4bDs
         S0Q40mQOcSJ3ykE6lrxqudn1mgbI+GCOhhFf4V+ydFCDHpPgFimcFs6e/B4auCKUEI
         TQFyffYq3VpFOyXFupNlaihhC5CnOY9l/jVv842pOE2fRpdXPjQ6dEVNRhux1eihHs
         6Be+tXtqLyjSg==
Date:   Wed, 28 Jun 2023 10:50:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: journal geometry is not properly bounds checked
Message-ID: <20230628175052.GW11441@frogsfrogsfrogs>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:10AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the journal geometry results in a sector or log stripe unit
> validation problem, it indicates that we cannot set the log up to
> safely write to the the journal. In these cases, we must abort the
> mount because the corruption needs external intervention to resolve.
> Similarly, a journal that is too large cannot be written to safely,
> either, so we shouldn't allow those geometries to mount, either.
> 
> If the log is too small, we risk having transaction reservations
> overruning the available log space and the system hanging waiting
> for space it can never provide. This is purely a runtime hang issue,
> not a corruption issue as per the first cases listed above. We abort
> mounts of the log is too small for V5 filesystems, but we must allow
> v4 filesystems to mount because, historically, there was no log size
> validity checking and so some systems may still be out there with
> undersized logs.
> 
> The problem is that on V4 filesystems, when we discover a log
> geometry problem, we skip all the remaining checks and then allow
> the log to continue mounting. This mean that if one of the log size
> checks fails, we skip the log stripe unit check. i.e. we allow the
> mount because a "non-fatal" geometry is violated, and then fail to
> check the hard fail geometries that should fail the mount.
> 
> Move all these fatal checks to the superblock verifier, and add a
> new check for the two log sector size geometry variables having the
> same values. This will prevent any attempt to mount a log that has
> invalid or inconsistent geometries long before we attempt to mount
> the log.
> 
> However, for the minimum log size checks, we can only do that once
> we've setup up the log and calculated all the iclog sizes and
> roundoffs. Hence this needs to remain in the log mount code after
> the log has been initialised. It is also the only case where we
> should allow a v4 filesystem to continue running, so leave that
> handling in place, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 56 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log.c       | 47 +++++++++++------------------------
>  2 files changed, 70 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ba0f17bc1dc0..5e174685a77c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -412,7 +412,6 @@ xfs_validate_sb_common(
>  	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
>  	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
>  	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
> -	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
>  	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
>  	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES	||
>  	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_MAX_AG_BYTES	||
> @@ -430,6 +429,61 @@ xfs_validate_sb_common(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/*
> +	 * Logs that are too large are not supported at all. Reject them
> +	 * outright. Logs that are too small are tolerated on v4 filesystems,
> +	 * but we can only check that when mounting the log. Hence we skip
> +	 * those checks here.
> +	 */
> +	if (sbp->sb_logblocks > XFS_MAX_LOG_BLOCKS) {
> +		xfs_notice(mp,
> +		"Log size 0x%x blocks too large, maximum size is 0x%llx blocks",
> +			 sbp->sb_logblocks, XFS_MAX_LOG_BLOCKS);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (XFS_FSB_TO_B(mp, sbp->sb_logblocks) > XFS_MAX_LOG_BYTES) {
> +		xfs_warn(mp,
> +		"log size 0x%llx bytes too large, maximum size is 0x%llx bytes",
> +			 XFS_FSB_TO_B(mp, sbp->sb_logblocks),
> +			 XFS_MAX_LOG_BYTES);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/*
> +	 * Do not allow filesystems with corrupted log sector or stripe units to
> +	 * be mounted. We cannot safely size the iclogs or write to the log if
> +	 * the log stripe unit is not valid.
> +	 */
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT) {
> +		if (sbp->sb_logsectsize != (1U << sbp->sb_logsectlog)) {
> +			xfs_notice(mp,
> +			"log sector size in bytes/log2 (0x%x/0x%x) must match",
> +				sbp->sb_logsectsize, 1U << sbp->sb_logsectlog);
> +			return -EFSCORRUPTED;
> +		}
> +	} else if (sbp->sb_logsectsize || sbp->sb_logsectlog) {
> +		xfs_notice(mp,
> +		"log sector size in bytes/log2 (0x%x/0x%x) are not zero",
> +			sbp->sb_logsectsize, sbp->sb_logsectlog);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (sbp->sb_logsunit > 1) {
> +		if (sbp->sb_logsunit % sbp->sb_blocksize) {
> +			xfs_notice(mp,
> +		"log stripe unit 0x%x bytes must be a multiple of block size",
> +				sbp->sb_logsunit);
> +			return -EFSCORRUPTED;
> +		}
> +		if (sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE) {
> +			xfs_notice(mp,
> +		"log stripe unit 0x%x bytes over maximum size (0x%x bytes)",
> +				sbp->sb_logsunit, XLOG_MAX_RECORD_BSIZE);
> +			return -EFSCORRUPTED;
> +		}
> +	}
> +
>  	/* Validate the realtime geometry; stolen from xfs_repair */
>  	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
>  	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fc61cc024023..79004d193e54 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -639,7 +639,6 @@ xfs_log_mount(
>  	int		num_bblks)
>  {
>  	struct xlog	*log;
> -	bool		fatal = xfs_has_crc(mp);
>  	int		error = 0;
>  	int		min_logfsbs;
>  
> @@ -663,53 +662,37 @@ xfs_log_mount(
>  	mp->m_log = log;
>  
>  	/*
> -	 * Validate the given log space and drop a critical message via syslog
> -	 * if the log size is too small that would lead to some unexpected
> -	 * situations in transaction log space reservation stage.
> +	 * Now that we have set up the log and it's internal geometry
> +	 * parameters, we can validate the given log space and drop a critical
> +	 * message via syslog if the log size is too small. A log that is too
> +	 * small can lead to unexpected situations in transaction log space
> +	 * reservation stage. The superblock verifier has already validated all
> +	 * the other log geometry constraints, so we don't have to check those
> +	 * here.
>  	 *
> -	 * Note: we can't just reject the mount if the validation fails.  This
> -	 * would mean that people would have to downgrade their kernel just to
> -	 * remedy the situation as there is no way to grow the log (short of
> -	 * black magic surgery with xfs_db).
> +	 * Note: For v4 filesystems, we can't just reject the mount if the
> +	 * validation fails.  This would mean that people would have to
> +	 * downgrade their kernel just to remedy the situation as there is no
> +	 * way to grow the log (short of black magic surgery with xfs_db).
>  	 *
> -	 * We can, however, reject mounts for CRC format filesystems, as the
> +	 * We can, however, reject mounts for V5 format filesystems, as the
>  	 * mkfs binary being used to make the filesystem should never create a
>  	 * filesystem with a log that is too small.
>  	 */
>  	min_logfsbs = xfs_log_calc_minimum_size(mp);
> -
>  	if (mp->m_sb.sb_logblocks < min_logfsbs) {
>  		xfs_warn(mp,
>  		"Log size %d blocks too small, minimum size is %d blocks",
>  			 mp->m_sb.sb_logblocks, min_logfsbs);
> -		error = -EINVAL;
> -	} else if (mp->m_sb.sb_logblocks > XFS_MAX_LOG_BLOCKS) {
> -		xfs_warn(mp,
> -		"Log size %d blocks too large, maximum size is %lld blocks",
> -			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
> -		error = -EINVAL;
> -	} else if (XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks) > XFS_MAX_LOG_BYTES) {
> -		xfs_warn(mp,
> -		"log size %lld bytes too large, maximum size is %lld bytes",
> -			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
> -			 XFS_MAX_LOG_BYTES);
> -		error = -EINVAL;
> -	} else if (mp->m_sb.sb_logsunit > 1 &&
> -		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
> -		xfs_warn(mp,
> -		"log stripe unit %u bytes must be a multiple of block size",
> -			 mp->m_sb.sb_logsunit);
> -		error = -EINVAL;
> -		fatal = true;
> -	}
> -	if (error) {
> +
>  		/*
>  		 * Log check errors are always fatal on v5; or whenever bad
>  		 * metadata leads to a crash.
>  		 */
> -		if (fatal) {
> +		if (xfs_has_crc(mp)) {
>  			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
>  			ASSERT(0);
> +			error = -EINVAL;
>  			goto out_free_log;
>  		}
>  		xfs_crit(mp, "Log size out of supported range.");
> -- 
> 2.40.1
> 
