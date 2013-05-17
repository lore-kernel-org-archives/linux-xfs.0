Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF21029E06
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:14:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 635BFAC001
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:14:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1vvM5pjqHJVLlzgY for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:14:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbi-0008So-41
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:54 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbh-0005Ff-LK
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/30] xfsprogs: add crc format support to repair
Date: Fri, 17 May 2013 21:13:19 +1000
Message-Id: <1368789205-19969-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h           |    5 ++
 include/xfs_alloc_btree.h  |    2 +-
 include/xfs_bmap_btree.h   |    2 +-
 include/xfs_btree.h        |    5 +-
 include/xfs_ialloc_btree.h |    2 +-
 include/xfs_symlink.h      |    2 +
 libxfs/rdwr.c              |   19 ++++-
 libxfs/xfs.h               |   12 ++-
 libxfs/xfs_alloc.c         |    7 +-
 libxfs/xfs_btree.c         |   20 +++--
 repair/agheader.c          |   36 ++++++++-
 repair/dino_chunks.c       |    7 +-
 repair/dinode.c            |  190 ++++++++++++++++++++++++++------------------
 repair/phase2.c            |    1 +
 repair/phase5.c            |  152 ++++++++++++++++++++++++++---------
 repair/prefetch.c          |    7 +-
 repair/scan.c              |  152 +++++++++++++++++++----------------
 repair/scan.h              |   12 ++-
 repair/versions.c          |    2 +-
 repair/xfs_repair.c        |    2 +-
 20 files changed, 422 insertions(+), 215 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index d5131c1..4bb4ad4 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -682,6 +682,7 @@ void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 #define libxfs_dinode_to_disk		xfs_dinode_to_disk
 void	xfs_dinode_from_disk(struct xfs_icdinode *,
 			     struct xfs_dinode *);
+#define libxfs_dinode_calc_crc		xfs_dinode_calc_crc
 #define libxfs_idata_realloc		xfs_idata_realloc
 #define libxfs_idestroy_fork		xfs_idestroy_fork
 
@@ -690,6 +691,10 @@ void	xfs_dinode_from_disk(struct xfs_icdinode *,
 #define libxfs_sb_from_disk		xfs_sb_from_disk
 #define libxfs_sb_to_disk		xfs_sb_to_disk
 
+/* xfs_symlink.h */
+#define libxfs_symlink_blocks		xfs_symlink_blocks
+#define libxfs_symlink_hdr_ok		xfs_symlink_hdr_ok
+
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 
diff --git a/include/xfs_alloc_btree.h b/include/xfs_alloc_btree.h
index 70c3ea0..e160339 100644
--- a/include/xfs_alloc_btree.h
+++ b/include/xfs_alloc_btree.h
@@ -64,7 +64,7 @@ typedef __be32 xfs_alloc_ptr_t;
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
 	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-	 XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
+	 XFS_BTREE_SBLOCK_CRC_LEN : \
 	 XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index 8a28b89..20d66b0 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -140,7 +140,7 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
  */
 #define XFS_BMBT_BLOCK_LEN(mp) \
 	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-	 XFS_BTREE_LBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
+	 XFS_BTREE_LBLOCK_CRC_LEN : \
 	 XFS_BTREE_LBLOCK_LEN)
 
 #define XFS_BMBT_REC_ADDR(mp, block, index) \
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 02f89d8..c0acbbf 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -83,7 +83,10 @@ struct xfs_btree_block {
 
 #define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
 #define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
-#define XFS_BTREE_CRCBLOCK_ADD	32	/* size of blkno + crc + uuid */
+
+/* sizes of CRC enabled btree blocks */
+#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
+#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
 
 #define XFS_BTREE_SBLOCK_CRC_OFF \
 	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index a1bfa7a..7f5ae6b 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -80,7 +80,7 @@ typedef __be32 xfs_inobt_ptr_t;
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
 	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-	 XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
+	 XFS_BTREE_SBLOCK_CRC_LEN : \
 	 XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
index bb21e6a..55f3f2d 100644
--- a/include/xfs_symlink.h
+++ b/include/xfs_symlink.h
@@ -29,6 +29,8 @@ struct xfs_dsymlink_hdr {
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
 int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
 
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f91a5d0..c679f81 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -445,6 +445,7 @@ __libxfs_getbufr(int blen)
 	} else
 		bp = kmem_zone_zalloc(xfs_buf_zone, 0);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
+	bp->b_ops = NULL;
 
 	return bp;
 }
@@ -833,10 +834,20 @@ libxfs_writebufr(xfs_buf_t *bp)
 		}
 	}
 
