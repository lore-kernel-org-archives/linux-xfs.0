Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDE9C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 20:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F104064E74
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 20:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhBHUqk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 15:46:40 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:53884 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231835AbhBHUog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Feb 2021 15:44:36 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id BC69B1105FA6;
        Tue,  9 Feb 2021 07:43:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l9DNK-00D6JC-OS; Tue, 09 Feb 2021 07:43:14 +1100
Date:   Tue, 9 Feb 2021 07:43:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        rcu@vger.kernel.org, it+linux-rcu@molgen.mpg.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_sched self-detected stall on CPU: Workqueue:
 xfs-conv/md0 xfs_end_io
Message-ID: <20210208204314.GY4662@dread.disaster.area>
References: <1b07e849-cffd-db1f-f01b-2b8b45ce8c36@molgen.mpg.de>
 <20210205171240.GN2743@paulmck-ThinkPad-P72>
 <20210208140724.GA126859@bfoster>
 <20210208145723.GT2743@paulmck-ThinkPad-P72>
 <20210208154458.GB126859@bfoster>
 <20210208171140.GV2743@paulmck-ThinkPad-P72>
 <20210208172824.GA7209@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208172824.GA7209@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=IutluZyxhPRxE9LQjgIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 09:28:24AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 09, 2021 at 09:11:40AM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 08, 2021 at 10:44:58AM -0500, Brian Foster wrote:
> > > There was a v2 inline that incorporated some directed feedback.
> > > Otherwise there were questions and ideas about making the whole thing
> > > faster, but I've no idea if that addresses the problem or not (if so,
> > > that would be an entirely different set of patches). I'll wait and see
> > > what Darrick thinks about this and rebase/repost if the approach is
> > > agreeable..
> > 
> > There is always the school of thought that says that the best way to
> > get people to focus on this is to rebase and repost.  Otherwise, they
> > are all too likely to assume that you lost interest in this.
> 
> I was hoping that a better solution would emerge for clearing
> PageWriteback on hundreds of thousands of pages, but nothing easy popped
> out.
> 
> The hardcoded threshold in "[PATCH v2 2/2] xfs: kick extra large ioends
> to completion workqueue" gives me unease because who's to say if marking
> 262,144 pages on a particular CPU will actually stall it long enough to
> trip the hangcheck?  Is the number lower on (say) some pokey NAS box
> with a lot of storage but a slow CPU?

It's also not the right thing to do given the IO completion
workqueue is a bound workqueue. Anything that is doing large amounts
of CPU intensive work should be on a unbound workqueue so that the
scheduler can bounce it around different CPUs as needed.

Quite frankly, the problem is a huge long ioend chain being built by
the submission code. We need to keep ioend completion overhead down.
It runs in either softirq or bound workqueue context and so
individual items of work that are performed in this context must not
be -unbounded- in size or time. Unbounded ioend chains are bad for
IO latency, they are bad for memory reclaim and they are bad for CPU
scheduling.

As I've said previously, we gain nothing by aggregating ioends past
a few tens of megabytes of submitted IO. The batching gains are
completely diminished once we've got enough IO in flight to keep the
submission queue full. We're talking here about gigabytes of
sequential IOs in a single ioend chain which are 2-3 orders of
magnitude larger than needed for optimal background IO submission
and completion efficiency and throughput. IOWs, we really should be
limiting the ioend chain length at submission time, not trying to
patch over bad completion behaviour that results from sub-optimal IO
submission behaviour...

> That said, /some/ threshold is probably better than no threshold.  Could
> someone try to confirm if that series of Brian's fixes this problem too?

262144 pages is still too much work to be doing in a single softirq
IO completion callback. It's likely to be too much work for a bound
workqueue, too, especially when you consider that the workqueue
completion code will merge sequential ioends into one ioend, hence
making the IO completion loop counts bigger and latency problems worse
rather than better...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
