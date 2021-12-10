Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD0CC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 21:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhLJVYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 16:24:12 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:38685 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235802AbhLJVYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 16:24:12 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 97C60E0C6E7;
        Sat, 11 Dec 2021 08:20:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mvnJh-001XOh-D6; Sat, 11 Dec 2021 08:20:33 +1100
Date:   Sat, 11 Dec 2021 08:20:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Subject: Re: VMs getting into stuck states since kernel ~5.13
Message-ID: <20211210212033.GP449541@dread.disaster.area>
References: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
 <20211208213339.GM449541@dread.disaster.area>
 <CAJCQCtR5NjF61B4g4KkjBgdmV8rK8tWLNxtVvNbm4gzm9kdrhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtR5NjF61B4g4KkjBgdmV8rK8tWLNxtVvNbm4gzm9kdrhg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61b3c4a3
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=7-415B0cAAAA:8
        a=dwEYYnyJ9O50m8qkNlAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 03:06:37PM -0500, Chris Murphy wrote:
> On Wed, Dec 8, 2021 at 4:33 PM Dave Chinner <david@fromorbit.com> wrote:
> > Looking at the traces, I'd say IO is really slow, but not stuck.
> > `iostat -dxm 5` output for a few minutes will tell you if IO is
> > actually making progress or not.
> 
> Pretty sure like everything else we run once the hang happens, iostat
> will just hang too. But I'll ask.

If that's the case, then I want to see the stack trace for the hung
iostat binary.

> > Can you please provide the hardware configuration for these machines
> > and iostat output before we go any further here?
> 
> Dell PERC H730P
> megaraid sas controller,

Does it have NVRAM? if so, how much, how is it configured, etc.

> to 10x 600G sas drives,

Configured as JBOD, or something else? What is the per-drive cache
configuration?

The link I put in the last email did ask for this sort of specific
information....

> BFQ ioscheduler, and
> the stack is:
> 
> partition->mdadm raid6, 512KiB chunk->dm-crypt->LVM->XFS

Ok, that's pretty suboptimal for VM hosts that typically see lots of
small random IO. 512kB chunk size RAID6 is about the worst
configuration you can have for a small random write workload.
Putting dmcrypt on top of that will make things even slower.

But it also means we need to be looking for bugs in both dmcrypt and
MD raid, and given that there are bad bios being built somewhere in
the stack, it's a good be the problems are somewhere within these
two layers.


> meta-data=/dev/mapper/vg_guests-LogVol00 isize=512    agcount=180, agsize=1638272 blks

Where does the agcount=180 come from? Has this filesystem been grown
at some point in time?

>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=294649856, imaxpct=25
>          =                       sunit=128    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=12800, version=2

Yeah, 50MB is tiny log for a filesystem of this size.

>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, here's what I'm guessing was th original fs config:

# mkfs.xfs -N -d size=100G,su=512k,sw=4 foo
meta-data=foo                    isize=512    agcount=16, agsize=1638272 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=26212352, imaxpct=25
         =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
#

and then it was grown from 100GB to 1.5TB at some point later on in
it's life. An actual 1.5TB fs should have a log that is somewhere
around 800MB in size.

So some of the slowness could be because the log is too small,
causing much more frequent semi-random 4kB metadata writeback than
should be occurring. That should be somewhat temporary slowness (in
the order of minutes) but it's also worst case behaviour for the
RAID6 configuration of the storage.

Also, what mount options are in use?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
