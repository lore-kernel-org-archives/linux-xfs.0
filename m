Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A1nq9U020193 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 19:49:53 -0600
Received: from [134.14.52.238] (unknown [134.14.52.238])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C05CAAC07C
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 17:49:12 -0800 (PST)
Message-ID: <4990DCF6.5000900@sgi.com>
Date: Tue, 10 Feb 2009 12:48:38 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Re-dirty pages on I/O error
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

[This patch seems to have slipped through the proverbial crack.]

If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
we throw away the dirty page without converting the delayed allocation.  This
leaves delayed allocations that can never be removed and confuses code that
expects a flush of the file to clear them.  We need to re-dirty the page on
error so we can try again later or report that the flush failed.


Index: xfs-fixes/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs-fixes.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ xfs-fixes/fs/xfs/linux-2.6/xfs_aops.c
@@ -1185,16 +1185,6 @@ error:
  	if (iohead)
  		xfs_cancel_ioend(iohead);

-	/*
-	 * If it's delalloc and we have nowhere to put it,
-	 * throw it away, unless the lower layers told
-	 * us to try again.
-	 */
-	if (err != -EAGAIN) {
-		if (!unmapped)
-			block_invalidatepage(page, 0);
-		ClearPageUptodate(page);
-	}
  	return err;
  }

@@ -1223,7 +1213,7 @@ xfs_vm_writepage(
  	struct page		*page,
  	struct writeback_control *wbc)
  {
-	int			error;
+	int			error = 0;
  	int			need_trans;
  	int			delalloc, unmapped, unwritten;
  	struct inode		*inode = page->mapping->host;
@@ -1269,19 +1259,16 @@ xfs_vm_writepage(
  	 * to real space and flush out to disk.
  	 */
  	error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
-	if (error == -EAGAIN)
-		goto out_fail;
  	if (unlikely(error < 0))
-		goto out_unlock;
+		goto out_fail;

  	return 0;

  out_fail:
  	redirty_page_for_writepage(wbc, page);
  	unlock_page(page);
-	return 0;
-out_unlock:
-	unlock_page(page);
+	if (error == -EAGAIN)
+		error = 0;
  	return error;
  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
