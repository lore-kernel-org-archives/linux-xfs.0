Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7204C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 18:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9199923B79
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 18:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgLRSgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:36:14 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50261 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgLRSgN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Dec 2020 13:36:13 -0500
Received: from [192.168.0.8] (ip5f5aeee5.dynamic.kabel-deutschland.de [95.90.238.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D650220646234;
        Fri, 18 Dec 2020 19:35:29 +0100 (CET)
Subject: Re: v5.10.1 xfs deadlock
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
 <20201217194317.GD2507317@bfoster>
 <39b92850-f2ff-e4b6-0b2e-477ab3ec3c87@molgen.mpg.de>
 <20201218153533.GA2563439@bfoster>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <8e9a2939-220d-b12f-a24e-0fb48fa95215@molgen.mpg.de>
Date:   Fri, 18 Dec 2020 19:35:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218153533.GA2563439@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18.12.20 16:35, Brian Foster wrote:
> On Thu, Dec 17, 2020 at 10:30:37PM +0100, Donald Buczek wrote:
>> On 17.12.20 20:43, Brian Foster wrote:
>>> On Thu, Dec 17, 2020 at 06:44:51PM +0100, Donald Buczek wrote:
>>>> Dear xfs developer,
>>>>
>>>> I was doing some testing on a Linux 5.10.1 system with two 100 TB xfs filesystems on md raid6 raids.
>>>>
>>>> The stress test was essentially `cp -a`ing a Linux source repository with two threads in parallel on each filesystem.
>>>>
>>>> After about on hour, the processes to one filesystem (md1) blocked, 30 minutes later the process to the other filesystem (md0) did.
>>>>
>>>>       root      7322  2167  0 Dec16 pts/1    00:00:06 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/1/linux.018.TMP
>>>>       root      7329  2169  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/2/linux.019.TMP
>>>>       root     13856  2170  0 Dec16 pts/1    00:00:08 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/2/linux.028.TMP
>>>>       root     13899  2168  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/1/linux.027.TMP
>>>>
> 
> Do you have any indication of whether these workloads actually hung or
> just became incredibly slow?

There is zero progress. iostat doesn't show any I/O on any of the block devices (md or member)

>>>> Some info from the system (all stack traces, slabinfo) is available here: https://owww.molgen.mpg.de/~buczek/2020-12-16.info.txt
>>>>
>>>> It stands out, that there are many (549 for md0, but only 10 for md1)  "xfs-conv" threads all with stacks like this
>>>>
>>>>       [<0>] xfs_log_commit_cil+0x6cc/0x7c0
>>>>       [<0>] __xfs_trans_commit+0xab/0x320
>>>>       [<0>] xfs_iomap_write_unwritten+0xcb/0x2e0
>>>>       [<0>] xfs_end_ioend+0xc6/0x110
>>>>       [<0>] xfs_end_io+0xad/0xe0
>>>>       [<0>] process_one_work+0x1dd/0x3e0
>>>>       [<0>] worker_thread+0x2d/0x3b0
>>>>       [<0>] kthread+0x118/0x130
>>>>       [<0>] ret_from_fork+0x22/0x30
>>>>
>>>> xfs_log_commit_cil+0x6cc is
>>>>
>>>>     xfs_log_commit_cil()
>>>>       xlog_cil_push_background(log)
>>>>         xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
>>>>
> 
> This looks like the transaction commit throttling code. That was
> introduced earlier this year in v5.7 via commit 0e7ab7efe7745 ("xfs:
> Throttle commits on delayed background CIL push"). The purpose of that
> change was to prevent the CIL from growing too large. FWIW, I don't
> recall that being a functional problem so it should be possible to
> simply remove that blocking point and see if that avoids the problem or
> if we simply stall out somewhere else, if you wanted to give that a
> test.

Will do. Before trying with this commit reverted, I will repeat the test without any change to see if the problem is reproducible at all.

>>>> Some other threads, including the four "cp" commands are also blocking at xfs_log_commit_cil+0x6cc
>>>>
>>>> There are also single "flush" process for each md device with this stack signature:
>>>>
>>>>       [<0>] xfs_map_blocks+0xbf/0x400
>>>>       [<0>] iomap_do_writepage+0x15e/0x880
>>>>       [<0>] write_cache_pages+0x175/0x3f0
>>>>       [<0>] iomap_writepages+0x1c/0x40
>>>>       [<0>] xfs_vm_writepages+0x59/0x80
>>>>       [<0>] do_writepages+0x4b/0xe0
>>>>       [<0>] __writeback_single_inode+0x42/0x300
>>>>       [<0>] writeback_sb_inodes+0x198/0x3f0
>>>>       [<0>] __writeback_inodes_wb+0x5e/0xc0
>>>>       [<0>] wb_writeback+0x246/0x2d0
>>>>       [<0>] wb_workfn+0x26e/0x490
>>>>       [<0>] process_one_work+0x1dd/0x3e0
>>>>       [<0>] worker_thread+0x2d/0x3b0
>>>>       [<0>] kthread+0x118/0x130
>>>>       [<0>] ret_from_fork+0x22/0x30
>>>>
> 
> Is writeback still blocked as such or was this just a transient stack?

This is frozen. I did another collection of the stack dump today and all the stack trace (related to these two filesystems) are unchanged.

However, I discovered, that my original report was not correct. The above stack trace is from PID 348 ("kworker/u81:8+flush-9:0") while the other thread for the other device (PID 20, "kworker/u82:0+flush-9:1" doesn't have an identical thread, it has three more frames and is blocking at xfs_log_commit_cil+0x6cc as most other processes.

     [<0>] xfs_log_commit_cil+0x6cc/0x7c0
     [<0>] __xfs_trans_commit+0xab/0x320
     [<0>] xfs_bmapi_convert_delalloc+0x437/0x4b0
     [<0>] xfs_map_blocks+0x1e3/0x400
     [<0>] iomap_do_writepage+0x15e/0x880
     [<0>] write_cache_pages+0x175/0x3f0
     [<0>] iomap_writepages+0x1c/0x40
     [<0>] xfs_vm_writepages+0x59/0x80
     [<0>] do_writepages+0x4b/0xe0
     [<0>] __writeback_single_inode+0x42/0x300
     [<0>] writeback_sb_inodes+0x198/0x3f0
     [<0>] __writeback_inodes_wb+0x5e/0xc0
     [<0>] wb_writeback+0x246/0x2d0
     [<0>] wb_workfn+0x26e/0x490
     [<0>] process_one_work+0x1dd/0x3e0
     [<0>] worker_thread+0x2d/0x3b0
     [<0>] kthread+0x118/0x130
     [<0>] ret_from_fork+0x22/0x30

> 
>>>> xfs_map_blocks+0xbf is the
>>>>
>>>>       xfs_ilock(ip, XFS_ILOCK_SHARED);
>>>>
>>>> in xfs_map_blocks().
>>>>
>>>> The system is low on free memory
>>>>
>>>>       MemTotal:       197587764 kB
>>>>       MemFree:          2196496 kB
>>>>       MemAvailable:   189895408 kB
>>>>
>>>> but responsive.
>>>>
>>>> I have an out of tree driver for the HBA ( smartpqi 2.1.6-005 pulled from linux-scsi) , but it is unlikely that this blocking is related to that, because the md block devices itself are responsive (`xxd /dev/md0` )
>>>>
>>>> I can keep the system in the state for a while. Is there an idea what was going from or an idea what data I could collect from the running system to help? I have full debug info and could walk lists or retrieve data structures with gdb.
>>>>
>>>
>>> It might be useful to dump the values under /sys/fs/xfs/<dev>/log/* for
>>> each fs to get an idea of the state of the logs as well...
>>
>>
>> root@deadbird:~# for f in /sys/fs/xfs/*/log/*; do echo $f : $(cat $f);done
>> /sys/fs/xfs/md0/log/log_head_lsn : 5:714808
>> /sys/fs/xfs/md0/log/log_tail_lsn : 5:581592
>> /sys/fs/xfs/md0/log/reserve_grant_head : 5:365981696
>> /sys/fs/xfs/md0/log/write_grant_head : 5:365981696
> 
> Hm, so it looks like the log is populated but not necessarily full. What
> looks more interesting is that the grant heads (365981696 bytes) line up
> with the physical log head (714808 512b sectors). That suggests there is
> no outstanding transaction reservation and thus perhaps all workload
> tasks are sitting at that throttling point just after the current
> transaction commits and releases unused reservation. That certainly
> shouldn't be such a longstanding blocking point as it only waits for the
> CIL push to start.
> 
> Out of curiosity, have any of the above values changed since the sample
> provided here was collected? As above, I'm curious if the filesystem
> happens to be moving along slowly or not at all, whether the AIL has
> been drained in the background, etc.

Zero I/O on the block devices.
All related thread have exact same stack frame after >2days

> Could you post the xfs_info for the affected filesystems?

buczek@deadbird:~/linux_problems/mdX_raid6_looping/tests_with_deadbird/2020-12-16-01$ xfs_info /dev/md0
meta-data=/dev/md0               isize=512    agcount=102, agsize=268435328 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1
data     =                       bsize=4096   blocks=27348629504, imaxpct=1
          =                       sunit=128    swidth=1792 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
buczek@deadbird:~/linux_problems/mdX_raid6_looping/tests_with_deadbird/2020-12-16-01$ xfs_info /dev/md1
meta-data=/dev/md1               isize=512    agcount=102, agsize=268435328 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1
data     =                       bsize=4096   blocks=27348629504, imaxpct=1
          =                       sunit=128    swidth=1792 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


> Also since it seems like you should have plenty of available log
> reservation, are you able to perform any writable operations on the fs
> (i.e., touch <file>)? If so, I wonder if you were able to start a new
> copy workload on of the fs' capable of triggering the blocking threshold
> again, if that might eventually unstick the currently blocked tasks when
> the next CIL push occurs...

When I do something like

     touch /jbod/M8067/scratch/x.001

This doesn't block and shortly thereafter I see momentary write activity on the md and member devices. But the blocked processes don't resume.

     root@deadbird:~# iostat|grep md0 ; sleep 30 ; iostat|grep md0 ; touch /jbod/M8067/scratch/x.008 ; sleep 30 ; iostat|grep md0 ; sleep 30 ; iostat|grep md0
     md0              25.81        52.45      2385.56         0.00   12806780  582460904          0
     md0              25.81        52.45      2385.27         0.00   12806780  582460904          0
     md0              25.81        52.44      2384.98         0.00   12806780  582460908          0
     md0              25.80        52.43      2384.68         0.00   12806780  582460908          0

The touched files are visible with `ls`.

So then I tried something longer:

     cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/linux.001

which also triggerd a few I/Os in the beginning but then came to a perceived halt (no I/O in several minutes).

Interestingly, this new "cp" is not blocking on xfs_log_commit_cil+0x6cc as the four "cp" commands from the stress test but has this stack:

     [<0>] balance_dirty_pages+0x31c/0xd80
     [<0>] balance_dirty_pages_ratelimited+0x2f9/0x3c0
     [<0>] iomap_write_actor+0x11d/0x190
     [<0>] iomap_apply+0x117/0x2e0
     [<0>] iomap_file_buffered_write+0x62/0x90
     [<0>] xfs_file_buffered_aio_write+0xd3/0x320
     [<0>] new_sync_write+0x11f/0x1b0
     [<0>] vfs_write+0x1ea/0x250
     [<0>] ksys_write+0xa1/0xe0
     [<0>] do_syscall_64+0x33/0x40
     [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Maybe this would change if I waited a few hours more.

So I will reboot the system now and retry test test exactly the same configuration as then again with 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push") reverted.

Donald

> Brian
> 
>> /sys/fs/xfs/md1/log/log_head_lsn : 3:2963880
>> /sys/fs/xfs/md1/log/log_tail_lsn : 3:2772656
>> /sys/fs/xfs/md1/log/reserve_grant_head : 3:1517506560
>> /sys/fs/xfs/md1/log/write_grant_head : 3:1517506560
>> /sys/fs/xfs/sda1/log/log_head_lsn : 233:106253
>> /sys/fs/xfs/sda1/log/log_tail_lsn : 233:106251
>> /sys/fs/xfs/sda1/log/reserve_grant_head : 233:54403812
>> /sys/fs/xfs/sda1/log/write_grant_head : 233:54403812
>> /sys/fs/xfs/sda2/log/log_head_lsn : 84:5653
>> /sys/fs/xfs/sda2/log/log_tail_lsn : 84:5651
>> /sys/fs/xfs/sda2/log/reserve_grant_head : 84:2894336
>> /sys/fs/xfs/sda2/log/write_grant_head : 84:2894336
>>
>>
>>
>>>
>>> Brian
>>>
>>>> Best
>>>>     Donald
>>>>
>>>
>>
>> -- 
>> Donald Buczek
>> buczek@molgen.mpg.de
>> Tel: +49 30 8413 1433
>>
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
