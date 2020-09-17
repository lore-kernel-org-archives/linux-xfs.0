Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AC7C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD5C220684
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIQGLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 02:11:52 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53674 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgIQGLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 02:11:52 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D5F93826575;
        Thu, 17 Sep 2020 16:11:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIn92-0001cL-N4; Thu, 17 Sep 2020 16:11:48 +1000
Date:   Thu, 17 Sep 2020 16:11:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: periodically relog deferred intent items
Message-ID: <20200917061148.GH12131@dread.disaster.area>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
 <160031340007.3624707.16729315375941677948.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031340007.3624707.16729315375941677948.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=2W51ztwRv_2d4vuv50MA:9 a=epvQ2Cv-clFS5LTL:21 a=GRkTPkJwr5N76rzy:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:30:00PM -0700, Darrick J. Wong wrote:
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
> periodically so that we can always move the log tail forward.  We do
> this every seven loops, having observed that while most chains never
> exceed seven items in length, the rest go far over that and seem to
> be involved in most of the stall problems.
> 
> Callers are now required to ensure that the transaction reservation is
> large enough to handle logging done items and new intent items for the
> maximum possible chain length.  Most callers are careful to keep the
> chain lengths low, so the overhead should be minimal.
> 
> (Note that in the next patch we'll make it so that we only relog on
> demand, since 7 is an arbitrary number that I used here to get the basic
> mechanics working.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   30 ++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_item.c     |   25 +++++++++++++++++++++++++
>  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++++++
>  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h         |    1 +
>  fs/xfs/xfs_trans.h         |   10 ++++++++++
>  7 files changed, 149 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 84a70edd0da1..7938e4d3af90 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -361,6 +361,28 @@ xfs_defer_cancel_list(
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
> +
> +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> +
> +	list_for_each_entry(dfp, dfops, dfp_list) {
> +		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> +		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);

Any reason for xfs_trans_item_relog() when it's a one liner?

> +	}
> +
> +	return xfs_defer_trans_roll(tpp);
> +}
> +
>  /*
>   * Log an intent-done item for the first pending intent, and finish the work
>   * items.
> @@ -422,6 +444,7 @@ xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> +	unsigned int			nr_rolls = 0;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -447,6 +470,13 @@ xfs_defer_finish_noroll(
>  		if (error)
>  			goto out_shutdown;
>  
> +		/* Every few rolls we relog all the intent items. */
> +		if (!(++nr_rolls % 7)) {
> +			error = xfs_defer_relog(tp, &dop_pending);
> +			if (error)
> +				goto out_shutdown;
> +		}

Urk.

I think I've got a better idea: rather than a counter, use something
meaningful as to whether the intent has been committed or not. e.g.
use something like xfs_log_item_in_current_chkpt() to determine if
we need to relog the intent.

i.e. If the intent is active in the CIL, then we don't need to relog
it. If the intent has been committed to the journal and is no longer
in the CIL list, relog it so the next CIL push will move it forward
in the journal.

The intent relogging functions look fine, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
