Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF94D7F53
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF3178F8052
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 16PNpArHkA6cMdeO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:35 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvl-0001OI-Py
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:33 +0000
Message-Id: <20131123151533.726941044@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: let iop_format write directly into the linear buffer
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-xfs-let-iop_format-write-directly-into-the-linear-bu.patch
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

Instead of setting up pointers to memory locations in iop_format which then
get copied into the CIL linear buffer after return move the copy into
the individual inode items.  This avoids the need to always have a memory
block in the exact same layout that gets written into the log around, and
allow the log items to be much more flexible in their in-memory layouts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c     |   89 ++++++++++++-------
 fs/xfs/xfs_dquot_item.c   |   35 +++++---
 fs/xfs/xfs_extfree_item.c |   33 ++++---
 fs/xfs/xfs_icreate_item.c |   12 ++-
 fs/xfs/xfs_inode_fork.c   |   15 ++--
 fs/xfs/xfs_inode_item.c   |  209 ++++++++++++++++-----------------------------
 fs/xfs/xfs_inode_item.h   |    4 -
 fs/xfs/xfs_log.h          |   30 +++++++
 fs/xfs/xfs_log_cil.c      |   35 +-------
 fs/xfs/xfs_trans.h        |    2 +-
 10 files changed, 222 insertions(+), 242 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a64f67b..067a840 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -182,10 +182,44 @@ xfs_buf_item_size(
 	trace_xfs_buf_item_size(bip);
 }
 
