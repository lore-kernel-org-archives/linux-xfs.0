Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625C3C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 15:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E35206B2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 15:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTqXGD3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgIQPsk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:48:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54978 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727959AbgIQPrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 11:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600357628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OcvN5J9dbBovV+OeYR2cq5R4aoKJIpuKCzvSRuCwsBI=;
        b=BTqXGD3EqORlKdwXIBsRwNc3pD32iZ1HSjZtTx9JC6QPAjv1OMNUwW3HklufXanoPZLHiv
        P0ITjzpKzuE5F3t/1J2Vyq4EC5I4baYzJcPEhWFmBCtqq0zfwnNZNUpeKsIB69fXFpg/wU
        oK2wzqZHU+VM8raLCoYJetcbh7rv6fI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-m1Ol_j7TM0SZ0B3o44tM4w-1; Thu, 17 Sep 2020 11:28:34 -0400
X-MC-Unique: m1Ol_j7TM0SZ0B3o44tM4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B90F21018724;
        Thu, 17 Sep 2020 15:28:33 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CCBF19930;
        Thu, 17 Sep 2020 15:28:32 +0000 (UTC)
Date:   Thu, 17 Sep 2020 11:28:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: use the log grant push threshold to decide if
 we're going to relog deferred items
Message-ID: <20200917152829.GC1874815@bfoster>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
 <160031340936.3624707.125940597283537162.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031340936.3624707.125940597283537162.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:30:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've landed a means for the defer ops manager to ask log items
> to relog themselves to move the log tail forward, we can improve how we
> decide when to relog so that we're not just using an arbitrary hardcoded
> value.
> 
> The XFS log has "push threshold", which tells us how far we'd have to
> move the log tail forward to keep 25% of the ondisk log space available.
> We use this threshold to decide when to force defer ops chains to relog
> themselves.  This avoids unnecessary relogging (which adds extra steps
> to metadata updates) while helping us to avoid pinning the tail.
> 
> A better algorithm would be to relog only when we detect that the time
> required to move the tail forward is greater than the time remaining
> before all the log space gets used up, but letting the upper levels
> drive the relogging means that it is difficult to coordinate relogging
> the lowest LSN'd intents first.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

FYI, the commit log doesn't match the git branch referenced in the cover
letter.

>  fs/xfs/libxfs/xfs_defer.c |   32 +++++++++++++++++++++++++-------
>  fs/xfs/xfs_log.c          |   41 +++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_log.h          |    2 ++
>  3 files changed, 58 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 7938e4d3af90..97ec36f32a0a 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -17,6 +17,7 @@
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> +#include "xfs_log.h"
>  
>  /*
>   * Deferred Operations in XFS
> @@ -372,15 +373,35 @@ xfs_defer_relog(
>  	struct list_head		*dfops)
>  {
>  	struct xfs_defer_pending	*dfp;
> +	xfs_lsn_t			threshold_lsn;
>  
>  	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
> +	/*
> +	 * Figure out where we need the tail to be in order to maintain the
> +	 * minimum required free space in the log.
> +	 */
> +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> +	if (threshold_lsn == NULLCOMMITLSN)
> +		return 0;
> +
>  	list_for_each_entry(dfp, dfops, dfp_list) {
> +		/*
> +		 * If the log intent item for this deferred op is behind the
> +		 * threshold, we're running out of space and need to relog it
> +		 * to release the tail.
> +		 */
> +		if (dfp->dfp_intent == NULL ||

Any reason the NULL check isn't in the previous patch?

> +		    XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) < 0)
> +			continue;
> +

Logic looks backwards, we should relog (not skip) if li_lsn is within
the threshold, right?

>  		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
>  		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
>  	}
>  
> -	return xfs_defer_trans_roll(tpp);
> +	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
> +		return xfs_defer_trans_roll(tpp);

I suspect this churn is eliminated if this code uses the threshold logic
from the start..

> +	return 0;
>  }
>  
>  /*
> @@ -444,7 +465,6 @@ xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> -	unsigned int			nr_rolls = 0;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -471,11 +491,9 @@ xfs_defer_finish_noroll(
>  			goto out_shutdown;
>  
>  		/* Every few rolls we relog all the intent items. */
> -		if (!(++nr_rolls % 7)) {
> -			error = xfs_defer_relog(tp, &dop_pending);
> -			if (error)
> -				goto out_shutdown;
> -		}
> +		error = xfs_defer_relog(tp, &dop_pending);
> +		if (error)
> +			goto out_shutdown;
>  
>  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>  				       dfp_list);
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ad0c69ee8947..62c9e0aaa7df 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1475,14 +1475,15 @@ xlog_commit_record(
>  }
>  
>  /*
> - * Push on the buffer cache code if we ever use more than 75% of the on-disk
> - * log space.  This code pushes on the lsn which would supposedly free up
> - * the 25% which we want to leave free.  We may need to adopt a policy which
> - * pushes on an lsn which is further along in the log once we reach the high
> - * water mark.  In this manner, we would be creating a low water mark.
> + * Compute the LSN push target needed to push on the buffer cache code if we
> + * ever use more than 75% of the on-disk log space.  This code pushes on the
> + * lsn which would supposedly free up the 25% which we want to leave free.  We
> + * may need to adopt a policy which pushes on an lsn which is further along in
> + * the log once we reach the high water mark.  In this manner, we would be
> + * creating a low water mark.
>   */
> -STATIC void
> -xlog_grant_push_ail(
> +xfs_lsn_t
> +xlog_grant_push_threshold(
>  	struct xlog	*log,
>  	int		need_bytes)
>  {
> @@ -1508,7 +1509,7 @@ xlog_grant_push_ail(
>  	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
>  	free_threshold = max(free_threshold, 256);
>  	if (free_blocks >= free_threshold)
> -		return;
> +		return NULLCOMMITLSN;
>  
>  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
>  						&threshold_block);
> @@ -1528,13 +1529,33 @@ xlog_grant_push_ail(
>  	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
>  		threshold_lsn = last_sync_lsn;
>  
> +	return threshold_lsn;
> +}
> +
> +/*
> + * Push on the buffer cache code if we ever use more than 75% of the on-disk
> + * log space.  This code pushes on the lsn which would supposedly free up
> + * the 25% which we want to leave free.  We may need to adopt a policy which
> + * pushes on an lsn which is further along in the log once we reach the high
> + * water mark.  In this manner, we would be creating a low water mark.
> + */
> +STATIC void
> +xlog_grant_push_ail(
> +	struct xlog	*log,
> +	int		need_bytes)
> +{
> +	xfs_lsn_t	threshold_lsn;
> +
> +	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> +	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
> +		return;
> +
>  	/*
>  	 * Get the transaction layer to kick the dirty buffers out to
>  	 * disk asynchronously. No point in trying to do this if
>  	 * the filesystem is shutting down.
>  	 */
> -	if (!XLOG_FORCED_SHUTDOWN(log))
> -		xfs_ail_push(log->l_ailp, threshold_lsn);
> +	xfs_ail_push(log->l_ailp, threshold_lsn);
>  }

Separate refactoring patch for the xfs_log.c bits, please.

Brian

>  
>  /*
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 1412d6993f1e..58c3fcbec94a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -141,4 +141,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  bool	xfs_log_in_recovery(struct xfs_mount *);
>  
> +xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> +
>  #endif	/* __XFS_LOG_H__ */
> 

