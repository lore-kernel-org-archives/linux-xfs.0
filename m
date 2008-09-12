Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Sep 2008 23:35:37 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C6Z8V9026996
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 23:35:08 -0700
Message-ID: <48CA0FD8.6010904@sgi.com>
Date: Fri, 12 Sep 2008 16:44:40 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Re-dirty pages on I/O error
References: <48C8D8CD.7050508@sgi.com> <20080911103342.GA17482@infradead.org> <48C98BE4.3000309@sandeen.net>
In-Reply-To: <48C98BE4.3000309@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Thu, Sep 11, 2008 at 06:37:33PM +1000, Lachlan McIlroy wrote:
>>> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
>>> we throw away the dirty page without converting the delayed allocation.  This
>>> leaves delayed allocations that can never be removed and confuses code that
>>> expects a flush of the file to clear them.  We need to re-dirty the page on
>>> error so we can try again later or report that the flush failed.
>>>
>>> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 16:32:11.000000000 +1000
>>> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 15:44:09.000000000 +1000
>>> @@ -1147,16 +1147,6 @@ error:
>>> 	if (iohead)
>>> 		xfs_cancel_ioend(iohead);
>>>
>>> -	/*
>>> -	 * If it's delalloc and we have nowhere to put it,
>>> -	 * throw it away, unless the lower layers told
>>> -	 * us to try again.
>>> -	 */
>>> -	if (err != -EAGAIN) {
>>> -		if (!unmapped)
>>> -			block_invalidatepage(page, 0);
>>> -		ClearPageUptodate(page);
>>> -	}
>> While this always looked fishy to me we it needs a good explanation to
>> kill this.  I try to remember why Steve did it this way long time ago.
> 
> Hrm some of that was my fault, ages ago.
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/pagebuf/Attic/page_buf_io.c.diff?r1=1.2;r2=1.3;hideattic=0
That revision history doesn't match the ptools history - probably cause the
file no longer exists.  Anyway it looks like the hack was mostly there before
your change.

> 
> I don't remember the details fo why.... ah here's a clue
> 
> http://oss.sgi.com/archives/xfs/2002-01/msg00475.html
Geez, that's so long ago that I doubt it's still an issue.  So it sounds
like this hack was added to prevent further issues after a forced shutdown
has already occurred.  If we leave this hack in there's a good chance it
will cause a forced shutdown.

> 
>> As _xfs_force_shutdown was written, it tried to schedule in an interrupt context
>> and caused a BUG() to be thrown.
> 
>> Also, even if we didn't try to deal with leftover buffers in the interrupt,
>> they subsequently had their delalloc flags removed, and thus queued up
>> to clobber block 0 (1,2,3) on the disk, thus corrupting the filesystem.
> 
> so back then, delalloc buffers w/o a home would eventually slam into the
> superblock, I guess.
Really?  How do you figure?  Delayed allocations have a special block
number of -1.  When that is converted to the physical disk address it
should end up beyond the end of the volume.

> 
> Anyway, if this is redirtied, will it ever go away for an IO error that
> persists?
For the case that I am trying to fix the error should not be persistent.
If there is a persistent error (and it doesn't result in a forced shutdown)
then I think we'll just keep trying to flush the data.

For errors that are ultimately persistant we wont know on the first I/O
that these are going to be persistant errors so I don't think it makes
sense to toss the data straight away - we may have temporarily lost our
link to the storage.

If there is a serious error (ie that results in a forced shutdown) then
we should end up tossing the data in xfs_sync_inodes().

> 
> -Eric
> 
>>> @@ -1216,8 +1206,11 @@ xfs_vm_writepage(
>>> 	 * then mark the page dirty again and leave the page
>>> 	 * as is.
>>> 	 */
>>> -	if (current_test_flags(PF_FSTRANS) && need_trans)
>>> -		goto out_fail;
>>> +	if (current_test_flags(PF_FSTRANS) && need_trans) {
>>> +		redirty_page_for_writepage(wbc, page);
>>> +		unlock_page(page);
>>> +		return -EAGAIN;
>> The redirty, unlock, return sequence is duplicated after your
>> patch, I think we should still keep the out_fail goto.  Also returning
>> -EGAIN from ->writepage is wrong.  The return values goes through
>> handle_write_error and mapping_set_error into the return value of e.g.
>> msync.  If you look at all similar writepage implementation they only
>> return a negative error for a real error condition and simply return 0
>> when just redirtying it due to transaction constraints or when trylocks
>> fail.
>>
>>
> 
> 
> 
