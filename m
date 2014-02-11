Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F35D7F4E
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 21:10:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2CC2B304067
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 19:10:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lbEnMwZHcmaOUJAz for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 19:10:45 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id AA14B63CE389
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 21:10:45 -0600 (CST)
Message-ID: <52F994B5.3010000@sandeen.net>
Date: Mon, 10 Feb 2014 21:10:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/7] xfs: Use defines for CRC offsets in all cases
References: <52F99426.3010409@sandeen.net>
In-Reply-To: <52F99426.3010409@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Some calls to crc functions used useful #defines,
others used awkward offsetof() constructs.

Switch them all to #define to make things a bit
cleaner.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_ag.h             |    6 ++++++
 fs/xfs/xfs_alloc.c          |   10 ++++------
 fs/xfs/xfs_dinode.h         |    2 ++
 fs/xfs/xfs_format.h         |    2 ++
 fs/xfs/xfs_ialloc.c         |    5 ++---
 fs/xfs/xfs_inode_buf.c      |    4 ++--
 fs/xfs/xfs_sb.c             |    5 ++---
 fs/xfs/xfs_sb.h             |    2 ++
 fs/xfs/xfs_symlink_remote.c |    5 ++---
 9 files changed, 24 insertions(+), 17 deletions(-)

New patch since V1

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 3fc1098..0fdd410 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
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
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 9eab2df..72ea855 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -486,7 +486,7 @@ xfs_agfl_read_verify(
 		return;
 
 	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				   offsetof(struct xfs_agfl, agfl_crc));
+				   XFS_AGFL_CRC_OFF);
 
 	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
 
@@ -516,8 +516,7 @@ xfs_agfl_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agfl, agfl_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGFL_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
@@ -2242,7 +2241,7 @@ xfs_agf_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		agf_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  offsetof(struct xfs_agf, agf_crc));
+					  XFS_AGF_CRC_OFF);
 
 	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
 
@@ -2272,8 +2271,7 @@ xfs_agf_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agf, agf_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGF_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index e5869b5..623bbe8 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -89,6 +89,8 @@ typedef struct xfs_dinode {
 	/* structure must be padded to 64 bit alignment */
 } xfs_dinode_t;
 
+#define XFS_DINODE_CRC_OFF	offsetof(struct xfs_dinode, di_crc)
+
 #define DI_MAX_FLUSH 0xffff
 
 /*
diff --git a/fs/xfs/xfs_format.h b/fs/xfs/xfs_format.h
index b6ab5a3..9898f31 100644
--- a/fs/xfs/xfs_format.h
+++ b/fs/xfs/xfs_format.h
@@ -145,6 +145,8 @@ struct xfs_dsymlink_hdr {
 	__be64	sl_lsn;
 };
 
+#define XFS_SYMLINK_CRC_OFF	offsetof(struct xfs_dsymlink_hdr, sl_crc)
+
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
  * blocksize is 512 bytes, we can get a max of 3 extents back from
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5d7f105..d79210b 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1572,7 +1572,7 @@ xfs_agi_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  offsetof(struct xfs_agi, agi_crc));
+					  XFS_AGI_CRC_OFF);
 	agi_ok = agi_ok && xfs_agi_verify(bp);
 
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
@@ -1600,8 +1600,7 @@ xfs_agi_write_verify(
 
 	if (bip)
 		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agi, agi_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGI_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 4fc9f39..606b43a 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -306,7 +306,7 @@ xfs_dinode_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return false;
 	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      offsetof(struct xfs_dinode, di_crc)))
+			      XFS_DINODE_CRC_OFF))
 		return false;
 	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
 		return false;
@@ -327,7 +327,7 @@ xfs_dinode_calc_crc(
 
 	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
 	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      offsetof(struct xfs_dinode, di_crc));
+			      XFS_DINODE_CRC_OFF);
 	dip->di_crc = xfs_end_cksum(crc);
 }
 
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index efaef71..1c6dc6d 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -611,7 +611,7 @@ xfs_sb_read_verify(
 	     dsb->sb_crc != 0)) {
 
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
-				      offsetof(struct xfs_sb, sb_crc))) {
+				      XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn != XFS_SB_DADDR &&
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -675,8 +675,7 @@ xfs_sb_write_verify(
 	if (bip)
 		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_sb, sb_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_SB_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 35061d4..f7b2fe7 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -182,6 +182,8 @@ typedef struct xfs_sb {
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
+
 /*
  * Superblock - on disk version.  Must match the in core version above.
  * Must be padded to 64 bit alignment.
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index bf59a2b..7a705a4 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -134,7 +134,7 @@ xfs_symlink_read_verify(
 		return;
 
 	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				  offsetof(struct xfs_dsymlink_hdr, sl_crc)) ||
+				  XFS_SYMLINK_CRC_OFF) ||
 	    !xfs_symlink_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
@@ -162,8 +162,7 @@ xfs_symlink_write_verify(
 		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
 		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_dsymlink_hdr, sl_crc));
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_SYMLINK_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
