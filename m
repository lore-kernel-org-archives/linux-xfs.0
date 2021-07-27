Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AD3C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 12:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 323C661A79
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 12:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhG0MY3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhG0MY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 08:24:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76CC061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 05:24:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n10so15691916plf.4
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 05:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jjp4R3JO/DsICTGQEBu+qmfrVV8BXDHnVjW7acATNb4=;
        b=Ee2kaCjDp14t/xrX8ZehehSftwpdYY9kyDfUDmhVzptUOLwFrtf9lqhDE/+EtQlPVN
         TFbY0iho3A8tVILkiYgNz2FWuVz/hhvCRjGwCijZmmKlMVqaeuQBin57Co9mtWbnBq8A
         Fqj4Y8Nkav0g77VYgjOFOKLU+DoQfonihfFkMxMMWrb/d03EN/n78YokehPZNS45WbFb
         Og5Sjc/98BT89S423+2zHt8L2vCuYWbM/S7RuPaB6ZQP80b920T80vXF7EOIGavjE5Nr
         xNKTFhEVnc1vy/ik2gKqyEWtRan4nyq0WRf1VJIWn/PBIp7ySCo+piF5nyhYaQeoqUyA
         p1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jjp4R3JO/DsICTGQEBu+qmfrVV8BXDHnVjW7acATNb4=;
        b=E3zIGz+f+kqSBwsN4H///rXPQsjE/HrruMT9LpqlAYkAonuyx5Xzr0W4rqsNj8DByX
         7rHgB5tcz8fi+f/huVRzLLSOo/uVK65kGBxazO15qkDOFB1+9zA8BnR9G6n8TcsKl883
         NiOxy58IoRg5nQ+BUZO2MWVDlf7Y/0hIdFk0m0yC6yHJScOG66H4UUdkMVmH7d295Ri3
         l9xoNq0eOtfqX3npklhOCwZSuxUYlgrWEK14W0KbgVWj8RS09cOrF4XxJWWczCUH/VQZ
         vRFMNC2ola/blnSKsl6eHmgfH1wVcf1PYcKZz6tElk5xzSTp0805/G3UyxjEs7xpVg/o
         Q6qQ==
X-Gm-Message-State: AOAM531y7Zst6tqzukgmuytUBuuL9TWmmkXbZT90fpGdfRreimA9hoB0
        +Dg96lOa2mhsE5Lhtli1dABZDuaiE9s=
X-Google-Smtp-Source: ABdhPJwJUPNidFJr8UiN1qdcJQGFZrAWrTKo2Dhl/CcoPUAStRcDq5jp0x9fUQx7VFsyJp+FiV55NA==
X-Received: by 2002:a63:ee06:: with SMTP id e6mr23021295pgi.374.1627388667113;
        Tue, 27 Jul 2021 05:24:27 -0700 (PDT)
Received: from garuda ([122.171.185.191])
        by smtp.gmail.com with ESMTPSA id y28sm3685659pff.137.2021.07.27.05.24.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 05:24:26 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-2-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 01/16] xfs: allow setting and clearing of log incompat feature flags
