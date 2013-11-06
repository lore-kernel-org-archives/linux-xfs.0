Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A95F829E55
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DDE9AC00B
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:51 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	weHAbb3YInp4zIZu for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:49 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003O6-5E
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008Un-4d
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/37] xfs: remove newlines from strings passed to __xfs_printk
Date: Wed,  6 Nov 2013 12:06:57 +1100
Message-Id: <1383700043-32305-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

__xfs_printk adds its own "\n".  Having it in the original string
leads to unintentional blank lines from these messages.

Ported from kernel commit 08e96e1a.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_bmap.c         | 2 +-
 libxfs/xfs_dir2_node.c    | 2 +-
 libxfs/xfs_sb.c           | 4 ++--
 libxlog/xfs_log_recover.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3e80c64..c45b91a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1447,7 +1447,7 @@ xfs_bmap_search_extents(
 		xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 				"Access to block zero in inode %llu "
 				"start_block: %llx start_off: %llx "
-				"blkcnt: %llx extent-state: %x lastx: %x\n",
+				"blkcnt: %llx extent-state: %x lastx: %x",
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)gotp->br_startblock,
 			(unsigned long long)gotp->br_startoff,
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 10d1d81..ced8c58 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1083,7 +1083,7 @@ xfs_dir2_leafn_rebalance(
 		state->inleaf = 1;
 		blk2->index = 0;
 		xfs_alert(args->dp->i_mount,
-	"%s: picked the wrong leaf? reverting original leaf: blk1->index %d\n",
+	"%s: picked the wrong leaf? reverting original leaf: blk1->index %d",
 			__func__, blk1->index);
 	}
 }
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 8b90b88..11353bb 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -215,13 +215,13 @@ xfs_mount_validate_sb(
 	if (xfs_sb_version_has_pquotino(sbp)) {
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
-			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
+			   "Version 5 of Super block has XFS_OQUOTA bits.");
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
-"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
+"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
 			return XFS_ERROR(EFSCORRUPTED);
 	}
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index f3cda77..3f22921 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1330,7 +1330,7 @@ xlog_unpack_data_crc(
 	if (crc != rhead->h_crc) {
 		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
 			xfs_alert(log->l_mp,
-		"log record CRC mismatch: found 0x%x, expected 0x%x.\n",
+		"log record CRC mismatch: found 0x%x, expected 0x%x.",
 					le32_to_cpu(rhead->h_crc),
 					le32_to_cpu(crc));
 			xfs_hex_dump(dp, 32);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
