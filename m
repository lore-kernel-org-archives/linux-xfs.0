Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 696807F54
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 06:39:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4EF768F8064
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 04:39:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ccyz4gtieF7hIKW4 for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 04:39:42 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UX8uI-0005sP-Vw
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UX8uI-0004lV-Sj
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: Remote attr validation fixes and optimisations
Date: Tue, 30 Apr 2013 21:39:35 +1000
Message-Id: <1367321976-18268-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1367321976-18268-1-git-send-email-david@fromorbit.com>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
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

- optimise the calcuation for the number of blocks in a remote
  xattr.
- check attribute length against MAX_XATTR_SIZE, not MAXPATHLEN
- whitespace fixes

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_remote.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 53da46b..dee8446 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -52,15 +52,9 @@ xfs_attr3_rmt_blocks(
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
@@ -79,7 +73,7 @@ xfs_attr3_rmt_verify(
 	if (bp->b_bn != be64_to_cpu(rmt->rm_blkno))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
-				be32_to_cpu(rmt->rm_bytes) >= MAXPATHLEN)
+				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
 		return false;
 	if (rmt->rm_owner == 0)
 		return false;
@@ -183,7 +177,6 @@ xfs_attr3_rmt_hdr_ok(
 
 	/* ok */
 	return true;
-
 }
 
 /*
@@ -367,7 +360,6 @@ xfs_attr_rmtval_set(
 		 * spill for another block every 9 headers we require in this
 		 * loop.
 		 */
-
 		if (crcs && blkcnt == 0) {
 			int total_len;
 
@@ -422,9 +414,8 @@ xfs_attr_rmtval_set(
 
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
