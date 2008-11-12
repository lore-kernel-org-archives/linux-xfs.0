Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 22:48:58 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC6mhdo006935
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 22:48:43 -0800
Message-ID: <491A7C2F.8020702@sgi.com>
Date: Wed, 12 Nov 2008 17:48:15 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH V2] Re-dirty pages on ENOSPC when converting delayed allocations
References: <48EB1ABD.3020503@sgi.com>
In-Reply-To: <48EB1ABD.3020503@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Could we please reach consensus on this patch? - it's been more
than a month .. and we have customers hitting it. If nobody has any
objections, we're going to take it and push it for 2.6.28.

Thanks
-- Mark

Lachlan McIlroy wrote:
> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
> we throw away the dirty page without converting the delayed allocation.  
> This
> leaves delayed allocations that can never be removed and confuses code that
> expects a flush of the file to clear them.  We need to re-dirty the page on
> error so we can try again later or report that the flush failed.
> 
> This change is needed to handle the condition where we are at ENOSPC and we
> exhaust the reserved block pool (because many transactions are executing
> concurrently) and calls to xfs_trans_reserve() start failing with ENOSPC
> errors.
> 
> Version 2 wont return EAGAIN from xfs_vm_writepage() and also converts an
> ENOSPC error to an EAGAIN for asynchronous writeback to avoid setting an
> error in the inode mapping when we don't need to.
> 
> --- a/fs/xfs/linux-2.6/xfs_aops.c    2008-10-07 17:02:04.000000000 +1000
> +++ b/fs/xfs/linux-2.6/xfs_aops.c    2008-10-07 17:58:04.000000000 +1000
> @@ -1147,16 +1147,6 @@ error:
>     if (iohead)
>         xfs_cancel_ioend(iohead);
> 
> -    /*
> -     * If it's delalloc and we have nowhere to put it,
> -     * throw it away, unless the lower layers told
> -     * us to try again.
> -     */
> -    if (err != -EAGAIN) {
> -        if (!unmapped)
> -            block_invalidatepage(page, 0);
> -        ClearPageUptodate(page);
> -    }
>     return err;
> }
> 
> @@ -1185,7 +1175,7 @@ xfs_vm_writepage(
>     struct page        *page,
>     struct writeback_control *wbc)
> {
> -    int            error;
> +    int            error = 0;
>     int            need_trans;
>     int            delalloc, unmapped, unwritten;
>     struct inode        *inode = page->mapping->host;
> @@ -1231,19 +1221,16 @@ xfs_vm_writepage(
>      * to real space and flush out to disk.
>      */
>     error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
> -    if (error == -EAGAIN)
> -        goto out_fail;
>     if (unlikely(error < 0))
> -        goto out_unlock;
> +        goto out_fail;
> 
>     return 0;
> 
> out_fail:
>     redirty_page_for_writepage(wbc, page);
>     unlock_page(page);
> -    return 0;
> -out_unlock:
> -    unlock_page(page);
> +    if (error == -EAGAIN)
> +        error = 0;
>     return error;
> }
> 
> --- a/fs/xfs/xfs_iomap.c    2008-10-07 17:02:04.000000000 +1000
> +++ b/fs/xfs/xfs_iomap.c    2008-10-07 17:58:04.000000000 +1000
> @@ -269,6 +269,8 @@ xfs_iomap(
> 
>         error = xfs_iomap_write_allocate(ip, offset, count,
>                          &imap, &nimaps);
> +        if ((flags & BMAPI_TRYLOCK) && error == ENOSPC)
> +            error = EAGAIN;
>         break;
>     }
> 
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
