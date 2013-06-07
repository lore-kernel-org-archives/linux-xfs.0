Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A04317F54
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38243AC00A
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7D3zMz7NZbYl1bDF for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ukvj6-0005Su-Gr
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ukvj6-00030x-9F
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/12] xfs: Remote attr validation fixes and optimisations
Date: Fri,  7 Jun 2013 22:24:51 +1000
Message-Id: <1370607901-11538-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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

- optimise the calcuation for the number of blocks in a remote xattr.
- check attribute length against MAX_XATTR_SIZE, not MAXPATHLEN
- whitespace fixes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_attr_remote.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index fa112ad..f0ca926 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -29,15 +29,9 @@ xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
 {
-	int		fsblocks = 0;
-	int		len = attrlen;
-
-	do {
-		fsblocks++;
-		len -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
-	} while (len > 0);
-
-	return fsblocks;
+	int		buflen = XFS_ATTR3_RMT_BUF_SPACE(mp,
+							 mp->m_sb.sb_blocksize);
+	return (attrlen + buflen - 1) / buflen;
 }
 
 static bool
@@ -56,7 +50,7 @@ xfs_attr3_rmt_verify(
 	if (bp->b_bn != be64_to_cpu(rmt->rm_blkno))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
-				be32_to_cpu(rmt->rm_bytes) >= MAXPATHLEN)
+				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
 		return false;
 	if (rmt->rm_owner == 0)
 		return false;
@@ -160,7 +154,6 @@ xfs_attr3_rmt_hdr_ok(
 
 	/* ok */
 	return true;
-
 }
 
 /*
@@ -344,7 +337,6 @@ xfs_attr_rmtval_set(
 		 * spill for another block every 9 headers we require in this
 		 * loop.
 		 */
-
 		if (crcs && blkcnt == 0) {
 			int total_len;
 
@@ -399,9 +391,8 @@ xfs_attr_rmtval_set(
 
 		byte_cnt = BBTOB(bp->b_length);
 		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
-		if (valuelen < byte_cnt) {
+		if (valuelen < byte_cnt)
 			byte_cnt = valuelen;
-		}
 
 		buf = bp->b_addr;
 		buf += xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
