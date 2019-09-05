Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAAEC3A5A5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 07:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41CC722CF5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 07:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfIEH3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 03:29:01 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46786 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731389AbfIEH3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 03:29:01 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 072AE43EC30;
        Thu,  5 Sep 2019 17:28:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5mCO-0003YT-3S; Thu, 05 Sep 2019 17:28:56 +1000
Date:   Thu, 5 Sep 2019 17:28:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] xfs: log race fixes and cleanups
Message-ID: <20190905072856.GE1119@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904052600.GA27276@infradead.org>
 <20190904055619.GA2279@infradead.org>
 <20190904225716.GM1119@dread.disaster.area>
 <20190905065133.GA21840@infradead.org>
 <20190905071031.GD1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905071031.GD1119@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=CqNpd9uUQgGwsgtLomcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 05:10:31PM +1000, Dave Chinner wrote:
> On Wed, Sep 04, 2019 at 11:51:33PM -0700, Christoph Hellwig wrote:
> > On Thu, Sep 05, 2019 at 08:57:16AM +1000, Dave Chinner wrote:
> > > > And unfortunately generic/530 still hangs for me with this series.
> > > 
> > > Where does it hang?
> > > 
> > > > This is an x86-64 VM with 4G of RAM and virtio-blk, default mkfs.xfs
> > > > options from current xfsprogs, 20G test and scratch fs.
> > > 
> > > That's pretty much what one of my test rigs is, except iscsi luns
> > > rather than virtio-blk. I haven't been able to reproduce the issues,
> > > so I'm kinda flying blind w.r.t. to testing them here. Can you
> > > get a trace of what is happening (xfs_trans*, xfs_log*, xfs_ail*
> > > tracepoints) so I can have a deeper look?
> > 
> > console output below, traces attached.
> 
> Thanks, I'll have a look in a minute. I'm pretty sure I know what it
> will show - I got a trace from Chandan earlier this afternoon and
> the problem is log recovery doesn't yeild the cpu until it runs out
> of transaction reservation space, so the push work doesn't run
> because workqueue default behaviour is strict "run work only on the
> CPU it is queued on"....

Yup, exactly the same trace. Right down to the lsns in the log and
the 307 iclog writes just after the log runs out of space. To quote
from #xfs earlier this afternoon:

[5/9/19 14:21] <dchinner> I see what is -likely- to be a cil checkpoint but without the closing commit record
[5/9/19 14:21] <chandan> which line number in the trace log are you noticing that?
[5/9/19 14:22] <dchinner> 307 sequential calls to xfs_log_assign_tail_lsn() from a kworker and then releasing a log reservation
[5/9/19 14:22] <dchinner> Assuming 32kB iclog size (default)
[5/9/19 14:23] <dchinner> thats 307 * 32 / 4 filesystem blocks, which is 2456 blocks
[5/9/19 14:24] <dchinner> that's 96% of the log in a single CIL commit
[5/9/19 14:24] <dchinner> this isn't a "why hasn't there been iclog completion" problem
[5/9/19 14:24] <dchinner> this is a "why didn't the CIL push occur when it passed 12% of the log...
[5/9/19 14:25] <dchinner> ?
[5/9/19 14:25] <dchinner> " problem
[5/9/19 14:26] <dchinner> oooohhhh
[5/9/19 14:27] <dchinner> this isn't a premeptible kernel, is it?
[5/9/19 14:27] <chandan> correct. Linux kernel on ppc64le isn't prememptible
[5/9/19 14:28] <dchinner> so a kernel thread running in a tight loop wil delay a kworker thread scheduled on the same CPU until running kthread yields the CPU
[5/9/19 14:28] <dchinner> but, because we've recovered all the inodes, etc, everything is hot in cache
[5/9/19 14:28] <dchinner> so the unlink workload runs without blocking, and so never yeilds the CPU until it runs out of transaction space.
[5/9/19 14:29] <dchinner> and only then does the background kworker get scheduled to run.

I'll send the updated patch set soon...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
