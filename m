Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Sep 2008 22:55:59 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C5tAZI024617
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 22:55:10 -0700
Message-ID: <48CA067F.1050402@sgi.com>
Date: Fri, 12 Sep 2008 16:04:47 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Re-dirty pages on I/O error
References: <48C8D8CD.7050508@sgi.com> <20080911103342.GA17482@infradead.org>
In-Reply-To: <20080911103342.GA17482@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

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
We'd need an even better explanation to keep it.  It's just plain wrong
and has caused serious customer issues for us.

At ENOSPC calls to xfs_trans_reserve() can fail if the reserved space is
also exhausted (see m_resblks).  This causes conversion of delayed allocs
to fail with ENOSPC.  This dodgy code throws the page away and leaves the
delayed alloc.  A direct I/O then panics because it finds a delayed
allocation when it does not expect one.

This code has been there since the initial version of the file.

> 
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

I got rid of the goto because it looked messy but if you want it back I'll
change it.

As for the EAGAIN, I'll change that to 0.  I don't think it makes any
difference to the problem I'm trying to fix.
