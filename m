Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2BB365A1D
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633731; cv=none; b=BN3PdIiAQk2XeI1KLEzitnIxLAk3kJ3ITVc4q8nWvXTvJhogOGl0KtQWTIAsGPNM54G6kEdiNYWur9NZRDqLX9OWTKbvZxvOYVnRBBkgG+ptQhOCrIovpVYTB3ft0DKi3Dn03mZyZU6p7wPekDJBmqQgVs5NdW2oBf6mX5Wf5RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633731; c=relaxed/simple;
	bh=H2Xnb+bY3hHvKLw4J2faSe3e83Yd7w4LwHHqdfzF6kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BlHLPa9WdUTeH7ZuYlU4Kxr9mbfxjxcLVVmZ6YWfCiQXgNPcYClwFVw9q2NB3QOR6VIlIyjc+jHwRGIh/r8RQ2ybR+ucw3Rz7nzQ3DL+hbbXDZ5NwValzmi6Hvu59pZeUw6ijtxr1l+8RCS9xyJ4JA0S6VhYK1X8BJUyXcbn8ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jRKB8rYN; arc=none smtp.client-ip=91.218.175.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jRKB8rYN"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H2Xnb+bY3hHvKLw4J2faSe3e83Yd7w4LwHHqdfzF6kg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789633710; v=1; x=1790238510;
 b=jRKB8rYN9nMI8CePG7pBCUz8vcGY9zG7Zia6wllVAX2q34Ehf7HlhHXO4ND6vScqXsOKkurm
 LStg7ZjulzRreMfko2zgLQ5dcEIczxhwVi/tNJ45TNM+UQNQMv6g+KtDeiufNv6ibBnEiyL56mA
 g472BcwJS91yBwh5fLoFtd/Y=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 188445fb7ea80638;
	Thu, 17 Sep 2026 08:28:19 +0000
X-Mizu-Trace-ID: 188445fb7ea80638
X-Migadu-Flow: FLOW_OUT
Message-ID: <e651832b-75bc-4520-a45e-b79cd986d175@linux.dev>
Date: Thu, 17 Sep 2026 09:28:15 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang again
To: Dave Chinner <dgc@kernel.org>, John Garry <john.g.garry@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev> <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
 <20260915145046.GC2705364@frogsfrogsfrogs>
 <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
 <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com> <aqsW_iNwYAjYldVf@dread>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <aqsW_iNwYAjYldVf@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/16/26 23:23, Dave Chinner wrote:
> On Wed, Sep 16, 2026 at 11:23:16AM +0100, John Garry wrote:
>> On 15/09/2026 16:41, John Garry wrote:
>>> On 9/15/26 15:50, Darrick J. Wong wrote:
>>>>> thanks
>>>>>
>>>>> About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for
>>>>> CoW-based atomics could help avoid this issue as we seem to be
>>>>> bogged down
>>>>> in lock contention.
>>>> Which lock is being contended, anyway?  It looks like the ILOCK?
>>>
>>> Yeah, I think so Re. ilock. I had some perf data illustrating this from
>>> last year, which I can't seem to find, so I will re-generate it.
>>
>> Here is perf call graph snippet when running fio with 72x threads issuing
>> 4KB atomic writes on 1MB file:
>>
>> --50.46%--xfs_file_dio_write_atomic
>> |
>> |--37.19%--iomap_dio_rw
>> |          |
>> |      --37.14%--__iomap_dio_rw
>> |           |
>> |       --36.50%--iomap_iter
>> |            |
>> |             --36.49%--xfs_atomic_write_cow_iomap_next
>> |                  |
>> |                  |--27.34%--xfs_ilock
>> |                  |          |
>> |                  |      --27.34%--down_write
>> |                  |           |
>> |                  |       --27.28%--rwsem_down_write_slowpath
>> |                  |            |
>> |                  |            |--24.65%--osq_lock
>> |                  |            |
>> |                  |             --2.35%--rwsem_spin_on_owner
>> |                  |
>> |                  |--7.62%--xfs_trans_alloc_inode
>> |                  |          |
>> |                  |      --7.59%--xfs_ilock
> 
> Where's the other half of the lock contention?

I was expecting xfs_reflink_end_atomic_cow() -> xfs_ilock() to be a 
point of contention as well, but it does not show up. I suppose that it 
because all those threads at completion stage are sleeping.

However, there is this which I omitted:

--13.21%--xfs_file_write_checks
    |
       --13.18%--kiocb_modified
          |
             --13.17%--file_update_time_flags
                |
                   --13.16%--xfs_vn_update_time
                      |
                         --12.99%--xfs_ilock
                            |
                               --12.98%--down_write

