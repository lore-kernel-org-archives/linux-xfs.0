Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B77C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDA8207D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgETBED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:04:03 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41245 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgETBEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:04:02 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 49EB110A60C;
        Wed, 20 May 2020 11:03:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbD9G-0001PW-Ks; Wed, 20 May 2020 11:03:54 +1000
Date:   Wed, 20 May 2020 11:03:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200520010354.GR2040@dread.disaster.area>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
 <20200119204925.GC9407@dread.disaster.area>
 <20200203201445.GA6870@magnolia>
 <20200507103232.GB9003@bfoster>
 <20200514163317.GA6714@magnolia>
 <20200514174448.GE50849@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514174448.GE50849@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=YslsDvKLH7J8-tQztigA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 01:44:48PM -0400, Brian Foster wrote:
> On Thu, May 14, 2020 at 09:33:17AM -0700, Darrick J. Wong wrote:
> ISTM that the right thing to do here is merge this patch, finally fix
> the last known stale data exposure vector, and then perhaps step back
> and think about how we might improve performance of unwritten extents
> (or whatever alternate scheme to avoid stale data exposure we might
> think up) regardless of allocation policy or write path. That might even
> make a decent side topic associated with the SSD allocation policy topic
> proposal Dave recently posted.
> 
> It looks like Christoph already reviewed the patch. I'm not sure if his
> opinion changed it all after the subsequent discussion, but otherwise
> that just leaves Dave's objection. Dave, any thoughts on this given the
> test results and broader context? What do you think about getting this
> patch merged and revisiting the whole unwritten extent thing
> independently?

I guess when we look at this in the broader context of "buffered IO
already sucks real bad for high performance IO" then a few percent
here or there doesn't really matter.

Note, however, that the difference between dio+aio and buffered
writes has nothing to do with unwritten extents - what you are
seeing is the cost of the CPU copying the data into the page cache
in the user process context vs just submitting IO. Essentially, IO
submission time is way higher for buffered IO because of the data
copy, hence a CPU can do less of them per second. IOWs, unwritten
extents are not significant compared to the overhead the page cache
adds to the IO path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