+	/*
+	 * clear any pre-existing error status on the buffer. This can occur if
+	 * the buffer is corrupt on disk and the repair process doesn't clear
+	 * the error before fixing and writing it back.
+	 */
+	bp->b_error = 0;
 	if (bp->b_ops) {
 		bp->b_ops->verify_write(bp);
-		if (bp->b_error)
+		if (bp->b_error) {
+			fprintf(stderr,
+	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
+				__func__, (long long)bp->b_bn, bp->b_bcount);
 			return bp->b_error;
+		}
 	}
 
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
@@ -883,6 +894,12 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
 int
 libxfs_writebuf(xfs_buf_t *bp, int flags)
 {
+#ifdef IO_DEBUG
+	printf("%lx: %s: dirty blkno=%llu(%llu)\n",
+			pthread_self(), __FUNCTION__,
+			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
+			(long long)bp->b_bn);
+#endif
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
 	libxfs_putbuf(bp);
 	return 0;
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 9246f36..aa71ecc 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -69,8 +69,16 @@ typedef __uint32_t		inst_t;		/* an instruction */
 #define IHOLD(ip)			((void) 0)
 
 /* stop unused var warnings by assigning mp to itself */
-#define XFS_CORRUPTION_ERROR(e,l,mp,m)	do { (mp) = (mp); } while (0)
-#define XFS_ERROR_REPORT(e,l,mp)	do { (mp) = (mp); } while (0)
+#define XFS_CORRUPTION_ERROR(e,l,mp,m)	do { \
+	(mp) = (mp); \
+	cmn_err(CE_ALERT, "%s: XFS_CORRUPTION_ERROR", (e));  \
+} while (0)
+
+#define XFS_ERROR_REPORT(e,l,mp)	do { \
+	(mp) = (mp); \
+	cmn_err(CE_ALERT, "%s: XFS_ERROR_REPORT", (e));  \
+} while (0)
+
 #define XFS_QM_DQATTACH(mp,ip,flags)	0
 #define XFS_ERROR(e)			(e)
 #define XFS_ERRLEVEL_LOW		1
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1041f8f..1d7ea8f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2173,8 +2173,13 @@ xfs_agf_verify(
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
+	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
+		char uu[64], uu2[64];
+		platform_uuid_unparse(&agf->agf_uuid, uu);
+		platform_uuid_unparse(&mp->m_sb.sb_uuid, uu2);
+
 			return false;
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a613294..b11131c 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -391,17 +391,15 @@ xfs_btree_dup_cursor(
  */
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
-	size_t len;
-
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		len = XFS_BTREE_LBLOCK_LEN;
-	else
-		len = XFS_BTREE_SBLOCK_LEN;
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
+			return XFS_BTREE_LBLOCK_CRC_LEN;
+		return XFS_BTREE_LBLOCK_LEN;
+	}
 
 	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
-		len += XFS_BTREE_CRCBLOCK_ADD;
-
-	return len;
+		return XFS_BTREE_SBLOCK_CRC_LEN;
+	return XFS_BTREE_SBLOCK_LEN;
 }
 
 /*
@@ -1311,7 +1309,7 @@ xfs_btree_log_block(
 		offsetof(struct xfs_btree_block, bb_u.s.bb_uuid),
 		offsetof(struct xfs_btree_block, bb_u.s.bb_owner),
 		offsetof(struct xfs_btree_block, bb_u.s.bb_crc),
-		XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD
+		XFS_BTREE_SBLOCK_CRC_LEN
 	};
 	static const short	loffsets[] = {	/* table of offsets (long) */
 		offsetof(struct xfs_btree_block, bb_magic),
@@ -1325,7 +1323,7 @@ xfs_btree_log_block(
 		offsetof(struct xfs_btree_block, bb_u.l.bb_owner),
 		offsetof(struct xfs_btree_block, bb_u.l.bb_crc),
 		offsetof(struct xfs_btree_block, bb_u.l.bb_pad),
-		XFS_BTREE_LBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD
+		XFS_BTREE_LBLOCK_CRC_LEN
 	};
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
diff --git a/repair/agheader.c b/repair/agheader.c
index 769022d..bc8b1bf 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -22,6 +22,11 @@
 #include "protos.h"
 #include "err_protos.h"
 
+/*
+ * XXX (dgc): WTF is the point of all the check and repair here when phase 5
+ * recreates the AGF/AGI/AGFL completely from scratch?
+ */
+
 static int
 verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 {
@@ -104,7 +109,20 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 
 	/* don't check freespace btrees -- will be checked by caller */
 
-	return(retval);
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return retval;
+
+	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
+		char uu[64];
+
+		retval = XR_AG_AGF;
+		platform_uuid_unparse(&agf->agf_uuid, uu);
+		do_warn(_("bad uuid %s for agf %d\n"), uu, i);
+
+		if (!no_modify)
+			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+	}
+	return retval;
 }
 
 static int
@@ -169,7 +187,21 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 
 	/* don't check inode btree -- will be checked by caller */
 
