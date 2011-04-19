Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JJKFm7049684 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 14:20:15 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C00B28F8040
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 12:23:39 -0700 (PDT)
Subject: [PATCH] xfs: only SetPageUptodate if all buffers are uptodate
From: Ben Myers <bpm@sgi.com>
Date: Tue, 19 Apr 2011 06:40:28 -0500
Message-ID: <20110419114028.7844.10303.stgit@nfs3>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

xfs_vm_writepage and xfs_page_convert set a page uptodate if it is determined
that all of the buffer_heads attached to that page are uptodate.

Currently we use the flag variable 'uptodate'.  The flag is initially set = 1
and it is cleared if a !buffer_uptodate buffer is encountered.  In addition we
check that bh == head in order to ensure that all of the buffer_heads have been
checked.  However, it is possible to break out of the buffer_head loop early
having processed only the first buffer.  This leaves uptodate == 1 and bh ==
head, so the uptodate bit can be set on a page even if not all of the buffers
have been checked.  This can lead to data corruption on platforms with > 1
buffer per page.

SGI-PV: 1014173

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 52dbd14..c961f35 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -686,7 +686,7 @@ xfs_convert_page(
 	unsigned long		p_offset;
 	unsigned int		type;
 	int			len, page_dirty;
-	int			count = 0, done = 0, uptodate = 1;
+	int			count = 0, done = 0, uptodate = 0;
  	xfs_off_t		offset = page_offset(page);
 
 	if (page->index != tindex)
@@ -727,8 +727,8 @@ xfs_convert_page(
 	do {
 		if (offset >= end_offset)
 			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
+		if (buffer_uptodate(bh))
+			uptodate++;
 		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
 			done = 1;
 			continue;
@@ -761,7 +761,7 @@ xfs_convert_page(
 		}
 	} while (offset += len, (bh = bh->b_this_page) != head);
 
-	if (uptodate && bh == head)
+	if (uptodate == (PAGE_CACHE_SIZE / len))
 		SetPageUptodate(page);
 
 	if (count) {
@@ -915,7 +915,7 @@ xfs_vm_writepage(
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
 	ssize_t			len;
-	int			err, imap_valid = 0, uptodate = 1;
+	int			err, imap_valid = 0, uptodate = 0;
 	int			count = 0;
 	int			nonblocking = 0;
 
@@ -978,8 +978,8 @@ xfs_vm_writepage(
 
 		if (offset >= end_offset)
 			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
+		if (buffer_uptodate(bh))
+			uptodate++;
 
 		/*
 		 * set_page_dirty dirties all buffers in a page, independent
@@ -1047,7 +1047,7 @@ xfs_vm_writepage(
 
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
-	if (uptodate && bh == head)
+	if (uptodate == (PAGE_CACHE_SIZE / len))
 		SetPageUptodate(page);
 
 	xfs_start_page_writeback(page, 1, count);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
