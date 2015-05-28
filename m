Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F1DD7F67
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F41B7304051
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:11 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MOCeQmlSMJE5Z62Y for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006cs-AN
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024a-9X
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: add DAX block zeroing support
Date: Fri, 29 May 2015 09:45:52 +1000
Message-Id: <1432856755-7859-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1432856755-7859-1-git-send-email-david@fromorbit.com>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add initial support for DAX block zeroing operations to XFS. DAX
cannot use buffered IO through the page cache for zeroing, nor do we
need to issue IO for uncached block zeroing. In both cases, we can
simply call out to the dax block zeroing function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 23 +++++++++++++++++++----
 fs/xfs/xfs_file.c      | 43 +++++++++++++++++++++++++------------------
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a52bbd3..4a29655 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1133,14 +1133,29 @@ xfs_zero_remaining_bytes(
 			break;
 		ASSERT(imap.br_blockcount >= 1);
 		ASSERT(imap.br_startoff == offset_fsb);
+		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+
+		if (imap.br_startblock == HOLESTARTBLOCK ||
+		    imap.br_state == XFS_EXT_UNWRITTEN) {
+			/* skip the entire extent */
+			lastoffset = XFS_FSB_TO_B(mp, imap.br_startoff +
+						      imap.br_blockcount) - 1;
+			continue;
+		}
+
 		lastoffset = XFS_FSB_TO_B(mp, imap.br_startoff + 1) - 1;
 		if (lastoffset > endoff)
 			lastoffset = endoff;
-		if (imap.br_startblock == HOLESTARTBLOCK)
-			continue;
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-		if (imap.br_state == XFS_EXT_UNWRITTEN)
+
+		/* DAX can just zero the backing device directly */
+		if (IS_DAX(VFS_I(ip))) {
+			error = dax_zero_page_range(VFS_I(ip), offset,
+						    lastoffset - offset + 1,
+						    xfs_get_blocks_direct);
+			if (error)
+				return error;
 			continue;
+		}
 
 		error = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c2af282..fd94460 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -79,14 +79,15 @@ xfs_rw_ilock_demote(
 }
 
 /*
- *	xfs_iozero
+ * xfs_iozero clears the specified range supplied via the page cache (except in
+ * the DAX case). Writes through the page cache will allocate blocks over holes,
+ * though the callers usually map the holes first and avoid them. If a block is
+ * not completely zeroed, then it will be read from disk before being partially
+ * zeroed.
  *
- *	xfs_iozero clears the specified range of buffer supplied,
- *	and marks all the affected blocks as valid and modified.  If
- *	an affected block is not allocated, it will be allocated.  If
- *	an affected block is not completely overwritten, and is not
- *	valid before the operation, it will be read from disk before
- *	being partially zeroed.
+ * In the DAX case, we can just directly write to the underlying pages. This
+ * will not allocate blocks, but will avoid holes and unwritten extents and so
+ * not do unnecessary work.
  */
 int
 xfs_iozero(
@@ -96,7 +97,8 @@ xfs_iozero(
 {
 	struct page		*page;
 	struct address_space	*mapping;
-	int			status;
+	int			status = 0;
+
 
 	mapping = VFS_I(ip)->i_mapping;
 	do {
@@ -108,20 +110,25 @@ xfs_iozero(
 		if (bytes > count)
 			bytes = count;
 
-		status = pagecache_write_begin(NULL, mapping, pos, bytes,
-					AOP_FLAG_UNINTERRUPTIBLE,
-					&page, &fsdata);
-		if (status)
-			break;
+		if (IS_DAX(VFS_I(ip)))
+			dax_zero_page_range(VFS_I(ip), pos, bytes,
+					    xfs_get_blocks_direct);
+		else {
+			status = pagecache_write_begin(NULL, mapping, pos, bytes,
+						AOP_FLAG_UNINTERRUPTIBLE,
+						&page, &fsdata);
+			if (status)
+				break;
 
-		zero_user(page, offset, bytes);
+			zero_user(page, offset, bytes);
 
-		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
-					page, fsdata);
-		WARN_ON(status <= 0); /* can't return less than zero! */
+			status = pagecache_write_end(NULL, mapping, pos, bytes,
+						bytes, page, fsdata);
+			WARN_ON(status <= 0); /* can't return less than zero! */
+			status = 0;
+		}
 		pos += bytes;
 		count -= bytes;
-		status = 0;
 	} while (count);
 
 	return status;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
