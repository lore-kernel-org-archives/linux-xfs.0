Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A71CA9EC7
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 04:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC8320659
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 04:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbfKEEDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 23:03:32 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35444 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729711AbfKEEDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 23:03:32 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D6E4C3A1784;
        Tue,  5 Nov 2019 15:03:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iRq3x-0000dP-7q; Tue, 05 Nov 2019 15:03:25 +1100
Date:   Tue, 5 Nov 2019 15:03:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191105040325.GC4614@dread.disaster.area>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8 a=w1VptvuhYDPMJX4mGNAA:9
        a=ggN-k8jfiSgHKobi:21 a=dRI7x4IBfIF0c0dP:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 11:26:32AM +0800, Shaokun Zhang wrote:
> Hi Dave,
> 
> On 2019/11/5 4:49, Dave Chinner wrote:
> > On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
> >> From: Yang Guo <guoyang2@huawei.com>
> >>
> >> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
> >> whether the counter less than 0 and it is a expensive function.
> >> let's check it only when delta < 0, it will be good for xfs's performance.
> > 
> > Hmmm. I don't recall this as being expensive.
> > 
> 
> Sorry about the misunderstanding information in commit message.
> 
> > How did you find this? Can you please always document how you found
> 
> If user creates million of files and the delete them, We found that the
> __percpu_counter_compare costed 5.78% CPU usage, you are right that itself
> is not expensive, but it calls __percpu_counter_sum which will use
> spin_lock and read other cpu's count. perf record -g is used to profile it:
> 
> - 5.88%     0.02%  rm  [kernel.vmlinux]  [k] xfs_mod_ifree
>    - 5.86% xfs_mod_ifree
>       - 5.78% __percpu_counter_compare
>            5.61% __percpu_counter_sum

Interesting. Your workload is hitting the slow path, which I most
certainly do no see when creating lots of files. What's your
workload?

> > IOWs, we typically measure the overhead of such functions by kernel
> > profile.  Creating ~200,000 inodes a second, so hammering the icount
> > and ifree counters, I see:
> > 
> >       0.16%  [kernel]  [k] percpu_counter_add_batch
> >       0.03%  [kernel]  [k] __percpu_counter_compare
> > 
> 
> 0.03% is just __percpu_counter_compare's usage.

No, that's the total of _all_ the percpu counter functions captured
by the profile - it was the list of all samples filtered by
"percpu". I just re-ran the profile again, and got:


   0.23%  [kernel]  [k] percpu_counter_add_batch
   0.04%  [kernel]  [k] __percpu_counter_compare
   0.00%  [kernel]  [k] collect_percpu_times
   0.00%  [kernel]  [k] __handle_irq_event_percpu
   0.00%  [kernel]  [k] __percpu_counter_sum
   0.00%  [kernel]  [k] handle_irq_event_percpu
   0.00%  [kernel]  [k] fprop_reflect_period_percpu.isra.0
   0.00%  [kernel]  [k] percpu_ref_switch_to_atomic_rcu
   0.00%  [kernel]  [k] free_percpu
   0.00%  [kernel]  [k] percpu_ref_exit

So you can see that this essentially no samples in
__percpu_counter_sum at all - my tests are not hitting the slow path
at all, despite allocating inodes continuously.

IOWs, your workload is hitting the slow path repeatedly, and so the
question that needs to be answered is "why is the slow path actually
being exercised?". IOWs, we need to know what your workload is, what
the filesystem config is, what hardware (cpus, storage, etc) you are
running on, etc. There must be some reason for the slow path being
used, and that's what we need to understand first before deciding
what the best fix might be...

I suspect that you are only running one or two threads creating
files and you have lots of idle CPU and hence the inode allocation
is not clearing the fast path batch threshold on the ifree counter.
And because you have lots of CPUs, the cost of a sum is very
expensive compared to running single threaded creates. That's my
current hypothesis based what I see on my workloads that
xfs_mod_ifree overhead goes down as concurrency goes up....

FWIW, the profiles I took came from running this on 16 and 32p
machines:

--
dirs=""
for i in `seq 1 $THREADS`; do
        dirs="$dirs -d /mnt/scratch/$i"
done

cycles=$((512 / $THREADS))

time ./fs_mark $XATTR -D 10000 -S0 -n $NFILES -s 0 -L $cycles $dirs
--

With THREADS=16 or 32 and NFILES=100000 on a big sparse filesystem
image:

meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=134217727500, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

That's allocating enough inodes to keep the free inode counter
entirely out of the slow path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
