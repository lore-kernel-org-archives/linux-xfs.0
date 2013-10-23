Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A5897F55
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 18:27:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 806F5AC002
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 16:27:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DiOFbiMHW23H7jjh for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 16:27:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VZ7pY-0003p2-T7
	for xfs@oss.sgi.com; Thu, 24 Oct 2013 10:27:12 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VZ7pY-00078T-SG
	for xfs@oss.sgi.com; Thu, 24 Oct 2013 10:27:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: validity check the directory block leaf entry count
Date: Thu, 24 Oct 2013 10:27:12 +1100
Message-Id: <1382570832-27396-1-git-send-email-david@fromorbit.com>
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

The directory block format verifier fails to check that the leaf
entry count is in a valid range, and so if it is corrupted then it
can lead to derefencing a pointer outside the block buffer. While we
can't exactly validate the count without first walking the directory
block, we can ensure the count lands in the valid area within the
directory block and hence avoid out-of-block references.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_data.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 014fa6a..e0c8f57 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -65,7 +65,6 @@ __xfs_dir3_data_check(
 	const struct xfs_dir_ops *ops;
 
 	mp = bp->b_target->bt_mount;
-	hdr = bp->b_addr;
 
 	/*
 	 * we can be passed a null dp here from a verifier, so we need to go the
@@ -73,12 +72,25 @@ __xfs_dir3_data_check(
 	 */
 	ops = xfs_dir_get_ops(mp, dp);
 
+	hdr = bp->b_addr;
+	p = (char *)ops->data_entry_p(hdr);
+
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
 	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
+
+		/*
+		 * The number of leaf entries is limited by the size of the
+		 * block and the amount of space used by the data entries.
+		 * We don't know how much space is used by the data entries yet,
+		 * so just ensure that the count falls somewhere inside the
+		 * block right now.
+		 */
+		XFS_WANT_CORRUPTED_RETURN(be32_to_cpu(btp->count) <
+			((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry));
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
@@ -88,13 +100,12 @@ __xfs_dir3_data_check(
 		XFS_ERROR_REPORT("Bad Magic", XFS_ERRLEVEL_LOW, mp);
 		return EFSCORRUPTED;
 	}
-	bf = ops->data_bestfree_p(hdr);
-	p = (char *)ops->data_entry_p(hdr);
 
-	count = lastfree = freeseen = 0;
 	/*
 	 * Account for zero bestfree entries.
 	 */
+	bf = ops->data_bestfree_p(hdr);
+	count = lastfree = freeseen = 0;
 	if (!bf[0].length) {
 		XFS_WANT_CORRUPTED_RETURN(!bf[0].offset);
 		freeseen |= 1 << 0;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
