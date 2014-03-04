Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 24A757F58
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5D21304043
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MPDXV641at41a0tV for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:18 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006Ha-Ms
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006zB-Lk
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/13] libxfs: Use defines for CRC offsets in all cases
Date: Tue,  4 Mar 2014 19:51:51 +1100
Message-Id: <1393923117-9559-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

[userspace port]

Some calls to crc functions used useful #defines,
others used awkward offsetof() constructs.

Switch them all to #define to make things a bit cleaner.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_ag.h            |  6 ++++++
 include/xfs_dinode.h        |  2 ++
 include/xfs_format.h        |  2 ++
 include/xfs_sb.h            |  2 ++
 libxfs/xfs_alloc.c          | 10 ++++------
 libxfs/xfs_ialloc.c         |  5 ++---
 libxfs/xfs_inode_buf.c      |  4 ++--
 libxfs/xfs_sb.c             |  5 ++---
 libxfs/xfs_symlink_remote.c |  5 ++---
 9 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 3fc1098..0fdd410 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -89,6 +89,8 @@ typedef struct xfs_agf {
 	/* structure must be padded to 64 bit alignment */
 } xfs_agf_t;
 
+#define XFS_AGF_CRC_OFF		offsetof(struct xfs_agf, agf_crc)
+
 #define	XFS_AGF_MAGICNUM	0x00000001
 #define	XFS_AGF_VERSIONNUM	0x00000002
 #define	XFS_AGF_SEQNO		0x00000004
@@ -167,6 +169,8 @@ typedef struct xfs_agi {
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
+#define XFS_AGI_CRC_OFF		offsetof(struct xfs_agi, agi_crc)
+
 #define	XFS_AGI_MAGICNUM	0x00000001
 #define	XFS_AGI_VERSIONNUM	0x00000002
 #define	XFS_AGI_SEQNO		0x00000004
@@ -222,6 +226,8 @@ typedef struct xfs_agfl {
 	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
 } xfs_agfl_t;
 
+#define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
+
 /*
  * tags for inode radix tree
  */
diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
index e5869b5..623bbe8 100644
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -89,6 +89,8 @@ typedef struct xfs_dinode {
 	/* structure must be padded to 64 bit alignment */
 } xfs_dinode_t;
 
+#define XFS_DINODE_CRC_OFF	offsetof(struct xfs_dinode, di_crc)
+
 #define DI_MAX_FLUSH 0xffff
 
 /*
diff --git a/include/xfs_format.h b/include/xfs_format.h
index 997c770..77f6b8b 100644
--- a/include/xfs_format.h
+++ b/include/xfs_format.h
@@ -145,6 +145,8 @@ struct xfs_dsymlink_hdr {
 	__be64	sl_lsn;
 };
 
+#define XFS_SYMLINK_CRC_OFF	offsetof(struct xfs_dsymlink_hdr, sl_crc)
+
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
  * blocksize is 512 bytes, we can get a max of 3 extents back from
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 35061d4..f7b2fe7 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -182,6 +182,8 @@ typedef struct xfs_sb {
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
+
 /*
  * Superblock - on disk version.  Must match the in core version above.
  * Must be padded to 64 bit alignment.
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index e4fb1ad..8a6725e 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -464,7 +464,7 @@ xfs_agfl_read_verify(
 		return;
 
 	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				   offsetof(struct xfs_agfl, agfl_crc));
+				   XFS_AGFL_CRC_OFF);
 
 	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
 
@@ -494,8 +494,7 @@ xfs_agfl_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agfl, agfl_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGFL_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
@@ -2222,7 +2221,7 @@ xfs_agf_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		agf_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  offsetof(struct xfs_agf, agf_crc));
+					  XFS_AGF_CRC_OFF);
 
 	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
 
@@ -2252,8 +2251,7 @@ xfs_agf_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agf, agf_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGF_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index afe1a82..b83ad98 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1555,7 +1555,7 @@ xfs_agi_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  offsetof(struct xfs_agi, agi_crc));
+					  XFS_AGI_CRC_OFF);
 	agi_ok = agi_ok && xfs_agi_verify(bp);
 
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
@@ -1583,8 +1583,7 @@ xfs_agi_write_verify(
 
 	if (bip)
 		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agi, agi_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGI_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index d245d72..4f29033 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -292,7 +292,7 @@ xfs_dinode_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return false;
 	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      offsetof(struct xfs_dinode, di_crc)))
+			      XFS_DINODE_CRC_OFF))
 		return false;
 	if (be64_to_cpu(dip->di_ino) != ino)
 		return false;
@@ -313,7 +313,7 @@ xfs_dinode_calc_crc(
 
 	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
 	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      offsetof(struct xfs_dinode, di_crc));
+			      XFS_DINODE_CRC_OFF);
 	dip->di_crc = xfs_end_cksum(crc);
 }
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 05bc860..bbcf886 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -566,7 +566,7 @@ xfs_sb_read_verify(
 	     dsb->sb_crc != 0)) {
 
 		if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				      offsetof(struct xfs_sb, sb_crc))) {
+				      XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -629,8 +629,7 @@ xfs_sb_write_verify(
 	if (bip)
 		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_sb, sb_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_SB_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 539db0c..09ee9d4 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -117,7 +117,7 @@ xfs_symlink_read_verify(
 		return;
 
 	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				  offsetof(struct xfs_dsymlink_hdr, sl_crc)) ||
+				  XFS_SYMLINK_CRC_OFF) ||
 	    !xfs_symlink_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
@@ -145,8 +145,7 @@ xfs_symlink_write_verify(
 		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
 		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_dsymlink_hdr, sl_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_SYMLINK_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