-	return(retval);
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return retval;
+
+	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_uuid)) {
+		char uu[64];
+
+		retval = XR_AG_AGI;
+		platform_uuid_unparse(&agi->agi_uuid, uu);
+		do_warn(_("bad uuid %s for agi %d\n"), uu, agno);
+
+		if (!no_modify)
+			platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+	}
+
+	return retval;
 }
 
 /*
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 21078d0..d3c2236 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -628,7 +628,7 @@ process_inode_chunk(
 		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, blks_per_cluster), 0,
-					NULL);
+					&xfs_inode_buf_ops);
 		if (!bplist[bp_index]) {
 			do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
 				XFS_AGINO_TO_INO(mp, agno, first_irec->ino_startnum),
@@ -775,8 +775,11 @@ process_inode_chunk(
 				extra_attr_check, &isa_dir, &parent);
 
 		ASSERT(is_used != 3);
-		if (ino_dirty)
+		if (ino_dirty) {
 			dirty = 1;
+			libxfs_dinode_calc_crc(mp, dino);
+		}
+
 		/*
 		 * XXX - if we want to try and keep
 		 * track of whether we need to bang on
diff --git a/repair/dinode.c b/repair/dinode.c
index 66eedc2..2df9a91 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -85,139 +85,127 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 }
 
 static int
-clear_dinode_core(xfs_dinode_t *dinoc, xfs_ino_t ino_num)
+clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 {
 	int dirty = 0;
+	int i;
 
-	if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
+#define __dirty_no_modify_ret(dirty) \
+	({ (dirty) = 1; if (no_modify) return 1; })
 
+	if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)  {
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	}
 
 	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
 	    (!fs_inode_nlink && dinoc->di_version > 1))  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
-		dinoc->di_version = (fs_inode_nlink) ? 2 : 1;
+		__dirty_no_modify_ret(dirty);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			dinoc->di_version = 3;
+		else
+			dinoc->di_version = (fs_inode_nlink) ? 2 : 1;
 	}
 
 	if (be16_to_cpu(dinoc->di_mode) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_mode = 0;
 	}
 
 	if (be16_to_cpu(dinoc->di_flags) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_flags = 0;
 	}
 
 	if (be32_to_cpu(dinoc->di_dmevmask) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_dmevmask = 0;
 	}
 
 	if (dinoc->di_forkoff != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_forkoff = 0;
 	}
 
 	if (dinoc->di_format != XFS_DINODE_FMT_EXTENTS)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_format = XFS_DINODE_FMT_EXTENTS;
 	}
 
 	if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 
 	if (be64_to_cpu(dinoc->di_size) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_size = 0;
 	}
 
 	if (be64_to_cpu(dinoc->di_nblocks) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_nblocks = 0;
 	}
 
 	if (be16_to_cpu(dinoc->di_onlink) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_onlink = 0;
 	}
 
 	if (be32_to_cpu(dinoc->di_nextents) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_nextents = 0;
 	}
 
 	if (be16_to_cpu(dinoc->di_anextents) != 0)  {
-		dirty = 1;
-
-		if (no_modify)
-			return(1);
-
+		__dirty_no_modify_ret(dirty);
 		dinoc->di_anextents = 0;
 	}
 
 	if (dinoc->di_version > 1 &&
 			be32_to_cpu(dinoc->di_nlink) != 0)  {
-		dirty = 1;
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_nlink = 0;
+	}
 
-		if (no_modify)
-			return(1);
+	/* we are done for version 1/2 inodes */
+	if (dinoc->di_version < 3)
+		return dirty;
 
-		dinoc->di_nlink = 0;
+	if (be64_to_cpu(dinoc->di_ino) != ino_num) {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_ino = cpu_to_be64(ino_num);
 	}
 
-	return(dirty);
+	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_uuid)) {
+		__dirty_no_modify_ret(dirty);
+		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
+	}
+
+	for (i = 0; i < 16; i++) {
+		if (dinoc->di_pad[i] != 0) {
+			__dirty_no_modify_ret(dirty);
+			memset(dinoc->di_pad, 0, 16);
+			break;
+		}
+	}
+
+	if (be64_to_cpu(dinoc->di_flags2) != 0)  {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_flags2 = 0;
+	}
+
+	if (be64_to_cpu(dinoc->di_lsn) != 0)  {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_lsn = 0;
+	}
+
+	if (be64_to_cpu(dinoc->di_changecount) != 0)  {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_changecount = 0;
+	}
+
+	return dirty;
 }
 
 static int
