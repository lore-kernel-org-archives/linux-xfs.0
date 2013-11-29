Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B0B37F50
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D64E68F8068
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 2mL47Bql5CgmCpRj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcG-0000BM-VS
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:01 +0000
Message-Id: <20131129084000.853201203@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/10] xfs: introduce xlog_copy_iovec
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline; filename=0005-xfs-introduce-xlog_copy_iovec.patch
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

Add a helper to abstract out filling the log iovecs in the log item format
handlers.  This will allow us to change the way we do the log item
formatting more easily.

The copy in the name is a bit confusing for now as it just assigns a
pointer and lets the CIL code perform the copy, but that will change
soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c     |   30 +++++-------
 fs/xfs/xfs_dquot_item.c   |   25 +++++-----
 fs/xfs/xfs_extfree_item.c |   19 ++++----
 fs/xfs/xfs_icreate_item.c |    9 ++--
 fs/xfs/xfs_inode_item.c   |  115 ++++++++++++++++++++-------------------------
 fs/xfs/xfs_log.h          |   13 +++++
 6 files changed, 103 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a30c1fb..d49419d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -182,20 +182,18 @@ xfs_buf_item_size(
 	trace_xfs_buf_item_size(bip);
 }
 
-static inline struct xfs_log_iovec *
+static inline void
 xfs_buf_item_copy_iovec(
-	struct xfs_log_iovec	*vecp,
+	struct xfs_log_iovec	**vecp,
 	struct xfs_buf		*bp,
 	uint			offset,
 	int			first_bit,
 	uint			nbits)
 {
 	offset += first_bit * XFS_BLF_CHUNK;
-
-	vecp->i_type = XLOG_REG_TYPE_BCHUNK;
-	vecp->i_addr = xfs_buf_offset(bp, offset);
-	vecp->i_len = nbits * XFS_BLF_CHUNK;
-	return vecp + 1;
+	xlog_copy_iovec(vecp, XLOG_REG_TYPE_BCHUNK,
+			xfs_buf_offset(bp, offset),
+			nbits * XFS_BLF_CHUNK);
 }
 
 static inline bool
@@ -210,10 +208,10 @@ xfs_buf_item_straddle(
 		 XFS_BLF_CHUNK);
 }
 
