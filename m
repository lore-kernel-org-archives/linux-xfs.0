Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66496C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 23:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiGKXmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGKXmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 19:42:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8790B27FEC
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 16:42:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5C46C10E7FAF;
        Tue, 12 Jul 2022 09:42:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB32T-00HO6Q-4i; Tue, 12 Jul 2022 09:42:05 +1000
Date:   Tue, 12 Jul 2022 09:42:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: ensure log tail is always up to date
Message-ID: <20220711234205.GE3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-4-david@fromorbit.com>
 <Ysu+PPbq41DKByAw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysu+PPbq41DKByAw@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62ccb54e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=gbBYXTYLHQkj-5tzA6QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 11:07:56PM -0700, Christoph Hellwig wrote:
> On Fri, Jul 08, 2022 at 11:55:53AM +1000, Dave Chinner wrote:
> >  	lockdep_assert_held(&log->l_icloglock);
> > @@ -544,7 +543,7 @@ xlog_state_release_iclog(
> >  	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> >  	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
> >  	    !iclog->ic_header.h_tail_lsn) {
> > -		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> > +		xfs_lsn_t tail_lsn = atomic64_read(&log->l_tail_lsn);
> >  		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> 
> Nit: I'd just do this as:
> 
> 		iclog->ic_header.h_tail_lsn =
> 			cpu_to_be64(atomic64_read(&log->l_tail_lsn));
> 
> > +/*
> > + * Callers should pass the the original tail lsn so that we can detect if the
> > + * tail has moved as a result of the operation that was performed. If the caller
> > + * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
> > + * "did the tail LSN change?" checks.
> > + */
> 
> Should we also document the old_lsn == 0 case here?

I can, it's just the "tail did not change" value....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
