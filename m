Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD25C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 03:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiAMDqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 22:46:32 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52310 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232272AbiAMDq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 22:46:28 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A99F910C103C;
        Thu, 13 Jan 2022 14:46:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n7r4B-00Ee6l-4V; Thu, 13 Jan 2022 14:46:23 +1100
Date:   Thu, 13 Jan 2022 14:46:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: xlog_write rework and CIL scalability
Message-ID: <20220113034623.GC3290465@dread.disaster.area>
References: <20211210000956.GO449541@dread.disaster.area>
 <20220106214033.GR656707@magnolia>
 <20220111050437.GA3290465@dread.disaster.area>
 <20220111175828.GC656707@magnolia>
 <20220112235604.GC19198@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112235604.GC19198@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61dfa090
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=eG-BmhT3tPVRS-RG-1AA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 12, 2022 at 03:56:04PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 11, 2022 at 09:58:29AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 11, 2022 at 04:04:37PM +1100, Dave Chinner wrote:
> > > On Thu, Jan 06, 2022 at 01:40:33PM -0800, Darrick J. Wong wrote:
> > > > On Fri, Dec 10, 2021 at 11:09:56AM +1100, Dave Chinner wrote:
> > > > > Hi Darrick,
> > > > > 
> > > > > Can you please pull the following changes from the tag listed below
> > > > > for the XFS dev tree?
> > > > 
> > > > Hi Dave,
> > > > 
> > > > I tried, but the regressions with generic/017 persist.  It trips the
> > > > ticket reservation pretty consistently within 45-60 seconds of starting,
> > > > at least on the OCI VM that I created.  /dev/sd[ab] are (software
> > > > defined) disks that can sustain reads of ~50MB/s and ~5000iops; and
> > > > writes of about half those numbers.
> > > > 
> > > >  run fstests generic/017 at 2022-01-06 13:18:59
> > > >  XFS (sda4): Mounting V5 Filesystem
> > > >  XFS (sda4): Ending clean mount
> > > >  XFS (sda4): Quotacheck needed: Please wait.
> > > >  XFS (sda4): Quotacheck: Done.
> > > >  XFS (sda4): ctx ticket reservation ran out. Need to up reservation
> > > >  XFS (sda4): ticket reservation summary:
> > > >  XFS (sda4):   unit res    = 548636 bytes
> > > >  XFS (sda4):   current res = -76116 bytes
> > > >  XFS (sda4):   original count  = 1
> > > >  XFS (sda4):   remaining count = 1
> > > >  XFS (sda4): Log I/O Error (0x2) detected at xlog_write+0x5ee/0x660 [xfs] (fs/xfs/xfs_log.c:2499).  Shutting down filesystem.
> > > >  XFS (sda4): Please unmount the filesystem and rectify the problem(s)
> > > >  XFS (sda3): Unmounting Filesystem
> > > >  XFS (sda4): Unmounting Filesystem
> > > 
> > > Ok, I *think* I've worked out what was going on here. The patch
> > > below has run several hundred iterations of g/017 with an external
> > > log on two different fs/log size configurations that typically
> > > reproduced in within 10 cycles.
> > > 
> > > Essentially, the problem is largely caused by using
> > > XLOG_CIL_BLOCKING_SPACE_LIMIT() instead of XLOG_CIL_SPACE_LIMIT()
> > > when determining how much used space we can allow the percpu
> > > counters to accumulate before aggregating them back into the global
> > > counter. Using the hard limit meant that we could accumulate almost
> > > the entire hard limit before we aggregate even a single percpu value
> > > back into the global limit, resulting in failing to trigger either
> > > condition for aggregation until we'd effectively blown through the
> > > hard limit.
> > > 
> > > This then meant the extra reservations that need to be taken for
> > > space used beyond the hard limit didn't get stolen for the ctx
> > > ticket, and it then overruns.
> > > 
> > > It also means that we could overrun the hard limit substantially
> > > before throttling kicked in. With the percpu aggregation threshold
> > > brought back down to the (soft limit / num online cpus) we are
> > > guaranteed to always start aggregation back into the global counter
> > > before or at the point in time the soft limit should be hit, meaning
> > > that we start updating the global counter much sooner and so are it
> > > tracks actual space used once over the soft limit much more closely.
> > > 
> > > Darrick, can you rerun the branch with the patch below also included, and
> > > see if it reproduces on your setup? If it does, can you grab a trace
> > > of the trace_printk() calls I left in the patch?
> > 
> > Ok, I'll do that and report back.
> 
> ...everything passes now, except for generic/650 on the same machine
> that has a 128M external log:
> 
> [21310.267037] run fstests generic/650 at 2022-01-11 22:41:45
> [21311.121539] XFS (sda3): Mounting V5 Filesystem
> [21312.295609] XFS (sda3): Ending clean mount
> [21314.160622] smpboot: CPU 2 is now offline
> [21314.737842] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [21314.740726] kvm-clock: cpu 2, msr 43f608081, secondary cpu clock
> [21314.787354] kvm-guest: stealtime: cpu 2, msr 43fd1b040
> [21315.917154] smpboot: CPU 1 is now offline
> [21317.993809] x86: Booting SMP configuration:
> [21317.996484] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [21318.001940] kvm-clock: cpu 1, msr 43f608041, secondary cpu clock
> [21318.020207] kvm-guest: stealtime: cpu 1, msr 43fc9b040
> [21320.126617] smpboot: CPU 3 is now offline
> [21320.127744] XFS (sda3): ctx ticket reservation ran out. Need to up reservation
> [21320.153944] XFS (sda3): ticket reservation summary:
> [21320.158868] XFS (sda3):   unit res    = 2100 bytes
> [21320.163064] XFS (sda3):   current res = -40 bytes
> [21320.167323] XFS (sda3):   original count  = 1
> [21320.170436] XFS (sda3):   remaining count = 1
> [21320.171742] XFS (sda3): Log I/O Error (0x2) detected at xlog_write+0x5f3/0x670 [xfs] (fs/xfs/xfs_log.c:2512).  Shutting down filesystem.
> [21320.176445] XFS (sda3): Please unmount the filesystem and rectify the problem(s)
> [21320.179719] potentially unexpected fatal signal 6.
> [21320.182490] potentially unexpected fatal signal 6.
> [21320.182632] potentially unexpected fatal signal 6.
> [21320.183842] CPU: 0 PID: 3460987 Comm: fsstress Tainted: G        W         5.16.0-rc5-djwx #rc5 79050ab45c4cbd1b9fbe98125ec0eea3a2cdfa1d

Different issue. That's a CPU hotplug problem, not a general
accounting issue. Hotplug sucks, not sure yet if there's a way to
avoid the race that causes this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
