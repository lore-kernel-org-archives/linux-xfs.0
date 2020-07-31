Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B8EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 22:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0759722B43
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 22:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGaWdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 18:33:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52307 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgGaWdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 18:33:01 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C13A0366F87;
        Sat,  1 Aug 2020 08:32:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k1daB-0001CG-23; Sat, 01 Aug 2020 08:32:55 +1000
Date:   Sat, 1 Aug 2020 08:32:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfs_reclaim_inodes_ag taking several seconds
Message-ID: <20200731223255.GG2005@dread.disaster.area>
References: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=rAesklP4G-IAMA5cWT4A:9 a=ZgxdwEChLKTLruX4:21 a=jKte_x3vTZg2EUFh:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 01:27:31PM +0200, Donald Buczek wrote:
> Dear Linux people,
> 
> we have a backup server with two xfs filesystems on 101.9TB md-raid6 devices (16 * 7.3 T disks) each, Current Linux version is 5.4.54.
.....
> root:done:/home/buczek/linux_problems/shrinker_semaphore/# cat /proc/meminfo
> MemTotal:       263572332 kB

256GB of RAM.

> MemFree:         2872368 kB
> MemAvailable:   204193824 kB

200GB "available"

> Buffers:            2568 kB
> Cached:         164931356 kB

160GB in page cache

> KReclaimable:   40079660 kB
> Slab:           49988268 kB
> SReclaimable:   40079660 kB

40GB in reclaimable slab objects.

IOWs, you have no free memory in the machine and so allocation
will frequently be dipping into memory reclaim to free up page cache
and slab caches to make memory available.

> xfs_inode         30978282 31196832    960    4    1 : tunables   54   27    8 : slabdata 7799208 7799208    434

Yes, 30 million cached inodes.

> bio_integrity_payload 29644966 30203481    192   21    1 : tunables  120   60    8 : slabdata 1438261 1438261    480

Either there is a memory leak in this slab, or it is shared with
something like the xfs_ili slab, which would indicate that most
of the cached inodes have been dirtied in memory at some point in
time. 

And if you have 30 million inodes in memory, and lots of them are
dirty, and the shrinkers are running, then they will be doing
dirty inode writeback to throttle memory reclaim to
ensure it makes progress and doesn't declare OOM and kill processes
permaturely.

You have spinning disks, RAID6. I'm betting that it can only clean a
couple of hundred inodes a second because RAID6 is severely IOP
limited for small writes (like inode clusters). And when you many,
many thousands (maybe millions) of dirty inodes, anything that has
to wait on inode writeback is going to be waiting for some time...

> root:done:/home/buczek/linux_problems/shrinker_semaphore/# xfs_info /amd/done/C/C8024
> meta-data=/dev/md0               isize=512    agcount=102, agsize=268435328 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=27348629504, imaxpct=1
>          =                       sunit=128    swidth=1792 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2

And full size journals, so the filesystem can hold an awful lot of
active dirty inodes in memory before it starts throttling on a full
journal (think millions of dirty inodes per filesystem)...

So, yeah, this is the classic "in memory operation is orders of
magnitude faster than disk operation" and it all comes crashing down
when something needs to wait for inodes to be written back. The
patchset Darrick pointed you at should fix the shrinker issue, but
it's likely that this will just push the problem to the next
throttling point, which is the journal filling up.

IOWs, I suspect fixing your shrinker problem is only going to make
the overload of dirty inodes in the system behave worse, because
running out of journal space cause *all modifications* to the
filesystem to start taking significant delays while they wait for
inode writeback to free journal space, not just have things
trying to register/unregister shrinkers take delays...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