@@ -243,7 +231,7 @@ clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 {
 	int dirty;
 
-	dirty = clear_dinode_core(dino, ino_num);
+	dirty = clear_dinode_core(mp, dino, ino_num);
 	dirty += clear_dinode_unlinked(mp, dino);
 
 	/* and clear the forks */
@@ -1126,6 +1114,7 @@ process_btinode(
 	int			level;
 	int			numrecs;
 	bmap_cursor_t		cursor;
+	__uint64_t		magic;
 
 	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1137,6 +1126,9 @@ process_btinode(
 	else
 		forkname = _("attr");
 
+	magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_BMAP_CRC_MAGIC
+						 : XFS_BMAP_MAGIC;
+
 	level = be16_to_cpu(dib->bb_level);
 	numrecs = be16_to_cpu(dib->bb_numrecs);
 
@@ -1190,9 +1182,9 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 			return(1);
 		}
 
-		if (scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, type, 
+		if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, type, 
 				whichfork, lino, tot, nex, blkmapp, &cursor,
-				1, check_dups))
+				1, check_dups, magic, &xfs_bmbt_buf_ops))
 			return(1);
 		/*
 		 * fix key (offset) mismatches between the keys in root
@@ -1520,9 +1512,21 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 				return(1);
 			}
 
+
 			buf_data = (char *)XFS_BUF_PTR(bp);
-			size = MIN(be64_to_cpu(dino->di_size) - amountdone, 
-						XFS_FSB_TO_BB(mp, 1) * BBSIZE);
+			size = MIN(be64_to_cpu(dino->di_size) - amountdone,
+					XFS_SYMLINK_BUF_SPACE(mp,
+							mp->m_sb.sb_blocksize));
+			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+				if (!libxfs_symlink_hdr_ok(mp, lino, amountdone,
+							size, bp)) {
+					do_warn(
+_("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
+						lino, i, fsbno);
+					return(1);
+				}
+				buf_data += sizeof(struct xfs_dsymlink_hdr);
+			}
 			memmove(cptr, buf_data, size);
 			cptr += size;
 			amountdone += size;
@@ -2484,7 +2488,8 @@ process_dinode_int(xfs_mount_t *mp,
 	}
 
 	if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
-	    (!fs_inode_nlink && dino->di_version > 1))  {
+	    (!fs_inode_nlink && dino->di_version > 1) ||
+	    (xfs_sb_version_hascrc(&mp->m_sb) && dino->di_version < 3) )  {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
@@ -2493,7 +2498,9 @@ process_dinode_int(xfs_mount_t *mp,
 		if (!verify_mode) {
 			if (!no_modify) {
 				do_warn(_(" resetting version number\n"));
-				dino->di_version = (fs_inode_nlink) ?  2 : 1;
+				dino->di_version =
+					xfs_sb_version_hascrc(&mp->m_sb) ? 3 :
+					(fs_inode_nlink) ?  2 : 1;
 				*dirty = 1;
 			} else
 				do_warn(_(" would reset version number\n"));
@@ -2501,6 +2508,31 @@ process_dinode_int(xfs_mount_t *mp,
 	}
 
 	/*
+	 * We don't bother checking the CRC here - we cannot guarantee that when
+	 * we are called here that the inode has not already been modified in
+	 * memory and hence invalidated the CRC.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (be64_to_cpu(dino->di_ino) != lino) {
+			if (!uncertain)
+				do_warn(
+_("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
+					be64_to_cpu(dino->di_ino), lino);
+			if (verify_mode)
+				return 1;
+			goto clear_bad_out;
+		}
+		if (platform_uuid_compare(&dino->di_uuid, &mp->m_sb.sb_uuid)) {
+			if (!uncertain)
+				do_warn(
+			_("UUID mismatch on inode %" PRIu64 "\n"), lino);
+			if (verify_mode)
+				return 1;
+			goto clear_bad_out;
+		}
+	}
+
+	/*
 	 * blow out of here if the inode size is < 0
 	 */
 	if ((xfs_fsize_t)be64_to_cpu(dino->di_size) < 0)  {
diff --git a/repair/phase2.c b/repair/phase2.c
index 2817fed..a62854e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -64,6 +64,7 @@ zero_log(xfs_mount_t *mp)
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
 	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
+	log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;
 
 	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
 		do_warn(_("zero_log: cannot find log head/tail "
diff --git a/repair/phase5.c b/repair/phase5.c
index c7cef4f..2eae42a 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -602,6 +602,12 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_alloc_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
+	__uint32_t		crc_magic;
+
+	if (magic == XFS_ABTB_MAGIC)
+		crc_magic = XFS_ABTB_CRC_MAGIC;
+	else
+		crc_magic = XFS_ABTC_CRC_MAGIC;
 
 	level++;
 
@@ -650,14 +656,17 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
+		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, lptr->buf_p, crc_magic, level,
+						0, agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, lptr->buf_p, magic, level,
+						0, agno, 0);
 
-		bt_hdr->bb_magic = cpu_to_be32(magic);
-		bt_hdr->bb_level = cpu_to_be16(level);
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		bt_hdr->bb_numrecs = 0;
 
 		/*
 		 * propagate extent record for first extent in new block up
@@ -699,6 +708,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	extent_tree_node_t	*ext_ptr;
 	bt_stat_level_t		*lptr;
 	xfs_extlen_t		freeblks;
+	__uint32_t		crc_magic;
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "in build_freespace_tree, agno = %d\n", agno);
@@ -707,6 +717,10 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	freeblks = 0;
 
 	ASSERT(level > 0);
+	if (magic == XFS_ABTB_MAGIC)
+		crc_magic = XFS_ABTB_CRC_MAGIC;
+	else
+		crc_magic = XFS_ABTC_CRC_MAGIC;
 
 	/*
 	 * initialize the first block on each btree level
@@ -728,14 +742,15 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
+		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-
-		bt_hdr->bb_magic = cpu_to_be32(magic);
-		bt_hdr->bb_level = cpu_to_be16(i);
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		bt_hdr->bb_numrecs = 0;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, lptr->buf_p, crc_magic, i,
+						0, agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, lptr->buf_p, magic, i,
+						0, agno, 0);
 	}
 	/*
 	 * run along leaf, setting up records.  as we have to switch
@@ -759,13 +774,17 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * block initialization, lay in block header
 		 */
+		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, lptr->buf_p, crc_magic, 0,
+						0, agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, lptr->buf_p, magic, 0,
+						0, agno, 0);
 
-		bt_hdr->bb_magic = cpu_to_be32(magic);
-		bt_hdr->bb_level = 0;
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
 							(lptr->modulo > 0));
 #ifdef XR_BLD_FREE_TRACE
