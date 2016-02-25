Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54FDF7F91
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 10:45:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 248C18F8035
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 08:45:34 -0800 (PST)
Received: from 6.mo175.mail-out.ovh.net (6.mo175.mail-out.ovh.net
	[46.105.47.107]) by cuda.sgi.com with ESMTP id vLnBapJbbd6GIesC
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Feb 2016 08:45:31 -0800 (PST)
Message-ID: <56CF2FC1.10506@corp.ovh.com>
Date: Thu, 25 Feb 2016 17:45:53 +0100
From: Jean-Tiare Le Bigot <jean-tiare.le-bigot@corp.ovh.com>
MIME-Version: 1.0
Subject: Re: backport 7a29ac474a47eb8cf212b45917683ae89d6fa13b to stable ?
References: <56CC852F.7010507@corp.ovh.com> <20160223224555.GM25832@dastard>
	<56CDE801.2030402@corp.ovh.com> <20160224213038.GK14668@dastard>
In-Reply-To: <20160224213038.GK14668@dastard>
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

Thanks for these in depth explanations. I understood my mistake.
"xfs_reclaim_inodes_nr" ensures the background job on queue #0 is
scheduled but also run a synchronous reclaim which is blocked by the
I/O. For some reason, I focused on the job and completely forgot the
synchronous part.

Hence the only way to fix this hang is to fix flashcache to use a
dedicated queue with a rescuer thread. Which has nothing to do with XFS.

Regards,

