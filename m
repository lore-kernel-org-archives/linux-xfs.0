Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:53652 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeBHIYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 03:24:15 -0500
Received: by mail-wm0-f46.google.com with SMTP id t74so7847534wme.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Feb 2018 00:24:14 -0800 (PST)
Subject: Re: xfs_buf_lock vs aio
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
Date: Thu, 8 Feb 2018 10:24:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180207233320.GB20367@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 02/08/2018 01:33 AM, Dave Chinner wrote:
> On Wed, Feb 07, 2018 at 07:20:17PM +0200, Avi Kivity wrote:
>> As usual, I'm having my lovely io_submit()s sleeping. This time some
>> detailed traces. 4.14.15.
>>
>> kthreadd  8146 [013]  3580.418103:           sched:sched_switch:
>> kworker/13:3:8146 [120] D ==> kworker/13:0:8144 [120]
>>              7fff817dd0a5 __schedule ([kernel.kallsyms])
>>              7fff817dd5c6 schedule ([kernel.kallsyms])
>>              7fff817e1656 schedule_timeout ([kernel.kallsyms])
>>              7fff817de181 wait_for_completion ([kernel.kallsyms])
>>              7fff8109d51d flush_work ([kernel.kallsyms])
>>              7fffa086e29d xlog_cil_force_lsn ([kernel.kallsyms])
>>              7fffa086bfd6 _xfs_log_force ([kernel.kallsyms])
>>              7fffa086c1fc xfs_log_force ([kernel.kallsyms])
>>              7fffa08444d6 xfs_buf_lock ([kernel.kallsyms])
>>              7fffa084479b _xfs_buf_find ([kernel.kallsyms])
>>              7fffa0844a1a xfs_buf_get_map ([kernel.kallsyms])
>>              7fffa087b766 xfs_trans_get_buf_map ([kernel.kallsyms])
>>              7fffa0811c14 xfs_btree_get_bufl ([kernel.kallsyms])
>>              7fffa08024d2 xfs_bmap_extents_to_btree ([kernel.kallsyms])
>>              7fffa0805d68 xfs_bmap_add_extent_unwritten_real
>> ([kernel.kallsyms])
>>              7fffa0806a88 xfs_bmapi_convert_unwritten ([kernel.kallsyms])
>>              7fffa080c3e0 xfs_bmapi_write ([kernel.kallsyms])
>>              7fffa08553c9 xfs_iomap_write_unwritten ([kernel.kallsyms])
>>              7fffa0849416 xfs_dio_write_end_io ([kernel.kallsyms])
>>              7fff812bc935 iomap_dio_complete ([kernel.kallsyms])
>>              7fff812bca17 iomap_dio_complete_work ([kernel.kallsyms])
>>              7fff8109dd19 process_one_work ([kernel.kallsyms])
>>              7fff8109e79d worker_thread ([kernel.kallsyms])
>>              7fff810a43b9 kthread ([kernel.kallsyms])
>>              7fff81802335 ret_from_fork ([kernel.kallsyms])
>>
>>
>>
>> Forcing the log, so sleeping with ILOCK taken.
> Because it's trying to reallocate an extent that is pinned in the
> log and is marked stale. i.e. we are reallocating a recently freed
> metadata extent that hasn't been committed to disk yet. IOWs, it's
> the metadata form of the "log force to clear a busy extent so we can
> re-use it" condition....
>
> There's nothing you can do to reliably avoid this - it's a sign that
> you're running low on free space in an AG because it's recycling
> recently freed space faster than the CIL is being committed to disk.
>
> You could speed up background journal syncs to try to reduce the
> async checkpoint latency that allows busy extents to build up
> (/proc/sys/fs/xfs/xfssyncd_centisecs) but that also impacts on
> journal overhead and IO latency, etc.

Perhaps xfs should auto-tune this variable. If it detects that it is 
forcing the log synchronously, it can increase the background flush 
frequency significantly (like by a factor of 2), and if some time passes 
without contention, it can reduce the frequency a little. Over time it 
will find a flush frequency that matches what the workload is doing.

(Our database does this to a great extent - a log structured merge tree 
generates huge amounts of background work, not just for metadata, and we 
make sure that background work is clearing backlog at the same rate it 
is generated to avoid spiky service).

>
>> reactor-29  3336 [029]  3580.420137: xfs:xfs_ilock: dev 9:0 ino
>> 0x50000a9f flags ILOCK_EXCL caller kretprobe_trampoline
>>              7fffa0858572 xfs_ilock ([kernel.kallsyms])
>>              7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
>>              7fff8127314c file_update_time ([kernel.kallsyms])
>>              7fffa0849ab9 xfs_file_aio_write_checks ([kernel.kallsyms])
>>              7fffa0849bce xfs_file_dio_aio_write ([kernel.kallsyms])
>>              7fffa084a13f xfs_file_write_iter ([kernel.kallsyms])
>>              7fff812ab24f aio_write ([kernel.kallsyms])
>>              7fff812ab90e do_io_submit ([kernel.kallsyms])
>>              7fff812ac4c0 sys_io_submit ([kernel.kallsyms])
>>              7fff81005917 do_syscall_64 ([kernel.kallsyms])
>>              7fff81802115 return_from_SYSCALL_64 ([kernel.kallsyms])
>> io_submit() stalls. Later, task 8146 relinquishes the lock, which
>> (after passing through another worker thread), is finally acquired
>> by io_submit() which the continues.
> Yup, so it's the timestamp updates at IO submission that are
> blocking waiting for the *ILOCK* lock.
>
> [.....]
>
>> The other is to check that ILOCK can be taken exclusively in
>> xfs_file_dio_aio_write, if IOCB_NOWAIT. If this is the way to go, I
>> might venture a patch.
> You're getting your locks mixed up - xfs_file_dio_aio_write()
> doesn't ever take the ILOCK directly.  It takes the _IOLOCK_
> directly, and that's what IOCB_NOWAIT acts on.

It also takes ILOCK by calling file_update_time(), as seen in the trace 
above. I've seen that it does a _nowait acquisition of the IOLOCK, but 
that's not enough.

If we could pass the iocb to file_update_time() then xfs_vn_update_time, 
then it could perform a _nowait acquisition of ILOCK. Otherwise, we can 
just check if ILOCK is acquirable in xfs_file_aio_write_checks(). That's 
racy, but better than nothing.

>
> These operations are serialising on metadata updates which require
> the _ILOCK_ to be taken exclusively, and there's no way of knowing
> if that is going to be needed at the level of
> xfs_file_dio_aio_write().
>
> There are hooks in xfs_file_aio_write_checks() to avoid timestamp
> updates on write (FMODE_NOCMTIME) but there is no way to set
> this from userspace. It's used exclusively by the XFS open-by-handle
> code so that utilities like online defrag can write data into files
> without changing their user-visible timestamps.
>

xfs_file_aio_write_checks() knows its going to call file_update_time(), 
and it can guess that file_update_time() will call xfs_vn_update_time(). 
So just before that call, check that ILOCK is free and EAGAIN if not. 
Maybe that patch won't win any beauty contests but it will reduce some 
of my pain.

> Cheers,
>
> Dave.

