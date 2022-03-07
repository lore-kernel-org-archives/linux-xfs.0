Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453CEC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 21:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiCGVTh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 16:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiCGVTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 16:19:37 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E49D52C100
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 13:18:39 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0E09A10E1AE3;
        Tue,  8 Mar 2022 08:18:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRKkX-002k7t-HX; Tue, 08 Mar 2022 08:18:37 +1100
Date:   Tue, 8 Mar 2022 08:18:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: log recovery hang fixes
Message-ID: <20220307211837.GP59715@dread.disaster.area>
References: <20220307053252.2534616-1-david@fromorbit.com>
 <YiZENvZ1CncSyoYX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiZENvZ1CncSyoYX@casper.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=622676af
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=nIe8TPQbmuJFBfkEHvQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 07, 2022 at 05:43:18PM +0000, Matthew Wilcox wrote:
> On Mon, Mar 07, 2022 at 04:32:49PM +1100, Dave Chinner wrote:
> > Willy reported generic/530 had started hanging on his test machines
> > and I've tried to reproduce the problem he reported. While I haven't
> > reproduced the exact hang he's been having, I've found a couple of
> > others while running g/530 in a tight loop on a couple of test
> > machines.
> [...]
> > 
> > Willy, can you see if these patches fix the problem you are seeing?
> > If not, I still think they stand alone as necessary fixes, but I'll
> > have to keep digging to find out why you are seeing hangs in g/530.
> 
> I no longer see hangs, but I do see an interesting pattern in runtime
> of g/530.  I was seeing hangs after only a few minutes of running g/530,
> and I was using 15 minutes of success to say "git bisect good".  Now at 45
> minutes of runtime with no hangs.  Specifically, I'm testing 0020a190cf3e
> ("xfs: AIL needs asynchronous CIL forcing"), plus these three patches.
> If you're interested, I can see which of these three patches actually
> fixes my hang.  I should also test these three patches on top of current
> 5.17-rc, but I wanted to check they were backportable to current stable
> first.
> 
> Of the 120 times g/530 has run, I see 30 occurrences of the test taking
> 32-35 seconds.  I see one occurrence of the test taking 63 seconds.
> Usually it takes 2-3s.  This smacks to me of a 30s timeout expiring.
> Let me know if you want me to try to track down which one it is.

That'll be the log worker triggering a log force after 30s, and that
gets it unstuck. So you're still seeing the problem, only now the
watchdog kicks everything back into life.

Can you run a trace for me that captures one of those 30-60s runs
so I can see what might be happening? Something like:

# trace-cmd record -e xlog\* -e xfs_ail\* -e xfs_log\* -e xfs_inodegc\* -e printk ./check generic/530

I don't need all the XFS tracepoints - I'm mainly interested in log
and AIL interactions and what is stuck on them and when...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
