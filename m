Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46E3C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 11:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8691B229C7
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 11:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgLHLUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 06:20:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726755AbgLHLUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 06:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607426351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LoZWfXkZQX4bADO/USq06+OFZi14/M8Wsn6DiA0cWEc=;
        b=OvOLIMtZ0QnZbEQHXuWCryyyoWXErpGDjOzgvTyZdVngg3pb8B3mGgfr6VPwwEz0M9r9fc
        ZEExdD9iWIKw2UqY5lxDqNsW5kDIQrryjFHyFeZ5qBq6rxZSgnXZDsnUYBuXm5C+1s6s0u
        1jl+IVRu+x48H5thPVl9rIRf/iCq0yE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-K4Vef0XMPcC4b4g888Y-mw-1; Tue, 08 Dec 2020 06:19:09 -0500
X-MC-Unique: K4Vef0XMPcC4b4g888Y-mw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EA1E107ACF8;
        Tue,  8 Dec 2020 11:19:08 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BA9E5D9E2;
        Tue,  8 Dec 2020 11:19:08 +0000 (UTC)
Date:   Tue, 8 Dec 2020 06:19:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201208111906.GA1679681@bfoster>
References: <20201208004028.GU629293@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208004028.GU629293@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 04:40:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
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
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> Note: I wrote this so that we could turn on log incompat flags for
> atomic extent swapping and Allison could probably use it for the delayed
> logged xattr patchset.  Not gonna try to land this in 5.11, FWIW...
> ---
>  fs/xfs/libxfs/xfs_format.h |   15 ++++++
>  fs/xfs/xfs_log.c           |    8 +++
>  fs/xfs/xfs_mount.c         |  119 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.h         |    2 +
>  fs/xfs/xfs_super.c         |    9 +++
>  5 files changed, 153 insertions(+)
> 
...
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 669a9cf43582..68a5c90ec65b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
...
> @@ -1361,6 +1369,117 @@ xfs_force_summary_recalc(
>  	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
>  }
>  
> +/*
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

Do we need to do all of this serialization and whatnot to set the
incompat bit? Can we just modify and log the in-core sb when or before
an incompatible item is logged, similar to how xfs_sbversion_add_attr2()
is implemented for example?

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
> + * The caller must have freeze protection, cannot have any other transactions
> + * in progress, must ensure that the log does not contain any log items
> + * protected by any log incompat bit, and must ensure that there are no other
> + * threads that could be reading or writing the log incompat feature flag in
> + * the primary super.  In other words, we can only turn features off as one of
> + * the final steps of quiescing or unmounting the log.
> + */
> +int
> +xfs_clear_incompat_log_features(
> +	struct xfs_mount	*mp)
> +{
> +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> +	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
> +	    XFS_FORCED_SHUTDOWN(mp))
> +		return 0;
> +
> +	/*
> +	 * Update the incore superblock.  We synchronize on the primary super
> +	 * buffer lock to be consistent with the add function, though at least
> +	 * in theory this shouldn't be necessary.
> +	 */
> +	xfs_buf_lock(mp->m_sb_bp);
> +	xfs_buf_hold(mp->m_sb_bp);
> +
> +	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
> +		goto rele;
> +
> +	xfs_sb_remove_incompat_log_features(&mp->m_sb);
> +	xfs_buf_relse(mp->m_sb_bp);
> +
> +	/* Log the superblock to disk. */
> +	return xfs_sync_sb(mp, false);

Ok, so here it looks like we log the superblock change and presumably
rely on the unmount sequence to write it back...

> +rele:
> +	xfs_buf_relse(mp->m_sb_bp);
> +	return 0;
> +}
> +
>  /*
>   * Update the in-core delayed block counter.
>   *
...
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 343435a677f9..71e304c15e6b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -919,6 +919,15 @@ xfs_quiesce_attr(
>  	/* force the log to unpin objects from the now complete transactions */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> +	/*
> +	 * Clear log incompat features since we're freezing or remounting ro.
> +	 * Report failures, though it's not fatal to have a higher log feature
> +	 * protection level than the log contents actually require.
> +	 */
> +	error = xfs_clear_incompat_log_features(mp);
> +	if (error)
> +		xfs_warn(mp, "Unable to clear superblock log incompat flags. "
> +				"Frozen image may not be consistent.");
>  

What happens if the modified superblock is written back and then we
crash during a quiesce but before the log is fully clean? ISTM we could
end up in recovery of a log with potentially incompatible log items
where the feature bit has already been cleared. Not sure that's a
problem with intents, but seems risky in general.

Perhaps this needs to be pushed further down such that similar to
unmount, we ensure a full/sync AIL push completes (and moves the in-core
tail) before we log the feature bit change. I do wonder if it's worth
complicating the log quiesce path to clear feature bits at all, but I
suppose it could be a little inconsistent to clean the log on freeze yet
leave an incompat bit around. Perhaps we should push the clear bit
sequence down into the log quiesce path between completing the AIL push
and writing the unmount record. We may have to commit a sync transaction
and then push the AIL again, but that would cover the unmount and freeze
cases and I think we could probably do away with the post-recovery bit
clearing case entirely. A current/recovered mount should clear the
associated bits on the next log quiesce anyways. Hm?

Brian

>  	/* Push the superblock and write an unmount record */
>  	error = xfs_log_sbcount(mp);
> 

