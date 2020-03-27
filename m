Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B17C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 04:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FC9C20705
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 04:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgC0Eu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 00:50:27 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46828 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbgC0Eu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 00:50:27 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8B14D7EC0E7;
        Fri, 27 Mar 2020 15:50:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jHgwn-0007hm-QW; Fri, 27 Mar 2020 15:50:21 +1100
Date:   Fri, 27 Mar 2020 15:50:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't flush the entire filesystem when a buffered
 write runs out of space
Message-ID: <20200327045021.GR10776@dread.disaster.area>
References: <20200327014558.GG29339@magnolia>
 <20200327022714.GQ10776@dread.disaster.area>
 <20200327025153.GP29351@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327025153.GP29351@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=4VMN4xWXihn5s_dXWE8A:9
        a=ZINvIIO-WHBMzTGm:21 a=q_5nS_ba5Gbudrc5:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 07:51:53PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 27, 2020 at 01:27:14PM +1100, Dave Chinner wrote:
> > On Thu, Mar 26, 2020 at 06:45:58PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > A customer reported rcu stalls and softlockup warnings on a computer
> > > with many CPU cores and many many more IO threads trying to write to a
> > > filesystem that is totally out of space.  Subsequent analysis pointed to
> > > the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> > > which causes a lot of wb_writeback_work to be queued.  The writeback
> > > worker spends so much time trying to wake the many many threads waiting
> > > for writeback completion that it trips the softlockup detector, and (in
> > > this case) the system automatically reboots.
> > 
> > That doesn't sound right. Each writeback work that is queued via
> > sync_inodes_sb should only have a single process waiting on it's
> > completion. And how many threads do you actually have to need to
> > wake up for it to trigger a 10s soft-lockup timeout?
> > 
> > More detail, please?
> 
> It's a two socket 64-core system with some sort of rdma/infiniband magic
> and somewhere between 600-900 processes doing who knows what with the
> magic.  Each of those threads *also* is writing trace data to its own
> separate trace file (three private log files per process).  Hilariously
> they never check the return code from write() so they keep pounding the
> system forever.

<facepalm>

Ah, another game of ye olde "blame the filesystem because it's the
first to complain"...

> (I don't know what the rdma/infiniband magic is, they won't tell me.)
> 
> When the filesystem fills up all the way (it's a 10G fs with 8,207
> blocks free) they keep banging away on it until something finally dies.
> 
> I tried writing a dumb fstest to simulate the log writer part, but that
> never succeeds in triggering the rcu stalls.

Which means it probably requires a bunch of other RCU magic to be
done by other part of the system to trigger it...

> If you want the gory dmesg details I can send you some dmesg log.

No need, won't be able to read it anyway because facepalm...

> > > In addition, they complain that the lengthy xfs_flush_inodes scan traps
> > > all of those threads in uninterruptible sleep, which hampers their
> > > ability to kill the program or do anything else to escape the situation.
> > > 
> > > Fix this by replacing the full filesystem flush (which is offloaded to a
> > > workqueue which we then have to wait for) with directly flushing the
> > > file that we're trying to write.
> > 
> > Which does nothing to flush -other- outstanding delalloc
> > reservations and allow the eofblocks/cowblock scan to reclaim unused
> > post-EOF speculative preallocations.
> > 
> > That's the purpose of the xfs_flush_inodes() - without it we can get
> > very premature ENOSPC, especially on small filesystems when writing
> > largish files in the background. So I'm not sure that dropping the
> > sync is a viable solution. It is actually needed.
> 
> Yeah, I did kinda wonder about that...
> 
> > Perhaps we need to go back to the ancient code thatonly allowed XFS
> > to run a single xfs_flush_inodes() at a time - everything else
> > waited on the single flush to complete, then all returned at the
> > same time...
> 
> That might work too.  Admittedly it's pretty silly to be running this
> scan over and over and over considering that there's never going to be
> any more free space.

Actually, what if we just rate limit the calls? Once a second would
probably do the trick just fine - after the first few seconds
there'll be no space left to reclaim, anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