-static struct xfs_log_iovec *
+static void
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
-	struct xfs_log_iovec	*vecp,
+	struct xfs_log_iovec	**vecp,
 	uint			offset,
 	struct xfs_buf_log_format *blfp)
 {
@@ -245,10 +243,7 @@ xfs_buf_item_format_segment(
 		goto out;
 	}
 
-	vecp->i_addr = blfp;
-	vecp->i_len = base_size;
-	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
-	vecp++;
+	xlog_copy_iovec(vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
 	nvecs = 1;
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -291,8 +286,8 @@ xfs_buf_item_format_segment(
 			break;
 		} else if (next_bit != last_bit + 1 ||
 		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
-			vecp = xfs_buf_item_copy_iovec(vecp, bp, offset,
-						       first_bit, nbits);
+			xfs_buf_item_copy_iovec(vecp, bp, offset,
+						first_bit, nbits);
 			nvecs++;
 			first_bit = next_bit;
 			last_bit = next_bit;
@@ -304,7 +299,6 @@ xfs_buf_item_format_segment(
 	}
 out:
 	blfp->blf_size = nvecs;
-	return vecp;
 }
 
 /*
@@ -360,8 +354,8 @@ xfs_buf_item_format(
 	}
 
 	for (i = 0; i < bip->bli_format_count; i++) {
-		vecp = xfs_buf_item_format_segment(bip, vecp, offset,
-						&bip->bli_formats[i]);
+		xfs_buf_item_format_segment(bip, &vecp, offset,
+					    &bip->bli_formats[i]);
 		offset += bp->b_maps[i].bm_len;
 	}
 
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 92e5f62..ca354a8 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -57,20 +57,18 @@ xfs_qm_dquot_logitem_size(
 STATIC void
 xfs_qm_dquot_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*logvec)
+	struct xfs_log_iovec	*vecp)
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 
-	logvec->i_addr = &qlip->qli_format;
-	logvec->i_len  = sizeof(xfs_dq_logformat_t);
-	logvec->i_type = XLOG_REG_TYPE_QFORMAT;
-	logvec++;
-	logvec->i_addr = &qlip->qli_dquot->q_core;
-	logvec->i_len  = sizeof(xfs_disk_dquot_t);
-	logvec->i_type = XLOG_REG_TYPE_DQUOT;
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_QFORMAT,
+			&qlip->qli_format,
+			sizeof(struct xfs_dq_logformat));
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_DQUOT,
+			&qlip->qli_dquot->q_core,
+			sizeof(struct xfs_disk_dquot));
 
 	qlip->qli_format.qlf_size = 2;
-
 }
 
 /*
@@ -304,15 +302,16 @@ xfs_qm_qoff_logitem_size(
 STATIC void
 xfs_qm_qoff_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_iovec	*vecp)
 {
 	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
 
 	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
 
-	log_vector->i_addr = &qflip->qql_format;
-	log_vector->i_len = sizeof(xfs_qoff_logitem_t);
-	log_vector->i_type = XLOG_REG_TYPE_QUOTAOFF;
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_QUOTAOFF,
+			&qflip->qql_format,
+			sizeof(struct xfs_qoff_logitem));
+
 	qflip->qql_format.qf_size = 1;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3680d04..08823ec 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
+#include "xfs_log.h"
 
 
 kmem_zone_t	*xfs_efi_zone;
@@ -101,7 +102,7 @@ xfs_efi_item_size(
 STATIC void
 xfs_efi_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_iovec	*vecp)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
 
@@ -111,10 +112,9 @@ xfs_efi_item_format(
 	efip->efi_format.efi_type = XFS_LI_EFI;
 	efip->efi_format.efi_size = 1;
 
-	log_vector->i_addr = &efip->efi_format;
-	log_vector->i_len = xfs_efi_item_sizeof(efip);
-	log_vector->i_type = XLOG_REG_TYPE_EFI_FORMAT;
-	ASSERT(log_vector->i_len >= sizeof(xfs_efi_log_format_t));
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_EFI_FORMAT,
+			&efip->efi_format,
+			xfs_efi_item_sizeof(efip));
 }
 
 
@@ -368,7 +368,7 @@ xfs_efd_item_size(
 STATIC void
 xfs_efd_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_iovec	*vecp)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
 
@@ -377,10 +377,9 @@ xfs_efd_item_format(
 	efdp->efd_format.efd_type = XFS_LI_EFD;
 	efdp->efd_format.efd_size = 1;
 
-	log_vector->i_addr = &efdp->efd_format;
-	log_vector->i_len = xfs_efd_item_sizeof(efdp);
-	log_vector->i_type = XLOG_REG_TYPE_EFD_FORMAT;
-	ASSERT(log_vector->i_len >= sizeof(xfs_efd_log_format_t));
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_EFD_FORMAT,
+			&efdp->efd_format,
+			xfs_efd_item_sizeof(efdp));
 }
 
 /*
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index d2eaccf..5751fa8 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -28,6 +28,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 #include "xfs_icreate_item.h"
+#include "xfs_log.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -58,13 +59,13 @@ xfs_icreate_item_size(
 STATIC void
 xfs_icreate_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*log_vector)
+	struct xfs_log_iovec	*vecp)
 {
 	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
 
-	log_vector->i_addr = (xfs_caddr_t)&icp->ic_format;
-	log_vector->i_len  = sizeof(struct xfs_icreate_log);
-	log_vector->i_type = XLOG_REG_TYPE_ICREATE;
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_ICREATE,
+			&icp->ic_format,
+			sizeof(struct xfs_icreate_log));
 }
 
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 96554a3..73002db 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -30,6 +30,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
 #include "xfs_dinode.h"
+#include "xfs_log.h"
 
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
@@ -159,14 +160,15 @@ xfs_inode_item_size(
  * here, so always use the physical fork size to determine the size of the
  * buffer we need to allocate.
  */
-STATIC void
+STATIC int
 xfs_inode_item_format_extents(
 	struct xfs_inode	*ip,
-	struct xfs_log_iovec	*vecp,
+	struct xfs_log_iovec	**vecp,
 	int			whichfork,
 	int			type)
 {
 	xfs_bmbt_rec_t		*ext_buffer;
+	int			len;
 
 	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork), KM_SLEEP);
 	if (whichfork == XFS_DATA_FORK)
@@ -174,9 +176,9 @@ xfs_inode_item_format_extents(
 	else
 		ip->i_itemp->ili_aextents_buf = ext_buffer;
 
-	vecp->i_addr = ext_buffer;
-	vecp->i_len = xfs_iextents_copy(ip, ext_buffer, whichfork);
-	vecp->i_type = type;
+	len = xfs_iextents_copy(ip, ext_buffer, whichfork);
+	xlog_copy_iovec(vecp, type, ext_buffer, len);
+	return len;
 }
 
 /*
@@ -207,10 +209,10 @@ xfs_inode_item_format_v1_inode(
 	}
 }
 	
-STATIC struct xfs_log_iovec *
+STATIC void
 xfs_inode_item_format_data_fork(
 	struct xfs_inode_log_item *iip,
-	struct xfs_log_iovec	*vecp,
+	struct xfs_log_iovec	**vecp,
 	int			*nvecs)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
@@ -237,18 +239,18 @@ xfs_inode_item_format_data_fork(
 				 * extents, so just point to the
 				 * real extents array.
 				 */
-				vecp->i_addr = ip->i_df.if_u1.if_extents;
-				vecp->i_len = ip->i_df.if_bytes;
-				vecp->i_type = XLOG_REG_TYPE_IEXT;
+				xlog_copy_iovec(vecp, XLOG_REG_TYPE_IEXT,
+						ip->i_df.if_u1.if_extents,
+						ip->i_df.if_bytes);
+				iip->ili_format.ilf_dsize = ip->i_df.if_bytes;
 			} else
 #endif
 			{
-				xfs_inode_item_format_extents(ip, vecp,
-					XFS_DATA_FORK, XLOG_REG_TYPE_IEXT);
+				iip->ili_format.ilf_dsize =
+					xfs_inode_item_format_extents(ip, vecp,
+						XFS_DATA_FORK, XLOG_REG_TYPE_IEXT);
+				ASSERT(iip->ili_format.ilf_dsize <= ip->i_df.if_bytes);
 			}