@@ -996,14 +1015,19 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		/*
 		 * initialize block header
 		 */
+		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
+						level, 0, agno,
+						XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
+						level, 0, agno, 0);
 
-		bt_hdr->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
-		bt_hdr->bb_level = cpu_to_be16(level);
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		bt_hdr->bb_numrecs = 0;
+
 		/*
 		 * propagate extent record for first extent in new block up
 		 */
@@ -1024,6 +1048,9 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
 }
 
+/*
+ * XXX: yet more code that can be shared with mkfs, growfs.
+ */
 static void
 build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, xfs_agino_t first_agino,
@@ -1036,6 +1063,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 	agi_buf = libxfs_getbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE);
+	agi_buf->b_ops = &xfs_agi_buf_ops;
 	agi = XFS_BUF_TO_AGI(agi_buf);
 	memset(agi, 0, mp->m_sb.sb_sectsize);
 
@@ -1057,6 +1085,9 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)  
 		agi->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
 
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+
 	libxfs_writebuf(agi_buf, 0);
 }
 
@@ -1099,15 +1130,19 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
+
+		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-
-		bt_hdr->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
-		bt_hdr->bb_level = cpu_to_be16(i);
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		bt_hdr->bb_numrecs = 0;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
+						i, 0, agno,
+						XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
+						i, 0, agno, 0);
 	}
+
 	/*
 	 * run along leaf, setting up records.  as we have to switch
 	 * blocks, call the prop_ino_cursor routine to set up the new
@@ -1127,13 +1162,18 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * block initialization, lay in block header
 		 */
+		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
+						0, 0, agno,
+						XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
+						0, 0, agno, 0);
 
-		bt_hdr->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
-		bt_hdr->bb_level = 0;
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
 							(lptr->modulo > 0));
 
@@ -1192,7 +1232,9 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 
 /*
  * build both the agf and the agfl for an agno given both
- * btree cursors
+ * btree cursors.
+ *
+ * XXX: yet more common code that can be shared with mkfs/growfs.
  */
 static void
 build_agf_agfl(xfs_mount_t	*mp,
@@ -1213,6 +1255,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 	agf_buf = libxfs_getbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE);
+	agf_buf->b_ops = &xfs_agf_buf_ops;
 	agf = XFS_BUF_TO_AGF(agf_buf);
 	memset(agf, 0, mp->m_sb.sb_sectsize);
 