In-reply-to: <20210727062053.11129-2-allison.henderson@oracle.com>
Date:   Tue, 27 Jul 2021 17:54:23 +0530
Message-ID: <87bl6oeyh4.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Log incompat feature flags in the superblock exist for one purpose: to
> protect the contents of a dirty log from replay on a kernel that isn't
> prepared to handle those dirty contents.  This means that they can be
> cleared if (a) we know the log is clean and (b) we know that there
> aren't any other threads in the system that might be setting or relying
> upon a log incompat flag.
>
> Therefore, clear the log incompat flags when we've finished recovering
> the log, when we're unmounting cleanly, remounting read-only, or
> freezing; and provide a function so that subsequent patches can start
> using this.

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>
> ---
>  fs/xfs/libxfs/xfs_format.h |  15 +++++++
>  fs/xfs/xfs_log.c           |  14 ++++++
>  fs/xfs/xfs_log_recover.c   |  16 +++++++
>  fs/xfs/xfs_mount.c         | 110 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.h         |   2 +
>  5 files changed, 157 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 76e2461..3a4da111 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
>  	return (sbp->sb_features_log_incompat & feature) != 0;
>  }
>  
> +static inline void
> +xfs_sb_remove_incompat_log_features(
> +	struct xfs_sb	*sbp)
> +{
> +	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
> +}
> +
> +static inline void
> +xfs_sb_add_incompat_log_features(
> +	struct xfs_sb	*sbp,
> +	unsigned int	features)
> +{
> +	sbp->sb_features_log_incompat |= features;
> +}
> +
>  /*
>   * V5 superblock specific feature checks
>   */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 36fa265..9254405 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -947,6 +947,20 @@ int
>  xfs_log_quiesce(
>  	struct xfs_mount	*mp)
>  {
> +	/*
> +	 * Clear log incompat features since we're quiescing the log.  Report
> +	 * failures, though it's not fatal to have a higher log feature
> +	 * protection level than the log contents actually require.
> +	 */
> +	if (xfs_clear_incompat_log_features(mp)) {
> +		int error;
> +
> +		error = xfs_sync_sb(mp, false);
> +		if (error)
> +			xfs_warn(mp,
> +	"Failed to clear log incompat features on quiesce");
> +	}
> +
>  	cancel_delayed_work_sync(&mp->m_log->l_work);
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1721fce..ec4ccae 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3464,6 +3464,22 @@ xlog_recover_finish(
>  		 */
>  		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
> +		/*
> +		 * Now that we've recovered the log and all the intents, we can
> +		 * clear the log incompat feature bits in the superblock
> +		 * because there's no longer anything to protect.  We rely on
> +		 * the AIL push to write out the updated superblock after
> +		 * everything else.
> +		 */
> +		if (xfs_clear_incompat_log_features(log->l_mp)) {
> +			error = xfs_sync_sb(log->l_mp, false);
> +			if (error < 0) {
> +				xfs_alert(log->l_mp,
> +	"Failed to clear log incompat features on recovery");
> +				return error;
> +			}
> +		}
> +
>  		xlog_recover_process_iunlinks(log);
>  
>  		xlog_recover_check_summary(log);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d075549..d2c40ae 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1217,6 +1217,116 @@ xfs_force_summary_recalc(
>  }
>  
>  /*
> + * Enable a log incompat feature flag in the primary superblock.  The caller
> + * cannot have any other transactions in progress.
> + */
> +int
> +xfs_add_incompat_log_feature(
> +	struct xfs_mount	*mp,
> +	uint32_t		feature)
> +{
> +	struct xfs_dsb		*dsb;
> +	int			error;
> +
> +	ASSERT(hweight32(feature) == 1);
> +	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> +
> +	/*
> +	 * Force the log to disk and kick the background AIL thread to reduce
> +	 * the chances that the bwrite will stall waiting for the AIL to unpin
> +	 * the primary superblock buffer.  This isn't a data integrity
> +	 * operation, so we don't need a synchronous push.
> +	 */
> +	error = xfs_log_force(mp, XFS_LOG_SYNC);
> +	if (error)
> +		return error;
> +	xfs_ail_push_all(mp->m_ail);
> +
> +	/*
> +	 * Lock the primary superblock buffer to serialize all callers that
> +	 * are trying to set feature bits.
> +	 */
> +	xfs_buf_lock(mp->m_sb_bp);
> +	xfs_buf_hold(mp->m_sb_bp);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		error = -EIO;
> +		goto rele;
> +	}
> +
> +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
> +		goto rele;
> +
> +	/*
> +	 * Write the primary superblock to disk immediately, because we need
> +	 * the log_incompat bit to be set in the primary super now to protect
> +	 * the log items that we're going to commit later.
> +	 */
> +	dsb = mp->m_sb_bp->b_addr;
> +	xfs_sb_to_disk(dsb, &mp->m_sb);
> +	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
> +	error = xfs_bwrite(mp->m_sb_bp);
> +	if (error)
> +		goto shutdown;
> +
> +	/*
> +	 * Add the feature bits to the incore superblock before we unlock the
> +	 * buffer.
> +	 */
> +	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
> +	xfs_buf_relse(mp->m_sb_bp);
> +
> +	/* Log the superblock to disk. */
> +	return xfs_sync_sb(mp, false);
> +shutdown:
> +	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +rele:
> +	xfs_buf_relse(mp->m_sb_bp);
> +	return error;
> +}
> +
> +/*
> + * Clear all the log incompat flags from the superblock.
> + *
> + * The caller cannot be in a transaction, must ensure that the log does not
> + * contain any log items protected by any log incompat bit, and must ensure
> + * that there are no other threads that depend on the state of the log incompat
> + * feature flags in the primary super.
> + *
> + * Returns true if the superblock is dirty.
> + */
> +bool
> +xfs_clear_incompat_log_features(
> +	struct xfs_mount	*mp)
> +{
> +	bool			ret = false;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> +	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
> +	    XFS_FORCED_SHUTDOWN(mp))
> +		return false;
> +
> +	/*
> +	 * Update the incore superblock.  We synchronize on the primary super
> +	 * buffer lock to be consistent with the add function, though at least
> +	 * in theory this shouldn't be necessary.
> +	 */
> +	xfs_buf_lock(mp->m_sb_bp);
> +	xfs_buf_hold(mp->m_sb_bp);
> +
> +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
> +		xfs_info(mp, "Clearing log incompat feature flags.");
> +		xfs_sb_remove_incompat_log_features(&mp->m_sb);
> +		ret = true;
> +	}
> +
> +	xfs_buf_relse(mp->m_sb_bp);
> +	return ret;
> +}
> +
> +/*
>   * Update the in-core delayed block counter.
>   *
>   * We prefer to update the counter without having to take a spinlock for every
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c78b63f..66a47f5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -325,6 +325,8 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
>  struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
>  		int error_class, int error);
>  void xfs_force_summary_recalc(struct xfs_mount *mp);
> +int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
> +bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
>  void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
>  
>  #endif	/* __XFS_MOUNT_H__ */


-- 
chandan
