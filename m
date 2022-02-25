Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A28CC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 21:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiBYVln (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 16:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiBYVlm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 16:41:42 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 628F81AE678
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 13:41:09 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C521010E13BF;
        Sat, 26 Feb 2022 08:41:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nNiKo-00GPAZ-35; Sat, 26 Feb 2022 08:41:06 +1100
Date:   Sat, 26 Feb 2022 08:41:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Performance regression when large number of tasks perform random
 I/O
Message-ID: <20220225214106.GP59715@dread.disaster.area>
References: <87czjb9haq.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87czjb9haq.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62194cf4
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=FJYg_c5LTFClOfLm3d8A:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 25, 2022 at 07:31:17PM +0530, Chandan Babu R wrote:
> Hi Dave,
> 
> When the following fio command is executed,
> 
> fio --eta=always --output=runlogs/randwrite4k_64jobs.out -name fio.test
> --directory=/data --rw=randwrite --bs=4k --size=4G --ioengine=libaio
> --iodepth=16 --direct=1 --time_based=1 --runtime=900 --randrepeat=1
> --gtod_reduce=1 --group_reporting=1 --numjobs=64 

So random writes to a dataset of 256GB of files?

So how is fio preallocating the run file? By writing zeros or
fallocate()?

If fallocate(), then unwritten extent conversion is needed after
every random write, and that's going to end up being the performance
limiting factor.

What happens with a workload like this where there are 1024
random writes in flight at once, we end up with 1024 kworkers
running DIO IO completion racing to convert unwritten extents. They
all take out unwritten extent conversion transaction reservations,
and that runs the log out of space.

$ pgrep kworker |wc -l
3025
$

When the log runs out of space, we switch to the reservation
slowpath where tasks are put to sleep. This which means it goes from
lockless to spinlock serialised:

-   62.46%     0.00%  [kernel]            [k] iomap_dio_complete_work
   - iomap_dio_complete_work
      - 62.34% iomap_dio_complete
         - 62.31% xfs_dio_write_end_io
            - 62.30% xfs_iomap_write_unwritten
               - 36.25% xfs_trans_alloc_inode
                  - 35.09% xfs_trans_alloc
                     - 35.08% xfs_trans_reserve
                        - 35.05% xfs_log_reserve
                           - 34.99% xlog_grant_head_check
                              - 20.16% _raw_spin_lock
                                 - do_raw_spin_lock
                                      20.13% __pv_queued_spin_lock_slowpath
                              - 14.14% xlog_grant_head_wait
                                 - 13.90% _raw_spin_lock
                                    - do_raw_spin_lock
                                         13.88% __pv_queued_spin_lock_slowpath
                              - 0.66% xlog_grant_head_wake
                                 - 0.64% wake_up_process
                                    - try_to_wake_up
                                       - 0.55% _raw_spin_lock_irqsave
                                            do_raw_spin_lock
                  - 1.14% xfs_ilock
                     - down_write
                        - 1.11% rwsem_down_write_slowpath
                             0.56% rwsem_spin_on_owner
               - 24.80% xfs_trans_commit
                  - __xfs_trans_commit
                     - 24.77% xlog_cil_commit
                        - 24.27% xfs_log_ticket_ungrant
                           - 24.23% xfs_log_space_wake
                              - 23.15% _raw_spin_lock
                                 - do_raw_spin_lock
                                      23.14% __pv_queued_spin_lock_slowpath
                              - 1.04% xlog_grant_head_wake
                                 - 1.01% wake_up_process
                                    - 0.99% try_to_wake_up
                                       - 0.84% _raw_spin_lock_irqsave
                                            do_raw_spin_lock
               - 1.14% xfs_bmapi_write
                  - 1.06% xfs_bmapi_convert_unwritten
                       1.04% xfs_bmap_add_extent_unwritten_real

And because there are 1024 threads banging on that transaction
reservation, we get severe lock contention.

As a result of this, until all the files have been converted to
written, the workload only runs at 40-50k write IOPS while burning
tens of CPUs on lock contention.

As the random writes hit converted extents more often, the IOPS rate
goes up because those writes don't need conversion at completion.
After 5 minutes of runtime on my machine, it's up to about 100kIOPs.
But, really, performance is nowhere near what the hardware can
produce because of the unwritten extent conversion behaviour under
these workloads - unbound parallelism is bad for performance.

After 12 minutes, all the files are converted and it runs at
1607kIOPs (1.6 million IOPS) which is the limit the hardware I have
can support.

End result was:

write: IOPS=206k, BW=805MiB/s (844MB/s)(708GiB/900009msec); 0 zone resets

Crap performance compared to what the hardware can do.

So, if we add '-fallocate=none' and re-run the workload immediately,
it runs at 1.6MIOPS right form the start, because the 4GB work files
are already on disk and fully written:

write: IOPS=1593k, BW=6222MiB/s (6525MB/s)(2844GiB/468091msec); 0 zone resets

So the perf problem you are seeing here is unbound concurrency in
unwritten extent conversion running the journal out of reservation
space, not a problem with the XFS journal performance....

> on an XFS instance having the following geometry,
> 
> # xfs_info /dev/tank/lvm
> meta-data=/dev/mapper/tank-lvm   isize=512    agcount=32, agsize=97675376 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=3125612032, imaxpct=5
>          =                       sunit=16     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # dmsetup table
> tank-lvm: 0 25004900352 striped 4 128 259:3 2048 259:2 2048 259:5 2048 259:8 2048
> 
> # lsblk
> nvme0n1      259:0    0   2.9T  0 disk
> └─nvme0n1p1  259:3    0   2.9T  0 part
>   └─tank-lvm 252:0    0  11.7T  0 lvm  /data
> nvme1n1      259:1    0   2.9T  0 disk
> └─nvme1n1p1  259:2    0   2.9T  0 part
>   └─tank-lvm 252:0    0  11.7T  0 lvm  /data
> nvme2n1      259:4    0   2.9T  0 disk
> └─nvme2n1p1  259:5    0   2.9T  0 part
>   └─tank-lvm 252:0    0  11.7T  0 lvm  /data
> nvme3n1      259:6    0   2.9T  0 disk
> └─nvme3n1p1  259:8    0   2.9T  0 part
>   └─tank-lvm 252:0    0  11.7T  0 lvm  /data

Yup, I just got the above numbers and profile from a 4-way RAID0
stripe of intel DC4800 SSDs, which can do (combined) about 1.6
million random 4kB writes.

> ... The following results are produced
> 
> ------------------------------------------------------
>  Kernel                                    Write IOPS 
> ------------------------------------------------------
>  v5.4                                      1050K      
>  b843299ba5f9a430dd26ecd02ee2fef805f19844  1040k      
>  0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b  835k       
>  v5.17-rc4                                 909k       
> ------------------------------------------------------
> 
> The commit 0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b (xfs: Throttle commits on
> delayed background CIL push) causes tasks (which commit transactions to the
> CIL) to get blocked (if cil->xc_ctx->space_used >=
> XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) until the CIL push worker is executed.

Yup, that fixed a CIL space overrun violation, which could cause
the journal on disk to become corrupted because it would allow the
CIL to overcommit the journal space on disk and so we could have the
head of the log overwrite the tail of the log before the metadata at
the tail of the log had been written back to disk.

IOWs, the speed that happened before this commit was because the
CIL batch sizes were allowed to grow illegally large and not bound
so could exceed half the size of journal. We must have two complete
checkpoints in the log at any given time for recovery to be able to
find the head and tail to recover them. If we get two checkpoints
in a row that are larger than half the log, the second checkpoint
overwrites the tail of previous checkpoint and we corrupt the log.

This occurred when the CIL push worker gets delayed (e.g. like when
thousands of pending unwritten extent conversion drowns the system
in thousands of busy kworkers), because it allowed the CIL to keep
growing right up till the push kworker got scheduled and ran.

It's no surprise this makes this fio workload run slower - without
the patch it is likely the fio workload is violating journal
checkpoint size limits and if we crash at that point log recovery
will then fail and lots of data will be lost...

As I always say: correctness first, performance second.

If we need to improve or restore performance on this workload, we
need to address the behaviour of unwritten extent conversion and
reduce the overhead of performing millions of tiny, independent
conversion transactions like this. A good start would be to bound
the maximum concurrency of workqueue based DIO IO completion to stop
if from being able to fully exhaust log reservations with blocked
conversions (e.g. one completion worker thread per inode, not
1 completion thread per IO).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
