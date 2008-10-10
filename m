Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 23:45:17 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A6jFeh010692
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 23:45:15 -0700
Message-ID: <48EF0815.7080001@sgi.com>
Date: Fri, 10 Oct 2008 17:45:25 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH V2] Re-dirty pages on ENOSPC when converting delayed	allocations
References: <48EB1ABD.3020503@sgi.com> <20081009122726.GH9597@disturbed>
In-Reply-To: <20081009122726.GH9597@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Tue, Oct 07, 2008 at 06:15:57PM +1000, Lachlan McIlroy wrote:
>> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
>> we throw away the dirty page without converting the delayed allocation.  This
>> leaves delayed allocations that can never be removed and confuses code that
>> expects a flush of the file to clear them.  We need to re-dirty the page on
>> error so we can try again later or report that the flush failed.
> 
> Actually, those delalloc pages can be removed - they just need to
> be handled in ->releasepage. The problem there is that the
> delalloc state is checked by looking at the bufferhead, and by
> the time we get to ->releasepage the buffer heads have already gone
> through discard_buffer() and lost the buffer_delay() flag.
> 
> IIRC I had a patch that did the delalloc conversion correctly in
> ->releasepage by utilising a custom ->invalidatepage callouut, but
> the performance overhead was very bad because it is done a page at a
> time. ISTR even posting it to oss....
> 
>> This change is needed to handle the condition where we are at ENOSPC and we
>> exhaust the reserved block pool (because many transactions are executing
>> concurrently) and calls to xfs_trans_reserve() start failing with ENOSPC
>> errors.
>>
>> Version 2 wont return EAGAIN from xfs_vm_writepage() and also converts an
>> ENOSPC error to an EAGAIN for asynchronous writeback to avoid setting an
>> error in the inode mapping when we don't need to.
>>
>> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-10-07 17:02:04.000000000 +1000
>> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-10-07 17:58:04.000000000 +1000
>> @@ -1147,16 +1147,6 @@ error:
>> 	if (iohead)
>> 		xfs_cancel_ioend(iohead);
>>
>> -	/*
>> -	 * If it's delalloc and we have nowhere to put it,
>> -	 * throw it away, unless the lower layers told
>> -	 * us to try again.
>> -	 */
>> -	if (err != -EAGAIN) {
>> -		if (!unmapped)
>> -			block_invalidatepage(page, 0);
>> -		ClearPageUptodate(page);
>> -	}
>> 	return err;
>> }
> 
> So we don't throw away pages here....
> 
>> @@ -1231,19 +1221,16 @@ xfs_vm_writepage(
>> 	 * to real space and flush out to disk.
>> 	 */
>> 	error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
>> -	if (error == -EAGAIN)
>> -		goto out_fail;
>> 	if (unlikely(error < 0))
>> -		goto out_unlock;
>> +		goto out_fail;
>>
>> 	return 0;
>>
>> out_fail:
>> 	redirty_page_for_writepage(wbc, page);
>> 	unlock_page(page);
>> -	return 0;
>> -out_unlock:
>> -	unlock_page(page);
>> +	if (error == -EAGAIN)
>> +		error = 0;
>> 	return error;
>> }
> 
> And we redirty every page that comes through here with an error.
> 
> IOWs on permanent IO errors we can't get rid of the pages without
> a forced shutdown. That was my main objection to the first version
> of the patch.

If there is a permanent error then a metadata or log I/O will probably
soon fail and that will issue a force shutdown anyway and that will
cause us to discard the pages.

I just don't get why silently discarding writes is a good idea.  And
even if we issue a warning the user has no idea which writes were
discarded.

Are you worried we will deadlock the system by running out of pages?
Wouldn't it be better to do that than keep the system running in the
face of data corruption?

> 
>> --- a/fs/xfs/xfs_iomap.c	2008-10-07 17:02:04.000000000 +1000
>> +++ b/fs/xfs/xfs_iomap.c	2008-10-07 17:58:04.000000000 +1000
>> @@ -269,6 +269,8 @@ xfs_iomap(
>>
>> 		error = xfs_iomap_write_allocate(ip, offset, count,
>> 						 &imap, &nimaps);
>> +		if ((flags & BMAPI_TRYLOCK) && error == ENOSPC)
>> +			error = EAGAIN;
>> 		break;
>> 	}
>>
> 
> But you've added the special ENOSPC case to avoid having an error
> reported on non-blocking flushes that I suggested. That's not
> exactly what I meant or thought I was suggesting.
> 
> What I thought I suggested was to do the above ENOSPC swizzling for the
> non-blocking case, but still throw away pages in the blocking flush
> case.  That is, remove the first two hunks of the patch, and just
> use the third hunk. That way we don't introduce entertaining new
> ENOSPC problems by retaining the current behaviour, but we still
> fix the prolonged depletion of the reserve pool by delalloc
> reservations which seemed to be the cause of all the ENOSPC
> problems.

Are you sure?  So a synchronous flush of the file would still discard
data and leave the delayed allocation.  A flushinval (before a direct
I/O) would get an error and fail but a second flushinval would succeed
(because it would not try to flush the same page) and we'd hit the
BUG_ON with direct I/O.
