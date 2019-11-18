Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A83C432C3
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA9422084C
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfKRIMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:12:18 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59289 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbfKRIMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 03:12:18 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7F29943EBDB;
        Mon, 18 Nov 2019 19:12:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iWc8q-0007dF-60; Mon, 18 Nov 2019 19:12:12 +1100
Date:   Mon, 18 Nov 2019 19:12:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191118081212.GT4614@dread.disaster.area>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
 <20191105040325.GC4614@dread.disaster.area>
 <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
 <20191106212041.GF4614@dread.disaster.area>
 <d627883a-850c-1ec4-e057-cf9e9b47c50e@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d627883a-850c-1ec4-e057-cf9e9b47c50e@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=i0EeH86SAAAA:8 a=8TBquL46AAAA:20 a=HTyxxZSGAAAA:20 a=H0UjT0FRAAAA:20
        a=7-415B0cAAAA:8 a=waTbVBvWG9dj69r1T4AA:9 a=89pHtDRZ663gfxcD:21
        a=4pwdkveum5BcnxV0:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 01:58:56PM +0800, Shaokun Zhang wrote:
> Hi Dave,
> 
> On 2019/11/7 5:20, Dave Chinner wrote:
> > On Wed, Nov 06, 2019 at 02:00:58PM +0800, Shaokun Zhang wrote:
> >> Hi Dave,
> >>
> >> On 2019/11/5 12:03, Dave Chinner wrote:
> >>> On Tue, Nov 05, 2019 at 11:26:32AM +0800, Shaokun Zhang wrote:
> >>>> Hi Dave,
> >>>>
> >>>> On 2019/11/5 4:49, Dave Chinner wrote:
> >>>>> On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
> >>>>>> From: Yang Guo <guoyang2@huawei.com>
> >>>>>>
> >>>>>> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
> >>>>>> whether the counter less than 0 and it is a expensive function.
> >>>>>> let's check it only when delta < 0, it will be good for xfs's performance.
> >>>>>
> >>>>> Hmmm. I don't recall this as being expensive.
> >>>>>
> >>>>
> >>>> Sorry about the misunderstanding information in commit message.
> >>>>
> >>>>> How did you find this? Can you please always document how you found
> >>>>
> >>>> If user creates million of files and the delete them, We found that the
> >>>> __percpu_counter_compare costed 5.78% CPU usage, you are right that itself
> >>>> is not expensive, but it calls __percpu_counter_sum which will use
> >>>> spin_lock and read other cpu's count. perf record -g is used to profile it:
> >>>>
> >>>> - 5.88%     0.02%  rm  [kernel.vmlinux]  [k] xfs_mod_ifree
> >>>>    - 5.86% xfs_mod_ifree
> >>>>       - 5.78% __percpu_counter_compare
> >>>>            5.61% __percpu_counter_sum
> >>>
> >>> Interesting. Your workload is hitting the slow path, which I most
> >>> certainly do no see when creating lots of files. What's your
> >>> workload?
> >>>
> >>
> >> The hardware has 128 cpu cores, and the xfs filesystem format config is default,
> >> while the test is a single thread, as follow:
> >> ./mdtest -I 10  -z 6 -b 8 -d /mnt/ -t -c 2
> > 
> > What version and where do I get it?
> 
> You can get the mdtest from github: https://github.com/LLNL/mdtest.

Oh what a pain.

$ MPI_CC=mpicc make mpicc -DLinux -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE=1 -D__USE_LARGEFILE64=1  -g -o mdtest mdtest.c -lm
mdtest.c:32:10: fatal error: mpi.h: No such file or directory
 32 | #include "mpi.h"
    |          ^~~~~~~
compilation terminated.
make: *** [Makefile:59: mdtest] Error 1

It doesn't build with a modern linux distro openmpi installation.

/me looks at the readme.

Oh, it's an unmaintained historical archive.

Hmmm, it got forked to https://github.com/MDTEST-LANL/mdtest.

That's an unmaintained archive, too.

Oh, there's a version at https://github.com/hpc/ior

Ngggh.

