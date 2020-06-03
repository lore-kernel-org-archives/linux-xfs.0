Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D915EC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 18:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B08DA2077D
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 18:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fisNTnAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgFCS6U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 14:58:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23489 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725922AbgFCS6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 14:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591210697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KINSLNXf0Q7nedhIg4MnCQWoFg4ZfpKfLCLO6c6utWo=;
        b=fisNTnArVzvqcY0oM1/c28g7Ia9E5Nn862mE6xYbzOLCcMuKgcxPuIF6YmVpF/x/w22dM4
        niir2v96cxC/pQfCJpJExbgsRTTl6DMho9+J/Fv4Gq+ozz75YXxtUmqvE/E3LWQ04joHxV
        hFo50NPu0oGcwwqVXE/slSGxUZD+uEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-5nQCEx7aP8-wEnXbPbERZg-1; Wed, 03 Jun 2020 14:58:15 -0400
X-MC-Unique: 5nQCEx7aP8-wEnXbPbERZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA7C78018A5;
        Wed,  3 Jun 2020 18:58:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D32A78F17;
        Wed,  3 Jun 2020 18:58:14 +0000 (UTC)
Date:   Wed, 3 Jun 2020 14:58:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/30] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200603185812.GB13399@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-17-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-17-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:37AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we dirty an inode, we are going to have to write it disk at
> some point in the near future. This requires the inode cluster
> backing buffer to be present in memory. Unfortunately, under severe
> memory pressure we can reclaim the inode backing buffer while the
> inode is dirty in memory, resulting in stalling the AIL pushing
> because it has to do a read-modify-write cycle on the cluster
> buffer.
> 
> When we have no memory available, the read of the cluster buffer
> blocks the AIL pushing process, and this causes all sorts of issues
> for memory reclaim as it requires inode writeback to make forwards
> progress. Allocating a cluster buffer causes more memory pressure,
> and results in more cluster buffers to be reclaimed, resulting in
> more RMW cycles to be done in the AIL context and everything then
> backs up on AIL progress. Only the synchronous inode cluster
> writeback in the the inode reclaim code provides some level of
> forwards progress guarantees that prevent OOM-killer rampages in
> this situation.
> 
> Fix this by pinning the inode backing buffer to the inode log item
> when the inode is first dirtied (i.e. in xfs_trans_log_inode()).
> This may mean the first modification of an inode that has been held
> in cache for a long time may block on a cluster buffer read, but
> we can do that in transaction context and block safely until the
> buffer has been allocated and read.
> 
> Once we have the cluster buffer, the inode log item takes a
> reference to it, pinning it in memory, and attaches it to the log
> item for future reference. This means we can always grab the cluster
> buffer from the inode log item when we need it.
> 
> When the inode is finally cleaned and removed from the AIL, we can
> drop the reference the inode log item holds on the cluster buffer.
> Once all inodes on the cluster buffer are clean, the cluster buffer
> will be unpinned and it will be available for memory reclaim to
> reclaim again.
> 
> This avoids the issues with needing to do RMW cycles in the AIL
> pushing context, and hence allows complete non-blocking inode
> flushing to be performed by the AIL pushing context.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   |  3 +-
>  fs/xfs/libxfs/xfs_trans_inode.c | 53 +++++++++++++++++++++---
>  fs/xfs/xfs_buf_item.c           |  4 +-
>  fs/xfs/xfs_inode_item.c         | 73 +++++++++++++++++++++++++++------
>  fs/xfs/xfs_trans_ail.c          |  8 +++-
>  5 files changed, 117 insertions(+), 24 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index fe6c2e39be85d..1e7147b90725e 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
...
> @@ -132,6 +140,39 @@ xfs_trans_log_inode(
>  	spin_lock(&iip->ili_lock);
>  	iip->ili_fsync_fields |= flags;
>  
> +	if (!iip->ili_item.li_buf) {
> +		struct xfs_buf	*bp;
> +		int		error;
> +
> +		/*
> +		 * We hold the ILOCK here, so this inode is not going to be
> +		 * flushed while we are here. Further, because there is no
> +		 * buffer attached to the item, we know that there is no IO in
> +		 * progress, so nothing will clear the ili_fields while we read
> +		 * in the buffer. Hence we can safely drop the spin lock and
> +		 * read the buffer knowing that the state will not change from
> +		 * here.
> +		 */
> +		spin_unlock(&iip->ili_lock);
> +		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, NULL,
> +					&bp, 0);
> +		if (error) {
> +			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
> +			return;
> +		}

It's slightly unfortunate to shutdown on a read error, but I'd guess
many of these cases would have a dirty transaction already. Perhaps
something worth cleaning up later..?

> +
> +		/*
> +		 * We need an explicit buffer reference for the log item but
> +		 * don't want the buffer to remain attached to the transaction.
> +		 * Hold the buffer but release the transaction reference.
> +		 */
> +		xfs_buf_hold(bp);
> +		xfs_trans_brelse(tp, bp);
> +
> +		spin_lock(&iip->ili_lock);
> +		iip->ili_item.li_buf = bp;
> +	}
> +
>  	/*
>  	 * Always OR in the bits from the ili_last_fields field.  This is to
>  	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0ba75764a8dc5..0a7720b7a821a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -130,6 +130,8 @@ xfs_inode_item_size(
>  	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
>  	if (XFS_IFORK_Q(ip))
>  		xfs_inode_item_attr_fork_size(iip, nvecs, nbytes);
> +
> +	ASSERT(iip->ili_item.li_buf);

This assert seems unnecessary since we have one in ->iop_pin() just
below.

>  }
>  
>  STATIC void
> @@ -439,6 +441,7 @@ xfs_inode_item_pin(
>  	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(lip->li_buf);
>  
>  	trace_xfs_inode_pin(ip, _RET_IP_);
>  	atomic_inc(&ip->i_pincount);
> @@ -450,6 +453,12 @@ xfs_inode_item_pin(
>   * item which was previously pinned with a call to xfs_inode_item_pin().
>   *
>   * Also wake up anyone in xfs_iunpin_wait() if the count goes to 0.
> + *
> + * Note that unpin can race with inode cluster buffer freeing marking the buffer
> + * stale. In that case, flush completions are run from the buffer unpin call,
> + * which may happen before the inode is unpinned. If we lose the race, there
> + * will be no buffer attached to the log item, but the inode will be marked
> + * XFS_ISTALE.
>   */
>  STATIC void
>  xfs_inode_item_unpin(
> @@ -459,6 +468,7 @@ xfs_inode_item_unpin(
>  	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
>  
>  	trace_xfs_inode_unpin(ip, _RET_IP_);
> +	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
>  	if (atomic_dec_and_test(&ip->i_pincount))
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);

So I was wondering what happens to the attached buffer hold if shutdown
occurs after the inode is logged (i.e. transaction aborts or log write
fails). I see there's an assert for the buffer being cleaned up before
the ili is freed, so presumably that case is handled. It looks like we
unconditionally abort a flush on inode reclaim if the fs is shutdown,
regardless of whether the inode is dirty and we drop the buffer from
there..?

> @@ -629,10 +639,15 @@ xfs_inode_item_init(
>   */
>  void
>  xfs_inode_item_destroy(
> -	xfs_inode_t	*ip)
> +	struct xfs_inode	*ip)
>  {
> -	kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
> -	kmem_cache_free(xfs_ili_zone, ip->i_itemp);
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +
> +	ASSERT(iip->ili_item.li_buf == NULL);
> +
> +	ip->i_itemp = NULL;
> +	kmem_free(iip->ili_item.li_lv_shadow);
> +	kmem_cache_free(xfs_ili_zone, iip);
>  }
>  
>  
> @@ -647,6 +662,13 @@ xfs_inode_item_destroy(
>   * list for other inodes that will run this function. We remove them from the
>   * buffer list so we can process all the inode IO completions in one AIL lock
>   * traversal.
> + *
> + * Note: Now that we attach the log item to the buffer when we first log the
> + * inode in memory, we can have unflushed inodes on the buffer list here. These
> + * inodes will have a zero ili_last_fields, so skip over them here. We do
> + * this check -after- we've checked for stale inodes, because we're guaranteed
> + * to have XFS_ISTALE set in the case that dirty inodes are in the CIL and have
> + * not yet had their dirtying transactions committed to disk.
>   */
>  void
>  xfs_iflush_done(
> @@ -670,14 +692,16 @@ xfs_iflush_done(
>  			continue;
>  		}
>  
> +		if (!iip->ili_last_fields)
> +			continue;
> +

Hmm.. reading the comment above, do we actually attach the log item to
the buffer any earlier? ISTM we attach the buffer to the log item via a
hold, but that's different from getting the ili on ->b_li_list such that
it's available here. Hm?

>  		list_move_tail(&lip->li_bio_list, &tmp);
>  
>  		/* Do an unlocked check for needing the AIL lock. */
> -		if (lip->li_lsn == iip->ili_flush_lsn ||
> +		if (iip->ili_flush_lsn == lip->li_lsn ||
>  		    test_bit(XFS_LI_FAILED, &lip->li_flags))
>  			need_ail++;
>  	}
> -	ASSERT(list_empty(&bp->b_li_list));
>  
>  	/*
>  	 * We only want to pull the item from the AIL if it is actually there
...
> @@ -706,14 +730,29 @@ xfs_iflush_done(
>  	 * them is safely on disk.
>  	 */
>  	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
> +		bool	drop_buffer = false;
> +
>  		list_del_init(&lip->li_bio_list);
>  		iip = INODE_ITEM(lip);
>  
>  		spin_lock(&iip->ili_lock);
> +
> +		/*
> +		 * Remove the reference to the cluster buffer if the inode is
> +		 * clean in memory. Drop the buffer reference once we've dropped
> +		 * the locks we hold.
> +		 */
> +		ASSERT(iip->ili_item.li_buf == bp);
> +		if (!iip->ili_fields) {
> +			iip->ili_item.li_buf = NULL;
> +			drop_buffer = true;
> +		}
>  		iip->ili_last_fields = 0;
> +		iip->ili_flush_lsn = 0;

This also seems related to the behavior noted in the comment above.
Presumably we have to clear the flush lsn if clean inodes remain
attached to the buffer.. (but does that actually happen yet)?

Brian

>  		spin_unlock(&iip->ili_lock);
> -
>  		xfs_ifunlock(iip->ili_inode);
> +		if (drop_buffer)
> +			xfs_buf_rele(bp);
>  	}
>  }
>  
> @@ -725,12 +764,20 @@ xfs_iflush_done(
>   */
>  void
>  xfs_iflush_abort(
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	struct xfs_inode_log_item	*iip = ip->i_itemp;
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	struct xfs_buf		*bp = NULL;
>  
>  	if (iip) {
> +		/*
> +		 * Clear the failed bit before removing the item from the AIL so
> +		 * xfs_trans_ail_delete() doesn't try to clear and release the
> +		 * buffer attached to the log item before we are done with it.
> +		 */
> +		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
>  		xfs_trans_ail_delete(&iip->ili_item, 0);
> +
>  		/*
>  		 * Clear the inode logging fields so no more flushes are
>  		 * attempted.
> @@ -739,12 +786,14 @@ xfs_iflush_abort(
>  		iip->ili_last_fields = 0;
>  		iip->ili_fields = 0;
>  		iip->ili_fsync_fields = 0;
> +		iip->ili_flush_lsn = 0;
> +		bp = iip->ili_item.li_buf;
> +		iip->ili_item.li_buf = NULL;
>  		spin_unlock(&iip->ili_lock);
>  	}
> -	/*
> -	 * Release the inode's flush lock since we're done with it.
> -	 */
>  	xfs_ifunlock(ip);
> +	if (bp)
> +		xfs_buf_rele(bp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index ac33f6393f99c..c3be6e4401343 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -377,8 +377,12 @@ xfsaild_resubmit_item(
>  	}
>  
>  	/* protected by ail_lock */
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> -		xfs_clear_li_failed(lip);
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> +		if (bp->b_flags & _XBF_INODES)
> +			clear_bit(XFS_LI_FAILED, &lip->li_flags);
> +		else
> +			xfs_clear_li_failed(lip);
> +	}
>  
>  	xfs_buf_unlock(bp);
>  	return XFS_ITEM_SUCCESS;
> -- 
> 2.26.2.761.g0e0b3e54be
> 

