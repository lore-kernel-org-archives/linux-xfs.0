Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74ECC5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 06:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B09217D7
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 06:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfKFGBK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 01:01:10 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:39914 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfKFGBJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Nov 2019 01:01:09 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8C8E5E464016A5528EC9;
        Wed,  6 Nov 2019 14:01:06 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 6 Nov 2019
 14:00:58 +0800
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
To:     Dave Chinner <david@fromorbit.com>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
 <20191105040325.GC4614@dread.disaster.area>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
Date:   Wed, 6 Nov 2019 14:00:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191105040325.GC4614@dread.disaster.area>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 2019/11/5 12:03, Dave Chinner wrote:
> On Tue, Nov 05, 2019 at 11:26:32AM +0800, Shaokun Zhang wrote:
>> Hi Dave,
>>
>> On 2019/11/5 4:49, Dave Chinner wrote:
>>> On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
>>>> From: Yang Guo <guoyang2@huawei.com>
>>>>
>>>> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
>>>> whether the counter less than 0 and it is a expensive function.
>>>> let's check it only when delta < 0, it will be good for xfs's performance.
>>>
>>> Hmmm. I don't recall this as being expensive.
>>>
>>
>> Sorry about the misunderstanding information in commit message.
>>
>>> How did you find this? Can you please always document how you found
>>
>> If user creates million of files and the delete them, We found that the
>> __percpu_counter_compare costed 5.78% CPU usage, you are right that itself
>> is not expensive, but it calls __percpu_counter_sum which will use
>> spin_lock and read other cpu's count. perf record -g is used to profile it:
>>
>> - 5.88%     0.02%  rm  [kernel.vmlinux]  [k] xfs_mod_ifree
>>    - 5.86% xfs_mod_ifree
>>       - 5.78% __percpu_counter_compare
>>            5.61% __percpu_counter_sum
> 
> Interesting. Your workload is hitting the slow path, which I most
> certainly do no see when creating lots of files. What's your
> workload?
> 

The hardware has 128 cpu cores, and the xfs filesystem format config is default,
while the test is a single thread, as follow:
./mdtest -I 10  -z 6 -b 8 -d /mnt/ -t -c 2

xfs info:
meta-data=/dev/bcache2           isize=512    agcount=4, agsize=244188661 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=1 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=976754644, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1	
log      =internal               bsize=4096   blocks=476930, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

disk info:
Disk /dev/bcache2: 4000.8 GB, 4000787021824 bytes, 7814037152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> IOWs, we typically measure the overhead of such functions by kernel
>>> profile.  Creating ~200,000 inodes a second, so hammering the icount
>>> and ifree counters, I see:
>>>
>>>       0.16%  [kernel]  [k] percpu_counter_add_batch
>>>       0.03%  [kernel]  [k] __percpu_counter_compare
>>>
>>
>> 0.03% is just __percpu_counter_compare's usage.
> 
> No, that's the total of _all_ the percpu counter functions captured
> by the profile - it was the list of all samples filtered by
> "percpu". I just re-ran the profile again, and got:
> 
> 
>    0.23%  [kernel]  [k] percpu_counter_add_batch
>    0.04%  [kernel]  [k] __percpu_counter_compare
>    0.00%  [kernel]  [k] collect_percpu_times
>    0.00%  [kernel]  [k] __handle_irq_event_percpu
>    0.00%  [kernel]  [k] __percpu_counter_sum
>    0.00%  [kernel]  [k] handle_irq_event_percpu
>    0.00%  [kernel]  [k] fprop_reflect_period_percpu.isra.0
>    0.00%  [kernel]  [k] percpu_ref_switch_to_atomic_rcu
>    0.00%  [kernel]  [k] free_percpu
>    0.00%  [kernel]  [k] percpu_ref_exit
> 
> So you can see that this essentially no samples in
> __percpu_counter_sum at all - my tests are not hitting the slow path
> at all, despite allocating inodes continuously.

Got it,

> 
> IOWs, your workload is hitting the slow path repeatedly, and so the
> question that needs to be answered is "why is the slow path actually
> being exercised?". IOWs, we need to know what your workload is, what
> the filesystem config is, what hardware (cpus, storage, etc) you are
> running on, etc. There must be some reason for the slow path being
> used, and that's what we need to understand first before deciding
> what the best fix might be...
> 
> I suspect that you are only running one or two threads creating

Yeah, we just run one thread test.

> files and you have lots of idle CPU and hence the inode allocation
> is not clearing the fast path batch threshold on the ifree counter.
> And because you have lots of CPUs, the cost of a sum is very
> expensive compared to running single threaded creates. That's my
> current hypothesis based what I see on my workloads that
> xfs_mod_ifree overhead goes down as concurrency goes up....
> 

Agree, we add some debug info in xfs_mod_ifree and found most times
m_ifree.count < batch * num_online_cpus(),  because we have 128 online
cpus and m_ifree.count around 999.


> FWIW, the profiles I took came from running this on 16 and 32p
> machines:
> 
> --
> dirs=""
> for i in `seq 1 $THREADS`; do
>         dirs="$dirs -d /mnt/scratch/$i"
> done
> 
> cycles=$((512 / $THREADS))
> 
> time ./fs_mark $XATTR -D 10000 -S0 -n $NFILES -s 0 -L $cycles $dirs
> --
> 
> With THREADS=16 or 32 and NFILES=100000 on a big sparse filesystem
> image:
> 
> meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=134217727500, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> That's allocating enough inodes to keep the free inode counter
> entirely out of the slow path...

percpu_counter_read that reads the count will cause cache synchronization
cost if other cpu changes the count, Maybe it's better not to call
percpu_counter_compare if possible.

Thanks,
Shaokun

> 
> Cheers,
> 
> Dave.
> 

