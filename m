Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6FDC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA25208DB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgIQE7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:59:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47193 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbgIQE7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:59:05 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8EEE7825D26;
        Thu, 17 Sep 2020 14:58:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIm0W-0001Qv-TX; Thu, 17 Sep 2020 14:58:56 +1000
Date:   Thu, 17 Sep 2020 14:58:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: log new intent items created as part of
 finishing recovered intent items
Message-ID: <20200917045856.GD12131@dread.disaster.area>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031332982.3624373.6230830770363563010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031332982.3624373.6230830770363563010.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=5flnDyzRKi93cCsh7YIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During a code inspection, I found a serious bug in the log intent item
> recovery code when an intent item cannot complete all the work and
> decides to requeue itself to get that done.  When this happens, the
> item recovery creates a new incore deferred op representing the
> remaining work and attaches it to the transaction that it allocated.  At
> the end of _item_recover, it moves the entire chain of deferred ops to
> the dummy parent_tp that xlog_recover_process_intents passed to it, but
> fail to log a new intent item for the remaining work before committing
> the transaction for the single unit of work.
> 
> xlog_finish_defer_ops logs those new intent items once recovery has
> finished dealing with the intent items that it recovered, but this isn't
> sufficient.  If the log is forced to disk after a recovered log item
> decides to requeue itself and the system goes down before we call
> xlog_finish_defer_ops, the second log recovery will never see the new
> intent item and therefore has no idea that there was more work to do.
> It will finish recovery leaving the filesystem in a corrupted state.
> 
> The same logic applies to /any/ deferred ops added during intent item
> recovery, not just the one handling the remaining work.

Yup, that looks like a problem.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   26 ++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_defer.h  |    6 ++++++
>  fs/xfs/xfs_bmap_item.c     |    2 +-
>  fs/xfs/xfs_refcount_item.c |    2 +-
>  4 files changed, 32 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index d8f586256add..29e9762f3b77 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,8 +186,9 @@ xfs_defer_create_intent(
>  {
>  	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
>  
> -	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
> -			dfp->dfp_count, sort);
> +	if (!dfp->dfp_intent)
> +		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
> +						     dfp->dfp_count, sort);
>  }
>  
>  /*
> @@ -390,6 +391,7 @@ xfs_defer_finish_one(
>  			list_add(li, &dfp->dfp_work);
>  			dfp->dfp_count++;
>  			dfp->dfp_done = NULL;
> +			dfp->dfp_intent = NULL;
>  			xfs_defer_create_intent(tp, dfp, false);
>  		}
>  
> @@ -552,3 +554,23 @@ xfs_defer_move(
>  
>  	xfs_defer_reset(stp);
>  }
> +
> +/*
> + * Prepare a chain of fresh deferred ops work items to be completed later.  Log
> + * recovery requires the ability to put off until later the actual finishing
> + * work so that it can process unfinished items recovered from the log in
> + * correct order.
> + *
> + * Create and log intent items for all the work that we're capturing so that we
> + * can be assured that the items will get replayed if the system goes down
> + * before log recovery gets a chance to finish the work it put off.  Then we
> + * move the chain from stp to dtp.
> + */
> +void
> +xfs_defer_capture(
> +	struct xfs_trans	*dtp,
> +	struct xfs_trans	*stp)
> +{
> +	xfs_defer_create_intents(stp);
> +	xfs_defer_move(dtp, stp);
> +}

Not sold on the "capture" name, but it'll do for now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
