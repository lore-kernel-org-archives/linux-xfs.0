Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Sep 2008 01:27:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m8B8RrBg023391
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 01:27:54 -0700
Message-ID: <48C8D8CD.7050508@sgi.com>
Date: Thu, 11 Sep 2008 18:37:33 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Re-dirty pages on I/O error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
we throw away the dirty page without converting the delayed allocation.  This
leaves delayed allocations that can never be removed and confuses code that
expects a flush of the file to clear them.  We need to re-dirty the page on
error so we can try again later or report that the flush failed.

--- a/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 16:32:11.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 15:44:09.000000000 +1000
@@ -1147,16 +1147,6 @@ error:
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
 
@@ -1216,8 +1206,11 @@ xfs_vm_writepage(
 	 * then mark the page dirty again and leave the page
 	 * as is.
 	 */
-	if (current_test_flags(PF_FSTRANS) && need_trans)
-		goto out_fail;
+	if (current_test_flags(PF_FSTRANS) && need_trans) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return -EAGAIN;
+	}
 
 	/*
 	 * Delay hooking up buffer heads until we have
@@ -1231,20 +1224,14 @@ xfs_vm_writepage(
 	 * to real space and flush out to disk.
 	 */
 	error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
-	if (error == -EAGAIN)
-		goto out_fail;
-	if (unlikely(error < 0))
-		goto out_unlock;
 
-	return 0;
+	if (error < 0) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return error;
+	}
 
-out_fail:
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
 	return 0;
-out_unlock:
-	unlock_page(page);
-	return error;
 }
 
 STATIC int
