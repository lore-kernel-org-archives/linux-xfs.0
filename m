Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 21:18:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8D4I3Rf003737
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:18:03 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC5CA1067C84
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:19:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id abgK1TeBYTf9XYZD for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 21:19:33 -0700 (PDT)
Date: Sat, 13 Sep 2008 14:19:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re-dirty pages on I/O error
Message-ID: <20080913041930.GC5811@disturbed>
References: <48C8D8CD.7050508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8D8CD.7050508@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 11, 2008 at 06:37:33PM +1000, Lachlan McIlroy wrote:
> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
> we throw away the dirty page without converting the delayed allocation.  This
> leaves delayed allocations that can never be removed and confuses code that
> expects a flush of the file to clear them.  We need to re-dirty the page on
> error so we can try again later or report that the flush failed.
>
> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 16:32:11.000000000 +1000
> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 15:44:09.000000000 +1000
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

So we keep dirty pages around that we can't write back?
If we are in a low memory situation and the block device
has gone bad, that will prevent memory reclaim from making
progress.

i.e. if we have a bad disk, a user can now take down the system
by running it out of clean memory....

The EAGAIN case is for when we can't get the locks we
need during non-blocking writeback, which is a common case if
there is concurrent writes to this inode....

> @@ -1216,8 +1206,11 @@ xfs_vm_writepage(
> 	 * then mark the page dirty again and leave the page
> 	 * as is.
> 	 */
> -	if (current_test_flags(PF_FSTRANS) && need_trans)
> -		goto out_fail;
> +	if (current_test_flags(PF_FSTRANS) && need_trans) {
> +		redirty_page_for_writepage(wbc, page);
> +		unlock_page(page);
> +		return -EAGAIN;
> +	}

Should not return an error here - the redirty_page_for_writepage()
call effective says "can't do this right away, but no error
needs to be reported because it can be written again later".
Happens all the time with non-blocking writes.

> @@ -1231,20 +1224,14 @@ xfs_vm_writepage(
> 	 * to real space and flush out to disk.
> 	 */
> 	error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
> -	if (error == -EAGAIN)
> -		goto out_fail;
> -	if (unlikely(error < 0))
> -		goto out_unlock;
>
> -	return 0;
> +	if (error < 0) {
> +		redirty_page_for_writepage(wbc, page);
> +		unlock_page(page);
> +		return error;
> +	}

That needs the EAGAIN exception - that's not an error.
For EIO, though, we should really be invalidating the
page like we currently do. However, it should be silent as
per the current behaviour - a rate-limited log warning is
really needed here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
