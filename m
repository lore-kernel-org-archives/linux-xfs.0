Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBENBh7I185887 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 17:11:43 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 863E3F57F6
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 15:12:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	VHMnLrtNuWiDCFnC for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 15:12:20 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10160065-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 09:42:19 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKK5R-0001JG-S6
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 10:12:17 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKK57-0003u6-J1
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 10:11:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Free buffer pages array unconditionally
Date: Tue, 15 Dec 2009 10:11:57 +1100
Message-Id: <1260832317-14977-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The code in xfs_free_buf() only attempts to free the b_pages array if the
buffer is a page cache backed or page allocated buffer. The extra log buffer
that is used when the log wraps uses pages that are allocated to a different
log buffer, but it still has a b_pages array allocated when those pages
are associated to with the extra buffer in xfs_buf_associate_memory.

Hence we need to always attempt to free the b_pages array when tearing
down a buffer, not just on buffers that are explicitly marked as page bearing
buffers. This fixes a leak detected by the kernel memory leak code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 4ddc973..529d6a6 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -318,6 +318,7 @@ _xfs_buf_free_pages(
 {
 	if (bp->b_pages != bp->b_page_array) {
 		kmem_free(bp->b_pages);
+		bp->b_pages = NULL;
 	}
 }
 
@@ -349,9 +350,8 @@ xfs_buf_free(
 				ASSERT(!PagePrivate(page));
 			page_cache_release(page);
 		}
-		_xfs_buf_free_pages(bp);
 	}
-
+	_xfs_buf_free_pages(bp);
 	xfs_buf_deallocate(bp);
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
