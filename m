Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37645C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E8FA206A4
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cpk1gfTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730578AbgFHQp6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 12:45:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730490AbgFHQp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 12:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591634756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6QSSl9qTyo2tHNd7j4UlcsV4bhU2NpIm7erat2ctMus=;
        b=Cpk1gfTWTFPl2xiJjH91Ir4qUtt3pe5eoTWnx3M0p58mq5ZxdQBEJMXrxsUNUQdZIEGmLl
        vREorgEYPedlRK45PPnaz5a0+EfZdj9mZcvIGshmzPTKpiWNp/QWP2/xBgVU9BUz9QQXII
        SIr8wAE9BPnNIhGIOqZ2DSh77ZlMO6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-fiwUZwFtMReQ5GzBz3WPLQ-1; Mon, 08 Jun 2020 12:45:55 -0400
X-MC-Unique: fiwUZwFtMReQ5GzBz3WPLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00A8764ACA;
        Mon,  8 Jun 2020 16:45:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BD31768BB;
        Mon,  8 Jun 2020 16:45:53 +0000 (UTC)
Date:   Mon, 8 Jun 2020 12:45:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/30] xfs: xfs_iflush() is no longer necessary
Message-ID: <20200608164551.GD36278@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-27-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-27-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:46:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have a cached buffer on inode log items, we don't need
> to do buffer lookups when flushing inodes anymore - all we need
> to do is lock the buffer and we are ready to go.
> 
> This largely gets rid of the need for xfs_iflush(), which is
> essentially just a mechanism to look up the buffer and flush the
> inode to it. Instead, we can just call xfs_iflush_cluster() with a
> few modifications to ensure it also flushes the inode we already
> hold locked.
> 
> This allows the AIL inode item pushing to be almost entirely
> non-blocking in XFS - we won't block unless memory allocation
> for the cluster inode lookup blocks or the block device queues are
> full.
> 
> Writeback during inode reclaim becomes a little more complex because
> we now have to lock the buffer ourselves, but otherwise this change
> is largely a functional no-op that removes a whole lot of code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks mostly reasonable..

>  fs/xfs/xfs_inode.c      | 106 ++++++----------------------------------
>  fs/xfs/xfs_inode.h      |   2 +-
>  fs/xfs/xfs_inode_item.c |  54 +++++++++-----------
>  3 files changed, 37 insertions(+), 125 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index af65acd24ec4e..61c872e4ee157 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
...
> @@ -3688,6 +3609,7 @@ xfs_iflush_int(
>  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  	ASSERT(iip != NULL && iip->ili_fields != 0);
> +	ASSERT(iip->ili_item.li_buf == bp);

FWIW, the previous assert includes an iip NULL check.

>  
>  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
>  
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 697248b7eb2be..326547e89cb6b 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -485,53 +485,42 @@ xfs_inode_item_push(
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> -	if (xfs_ipincount(ip) > 0)
> +	ASSERT(iip->ili_item.li_buf);
> +
> +	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> +	    (ip->i_flags & XFS_ISTALE))
>  		return XFS_ITEM_PINNED;
>  
> -	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
> -		return XFS_ITEM_LOCKED;
> +	/* If the inode is already flush locked, we're already flushing. */

Or we're racing with reclaim (since we don't have the ilock here any
longer)?

> +	if (xfs_isiflocked(ip))
> +		return XFS_ITEM_FLUSHING;
>  
> -	/*
> -	 * Re-check the pincount now that we stabilized the value by
> -	 * taking the ilock.
> -	 */
> -	if (xfs_ipincount(ip) > 0) {
> -		rval = XFS_ITEM_PINNED;
> -		goto out_unlock;
> -	}
> +	if (!xfs_buf_trylock(bp))
> +		return XFS_ITEM_LOCKED;
>  
> -	/*
> -	 * Stale inode items should force out the iclog.
> -	 */
> -	if (ip->i_flags & XFS_ISTALE) {
> -		rval = XFS_ITEM_PINNED;
> -		goto out_unlock;
> +	if (bp->b_flags & _XBF_DELWRI_Q) {
> +		xfs_buf_unlock(bp);
> +		return XFS_ITEM_FLUSHING;

Hmm, what's the purpose of this check? I would expect that we'd still be
able to flush to a buffer even though it's delwri queued. We drop the
buffer lock after queueing it (and then it's reacquired on delwri
submit).

>  	}
> +	spin_unlock(&lip->li_ailp->ail_lock);
>  
>  	/*
> -	 * Someone else is already flushing the inode.  Nothing we can do
> -	 * here but wait for the flush to finish and remove the item from
> -	 * the AIL.
> +	 * We need to hold a reference for flushing the cluster buffer as it may
> +	 * fail the buffer without IO submission. In which case, we better get a
> +	 * reference for that completion because otherwise we don't get a
> +	 * reference for IO until we queue the buffer for delwri submission.
>  	 */
> -	if (!xfs_iflock_nowait(ip)) {
> -		rval = XFS_ITEM_FLUSHING;
> -		goto out_unlock;
> -	}
> -
> -	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> -	spin_unlock(&lip->li_ailp->ail_lock);
> -
> -	error = xfs_iflush(ip, &bp);
> +	xfs_buf_hold(bp);
> +	error = xfs_iflush_cluster(ip, bp);
>  	if (!error) {
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  		xfs_buf_relse(bp);
> -	} else if (error == -EAGAIN)
> +	} else {
>  		rval = XFS_ITEM_LOCKED;
> +	}
>  
>  	spin_lock(&lip->li_ailp->ail_lock);
> -out_unlock:
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	return rval;
>  }
>  
> @@ -548,6 +537,7 @@ xfs_inode_item_release(
>  
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(lip->li_buf || !test_bit(XFS_LI_DIRTY, &lip->li_flags));

This is the transaction cancel/abort path, so seems like this should be
part of the patch that attaches the ili on logging the inode?

Brian

>  
>  	lock_flags = iip->ili_lock_flags;
>  	iip->ili_lock_flags = 0;
> -- 
> 2.26.2.761.g0e0b3e54be
> 

