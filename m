Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5A2C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 11:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590B22071C
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 11:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s8dqT81Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgEWLbf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 07:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgEWLbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 07:31:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B6C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 04:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EQH4av4ITJQsMa79u/rT6gtEETlzJ1WPV+nxtg+CByY=; b=s8dqT81QtA0qGR0VYie+uYUuZy
        b8Wuk6/88wJsFuCZkO18uuVAa2vkBtQz2zNY6DTZ4Ux6l38hYQcxwwY4plFH/vvauQf7903Ac/F/b
        ib1i55yY0wMW9VvgBk9Tc/B4MyYnxQBN2XMar00z7UU7ZA3dmmhU9KgQujGEzD2IClDEunmNOzigW
        6n+g97Zmmju+MM4KBWCyxR70bth7jevCTi8ALnzqGnVcJy/F6a1mrjYp33Mix0oT9krK7C/hAcGl+
        pGsIulP5dwcjftuBNiULn332/9AS+6bclovfReeRRzG8RlbQrWNP4cRen+TwJeXTu77rpLFXssyD+
        hgz8N2rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcSNH-0003an-Ac; Sat, 23 May 2020 11:31:31 +0000
Date:   Sat, 23 May 2020 04:31:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200523113131.GA1421@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-23-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:27PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have all the dirty inodes attached to the cluster
> buffer, we don't actually have to do radix tree lookups to find
> them. Sure, the radix tree is efficient, but walking a linked list
> of just the dirty inodes attached to the buffer is much better.
> 
> We are also no longer dependent on having a locked inode passed into
> the function to determine where to start the lookup. This means we
> can drop it from the function call and treat all inodes the same.
> 
> We also make xfs_iflush_cluster skip inodes marked with
> XFS_IRECLAIM. This we avoid races with inodes that reclaim is
> actively referencing or are being re-initialised by inode lookup. If
> they are actually dirty, they'll get written by a future cluster
> flush....
> 
> We also add a shutdown check after obtaining the flush lock so that
> we catch inodes that are dirty in memory and may have inconsistent
> state due to the shutdown in progress. We abort these inodes
> directly and so they remove themselves directly from the buffer list
> and the AIL rather than having to wait for the buffer to be failed
> and callbacks run to be processed correctly.

