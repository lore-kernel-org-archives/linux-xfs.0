Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF4CC07E95
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 02:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E982F613C2
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 02:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhGECYl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jul 2021 22:24:41 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60109 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhGECYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jul 2021 22:24:41 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id C620F687A3;
        Mon,  5 Jul 2021 12:22:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m0EFF-002rpf-Tc; Mon, 05 Jul 2021 12:22:01 +1000
Date:   Mon, 5 Jul 2021 12:22:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: log head and tail aren't reliable during
 shutdown
Message-ID: <20210705022201.GL664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-10-david@fromorbit.com>
 <YN7T+6ozxZxAvfjZ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7T+6ozxZxAvfjZ@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=gfbzYfMUp_Vy8kkQtuYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 09:53:15AM +0100, Christoph Hellwig wrote:
> > +	if (tail_cycle == head_cycle && head_bytes >= tail_bytes) {
> > +		return log->l_logsize - (head_bytes - tail_bytes);
> > +	} else if (tail_cycle + 1 < head_cycle) {
> >  		return 0;
> > +	} else if (xlog_is_shutdown(log)) {
> > +		/* Ignore potential inconsistency when shutdown. */
> > +		return log->l_logsize;
> > +	} else if (tail_cycle < head_cycle) {
> >  		ASSERT(tail_cycle == (head_cycle - 1));
> > +		return tail_bytes - head_bytes;
> >  	}
> 
> Drop the else after the returns to make this a little easier to follow:
> 
> 	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
> 		return log->l_logsize - (head_bytes - tail_bytes);
> 	if (tail_cycle + 1 < head_cycle)
> 		return 0;
> 
> 	/* Ignore potential inconsistency when shutdown. */
> 	if (xlog_is_shutdown(log)) {
> 		return log->l_logsize;
> 
> 	if (tail_cycle < head_cycle) {
> 		ASSERT(tail_cycle == (head_cycle - 1));
> 		return tail_bytes - head_bytes;
> 	}

Yup, that's better. I'll fix it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
