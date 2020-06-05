Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789E8C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 18:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D99B2074B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 18:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbJ2iBlU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFES1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 14:27:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47601 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgFES13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 14:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591381647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4BQF3GbugZwx32uFQgelyNDBhSwJBR8YgEPBG38K04=;
        b=DbJ2iBlU6YAZIX0XlJDSZsyCegWsZPWd8M3HnQ8PaASsI0MX+fKlY/ebZh4vTDxhzjLEle
        mEwsWS588eFR0zU8UuBCI0mt+Hda9Qerdi2Bjxef4wM23U7G0caB0OsUUx3F9Gys6UFAta
        279t/sShHMNnZTXn1/y4+MPHmxvvHEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-tWjlvX9qOmqsvmclBds0RA-1; Fri, 05 Jun 2020 14:27:25 -0400
X-MC-Unique: tWjlvX9qOmqsvmclBds0RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CF01835B90;
        Fri,  5 Jun 2020 18:27:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB993108BA;
        Fri,  5 Jun 2020 18:27:23 +0000 (UTC)
Date:   Fri, 5 Jun 2020 14:27:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/30] xfs: rework stale inodes in xfs_ifree_cluster
Message-ID: <20200605182722.GH23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-25-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:46:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Once we have inodes pinning the cluster buffer and attached whenever
> they are dirty, we no longer have a guarantee that the items are
> flush locked when we lock the cluster buffer. Hence we cannot just
> walk the buffer log item list and modify the attached inodes.
> 
> If the inode is not flush locked, we have to ILOCK it first and then
> flush lock it to do all the prerequisite checks needed to avoid
> races with other code. This is already handled by
> xfs_ifree_get_one_inode(), so rework the inode iteration loop and
> function to update all inodes in cache whether they are attached to
> the buffer or not.
> 
> Note: we also remove the copying of the log item lsn to the
> ili_flush_lsn as xfs_iflush_done() now uses the XFS_ISTALE flag to
> trigger aborts and so flush lsn matching is not needed in IO
> completion for processing freed inodes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 158 ++++++++++++++++++---------------------------
>  1 file changed, 62 insertions(+), 96 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 272b54cf97000..fb4c614c64fda 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
...
> @@ -2559,43 +2563,53 @@ xfs_ifree_get_one_inode(
>  	 */
>  	if (ip != free_ip) {
>  		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> +			spin_unlock(&ip->i_flags_lock);
>  			rcu_read_unlock();
>  			delay(1);
>  			goto retry;
>  		}
> -
> -		/*
> -		 * Check the inode number again in case we're racing with
> -		 * freeing in xfs_reclaim_inode().  See the comments in that
> -		 * function for more information as to why the initial check is
> -		 * not sufficient.
> -		 */
> -		if (ip->i_ino != inum) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -			goto out_rcu_unlock;
> -		}

Why is the recheck under ILOCK_EXCL no longer necessary? It looks like
reclaim decides whether to proceed or not under the ilock and doesn't
acquire the spinlock until it decides to reclaim. Hm?

>  	}
> +	ip->i_flags |= XFS_ISTALE;
> +	spin_unlock(&ip->i_flags_lock);
>  	rcu_read_unlock();
>  
> -	xfs_iflock(ip);
> -	xfs_iflags_set(ip, XFS_ISTALE);
> +	/*
> +	 * If we can't get the flush lock, the inode is already attached.  All
> +	 * we needed to do here is mark the inode stale so buffer IO completion
> +	 * will remove it from the AIL.
> +	 */

To make sure I'm following this correctly, we can assume the inode is
attached based on an iflock_nowait() failure because we hold the ilock,
right? IOW, any other task doing a similar iflock check would have to do
so under ilock and release the flush lock first if the inode didn't end
up flushed, for whatever reason.

