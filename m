Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C444C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 17:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4909E2342F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 17:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfH3RYu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 13:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfH3RYu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 13:24:50 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B268756;
        Fri, 30 Aug 2019 17:24:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87D4E5D784;
        Fri, 30 Aug 2019 17:24:49 +0000 (UTC)
Date:   Fri, 30 Aug 2019 13:24:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandan@linux.ibm.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190830172447.GE26520@bfoster>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
 <3457989.EyS6152c1k@localhost.localdomain>
 <20190826003253.GK1119@dread.disaster.area>
 <783535067.D5oYYkGoWf@localhost.localdomain>
 <20190829230817.GW1119@dread.disaster.area>
 <20190830003441.GY1119@dread.disaster.area>
 <20190830021329.GB1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830021329.GB1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 30 Aug 2019 17:24:50 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 12:13:29PM +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2019 at 10:34:41AM +1000, Dave Chinner wrote:
> > On Fri, Aug 30, 2019 at 09:08:17AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 29, 2019 at 10:51:59AM +0530, Chandan Rajendra wrote:
> > > > 	 786576: kworker/4:1H-kb  1825 [004]   217.041079:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> > > 
> > > 200ms later the tail has moved, and last_sync_lsn is now 3/18501.
> > > i.e. the iclog writes have made it to disk, and the items have been
> > > moved into the AIL. I don't know where that came from, but I'm
> > > assuming it's an IO completion based on it being run from a
> > > kworker context that doesn't have an "xfs-" name prefix(*).
> > > 
> > > As the tail has moved, this should have woken the anything sleeping
> > > on the log tail in xlog_grant_head_wait() via a call to
> > > xfs_log_space_wake(). The first waiter should wake, see that there
> > > still isn't room in the log (only 3 sectors were freed in the log,
> > > we need at least 60). That woken process should then run
> > > xlog_grant_push_ail() again and go back to sleep.
> > 
> > Actually, it doesn't get woken because xlog_grant_head_wake() checks
> > how much space is available before waking waiters, and there clearly
> > isn't enough here. So that's one likely vector. Can you try this
> > patch?
> 
> And this one on top to address the situation the previous patch
> doesn't....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: push the grant head when the log head moves forward
> 
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
>  fs/xfs/xfs_log.c | 65 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 40 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 941f10ff99d9..ce46bb244442 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2612,6 +2612,45 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> +
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
> +xlog_iclog_iodone(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +{
> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> +		be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
> +
> +	if (list_empty_careful(&iclog->ic_callbacks))
> +		return;
> +
> +	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(iclog->ic_header.h_lsn));
> +	xlog_grant_push_ail(log, 0);

I think the intent of the patch makes sense but the wakeup is misplaced.
First, this wakeup technically occurs before AIL population because we
haven't invoked the iclog callbacks yet. Second, your first patch
already adds an AIL push in the log I/O completion path via
xfs_trans_ail_update_bulk() -> xfs_log_space_wake(). The problem may
just be that it's only invoked on tail changes and not empty ->
populated state changes. If so, that could be addressed with a check for
mlip == NULL in xfs_trans_ail_update_bulk().

(Actually, the first patch alone seems to be enough to prevent the
problem in my tests. I suppose I could be seeing a variation of the race
from what Chandan sees and a wakeup from the second CIL ctx ticket
release or something is saving me...).

Brian

> +
> +}
> +
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log,
> @@ -2710,31 +2749,7 @@ xlog_state_do_callback(
>  				}
>  
>  				iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -
> -				/*
> -				 * Completion of a iclog IO does not imply that
> -				 * a transaction has completed, as transactions
> -				 * can be large enough to span many iclogs. We
> -				 * cannot change the tail of the log half way
> -				 * through a transaction as this may be the only
> -				 * transaction in the log and moving th etail to
> -				 * point to the middle of it will prevent
> -				 * recovery from finding the start of the
> -				 * transaction. Hence we should only update the
> -				 * last_sync_lsn if this iclog contains
> -				 * transaction completion callbacks on it.
> -				 *
> -				 * We have to do this before we drop the
> -				 * icloglock to ensure we are the only one that
> -				 * can update it.
> -				 */
> -				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
> -				if (!list_empty_careful(&iclog->ic_callbacks))
> -					atomic64_set(&log->l_last_sync_lsn,
> -						be64_to_cpu(iclog->ic_header.h_lsn));
> -
> +				xlog_iclog_iodone(log, iclog);
>  			} else
>  				ioerrors++;
>  
