Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD0857CA4
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:27:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B7CF304043
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 09:27:17 -0800 (PST)
Received: from 10.mo175.mail-out.ovh.net (10.mo175.mail-out.ovh.net
	[46.105.63.108]) by cuda.sgi.com with ESMTP id phmF8bDrDXyIWW7p
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Feb 2016 09:27:08 -0800 (PST)
Message-ID: <56CDE801.2030402@corp.ovh.com>
Date: Wed, 24 Feb 2016 18:27:29 +0100
From: Jean-Tiare Le Bigot <jean-tiare.le-bigot@corp.ovh.com>
MIME-Version: 1.0
Subject: Re: backport 7a29ac474a47eb8cf212b45917683ae89d6fa13b to stable ?
References: <56CC852F.7010507@corp.ovh.com> <20160223224555.GM25832@dastard>
In-Reply-To: <20160223224555.GM25832@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi,

Thanks for having a look.

On 02/23/2016 11:45 PM, Dave Chinner wrote:
> On Tue, Feb 23, 2016 at 05:13:35PM +0100, Jean-Tiare Le Bigot wrote:
>> Hi,
>>
>> We've hit kernel hang related to XFS reclaim under heavy I/O load on a
>> couple of storage servers using XFS over flashcache over a 3.13.y kernel.
>>
>> On the crash dumps, kthreadd is blocked, waiting for XFS to reclaim some
>> memory but the related reclaim job is queued on a worker_pool stuck
>> waiting for some I/O, itself depending on other jobs on other queues
>> which would require additional threads to go forward. Unfortunately
>> kthreadd is blocked.
>> The host has plenty of memory (~128GB), about 80% of which being used
>> for the page cache.
>>
>> It looks like this is fixed by commit
>> 7a29ac474a47eb8cf212b45917683ae89d6fa13b.
> 
> That commit fixed a regression introduced, IIRC, in 3.19. The
> problem it fixed didn't exist before then, so I doubt you are seeing
> the problem that the above commit fixed. Perhaps you'd like to
> describe your problem along with the stack traces, etc so we have
> some idea of what you are trying to to fix?

On the dump we investigated, kthreadd is stuck, waiting for some memory

crash> bt 2
PID: 2      TASK: ffff881fd2a39800  CPU: 0   COMMAND: "kthreadd"
 #0 [ffff881fd2ab37c8] __schedule at ffffffff81724e19
 #1 [ffff881fd2ab3830] io_schedule at ffffffff817255fd
 #2 [ffff881fd2ab3848] __xfs_iunpin_wait at ffffffffa06cf269 [xfs]
 #3 [ffff881fd2ab38c0] xfs_iunpin_wait at ffffffffa06d2629 [xfs]
 #4 [ffff881fd2ab38d0] xfs_reclaim_inode at ffffffffa068ed4c [xfs]
 #5 [ffff881fd2ab3910] xfs_reclaim_inodes_ag at ffffffffa068f267 [xfs]
 #6 [ffff881fd2ab3aa0] xfs_reclaim_inodes_nr at ffffffffa068fd73 [xfs]
 #7 [ffff881fd2ab3ac0] xfs_fs_free_cached_objects at ffffffffa069a3a5 [xfs]
 #8 [ffff881fd2ab3ad0] super_cache_scan at ffffffff811c13e9
 #9 [ffff881fd2ab3b18] shrink_slab at ffffffff81160f27
#10 [ffff881fd2ab3bc0] do_try_to_free_pages at ffffffff8116405d
#11 [ffff881fd2ab3c38] try_to_free_pages at ffffffff8116429c
#12 [ffff881fd2ab3cd8] __alloc_pages_nodemask at ffffffff81158f15
#13 [ffff881fd2ab3e10] copy_process at ffffffff810652b3
#14 [ffff881fd2ab3e90] do_fork at ffffffff810669f5
#15 [ffff881fd2ab3ef8] kernel_thread at ffffffff81066c86
#16 [ffff881fd2ab3f08] kthreadd at ffffffff8108beea
#17 [ffff881fd2ab3f50] ret_from_fork at ffffffff817318bc

This triggered the insertion of a xfs-reclaim job for device dm-46 on
the workerpool bound to cpu #0

This xfs_reclaim job is the first *pending* job on the workerpool. The
workerpool has 2 active workers stuck in "xfs_log_worker" both blocked
in "xlog_state_get_iclog_space". My guess is they are waiting for some
underlying flashcache I/O (which won't happen, see below)


--> busy_hash aka busy workers:
crash> struct worker_pool.busy_hash 0xffff88207fc12d40 | grep -o 0xf.*
0xffff8806dd3b5780  --> 132626
                    --> in xfs_log_worker
                    --> in xlog_state_get_iclog_space
                    --> dm-40
0xffff88142d06ae80  --> 129142
                    --> in xfs_log_worker
                    --> in xlog_state_get_iclog_space
                    --> dm-63

--> pending jobs:
crash> list -o work_struct.entry -s work_struct.func -H ffff88207fc12d58
-x | awk 'BEGIN{w="";c=0} {if($1=="func") printf("%2d %s --> %s\n", c,
w, $4); else {w=$1;c++}}'
   WORK                 FUNC                    DEVICE
 1 ffff881fceda6ca8 --> <xfs_reclaim_worker>    dm-46
 2 ffff881fcd51bc28 --> <xfs_log_worker>        dm-46
 3 ffff88207fc0f3a0 --> <vmstat_update>         N/A
 ...