> +	iip = ip->i_itemp;
> +	if (!xfs_iflock_nowait(ip)) {
> +		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
> +		ASSERT(iip->ili_last_fields);
> +		goto out_iunlock;
> +	}
> +	ASSERT(!iip || list_empty(&iip->ili_item.li_bio_list));
>  
>  	/*
> -	 * We don't need to attach clean inodes or those only with unlogged
> -	 * changes (which we throw away, anyway).
> +	 * Clean inodes can be released immediately.  Everything else has to go
> +	 * through xfs_iflush_abort() on journal commit as the flock
> +	 * synchronises removal of the inode from the cluster buffer against
> +	 * inode reclaim.
>  	 */
> -	if (!ip->i_itemp || xfs_inode_clean(ip)) {
> -		ASSERT(ip != free_ip);
> +	if (xfs_inode_clean(ip)) {
>  		xfs_ifunlock(ip);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		goto out_no_inode;
> +		goto out_iunlock;
>  	}
> -	return ip;
>  
> -out_rcu_unlock:
> -	rcu_read_unlock();
> -out_no_inode:
> -	return NULL;
> +	/* we have a dirty inode in memory that has not yet been flushed. */
> +	ASSERT(iip->ili_fields);
> +	spin_lock(&iip->ili_lock);
> +	iip->ili_last_fields = iip->ili_fields;
> +	iip->ili_fields = 0;
> +	iip->ili_fsync_fields = 0;
> +	spin_unlock(&iip->ili_lock);
> +	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
> +	ASSERT(iip->ili_last_fields);

We already asserted ->ili_fields and assigned ->ili_fields to
->ili_last_fields, so this assert seems spurious.

Brian

> +
> +out_iunlock:
> +	if (ip != free_ip)
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  }
>  
>  /*
> @@ -2605,26 +2619,20 @@ xfs_ifree_get_one_inode(
>   */
>  STATIC int
>  xfs_ifree_cluster(
> -	xfs_inode_t		*free_ip,
> -	xfs_trans_t		*tp,
> +	struct xfs_inode	*free_ip,
> +	struct xfs_trans	*tp,
>  	struct xfs_icluster	*xic)
>  {
> -	xfs_mount_t		*mp = free_ip->i_mount;
> +	struct xfs_mount	*mp = free_ip->i_mount;
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	struct xfs_buf		*bp;
> +	xfs_daddr_t		blkno;
> +	xfs_ino_t		inum = xic->first_ino;
>  	int			nbufs;
>  	int			i, j;
>  	int			ioffset;
> -	xfs_daddr_t		blkno;
> -	xfs_buf_t		*bp;
> -	xfs_inode_t		*ip;
> -	struct xfs_inode_log_item *iip;
> -	struct xfs_log_item	*lip;
> -	struct xfs_perag	*pag;
> -	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	xfs_ino_t		inum;
>  	int			error;
>  
> -	inum = xic->first_ino;
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
>  	nbufs = igeo->ialloc_blks / igeo->blocks_per_cluster;
>  
>  	for (j = 0; j < nbufs; j++, inum += igeo->inodes_per_cluster) {
> @@ -2668,59 +2676,16 @@ xfs_ifree_cluster(
>  		bp->b_ops = &xfs_inode_buf_ops;
>  
>  		/*
> -		 * Walk the inodes already attached to the buffer and mark them
> -		 * stale. These will all have the flush locks held, so an
> -		 * in-memory inode walk can't lock them. By marking them all
> -		 * stale first, we will not attempt to lock them in the loop
> -		 * below as the XFS_ISTALE flag will be set.
> -		 */
> -		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> -			if (lip->li_type == XFS_LI_INODE) {
> -				iip = (struct xfs_inode_log_item *)lip;
> -				xfs_trans_ail_copy_lsn(mp->m_ail,
> -							&iip->ili_flush_lsn,
> -							&iip->ili_item.li_lsn);
> -				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
> -			}
> -		}
> -
> -
> -		/*
> -		 * For each inode in memory attempt to add it to the inode
> -		 * buffer and set it up for being staled on buffer IO
> -		 * completion.  This is safe as we've locked out tail pushing
> -		 * and flushing by locking the buffer.
> -		 *
> -		 * We have already marked every inode that was part of a
> -		 * transaction stale above, which means there is no point in
> -		 * even trying to lock them.
> +		 * Now we need to set all the cached clean inodes as XFS_ISTALE,
> +		 * too. This requires lookups, and will skip inodes that we've
> +		 * already marked XFS_ISTALE.
>  		 */
> -		for (i = 0; i < igeo->inodes_per_cluster; i++) {
> -			ip = xfs_ifree_get_one_inode(pag, free_ip, inum + i);
> -			if (!ip)
> -				continue;
> -
> -			iip = ip->i_itemp;
> -			spin_lock(&iip->ili_lock);
> -			iip->ili_last_fields = iip->ili_fields;
> -			iip->ili_fields = 0;
> -			iip->ili_fsync_fields = 0;
> -			spin_unlock(&iip->ili_lock);
> -			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
> -						&iip->ili_item.li_lsn);
> -
> -			list_add_tail(&iip->ili_item.li_bio_list,
> -						&bp->b_li_list);
> -
> -			if (ip != free_ip)
> -				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		}
> +		for (i = 0; i < igeo->inodes_per_cluster; i++)
> +			xfs_ifree_mark_inode_stale(bp, free_ip, inum + i);
>  
>  		xfs_trans_stale_inode_buf(tp, bp);
>  		xfs_trans_binval(tp, bp);
>  	}
> -
> -	xfs_perag_put(pag);
>  	return 0;
>  }
>  
> @@ -3845,6 +3810,7 @@ xfs_iflush_int(
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
>  	spin_unlock(&iip->ili_lock);
> +	ASSERT(iip->ili_last_fields);
>  
>  	/*
>  	 * Store the current LSN of the inode so that we can tell whether the
> -- 
> 2.26.2.761.g0e0b3e54be
> 

