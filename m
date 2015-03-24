Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 444117F50
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:51:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F04E304032
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:51:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7WasVupsolokMhZw for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:51:16 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: add DAX block zeroing support
Date: Tue, 24 Mar 2015 21:51:02 +1100
Message-Id: <1427194266-2885-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-1-git-send-email-david@fromorbit.com>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Add initial support for DAX block zeroing operations to XFS. DAX
cannot use buffered IO through the page cache for zeroing, nor do we
need to issue IO for uncached block zeroing. In both cases, we can
simply call out to the dax block zeroing function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 23 +++++++++++++++++++----
 fs/xfs/xfs_file.c      | 28 +++++++++++++++++-----------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1bd5393..d1fe432 100644
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
+						    xfs_get_blocks_dax);
+			if (error)
+				return error;
 			continue;
+		}
 
 		error = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a4c882e..94713c2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -97,7 +97,8 @@ xfs_iozero(
 {
 	struct page		*page;
 	struct address_space	*mapping;
-	int			status;
+	int			status = 0;
+
 
 	mapping = VFS_I(ip)->i_mapping;
 	do {
@@ -109,20 +110,25 @@ xfs_iozero(
 		if (bytes > count)
 			bytes = count;
 
-		status = pagecache_write_begin(NULL, mapping, pos, bytes,
-					AOP_FLAG_UNINTERRUPTIBLE,
-					&page, &fsdata);
-		if (status)
-			break;
+		if (IS_DAX(VFS_I(ip)))
+			dax_zero_page_range(VFS_I(ip), pos, bytes,
+						   xfs_get_blocks_dax);
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
 
 	return (-status);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