+static inline struct xfs_log_iovec *
+xfs_buf_item_set_iovec(
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	*vec,
+	struct xfs_buf		*bp,
+	uint			offset,
+	int			first_bit,
+	uint			len)
+{
+	vec = xlog_next_iovec(lv, vec);
+
+	offset += first_bit * XFS_BLF_CHUNK;
+	len *= XFS_BLF_CHUNK;
+
+	memcpy(vec->i_addr, xfs_buf_offset(bp, offset), len);
+	vec->i_len = len;
+	vec->i_type = XLOG_REG_TYPE_BCHUNK;
+
+	return vec;
+}
+
+static inline bool
+xfs_buf_item_straddle(
+	struct xfs_buf		*bp,
+	uint			offset,
+	int			next_bit,
+	int			last_bit)
+{
+	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
+		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
+		 XFS_BLF_CHUNK);
+}
+
 static struct xfs_log_iovec *
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
-	struct xfs_log_iovec	*vecp,
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	*vec,
 	uint			offset,
 	struct xfs_buf_log_format *blfp)
 {
@@ -196,7 +230,6 @@ xfs_buf_item_format_segment(
 	int		last_bit;
 	int		next_bit;
 	uint		nbits;
-	uint		buffer_offset;
 
 	/* copy the flags across from the base format item */
 	blfp->blf_flags = bip->__bli_format.blf_flags;
@@ -218,10 +251,14 @@ xfs_buf_item_format_segment(
 		goto out;
 	}
 
-	vecp->i_addr = blfp;
-	vecp->i_len = base_size;
-	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
-	vecp++;
+	if (vec)
+		vec = xlog_next_iovec(lv, vec);
+	else
+		vec = xlog_first_iovec(lv);
+
+	blfp = memcpy(vec->i_addr, blfp, base_size);
+	vec->i_len = base_size;
+	vec->i_type = XLOG_REG_TYPE_BFORMAT;
 	nvecs = 1;
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -261,33 +298,16 @@ xfs_buf_item_format_segment(
 		 * keep counting and scanning.
 		 */
 		if (next_bit == -1) {
-			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
-			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLF_CHUNK;
-			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
+			vec = xfs_buf_item_set_iovec(lv, vec, bp, offset,
+						     first_bit, nbits);
 			nvecs++;
 			break;
-		} else if (next_bit != last_bit + 1) {
-			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
-			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLF_CHUNK;
-			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
+		} else if (next_bit != last_bit + 1 ||
+		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
+			vec = xfs_buf_item_set_iovec(lv, vec, bp, offset,
+						     first_bit, nbits);
 			nvecs++;
-			vecp++;
-			first_bit = next_bit;
-			last_bit = next_bit;
-			nbits = 1;
-		} else if (xfs_buf_offset(bp, offset +
-					      (next_bit << XFS_BLF_SHIFT)) !=
-			   (xfs_buf_offset(bp, offset +
-					       (last_bit << XFS_BLF_SHIFT)) +
-			    XFS_BLF_CHUNK)) {
-			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
-			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLF_CHUNK;
-			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
-			nvecs++;
-			vecp++;
+
 			first_bit = next_bit;
 			last_bit = next_bit;
 			nbits = 1;
@@ -298,7 +318,7 @@ xfs_buf_item_format_segment(
 	}
 out:
 	blfp->blf_size = nvecs;
-	return vecp;
+	return vec;
 }
 
 /*
@@ -310,10 +330,11 @@ out:
 STATIC void
 xfs_buf_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_iovec	*vec = NULL;
 	uint			offset = 0;
 	int			i;
 
@@ -354,11 +375,13 @@ xfs_buf_item_format(
 	}
 
 	for (i = 0; i < bip->bli_format_count; i++) {
-		vecp = xfs_buf_item_format_segment(bip, vecp, offset,
+		vec = xfs_buf_item_format_segment(bip, lv, vec, offset,
 						&bip->bli_formats[i]);
 		offset += bp->b_maps[i].bm_len;
 	}
 
+	xlog_last_iovec(lv, vec);
+
 	/*
 	 * Check to make sure everything is consistent.
 	 */
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 92e5f62..5f446a7 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -57,20 +57,24 @@ xfs_qm_dquot_logitem_size(
 STATIC void
 xfs_qm_dquot_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*logvec)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
-
-	logvec->i_addr = &qlip->qli_format;
-	logvec->i_len  = sizeof(xfs_dq_logformat_t);
-	logvec->i_type = XLOG_REG_TYPE_QFORMAT;
-	logvec++;
-	logvec->i_addr = &qlip->qli_dquot->q_core;
-	logvec->i_len  = sizeof(xfs_disk_dquot_t);
-	logvec->i_type = XLOG_REG_TYPE_DQUOT;
+	struct xfs_log_iovec	*vec;
 
 	qlip->qli_format.qlf_size = 2;
 
+	vec = xlog_first_iovec(lv);
+	memcpy(vec->i_addr, &qlip->qli_format, sizeof(xfs_dq_logformat_t));
+	vec->i_len = sizeof(xfs_dq_logformat_t);
+	vec->i_type = XLOG_REG_TYPE_QFORMAT;
+
+	vec = xlog_next_iovec(lv, vec);
+	memcpy(vec->i_addr, &qlip->qli_dquot->q_core, sizeof(xfs_disk_dquot_t));
+	vec->i_len = sizeof(xfs_disk_dquot_t);
+	vec->i_type = XLOG_REG_TYPE_DQUOT;
+
+	xlog_last_iovec(lv, vec);
 }
 
 /*
@@ -304,16 +308,21 @@ xfs_qm_qoff_logitem_size(
 STATIC void
 xfs_qm_qoff_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
+	struct xfs_log_iovec *vec;
 
 	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
 
-	log_vector->i_addr = &qflip->qql_format;
-	log_vector->i_len = sizeof(xfs_qoff_logitem_t);
-	log_vector->i_type = XLOG_REG_TYPE_QUOTAOFF;
 	qflip->qql_format.qf_size = 1;
+
+	vec = xlog_first_iovec(lv);
+	memcpy(vec->i_addr, &qflip->qql_format, sizeof(xfs_qoff_logitem_t));
+	vec->i_len = sizeof(xfs_qoff_logitem_t);
+	vec->i_type = XLOG_REG_TYPE_QUOTAOFF;
+
+	xlog_last_iovec(lv, vec);
 }
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3680d04..94bf5e7 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
+#include "xfs_log.h"
 
 
 kmem_zone_t	*xfs_efi_zone;
@@ -101,9 +102,11 @@ xfs_efi_item_size(
 STATIC void
 xfs_efi_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	struct xfs_log_iovec	*vec;
+	int			size;
 
 	ASSERT(atomic_read(&efip->efi_next_extent) ==
 				efip->efi_format.efi_nextents);
@@ -111,12 +114,16 @@ xfs_efi_item_format(
 	efip->efi_format.efi_type = XFS_LI_EFI;
 	efip->efi_format.efi_size = 1;
 
-	log_vector->i_addr = &efip->efi_format;
-	log_vector->i_len = xfs_efi_item_sizeof(efip);
-	log_vector->i_type = XLOG_REG_TYPE_EFI_FORMAT;
-	ASSERT(log_vector->i_len >= sizeof(xfs_efi_log_format_t));
-}
+	size = xfs_efi_item_sizeof(efip);
+	ASSERT(size >= sizeof(xfs_efi_log_format_t));
+
+	vec = xlog_first_iovec(lv);
+	memcpy(vec->i_addr, &efip->efi_format, size);
+	vec->i_len = size;
+	vec->i_type = XLOG_REG_TYPE_EFI_FORMAT;
 
+	xlog_last_iovec(lv, vec);
+}
 
 /*
  * Pinning has no meaning for an efi item, so just return.
@@ -368,19 +375,23 @@ xfs_efd_item_size(
 STATIC void
 xfs_efd_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+	struct xfs_log_iovec	*vec;
 
 	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
 
 	efdp->efd_format.efd_type = XFS_LI_EFD;
 	efdp->efd_format.efd_size = 1;
 
-	log_vector->i_addr = &efdp->efd_format;
-	log_vector->i_len = xfs_efd_item_sizeof(efdp);
-	log_vector->i_type = XLOG_REG_TYPE_EFD_FORMAT;
-	ASSERT(log_vector->i_len >= sizeof(xfs_efd_log_format_t));
+	vec = xlog_first_iovec(lv);
+	memcpy(vec->i_addr, &efdp->efd_format, xfs_efd_item_sizeof(efdp));
+	vec->i_len = xfs_efd_item_sizeof(efdp);
+	vec->i_type = XLOG_REG_TYPE_EFD_FORMAT;
+	ASSERT(vec->i_len >= sizeof(xfs_efd_log_format_t));
+
+	xlog_last_iovec(lv, vec);
 }
 
 /*
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index d2eaccf..f6115c3 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -28,6 +28,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 #include "xfs_icreate_item.h"
+#include "xfs_log.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -58,13 +59,16 @@ xfs_icreate_item_size(
 STATIC void
 xfs_icreate_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
+	struct xfs_log_iovec *vec;
 
-	log_vector->i_addr = (xfs_caddr_t)&icp->ic_format;
-	log_vector->i_len  = sizeof(struct xfs_icreate_log);
-	log_vector->i_type = XLOG_REG_TYPE_ICREATE;
+	vec = xlog_first_iovec(lv);
+	memcpy(vec->i_addr, &icp->ic_format, sizeof(struct xfs_icreate_log));
+	vec->i_len  = sizeof(struct xfs_icreate_log);
+	vec->i_type = XLOG_REG_TYPE_ICREATE;
+	xlog_last_iovec(lv, vec);
 }
 
 
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index cfee14a..06abaee 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -721,15 +721,16 @@ xfs_idestroy_fork(
 }
 
 /*
- * xfs_iextents_copy()
+ * Convert in-core extents to on-disk form
  *
- * This is called to copy the REAL extents (as opposed to the delayed
- * allocation extents) from the inode into the given buffer.  It
- * returns the number of bytes copied into the buffer.
+ * For either the data or attr fork in extent format, we need to endian convert
+ * the in-core extent as we place them into the on-disk inode.
  *
- * If there are no delayed allocation extents, then we can just
- * memcpy() the extents into the buffer.  Otherwise, we need to
- * examine each extent in turn and skip those which are delayed.
+ * In the case of the data fork, the in-core and on-disk fork sizes can be
+ * different due to delayed allocation extents. We only copy on-disk extents
+ * here, so callers must always use the physical fork size to determine the
+ * size of the buffer passed to this routine.  We will return the size actually
+ * used.
  */
 int
 xfs_iextents_copy(
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 7c0d391f..fbdcde1 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -30,6 +30,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
 #include "xfs_dinode.h"
+#include "xfs_log.h"
 
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
@@ -137,41 +138,6 @@ xfs_inode_item_size(
 }
 
 /*
- * xfs_inode_item_format_extents - convert in-core extents to on-disk form
- *
- * For either the data or attr fork in extent format, we need to endian convert
- * the in-core extent as we place them into the on-disk inode. In this case, we
- * need to do this conversion before we write the extents into the log. Because
- * we don't have the disk inode to write into here, we allocate a buffer and
- * format the extents into it via xfs_iextents_copy(). We free the buffer in
- * the unlock routine after the copy for the log has been made.
- *
- * In the case of the data fork, the in-core and on-disk fork sizes can be
- * different due to delayed allocation extents. We only log on-disk extents
- * here, so always use the physical fork size to determine the size of the
- * buffer we need to allocate.
- */
-STATIC void
-xfs_inode_item_format_extents(
-	struct xfs_inode	*ip,
-	struct xfs_log_iovec	*vecp,
-	int			whichfork,
-	int			type)
-{
-	xfs_bmbt_rec_t		*ext_buffer;
-
-	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork), KM_SLEEP);
-	if (whichfork == XFS_DATA_FORK)
-		ip->i_itemp->ili_extents_buf = ext_buffer;
-	else
-		ip->i_itemp->ili_aextents_buf = ext_buffer;
-
-	vecp->i_addr = ext_buffer;
-	vecp->i_len = xfs_iextents_copy(ip, ext_buffer, whichfork);
-	vecp->i_type = type;
-}
-
-/*
  * This is called to fill in the vector of log iovecs for the
  * given inode log item.  It fills the first item with an inode
  * log format structure, the second with the on-disk inode structure,
@@ -181,24 +147,29 @@ xfs_inode_item_format_extents(
 STATIC void
 xfs_inode_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_log_iovec	*vec;
+	struct xfs_inode_log_format *ilf;
+	uint			size;
 	uint			nvecs;
 	size_t			data_bytes;
 	xfs_mount_t		*mp;
 
-	vecp->i_addr = &iip->ili_format;
-	vecp->i_len  = sizeof(xfs_inode_log_format_t);
-	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
-	vecp++;
-	nvecs	     = 1;
-
-	vecp->i_addr = &ip->i_d;
-	vecp->i_len  = xfs_icdinode_size(ip->i_d.di_version);
-	vecp->i_type = XLOG_REG_TYPE_ICORE;
-	vecp++;
+	vec = xlog_first_iovec(lv);
+	ilf = memcpy(vec->i_addr, &iip->ili_format,
+		     sizeof(struct xfs_inode_log_format));
+	vec->i_len = sizeof(struct xfs_inode_log_format);
+	vec->i_type = XLOG_REG_TYPE_IFORMAT;
+	nvecs = 1;
+
+	vec = xlog_next_iovec(lv, vec);
+	size = xfs_icdinode_size(ip->i_d.di_version);
+	memcpy(vec->i_addr, &ip->i_d, size);
+	vec->i_len = size;
+	vec->i_type = XLOG_REG_TYPE_ICORE;
 	nvecs++;
 
 	/*
@@ -210,9 +181,10 @@ xfs_inode_item_format(
 	 * has a new version number, then we don't bother converting back.
 	 */
 	mp = ip->i_mount;
-	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
+	ASSERT(ip->i_d.di_version == 1 ||
+	       xfs_sb_version_hasnlink(&ip->i_mount->m_sb));
 	if (ip->i_d.di_version == 1) {
-		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
+		if (!xfs_sb_version_hasnlink(&ip->i_mount->m_sb)) {
 			/*
 			 * Convert it back.
 			 */
@@ -241,29 +213,15 @@ xfs_inode_item_format(
 		    ip->i_df.if_bytes > 0) {
 			ASSERT(ip->i_df.if_u1.if_extents != NULL);
 			ASSERT(ip->i_df.if_bytes / sizeof(xfs_bmbt_rec_t) > 0);
-			ASSERT(iip->ili_extents_buf == NULL);
-
-#ifdef XFS_NATIVE_HOST
-                       if (ip->i_d.di_nextents == ip->i_df.if_bytes /
-                                               (uint)sizeof(xfs_bmbt_rec_t)) {
-				/*
-				 * There are no delayed allocation
-				 * extents, so just point to the
-				 * real extents array.
-				 */
-				vecp->i_addr = ip->i_df.if_u1.if_extents;
-				vecp->i_len = ip->i_df.if_bytes;
-				vecp->i_type = XLOG_REG_TYPE_IEXT;
-			} else
-#endif
-			{
-				xfs_inode_item_format_extents(ip, vecp,
-					XFS_DATA_FORK, XLOG_REG_TYPE_IEXT);
-			}
-			ASSERT(vecp->i_len <= ip->i_df.if_bytes);
-			iip->ili_format.ilf_dsize = vecp->i_len;
-			vecp++;
+
+			vec = xlog_next_iovec(lv, vec);
+			vec->i_len = xfs_iextents_copy(ip, vec->i_addr,
+						       XFS_DATA_FORK);
+			vec->i_type = XLOG_REG_TYPE_IEXT;
 			nvecs++;
+
+			ASSERT(vec->i_len <= ip->i_df.if_bytes);
+			ilf->ilf_dsize = vec->i_len;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DEXT;
 		}
@@ -277,12 +235,15 @@ xfs_inode_item_format(
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			ASSERT(ip->i_df.if_broot != NULL);
-			vecp->i_addr = ip->i_df.if_broot;
-			vecp->i_len = ip->i_df.if_broot_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IBROOT;
-			vecp++;
+
+			vec = xlog_next_iovec(lv, vec);
+			memcpy(vec->i_addr, ip->i_df.if_broot,
+			       ip->i_df.if_broot_bytes);
+			vec->i_len = ip->i_df.if_broot_bytes;
+			vec->i_type = XLOG_REG_TYPE_IBROOT;
 			nvecs++;
-			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
+
+			ilf->ilf_dsize = ip->i_df.if_broot_bytes;
 		} else {
 			ASSERT(!(iip->ili_fields &
 				 XFS_ILOG_DBROOT));
@@ -299,7 +260,6 @@ xfs_inode_item_format(
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_d.di_size > 0);
 
-			vecp->i_addr = ip->i_df.if_u1.if_data;
 			/*
 			 * Round i_bytes up to a word boundary.
 			 * The underlying memory is guaranteed to
@@ -308,11 +268,14 @@ xfs_inode_item_format(
 			data_bytes = roundup(ip->i_df.if_bytes, 4);
 			ASSERT((ip->i_df.if_real_bytes == 0) ||
 			       (ip->i_df.if_real_bytes == data_bytes));
-			vecp->i_len = (int)data_bytes;
-			vecp->i_type = XLOG_REG_TYPE_ILOCAL;
-			vecp++;
+
+			vec = xlog_next_iovec(lv, vec);
+			memcpy(vec->i_addr, ip->i_df.if_u1.if_data, data_bytes);
+			vec->i_len = data_bytes;
+			vec->i_type = XLOG_REG_TYPE_ILOCAL;
 			nvecs++;
-			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
+
+			ilf->ilf_dsize = (unsigned)data_bytes;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DDATA;
 		}
@@ -322,20 +285,16 @@ xfs_inode_item_format(
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
 			  XFS_ILOG_DEXT | XFS_ILOG_UUID);
-		if (iip->ili_fields & XFS_ILOG_DEV) {
-			iip->ili_format.ilf_u.ilfu_rdev =
-				ip->i_df.if_u2.if_rdev;
-		}
+		if (iip->ili_fields & XFS_ILOG_DEV)
+			ilf->ilf_u.ilfu_rdev = ip->i_df.if_u2.if_rdev;
 		break;
 
 	case XFS_DINODE_FMT_UUID:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
 			  XFS_ILOG_DEXT | XFS_ILOG_DEV);
-		if (iip->ili_fields & XFS_ILOG_UUID) {
-			iip->ili_format.ilf_u.ilfu_uuid =
-				ip->i_df.if_u2.if_uuid;
-		}
+		if (iip->ili_fields & XFS_ILOG_UUID)
+			ilf->ilf_u.ilfu_uuid = ip->i_df.if_u2.if_uuid;
 		break;
 
 	default:
@@ -363,22 +322,14 @@ xfs_inode_item_format(
 			ASSERT(ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) ==
 				ip->i_d.di_anextents);
 			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
-#ifdef XFS_NATIVE_HOST
-			/*
-			 * There are not delayed allocation extents
-			 * for attributes, so just point at the array.
-			 */
-			vecp->i_addr = ip->i_afp->if_u1.if_extents;
-			vecp->i_len = ip->i_afp->if_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IATTR_EXT;
-#else
-			ASSERT(iip->ili_aextents_buf == NULL);
-			xfs_inode_item_format_extents(ip, vecp,
-					XFS_ATTR_FORK, XLOG_REG_TYPE_IATTR_EXT);
-#endif
-			iip->ili_format.ilf_asize = vecp->i_len;
-			vecp++;
+
+			vec = xlog_next_iovec(lv, vec);
+			vec->i_len = xfs_iextents_copy(ip, vec->i_addr,
+						       XFS_ATTR_FORK);
+			vec->i_type = XLOG_REG_TYPE_IATTR_EXT;
 			nvecs++;
+
+			ilf->ilf_asize = vec->i_len;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_AEXT;
 		}
@@ -392,12 +343,14 @@ xfs_inode_item_format(
 		    ip->i_afp->if_broot_bytes > 0) {
 			ASSERT(ip->i_afp->if_broot != NULL);
 
-			vecp->i_addr = ip->i_afp->if_broot;
-			vecp->i_len = ip->i_afp->if_broot_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IATTR_BROOT;
-			vecp++;
+			vec = xlog_next_iovec(lv, vec);
+			memcpy(vec->i_addr, ip->i_afp->if_broot,
+			       ip->i_afp->if_broot_bytes);
+			vec->i_len = ip->i_afp->if_broot_bytes;
+			vec->i_type = XLOG_REG_TYPE_IATTR_BROOT;
 			nvecs++;
-			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
+
+			ilf->ilf_asize = ip->i_afp->if_broot_bytes;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ABROOT;
 		}
@@ -411,7 +364,6 @@ xfs_inode_item_format(
 		    ip->i_afp->if_bytes > 0) {
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 
-			vecp->i_addr = ip->i_afp->if_u1.if_data;
 			/*
 			 * Round i_bytes up to a word boundary.
 			 * The underlying memory is guaranteed to
@@ -420,11 +372,15 @@ xfs_inode_item_format(
 			data_bytes = roundup(ip->i_afp->if_bytes, 4);
 			ASSERT((ip->i_afp->if_real_bytes == 0) ||
 			       (ip->i_afp->if_real_bytes == data_bytes));
-			vecp->i_len = (int)data_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IATTR_LOCAL;
-			vecp++;
+
+			vec = xlog_next_iovec(lv, vec);
+			memcpy(vec->i_addr, ip->i_afp->if_u1.if_data,
+			       data_bytes);
+			vec->i_len = data_bytes;
+			vec->i_type = XLOG_REG_TYPE_IATTR_LOCAL;
 			nvecs++;
-			iip->ili_format.ilf_asize = (unsigned)data_bytes;
+
+			ilf->ilf_asize = (unsigned)data_bytes;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ADATA;
 		}
@@ -436,18 +392,18 @@ xfs_inode_item_format(
 	}
 
 out:
+	xlog_last_iovec(lv, vec);
 	/*
 	 * Now update the log format that goes out to disk from the in-core
 	 * values.  We always write the inode core to make the arithmetic
 	 * games in recovery easier, which isn't a big deal as just about any
 	 * transaction would dirty it anyway.
 	 */
-	iip->ili_format.ilf_fields = XFS_ILOG_CORE |
+	ilf->ilf_fields = XFS_ILOG_CORE |
 		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
-	iip->ili_format.ilf_size = nvecs;
+	ilf->ilf_size = nvecs;
 }
 
-
 /*
  * This is called to pin the inode associated with the inode log
  * item in memory so it cannot be written out.
@@ -563,27 +519,6 @@ xfs_inode_item_unlock(
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	/*
-	 * If the inode needed a separate buffer with which to log
-	 * its extents, then free it now.
-	 */
-	if (iip->ili_extents_buf != NULL) {
-		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS);
-		ASSERT(ip->i_d.di_nextents > 0);
-		ASSERT(iip->ili_fields & XFS_ILOG_DEXT);
-		ASSERT(ip->i_df.if_bytes > 0);
-		kmem_free(iip->ili_extents_buf);
-		iip->ili_extents_buf = NULL;
-	}
-	if (iip->ili_aextents_buf != NULL) {
-		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS);
-		ASSERT(ip->i_d.di_anextents > 0);
-		ASSERT(iip->ili_fields & XFS_ILOG_AEXT);
-		ASSERT(ip->i_afp->if_bytes > 0);
-		kmem_free(iip->ili_aextents_buf);
-		iip->ili_aextents_buf = NULL;
-	}
-
 	lock_flags = iip->ili_lock_flags;
 	iip->ili_lock_flags = 0;
 	if (lock_flags)
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index dce4d65..29b5f2b 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -34,10 +34,6 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
-						      data exts */
-	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
-						      attr exts */
 	xfs_inode_log_format_t	ili_format;	   /* logged structure */
 } xfs_inode_log_item_t;
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e148719..3769830 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -30,6 +30,36 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
+static inline struct xfs_log_iovec *
+xlog_first_iovec(struct xfs_log_vec *lv)
+{
+	struct xfs_log_iovec *vec = &lv->lv_iovecp[0];
+
+	vec->i_addr = lv->lv_buf;
+	lv->lv_buf_len = 0;
+	return vec;
+}
+
+static inline struct xfs_log_iovec *
+xlog_next_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *prev)
+{
+	struct xfs_log_iovec *vec;
+
+	ASSERT(prev - lv->lv_iovecp < lv->lv_niovecs);
+
+	vec = prev + 1;
+	vec->i_addr = prev->i_addr + prev->i_len;
+	lv->lv_buf_len += prev->i_len;
+	return vec;
+}
+
+static inline void
+xlog_last_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *prev)
+{
+	ASSERT(prev - lv->lv_iovecp < lv->lv_niovecs);
+	lv->lv_buf_len += prev->i_len;
+}
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5eb51fc..8d5f2ea 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -82,36 +82,6 @@ xlog_cil_init_post_recovery(
 								log->l_curr_block);
 }
 
