Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 01:36:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m778ZWYf002292
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 01:35:33 -0700
Message-ID: <489AB596.1010505@sgi.com>
Date: Thu, 07 Aug 2008 18:43:02 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed> <489806C2.7020200@sgi.com> <20080805084220.GF21635@disturbed> <48990C4E.9070102@sgi.com> <20080806052053.GU6119@disturbed> <4899406D.5020802@sgi.com> <20080806093844.GZ6119@disturbed>
In-Reply-To: <20080806093844.GZ6119@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Wed, Aug 06, 2008 at 04:10:53PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Wed, Aug 06, 2008 at 12:28:30PM +1000, Lachlan McIlroy wrote:
>>>> Dave Chinner wrote:
>>>>> On Tue, Aug 05, 2008 at 05:52:34PM +1000, Lachlan McIlroy wrote:
>>>>>> Dave Chinner wrote:
>>>>>>> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
>>>>>>>> Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
>>>>>>>> gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
>>>>>>> xfs_free()? What's that?
>>>>>> Sorry that should have been xfs_ifree() (we set the inode's mode to
>>>>>> zero in there).
>>>>>>
>>>>>>>> completions still running (file size updates and unwritten extent conversions)
>>>>>>>> may be working on an inode that is no longer valid.
>>>>>>> The linux inode does not get freed until after ->clear_inode
>>>>>>> completes, hence it is perfectly valid to reference it anywhere
>>>>>>> in the ->clear_inode path.
>>>>>> The problem I see is an assert in xfs_setfilesize() fail:
>>>>>>
>>>>>> 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
>>>>>>
>>>>>> The mode of the XFS inode is zero at this time.
>>>>> Ok, so the question has to be why is there I/O still in progress
>>>>> after the truncate is supposed to have already occurred and the
>>>>> vn_iowait() in xfs_itruncate_start() been executed.
>>>>>
>>>>> Something doesn't add up here - you can't be doing I/O on a file
>>>>> with no extents or delalloc blocks, hence that means we should be
>>>>> passing through the truncate path in xfs_inactive() before we
>>>>> call xfs_ifree() and therefore doing the vn_iowait()..
>>>>>
>>>>> Hmmmm - the vn_iowait() is conditional based on:
>>>>>
>>>>>         /* wait for the completion of any pending DIOs */
>>>>>         if (new_size < ip->i_size)
>>>>>                 vn_iowait(ip);
>>>>>
>>>>> We are truncating to zero (new_size == 0), so the only case where
>>>>> this would not wait is if ip->i_size == 0. Still - I can't see
>>>>> how we'd be doing I/O on an inode with a zero i_size. I suspect
>>>>> ensuring we call vn_iowait() if newsize == 0 as well would fix
>>>>> the problem. If not, there's something much more subtle going
>>>>> on here that we should understand....
>>>> If we make the vn_iowait() unconditional we might re-introduce the
>>>> NFS exclusivity bug that killed performance.  That was through
>>>> xfs_release()->xfs_free_eofblocks()->xfs_itruncate_start().
>>> It won't reintroduce that problem because ->clear_inode()
>>> is not called on every NFS write operation.
>> Yes but xfs_itruncate_start() can be called from every NFS write so
>> modifying the above code will re-introduce the problem.
> 
> Ah, no. The case here is new_size == 0, which will almost never be
> the case in the ->release call...
True.

> 
>>>> So if we leave the above code as is then we need another
>>>> vn_iowait() in xfs_inactive() to catch any remaining workqueue
>>>> items that we didn't wait for in xfs_itruncate_start().
>>> How do we have any new *data* I/O at all in progress at this point?
>> It's not new data I/O.
> 
> Then why isn't is being caught by the vn_iowait() in the truncate
> code?????
No idea.

> 
>>  It's workqueue items that have been queued
>> from previous I/Os that are still outstanding.
> 
> The iocount is decremented when the completion is finished, not when it
> is queued. Hence vn_iowait() should be taking into account this case.
Hmmm.  It should.

