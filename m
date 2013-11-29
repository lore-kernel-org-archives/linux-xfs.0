Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04D867F55
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66CA6AC006
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:03 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id z8lsTQqhmsHDsfIw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcH-0000C2-5H
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:01 +0000
Message-Id: <20131129084001.028583376@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/10] xfs: format log items write directly into the linear
	CIL buffer
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0006-xfs-format-log-items-write-directly-into-the-linear-.patch
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

Note that all log item format routines now need to be careful to modify
the copy of the item that was placed into the CIL after calls to
xlog_copy_iovec instead of the in-memory copy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c     |   29 +++++++-------
 fs/xfs/xfs_dquot_item.c   |   19 +++++-----
 fs/xfs/xfs_extfree_item.c |   10 +++--
 fs/xfs/xfs_icreate_item.c |    5 ++-
 fs/xfs/xfs_inode_item.c   |   92 ++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log.h          |   34 +++++++++++++++--
 fs/xfs/xfs_log_cil.c      |   34 +----------------
 fs/xfs/xfs_trans.h        |    2 +-
 8 files changed, 111 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d49419d..7641173 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -184,6 +184,7 @@ xfs_buf_item_size(
 
 static inline void
 xfs_buf_item_copy_iovec(
+	struct xfs_log_vec	*lv,
 	struct xfs_log_iovec	**vecp,
 	struct xfs_buf		*bp,
 	uint			offset,
@@ -191,7 +192,7 @@ xfs_buf_item_copy_iovec(
 	uint			nbits)
 {
 	offset += first_bit * XFS_BLF_CHUNK;
-	xlog_copy_iovec(vecp, XLOG_REG_TYPE_BCHUNK,
+	xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK,
 			xfs_buf_offset(bp, offset),
 			nbits * XFS_BLF_CHUNK);
 }
@@ -211,13 +212,13 @@ xfs_buf_item_straddle(
 static void
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
+	struct xfs_log_vec	*lv,
 	struct xfs_log_iovec	**vecp,
 	uint			offset,
 	struct xfs_buf_log_format *blfp)
 {
 	struct xfs_buf	*bp = bip->bli_buf;
 	uint		base_size;
-	uint		nvecs;
 	int		first_bit;
 	int		last_bit;
 	int		next_bit;
@@ -233,18 +234,17 @@ xfs_buf_item_format_segment(
 	 */
 	base_size = xfs_buf_log_format_size(blfp);
 
-	nvecs = 0;
 	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
 	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
 		/*
 		 * If the map is not be dirty in the transaction, mark
 		 * the size as zero and do not advance the vector pointer.
 		 */
-		goto out;
+		return;
 	}
 
-	xlog_copy_iovec(vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
-	nvecs = 1;
+	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
+	blfp->blf_size = 1;
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
@@ -254,7 +254,7 @@ xfs_buf_item_format_segment(
 		 */
 		trace_xfs_buf_item_format_stale(bip);
 		ASSERT(blfp->blf_flags & XFS_BLF_CANCEL);
-		goto out;
+		return;
 	}
 
 
@@ -280,15 +280,15 @@ xfs_buf_item_format_segment(
 		 * same set of bits so just keep counting and scanning.
 		 */
 		if (next_bit == -1) {
-			xfs_buf_item_copy_iovec(vecp, bp, offset,
+			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
 						first_bit, nbits);
-			nvecs++;
+			blfp->blf_size++;
 			break;
 		} else if (next_bit != last_bit + 1 ||
 		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
-			xfs_buf_item_copy_iovec(vecp, bp, offset,
+			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
 						first_bit, nbits);
-			nvecs++;
+			blfp->blf_size++;
 			first_bit = next_bit;
 			last_bit = next_bit;
 			nbits = 1;
@@ -297,8 +297,6 @@ xfs_buf_item_format_segment(
 			nbits++;
 		}
 	}
-out:
-	blfp->blf_size = nvecs;
 }
 
 /*
@@ -310,10 +308,11 @@ out:
 STATIC void
 xfs_buf_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_iovec	*vecp = NULL;
 	uint			offset = 0;
 	int			i;
 
@@ -354,7 +353,7 @@ xfs_buf_item_format(
 	}
 
 	for (i = 0; i < bip->bli_format_count; i++) {
-		xfs_buf_item_format_segment(bip, &vecp, offset,
+		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
 					    &bip->bli_formats[i]);
 		offset += bp->b_maps[i].bm_len;
 	}
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index ca354a8..946d588 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -57,18 +57,19 @@ xfs_qm_dquot_logitem_size(
 STATIC void
 xfs_qm_dquot_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
 
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_QFORMAT,
+	qlip->qli_format.qlf_size = 2;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_QFORMAT,
 			&qlip->qli_format,
 			sizeof(struct xfs_dq_logformat));
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_DQUOT,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT,
 			&qlip->qli_dquot->q_core,
 			sizeof(struct xfs_disk_dquot));
-
-	qlip->qli_format.qlf_size = 2;
 }
 
 /*
@@ -302,17 +303,17 @@ xfs_qm_qoff_logitem_size(
 STATIC void
 xfs_qm_qoff_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
+	qflip->qql_format.qf_size = 1;
 
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_QUOTAOFF,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_QUOTAOFF,
 			&qflip->qql_format,
 			sizeof(struct xfs_qoff_logitem));
-
-	qflip->qql_format.qf_size = 1;
 }
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 08823ec..fb7a4c1 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -102,9 +102,10 @@ xfs_efi_item_size(
 STATIC void
 xfs_efi_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(atomic_read(&efip->efi_next_extent) ==
 				efip->efi_format.efi_nextents);
@@ -112,7 +113,7 @@ xfs_efi_item_format(
 	efip->efi_format.efi_type = XFS_LI_EFI;
 	efip->efi_format.efi_size = 1;
 
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_EFI_FORMAT,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT,
 			&efip->efi_format,
 			xfs_efi_item_sizeof(efip));
 }
@@ -368,16 +369,17 @@ xfs_efd_item_size(
 STATIC void
 xfs_efd_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
 
 	efdp->efd_format.efd_type = XFS_LI_EFD;
 	efdp->efd_format.efd_size = 1;
 
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_EFD_FORMAT,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT,
 			&efdp->efd_format,
 			xfs_efd_item_sizeof(efdp));
 }
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 5751fa8..7e45492 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -59,11 +59,12 @@ xfs_icreate_item_size(
 STATIC void
 xfs_icreate_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
 
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_ICREATE,
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICREATE,
 			&icp->ic_format,
 			sizeof(struct xfs_icreate_log));
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 73002db..35dd24a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -163,6 +163,7 @@ xfs_inode_item_size(
 STATIC int
 xfs_inode_item_format_extents(
 	struct xfs_inode	*ip,
+	struct xfs_log_vec	*lv,
 	struct xfs_log_iovec	**vecp,
 	int			whichfork,
 	int			type)
@@ -177,7 +178,7 @@ xfs_inode_item_format_extents(
 		ip->i_itemp->ili_aextents_buf = ext_buffer;
 
 	len = xfs_iextents_copy(ip, ext_buffer, whichfork);
-	xlog_copy_iovec(vecp, type, ext_buffer, len);
+	xlog_copy_iovec(lv, vecp, type, ext_buffer, len);
 	return len;
 }
 
@@ -212,8 +213,9 @@ xfs_inode_item_format_v1_inode(
 STATIC void
 xfs_inode_item_format_data_fork(
 	struct xfs_inode_log_item *iip,
-	struct xfs_log_iovec	**vecp,
-	int			*nvecs)
+	struct xfs_inode_log_format *ilf,
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	**vecp)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
@@ -239,19 +241,19 @@ xfs_inode_item_format_data_fork(
 				 * extents, so just point to the
 				 * real extents array.
 				 */
-				xlog_copy_iovec(vecp, XLOG_REG_TYPE_IEXT,
+				xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IEXT,
 						ip->i_df.if_u1.if_extents,
 						ip->i_df.if_bytes);
-				iip->ili_format.ilf_dsize = ip->i_df.if_bytes;
+				ilf->ilf_dsize = ip->i_df.if_bytes;
 			} else
 #endif
 			{
-				iip->ili_format.ilf_dsize =
-					xfs_inode_item_format_extents(ip, vecp,
+				ilf->ilf_dsize =
+					xfs_inode_item_format_extents(ip, lv, vecp,
 						XFS_DATA_FORK, XLOG_REG_TYPE_IEXT);
 				ASSERT(iip->ili_format.ilf_dsize <= ip->i_df.if_bytes);
 			}
-			(*nvecs)++;
+			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DEXT;
 		}
@@ -264,11 +266,11 @@ xfs_inode_item_format_data_fork(
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			ASSERT(ip->i_df.if_broot != NULL);
-			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IBROOT,
+			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IBROOT,
 					ip->i_df.if_broot,
 					ip->i_df.if_broot_bytes);
-			(*nvecs)++;
-			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
+			ilf->ilf_dsize = ip->i_df.if_broot_bytes;
+			ilf->ilf_size++;
 		} else {
 			ASSERT(!(iip->ili_fields &
 				 XFS_ILOG_DBROOT));
@@ -291,10 +293,10 @@ xfs_inode_item_format_data_fork(
 			       ip->i_df.if_real_bytes == data_bytes);
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_d.di_size > 0);
-			xlog_copy_iovec(vecp, XLOG_REG_TYPE_ILOCAL,
+			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
 					ip->i_df.if_u1.if_data, data_bytes);
-			(*nvecs)++;
-			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
+			ilf->ilf_dsize = (unsigned)data_bytes;
+			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DDATA;
 		}
@@ -303,19 +305,15 @@ xfs_inode_item_format_data_fork(
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
 		ASSERT(0);
@@ -326,8 +324,9 @@ xfs_inode_item_format_data_fork(
 STATIC void
 xfs_inode_item_format_attr_fork(
 	struct xfs_inode_log_item *iip,
-	struct xfs_log_iovec	**vecp,
-	int			*nvecs)
+	struct xfs_inode_log_format *ilf,
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	**vecp)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
@@ -348,17 +347,17 @@ xfs_inode_item_format_attr_fork(
 			 * There are not delayed allocation extents
 			 * for attributes, so just point at the array.
 			 */
-			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IATTR_EXT,
+			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT,
 					ip->i_afp->if_u1.if_extents,
 					ip->i_afp->if_bytes);
-			iip->ili_format.ilf_asize = ip->i_afp->if_bytes;
+			ilf->ilf_asize = ip->i_afp->if_bytes;
 #else
 			ASSERT(iip->ili_aextents_buf == NULL);
-			iip->ili_format.ilf_asize =
-				xfs_inode_item_format_extents(ip, vecp,
+			ilf->ilf_asize =
+				xfs_inode_item_format_extents(ip, lv, vecp,
 					XFS_ATTR_FORK, XLOG_REG_TYPE_IATTR_EXT);
 #endif
-			(*nvecs)++;
+			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_AEXT;
 		}
@@ -371,11 +370,11 @@ xfs_inode_item_format_attr_fork(
 		    ip->i_afp->if_broot_bytes > 0) {
 			ASSERT(ip->i_afp->if_broot != NULL);
 
-			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IATTR_BROOT,
+			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_BROOT,
 					ip->i_afp->if_broot,
 					ip->i_afp->if_broot_bytes);
-			(*nvecs)++;
-			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
+			ilf->ilf_asize = ip->i_afp->if_broot_bytes;
+			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ABROOT;
 		}
@@ -395,11 +394,11 @@ xfs_inode_item_format_attr_fork(
 			ASSERT(ip->i_afp->if_real_bytes == 0 ||
 			       ip->i_afp->if_real_bytes == data_bytes);
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
-			xlog_copy_iovec(vecp, XLOG_REG_TYPE_IATTR_LOCAL,
+			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
 					ip->i_afp->if_u1.if_data,
 					data_bytes);
-			(*nvecs)++;
-			iip->ili_format.ilf_asize = (unsigned)data_bytes;
+			ilf->ilf_asize = (unsigned)data_bytes;
+			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ADATA;
 		}
@@ -420,28 +419,28 @@ xfs_inode_item_format_attr_fork(
 STATIC void
 xfs_inode_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+	struct xfs_log_vec	*lv)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-	uint			nvecs;
+	struct xfs_inode_log_format *ilf;
+	struct xfs_log_iovec	*vecp = NULL;
 
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_IFORMAT,
+	ilf = xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT,
 			&iip->ili_format,
 			sizeof(struct xfs_inode_log_format));