-STATIC int
-xlog_cil_lv_item_format(
-	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
-{
-	int	index;
-	char	*ptr;
-
-	/* format new vectors into array */
-	lip->li_ops->iop_format(lip, lv->lv_iovecp);
-
-	/* copy data into existing array */
-	ptr = lv->lv_buf;
-	for (index = 0; index < lv->lv_niovecs; index++) {
-		struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
-
-		memcpy(ptr, vec->i_addr, vec->i_len);
-		vec->i_addr = ptr;
-		ptr += vec->i_len;
-	}
-
-	/*
-	 * some size calculations for log vectors over-estimate, so the caller
-	 * doesn't know the amount of space actually used by the item. Return
-	 * the byte count to the caller so they can check and store it
-	 * appropriately.
-	 */
-	return ptr - lv->lv_buf;
-}
-
 /*
  * Prepare the log item for insertion into the CIL. Calculate the difference in
  * log space and vectors it will consume, and if it is a new item pin it as
@@ -259,7 +229,7 @@ xlog_cil_insert_format_items(
 			lv->lv_niovecs = niovecs;
 			lv->lv_buf = (char *)lv + buf_size - nbytes;
 
-			lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
+			lip->li_ops->iop_format(lip, lv);
 			goto insert;
 		}
 
@@ -281,7 +251,8 @@ xlog_cil_insert_format_items(
 		/* The allocated data region lies beyond the iovec region */
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
 
-		lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
+		/* Format new vectors into array */
+		lip->li_ops->iop_format(lip, lv);
 insert:
 		ASSERT(lv->lv_buf_len <= nbytes);
 		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9b96d35..b5bc1ab 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -64,7 +64,7 @@ typedef struct xfs_log_item {
 
 struct xfs_item_ops {
 	void (*iop_size)(xfs_log_item_t *, int *, int *);
-	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
+	void (*iop_format)(xfs_log_item_t *, struct xfs_log_vec *);
 	void (*iop_pin)(xfs_log_item_t *);
 	void (*iop_unpin)(xfs_log_item_t *, int remove);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