I suspect we should just kill off xfs_iflush_cluster with this, as it
is best split between xfs_iflush and xfs_inode_item_push.  POC patch
below, but as part of that I noticed some really odd error handling,
which I'll bring up separately.

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6f873eca8c916..8784e70626403 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1102,12 +1102,12 @@ xfs_reclaim_inode(
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
 	 * to be reclaimed with an invalid inode number when in the free state.
-	 * We do this as early as possible under the ILOCK so that
-	 * xfs_iflush_cluster() and xfs_ifree_cluster() can be guaranteed to
-	 * detect races with us here. By doing this, we guarantee that once
-	 * xfs_iflush_cluster() or xfs_ifree_cluster() has locked XFS_ILOCK that
-	 * it will see either a valid inode that will serialise correctly, or it
-	 * will see an invalid inode that it can skip.
+	 * We do this as early as possible under the ILOCK so that xfs_iflush()
+	 * and xfs_ifree_cluster() can be guaranteed to detect races with us
+	 * here. By doing this, we guarantee that once xfs_iflush() or
+	 * xfs_ifree_cluster() has locked XFS_ILOCK that it will see either a
+	 * valid inode that will serialise correctly, or it will see an invalid
+	 * inode that it can skip.
 	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5bbdb0c5ed172..8b0197a386a0f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3431,19 +3431,70 @@ xfs_rename(
 
 int
 xfs_iflush(
-	struct xfs_inode	*ip,
+	struct xfs_inode_log_item *iip,
 	struct xfs_buf		*bp)
 {
-	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_dinode	*dip;
+	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error;
+	struct xfs_dinode	*dip;
+	int			error = 0;
+
+	/*
+	 * Quick and dirty check to avoid locks if possible.
+	 */
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
+		return 0;
+	if (xfs_ipincount(ip))
+		return 0;
+
+	/*
+	 * The inode is still attached to the buffer, which means it is dirty
+	 * but reclaim might try to grab it.  Check carefully for that, and grab
+	 * the ilock while still holding the i_flags_lock to guarantee reclaim
+	 * will not be able to reclaim this inode once we drop the i_flags_lock.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
+		goto out_unlock_flags_lock;
+
+	/*
+	 * ILOCK will pin the inode against reclaim and prevent concurrent
+	 * transactions modifying the inode while we are flushing the inode.
+	 */
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
+		goto out_unlock_flags_lock;
+	spin_unlock(&ip->i_flags_lock);
+
+	/*
+	 * Skip inodes that are already flush locked as they have already been
+	 * written to the buffer.
+	 */
+	if (!xfs_iflock_nowait(ip))
+		goto out_unlock_ilock;
+
+	/*
+	 * If we are shut down, unpin and abort the inode now as there is no
+	 * point in flushing it to the buffer just to get an IO completion to
+	 * abort the buffer and remove it from the AIL.
+	 */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		xfs_iunpin_wait(ip);
+		/* xfs_iflush_abort() drops the flush lock */
+		xfs_iflush_abort(ip);
+		error = -EIO;
+		goto out_unlock_ilock;
+	}
+
+	/* don't block waiting on a log force to unpin dirty inodes */
+	if (xfs_ipincount(ip) || xfs_inode_clean(ip)) {
+		xfs_ifunlock(ip);
+		goto out_unlock_ilock;
+	}
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
-	ASSERT(iip != NULL && iip->ili_fields != 0);
+	ASSERT(iip->ili_fields != 0);
 	ASSERT(iip->ili_item.li_buf == bp);
 
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -3574,122 +3625,13 @@ xfs_iflush(
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
-	return error;
-}
-
-/*
- * Non-blocking flush of dirty inode metadata into the backing buffer.
- *
- * The caller must have a reference to the inode and hold the cluster buffer
- * locked. The function will walk across all the inodes on the cluster buffer it
- * can find and lock without blocking, and flush them to the cluster buffer.
- *
- * On success, the caller must write out the buffer returned in *bp and
- * release it. On failure, the filesystem will be shut down, the buffer will
- * have been unlocked and released, and EFSCORRUPTED will be returned.
- */
-int
-xfs_iflush_cluster(
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_log_item	*lip, *n;
-	struct xfs_inode	*ip;
-	struct xfs_inode_log_item *iip;
-	int			clcount = 0;
-	int			error = 0;
 
-	/*
-	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
-	 * can remove itself from the list.
-	 */
-	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
-		iip = (struct xfs_inode_log_item *)lip;
-		ip = iip->ili_inode;
-
-		/*
-		 * Quick and dirty check to avoid locks if possible.
-		 */
-		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
-			continue;
-		if (xfs_ipincount(ip))
-			continue;
-
-		/*
-		 * The inode is still attached to the buffer, which means it is
-		 * dirty but reclaim might try to grab it. Check carefully for
-		 * that, and grab the ilock while still holding the i_flags_lock
-		 * to guarantee reclaim will not be able to reclaim this inode
-		 * once we drop the i_flags_lock.
-		 */
-		spin_lock(&ip->i_flags_lock);
-		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
-		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK)) {
-			spin_unlock(&ip->i_flags_lock);
-			continue;
-		}
-
-		/*
-		 * ILOCK will pin the inode against reclaim and prevent
-		 * concurrent transactions modifying the inode while we are
-		 * flushing the inode.
-		 */
-		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-			spin_unlock(&ip->i_flags_lock);
-			continue;
-		}
-		spin_unlock(&ip->i_flags_lock);
-
-		/*
-		 * Skip inodes that are already flush locked as they have
-		 * already been written to the buffer.
-		 */
-		if (!xfs_iflock_nowait(ip)) {
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			continue;
-		}
-
-		/*
-		 * If we are shut down, unpin and abort the inode now as there
-		 * is no point in flushing it to the buffer just to get an IO
-		 * completion to abort the buffer and remove it from the AIL.
-		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_iunpin_wait(ip);
-			/* xfs_iflush_abort() drops the flush lock */
-			xfs_iflush_abort(ip);
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			error = EIO;
-			continue;
-		}
-
-		/* don't block waiting on a log force to unpin dirty inodes */
-		if (xfs_ipincount(ip)) {
-			xfs_ifunlock(ip);
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			continue;
-		}
-
-		if (!xfs_inode_clean(ip))
-			error = xfs_iflush(ip, bp);
-		else
-			xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		if (error)
-			break;
-		clcount++;
-	}
-
-	if (clcount) {
-		XFS_STATS_INC(mp, xs_icluster_flushcnt);
-		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
-	}
+out_unlock_ilock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
 
-	if (error) {
-		bp->b_flags |= XBF_ASYNC;
-		xfs_buf_ioend_fail(bp);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-	}
+out_unlock_flags_lock:
+	spin_unlock(&ip->i_flags_lock);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b93cf9076df8a..870e6768e119e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -427,7 +427,7 @@ int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-int		xfs_iflush_cluster(struct xfs_buf *);
+int		xfs_iflush(struct xfs_inode_log_item *iip, struct xfs_buf *bp);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4dd4f45dcc46e..b82d7f3628745 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -501,8 +501,10 @@ xfs_inode_item_push(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_log_item	*l, *n;
 	uint			rval = XFS_ITEM_SUCCESS;
-	int			error;
+	int			clcount = 0;
 
 	ASSERT(iip->ili_item.li_buf);
 
@@ -530,17 +532,34 @@ xfs_inode_item_push(
 	 * for IO until we queue it for delwri submission.
 	 */
 	xfs_buf_hold(bp);
-	error = xfs_iflush_cluster(bp);
-	if (!error) {
-		if (!xfs_buf_delwri_queue(bp, buffer_list)) {
-			ASSERT(0);
-			rval = XFS_ITEM_FLUSHING;
+
+	/*
+	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
+	 * can remove itself from the list.
+	 */
+	list_for_each_entry_safe(l, n, &bp->b_li_list, li_bio_list) {
+		if (xfs_iflush(INODE_ITEM(l), bp)) {
+			bp->b_flags |= XBF_ASYNC;
+			xfs_buf_ioend_fail(bp);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			rval = XFS_ITEM_LOCKED;
+			goto out_unlock;
 		}
-		xfs_buf_relse(bp);
-	} else {
-		rval = XFS_ITEM_LOCKED;
+		clcount++;
+	}
+
+	if (clcount) {
+		XFS_STATS_INC(mp, xs_icluster_flushcnt);
+		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
+	}
+
+	if (!xfs_buf_delwri_queue(bp, buffer_list)) {
+		ASSERT(0);
+		rval = XFS_ITEM_FLUSHING;
 	}
+	xfs_buf_relse(bp);
 
+out_unlock:
 	spin_lock(&lip->li_ailp->ail_lock);
 	return rval;
 }
