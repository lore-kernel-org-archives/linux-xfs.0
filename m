Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Sep 2008 14:21:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8BLLhNd022014
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 14:21:44 -0700
Message-ID: <48C98BE4.3000309@sandeen.net>
Date: Thu, 11 Sep 2008 16:21:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Re-dirty pages on I/O error
References: <48C8D8CD.7050508@sgi.com> <20080911103342.GA17482@infradead.org>
In-Reply-To: <20080911103342.GA17482@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Sep 11, 2008 at 06:37:33PM +1000, Lachlan McIlroy wrote:
>> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
>> we throw away the dirty page without converting the delayed allocation.  This
>> leaves delayed allocations that can never be removed and confuses code that
>> expects a flush of the file to clear them.  We need to re-dirty the page on
>> error so we can try again later or report that the flush failed.
>>
>> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 16:32:11.000000000 +1000
>> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 15:44:09.000000000 +1000
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
> 
> While this always looked fishy to me we it needs a good explanation to
> kill this.  I try to remember why Steve did it this way long time ago.

Hrm some of that was my fault, ages ago.

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/pagebuf/Attic/page_buf_io.c.diff?r1=1.2;r2=1.3;hideattic=0

I don't remember the details fo why.... ah here's a clue

http://oss.sgi.com/archives/xfs/2002-01/msg00475.html

> As _xfs_force_shutdown was written, it tried to schedule in an interrupt context
> and caused a BUG() to be thrown.

> Also, even if we didn't try to deal with leftover buffers in the interrupt,
> they subsequently had their delalloc flags removed, and thus queued up
> to clobber block 0 (1,2,3) on the disk, thus corrupting the filesystem.

so back then, delalloc buffers w/o a home would eventually slam into the
superblock, I guess.

Anyway, if this is redirtied, will it ever go away for an IO error that
persists?

-Eric

>> @@ -1216,8 +1206,11 @@ xfs_vm_writepage(
>> 	 * then mark the page dirty again and leave the page
>> 	 * as is.
>> 	 */
>> -	if (current_test_flags(PF_FSTRANS) && need_trans)
>> -		goto out_fail;
>> +	if (current_test_flags(PF_FSTRANS) && need_trans) {
>> +		redirty_page_for_writepage(wbc, page);
>> +		unlock_page(page);
>> +		return -EAGAIN;
> 
> The redirty, unlock, return sequence is duplicated after your
> patch, I think we should still keep the out_fail goto.  Also returning
> -EGAIN from ->writepage is wrong.  The return values goes through
> handle_write_error and mapping_set_error into the return value of e.g.
> msync.  If you look at all similar writepage implementation they only
> return a negative error for a real error condition and simply return 0
> when just redirtying it due to transaction constraints or when trylocks
> fail.
> 
> 
