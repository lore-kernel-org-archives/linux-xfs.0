Return-Path: <SRS0=ns7q=BN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C0EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 22:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1757622BED
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 22:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHCWLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 18:11:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46945 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgHCWLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Aug 2020 18:11:19 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 18C327EB81D;
        Tue,  4 Aug 2020 08:11:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k2ifn-0008Qk-2T; Tue, 04 Aug 2020 08:11:11 +1000
Date:   Tue, 4 Aug 2020 08:11:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfs_reclaim_inodes_ag taking several seconds
Message-ID: <20200803221111.GC2114@dread.disaster.area>
References: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
 <20200731223255.GG2005@dread.disaster.area>
 <d515fa07-5198-fc3c-24ac-d35aa4e08668@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d515fa07-5198-fc3c-24ac-d35aa4e08668@molgen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=NCnLcJuM4JqR9p3ilrQA:9 a=GNzd1uFCvdbtbz8A:21 a=pED4Lm8SYIsXpnix:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 01, 2020 at 12:25:40PM +0200, Donald Buczek wrote:
> On 01.08.20 00:32, Dave Chinner wrote:
> > On Fri, Jul 31, 2020 at 01:27:31PM +0200, Donald Buczek wrote:
> > > Dear Linux people,
> > > 
> > > we have a backup server with two xfs filesystems on 101.9TB md-raid6 devices (16 * 7.3 T disks) each, Current Linux version is 5.4.54.
> > .....
> > > root:done:/home/buczek/linux_problems/shrinker_semaphore/# cat /proc/meminfo
> > > MemTotal:       263572332 kB
> > 
> > 256GB of RAM.
> > 
> > > MemFree:         2872368 kB
> > > MemAvailable:   204193824 kB
> > 
> > 200GB "available"
> > 
> > > Buffers:            2568 kB
> > > Cached:         164931356 kB
> > 
> > 160GB in page cache
> > 
> > > KReclaimable:   40079660 kB
> > > Slab:           49988268 kB
> > > SReclaimable:   40079660 kB
> > 
> > 40GB in reclaimable slab objects.
> > 
> > IOWs, you have no free memory in the machine and so allocation
> > will frequently be dipping into memory reclaim to free up page cache
> > and slab caches to make memory available.
> > 
> > > xfs_inode         30978282 31196832    960    4    1 : tunables   54   27    8 : slabdata 7799208 7799208    434
> > 
> > Yes, 30 million cached inodes.
> > 
> > > bio_integrity_payload 29644966 30203481    192   21    1 : tunables  120   60    8 : slabdata 1438261 1438261    480
> > 
> > Either there is a memory leak in this slab, or it is shared with
> > something like the xfs_ili slab, which would indicate that most
> > of the cached inodes have been dirtied in memory at some point in
> > time.
> 
> I think you are right here:
> 
>     crash> p $s->name
>     $84 = 0xffffffff82259401 "bio_integrity_payload"
>     crash> p $s->refcount
>     $88 = 8
>     crash> p $s
>     $92 = (struct kmem_cache *) 0xffff88bff92d2bc0
>     crash> p sizeof(xfs_inode_log_item_t)
>     $93 = 192
>     crash> p $s->object_size
>     $94 = 192
> 
> So if I understand you correctly, this is expected behavior with
> this kind of load and conceptual changes are already scheduled for
> kernel 5.9. I don't understand most of it, but isn't it true that
> with that planned changes the impact might be better limited to
> the filesystem, so that the performance of other areas of the
> system might improve?

What the changes in 5.9 will do is remove the direct memory reclaim
latency that comes from waiting on IO in the shrinker. Hence you
will no longer see this problem from applications doing memory
allocation. i.e. they'll get some other memory reclaimed without
blocking (e.g. page cache or clean inodes) and so the specific
symptom of having large numbers of dirty inodes in memory that you
are seeing will go away.

Which means that dirty inodes in memory will continue to build up
until the next constraint is hit, and then it will go back to having
unpredictable large latencies while waiting for inodes to be written
back to free up whatever resource the filesystem has run out of.

That resource will, most likely, be filesystem journal space. Every
fs modification needs to reserve sufficient journal to complete
before the modification starts. Hence if the journal fills, any
modification to the fs will block waiting on dirty inode writeback
to release space in the journal....

You might be lucky and the backup process is slow enough that the
disk subsystem can keep up with the rate of ingest of new data and
so you never hit this limitation. However, the reported state of the
machine and the amount of RAM it has for caching says to me that the
underlying problem is that ingest is far faster than the filesystem
and disk subsystem can sink...

A solution to this problem might be to spread out the backups being
done over a wider timeframe, such that there isn't a sustained heavy
load at 3am in the morning when every machine is scheduled to be
backed up at the same time...

> I'd love to test that with our load, but I
> don't want to risk our backup data and it would be difficult to
> produce the same load on a toy system. The patch set is not yet
> ready to be tested on production data, is it?

Not unless you like testing -rc1 kernels in production :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