@@ -1266,22 +1309,34 @@ build_agf_agfl(xfs_mount_t	*mp,
 			XFS_BTNUM_CNT);
 #endif
 
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+
+	/* initialise the AGFL, then fill it if there are blocks left over. */
+	agfl_buf = libxfs_getbuf(mp->m_dev,
+			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			mp->m_sb.sb_sectsize/BBSIZE);
+	agfl_buf->b_ops = &xfs_agfl_buf_ops;
+	agfl = XFS_BUF_TO_AGFL(agfl_buf);
+
+	/* setting to 0xff results in initialisation to NULLAGBLOCK */
+	memset(agfl, 0xff, mp->m_sb.sb_sectsize);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+		agfl->agfl_seqno = cpu_to_be32(agno);
+		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
+		for (i = 0; i < XFS_AGFL_SIZE(mp); i++)
+			agfl->agfl_bno[i] = cpu_to_be32(NULLAGBLOCK);
+	}
+	freelist = XFS_BUF_TO_AGFL_BNO(mp, agfl_buf);
+
 	/*
 	 * do we have left-over blocks in the btree cursors that should
 	 * be used to fill the AGFL?
 	 */
 	if (bno_bt->num_free_blocks > 0 || bcnt_bt->num_free_blocks > 0)  {
 		/*
-		 * yes - grab the AGFL buffer
-		 */
-		agfl_buf = libxfs_getbuf(mp->m_dev,
-				XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-				mp->m_sb.sb_sectsize/BBSIZE);
-		agfl = XFS_BUF_TO_AGFL(agfl_buf);
-		freelist = XFS_BUF_TO_AGFL_BNO(mp, agfl_buf);
-		memset(agfl, 0, mp->m_sb.sb_sectsize);
-		/*
-		 * ok, now grab as many blocks as we can
+		 * yes, now grab as many blocks as we can
 		 */
 		i = j = 0;
 		while (bno_bt->num_free_blocks > 0 && i < XFS_AGFL_SIZE(mp))  {
@@ -1326,13 +1381,14 @@ build_agf_agfl(xfs_mount_t	*mp,
 		fprintf(stderr, "writing agfl for ag %u\n", agno);
 #endif
 
-		libxfs_writebuf(agfl_buf, 0);
 	} else  {
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
 	}
 
+	libxfs_writebuf(agfl_buf, 0);
+
 	ext_ptr = findbiggest_bcnt_extent(agno);
 	agf->agf_longest = cpu_to_be32((ext_ptr != NULL) ?
 						ext_ptr->ex_blockcount : 0);
@@ -1342,6 +1398,26 @@ build_agf_agfl(xfs_mount_t	*mp,
 
 	libxfs_writebuf(agf_buf, 0);
 
+	/*
+	 * now fix up the free list appropriately
+	 * XXX: code lifted from mkfs, shoul dbe shared.
+	 */
+	{
+		xfs_alloc_arg_t	args;
+		xfs_trans_t	*tp;
+
+		memset(&args, 0, sizeof(args));
+		args.tp = tp = libxfs_trans_alloc(mp, 0);
+		args.mp = mp;
+		args.agno = agno;
+		args.alignment = 1;
+		args.pag = xfs_perag_get(mp,agno);
+		libxfs_trans_reserve(tp, XFS_MIN_FREELIST(agf, mp), 0, 0, 0, 0);
+		libxfs_alloc_fix_freelist(&args, 0);
+		xfs_perag_put(args.pag);
+		libxfs_trans_commit(tp, 0);
+	}
+
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "wrote agf for ag %u, error = %d\n", agno, error);
 #endif
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 93b4146..7529f5d 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -221,7 +221,7 @@ pf_scan_lbtree(
 	int			rc;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
-			XFS_FSB_TO_BB(mp, 1), 0, NULL);
+			XFS_FSB_TO_BB(mp, 1), 0, &xfs_bmbt_buf_ops);
 	if (!bp)
 		return 0;
 
@@ -337,6 +337,11 @@ pf_read_inode_dirs(
 	int			hasdir = 0;
 	int			isadir;
 
+	bp->b_ops = &xfs_inode_buf_ops;
+	bp->b_ops->verify_read(bp);
+	if (bp->b_error)
+		return;
+
 	for (icnt = 0; icnt < (XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog); icnt++) {
 		dino = xfs_make_iptr(mp, bp, icnt);
 
diff --git a/repair/scan.c b/repair/scan.c
index 0b5ab1b..d58d55a 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -48,17 +48,6 @@ struct aghdr_cnts {
 	__uint64_t	ifreecount;
 };
 
-static void
-scanfunc_allocbt(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot,
-	__uint32_t		magic,
-	struct aghdr_cnts	*agcnts);
-
 void
 set_mp(xfs_mount_t *mpp)
 {
@@ -78,20 +67,23 @@ scan_sbtree(
 				xfs_agnumber_t		agno,
 				int			suspect,
 				int			isroot,
+				__uint32_t		magic,
 				void			*priv),
 	int		isroot,
-	void		*priv)
+	__uint32_t	magic,
+	void		*priv,
+	const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t	*bp;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
-			XFS_FSB_TO_BB(mp, 1), 0, NULL);
+			XFS_FSB_TO_BB(mp, 1), 0, ops);
 	if (!bp) {
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
 	}
 	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
-							isroot, priv);
+							isroot, magic, priv);
 	libxfs_putbuf(bp);
 }
 
@@ -114,7 +106,8 @@ scan_lbtree(
 				bmap_cursor_t		*bm_cursor,
 				int			isroot,
 				int			check_dups,
-				int			*dirty),
+				int			*dirty,
+				__uint64_t		magic),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -123,14 +116,16 @@ scan_lbtree(
 	blkmap_t	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
 	int		isroot,
-	int		check_dups)
+	int		check_dups,
+	__uint64_t	magic,
+	const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t	*bp;
 	int		err;
 	int		dirty = 0;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
-		      XFS_FSB_TO_BB(mp, 1), 0, NULL);
+		      XFS_FSB_TO_BB(mp, 1), 0, ops);
 	if (!bp)  {
 		do_error(_("can't read btree block %d/%d\n"),
 			XFS_FSB_TO_AGNO(mp, root),
@@ -139,7 +134,8 @@ scan_lbtree(
 	}
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
-			bm_cursor, isroot, check_dups, &dirty);
+			bm_cursor, isroot, check_dups, &dirty,
+			magic);
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
@@ -152,7 +148,7 @@ scan_lbtree(
 }
 
 int
