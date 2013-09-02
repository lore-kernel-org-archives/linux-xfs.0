Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A9297F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:50:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 85F1C8F8049
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:50:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SPmEjitjThvG4Xs3 for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:50:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGRi9-0000sT-1Q
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 20:50:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGRi9-00089P-09
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 20:50:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: check magic numbers in dir3 leaf verifier first
Date: Mon,  2 Sep 2013 20:50:20 +1000
Message-Id: <1378119020-31299-1-git-send-email-david@fromorbit.com>
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

Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
validating the magic numbers in the buffer results in ASSERT
failures due to mismatching magic numbers when a corruption occurs.
Seeing as the verifier is supposed to catch the corruption and pass
it back to the caller, having the verifier assert fail on error
defeats the purpose of detecting the errors in the first place.

Check the magic numbers direct from the buffer before decoding the
header.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_leaf.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 08984ee..fa46d4b 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -165,6 +165,7 @@ xfs_dir3_leaf_check_int(
 	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
 		return false;
 
+
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
@@ -180,6 +181,11 @@ xfs_dir3_leaf_check_int(
 	return true;
 }
 
+/*
+ * We verify the magic numbers before decoding the leaf header so that on debug
+ * kernels we don't get assertion failures in xfs_dir3_leaf_hdr_from_disk() due
+ * to incorrect magic numbers.
+ */
 static bool
 xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp,
@@ -191,24 +197,25 @@ xfs_dir3_leaf_verify(
 
 	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
 
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
+		__uint16_t		magic3;
 
-		if ((magic == XFS_DIR2_LEAF1_MAGIC &&
-		     leafhdr.magic != XFS_DIR3_LEAF1_MAGIC) ||
-		    (magic == XFS_DIR2_LEAFN_MAGIC &&
-		     leafhdr.magic != XFS_DIR3_LEAFN_MAGIC))
-			return false;
+		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
+							 : XFS_DIR3_LEAFN_MAGIC;
 
+		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
+			return false;
 		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
 	} else {
-		if (leafhdr.magic != magic)
+		if (leaf->hdr.info.magic != cpu_to_be32(magic))
 			return false;
 	}
+
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
 }
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
