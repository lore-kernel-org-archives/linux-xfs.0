Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38836 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbfDJNzy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Apr 2019 09:55:54 -0400
Subject: Re: deadlock in XFS
References: <5CAD4BAA.6070805@shannon-data.com>
 <6b2bb427-537a-3ae0-e865-87212478234d@sandeen.net>
 <49c750b2-b856-14b3-0f94-183fba5a753b@shannon-data.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6a159b98-b4f5-c9f8-87ae-0cb9e51cce91@sandeen.net>
Date: Wed, 10 Apr 2019 08:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <49c750b2-b856-14b3-0f94-183fba5a753b@shannon-data.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Li <liming@shannon-data.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On 4/10/19 7:43 AM, Ming Li wrote:
> hi Eric,
> 
>     Thanks for your reply, do you know this change started from which version? or where can i find the changes list about XFS`s all versions?
> 

The change was 

commit 6bdcf26ade8825ffcdc692338e715cd7ed0820d8
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 3 10:34:46 2017 -0700

    xfs: use a b+tree for the in-core extent list

and related patches which went into 4.15.

$ git describe --contains 6bdcf26ade8825ffcdc692338e715cd7ed0820d8
xfs-4.15-merge-1~27

the master changelog for xfs is in git history for the kernel.

-Eric

> Ming Li
> 
> 
> On 2019/4/10 12:17, Eric Sandeen wrote:
>> On 4/9/19 8:49 PM, Ming Li wrote:
>>> hi,
>>>      It is my great honor writing to you.I`m a driver engineer from china, I have a problem when I`m testing xfs iops on Intel P4510 2.0T. xfs deadlocks in my testcase. messages as this:
>>>
>>> kworker/23:75(11126) possible memory allocation deadlock size 4194320 in kmem_alloc (mode:0x250)    (this memory allocation need more than 4M memory from  once kmalloc, I think it will failure always.)
>> This is a known deficiency in older kernels, because xfs requires contiguous
>> memory for extent management.  If a file is highly fragmented, you may run
>> into this.  It's fixed upstream in newer kernels with a different extent
>> management infrastructure.
>>
>> Best thing to do on an older kernel is to work around it by using something like
>> an extent size hint to minimize fragmentation.
>>
>> -Eric
>>
>>
>>
>>  
>>> or like this:
>>>
>>> Apr  8 06:10:33 r720_1 kernel: XFS: kworker/3:129(7679) possible memory allocation deadlock size 2316352 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:33 r720_1 kernel: [292720.008492] XFS: kworker/2:30(7476) possible memory allocation deadlock size 2221840 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:33 r720_1 kernel: XFS: kworker/2:30(7476) possible memory allocation deadlock size 2221840 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: [292720.168489] XFS: kworker/2:80(7554) possible memory allocation deadlock size 2208848 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: XFS: kworker/2:80(7554) possible memory allocation deadlock size 2208848 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: [292720.308505] XFS: kworker/2:1(6884) possible memory allocation deadlock size 2367680 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: XFS: kworker/2:1(6884) possible memory allocation deadlock size 2367680 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: [292720.728593] XFS: kworker/7:22(7098) possible memory allocation deadlock size 2228800 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: XFS: kworker/7:22(7098) possible memory allocation deadlock size 2228800 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: [292720.828529] XFS: kworker/7:95(7512) possible memory allocation deadlock size 2097728 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:34 r720_1 kernel: XFS: kworker/7:95(7512) possible memory allocation deadlock size 2097728 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: [292721.428557] XFS: kworker/5:1(7134) possible memory allocation deadlock size 2097184 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: XFS: kworker/5:1(7134) possible memory allocation deadlock size 2097184 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: [292721.468569] XFS: kworker/4:235(7923) possible memory allocation deadlock size 2097168 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: XFS: kworker/4:235(7923) possible memory allocation deadlock size 2097168 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: [292721.588576] XFS: kworker/3:129(7679) possible memory allocation deadlock size 2316352 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: XFS: kworker/3:129(7679) possible memory allocation deadlock size 2316352 in kmem_alloc (mode:0x250)
>>> Apr  8 06:10:35 r720_1 kernel: [292722.008652] XFS: kworker/2:30(7476) possible memory allocation deadlock size 2221840 in kmem_alloc (mode:0x250)
>>>
>>> (although xfs need memory less than 4M, but it still deadlocks.)
>>>
>>> And, I catched CallTrace:
>>> Call Trace:
>>> [<ffffffff8613a282>] dump_stack+0x19/0x1b
>>> [<ffffffffc055bcb7>] kmem_realloc+0x127/0x140 [xfs]
>>> [<ffffffffc052e1b2>] xfs_iext_realloc_indirect+0x22/0x40 [xfs]
>>> [<ffffffffc052e9bf>] xfs_iext_irec_new+0x3f/0x170 [xfs]
>>> [<ffffffffc052ec6a>] xfs_iext_add_indirect_multi+0x17a/0x2d0 [xfs]
>>> [<ffffffffc052efd1>] xfs_iext_add+0x211/0x2c0 [xfs]
>>> [<ffffffffc052f6f8>] xfs_iext_insert+0x58/0xf0 [xfs]
>>> [<ffffffffc0508bcd>] ? xfs_bmap_add_extent_unwritten_real+0x38d/0x18f0 [xfs]
>>> [<ffffffffc0508bcd>] xfs_bmap_add_extent_unwritten_real+0x38d/0x18f0 [xfs]
>>> [<ffffffffc050a246>] xfs_bmapi_convert_unwritten+0x116/0x1c0 [xfs]
>>> [<ffffffffc050f2e9>] xfs_bmapi_write+0x269/0xab0 [xfs]
>>> [<ffffffffc054aeb7>] xfs_iomap_write_unwritten+0x117/0x300 [xfs]
>>> [<ffffffffc0535f63>] xfs_end_io_direct_write+0x133/0x170 [xfs]
>>> [<ffffffff85c6e465>] dio_complete+0x125/0x2a0
>>> [<ffffffff85c6e761>] dio_aio_complete_work+0x21/0x30
>>> [<ffffffff85ab952f>] process_one_work+0x17f/0x440
>>> [<ffffffff85aba5c6>] worker_thread+0x126/0x3c0
>>> [<ffffffff85aba4a0>] ? manage_workers.isra.25+0x2a0/0x2a0
>>> [<ffffffff85ac1341>] kthread+0xd1/0xe0
>>> [<ffffffff85ac1270>] ? insert_kthread_work+0x40/0x40
>>> [<ffffffff8614caf7>] ret_from_fork_nospec_begin+0x21/0x21
>>> [<ffffffff85ac1270>] ? insert_kthread_work+0x40/0x40
>>>
>>>
>>> my test platform is:
>>> Architecture:          x86_64
>>> CPU op-mode(s):        32-bit, 64-bit
>>> Byte Order:            Little Endian
>>> CPU(s):                8
>>> On-line CPU(s) list:   0-7
>>> Thread(s) per core:    1
>>> Core(s) per socket:    4
>>> Socket(s):             2
>>> NUMA node(s):          2
>>> Vendor ID:             GenuineIntel
>>> CPU family:            6
>>> Model:                 62
>>> Model name:            Intel(R) Xeon(R) CPU E5-2609 v2 @ 2.50GHz
>>> Stepping:              4
>>> CPU MHz:               1199.951
>>> BogoMIPS:              5005.23
>>> Virtualization:        VT-x
>>> L1d cache:             32K
>>> L1i cache:             32K
>>> L2 cache:              256K
>>> L3 cache:              10240K
>>> NUMA node0 CPU(s):     0,2,4,6
>>> NUMA node1 CPU(s):     1,3,5,7
>>>
>>>
>>> memory size is(this problem is still in the server that has 256G memory, so i think it is not about memory size and swap is truned off):
>>>                total        used        free      shared buff/cache available
>>> Mem:             23          10          12           0 0 12
>>> Swap:            15           0          15
>>>
>>> system:
>>> centos 7.3.1611
>>>
>>> kernel:
>>> 3.10.0-957.10.1.el7.x86_64
>>>
>>> test step(fio version: 2.2.9):
>>> 1. mkfs.xfs /dev/nvme0n1
>>> 2. mount /dev/nvme0n1 /nvme0n1
>>> 3. fio --ioengine=libaio --randrepeat=0 --norandommap --thread --direct=1 --group_reporting --time_based --random_generator=tausworthe --runtime=7200 --output=20190409-174239+0800/fsiops/log/fsiops_xfs_randwrite_iops.log --directory=/nvme0n1 --size=190679M --bs=4k --name=xfs_randwrite_iops --rw=randwrite --numjobs=8 --iodepth=32
>>>
>>> xfs will deadlocks when running about 1 hours and 45 minutes, and i must cold restart my server.
>>>
>>> And i found a patch in community, it is:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/commit/?id=b3f03bac8132207a20286d5602eda64500c19724
>>>
>>> it have been merged since kernel 3.14, and i`m sure that this patch is not in 3.10.0-957.10.1.el7.x86_64.
>>> So, I use 3.14 to do my test, and this appearance was not appeared in 3.14.
>>>
>>> I don`t know about architecture of XFS, so i`m not sure whether they have relevant. Because i think the deadlock was in xfs_iext_realloc_indirect(), but the patch fixed about xfs_dir2_block_to_sf(). But the true is this problem don`t appear in kernel 3.14 anymore, so i think this problem have been fixed completely in 3.14.but i don`t know which patch fixed it.
>>>
>>> So, Would you tell me whether this patch is root cause, or which patch fixed it.
>>>
>>> Thank you for your attention to this matter.
>>>
>>> Best regards
>>>
>>>
>>> Ming.Li
>>>
>>>
>>>
>>>
> 