-			ASSERT(vecp->i_len <= ip->i_df.if_bytes);
-			iip->ili_format.ilf_dsize = vecp->i_len;
-			vecp++;
 			(*nvecs)++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DEXT;
@@ -262,10 +264,9 @@ xfs_inode_item_format_data_fork(
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			ASSERT(ip->i_df.if_broot != NULL);
-			vecp->i_addr = ip->i_df.if_broot;
-			vecp->i_len = ip->i_df.if_broot_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IBROOT;
-			vecp++;
+			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IBROOT,
+					ip->i_df.if_broot,
+					ip->i_df.if_broot_bytes);
 			(*nvecs)++;
 			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
 		} else {
@@ -280,21 +281,18 @@ xfs_inode_item_format_data_fork(
 			  XFS_ILOG_DEV | XFS_ILOG_UUID);
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
-			ASSERT(ip->i_df.if_u1.if_data != NULL);
-			ASSERT(ip->i_d.di_size > 0);
-
-			vecp->i_addr = ip->i_df.if_u1.if_data;
 			/*
 			 * Round i_bytes up to a word boundary.
 			 * The underlying memory is guaranteed to
 			 * to be there by xfs_idata_realloc().
 			 */
 			data_bytes = roundup(ip->i_df.if_bytes, 4);
-			ASSERT((ip->i_df.if_real_bytes == 0) ||
-			       (ip->i_df.if_real_bytes == data_bytes));
-			vecp->i_len = (int)data_bytes;
-			vecp->i_type = XLOG_REG_TYPE_ILOCAL;
-			vecp++;
+			ASSERT(ip->i_df.if_real_bytes == 0 ||
+			       ip->i_df.if_real_bytes == data_bytes);
+			ASSERT(ip->i_df.if_u1.if_data != NULL);
+			ASSERT(ip->i_d.di_size > 0);
+			xlog_copy_iovec(vecp, XLOG_REG_TYPE_ILOCAL,
+					ip->i_df.if_u1.if_data, data_bytes);
 			(*nvecs)++;
 			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
 		} else {
@@ -323,14 +321,12 @@ xfs_inode_item_format_data_fork(
 		ASSERT(0);
 		break;
 	}
-
-	return vecp;
 }
 
-STATIC struct xfs_log_iovec *
+STATIC void
 xfs_inode_item_format_attr_fork(
 	struct xfs_inode_log_item *iip,
-	struct xfs_log_iovec	*vecp,
+	struct xfs_log_iovec	**vecp,
 	int			*nvecs)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
@@ -352,16 +348,16 @@ xfs_inode_item_format_attr_fork(
 			 * There are not delayed allocation extents
 			 * for attributes, so just point at the array.
 			 */
-			vecp->i_addr = ip->i_afp->if_u1.if_extents;
-			vecp->i_len = ip->i_afp->if_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IATTR_EXT;
+			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IATTR_EXT,
+					ip->i_afp->if_u1.if_extents,
+					ip->i_afp->if_bytes);
+			iip->ili_format.ilf_asize = ip->i_afp->if_bytes;
 #else
 			ASSERT(iip->ili_aextents_buf == NULL);