> 
>>> That does not explain why we need an additional vn_iowait() call.
>>> All I see from this is a truncate race that has somethign to do with
>>> the vn_iowait() call being conditional.
>>>
>>> That is, if we truncate to zero, then the current code in
>>> xfs_itruncate_start() should wait unconditinally for *all* I/O to
>>> complete because, by definition, all that I/O is beyond the new EOF
>>> and we have to wait for it to complete before truncating the file.
>> That makes sense.  If new_size is zero and ip->i_size is not then we
>> will wait.  If ip->i_size is also zero we will not wait but if the
>> file size is already zero there should not be any I/Os in progress
>> and therefore no workqueue items outstanding.
> 
> I note from the debug below that the linux inode size is zero,
> but you didn't include the dump of the xfs inode so we can't see
> what the other variables are.
I tried to dump the xfs inode at the time but kdb encountered a bad
address.  I'm pretty sure I was able to get a dump of the XFS inode
on another crash - that's how I found the mode to be zero.  I can't
be sure now - I'll have to reproduce the problem again.

> 
> Also, i_size is updated after write I/O is dispatched. If we are
> doing synchronous I/O, then i_size is not updated until after the
> I/O completes (in xfs_write()). Hence we could have the situation of
> I/O being run while i_size = 0. This is why I wanted to know what
> i_new_size is, because that gets set before the I/O is issued.
> 
> if i_new_size is non-zero and i_size is zero,that tends to imply
> the conditional vn_iowait() in the truncate path needs to take
> MAX(ip->i_size, ip->i_new_size) for the check, not just ip->i_size...
> 
> FWIW, from the dump below, we have:
> 
> typedef struct xfs_ioend {
>         struct xfs_ioend        *io_list = NULL
>         unsigned int            io_type = 0x20 = IOMAP_UNWRITTEN
>         int                     io_error = 0
>         atomic_t                io_remaining = 0;
>         struct inode            *io_inode = 0xffff810054062048
>         struct buffer_head      *io_buffer_head = NULL
>         struct buffer_head      *io_buffer_tail = NULL
>         size_t                  io_size = 0x3400
>         xfs_off_t               io_offset = 0xfe200
>         struct work_struct      io_work;        /* xfsdatad work queue */
> } xfs_ioend_t;
> 
> So the I/O was not even close to offset zero.
> 
> Also, the fact that the stack trace says it came through the
> written path, but the io_type says unwritten which says that there's
> something fishy here.  Either the stack trace is wrong, or there's
> been a memory corruption....
I'm pretty sure that's because it was a direct I/O write to a written
extent.  The I/O starts out as IOMAP_UNWRITTEN and if we didn't map to
an unwritten extent it's completion handler is switched to the written
one.  Looking at the direct I/O write path I can see where the direct
I/O write would wait for the bio's to complete but it's not waiting for
the workqueue items to be flushed.  Not sure if that's part of the
problem though.

> 
>>> If either the vn_iowait() in the truncate path is not sufficient, or
>>> the truncate code is not being called, there is *some other bug*
>>> that we don't yet understand.  Adding an unconditional vn_iowait()
>>> appear to me to be fixing a symptom, not the underlying cause of
>>> the problem....
>> I'm not adding a new call to vn_iowait().  I'm just moving the
>> existing one from xfs_ireclaim() so that we wait for all I/O to
>> complete before we tear the inode down.
> 
> Yes, but that is there to catch inodes with non-zero link counts because
> we are not doing a truncate in that case. We still need to get to the
> bottom of why the truncate is not waiting for all I/O.

I'm wondering if we have an extra decrement on the i_iocount atomic counter
that tricked vn_iowait() into thinking that all I/Os have completed.

Should this code in xfs_vm_direct_IO():

	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
		xfs_destroy_ioend(iocb->private);

be:

	if (unlikely(ret < 0 && ret != -EIOCBQUEUED && iocb->private))
		xfs_destroy_ioend(iocb->private);

Ordinarily we'd drop the i_iocount reference by calling xfs_end_io_direct().
