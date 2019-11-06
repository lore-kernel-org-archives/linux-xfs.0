Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE44C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C670217F4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 21:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKFVUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:20:49 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49549 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfKFVUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 16:20:49 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6282D7E9CFD;
        Thu,  7 Nov 2019 08:20:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iSSjJ-0006sw-Ve; Thu, 07 Nov 2019 08:20:41 +1100
Date:   Thu, 7 Nov 2019 08:20:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191106212041.GF4614@dread.disaster.area>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
 <20191105040325.GC4614@dread.disaster.area>
 <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8 a=waIoS2Gabq21BWvHE1cA:9
        a=9lEU_OVQspMH1i_r:21 a=yjND_H8rfCXGR7Z_:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 02:00:58PM +0800, Shaokun Zhang wrote:
> Hi Dave,
> 
> On 2019/11/5 12:03, Dave Chinner wrote:
> > On Tue, Nov 05, 2019 at 11:26:32AM +0800, Shaokun Zhang wrote:
> >> Hi Dave,
> >>
> >> On 2019/11/5 4:49, Dave Chinner wrote:
> >>> On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
> >>>> From: Yang Guo <guoyang2@huawei.com>
> >>>>
> >>>> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
> >>>> whether the counter less than 0 and it is a expensive function.
> >>>> let's check it only when delta < 0, it will be good for xfs's performance.
> >>>
> >>> Hmmm. I don't recall this as being expensive.
> >>>
> >>
> >> Sorry about the misunderstanding information in commit message.
> >>
> >>> How did you find this? Can you please always document how you found
> >>
> >> If user creates million of files and the delete them, We found that the
> >> __percpu_counter_compare costed 5.78% CPU usage, you are right that itself
> >> is not expensive, but it calls __percpu_counter_sum which will use
> >> spin_lock and read other cpu's count. perf record -g is used to profile it:
> >>
> >> - 5.88%     0.02%  rm  [kernel.vmlinux]  [k] xfs_mod_ifree
> >>    - 5.86% xfs_mod_ifree
> >>       - 5.78% __percpu_counter_compare
> >>            5.61% __percpu_counter_sum
> > 
> > Interesting. Your workload is hitting the slow path, which I most
> > certainly do no see when creating lots of files. What's your
> > workload?
> > 
> 
> The hardware has 128 cpu cores, and the xfs filesystem format config is default,
> while the test is a single thread, as follow:
> ./mdtest -I 10  -z 6 -b 8 -d /mnt/ -t -c 2

What version and where do I get it?

Hmmm - isn't mdtest a MPI benchmark intended for highly concurrent
metadata workload testing? How representative is it of your actual
production workload? Is that single threaded?

> xfs info:
> meta-data=/dev/bcache2           isize=512    agcount=4, agsize=244188661 blks

only 4 AGs, which explains the lack of free inodes - there isn't
enough concurrency in the filesystem layout to push the free inode
count in all AGs beyond the batchsize * num_online_cpus().

i.e. single threaded workloads typically drain the free inode count
all the way down to zero before new inodes are allocated. Workloads
that are highly concurrent allocate from lots of AGs at once,
leaving free inodes in every AG that is not current being actively
allocated out of.

As a test, can you remake that test filesystem with "-d agcount=32"
and see if the overhead you are seeing disappears?

> > files and you have lots of idle CPU and hence the inode allocation
> > is not clearing the fast path batch threshold on the ifree counter.
> > And because you have lots of CPUs, the cost of a sum is very
> > expensive compared to running single threaded creates. That's my
> > current hypothesis based what I see on my workloads that
> > xfs_mod_ifree overhead goes down as concurrency goes up....
> > 
> 
> Agree, we add some debug info in xfs_mod_ifree and found most times
> m_ifree.count < batch * num_online_cpus(),  because we have 128 online
> cpus and m_ifree.count around 999.

Ok, the threshold is 32 * 128 = ~4000 to get out of the slow
path. 32 AGs may well push the count over this threshold, so it's
definitely worth trying....

> > FWIW, the profiles I took came from running this on 16 and 32p
> > machines:
> > 
> > --
> > dirs=""
> > for i in `seq 1 $THREADS`; do
> >         dirs="$dirs -d /mnt/scratch/$i"
> > done
> > 
> > cycles=$((512 / $THREADS))
> > 
> > time ./fs_mark $XATTR -D 10000 -S0 -n $NFILES -s 0 -L $cycles $dirs
> > --
> > 
> > With THREADS=16 or 32 and NFILES=100000 on a big sparse filesystem
> > image:
> > 
> > meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1
> > data     =                       bsize=4096   blocks=134217727500, imaxpct=1
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=521728, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > That's allocating enough inodes to keep the free inode counter
> > entirely out of the slow path...
> 
> percpu_counter_read that reads the count will cause cache synchronization
> cost if other cpu changes the count, Maybe it's better not to call
> percpu_counter_compare if possible.

Depends.  Sometimes we trade off ultimate single threaded
performance and efficiency for substantially better scalability.
i.e. if we lose 5% on single threaded performance but gain 10x on
concurrent workloads, then that is a good tradeoff to make.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
