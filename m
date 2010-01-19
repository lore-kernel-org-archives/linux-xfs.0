Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9ttua182581 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:55:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EE571C5E164
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:56:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RnWlM1PPoy0A3tNS for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:56:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NXApT-0001GZ-7t
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 09:56:55 +0000
Message-Id: <20100119095655.041953657@bombadil.infradead.org>
Date: Tue, 19 Jan 2010 04:56:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: kill XLOG_VEC_SET_TYPE
References: <20100119095643.378866749@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XLOG_VEC_SET_TYPE
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This macro only obsfucates the log item type assignments, so kill it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-01-08 14:27:59.248004175 +0100
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-01-08 14:33:49.403031925 +0100
@@ -74,11 +74,11 @@ xfs_qm_dquot_logitem_format(
 
 	logvec->i_addr = (xfs_caddr_t)&logitem->qli_format;
 	logvec->i_len  = sizeof(xfs_dq_logformat_t);
-	XLOG_VEC_SET_TYPE(logvec, XLOG_REG_TYPE_QFORMAT);
+	logvec->i_type = XLOG_REG_TYPE_QFORMAT;
 	logvec++;
 	logvec->i_addr = (xfs_caddr_t)&logitem->qli_dquot->q_core;
 	logvec->i_len  = sizeof(xfs_disk_dquot_t);
-	XLOG_VEC_SET_TYPE(logvec, XLOG_REG_TYPE_DQUOT);
+	logvec->i_type = XLOG_REG_TYPE_DQUOT;
 
 	ASSERT(2 == logitem->qli_item.li_desc->lid_size);
 	logitem->qli_format.qlf_size = 2;
@@ -466,7 +466,7 @@ xfs_qm_qoff_logitem_format(xfs_qoff_logi
 
 	log_vector->i_addr = (xfs_caddr_t)&(qf->qql_format);
 	log_vector->i_len = sizeof(xfs_qoff_logitem_t);
-	XLOG_VEC_SET_TYPE(log_vector, XLOG_REG_TYPE_QUOTAOFF);
+	log_vector->i_type = XLOG_REG_TYPE_QUOTAOFF;
 	qf->qql_format.qf_size = 1;
 }
 
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-01-08 14:27:59.260254129 +0100
+++ xfs/fs/xfs/xfs_buf_item.c	2010-01-08 14:29:09.596255635 +0100
@@ -250,7 +250,7 @@ xfs_buf_item_format(
 		       ((bip->bli_format.blf_map_size - 1) * sizeof(uint)));
 	vecp->i_addr = (xfs_caddr_t)&bip->bli_format;
 	vecp->i_len = base_size;
-	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_BFORMAT);
+	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
 	vecp++;
 	nvecs = 1;
 
@@ -297,14 +297,14 @@ xfs_buf_item_format(
 			buffer_offset = first_bit * XFS_BLI_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLI_CHUNK;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_BCHUNK);
+			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 			nvecs++;
 			break;
 		} else if (next_bit != last_bit + 1) {
 			buffer_offset = first_bit * XFS_BLI_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLI_CHUNK;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_BCHUNK);
+			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 			nvecs++;
 			vecp++;
 			first_bit = next_bit;
@@ -316,7 +316,7 @@ xfs_buf_item_format(
 			buffer_offset = first_bit * XFS_BLI_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLI_CHUNK;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_BCHUNK);
