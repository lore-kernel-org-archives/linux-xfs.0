Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641B0C3A5AA
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 19:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4028222CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 19:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfIDTep (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbfIDTep (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 15:34:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA3AECF22;
        Wed,  4 Sep 2019 19:34:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7442B614C1;
        Wed,  4 Sep 2019 19:34:44 +0000 (UTC)
Date:   Wed, 4 Sep 2019 15:34:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190904193442.GA52970@bfoster>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-8-david@fromorbit.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 04 Sep 2019 19:34:44 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 02:24:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the log fills up, we can get into the state where the
> outstanding items in the CIL being committed and aggregated are
> larger than the range that the reservation grant head tail pushing
> will attempt to clean. This can result in the tail pushing range
> being trimmed back to the the log head (l_last_sync_lsn) and so
> may not actually move the push target at all.
> 
> When the iclogs associated with the CIL commit finally land, the
> log head moves forward, and this removes the restriction on the AIL
> push target. However, if we already have transactions sleeping on
> the grant head, and there's nothing in the AIL still to flush from
> the current push target, then nothing will move the tail of the log
> and trigger a log reservation wakeup.
> 
> Hence the there is nothing that will trigger xlog_grant_push_ail()
> to recalculate the AIL push target and start pushing on the AIL
> again to write back the metadata objects that pin the tail of the
> log and hence free up space and allow the transaction reservations
> to be woken and make progress.
> 
> Hence we need to push on the grant head when we move the log head
> forward, as this may be the only trigger we have that can move the
> AIL push target forwards in this situation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 72 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6a59d71d4c60..733693e1ac9f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2632,6 +2632,46 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> +/*
> + * Completion of a iclog IO does not imply that a transaction has completed, as
> + * transactions can be large enough to span many iclogs. We cannot change the
> + * tail of the log half way through a transaction as this may be the only
> + * transaction in the log and moving the tail to point to the middle of it
> + * will prevent recovery from finding the start of the transaction. Hence we
> + * should only update the last_sync_lsn if this iclog contains transaction
> + * completion callbacks on it.
> + *
> + * We have to do this before we drop the icloglock to ensure we are the only one
> + * that can update it.
> + *
> + * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> + * the reservation grant head pushing. This is due to the fact that the push
> + * target is bound by the current last_sync_lsn value. Hence if we have a large
> + * amount of log space bound up in this committing transaction then the
> + * last_sync_lsn value may be the limiting factor preventing tail pushing from
> + * freeing space in the log. Hence once we've updated the last_sync_lsn we
> + * should push the AIL to ensure the push target (and hence the grant head) is
> + * no longer bound by the old log head location and can move forwards and make
> + * progress again.
> + */
> +static void
> +xlog_state_set_callback(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	xfs_lsn_t		header_lsn)
> +{
> +	iclog->ic_state = XLOG_STATE_CALLBACK;
> +
> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn), header_lsn) <= 0);
> +
> +	if (list_empty_careful(&iclog->ic_callbacks))
> +		return;
> +
> +	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> +	xlog_grant_push_ail(log, 0);
> +

Nit: extra whitespace line above.

This still seems racy to me, FWIW. What if the AIL is empty (i.e. the
push is skipped)? What if xfsaild completes this push before the
associated log items land in the AIL or we race with xfsaild emptying
the AIL? Why not just reuse/update the existing grant head wake up logic
in the iclog callback itself? E.g., something like the following
(untested):

@@ -740,12 +740,10 @@ xfs_trans_ail_update_bulk(
 	if (mlip_changed) {
 		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
 			xlog_assign_tail_lsn_locked(ailp->ail_mount);
-		spin_unlock(&ailp->ail_lock);
-
-		xfs_log_space_wake(ailp->ail_mount);
-	} else {
-		spin_unlock(&ailp->ail_lock);
 	}
+
+	spin_unlock(&ailp->ail_lock);
+	xfs_log_space_wake(ailp->ail_mount);
}

... seems to solve the same prospective problem without being racy and
with less and more simple code. Hm?

Brian

> +}
> +
>  /*
>   * Return true if we need to stop processing, false to continue to the next
>   * iclog. The caller will need to run callbacks if the iclog is returned in the
> @@ -2644,6 +2684,7 @@ xlog_state_iodone_process_iclog(
>  	struct xlog_in_core	*completed_iclog)
>  {
>  	xfs_lsn_t		lowest_lsn;
> +	xfs_lsn_t		header_lsn;
>  
>  	/* Skip all iclogs in the ACTIVE & DIRTY states */
>  	if (iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))
> @@ -2681,34 +2722,15 @@ xlog_state_iodone_process_iclog(
>  	 * callbacks) see the above if.
>  	 *
>  	 * We will do one more check here to see if we have chased our tail
> -	 * around.
> +	 * around. If this is not the lowest lsn iclog, then we will leave it
> +	 * for another completion to process.
>  	 */
> +	header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  	lowest_lsn = xlog_get_lowest_lsn(log);
> -	if (lowest_lsn &&
> -	    XFS_LSN_CMP(lowest_lsn, be64_to_cpu(iclog->ic_header.h_lsn)) < 0)
> -		return false; /* Leave this iclog for another thread */
> -
> -	iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -	/*
> -	 * Completion of a iclog IO does not imply that a transaction has
> -	 * completed, as transactions can be large enough to span many iclogs.
> -	 * We cannot change the tail of the log half way through a transaction
> -	 * as this may be the only transaction in the log and moving th etail to
> -	 * point to the middle of it will prevent recovery from finding the
> -	 * start of the transaction.  Hence we should only update the
> -	 * last_sync_lsn if this iclog contains transaction completion callbacks
> -	 * on it.
> -	 *
> -	 * We have to do this before we drop the icloglock to ensure we are the
> -	 * only one that can update it.
> -	 */
> -	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -			be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
> -	if (!list_empty_careful(&iclog->ic_callbacks))
> -		atomic64_set(&log->l_last_sync_lsn,
> -			be64_to_cpu(iclog->ic_header.h_lsn));
> +	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
> +		return false;
>  
> +	xlog_state_set_callback(log, iclog, header_lsn);
>  	return false;
>  
>  }
> -- 
> 2.23.0.rc1
> 