-scanfunc_bmap(
+scan_bmapbt(
 	struct xfs_btree_block	*block,
 	int			level,
 	int			type,
@@ -165,7 +161,8 @@ scanfunc_bmap(
 	bmap_cursor_t		*bm_cursor,
 	int			isroot,
 	int			check_dups,
-	int			*dirty)
+	int			*dirty,
+	__uint64_t		magic)
 {
 	int			i;
 	int			err;
@@ -192,7 +189,7 @@ scanfunc_bmap(
 	 * another inode are claiming the same block but that's
 	 * highly unlikely.
 	 */
-	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != magic) {
 		do_warn(
 _("bad magic # %#x in inode %" PRIu64 " (%s fork) bmbt block %" PRIu64 "\n"),
 			be32_to_cpu(block->bb_magic), ino, forkname, bno);
@@ -206,6 +203,16 @@ _("expected level %d got %d in inode %" PRIu64 ", (%s fork) bmbt block %" PRIu64
 		return(1);
 	}
 
+	if (magic == XFS_BMAP_CRC_MAGIC) {
+		/* verify owner */
+		if (be64_to_cpu(block->bb_u.l.bb_owner) != ino) {
+			do_warn(
+_("expected owner inode %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
+				ino, be64_to_cpu(block->bb_u.l.bb_owner), bno);
+			return(1);
+		}
+	}
+
 	if (check_dups == 0)  {
 		/*
 		 * check sibling pointers. if bad we have a conflict
@@ -408,9 +415,10 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 			return(1);
 		}
 
-		err = scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap,
+		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups);
+				bm_cursor, 0, check_dups, magic,
+				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
 
@@ -481,35 +489,7 @@ _("bad fwd (right) sibling pointer (saw %" PRIu64 " should be NULLDFSBNO)\n"
 }
 
 static void
-scanfunc_bno(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot,
-	void			*agcnts)
-{
-	return scanfunc_allocbt(block, level, bno, agno,
-				suspect, isroot, XFS_ABTB_MAGIC, agcnts);
-}
-
-static void
-scanfunc_cnt(
-	struct xfs_btree_block	*block,
-	int			level,
-	xfs_agblock_t		bno,
-	xfs_agnumber_t		agno,
-	int			suspect,
-	int			isroot,
-	void			*agcnts)
-{
-	return scanfunc_allocbt(block, level, bno, agno,
-				suspect, isroot, XFS_ABTC_MAGIC, agcnts);
-}
-
-static void
-scanfunc_allocbt(
+scan_allocbt(
 	struct xfs_btree_block	*block,
 	int			level,
 	xfs_agblock_t		bno,
@@ -517,8 +497,9 @@ scanfunc_allocbt(
 	int			suspect,
 	int			isroot,
 	__uint32_t		magic,
-	struct aghdr_cnts	*agcnts)
+	void			*priv)
 {
+	struct aghdr_cnts	*agcnts = priv;
 	const char 		*name;
 	int			i;
 	xfs_alloc_ptr_t		*pp;
@@ -529,9 +510,19 @@ scanfunc_allocbt(
 	xfs_extlen_t		lastcount = 0;
 	xfs_agblock_t		lastblock = 0;
 
-	assert(magic == XFS_ABTB_MAGIC || magic == XFS_ABTC_MAGIC);
-
-	name = (magic == XFS_ABTB_MAGIC) ? "bno" : "cnt";
+	switch (magic) {
+	case XFS_ABTB_CRC_MAGIC:
+	case XFS_ABTB_MAGIC:
+		name = "bno";
+		break;
+	case XFS_ABTC_CRC_MAGIC:
+	case XFS_ABTC_MAGIC:
+		name = "cnt";
+		break;
+	default:
+		assert(0);
+		break;
+	}
 
 	if (be32_to_cpu(block->bb_magic) != magic) {
 		do_warn(_("bad magic # %#x in bt%s block %d/%d\n"),
@@ -615,7 +606,8 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				continue;
 			}
 
-			if (magic == XFS_ABTB_MAGIC) {
+			if (magic == XFS_ABTB_MAGIC ||
+			    magic == XFS_ABTB_CRC_MAGIC) {
 				if (b <= lastblock) {
 					do_warn(_(
 	"out-of-order bno btree record %d (%u %u) block %u/%u\n"),
@@ -648,7 +640,8 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 					 * no warning messages -- we'll catch
 					 * FREE1 blocks later
 					 */
-					if (magic == XFS_ABTC_MAGIC) {
+					if (magic == XFS_ABTC_MAGIC ||
+					    magic == XFS_ABTC_CRC_MAGIC) {
 						set_bmap_ext(agno, b, blen,
 							     XR_E_FREE);
 						break;
@@ -709,10 +702,20 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * as possible.
 		 */
 		if (bno != 0 && verify_agbno(mp, agno, bno)) {
-			scan_sbtree(bno, level, agno, suspect,
-				    (magic == XFS_ABTB_MAGIC) ?
-				     scanfunc_bno : scanfunc_cnt, 0,
-				     (void *)agcnts);
+			switch (magic) {
+			case XFS_ABTB_CRC_MAGIC:
+			case XFS_ABTB_MAGIC:
+				scan_sbtree(bno, level, agno, suspect,
+					    scan_allocbt, 0, magic, priv,
+					    &xfs_allocbt_buf_ops);
+				break;
+			case XFS_ABTC_CRC_MAGIC:
+			case XFS_ABTC_MAGIC:
+				scan_sbtree(bno, level, agno, suspect,
+					    scan_allocbt, 0, magic, priv,
+					    &xfs_allocbt_buf_ops);
+				break;
+			}
 		}
 	}
 }
@@ -896,13 +899,14 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
  * that we aren't sure about go into the uncertain list.
  */
 static void
-scanfunc_ino(
+scan_inobt(
 	struct xfs_btree_block	*block,
 	int			level,
 	xfs_agblock_t		bno,
 	xfs_agnumber_t		agno,
 	int			suspect,
 	int			isroot,
+	__uint32_t		magic,
 	void			*priv)
 {
 	struct aghdr_cnts	*agcnts = priv;
@@ -915,7 +919,7 @@ scanfunc_ino(
 
 	hdr_errors = 0;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != magic) {
 		do_warn(_("bad magic # %#x in inobt block %d/%d\n"),
 			be32_to_cpu(block->bb_magic), agno, bno);
 		hdr_errors++;
@@ -1032,7 +1036,8 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		if (be32_to_cpu(pp[i]) != 0 && verify_agbno(mp, agno,
 							be32_to_cpu(pp[i])))
 			scan_sbtree(be32_to_cpu(pp[i]), level, agno,
-					suspect, scanfunc_ino, 0, priv);
+					suspect, scan_inobt, 0, magic, priv,
+					&xfs_inobt_buf_ops);
 	}
 }
 
@@ -1109,11 +1114,15 @@ validate_agf(
 	struct aghdr_cnts	*agcnts)
 {
 	xfs_agblock_t		bno;
+	__uint32_t		magic;
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_ABTB_CRC_MAGIC
+							 : XFS_ABTB_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
-			    agno, 0, scanfunc_bno, 1, agcnts);
+			    agno, 0, scan_allocbt, 1, magic, agcnts,
+			    &xfs_allocbt_buf_ops);
 	} else {
 		do_warn(_("bad agbno %u for btbno root, agno %d\n"),
 			bno, agno);
@@ -1121,8 +1130,11 @@ validate_agf(
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_ABTC_CRC_MAGIC
+							 : XFS_ABTC_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
-			    agno, 0, scanfunc_cnt, 1, agcnts);
+			    agno, 0, scan_allocbt, 1, magic, agcnts,
+			    &xfs_allocbt_buf_ops);
 	} else  {
 		do_warn(_("bad agbno %u for btbcnt root, agno %d\n"),
 			bno, agno);
@@ -1153,11 +1165,15 @@ validate_agi(
 {
 	xfs_agblock_t		bno;
 	int			i;
+	__uint32_t		magic;
 
 	bno = be32_to_cpu(agi->agi_root);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_IBT_CRC_MAGIC
+							 : XFS_IBT_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
-			    agno, 0, scanfunc_ino, 1, agcnts);
+			    agno, 0, scan_inobt, 1, magic, agcnts,
+			    &xfs_inobt_buf_ops);
 	} else {
 		do_warn(_("bad agbno %u for inobt root, agno %d\n"),
 			be32_to_cpu(agi->agi_root), agno);
diff --git a/repair/scan.h b/repair/scan.h
index 9f945cf..92593e9 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -35,7 +35,8 @@ int scan_lbtree(
 				bmap_cursor_t		*bm_cursor,
 				int			isroot,
 				int			check_dups,
-				int			*dirty),
+				int			*dirty,
+				__uint64_t		magic),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -44,9 +45,11 @@ int scan_lbtree(
 	struct blkmap	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
 	int		isroot,
-	int		check_dups);
+	int		check_dups,
+	__uint64_t	magic,
+	const struct xfs_buf_ops *ops);
 
-int scanfunc_bmap(
+int scan_bmapbt(
 	struct xfs_btree_block	*block,
 	int			level,
 	int			type,
@@ -59,7 +62,8 @@ int scanfunc_bmap(
 	bmap_cursor_t		*bm_cursor,
 	int			isroot,
 	int			check_dups,
-	int			*dirty);
+	int			*dirty,
+	__uint64_t		magic);
 
 void
 scan_ags(
diff --git a/repair/versions.c b/repair/versions.c
index 957766a..c11a728 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -165,7 +165,7 @@ _("This filesystem contains features not understood by this program.\n"));
 		return(1);
 	}
 
-	if (XFS_SB_VERSION_NUM(sb) == XFS_SB_VERSION_4)  {
+	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_4)  {
 		if (!fs_sb_feature_bits_allowed)  {
 			if (!no_modify)  {
 				do_warn(
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 7623560..4708c5c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -611,7 +611,7 @@ main(int argc, char **argv)
 	glob_agcount = mp->m_sb.sb_agcount;
 
 	chunks_pblock = mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
-	max_symlink_blocks = howmany(MAXPATHLEN - 1, mp->m_sb.sb_blocksize);
+	max_symlink_blocks = libxfs_symlink_blocks(mp, MAXPATHLEN);
 	inodes_per_cluster = MAX(mp->m_sb.sb_inopblock,
 			XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
