Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89C7C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A44239EB
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgI0XI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:08:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35439 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgI0XI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:08:27 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 93461825F0F;
        Mon, 28 Sep 2020 09:08:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMfmJ-0003q8-Aq; Mon, 28 Sep 2020 09:08:23 +1000
Date:   Mon, 28 Sep 2020 09:08:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200927230823.GA14422@dread.disaster.area>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160083919968.1401135.1020138085396332868.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=mP9b5-8OECr-va5RstUA:9 a=zvfFNVJwTFR9YhDh:21 a=c5Hm-UcGQGQaY0H3:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's a subtle design flaw in the deferred log item code that can lead
> to pinning the log tail.  Taking up the defer ops chain examples from
> the previous commit, we can get trapped in sequences like this:
> 
> Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> chain will look like the following if the transaction rolls succeed:
> 
> t1: D0(t0), D1(t0), D2(t0), D3(t0)
> t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> t3: d5(t1), D1(t0), D2(t0), D3(t0)
> ...
> t9: d9(t7), D3(t0)
> t10: D3(t0)
> t11: d10(t10), d11(t10)
> t12: d11(t10)
> 
> In transaction 9, we finish d9 and try to roll to t10 while holding onto
> an intent item for D3 that we logged in t0.
> 
> The previous commit changed the order in which we place new defer ops in
> the defer ops processing chain to reduce the maximum chain length.  Now
> make xfs_defer_finish_noroll capable of relogging the entire chain
> periodically so that we can always move the log tail forward.  Most
> chains will never get relogged, except for operations that generate very
> long chains (large extents containing many blocks with different sharing
> levels) or are on filesystems with small logs and a lot of ongoing
> metadata updates.
> 
> Callers are now required to ensure that the transaction reservation is
> large enough to handle logging done items and new intent items for the
> maximum possible chain length.  Most callers are careful to keep the
> chain lengths low, so the overhead should be minimal.
> 
> The decision to relog an intent item is made based on whether or not the
> intent was added to the current checkpoint.  If so, the checkpoint is
> still open and there's no point in relogging.  Otherwise, the old
> checkpoint is closed and we relog the intent to add it to the current
> one.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++
>  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++
>  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++
>  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++
>  fs/xfs/xfs_trace.h         |    1 +
>  fs/xfs/xfs_trans.h         |   10 ++++++++
>  7 files changed, 173 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 84a70edd0da1..c601cc2af254 100644
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
> @@ -361,6 +362,52 @@ xfs_defer_cancel_list(
>  	}
>  }
>  
> +/*
> + * Prevent a log intent item from pinning the tail of the log by logging a
> + * done item to release the intent item; and then log a new intent item.
> + * The caller should provide a fresh transaction and roll it after we're done.
> + */
> +static int
> +xfs_defer_relog(
> +	struct xfs_trans		**tpp,
> +	struct list_head		*dfops)
> +{
> +	struct xfs_defer_pending	*dfp;
> +	xfs_lsn_t			threshold_lsn;
> +
> +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> +
> +	/*
> +	 * Figure out where we need the tail to be in order to maintain the
> +	 * minimum required free space in the log.
> +	 */
> +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> +	if (threshold_lsn == NULLCOMMITLSN)
> +		return 0;

This smells of premature optimisation.

When we are in a tail-pushing scenario (i.e. any sort of
sustained metadata workload) this will always return true, and so we
will relog every intent that isn't in the current checkpoint every
time this is called.  Under light load, we don't care if we add a
little bit of relogging overhead as the CIL slowly flushes/pushes -
it will have neglible impact on performance because there is little
load on the journal.

However, when we are under heavy load the code will now be reading
the grant head and log position accounting variables during every
commit, hence greatly increasing the number and temporal
distribution of accesses to the hotest cachelines in the log. We
currently never access these cache lines during commit unless the
unit reservation has run out and we have to regrant physical log
space for the transaction to continue (i.e. we are into slow path
commit code). IOWs, this is like causing far more than double the
number of accesses to the grant head, the log tail, the
last_sync_lsn, etc, all of which is unnecessary exactly when we care
about minimising contention on the log space accounting variables...

Given that it is a redundant check under heavy load journal load
when access to the log grant/head/tail are already contended,
I think we should just be checking the "in current checkpoint" logic
and not making it conditional on the log being near full.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
