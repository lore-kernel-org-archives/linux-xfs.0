Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145F3C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 23:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiGKXrV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKXrU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 19:47:20 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BB2828E11
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 16:47:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7073162C808;
        Tue, 12 Jul 2022 09:47:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB37V-00HO9k-FO; Tue, 12 Jul 2022 09:47:17 +1000
Date:   Tue, 12 Jul 2022 09:47:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: l_last_sync_lsn is really tracking AIL state
Message-ID: <20220711234717.GF3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-5-david@fromorbit.com>
 <YsvGbJBvk2QB0168@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsvGbJBvk2QB0168@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62ccb687
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=0jiTdjcmfmMYYZye1PEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 11:42:52PM -0700, Christoph Hellwig wrote:
> On Fri, Jul 08, 2022 at 11:55:54AM +1000, Dave Chinner wrote:
> > +		/*
> > +		 * If there are no callbacks on this iclog, we can mark it clean
> > +		 * immediately and return. Otherwise we need to run the
> > +		 * callbacks.
> > +		 */
> > +		if (list_empty(&iclog->ic_callbacks)) {
> > +			xlog_state_clean_iclog(log, iclog);
> > +			return false;
> > +		}
> > +		trace_xlog_iclog_callback(iclog, _RET_IP_);
> > +		iclog->ic_state = XLOG_STATE_CALLBACK;
> 
> Can you split the optimization of skipping the XLOG_STATE_CALLBACK
> state out?  It seems unrelated to the rest and really confused me
> when trying to understand this patch. 

OK.

> 
> > +static inline void
> > +xfs_ail_assign_tail_lsn(
> > +	struct xfs_ail		*ailp)
> > +{
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	xfs_ail_update_tail_lsn(ailp);
> > +	spin_unlock(&ailp->ail_lock);
> > +}
> 
> This naming scheme seems a lot more confusing than the old _locked
> suffix or the __ prefix.

Easy enough.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
