Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:43556 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932621AbeBLJds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Feb 2018 04:33:48 -0500
Received: by mail-wr0-f170.google.com with SMTP id b52so14420038wrd.10
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2018 01:33:47 -0800 (PST)
Subject: Re: xfs_buf_lock vs aio
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
Date: Mon, 12 Feb 2018 11:33:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180209231015.GI20266@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 02/10/2018 01:10 AM, Dave Chinner wrote:
> On Fri, Feb 09, 2018 at 02:11:58PM +0200, Avi Kivity wrote:
>> On 02/09/2018 12:11 AM, Dave Chinner wrote:
>>> On Thu, Feb 08, 2018 at 10:24:11AM +0200, Avi Kivity wrote:
>>>> On 02/08/2018 01:33 AM, Dave Chinner wrote:
>>>>> On Wed, Feb 07, 2018 at 07:20:17PM +0200, Avi Kivity wrote:
>>>>>> As usual, I'm having my lovely io_submit()s sleeping. This time some
>>>>>> detailed traces. 4.14.15.
>>> [....]
>>>
>>>>>> Forcing the log, so sleeping with ILOCK taken.
>>>>> Because it's trying to reallocate an extent that is pinned in the
>>>>> log and is marked stale. i.e. we are reallocating a recently freed
>>>>> metadata extent that hasn't been committed to disk yet. IOWs, it's
>>>>> the metadata form of the "log force to clear a busy extent so we can
>>>>> re-use it" condition....
>>>>>
>>>>> There's nothing you can do to reliably avoid this - it's a sign that
>>>>> you're running low on free space in an AG because it's recycling
>>>>> recently freed space faster than the CIL is being committed to disk.
>>>>>
>>>>> You could speed up background journal syncs to try to reduce the
>>>>> async checkpoint latency that allows busy extents to build up
>>>>> (/proc/sys/fs/xfs/xfssyncd_centisecs) but that also impacts on
>>>>> journal overhead and IO latency, etc.
>>>> Perhaps xfs should auto-tune this variable.
>>> That's not a fix. That's a nasty hack that attempts to hide the
>>> underlying problem of selecting AGs and/or free space that requires
>>> a log force to be used instead of finding other, un-encumbered
>>> freespace present in the filesystem.
>> Isn't the underlying problem that you have a foreground process
>> depending on the progress of a background process?
> At a very, very basic level.
>
>> i.e., no matter
>> how AG and free space selection improves, you can always find a
>> workload that consumes extents faster than they can be laundered?
> Sure, but that doesn't mean we have to fall back to a synchronous
> alogrithm to handle collisions. It's that synchronous behaviour that
> is the root cause of the long lock stalls you are seeing.

Well, having that algorithm be asynchronous will be wonderful. But I 
imagine it will be a monstrous effort.

>
>> I'm not saying that free extent selection can't or shouldn't be
>> improved, just that it can never completely fix the problem on its
>> own.
> Righto, if you say so.
>
> After all, what do I know about the subject at hand? I'm just the
> poor dumb guy


Just because you're an XFS expert, and even wrote the code at hand, 
doesn't mean I have nothing to contribute. If I'm wrong, it's enough to 
tell me that and why.



>   who wrote the current busy extent list handling
> algorithm years ago.  Perhaps you'd like to read the commit message
> (below), because it explains these sycnhronous slow paths and why
> they exist. I'll quote the part relevant to the discussion here,
> though:
>
> 	    Ideally we should not reallocate busy extents. That is a
> 	    much more complex fix to the problem as it involves
> 	    direct intervention in the allocation btree searches in
> 	    many places. This is left to a future set of
> 	    modifications.

Thanks, that commit was interesting.

So, this future set of modifications is to have the extent allocator 
consult this rbtree and continue searching if locked?

> Christoph has already mentioned in these busy extent blocking
> threads that we need to do to avoid the synchronous blocking
> problems you are seeing. We knew about this blocking problem more
> than *15 years ago*, but we didn't need to solve it 8 years ago
> because we it was not necessary to solve the "array overrun causes
> log forces" problem people were reporting when they had heaps of
> free space available in each AG.
>
> Since then we haven't had a user report a workload that needed
> anything more than what we currently do. You have a workload where
> this is now important, and so we now need to revisit the issues we
> laid out some 8 years ago and work from there.

I still think reducing the amount of outstanding busy extents is 
important. Modern disks write multiple GB/s, and big-data applications 
like to do large sequential writes and deletes, so high production rate 
of busy extents. Users also like high space utilization of their SSDs. 
It's easy to end up where most of your free extents are busy, leading to 
a hard time for your find-not-busy-free-extent algorithm.


>>>> If we could pass the iocb to file_update_time() then
>>>> xfs_vn_update_time, then it could perform a _nowait acquisition of
>>>> ILOCK. Otherwise, we can just check if ILOCK is acquirable in
>>>> xfs_file_aio_write_checks(). That's racy, but better than nothing.
>>> Sure, but that's not the issue with such suggestions. I'm not about
>>> to propose a patch to hack an iocb through generic infrastructure
>>> that doesn't need an iocb. Doing stuff like that will only get me
>>> shouted at because it's a massive layering violation and I should
>>> (and do!) know better....
>> If updating the time is part of an asynchronous operation, then it
>> should fit with the rest of the async framework, no?
>>
>> Perhaps a variant file_update_time_async() (which would be called by
>> file_update_time).
> This doesn't fix the problem you've reported.
>
> We've got to run a transaction to update timestamps. That means
> memory allocation (which can block on IO) and transaction
> reservations need to be made (which can block on IO) *before* we
> even attempt to take the ilock.  That means there's a huge TOCTOU
> race window in any "optimisitic" check we'd do here.
>
> IOWs,  a non-blocking timestamp update API is still racy. It /might/
> make blocking in timestamp updates less common, but it will not
> improve the worst case long-tail latencies that are causing you
> problems. And that means it doesn't fix your problem.

I'm aware it's racy. For me, even making it less common is an important 
improvement. I know I'll never get fully asynchronous behavior from the 
kernel, so I'm looking for the lowest hanging fruit rather than perfection.

I'm slightly helped by the fact that kernel memory allocations never 
block for me, as the kernel is never under memory pressure (my 
application allocates a fixed amount of anonymous memory and doesn't 
touch the page cache), but that's not the general case.

If we do have an async variant of file_update_time(), then the second 
check (for transaction reservation) can consult the NOWAIT flag and fail 
the write in that case with EAGAIN.

>
>> Well, I don't like it very much either. But I do need some fix.
> We are well aware of that. And we are also well aware of just how
> complex and difficult it is to solve properly.
>

Yeah.
