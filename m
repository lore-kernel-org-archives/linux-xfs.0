Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 05:25:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99CPpUG014197
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 05:25:52 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A368AA24795
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 05:27:30 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id GZrBtFR4UYN3q4IB for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 05:27:30 -0700 (PDT)
Date: Thu, 9 Oct 2008 23:27:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] Re-dirty pages on ENOSPC when converting delayed
	allocations
Message-ID: <20081009122726.GH9597@disturbed>
References: <48EB1ABD.3020503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EB1ABD.3020503@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Oct 07, 2008 at 06:15:57PM +1000, Lachlan McIlroy wrote:
> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
> we throw away the dirty page without converting the delayed allocation.  This
> leaves delayed allocations that can never be removed and confuses code that
> expects a flush of the file to clear them.  We need to re-dirty the page on
> error so we can try again later or report that the flush failed.

Actually, those delalloc pages can be removed - they just need to
be handled in ->releasepage. The problem there is that the
delalloc state is checked by looking at the bufferhead, and by
the time we get to ->releasepage the buffer heads have already gone
through discard_buffer() and lost the buffer_delay() flag.

IIRC I had a patch that did the delalloc conversion correctly in
->releasepage by utilising a custom ->invalidatepage callouut, but
the performance overhead was very bad because it is done a page at a
time. ISTR even posting it to oss....

> This change is needed to handle the condition where we are at ENOSPC and we
> exhaust the reserved block pool (because many transactions are executing
> concurrently) and calls to xfs_trans_reserve() start failing with ENOSPC
> errors.
>
> Version 2 wont return EAGAIN from xfs_vm_writepage() and also converts an
> ENOSPC error to an EAGAIN for asynchronous writeback to avoid setting an
> error in the inode mapping when we don't need to.
>
> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-10-07 17:02:04.000000000 +1000
> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-10-07 17:58:04.000000000 +1000
> @@ -1147,16 +1147,6 @@ error:
> 	if (iohead)
> 		xfs_cancel_ioend(iohead);
>
> -	/*
> -	 * If it's delalloc and we have nowhere to put it,
> -	 * throw it away, unless the lower layers told
> -	 * us to try again.
> -	 */
> -	if (err != -EAGAIN) {
> -		if (!unmapped)
> -			block_invalidatepage(page, 0);
> -		ClearPageUptodate(page);
> -	}
> 	return err;
> }

So we don't throw away pages here....

> @@ -1231,19 +1221,16 @@ xfs_vm_writepage(
> 	 * to real space and flush out to disk.
> 	 */
> 	error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
> -	if (error == -EAGAIN)
> -		goto out_fail;
> 	if (unlikely(error < 0))
> -		goto out_unlock;
> +		goto out_fail;
>
> 	return 0;
>
> out_fail:
> 	redirty_page_for_writepage(wbc, page);
> 	unlock_page(page);
> -	return 0;
> -out_unlock:
> -	unlock_page(page);
> +	if (error == -EAGAIN)
> +		error = 0;
> 	return error;
> }

And we redirty every page that comes through here with an error.

IOWs on permanent IO errors we can't get rid of the pages without
a forced shutdown. That was my main objection to the first version
of the patch.

> --- a/fs/xfs/xfs_iomap.c	2008-10-07 17:02:04.000000000 +1000
> +++ b/fs/xfs/xfs_iomap.c	2008-10-07 17:58:04.000000000 +1000
> @@ -269,6 +269,8 @@ xfs_iomap(
>
> 		error = xfs_iomap_write_allocate(ip, offset, count,
> 						 &imap, &nimaps);
> +		if ((flags & BMAPI_TRYLOCK) && error == ENOSPC)
> +			error = EAGAIN;
> 		break;
> 	}
>

But you've added the special ENOSPC case to avoid having an error
reported on non-blocking flushes that I suggested. That's not
exactly what I meant or thought I was suggesting.

What I thought I suggested was to do the above ENOSPC swizzling for the
non-blocking case, but still throw away pages in the blocking flush
case.  That is, remove the first two hunks of the patch, and just
use the third hunk. That way we don't introduce entertaining new
ENOSPC problems by retaining the current behaviour, but we still
fix the prolonged depletion of the reserve pool by delalloc
reservations which seemed to be the cause of all the ENOSPC
problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
