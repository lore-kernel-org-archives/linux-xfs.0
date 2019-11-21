Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAF6C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 13:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A1F20708
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 13:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sk5rWxxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKUN3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 08:29:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfKUN3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 08:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jfdDcg8Rb9EyvSu2eIxHgWj5A4eCWm0Rpkl8ERU2Ehs=; b=sk5rWxxKId6Hjdan020hfjeX1
        UNhZmhPKm6rVbvQaCrkk7BX2MmOYRpT8hAw1F9TJbLpuDUTjba0XqdFrlBqdGCigUbwAbvlQrY8np
        OeYOFQmlp9OGquvo9OeJYV0YGRYEp0guO+rfcpB70MV5g8UQvIU9C5xpwth0HGIjSxR2xTf5y1+rG
        4Tm4IjBYErkjeQjv3Za/e0HLyi2xBxZ1voeNZs1lfY+/lVHyvj+chZSnDtr9pBJdAk2cQ2AOPnF3H
        obukZ3/rB5w6h8glw8SNfm/zklTSpzamhSUJJddjG0v44lLG2Kfscj1T7F6cDC3JD5YZeX0OZA61D
        CmVk4S5Og==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXmWh-0008QU-Dz; Thu, 21 Nov 2019 13:29:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CECCA3056C8;
        Thu, 21 Nov 2019 14:28:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B1981201DD6AF; Thu, 21 Nov 2019 14:29:37 +0100 (CET)
Date:   Thu, 21 Nov 2019 14:29:37 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: single aio thread is migrated crazily by scheduler
Message-ID: <20191121132937.GW4114@hirez.programming.kicks-ass.net>
References: <20191114113153.GB4213@ming.t460p>
 <20191114235415.GL4614@dread.disaster.area>
 <20191115010824.GC4847@ming.t460p>
 <20191115045634.GN4614@dread.disaster.area>
 <20191115070843.GA24246@ming.t460p>
 <20191115234005.GO4614@dread.disaster.area>
 <20191118092121.GV4131@hirez.programming.kicks-ass.net>
 <20191118204054.GV4614@dread.disaster.area>
 <20191120191636.GI4097@hirez.programming.kicks-ass.net>
 <20191120220313.GC18056@pauld.bos.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120220313.GC18056@pauld.bos.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 05:03:13PM -0500, Phil Auld wrote:
> On Wed, Nov 20, 2019 at 08:16:36PM +0100 Peter Zijlstra wrote:
> > On Tue, Nov 19, 2019 at 07:40:54AM +1100, Dave Chinner wrote:

> > > Yes, that's precisely the problem - work is queued, by default, on a
> > > specific CPU and it will wait for a kworker that is pinned to that
> > 
> > I'm thinking the problem is that it doesn't wait. If it went and waited
> > for it, active balance wouldn't be needed, that only works on active
> > tasks.
> 
> Since this is AIO I wonder if it should queue_work on a nearby cpu by 
> default instead of unbound.  

The thing seems to be that 'unbound' is in fact 'bound'. Maybe we should
fix that. If the load-balancer were allowed to move the kworker around
when it didn't get time to run, that would probably be a better
solution.

Picking another 'bound' cpu by random might create the same sort of
problems in more complicated scenarios.

TJ, ISTR there used to be actually unbound kworkers, what happened to
those? or am I misremembering things.

> > Lastly,
> > one other thing to try is -next. Vincent reworked the load-balancer
> > quite a bit.
> > 
> 
> I've tried it with the lb patch series. I get basically the same results.
> With the high granularity settings I get 3700 migrations for the 30 
> second run at 4k. Of those about 3200 are active balance on stock 5.4-rc7.
> With the lb patches it's 3500 and 3000, a slight drop. 

Thanks for testing that. I didn't expect miracles, but it is good to
verify.

> Using the default granularity settings 50 and 22 for stock and 250 and 25.
> So a few more total migrations with the lb patches but about the same active.

Right, so the granularity thing interacts with the load-balance period.
By pushing it up, as some people appear to do, makes it so that what
might be a temporal imablance is perceived as a persitent imbalance.

Tying the load-balance period to the gramularity is something we could
consider, but then I'm sure, we'll get other people complaining the
doesn't balance quick enough anymore.