To progress this queue needs either:
- the I/O to complete
- a new thread to handle the xfs_reclaim
  (which does not trigger I/O in this context, If I got the code right)

The I/O is stuck so we need a new thread. The pool manager requested
this thread BUT the request is pending in kthreadd queue. It is #5 in
the line

crash> list -o kthread_create_info.list -s kthread_create_info -H
kthread_create_list | grep threadfn | sort | uniq -c
Hence 'data' field represents a struct worker
               WORKER POOL               ID
 1 0xffff881851c50780 0xffff881fff011c00 4  unbound pool 24
 2 0xffff881a08c5b680 0xffff881fd1cb4c00 0  unbound pool 25
 3 0xffff881295297700 0xffff88207fd72d40 0  cpu 11  pool 22
 4 0xffff88131ed9c580 0xffff88207fc72d40 1  cpu 3   pool  6
 5 0xffff88062e8e9b80 0xffff88207fc12d40 0  cpu 0   pool  0
 6 0xffff8819440d1500 0xffff88207fc92d40 2  cpu 4   pool  8
 7 0xffff8802288aa280 0xffff88207fc52d40 0  cpu 2   pool  4
 8 0xffff88120d711200 0xffff88207fcb2d40 0  cpu 5   pool 10
 9 0xffff881cf648fb00 0xffff88207fc32d40 0  cpu 1   pool  2
10 0xffff8819c1471a00 0xffff88207fd32d40 2  cpu 9   pool 18

Hence, the "mayday" mode should trigger and move the xfs_reclaim job to
the rescuer worker.

On the other hand, we also hit a similar issue on the underlying
flashcache. If it had not happened, I bet the system would not have locked.

Anyway, as I understood the code, flashcache queues a single job on the
default bound system queue. When this job is executed, it processes its
own internal queues sequentially. So basically, if this single job is
stuck, all I/Os of flashcache devices are stuck (!).

This is on queue #6

--> busy_hash aka busy workers:
0xffff881330823080 --> 139598
                   --> in xfs_end_io
                   --> in rwsem_down_write_failed
0xffff881330823c80 --> 139599
                   --> in xfs_end_io
                   --> in ???
0xffff880e1a890e80 --> 127402
                   --> in xfs_end_io
                   --> rwsem_down_write_failed

--> pending jobs:
crash> list -o work_struct.entry -s work_struct.func -H ffff88207fcd2d58
-x | awk 'BEGIN{w="";c=0} {if($1=="func") printf("    %2d %s --> %s\n",
c, w, $4); else {w=$1;c++}}'
   WORK                 FUNC                    NOTES
 1 ffffffffa062e780 --> <do_work>               FLASHCACHE JOB
 2 ffff881f582dd350 --> <flashcache_clean_all_sets>
 3 ffff88207fccf3a0 --> <vmstat_update>
 4 ffff881ed1d05350 --> <flashcache_clean_all_sets>
 5 ffff881fff010d10 --> <vmpressure_work_fn>
 6 ffff881d9998bca8 --> <xfs_reclaim_worker>    dm-4
 7 ffffffff81ca8880 --> <push_to_pool>
 8 ffff881fcc425ca8 --> <xfs_reclaim_worker>    dm-45
 9 ffff88207fccf180 --> <lru_add_drain_per_cpu>

Flashcache job is #1 (yes, the explicit 'do_work' name). All workers are
waiting for I/O. The pool is waiting for a thread. Which is waiting for
memory. Which ... OK, we're stuck.

Some assumptions may be wrong, I have seemingly truncated stack traces
looking like, this does not help much :s

crash> bt 139599
PID: 139599  TASK: ffff8816c7970000  CPU: 6   COMMAND: "kworker/6:1"
 #0 [ffff88011c407700] __schedule at ffffffff81724e19
 #1 [ffff88011c407768] schedule at ffffffff817252d9
 #2 [ffff88011c407778] schedule_timeout at ffffffff81724529

Long story short, My understanding is that the hang is the result of a
design issue in flashcache, which could be helped in such not-so-low-mem
situation (80% is page cache) if the reclaim job had a rescuer thread.

Actually, the quick prod fix was a clever brute force hack in flashcache.

Regards,

> 
> Cheers,
> 
> Dave.
> 


-- 
Jean-Tiare Le Bigot, OVH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