+			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 /* You would think we need to bump the nvecs here too, but we do not
  * this number is used by recovery, and it gets confused by the boundary
  * split here
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-01-08 14:27:59.274254026 +0100
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-01-08 14:29:26.849016123 +0100
@@ -82,7 +82,7 @@ xfs_efi_item_format(xfs_efi_log_item_t	*
 
 	log_vector->i_addr = (xfs_caddr_t)&(efip->efi_format);
 	log_vector->i_len = size;
-	XLOG_VEC_SET_TYPE(log_vector, XLOG_REG_TYPE_EFI_FORMAT);
+	log_vector->i_type = XLOG_REG_TYPE_EFI_FORMAT;
 	ASSERT(size >= sizeof(xfs_efi_log_format_t));
 }
 
@@ -406,7 +406,7 @@ xfs_efd_item_format(xfs_efd_log_item_t	*
 
 	log_vector->i_addr = (xfs_caddr_t)&(efdp->efd_format);
 	log_vector->i_len = size;
-	XLOG_VEC_SET_TYPE(log_vector, XLOG_REG_TYPE_EFD_FORMAT);
+	log_vector->i_type = XLOG_REG_TYPE_EFD_FORMAT;
 	ASSERT(size >= sizeof(xfs_efd_log_format_t));
 }
 
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-01-08 14:27:59.286003706 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2010-01-08 14:32:40.497005581 +0100
@@ -228,7 +228,7 @@ xfs_inode_item_format(
 
 	vecp->i_addr = (xfs_caddr_t)&iip->ili_format;
 	vecp->i_len  = sizeof(xfs_inode_log_format_t);
-	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IFORMAT);
+	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
 	vecp++;
 	nvecs	     = 1;
 
@@ -279,7 +279,7 @@ xfs_inode_item_format(
 
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
 	vecp->i_len  = sizeof(struct xfs_icdinode);
-	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);
+	vecp->i_type = XLOG_REG_TYPE_ICORE;
 	vecp++;
 	nvecs++;
 	iip->ili_format.ilf_fields |= XFS_ILOG_CORE;
@@ -336,7 +336,7 @@ xfs_inode_item_format(
 				vecp->i_addr =
 					(char *)(ip->i_df.if_u1.if_extents);
 				vecp->i_len = ip->i_df.if_bytes;
-				XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IEXT);
+				vecp->i_type = XLOG_REG_TYPE_IEXT;
 			} else
 #endif
 			{
@@ -355,7 +355,7 @@ xfs_inode_item_format(
 				vecp->i_addr = (xfs_caddr_t)ext_buffer;
 				vecp->i_len = xfs_iextents_copy(ip, ext_buffer,
 						XFS_DATA_FORK);
-				XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IEXT);
+				vecp->i_type = XLOG_REG_TYPE_IEXT;
 			}
 			ASSERT(vecp->i_len <= ip->i_df.if_bytes);
 			iip->ili_format.ilf_dsize = vecp->i_len;
@@ -373,7 +373,7 @@ xfs_inode_item_format(
 			ASSERT(ip->i_df.if_broot != NULL);
 			vecp->i_addr = (xfs_caddr_t)ip->i_df.if_broot;
 			vecp->i_len = ip->i_df.if_broot_bytes;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IBROOT);
+			vecp->i_type = XLOG_REG_TYPE_IBROOT;
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
@@ -399,7 +399,7 @@ xfs_inode_item_format(
 			ASSERT((ip->i_df.if_real_bytes == 0) ||
 			       (ip->i_df.if_real_bytes == data_bytes));
 			vecp->i_len = (int)data_bytes;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ILOCAL);
+			vecp->i_type = XLOG_REG_TYPE_ILOCAL;
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
@@ -477,7 +477,7 @@ xfs_inode_item_format(
 			vecp->i_len = xfs_iextents_copy(ip, ext_buffer,
 					XFS_ATTR_FORK);
 #endif
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IATTR_EXT);
+			vecp->i_type = XLOG_REG_TYPE_IATTR_EXT;
 			iip->ili_format.ilf_asize = vecp->i_len;
 			vecp++;
 			nvecs++;
@@ -492,7 +492,7 @@ xfs_inode_item_format(
 			ASSERT(ip->i_afp->if_broot != NULL);
 			vecp->i_addr = (xfs_caddr_t)ip->i_afp->if_broot;
 			vecp->i_len = ip->i_afp->if_broot_bytes;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IATTR_BROOT);
+			vecp->i_type = XLOG_REG_TYPE_IATTR_BROOT;
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
@@ -516,7 +516,7 @@ xfs_inode_item_format(
 			ASSERT((ip->i_afp->if_real_bytes == 0) ||
 			       (ip->i_afp->if_real_bytes == data_bytes));
 			vecp->i_len = (int)data_bytes;
-			XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_IATTR_LOCAL);
+			vecp->i_type = XLOG_REG_TYPE_IATTR_LOCAL;
 			vecp++;
 			nvecs++;
 			iip->ili_format.ilf_asize = (unsigned)data_bytes;
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-01-08 14:27:59.297004270 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-01-08 14:33:35.830255519 +0100
@@ -617,7 +617,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
 		reg[0].i_addr = (void*)&magic;
 		reg[0].i_len  = sizeof(magic);
-		XLOG_VEC_SET_TYPE(&reg[0], XLOG_REG_TYPE_UNMOUNT);
+		reg[0].i_type = XLOG_REG_TYPE_UNMOUNT;
 
 		error = xfs_log_reserve(mp, 600, 1, &tic,
 					XFS_LOG, 0, XLOG_UNMOUNT_REC_TYPE);
@@ -1236,7 +1236,7 @@ xlog_commit_record(xfs_mount_t  *mp,
 
 	reg[0].i_addr = NULL;
 	reg[0].i_len = 0;
-	XLOG_VEC_SET_TYPE(&reg[0], XLOG_REG_TYPE_COMMIT);
+	reg[0].i_type = XLOG_REG_TYPE_COMMIT;
 
 	ASSERT_ALWAYS(iclog);
 	if ((error = xlog_write(mp, reg, 1, ticket, commitlsnp,
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-01-08 14:33:55.979280121 +0100
+++ xfs/fs/xfs/xfs_log.h	2010-01-08 14:34:13.569006415 +0100
@@ -110,10 +110,8 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
 #define XLOG_REG_TYPE_TRANSHDR		19
 #define XLOG_REG_TYPE_MAX		19
 
-#define XLOG_VEC_SET_TYPE(vecp, t) ((vecp)->i_type = (t))
-
 typedef struct xfs_log_iovec {
-	xfs_caddr_t		i_addr;		/* beginning address of region */
+	xfs_caddr_t	i_addr;		/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-01-08 14:27:59.307004006 +0100
+++ xfs/fs/xfs/xfs_trans.c	2010-01-08 14:33:46.908006228 +0100
@@ -1121,7 +1121,7 @@ xfs_trans_fill_vecs(
 	tp->t_header.th_num_items = nitems;
 	log_vector->i_addr = (xfs_caddr_t)&tp->t_header;
 	log_vector->i_len = sizeof(xfs_trans_header_t);
-	XLOG_VEC_SET_TYPE(log_vector, XLOG_REG_TYPE_TRANSHDR);
+	log_vector->i_type = XLOG_REG_TYPE_TRANSHDR;
 }
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