> 
> If this is all there is, it's because of concurrent submission of
> serialising IO, and xfs_atomic_write_cow_iomap_begin() is the first
> place in the IO submission path that we hit a serialising lock. That
> indicates a problem with high level IO serialisation, not a problem
> with the ILOCK.
> 
>> Notice how much time we spend getting that ilock.
>>
>> We could try something like this:
>>
>> ----8<------
>>
>> [PATCH] xfs: serialize CoW-based atomic writes
>>
>> We have had reports of system hangs when testing Cow-based atomic writes
>> for large block sizes.
>>
>> Analysis has shown large contention on the the per-inode ilock,
>> superficially in creating the mapping in
>> xfs_atomic_write_cow_iomap_begin().
>>
>> Serialize atomic writes to reduce this contention. In some cases this may
>> reduce performance, but high performance has not been a requirement so far
>> for CoW-based atomic writes.
>>
>> Signed-off-by: John Garry <john.garry@linux.dev>
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index d8202da15aca..ff48757cf0f0 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -819,10 +819,12 @@ xfs_file_dio_write_atomic(
>>   	 * HW offload should be faster, so try that first if it is already
>>   	 * known that the write length is not too large.
>>   	 */
>> -	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
>> +	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max) {
>>   		dops = &xfs_atomic_write_cow_iomap_ops;
>> -	else
>> +		dio_flags |= IOMAP_DIO_FORCE_WAIT;
>> +	} else {
>>   		dops = &xfs_direct_write_iomap_ops;
>> +	}
>>
>>   retry:
>>   	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>> @@ -840,6 +842,8 @@ xfs_file_dio_write_atomic(
>>   	}
>>
>>   	trace_xfs_file_direct_write(iocb, from);
>> +	if (dio_flags & IOMAP_DIO_FORCE_WAIT)
>> +		inode_dio_wait(VFS_I(ip));
> 
> Based on my comment above, this seems like the wrong approach to me.
> 
> We serialise concurrent DIO write submission when necessary by
> taking the IOLOCK_EXCL instead of IOLOCK_SHARED (e.g. EOF
> extension). inode_dio_wait() waits for completion of all DIO (read
> and write), but we don't need to wait for completions if all we need
> to do is serialise IO submission.
> 
> Hence if we know we are going to do a software COW for the write, we
> should take IOLOCK_EXCL to serialise submission up high. Waiting
> until we are deep into the IO path and serialising on the
> internal metadata ILOCK is much, much harder to do efficiently and
> correctly.
> 
> i.e. we need to take the ILOCK vs transaction reservation vs unbound
> user-controlled concurrency deadlock problem out of
> the equation. Using the IOLOCK achieves this because IO submission
> blocks on the IOLOCK rather than on the ILOCK whilst holding a
> transaction reservation.
> 
>> I also notice that in xfs_atomic_write_cow_iomap_next() we drop the ilock
>> for calling xfs_trans_alloc_inode() (which immediately grabs the same lock).
>> It would seem that could be improved.
> 
> Doubt it - holding the ILOCK across transaction reservation
> guarantees journal space deadlocks will occur.  That's why the
> suboptimal pattern of 'lock - check - unlock - trans_alloc - lock -
> check' exists throughout XFS inode modification paths.
> 
> FWIW, that's one of the anit-patterns that the patchset I posted
> recently begins to address:
> 
> https://lore.kernel.org/linux-xfs/20260819001442.1451892-1-dgc@kernel.org/
> 
> It creates consistently correct patterns in the IO path by changes all the
> individual alloc-lock-check-mod-commit-unlock loops to an "atomic"
> alloc-lock, check-mod-roll loop, commit-unlock pattern.
> 
> IOWs, multi-part extent modifications are all done under a single
> lock/unlock pair, and so appear atomic to all other extent map and
> modification operations. This makes many of the nasty IO corner
> cases that lead to sub-optimal behaviour (like data corruption or
> lock contention in COW workloads due to continual bouncing of the
> ILOCK between submission and completion contexts) largely go away...
> 

Ack, and unfortunately that series did not get much expert review.

JFYI, I have another log for a similar hang which we see one thread 
deadlock for log space, below.