-			xfs_inode_item_format_extents(ip, vecp,
+			iip->ili_format.ilf_asize =
+				xfs_inode_item_format_extents(ip, vecp,
 					XFS_ATTR_FORK, XLOG_REG_TYPE_IATTR_EXT);
 #endif
-			iip->ili_format.ilf_asize = vecp->i_len;
-			vecp++;
 			(*nvecs)++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_AEXT;
@@ -375,10 +371,9 @@ xfs_inode_item_format_attr_fork(
 		    ip->i_afp->if_broot_bytes > 0) {
 			ASSERT(ip->i_afp->if_broot != NULL);
 
-			vecp->i_addr = ip->i_afp->if_broot;
-			vecp->i_len = ip->i_afp->if_broot_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IATTR_BROOT;
-			vecp++;
+			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IATTR_BROOT,
+					ip->i_afp->if_broot,
+					ip->i_afp->if_broot_bytes);
 			(*nvecs)++;
 			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
 		} else {
@@ -391,20 +386,18 @@ xfs_inode_item_format_attr_fork(
 
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
-			ASSERT(ip->i_afp->if_u1.if_data != NULL);
-
-			vecp->i_addr = ip->i_afp->if_u1.if_data;
 			/*
 			 * Round i_bytes up to a word boundary.
 			 * The underlying memory is guaranteed to
 			 * to be there by xfs_idata_realloc().
 			 */
 			data_bytes = roundup(ip->i_afp->if_bytes, 4);
-			ASSERT((ip->i_afp->if_real_bytes == 0) ||
-			       (ip->i_afp->if_real_bytes == data_bytes));
-			vecp->i_len = (int)data_bytes;
-			vecp->i_type = XLOG_REG_TYPE_IATTR_LOCAL;
-			vecp++;
+			ASSERT(ip->i_afp->if_real_bytes == 0 ||
+			       ip->i_afp->if_real_bytes == data_bytes);
+			ASSERT(ip->i_afp->if_u1.if_data != NULL);
+			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IATTR_LOCAL,
+					ip->i_afp->if_u1.if_data,
+					data_bytes);
 			(*nvecs)++;
 			iip->ili_format.ilf_asize = (unsigned)data_bytes;
 		} else {
@@ -415,8 +408,6 @@ xfs_inode_item_format_attr_fork(
 		ASSERT(0);
 		break;
 	}
-
-	return vecp;
 }
 
 /*
@@ -435,24 +426,22 @@ xfs_inode_item_format(
 	struct xfs_inode	*ip = iip->ili_inode;
 	uint			nvecs;
 
-	vecp->i_addr = &iip->ili_format;
-	vecp->i_len  = sizeof(xfs_inode_log_format_t);
-	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
-	vecp++;
-	nvecs	     = 1;
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_IFORMAT,
+			&iip->ili_format,
+			sizeof(struct xfs_inode_log_format));
+	nvecs = 1;
 
-	vecp->i_addr = &ip->i_d;
-	vecp->i_len  = xfs_icdinode_size(ip->i_d.di_version);
-	vecp->i_type = XLOG_REG_TYPE_ICORE;
-	vecp++;
+	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_ICORE,
+			&ip->i_d,
+			xfs_icdinode_size(ip->i_d.di_version));
 	nvecs++;
 
 	if (ip->i_d.di_version == 1)
 		xfs_inode_item_format_v1_inode(ip);
 
-	vecp = xfs_inode_item_format_data_fork(iip, vecp, &nvecs);
+	xfs_inode_item_format_data_fork(iip, &vecp, &nvecs);
 	if (XFS_IFORK_Q(ip)) {
-		vecp = xfs_inode_item_format_attr_fork(iip, vecp, &nvecs);
+		xfs_inode_item_format_attr_fork(iip, &vecp, &nvecs);
 	} else {
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e148719..384c6c4 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -30,6 +30,19 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
+static inline void *
+xlog_copy_iovec(struct xfs_log_iovec **vecp, uint type, void *data, int len)
+{
+	struct xfs_log_iovec *vec = *vecp;
+
+	vec->i_type = type;
+	vec->i_addr = data;
+	vec->i_len = len;
+
+	*vecp = vec + 1;
+	return vec->i_addr;
+}
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