$./configure
....
checking for mpicc... mpicc
checking for gcc... (cached) mpicc
checking whether the C compiler works... no
configure: error: in `/home/dave/src/ior':
configure: error: C compiler cannot create executables
See `config.log' for more details
$
$ less config.log
....
configure:3805: checking whether the C compiler works
configure:3827: mpicc    conftest.c  >&5
/usr/bin/ld: cannot find -lopen-rte
/usr/bin/ld: cannot find -lopen-pal
/usr/bin/ld: cannot find -lhwloc
/usr/bin/ld: cannot find -levent
/usr/bin/ld: cannot find -levent_pthreads
collect2: error: ld returned 1 exit status
configure:3831: $? = 1
.....

So, the mpicc compiler wrapper uses a bunch of libraries that don't
get installed with the compiler wrapper.

Yay?

> > Hmmm - isn't mdtest a MPI benchmark intended for highly concurrent
> > metadata workload testing? How representative is it of your actual
> > production workload? Is that single threaded?
> > 
> 
> We just use mdtest to test the performance of a file system, it can't representative
> the actual workload and it's single threaded. But we also find that it goes to slow
> path when we remove a dir with many files. The cmd is below:
> rm -rf xxx.

The benchmark doesn't reproduce that. It will only occur when you do
sequential inode remove so you have no free inodes in the filesytem
and every set of 64 inodes that is remove land in the same chunk and
so are immediately freed, leaving zero inodes in the filesyste,

i.e. this is a result of sequential inode create, which typically
implies "empty filesystem". Aged filesystems typically don't behave
like this - they have free indoes distributed all through the inode
chunks on disk. And if you do random remove, you won't see it for
the same reason, either - the remove phase of mdtest doesn't show
any CPU usage in percpu_counter_sum() at all.

Please understand taht I'm not saying that it isn't a problem,
that it doesn't happen, or that we don't need to change the
bahviour. What I'm trying to do is understand the
conditions in which this problem occurs and whether they are real
world or just micro-benchmark related problems...

> Because percpu_counter_batch was initialized to 256 when there are 128 cpu cores.
> Then we change the agcount=1024, and it also goes to slow path frequently because
> mostly there are no 32768 free inodes.

Hmmm. I had forgotten the batch size increased with CPU count like
that - I had the thought it was log(ncpus), not linear(ncpus).

That kinda points out that scaling the batch size by CPU count is
somewhat silly, as concurrency on the counter is not defined by the
number of CPUs in the system. INode counter concurrency is defined
by the number of inode allocation/free operations that can be
performed at any given time.

As such, having a counter threshold of 256 * num_cpus doesn't make a
whole lot of sense for a 4 AG filesystem because you can't have 128
CPUs all banging on it at once. And even if you have hundreds of
AGs, the CPUs are going to be somewhat serialised through the
transaction commit path by the CIL locks that are taken to insert
objects into the CIL.

Hence the unbound concurrency of transaction commit is going to be
soaked up by the CIL list insert spin lock, and it's mostly going to be
just a dribble of CPUs at a time through the transaction commit
accounting code.

Ok, so maybe we just need a small batch size here, like a value of 4
or 8 just to avoid every inode alloc/free transaction having to pick
up a global spin lock every time...

Let me do some testing here...

> >> percpu_counter_read that reads the count will cause cache synchronization
> >> cost if other cpu changes the count, Maybe it's better not to call
> >> percpu_counter_compare if possible.
> > 
> > Depends.  Sometimes we trade off ultimate single threaded
> > performance and efficiency for substantially better scalability.
> > i.e. if we lose 5% on single threaded performance but gain 10x on
> > concurrent workloads, then that is a good tradeoff to make.
> > 
> 
> Agree, I mean that when delta > 0, there is no need to call percpu_counter_compare in
> xfs_mod_ifree/icount.

It also doesn't totally avoid the issue, either, because of the
way we dynamically alloc/free inode clusters and so the counters go
both up and down during conmtinuous allocation or continuous
freeing.

i.e. The pattern we see on inode allocation is:

	icount += 64
	ifree += 64
	ifree--
	....
	ifree--
	icount += 64
	ifree += 64
	ifree--
	....
	ifree--

And on inode freeing, we see the opposite:

	ifree++
	....
	ifree++
	icount -= 64
	ifree -= 64
	ifree++
	....
	ifree++
	icount -= 64
	ifree -= 64

So the the values of ifree will still decrement during both free and
allocation operations, hence it doesn't avoid the issue totally.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
