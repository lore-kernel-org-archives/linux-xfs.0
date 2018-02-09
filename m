Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35287 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbeBIMMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Feb 2018 07:12:02 -0500
Received: by mail-wm0-f45.google.com with SMTP id r78so15909844wme.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Feb 2018 04:12:01 -0800 (PST)
Subject: Re: xfs_buf_lock vs aio
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
Date: Fri, 9 Feb 2018 14:11:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180208221153.GF20266@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 02/09/2018 12:11 AM, Dave Chinner wrote:
> On Thu, Feb 08, 2018 at 10:24:11AM +0200, Avi Kivity wrote:
>> On 02/08/2018 01:33 AM, Dave Chinner wrote:
>>> On Wed, Feb 07, 2018 at 07:20:17PM +0200, Avi Kivity wrote:
>>>> As usual, I'm having my lovely io_submit()s sleeping. This time some
>>>> detailed traces. 4.14.15.
> [....]
>
>>>> Forcing the log, so sleeping with ILOCK taken.
>>> Because it's trying to reallocate an extent that is pinned in the
>>> log and is marked stale. i.e. we are reallocating a recently freed
>>> metadata extent that hasn't been committed to disk yet. IOWs, it's
>>> the metadata form of the "log force to clear a busy extent so we can
>>> re-use it" condition....
>>>
>>> There's nothing you can do to reliably avoid this - it's a sign that
>>> you're running low on free space in an AG because it's recycling
>>> recently freed space faster than the CIL is being committed to disk.
>>>
>>> You could speed up background journal syncs to try to reduce the
>>> async checkpoint latency that allows busy extents to build up
>>> (/proc/sys/fs/xfs/xfssyncd_centisecs) but that also impacts on
>>> journal overhead and IO latency, etc.
>> Perhaps xfs should auto-tune this variable.
> That's not a fix. That's a nasty hack that attempts to hide the
> underlying problem of selecting AGs and/or free space that requires
> a log force to be used instead of finding other, un-encumbered
> freespace present in the filesystem.

Isn't the underlying problem that you have a foreground process 
depending on the progress of a background process? i.e., no matter how 
AG and free space selection improves, you can always find a workload 
that consumes extents faster than they can be laundered?

I'm not saying that free extent selection can't or shouldn't be 
improved, just that it can never completely fix the problem on its own.

> i.e. We know what the underlying problem is here, and there isn't a
> quick fix for it. You're just going to have to live with that until
> we work out a reliable, robust way of avoiding having busy extents
> block allocations.
>
>>>> reactor-29  3336 [029]  3580.420137: xfs:xfs_ilock: dev 9:0 ino
>>>> 0x50000a9f flags ILOCK_EXCL caller kretprobe_trampoline
>>>>              7fffa0858572 xfs_ilock ([kernel.kallsyms])
>>>>              7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
>>>>              7fff8127314c file_update_time ([kernel.kallsyms])
>>>>              7fffa0849ab9 xfs_file_aio_write_checks ([kernel.kallsyms])
>>>>              7fffa0849bce xfs_file_dio_aio_write ([kernel.kallsyms])
>>>>              7fffa084a13f xfs_file_write_iter ([kernel.kallsyms])
>>>>              7fff812ab24f aio_write ([kernel.kallsyms])
>>>>              7fff812ab90e do_io_submit ([kernel.kallsyms])
>>>>              7fff812ac4c0 sys_io_submit ([kernel.kallsyms])
>>>>              7fff81005917 do_syscall_64 ([kernel.kallsyms])
>>>>              7fff81802115 return_from_SYSCALL_64 ([kernel.kallsyms])
>>>> io_submit() stalls. Later, task 8146 relinquishes the lock, which
>>>> (after passing through another worker thread), is finally acquired
>>>> by io_submit() which the continues.
>>> Yup, so it's the timestamp updates at IO submission that are
>>> blocking waiting for the *ILOCK* lock.
>>>
>>> [.....]
>>>
>>>> The other is to check that ILOCK can be taken exclusively in
>>>> xfs_file_dio_aio_write, if IOCB_NOWAIT. If this is the way to go, I
>>>> might venture a patch.
>>> You're getting your locks mixed up - xfs_file_dio_aio_write()
>>> doesn't ever take the ILOCK directly.  It takes the _IOLOCK_
>>> directly, and that's what IOCB_NOWAIT acts on.
>> It also takes ILOCK by calling file_update_time(), as seen in the
>> trace above. I've seen that it does a _nowait acquisition of the
>> IOLOCK, but that's not enough.
>>
>> If we could pass the iocb to file_update_time() then
>> xfs_vn_update_time, then it could perform a _nowait acquisition of
>> ILOCK. Otherwise, we can just check if ILOCK is acquirable in
>> xfs_file_aio_write_checks(). That's racy, but better than nothing.
> Sure, but that's not the issue with such suggestions. I'm not about
> to propose a patch to hack an iocb through generic infrastructure
> that doesn't need an iocb. Doing stuff like that will only get me
> shouted at because it's a massive layering violation and I should
> (and do!) know better....

If updating the time is part of an asynchronous operation, then it 
should fit with the rest of the async framework, no?

Perhaps a variant file_update_time_async() (which would be called by 
file_update_time).


>
>>> require the _ILOCK_ to be taken exclusively, and there's no way
>>> of knowing if that is going to be needed at the level of
>>> xfs_file_dio_aio_write().
>>>
>>> There are hooks in xfs_file_aio_write_checks() to avoid timestamp
>>> updates on write (FMODE_NOCMTIME) but there is no way to set this
>> >from userspace. It's used exclusively by the XFS open-by-handle
>>> code so that utilities like online defrag can write data into
>>> files without changing their user-visible timestamps.
>>>
>> xfs_file_aio_write_checks() knows its going to call
>> file_update_time(), and it can guess that file_update_time() will
>> call xfs_vn_update_time(). So just before that call, check that
>> ILOCK is free and EAGAIN if not.  Maybe that patch won't win any
>> beauty contests but it will reduce some of my pain.
> Again, grose, unmaintable layering violations. Expeditious solution
> to cater for your immediate need - you're welcome to do this with
> your own kernels, but it's not a solution we can really carry
> upstream.

Well, I don't like it very much either. But I do need some fix.

>
> And that brings me to the real issue here: If your requirement
> really is "never block io_submit(), ever", then the correct change
> to make is to the aio code so that it will /always queue IO/ and
> never attempt to submit it directly. If you get that done, then we
> can stop playing this tiresome whack-a-mole game in XFS.....
>
>

Queuing is easy, but who looks at that queue? If it's another thread, I 
can already do that from userspace from a worker thread (less 
efficiently due to more user/kernel mode changes). But now we have to 
context switch for each I/O. The whole point was to improve efficiency 
and reduce latency by doing everything directly.