On 02/24/2016 10:30 PM, Dave Chinner wrote:
> On Wed, Feb 24, 2016 at 06:27:29PM +0100, Jean-Tiare Le Bigot wrote:
>> Hi,
>>
>> Thanks for having a look.
>>
>> On 02/23/2016 11:45 PM, Dave Chinner wrote:
>>> On Tue, Feb 23, 2016 at 05:13:35PM +0100, Jean-Tiare Le Bigot wrote:
>>>> Hi,
>>>>
>>>> We've hit kernel hang related to XFS reclaim under heavy I/O load on a
>>>> couple of storage servers using XFS over flashcache over a 3.13.y kernel.
>>>>
>>>> On the crash dumps, kthreadd is blocked, waiting for XFS to reclaim some
>>>> memory but the related reclaim job is queued on a worker_pool stuck
>>>> waiting for some I/O, itself depending on other jobs on other queues
>>>> which would require additional threads to go forward. Unfortunately
>>>> kthreadd is blocked.
>>>> The host has plenty of memory (~128GB), about 80% of which being used
>>>> for the page cache.
>>>>
>>>> It looks like this is fixed by commit
>>>> 7a29ac474a47eb8cf212b45917683ae89d6fa13b.
>>>
>>> That commit fixed a regression introduced, IIRC, in 3.19. The
>>> problem it fixed didn't exist before then, so I doubt you are seeing
>>> the problem that the above commit fixed. Perhaps you'd like to
>>> describe your problem along with the stack traces, etc so we have
>>> some idea of what you are trying to to fix?
>>
>> On the dump we investigated, kthreadd is stuck, waiting for some memory
>>
>> crash> bt 2
>> PID: 2      TASK: ffff881fd2a39800  CPU: 0   COMMAND: "kthreadd"
>>  #0 [ffff881fd2ab37c8] __schedule at ffffffff81724e19
>>  #1 [ffff881fd2ab3830] io_schedule at ffffffff817255fd
>>  #2 [ffff881fd2ab3848] __xfs_iunpin_wait at ffffffffa06cf269 [xfs]
>>  #3 [ffff881fd2ab38c0] xfs_iunpin_wait at ffffffffa06d2629 [xfs]
>>  #4 [ffff881fd2ab38d0] xfs_reclaim_inode at ffffffffa068ed4c [xfs]
>>  #5 [ffff881fd2ab3910] xfs_reclaim_inodes_ag at ffffffffa068f267 [xfs]
>>  #6 [ffff881fd2ab3aa0] xfs_reclaim_inodes_nr at ffffffffa068fd73 [xfs]
>>  #7 [ffff881fd2ab3ac0] xfs_fs_free_cached_objects at ffffffffa069a3a5 [xfs]
>>  #8 [ffff881fd2ab3ad0] super_cache_scan at ffffffff811c13e9
>>  #9 [ffff881fd2ab3b18] shrink_slab at ffffffff81160f27
>> #10 [ffff881fd2ab3bc0] do_try_to_free_pages at ffffffff8116405d
>> #11 [ffff881fd2ab3c38] try_to_free_pages at ffffffff8116429c
>> #12 [ffff881fd2ab3cd8] __alloc_pages_nodemask at ffffffff81158f15
>> #13 [ffff881fd2ab3e10] copy_process at ffffffff810652b3
>> #14 [ffff881fd2ab3e90] do_fork at ffffffff810669f5
>> #15 [ffff881fd2ab3ef8] kernel_thread at ffffffff81066c86
>> #16 [ffff881fd2ab3f08] kthreadd at ffffffff8108beea
>> #17 [ffff881fd2ab3f50] ret_from_fork at ffffffff817318bc
> 
> So, it's waiting for a log force to complete because it needs to
> reclaim a dirty inode...
> 
>> This triggered the insertion of a xfs-reclaim job for device dm-46 on
>> the workerpool bound to cpu #0
>>
>> This xfs_reclaim job is the first *pending* job on the workerpool. The
>> workerpool has 2 active workers stuck in "xfs_log_worker" both blocked
>> in "xlog_state_get_iclog_space". My guess is they are waiting for some
>> underlying flashcache I/O (which won't happen, see below)
>>
>>
>> --> busy_hash aka busy workers:
>> crash> struct worker_pool.busy_hash 0xffff88207fc12d40 | grep -o 0xf.*
>> 0xffff8806dd3b5780  --> 132626
>>                     --> in xfs_log_worker
>>                     --> in xlog_state_get_iclog_space
>>                     --> dm-40
>> 0xffff88142d06ae80  --> 129142
>>                     --> in xfs_log_worker
>>                     --> in xlog_state_get_iclog_space
>>                     --> dm-63
> 
> These are both waiting on IO completion of log IO. And the IO
> completion is blocked behind metadata buffer completion that is
> blocked waiting on locks. Yes, this can happen when we are running
> low on memory, but it can also occur when we hit maximum workqueue
> concurrency limits. The problem is not solved by adding a rescuer
> thread to the workqueue because it ends up blocking, too.
> 
>> --> pending jobs:
>> crash> list -o work_struct.entry -s work_struct.func -H ffff88207fc12d58
>> -x | awk 'BEGIN{w="";c=0} {if($1=="func") printf("%2d %s --> %s\n", c,
>> w, $4); else {w=$1;c++}}'
>>    WORK                 FUNC                    DEVICE
>>  1 ffff881fceda6ca8 --> <xfs_reclaim_worker>    dm-46
>>  2 ffff881fcd51bc28 --> <xfs_log_worker>        dm-46
>>  3 ffff88207fc0f3a0 --> <vmstat_update>         N/A
>>  ...
>>
>> To progress this queue needs either:
>> - the I/O to complete
>> - a new thread to handle the xfs_reclaim
>>   (which does not trigger I/O in this context, If I got the code right)
> 
> The reclaim worker runs background inode reclaim - it doesn't
> guarantee forwards progress. Running it won't make the log IO
> completion the kthreadd is waiting on complete any faster, because
> that's not what is preventing IO completion from running.
> 
>> The I/O is stuck so we need a new thread. The pool manager requested
>> this thread BUT the request is pending in kthreadd queue. It is #5 in
>> the line
> 
> Actually, we needed a different workqueue that is marked as a high
> priority workqueue so log IO completion doesn't get held up by
> metadata buffer IO completion waiting on locks and stalling.  This
> is the problem that commit b29c70f59870 ("xfs: split metadata and
> log buffer completion to separate workqueues") addressed in 3.18
> addressed.
> 
> Remember how I said commit 7a29ac474 ("xfs: give all workqueues
> rescuer threads") fixed a regression we'd introduced, not the
> problem you are reporting?  Yeah, in commit b29c70f59870 I forgot to
> add the WQ_MEM_RECLAIM to the m_log_workqueue when we moved all the
> log IO completions to it and that introduced the problem seen in
> subsequent kernels.
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
