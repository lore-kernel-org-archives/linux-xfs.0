Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5401CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 21:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3049C60F70
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 21:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbhIHV2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 17:28:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36976 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhIHV2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 17:28:45 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 47B8082C659;
        Thu,  9 Sep 2021 07:27:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mO56T-00AFI7-1G; Thu, 09 Sep 2021 07:27:33 +1000
Date:   Thu, 9 Sep 2021 07:27:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Momtchil Momtchev <momtchil@momtchev.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: heavy xfsaild I/O blocking process exit
Message-ID: <20210908212733.GA2361455@dread.disaster.area>
References: <b0537b9a-d2f8-9288-b631-5bf67488d930@momtchev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0537b9a-d2f8-9288-b631-5bf67488d930@momtchev.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=8nJEP1OIZ-IA:10 a=7QKq2e-ADPsA:10 a=xNf9USuDAAAA:8 a=7-415B0cAAAA:8
        a=TJuteJKHv3KEP-wJsPYA:9 a=wPNLvfGTeEIA:10 a=SEwjQc04WA-l_NiBhQ7s:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 08, 2021 at 10:15:59AM +0200, Momtchil Momtchev wrote:
> 
> Hello,
> 
> 
> I have a puzzling problem with XFS on Debian 10. I am running
> number-crunching driven by Node.js - I have a process that creates about 2
> million 1MB to 5MB files per day with an about 24h lifespan (weather
> forecasting). The file system is obviously heavily fragmented. I have
> absolutely no problems when running this in cruise mode, but every time I
> decide to stop that process, especially when it has been running for a few

What does "stop that process" mean? You kill it, or do you run a
stop command that tells the process to do a controlled shutdown?

> weeks or months, the process will become a zombie (freeing all its user
> memory and file descriptors) and then xfsaild/kworker will continue flushing
> the log for about 30-45 minutes before the process really quits.

The xfsaild is not flushing the log. It's doing metadata writeback.
If it is constantly busy, it means the log has run out of space and
something else wants log space. That something else will block until
the log space has been freed up by metadata writeback....

> It will
> keep its binds to network ports (which is my main problem) but the system
> will remain responsive and usable. The I/O pattern is several seconds of
> random reading then a second or two of sequential writing.

That would be expected from final close on lots of dirty inodes or
finalising unlinks on final close. But that won't stop anything else
from functioning.

> The kernel functions that are running in the zombie process context are
> mainly xfs_btree_lookup, xfs_log_commit_cil, xfs_next_bit,
> xfs_buf_find_isra.26

Full profiles (e.g. from perf top -U -p <pid>) would be useful here,
but this sounds very much like extent removal on final close. This
will be removing either speculative preallocation beyond EOF or the
workload has open but unlinked files and the unlink is being done at
process exit.

Either way, if the files are fragmented into millions of extents,
this could take minutes per file being closed. But with only 1-5MB
files, that shouldn't be occurring...

> xfsaild is spending time in radix_tree_next_chunk, xfs_inode_buf_verify

xfsaild should never be doing radix tree lookups - it only works on
internal in-memory filessytem objects that it has direct references
to. IOWs, I really need to see the actual profile outputs to
determine what it is doing...

xfs_inode_buf_verify() is expected if it is writing back dirty inode
clusters. Which it will be, but at only 2 million files a day I
wouldn't expect that to show up in profiles at all. It doesn't
really even show up in profiles even at half a million inodes per
_second_

> kworker is in xfs_reclaim_inode, radix_tree_next_chunk

Which kworker is that? Likely background inode reclaim, but that
doesn't limit anything - it just indicates there are inodes
available to be reclaimed.

> This is on (standard up-to date Debian 10):
> 
> Linux version 4.19.0-16-amd64 (debian-kernel@lists.debian.org) (gcc version
> 8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.181-1 (2021-03-19)
> 
> xfs_progs 4.20.0-1
> 
> 
> 
> File system is RAID-0, 2x2TB disks with LVM over md (512k chunks)

Are these SSDs or HDDs? I'll assume HDD at this point.

> meta-data=/dev/mapper/vg0-home   isize=512    agcount=32, agsize=29849728
> blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=955191296, imaxpct=5
>          =                       sunit=128    swidth=256 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=466402, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, so you have a 1.7GB log. If those are HDDs, then you could have
hundreds of thousands of dirty inodes tracked in the log, and
metadata writeback has been falling behind for days because the log
can be filled much faster than it can be drained.

Assuming 200 write IOPS, 30 minutes would be 360,000 writes, which
pretty much matches up with having half a million dirty inodes in
the log and the process exiting needing to run a bunch of
transactions that need a chunk of log space to make progress and
having to wait on inode writeback to free up log space...

> MemTotal:       32800968 kB
> MemFree:          759308 kB
> MemAvailable:   27941208 kB
> Buffers:           43900 kB
> Cached:         26504332 kB
> SwapCached:         7560 kB
> Active:         16101380 kB
> Inactive:       11488252 kB
> Active(anon):     813424 kB
> Inactive(anon):   228180 kB
> Active(file):   15287956 kB
> Inactive(file): 11260072 kB

So all your memory is in the page cache.

> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:      16777212 kB
> SwapFree:       16715524 kB
> Dirty:              2228 kB

And almost all the page cache is clean.

> Writeback:             0 kB
> AnonPages:       1034280 kB
> Mapped:            89660 kB
> Shmem:               188 kB
> Slab:            1508868 kB
> SReclaimable:    1097804 kB
> SUnreclaim:       411064 kB

And that's enough slab cache to hold half a million cached, dirty
inodes...

More information required.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
