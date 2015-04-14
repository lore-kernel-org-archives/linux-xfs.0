Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 544507F3F
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 02:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3F4DAC001
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 00:26:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dDnQjPlNQ0oH4qTW for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 00:26:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YhvFE-0000qa-Sy
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YhvFE-0000VZ-SE
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: move DIO mapping size calculation
Date: Tue, 14 Apr 2015 17:26:45 +1000
Message-Id: <1428996411-1507-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1428996411-1507-1-git-send-email-david@fromorbit.com>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
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

The mapping size calculation is done last in __xfs_get_blocks(), but
we are going to need the actual mapping size we will use to map the
direct IO correctly in xfs_map_direct(). Factor out the calculation
for code clarity, and move the call to be the first operation in
mapping the extent to the returned buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 79 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5f7ddd5..8f63520 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1249,6 +1249,47 @@ xfs_map_direct(
 	}
 }
 
+
+/*
+ * If this is O_DIRECT or the mpage code calling tell them how large the mapping
+ * is, so that we can avoid repeated get_blocks calls.
+ *
+ * If the mapping spans EOF, then we have to break the mapping up as the mapping
+ * for blocks beyond EOF must be marked new so that sub block regions can be
+ * correctly zeroed. We can't do this for mappings within EOF unless the mapping
+ * was just allocated or is unwritten, otherwise the callers would overwrite
+ * existing data with zeros. Hence we have to split the mapping into a range up
+ * to and including EOF, and a second mapping for beyond EOF.
+ */
+static void
+xfs_map_trim_size(
+	struct inode		*inode,
+	sector_t		iblock,
+	struct buffer_head	*bh_result,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset,
+	ssize_t			size)
+{
+	xfs_off_t		mapping_size;
+
+	mapping_size = imap->br_startoff + imap->br_blockcount - iblock;
+	mapping_size <<= inode->i_blkbits;
+
+	ASSERT(mapping_size > 0);
+	if (mapping_size > size)
+		mapping_size = size;
+	if (offset < i_size_read(inode) &&
+	    offset + mapping_size >= i_size_read(inode)) {
+		/* limit mapping to block that spans EOF */
+		mapping_size = roundup_64(i_size_read(inode) - offset,
+					  1 << inode->i_blkbits);
+	}
+	if (mapping_size > LONG_MAX)
+		mapping_size = LONG_MAX;
+
+	bh_result->b_size = mapping_size;
+}
+
 STATIC int
 __xfs_get_blocks(
 	struct inode		*inode,
@@ -1347,6 +1388,11 @@ __xfs_get_blocks(
 		goto out_unlock;
 	}
 
+	/* trim mapping down to size requested */
+	if (direct || size > (1 << inode->i_blkbits))
+		xfs_map_trim_size(inode, iblock, bh_result,
+				  &imap, offset, size);
+
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
@@ -1388,39 +1434,6 @@ __xfs_get_blocks(
 		}
 	}
 
-	/*
-	 * If this is O_DIRECT or the mpage code calling tell them how large
-	 * the mapping is, so that we can avoid repeated get_blocks calls.
-	 *
-	 * If the mapping spans EOF, then we have to break the mapping up as the
-	 * mapping for blocks beyond EOF must be marked new so that sub block
-	 * regions can be correctly zeroed. We can't do this for mappings within
-	 * EOF unless the mapping was just allocated or is unwritten, otherwise
-	 * the callers would overwrite existing data with zeros. Hence we have
-	 * to split the mapping into a range up to and including EOF, and a
-	 * second mapping for beyond EOF.
-	 */
-	if (direct || size > (1 << inode->i_blkbits)) {
-		xfs_off_t		mapping_size;
-
-		mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
-		mapping_size <<= inode->i_blkbits;
-
-		ASSERT(mapping_size > 0);
-		if (mapping_size > size)
-			mapping_size = size;
-		if (offset < i_size_read(inode) &&
-		    offset + mapping_size >= i_size_read(inode)) {
-			/* limit mapping to block that spans EOF */
-			mapping_size = roundup_64(i_size_read(inode) - offset,
-						  1 << inode->i_blkbits);
-		}
-		if (mapping_size > LONG_MAX)
-			mapping_size = LONG_MAX;
-
-		bh_result->b_size = mapping_size;
-	}
-
 	return 0;
 
 out_unlock:
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
