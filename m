Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A2n0Zs023102 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 20:49:00 -0600
Received: from [134.14.52.238] (unknown [134.14.52.238])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E2F5AC30D
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 18:48:20 -0800 (PST)
Message-ID: <4990EAF9.9010607@sgi.com>
Date: Tue, 10 Feb 2009 13:48:25 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Prevent lookup from finding bad buffers
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

There's a bug in _xfs_buf_find() that will cause it to return buffers
that failed to be initialised.

If a thread has a buffer locked and is waiting for I/O to initialise
it and another thread wants the same buffer the second thread will
wait on the buffer lock in _xfs_buf_find().  If the initial thread
gets an I/O error it marks the buffer in error and releases the
buffer lock.  The second thread gets the buffer lock, assumes the
buffer has been successfully initialised, and then tries to use it.

Some callers of xfs_buf_get_flags() will check for B_DONE, and if
it's not set then re-issue the I/O, bust most callers assume the
buffer and it's contents are good and then use the uninitialised
data.

The solution I've come up with is if we lookup a buffer and find
it's got b_error set or has been marked stale then unhash it from
the buffer hashtable and retry the lookup.  Also if we fail to setup
the buffer correctly in xfs_buf_get_flags() then mark the buffer in
error and unhash it.  If the buffer is marked stale then in
xfs_buf_free() inform the page cache that the contents of the pages
are no longer valid.

Index: xfs-patch/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs-patch.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ xfs-patch/fs/xfs/linux-2.6/xfs_buf.c
@@ -271,6 +271,8 @@ xfs_buf_free(

  			if (bp->b_flags & _XBF_PAGE_CACHE)
  				ASSERT(!PagePrivate(page));
+			if (XFS_BUF_ISSTALE(bp))
+				ClearPageUptodate(page);
  			page_cache_release(page);
  		}
  		_xfs_buf_free_pages(bp);
@@ -430,7 +432,7 @@ _xfs_buf_find(
  	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));

  	hash = &btp->bt_hash[hash_long((unsigned long)ioff, btp->bt_hashshift)];
-
+retry:
  	spin_lock(&hash->bh_lock);

  	list_for_each_entry_safe(bp, n, &hash->bh_list, b_hash_list) {
@@ -489,9 +491,12 @@ found:
  		XB_SET_OWNER(bp);
  	}

-	if (bp->b_flags & XBF_STALE) {
+	if (bp->b_error || XFS_BUF_ISSTALE(bp)) {
  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= XBF_MAPPED;
+		xfs_buf_unhash(bp);
+		xfs_buf_unlock(bp);
+		xfs_buf_rele(bp);
+		goto retry;
  	}
  	XB_TRACE(bp, "got_lock", 0);
  	XFS_STATS_INC(xb_get_locked);
@@ -553,6 +558,10 @@ xfs_buf_get_flags(
  	return bp;

   no_buffer:
+	if (error) {
+		xfs_buf_ioerror(bp, -error);
+		xfs_buf_unhash(bp);
+	}
  	if (flags & (XBF_LOCK | XBF_TRYLOCK))
  		xfs_buf_unlock(bp);
  	xfs_buf_rele(bp);
@@ -771,6 +780,20 @@ xfs_buf_hold(
  	XB_TRACE(bp, "hold", 0);
  }

+void
+xfs_buf_unhash(
+	xfs_buf_t		*bp)
+{
+	xfs_bufhash_t		*hash = bp->b_hash;
+
+	if (hash) {
+		spin_lock(&hash->bh_lock);
+		bp->b_hash = 0;
+		list_del_init(&bp->b_hash_list);
+		spin_unlock(&hash->bh_lock);
+	}
+}
+
  /*
   *	Releases a hold on the specified buffer.  If the
   *	the hold count is 1, calls xfs_buf_free.
Index: xfs-patch/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs-patch.orig/fs/xfs/linux-2.6/xfs_buf.h
+++ xfs-patch/fs/xfs/linux-2.6/xfs_buf.h
@@ -206,6 +206,7 @@ extern void xfs_buf_readahead(xfs_buftar
  /* Releasing Buffers */
  extern void xfs_buf_free(xfs_buf_t *);
  extern void xfs_buf_rele(xfs_buf_t *);
+extern void xfs_buf_unhash(xfs_buf_t *);

  /* Locking and Unlocking Buffers */
  extern int xfs_buf_cond_lock(xfs_buf_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