fio-3.38
Starting 14 processes
[  247.169311] INFO: task kworker/34:1:568 blocked for more than 122 
seconds.
[  247.169355]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.169370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.169372] task:kworker/34:1    state:D stack:23048 pid:568 
tgid:568   ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.169388] Workqueue: dio/sda iomap_dio_complete_work
[  247.169424] Call Trace:
[  247.169427]  <TASK>
[  247.169431]  __schedule+0x1179/0x44c0
[  247.169446]  ? kick_pool_pick+0x24c/0x640
[  247.169458]  ? __pfx___schedule+0x10/0x10
[  247.169464]  ? lock_release+0xc9/0x290
[  247.169471]  schedule+0xd2/0x260
[  247.169476]  schedule_preempt_disabled+0x11/0x20
[  247.169479]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.169486]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.169494]  ? xfs_dec_freecounter+0xec/0x580
[  247.169501]  down_write_nested+0x1b5/0x1e0
[  247.169508]  ? __pfx_down_write_nested+0x10/0x10
[  247.169512]  ? xfs_ilock+0x2a0/0x3d0
[  247.169518]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.169523]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.169527]  ? __lock_acquire+0x607/0x1f70
[  247.169532]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.169539]  iomap_dio_complete+0x136/0xaa0
[  247.169543]  ? process_scheduled_works+0xaee/0x1b30
[  247.169546]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.169552]  iomap_dio_complete_work+0x51/0x80
[  247.169555]  process_scheduled_works+0xc08/0x1b30
[  247.169570]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.169573]  ? lock_acquire+0x185/0x2e0
[  247.169577]  ? lock_is_held_type+0x9e/0x120
[  247.169582]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.169586]  worker_thread+0x4ad/0xb40
[  247.169591]  ? __kthread_parkme+0x99/0x180
[  247.169596]  ? __pfx_worker_thread+0x10/0x10
[  247.169600]  kthread+0x351/0x450
[  247.169603]  ? __pfx_kthread+0x10/0x10
[  247.169606]  ret_from_fork+0x563/0x800
[  247.169618]  ? __pfx_ret_from_fork+0x10/0x10
[  247.169621]  ? __pfx_kthread+0x10/0x10
[  247.169624]  ? __switch_to+0x58e/0xea0
[  247.169630]  ? __pfx_kthread+0x10/0x10
[  247.169632]  ret_from_fork_asm+0x1a/0x30
[  247.169651]  </TASK>
[  247.170111] INFO: task kworker/34:1:568 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.170169] INFO: task kworker/48:12:800 blocked for more than 122 
seconds.
[  247.170172]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.170173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.170174] task:kworker/48:12   state:D stack:26088 pid:800 
tgid:800   ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.170188] Workqueue: dio/sda iomap_dio_complete_work
[  247.170196] Call Trace:
[  247.170198]  <TASK>
[  247.170200]  __schedule+0x1179/0x44c0
[  247.170208]  ? kick_pool_pick+0x24c/0x640
[  247.170216]  ? __pfx___schedule+0x10/0x10
[  247.170220]  ? lock_release+0xc9/0x290
[  247.170227]  schedule+0xd2/0x260
[  247.170231]  schedule_preempt_disabled+0x11/0x20
[  247.170234]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.170240]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.170249]  ? xfs_dec_freecounter+0xec/0x580
[  247.170254]  down_write_nested+0x1b5/0x1e0
[  247.170260]  ? __pfx_down_write_nested+0x10/0x10
[  247.170264]  ? xfs_ilock+0x2a0/0x3d0
[  247.170269]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.170274]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.170278]  ? __lock_acquire+0x607/0x1f70
[  247.170283]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.170289]  iomap_dio_complete+0x136/0xaa0
[  247.170293]  ? process_scheduled_works+0xaee/0x1b30
[  247.170296]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.170302]  iomap_dio_complete_work+0x51/0x80
[  247.170305]  process_scheduled_works+0xc08/0x1b30
[  247.170319]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.170323]  ? lock_acquire+0x185/0x2e0
[  247.170327]  ? lock_is_held_type+0x9e/0x120
[  247.170331]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.170335]  worker_thread+0x4ad/0xb40
[  247.170342]  ? __pfx_worker_thread+0x10/0x10
[  247.170345]  kthread+0x351/0x450
[  247.170348]  ? __pfx_kthread+0x10/0x10
[  247.170351]  ret_from_fork+0x563/0x800
[  247.170358]  ? __pfx_ret_from_fork+0x10/0x10
[  247.170371]  ? __pfx_kthread+0x10/0x10
[  247.170374]  ? __switch_to+0x58e/0xea0
[  247.170378]  ? __pfx_kthread+0x10/0x10
[  247.170381]  ret_from_fork_asm+0x1a/0x30
[  247.170391]  </TASK>
[  247.170688] INFO: task kworker/48:12:800 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.170694] INFO: task kworker/48:13:807 blocked for more than 122 
seconds.
[  247.170696]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.170698] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.170699] task:kworker/48:13   state:D stack:26088 pid:807 
tgid:807   ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.170708] Workqueue: dio/sda iomap_dio_complete_work
[  247.170713] Call Trace:
[  247.170715]  <TASK>
[  247.170718]  __schedule+0x1179/0x44c0
[  247.170722]  ? kick_pool_pick+0x24c/0x640
[  247.170729]  ? __pfx___schedule+0x10/0x10
[  247.170733]  ? lock_release+0xc9/0x290
[  247.170739]  schedule+0xd2/0x260
[  247.170742]  schedule_preempt_disabled+0x11/0x20
[  247.170746]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.170752]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.170759]  ? xfs_dec_freecounter+0xec/0x580
[  247.170764]  down_write_nested+0x1b5/0x1e0
[  247.170769]  ? __pfx_down_write_nested+0x10/0x10
[  247.170774]  ? xfs_ilock+0x2a0/0x3d0
[  247.170778]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.170781]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.170786]  ? __lock_acquire+0x607/0x1f70
[  247.170791]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.170796]  iomap_dio_complete+0x136/0xaa0
[  247.170799]  ? process_scheduled_works+0xaee/0x1b30
[  247.170802]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.170807]  iomap_dio_complete_work+0x51/0x80
[  247.170810]  process_scheduled_works+0xc08/0x1b30
[  247.170824]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.170827]  ? lock_acquire+0x185/0x2e0
[  247.170831]  ? lock_is_held_type+0x9e/0x120
[  247.170835]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.170839]  worker_thread+0x4ad/0xb40
[  247.170845]  ? __pfx_worker_thread+0x10/0x10
[  247.170848]  kthread+0x351/0x450
[  247.170850]  ? __pfx_kthread+0x10/0x10
[  247.170853]  ret_from_fork+0x563/0x800
[  247.170858]  ? __pfx_ret_from_fork+0x10/0x10
[  247.170861]  ? __pfx_kthread+0x10/0x10
[  247.170863]  ? __switch_to+0x58e/0xea0
[  247.170867]  ? __pfx_kthread+0x10/0x10
[  247.170870]  ret_from_fork_asm+0x1a/0x30
[  247.170878]  </TASK>
[  247.171134] INFO: task kworker/48:13:807 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.171153] INFO: task kworker/52:22:893 blocked for more than 122 
seconds.
[  247.171155]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.171156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.171157] task:kworker/52:22   state:D stack:26280 pid:893 
tgid:893   ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.171166] Workqueue: dio/sda iomap_dio_complete_work
[  247.171171] Call Trace:
[  247.171172]  <TASK>
[  247.171174]  __schedule+0x1179/0x44c0
[  247.171179]  ? kick_pool_pick+0x24c/0x640
[  247.171186]  ? __pfx___schedule+0x10/0x10
[  247.171189]  ? lock_release+0xc9/0x290
[  247.171195]  schedule+0xd2/0x260
[  247.171198]  schedule_preempt_disabled+0x11/0x20
[  247.171202]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.171208]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.171216]  ? xfs_dec_freecounter+0xec/0x580
[  247.171221]  down_write_nested+0x1b5/0x1e0
[  247.171225]  ? __pfx_down_write_nested+0x10/0x10
[  247.171230]  ? xfs_ilock+0x2a0/0x3d0
[  247.171234]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.171238]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.171242]  ? __lock_acquire+0x607/0x1f70
[  247.171248]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.171253]  iomap_dio_complete+0x136/0xaa0
[  247.171256]  ? process_scheduled_works+0xaee/0x1b30
[  247.171259]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.171264]  iomap_dio_complete_work+0x51/0x80
[  247.171267]  process_scheduled_works+0xc08/0x1b30
[  247.171281]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.171285]  ? lock_acquire+0x185/0x2e0
[  247.171289]  ? lock_is_held_type+0x9e/0x120
[  247.171293]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.171297]  worker_thread+0x4ad/0xb40
[  247.171303]  ? __pfx_worker_thread+0x10/0x10
[  247.171306]  kthread+0x351/0x450
[  247.171308]  ? __pfx_kthread+0x10/0x10
[  247.171311]  ret_from_fork+0x563/0x800
[  247.171315]  ? __pfx_ret_from_fork+0x10/0x10
[  247.171318]  ? __pfx_kthread+0x10/0x10
[  247.171320]  ? __switch_to+0x58e/0xea0
[  247.171324]  ? __pfx_kthread+0x10/0x10
[  247.171327]  ret_from_fork_asm+0x1a/0x30
[  247.171335]  </TASK>
[  247.171539] INFO: task kworker/52:22:893 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.171555] INFO: task kworker/5:4:1006 blocked for more than 122 
seconds.
[  247.171557]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.171558] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.171559] task:kworker/5:4     state:D stack:26456 pid:1006 
tgid:1006  ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.171566] Workqueue: dio/sda iomap_dio_complete_work
[  247.171569] Call Trace:
[  247.171570]  <TASK>
[  247.171572]  __schedule+0x1179/0x44c0
[  247.171576]  ? kick_pool_pick+0x24c/0x640
[  247.171582]  ? __pfx___schedule+0x10/0x10
[  247.171586]  ? lock_release+0xc9/0x290
[  247.171591]  schedule+0xd2/0x260
[  247.171595]  schedule_preempt_disabled+0x11/0x20
[  247.171597]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.171603]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.171611]  ? xfs_dec_freecounter+0xec/0x580
[  247.171616]  down_write_nested+0x1b5/0x1e0
[  247.171619]  ? __pfx_down_write_nested+0x10/0x10
[  247.171623]  ? xfs_ilock+0x2a0/0x3d0
[  247.171627]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.171631]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.171635]  ? __lock_acquire+0x607/0x1f70
[  247.171640]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.171657]  iomap_dio_complete+0x136/0xaa0
[  247.171661]  ? process_scheduled_works+0xaee/0x1b30
[  247.171663]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.171667]  iomap_dio_complete_work+0x51/0x80
[  247.171670]  process_scheduled_works+0xc08/0x1b30
[  247.171684]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.171687]  ? lock_acquire+0x185/0x2e0
[  247.171691]  ? lock_is_held_type+0x9e/0x120
[  247.171695]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.171699]  worker_thread+0x4ad/0xb40
[  247.171705]  ? __pfx_worker_thread+0x10/0x10
[  247.171709]  kthread+0x351/0x450
[  247.171711]  ? __pfx_kthread+0x10/0x10
[  247.171714]  ret_from_fork+0x563/0x800
[  247.171718]  ? __pfx_ret_from_fork+0x10/0x10
[  247.171721]  ? __pfx_kthread+0x10/0x10
[  247.171723]  ? __switch_to+0x58e/0xea0
[  247.171726]  ? __pfx_kthread+0x10/0x10
[  247.171729]  ret_from_fork_asm+0x1a/0x30
[  247.171737]  </TASK>
[  247.171902] INFO: task kworker/5:4:1006 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.171905] INFO: task kworker/5:6:1009 blocked for more than 122 
seconds.
[  247.171906]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.171908] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.171908] task:kworker/5:6     state:D stack:25000 pid:1009 
tgid:1009  ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.171915] Workqueue: dio/sda iomap_dio_complete_work
[  247.171919] Call Trace:
[  247.171920]  <TASK>
[  247.171922]  __schedule+0x1179/0x44c0
[  247.171929]  ? __pfx___schedule+0x10/0x10
[  247.171933]  ? lock_release+0xc9/0x290
[  247.171935]  ? _raw_spin_unlock_irq+0x23/0x40
[  247.171940]  schedule+0xd2/0x260
[  247.171944]  schedule_preempt_disabled+0x11/0x20
[  247.171947]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.171952]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.171960]  ? xfs_dec_freecounter+0xec/0x580
[  247.171965]  down_write_nested+0x1b5/0x1e0
[  247.171968]  ? __pfx_down_write_nested+0x10/0x10
[  247.171973]  ? xfs_ilock+0x2a0/0x3d0
[  247.171976]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.171980]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.171984]  ? __lock_acquire+0x607/0x1f70
[  247.171989]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.171994]  iomap_dio_complete+0x136/0xaa0
[  247.171997]  ? process_scheduled_works+0xaee/0x1b30
[  247.172000]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.172004]  iomap_dio_complete_work+0x51/0x80
[  247.172007]  process_scheduled_works+0xc08/0x1b30
[  247.172021]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.172024]  ? lock_acquire+0x185/0x2e0
[  247.172028]  ? lock_is_held_type+0x9e/0x120
[  247.172032]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.172036]  worker_thread+0x4ad/0xb40
[  247.172041]  ? __kthread_parkme+0x99/0x180
[  247.172045]  ? __pfx_worker_thread+0x10/0x10
[  247.172062]  kthread+0x351/0x450
[  247.172065]  ? __pfx_kthread+0x10/0x10
[  247.172068]  ret_from_fork+0x563/0x800
[  247.172072]  ? __pfx_ret_from_fork+0x10/0x10
[  247.172075]  ? __pfx_kthread+0x10/0x10
[  247.172077]  ? __switch_to+0x58e/0xea0
[  247.172081]  ? __pfx_kthread+0x10/0x10
[  247.172084]  ret_from_fork_asm+0x1a/0x30
[  247.172092]  </TASK>
[  247.172277] INFO: task kworker/5:6:1009 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.172282] INFO: task kworker/7:3:1019 blocked for more than 122 
seconds.
[  247.172283]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.172285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.172286] task:kworker/7:3     state:D stack:25912 pid:1019 
tgid:1019  ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.172292] Workqueue: dio/sda iomap_dio_complete_work
[  247.172295] Call Trace:
[  247.172296]  <TASK>
[  247.172299]  __schedule+0x1179/0x44c0
[  247.172302]  ? kick_pool_pick+0x24c/0x640
[  247.172308]  ? __pfx___schedule+0x10/0x10
[  247.172312]  ? lock_release+0xc9/0x290
[  247.172317]  schedule+0xd2/0x260
[  247.172321]  xlog_grant_head_wait+0x112/0x9b0
[  247.172327]  xlog_grant_head_check+0x377/0x500
[  247.172331]  ? __pfx_xlog_grant_head_check+0x10/0x10
[  247.172337]  xfs_log_reserve+0x291/0x6f0
[  247.172343]  ? __pfx_xfs_log_reserve+0x10/0x10
[  247.172346]  ? __percpu_counter_compare+0xa8/0xf0
[  247.172352]  ? xfs_dec_freecounter+0xec/0x580
[  247.172357]  xfs_trans_alloc+0x205/0x900
[  247.172363]  xfs_reflink_end_atomic_cow+0x197/0x640
[  247.172367]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.172372]  ? __lock_acquire+0x607/0x1f70
[  247.172378]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.172383]  iomap_dio_complete+0x136/0xaa0
[  247.172386]  ? process_scheduled_works+0xaee/0x1b30
[  247.172388]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.172392]  iomap_dio_complete_work+0x51/0x80
[  247.172396]  process_scheduled_works+0xc08/0x1b30
[  247.172411]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.172415]  ? lock_acquire+0x185/0x2e0
[  247.172419]  ? lock_is_held_type+0x9e/0x120
[  247.172424]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.172428]  worker_thread+0x4ad/0xb40
[  247.172434]  ? __pfx_worker_thread+0x10/0x10
[  247.172437]  kthread+0x351/0x450
[  247.172439]  ? __pfx_kthread+0x10/0x10
[  247.172442]  ret_from_fork+0x563/0x800
[  247.172445]  ? __pfx_ret_from_fork+0x10/0x10
[  247.172448]  ? __pfx_kthread+0x10/0x10
[  247.172450]  ? __switch_to+0x58e/0xea0
[  247.172454]  ? __pfx_kthread+0x10/0x10
[  247.172457]  ret_from_fork_asm+0x1a/0x30
[  247.172465]  </TASK>
[  247.172471] INFO: task kworker/61:4:1051 blocked for more than 122 
seconds.
[  247.172472]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.172473] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.172474] task:kworker/61:4    state:D stack:26016 pid:1051 
tgid:1051  ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.172481] Workqueue: dio/sda iomap_dio_complete_work
[  247.172484] Call Trace:
[  247.172485]  <TASK>
[  247.172487]  __schedule+0x1179/0x44c0
[  247.172490]  ? kick_pool_pick+0x24c/0x640
[  247.172496]  ? __pfx___schedule+0x10/0x10
[  247.172500]  ? lock_release+0xc9/0x290
[  247.172504]  schedule+0xd2/0x260
[  247.172508]  schedule_preempt_disabled+0x11/0x20
[  247.172511]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.172517]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.172526]  ? xfs_dec_freecounter+0xec/0x580
[  247.172531]  down_write_nested+0x1b5/0x1e0
[  247.172534]  ? __pfx_down_write_nested+0x10/0x10
[  247.172539]  ? xfs_ilock+0x2a0/0x3d0
[  247.172543]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.172546]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.172550]  ? __lock_acquire+0x607/0x1f70
[  247.172555]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.172560]  iomap_dio_complete+0x136/0xaa0
[  247.172563]  ? process_scheduled_works+0xaee/0x1b30
[  247.172565]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.172569]  iomap_dio_complete_work+0x51/0x80
[  247.172572]  process_scheduled_works+0xc08/0x1b30
[  247.172586]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.172589]  ? lock_acquire+0x185/0x2e0
[  247.172594]  ? lock_is_held_type+0x9e/0x120
[  247.172597]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.172601]  worker_thread+0x4ad/0xb40
[  247.172607]  ? __pfx_worker_thread+0x10/0x10
[  247.172610]  kthread+0x351/0x450
[  247.172612]  ? __pfx_kthread+0x10/0x10
[  247.172615]  ret_from_fork+0x563/0x800
[  247.172618]  ? __pfx_ret_from_fork+0x10/0x10
[  247.172621]  ? __pfx_kthread+0x10/0x10
[  247.172623]  ? __switch_to+0x58e/0xea0
[  247.172626]  ? __pfx_kthread+0x10/0x10
[  247.172629]  ret_from_fork_asm+0x1a/0x30
[  247.172637]  </TASK>
[  247.172804] INFO: task kworker/61:4:1051 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.172810] INFO: task kworker/34:2:1071 blocked for more than 122 
seconds.
[  247.172812]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.172813] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.172814] task:kworker/34:2    state:D stack:26360 pid:1071 
tgid:1071  ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.172820] Workqueue: dio/sda iomap_dio_complete_work
[  247.172823] Call Trace:
[  247.172824]  <TASK>
[  247.172827]  __schedule+0x1179/0x44c0
[  247.172830]  ? kick_pool_pick+0x24c/0x640
[  247.172836]  ? __pfx___schedule+0x10/0x10
[  247.172840]  ? lock_release+0xc9/0x290
[  247.172844]  schedule+0xd2/0x260
[  247.172848]  schedule_preempt_disabled+0x11/0x20
[  247.172851]  rwsem_down_write_slowpath+0x3d6/0x1670
[  247.172857]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
[  247.172865]  ? xfs_dec_freecounter+0xec/0x580
[  247.172869]  down_write_nested+0x1b5/0x1e0
[  247.172872]  ? __pfx_down_write_nested+0x10/0x10
[  247.172876]  ? xfs_ilock+0x2a0/0x3d0
[  247.172880]  xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.172884]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.172888]  ? __lock_acquire+0x607/0x1f70
[  247.172893]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.172898]  iomap_dio_complete+0x136/0xaa0
[  247.172901]  ? process_scheduled_works+0xaee/0x1b30
[  247.172903]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.172907]  iomap_dio_complete_work+0x51/0x80
[  247.172910]  process_scheduled_works+0xc08/0x1b30
[  247.172924]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.172927]  ? lock_acquire+0x185/0x2e0
[  247.172931]  ? lock_is_held_type+0x9e/0x120
[  247.172935]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.172939]  worker_thread+0x4ad/0xb40
[  247.172944]  ? __pfx_worker_thread+0x10/0x10
[  247.172947]  kthread+0x351/0x450
[  247.172949]  ? __pfx_kthread+0x10/0x10
[  247.172952]  ret_from_fork+0x563/0x800
[  247.172956]  ? __pfx_ret_from_fork+0x10/0x10
[  247.172959]  ? __pfx_kthread+0x10/0x10
[  247.172961]  ? __switch_to+0x58e/0xea0
[  247.172964]  ? __pfx_kthread+0x10/0x10
[  247.172967]  ret_from_fork_asm+0x1a/0x30
[  247.172975]  </TASK>
[  247.173163] INFO: task kworker/34:2:1071 <writer> blocked on an 
rw-semaphore likely owned by task kworker/5:10:1933 <writer>
[  247.173167] INFO: task kworker/6:5:1080 blocked for more than 122 
seconds.
[  247.173169]       Not tainted 7.3.0-rc2-00095-g75fd6e0692c3-dirty #265
[  247.173170] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  247.173171] task:kworker/6:5     state:D stack:26424 pid:1080 
tgid:1080  ppid:2      task_flags:0x4248060 flags:0x00080000
[  247.173178] Workqueue: dio/sda iomap_dio_complete_work
[  247.173181] Call Trace:
[  247.173181]  <TASK>
[  247.173184]  __schedule+0x1179/0x44c0
[  247.173187]  ? kick_pool_pick+0x24c/0x640
[  247.173193]  ? __pfx___schedule+0x10/0x10
[  247.173197]  ? lock_release+0xc9/0x290
[  247.173201]  schedule+0xd2/0x260
[  247.173205]  xlog_grant_head_wait+0x112/0x9b0
[  247.173211]  xlog_grant_head_check+0x377/0x500
[  247.173214]  ? __pfx_xlog_grant_head_check+0x10/0x10
[  247.173221]  xfs_log_reserve+0x291/0x6f0
[  247.173225]  ? __pfx_xfs_log_reserve+0x10/0x10
[  247.173228]  ? __percpu_counter_compare+0xa8/0xf0
[  247.173233]  ? xfs_dec_freecounter+0xec/0x580
[  247.173237]  xfs_trans_alloc+0x205/0x900
[  247.173244]  xfs_reflink_end_atomic_cow+0x197/0x640
[  247.173248]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10
[  247.173252]  ? __lock_acquire+0x607/0x1f70
[  247.173257]  xfs_dio_write_end_io+0x58c/0x6e0
[  247.173262]  iomap_dio_complete+0x136/0xaa0
[  247.173265]  ? process_scheduled_works+0xaee/0x1b30
[  247.173268]  ? __pfx_aio_complete_rw+0x10/0x10
[  247.173272]  iomap_dio_complete_work+0x51/0x80
[  247.173275]  process_scheduled_works+0xc08/0x1b30
[  247.173288]  ? __pfx_process_scheduled_works+0x10/0x10
[  247.173291]  ? lock_acquire+0x185/0x2e0
[  247.173295]  ? lock_is_held_type+0x9e/0x120
[  247.173299]  ? __pfx_iomap_dio_complete_work+0x10/0x10
[  247.173303]  worker_thread+0x4ad/0xb40
[  247.173309]  ? __pfx_worker_thread+0x10/0x10
[  247.173312]  kthread+0x351/0x450
[  247.173314]  ? __pfx_kthread+0x10/0x10
[  247.173317]  ret_from_fork+0x563/0x800
[  247.173320]  ? __pfx_ret_from_fork+0x10/0x10
[  247.173323]  ? __pfx_kthread+0x10/0x10
[  247.173325]  ? __switch_to+0x58e/0xea0
[  247.173328]  ? __pfx_kthread+0x10/0x10
[  247.173331]  ret_from_fork_asm+0x1a/0x30
[  247.173339]  </TASK>
[  247.173340] Future hung task reports are suppressed, see sysctl 
kernel.hung_task_warnings
[  247.173778]
[  247.173778] Showing all locks held in the system:
[  247.173782] locks held by pr/ttyS0/15: 2, last CPU#41:
[  247.173784]  #0: ffffffff892141f8 (console_srcu){....}-{0:0}, at: 
console_srcu_read_lock+0x46/0x60
[  247.173792]  #1: ffffffff8c4893d8 (&port_lock_key){-...}-{3:3}, at: 
univ8250_console_device_lock+0x56/0xa0
[  247.173839] locks held by khungtaskd/356: 1, last CPU#40:
[  247.173841]  #0: ffffffff89221460 (rcu_read_lock){....}-{1:3}, at: 
debug_show_all_locks+0x36/0x1c0
[  247.173858] locks held by syslogd/464: 1, last CPU#59:
[  247.173860]  #0: ffff888105817cc8 (&u->iolock){+.+.}-{4:4}, at: 
__unix_dgram_recvmsg+0x1ad/0xc30
[  247.173872] locks held by kworker/34:1/568: 4, on CPU#34:
[  247.173874]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.173880]  #1: ffff88812a6a7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.173885]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.173891]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.173915] locks held by kworker/48:12/800: 4, on CPU#48:
[  247.173917]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.173922]  #1: ffff88814a0dfd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.173927]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.173932]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.173938] locks held by kworker/48:13/807: 4, on CPU#48:
[  247.173940]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.173945]  #1: ffff88814a12fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.173950]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.173955]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.173972] locks held by kworker/52:22/893: 4, on CPU#52:
[  247.173973]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.173979]  #1: ffff88814a4ffd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.173983]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.173988]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174009] locks held by kworker/5:4/1006: 4, on CPU#5:
[  247.174011]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174016]  #1: ffff88814b3efd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174021]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174026]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174032] locks held by kworker/5:6/1009: 4, on CPU#5:
[  247.174033]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174039]  #1: ffff88814b48fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174043]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174273]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174281] locks held by kworker/7:3/1019: 3, on CPU#7:
[  247.174282]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174288]  #1: ffff88814b687d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174293]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174302] locks held by kworker/61:4/1051: 4, on CPU#61:
[  247.174304]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174309]  #1: ffff88814bb0fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174314]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174319]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174327] locks held by kworker/34:2/1071: 4, on CPU#34:
[  247.174328]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174334]  #1: ffff88814bc57d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174338]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174343]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174349] locks held by kworker/6:5/1080: 3, on CPU#6:
[  247.174351]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174356]  #1: ffff88814bda7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174361]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174371] locks held by kworker/34:19/1123: 4, on CPU#34:
[  247.174373]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174378]  #1: ffff88814c187d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174383]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174387]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174395] locks held by kworker/7:10/1144: 3, on CPU#7:
[  247.174397]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174402]  #1: ffff88814c497d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174407]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174428] locks held by kworker/59:3/1308: 3, on CPU#59:
[  247.174430]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174435]  #1: ffff88813524fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174440]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174445] locks held by kworker/59:4/1309: 3, on CPU#59:
[  247.174446]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
Jobs: 14 (f=14):[  247.174452]  #1: ffff8881036b7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
  [W(14)][10.5%][[  247.174457]  #2: ffff88813af38628 
(sb_internal){.+.+}-{0:0}, at: xfs_trans_alloc+0xa7/0x900
[  247.174462] locks held by kworker/59:5/1310: 4, on CPU#59:
[  247.174463]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174469]  #1: ffff888135e6fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174473]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174478]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174498] locks held by kworker/28:2/1449: 4, on CPU#28:
[  247.174499]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174505]  #1: ffff888148d87d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174510]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174515]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174521] locks held by kworker/28:4/1454: 4, on CPU#28:
[  247.174522]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174527]  #1: ffff888148c7fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174532]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174537]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174542] locks held by kworker/28:6/1457: 3, on CPU#28:
[  247.174544]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174549]  #1: ffff888148b5fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174554]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174559] locks held by kworker/28:8/1461: 4, on CPU#28:
[  247.174561]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174566]  #1: ffff888148c5fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174571]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174576]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174588] locks held by kworker/28:9/1537: 4, on CPU#28:
[  247.174590]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174595]  #1: ffff888147537d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174600]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174605]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174612] locks held by kworker/28:13/1549: 4, on CPU#28:
[  247.174613]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174618]  #1: ffff88814770fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174623]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174628]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174635] locks held by kworker/60:10/1577: 4, on CPU#60:
[  247.174636]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174642]  #1: ffff8881446ffd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174656]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174661]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174666] locks held by kworker/60:11/1578: 4, on CPU#60:
[  247.174667]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174673]  #1: ffff888144707d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174677]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174682]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174699] locks held by kworker/59:10/1722: 3, on CPU#59:
[  247.174701]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174706]  #1: ffff888143dffd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174711]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174717] locks held by kworker/59:11/1726: 4, on CPU#59:
[  247.174719]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174724]  #1: ffff888143e2fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174729]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174733]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174739] locks held by kworker/59:12/1727: 4, on CPU#59:
[  247.174740]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174746]  #1: ffff888143e37d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174751]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174755]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174761] locks held by kworker/59:14/1729: 3, on CPU#59:
[  247.174762]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174767]  #1: ffff888143e4fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174772]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174780] locks held by kworker/59:18/1772: 4, on CPU#59:
[  247.174782]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174787]  #1: ffff888147097d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174792]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174797]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174804] locks held by kworker/59:20/1800: 4, on CPU#59:
[  247.174805]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174810]  #1: ffff8881471cfd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174815]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174820]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174828] locks held by kworker/25:7/1821: 4, on CPU#25:
[  247.174829]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174835]  #1: ffff888146b9fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174840]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174845]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174850] locks held by kworker/25:13/1834: 2, last CPU#25:
[  247.174852]  #0: ffff88810028cd40 
((wq_completion)events_power_efficient){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174857]  #1: ffff88814642fd30 
((work_completion)(&(&gc_work->dwork)->work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174863] locks held by kworker/48:36/1852: 3, on CPU#48:
[  247.174865]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174870]  #1: ffff88813f75fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174875]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174880] locks held by kworker/48:38/1854: 3, on CPU#48:
[  247.174881]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174887]  #1: ffff88812bfffd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174892]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174897] locks held by kworker/48:41/1859: 4, on CPU#48:
[  247.174899]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174904]  #1: ffff88814654fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174909]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174914]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174919] locks held by kworker/60:26/1863: 4, on CPU#60:
[  247.174920]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174926]  #1: ffff888146577d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174930]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174935]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174945] locks held by kworker/5:10/1933: 4, on CPU#5:
[  247.174947]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174952]  #1: ffff888146367d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174957]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174962]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.174967] locks held by kworker/5:13/1936: 3, on CPU#5:
[  247.174968]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174974]  #1: ffff88814637fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174979]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.174984] locks held by kworker/5:14/1937: 3, on CPU#5:
[  247.174985]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.174990]  #1: ffff88814638fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.174995]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175000] locks held by kworker/5:15/1938: 3, on CPU#5:
[  247.175002]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175007]  #1: ffff888146397d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175012]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175020] locks held by kworker/14:20/1967: 4, on CPU#14:
[  247.175022]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175027]  #1: ffff888142a0fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175032]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175037]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175071] locks held by kworker/62:21/2093: 4, on CPU#62:
[  247.175073]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175079]  #1: ffff8881454b7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175084]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175089]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175108] locks held by kworker/61:26/2190: 4, on CPU#61:
[  247.175110]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175115]  #1: ffff888145307d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175120]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175125]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175131] locks held by kworker/61:32/2196: 4, on CPU#61:
[  247.175133]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175138]  #1: ffff888145347d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175143]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175148]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175158] locks held by kworker/61:65/2234: 4, on CPU#61:
[  247.175160]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175165]  #1: ffff888144c87d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175170]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175175]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175181] locks held by kworker/61:71/2241: 4, on CPU#61:
[  247.175182]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175188]  #1: ffff888144ccfd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175193]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175198]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175204] locks held by kworker/61:73/2244: 4, on CPU#61:
[  247.175205]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175211]  #1: ffff888144cefd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175216]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175221]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175227] locks held by kworker/61:75/2246: 3, on CPU#61:
[  247.175228]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175234]  #1: ffff888144d07d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175239]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175244] locks held by kworker/61:77/2248: 3, on CPU#61:
[  247.175246]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175251]  #1: ffff888144d17d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175257]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175262] locks held by kworker/61:78/2249: 4, on CPU#61:
[  247.175264]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175270]  #1: ffff888144d27d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175275]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175280]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175286] locks held by kworker/61:80/2251: 3, on CPU#61:
[  247.175288]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175294]  #1: ffff888144d37d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175299]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175304] locks held by kworker/61:81/2252: 3, on CPU#61:
[  247.175306]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175311]  #1: ffff888144d3fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175317]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175329] locks held by kworker/35:38/2302: 4, on CPU#35:
[  247.175331]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175336]  #1: ffff8881448c7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175341]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175346]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175362] locks held by kworker/34:36/2368: 4, on CPU#34:
[  247.175364]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175370]  #1: ffff888145967d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175374]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175379]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175385] locks held by kworker/34:37/2369: 4, on CPU#34:
[  247.175386]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175392]  #1: ffff888145977d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175397]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175402]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175408] locks held by kworker/34:44/2376: 4, on CPU#34:
[  247.175410]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175415]  #1: ffff8881459c7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175420]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175425]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175448] locks held by kworker/7:27/2494: 3, on CPU#7:
[  247.175450]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175455]  #1: ffff8881432ffd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175461]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175466] locks held by kworker/6:28/2495: 4, on CPU#6:
[  247.175468]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175473]  #1: ffff888143307d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175479]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175484]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175490] locks held by kworker/7:31/2502: 3, on CPU#7:
[  247.175491]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175497]  #1: ffff88814335fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175502]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175507] locks held by kworker/6:37/2509: 3, on CPU#6:
[  247.175509]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175515]  #1: ffff8881433afd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175519]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175525] locks held by kworker/7:34/2513: 4, on CPU#7:
[  247.175526]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175532]  #1: ffff8881433d7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175537]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175542]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175547] locks held by kworker/6:44/2519: 3, on CPU#6:
[  247.175549]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175554]  #1: ffff888142c0fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175559]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175566] locks held by kworker/59:21/2537: 4, on CPU#59:
[  247.175568]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175574]  #1: ffff888142ce7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175579]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175584]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175590] locks held by kworker/59:22/2538: 3, on CPU#59:
[  247.175591]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175597]  #1: ffff888142cefd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175601]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175607] locks held by kworker/59:26/2542: 4, on CPU#59:
[  247.175608]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175614]  #1: ffff88813fe87d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175619]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175624]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175629] locks held by kworker/59:27/2543: 3, on CPU#59:
[  247.175631]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175636]  #1: ffff88813fe77d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175641]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175657] locks held by kworker/59:28/2544: 3, on CPU#59:
[  247.175659]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175664]  #1: ffff88813fcd7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175669]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175680] locks held by kworker/60:35/2583: 3, on CPU#60:
[  247.175682]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175687]  #1: ffff888142f8fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175692]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175700] locks held by kworker/26:7/2606: 4, on CPU#26:
[  247.175701]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175707]  #1: ffff888142477d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175711]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175716]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175727] locks held by kworker/14:27/2649: 3, on CPU#14:
[  247.175729]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175734]  #1: ffff888142617d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175739]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175747] locks held by kworker/14:39/2673: 4, on CPU#14:
[  247.175749]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175754]  #1: ffff888142727d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175759]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175764]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175770] locks held by kworker/14:49/2687: 4, on CPU#14:
[  247.175772]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175777]  #1: ffff8881427bfd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175782]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175787]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175792] locks held by kworker/14:50/2688: 4, on CPU#14:
[  247.175794]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175799]  #1: ffff8881427c7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175804]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175808]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175814] locks held by kworker/5:20/2691: 4, on CPU#5:
[  247.175815]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175820]  #1: ffff8881427e7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175825]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175830]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175836] locks held by kworker/5:22/2695: 4, on CPU#5:
[  247.175837]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175842]  #1: ffff888146ea7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175847]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175852]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175872] locks held by kworker/60:46/2815: 4, on CPU#60:
[  247.175874]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175879]  #1: ffff88813995fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175884]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175889]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175896] locks held by kworker/59:30/2827: 4, on CPU#59:
[  247.175898]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175903]  #1: ffff888138a77d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175908]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175913]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175918] locks held by kworker/59:31/2829: 3, on CPU#59:
[  247.175920]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175925]  #1: ffff888145a7fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175930]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175935] locks held by kworker/59:33/2831: 4, on CPU#59:
[  247.175936]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175942]  #1: ffff88813ceffd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175946]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175951]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.175957] locks held by kworker/59:35/2833: 3, on CPU#59:
[  247.175958]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175963]  #1: ffff88812c9afd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175968]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.175980] locks held by kworker/28:16/2887: 3, on CPU#28:
[  247.175981]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.175987]  #1: ffff88814d967d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.175992]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176000] locks held by kworker/48:50/2910: 4, on CPU#48:
[  247.176002]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176007]  #1: ffff88814db57d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176012]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176017]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176035] locks held by kworker/26:38/3006: 4, on CPU#26:
[  247.176036]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176042]  #1: ffff888148f3fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176058]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176065]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176081] locks held by kworker/59:43/3082: 4, on CPU#59:
[  247.176082]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176088]  #1: ffff8881350b7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176093]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176098]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176103] locks held by kworker/59:44/3084: 3, on CPU#59:
[  247.176105]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176110]  #1: ffff888145d17d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176115]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176120] locks held by kworker/59:45/3085: 3, on CPU#59:
[  247.176122]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176127]  #1: ffff88814d76fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176132]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176137] locks held by kworker/59:47/3087: 4, on CPU#59:
[  247.176139]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176144]  #1: ffff88814d49fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176149]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176154]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176165] locks held by kworker/28:19/3123: 3, on CPU#28:
[  247.176166]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176171]  #1: ffff888146a97d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176176]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176191] locks held by kworker/34:49/3179: 4, on CPU#34:
[  247.176192]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176198]  #1: ffff88814e587d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176203]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176208]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176214] locks held by kworker/34:50/3180: 4, on CPU#34:
[  247.176215]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176221]  #1: ffff88814e58fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176225]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176230]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176237] locks held by kworker/34:54/3184: 4, on CPU#34:
[  247.176238]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176244]  #1: ffff888142dc7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176249]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176254]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176259] locks held by kworker/34:55/3185: 4, on CPU#34:
[  247.176260]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176266]  #1: ffff888142dcfd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176271]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176276]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176300] locks held by fio/3278: 2, on CPU#6:
[  247.176302]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176309]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176315] locks held by fio/3279: 2, on CPU#62:
[  247.176317]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176322]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176327] locks held by fio/3280: 2, on CPU#7:
[  247.176329]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176334]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176340] locks held by fio/3281: 2, on CPU#28:
[  247.176341]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176346]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176351] locks held by fio/3282: 2, on CPU#60:
[  247.176353]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176358]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176363] locks held by fio/3283: 2, on CPU#34:
[  247.176364]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176369]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176375] locks held by fio/3284: 3, on CPU#26:
[  247.176376]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176381]  #1: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176386]  #2: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x28c/0x4d0
[  247.176391] locks held by fio/3285: 2, on CPU#14:
[  247.176393]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176398]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176403] locks held by fio/3286: 3, on CPU#26:
[  247.176405]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176410]  #1: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176415]  #2: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x28c/0x4d0
[  247.176421] locks held by fio/3287: 2, on CPU#48:
[  247.176422]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176428]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176433] locks held by fio/3288: 2, on CPU#5:
[  247.176434]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176440]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176445] locks held by fio/3289: 3, on CPU#26:
[  247.176446]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176452]  #1: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176457]  #2: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x28c/0x4d0
[  247.176462] locks held by fio/3290: 2, on CPU#61:
[  247.176463]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176469]  #1: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_atomic_write_cow_iomap_next+0x3ea/0xc60
[  247.176474] locks held by fio/3291: 3, on CPU#26:
[  247.176476]  #0: ffff8881247bae90 
(&sb->s_type->i_mutex_key#14){++++}-{4:4}, at: xfs_ilock+0x253/0x3d0
[  247.176481]  #1: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176486]  #2: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x28c/0x4d0
[  247.176505] locks held by kworker/62:53/3393: 3, on CPU#62:
[  247.176506]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176512]  #1: ffff88814759fd30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176517]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176523] locks held by kworker/62:54/3394: 4, on CPU#62:
[  247.176524]  #0: ffff888135aeb140 
((wq_completion)dio/sda#9){+.+.}-{0:0}, at: 
process_scheduled_works+0xff2/0x1b30
[  247.176530]  #1: ffff88814f5d7d30 
((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: 
process_scheduled_works+0xb9f/0x1b30
[  247.176535]  #2: ffff88813af38628 (sb_internal){.+.+}-{0:0}, at: 
xfs_trans_alloc+0xa7/0x900
[  247.176540]  #3: ffff8881247bac80 
(&xfs_nondir_ilock_class){++++}-{4:4}, at: 
xfs_reflink_end_atomic_cow+0x2ea/0x640
[  247.176546]
[  247.176547] =============================================
[  247.176547]



