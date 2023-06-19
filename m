Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118E0EB64D9
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jun 2023 08:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjFSIaK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjFSIaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 04:30:09 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1868110
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 01:30:07 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-5607b8c33ddso119215eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687163406; x=1689755406;
        h=in-reply-to:subject:to:from:message-id:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cgp08WAK5MWx35x8f1Ju8LVHUCCDS8wpYxSukkR2m0=;
        b=jxt37TKxlpPIrqSsSuyFlhiF8a/gEPW0D/xg97EFNqRDcypCfb9RbP+GDOIGy544NB
         pAjOHLq/yCNW96NMI8/voz/IlWcWvlbbZkjaI0doNB8h2u358Br18hghWyACUytIfKiF
         FbaBVJyHqHsaABmLod1tJu6G6FdHjz4JcLr11wHX/Kf1XZEQywgf8KpoiPPJBYh/13iQ
         yOX3E5+rpGxhmxYQeRWWyiPX9/cIrgQ+3Qc3UmEO8CTt3ce6fdrTe67J+WJFMnYyXul5
         2CXHV4aakVDw8uYo9k6bJqwWaGjUaYBG0vcYWZGmeaBR/5Yrf8Tj4oGHzXZ7c6to/Cpj
         gbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687163406; x=1689755406;
        h=in-reply-to:subject:to:from:message-id:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+cgp08WAK5MWx35x8f1Ju8LVHUCCDS8wpYxSukkR2m0=;
        b=iiE/xQZ4uJC5IScsh43kDWrEAAXr6ctAV74QU1Wz+H5nMAhbYhWS0lUCanlfpwLbhG
         erSnPgw3a8tZ0ZSTgST1Xc2fyIU/FSebN40fLsE0FA3IZgLdP8ll3buXTV/cm9fBfWsW
         JcUAOZ2/6TqP19AkEXWn9fJn3qNfPSGWrP4JL7ysEHvqa3B9tJhmSI3PN5jvdANw7/ta
         fTbvw4w596hgDXITEY65htEbPvw3KSE6eY/NS5Gg3eXzW5PvvHnvv7fB/98QxAlInk5s
         iqcGdbJ4CWVJ35svkdmTkhV9wt/nCv4q/RGSgzOA0HKtrDckkIFzamcR4QreiYilngH+
         kM/w==
X-Gm-Message-State: AC+VfDyzwjEHCvq6JQRvYpAQMRv/idGSh7U9ZcR8/EVkf8fqXtqQqHFo
        EzRLJRPN2xAISFNAA8wQ0YuDQQvfkOQ=
X-Google-Smtp-Source: ACHHUZ59u/feOVfaNl0kUxeAUiigu8Bv4ZPoh0JiasQGpfZSVJNoSIuuXphz9XYom3oNiKGG1G7Lfw==
X-Received: by 2002:a05:6808:f14:b0:39c:64f4:bc71 with SMTP id m20-20020a0568080f1400b0039c64f4bc71mr7882904oiw.53.1687163406221;
        Mon, 19 Jun 2023 01:30:06 -0700 (PDT)
Received: from dw-tp ([129.41.58.20])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902848200b001b3ab80381csm15986970plo.301.2023.06.19.01.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:30:05 -0700 (PDT)
Date:   Mon, 19 Jun 2023 13:59:57 +0530
Message-Id: <87r0q7n9bu.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: journal geometry is not properly bounds checked
In-Reply-To: <20230619070032.1912781-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

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
> ---
>  fs/xfs/libxfs/xfs_sb.c | 59 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log.c       | 45 ++++++++++----------------------
>  2 files changed, 72 insertions(+), 32 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ba0f17bc1dc0..0daf6bb37741 100644
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
> @@ -430,6 +429,64 @@ xfs_validate_sb_common(
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
> +		"log stripe unit %u bytes must be a multiple of block size",
> +				sbp->sb_logsunit);
> +			return -EFSCORRUPTED;
> +		}
> +		if (sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE) {
> +			xfs_notice(mp,
> +		"log stripe unit %u bytes must be a multiple of block size",
> +				sbp->sb_logsunit);

I guess this xfs_notice message needs to be corrected.

> +			return -EFSCORRUPTED;
> +		}
> +	}
> +
> +
> +
> +

too many new lines here ^^^

>  	/* Validate the realtime geometry; stolen from xfs_repair */
>  	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
>  	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fc61cc024023..397374d07f73 100644
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
> @@ -663,51 +662,35 @@ xfs_log_mount(
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
>  		error = -EINVAL;

Are we using this error now?

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
>  			goto out_free_log;

yes, only here in goto out_free_log we will return "error".
Then why not shift error = -EINVAL in this if block?

-ritesh