-	nvecs = 1;
-
-	xlog_copy_iovec(&vecp, XLOG_REG_TYPE_ICORE,
-			&ip->i_d,
-			xfs_icdinode_size(ip->i_d.di_version));
-	nvecs++;
+	ilf->ilf_size = 1;
 
 	if (ip->i_d.di_version == 1)
 		xfs_inode_item_format_v1_inode(ip);
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICORE,
+			&ip->i_d,
+			xfs_icdinode_size(ip->i_d.di_version));
+	ilf->ilf_size++;
 
-	xfs_inode_item_format_data_fork(iip, &vecp, &nvecs);
+	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
 	if (XFS_IFORK_Q(ip)) {
-		xfs_inode_item_format_attr_fork(iip, &vecp, &nvecs);
+		xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
 	} else {
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
@@ -455,7 +454,6 @@ xfs_inode_item_format(
 	 */
 	iip->ili_format.ilf_fields = XFS_ILOG_CORE |
 		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
-	iip->ili_format.ilf_size = nvecs;
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 384c6c4..e04bd0c 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -31,18 +31,44 @@ struct xfs_log_vec {
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 static inline void *
-xlog_copy_iovec(struct xfs_log_iovec **vecp, uint type, void *data, int len)
+xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
+		uint type)
 {
 	struct xfs_log_iovec *vec = *vecp;
 
+	if (vec) {
+		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
+		vec++;
+	} else {
+		vec = &lv->lv_iovecp[0];
+	}
+
 	vec->i_type = type;
-	vec->i_addr = data;
-	vec->i_len = len;
+	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
 
-	*vecp = vec + 1;
+	*vecp = vec;
 	return vec->i_addr;
 }
 
+static inline void
+xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
+{
+	lv->lv_buf_len += len;
+	vec->i_len = len;
+}
+
+static inline void *
+xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
+		uint type, void *data, int len)
+{
+	void *buf;
+
+	buf = xlog_prepare_iovec(lv, vecp, type);
+	memcpy(buf, data, len);
+	xlog_finish_iovec(lv, *vecp, len);
+	return buf;
+}
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 0a7a8ce..28192d6 100644
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
@@ -272,9 +242,9 @@ xlog_cil_insert_format_items(
 		lv->lv_niovecs = niovecs;
 
 		/* The allocated data region lies beyond the iovec region */
+		lv->lv_buf_len = 0;
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
-
-		lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
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
