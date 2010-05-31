Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6ZLe178971 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BD6B157FD1E
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1vu1Zh8DaNiepJig for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xx-00014w-O0
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:01 +0000
Message-Id: <20100531160901.608320202@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/17] xfs: fix the xfs_log_iovec i_addr type
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-i_addr-type
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

By making this member a void pointer we can get rid of a lot of pointless
casts.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-05-29 18:44:47.514010352 +0200
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-05-29 18:44:55.990253681 +0200
@@ -65,11 +65,11 @@ xfs_qm_dquot_logitem_format(
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 
-	logvec->i_addr = (xfs_caddr_t)&qlip->qli_format;
+	logvec->i_addr = &qlip->qli_format;
 	logvec->i_len  = sizeof(xfs_dq_logformat_t);
 	logvec->i_type = XLOG_REG_TYPE_QFORMAT;
 	logvec++;
-	logvec->i_addr = (xfs_caddr_t)&qlip->qli_dquot->q_core;
+	logvec->i_addr = &qlip->qli_dquot->q_core;
 	logvec->i_len  = sizeof(xfs_disk_dquot_t);
 	logvec->i_type = XLOG_REG_TYPE_DQUOT;
 
@@ -369,7 +369,7 @@ xfs_qm_qoff_logitem_format(
 
 	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
 
-	log_vector->i_addr = (xfs_caddr_t)&(qflip->qql_format);
+	log_vector->i_addr = &qflip->qql_format;
 	log_vector->i_len = sizeof(xfs_qoff_logitem_t);
 	log_vector->i_type = XLOG_REG_TYPE_QUOTAOFF;
 	qflip->qql_format.qf_size = 1;
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-29 18:44:47.641007209 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-29 18:44:55.991253611 +0200
@@ -251,7 +251,7 @@ xfs_buf_item_format(
 	base_size =
 		(uint)(sizeof(xfs_buf_log_format_t) +
 		       ((bip->bli_format.blf_map_size - 1) * sizeof(uint)));
-	vecp->i_addr = (xfs_caddr_t)&bip->bli_format;
+	vecp->i_addr = &bip->bli_format;
 	vecp->i_len = base_size;
 	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
 	vecp++;
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-05-29 18:44:47.519254590 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-05-29 18:44:55.996299498 +0200
@@ -82,7 +82,7 @@ xfs_efi_item_format(
 	size += (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
 	efip->efi_format.efi_size = 1;
 
-	log_vector->i_addr = (xfs_caddr_t)&efip->efi_format;
+	log_vector->i_addr = &efip->efi_format;
 	log_vector->i_len = size;
 	log_vector->i_type = XLOG_REG_TYPE_EFI_FORMAT;
 	ASSERT(size >= sizeof(xfs_efi_log_format_t));
@@ -244,7 +244,7 @@ xfs_efi_init(
 int
 xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 {
-	xfs_efi_log_format_t *src_efi_fmt = (xfs_efi_log_format_t *)buf->i_addr;
+	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
 	uint i;
 	uint len = sizeof(xfs_efi_log_format_t) + 
 		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_t);  
@@ -257,8 +257,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf
 		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
 		return 0;
 	} else if (buf->i_len == len32) {
-		xfs_efi_log_format_32_t *src_efi_fmt_32 =
-			(xfs_efi_log_format_32_t *)buf->i_addr;
+		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->i_addr;
 
 		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
@@ -272,8 +271,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf
 		}
 		return 0;
 	} else if (buf->i_len == len64) {
-		xfs_efi_log_format_64_t *src_efi_fmt_64 =
-			(xfs_efi_log_format_64_t *)buf->i_addr;
+		xfs_efi_log_format_64_t *src_efi_fmt_64 = buf->i_addr;
 
 		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
@@ -373,7 +371,7 @@ xfs_efd_item_format(
 	size += (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
 	efdp->efd_format.efd_size = 1;
 
-	log_vector->i_addr = (xfs_caddr_t)&efdp->efd_format;
+	log_vector->i_addr = &efdp->efd_format;
 	log_vector->i_len = size;
 	log_vector->i_type = XLOG_REG_TYPE_EFD_FORMAT;
 	ASSERT(size >= sizeof(xfs_efd_log_format_t));
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-29 18:44:47.737033819 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-29 18:44:55.999022224 +0200
@@ -217,7 +217,7 @@ xfs_inode_item_format(
 	int			nrecs;
 	xfs_mount_t		*mp;
 
-	vecp->i_addr = (xfs_caddr_t)&iip->ili_format;
+	vecp->i_addr = &iip->ili_format;
 	vecp->i_len  = sizeof(xfs_inode_log_format_t);
 	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
 	vecp++;
@@ -268,7 +268,7 @@ xfs_inode_item_format(
 	 */
 	xfs_synchronize_times(ip);
 
-	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
+	vecp->i_addr = &ip->i_d;
 	vecp->i_len  = sizeof(struct xfs_icdinode);
 	vecp->i_type = XLOG_REG_TYPE_ICORE;
 	vecp++;
@@ -324,8 +324,7 @@ xfs_inode_item_format(
 				 * extents, so just point to the
 				 * real extents array.
 				 */
-				vecp->i_addr =
-					(char *)(ip->i_df.if_u1.if_extents);
+				vecp->i_addr = ip->i_df.if_u1.if_extents;
 				vecp->i_len = ip->i_df.if_bytes;
 				vecp->i_type = XLOG_REG_TYPE_IEXT;
 			} else
@@ -343,7 +342,7 @@ xfs_inode_item_format(
 				ext_buffer = kmem_alloc(ip->i_df.if_bytes,
 					KM_SLEEP);
 				iip->ili_extents_buf = ext_buffer;
-				vecp->i_addr = (xfs_caddr_t)ext_buffer;
+				vecp->i_addr = ext_buffer;
 				vecp->i_len = xfs_iextents_copy(ip, ext_buffer,
 						XFS_DATA_FORK);
 				vecp->i_type = XLOG_REG_TYPE_IEXT;
@@ -362,7 +361,7 @@ xfs_inode_item_format(
 		if (iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) {
 			ASSERT(ip->i_df.if_broot_bytes > 0);
 			ASSERT(ip->i_df.if_broot != NULL);
-			vecp->i_addr = (xfs_caddr_t)ip->i_df.if_broot;
+			vecp->i_addr = ip->i_df.if_broot;
 			vecp->i_len = ip->i_df.if_broot_bytes;
 			vecp->i_type = XLOG_REG_TYPE_IBROOT;
 			vecp++;
@@ -380,7 +379,7 @@ xfs_inode_item_format(
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_d.di_size > 0);
 
-			vecp->i_addr = (xfs_caddr_t)ip->i_df.if_u1.if_data;
+			vecp->i_addr = ip->i_df.if_u1.if_data;
 			/*
 			 * Round i_bytes up to a word boundary.
 			 * The underlying memory is guaranteed to
@@ -454,7 +453,7 @@ xfs_inode_item_format(
 			 * There are not delayed allocation extents
 			 * for attributes, so just point at the array.
 			 */
-			vecp->i_addr = (char *)(ip->i_afp->if_u1.if_extents);
+			vecp->i_addr = ip->i_afp->if_u1.if_extents;
 			vecp->i_len = ip->i_afp->if_bytes;
 #else
 			ASSERT(iip->ili_aextents_buf == NULL);
@@ -464,7 +463,7 @@ xfs_inode_item_format(
 			ext_buffer = kmem_alloc(ip->i_afp->if_bytes,
 				KM_SLEEP);
 			iip->ili_aextents_buf = ext_buffer;
-			vecp->i_addr = (xfs_caddr_t)ext_buffer;
+			vecp->i_addr = ext_buffer;
 			vecp->i_len = xfs_iextents_copy(ip, ext_buffer,
 					XFS_ATTR_FORK);
 #endif
@@ -481,7 +480,7 @@ xfs_inode_item_format(
 		if (iip->ili_format.ilf_fields & XFS_ILOG_ABROOT) {
 			ASSERT(ip->i_afp->if_broot_bytes > 0);
 			ASSERT(ip->i_afp->if_broot != NULL);
-			vecp->i_addr = (xfs_caddr_t)ip->i_afp->if_broot;
+			vecp->i_addr = ip->i_afp->if_broot;
 			vecp->i_len = ip->i_afp->if_broot_bytes;
 			vecp->i_type = XLOG_REG_TYPE_IATTR_BROOT;
 			vecp++;
@@ -497,7 +496,7 @@ xfs_inode_item_format(
 			ASSERT(ip->i_afp->if_bytes > 0);
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 
-			vecp->i_addr = (xfs_caddr_t)ip->i_afp->if_u1.if_data;
+			vecp->i_addr = ip->i_afp->if_u1.if_data;
 			/*
 			 * Round i_bytes up to a word boundary.
 			 * The underlying memory is guaranteed to
@@ -938,9 +937,8 @@ xfs_inode_item_format_convert(
 	xfs_inode_log_format_t	*in_f)
 {
 	if (buf->i_len == sizeof(xfs_inode_log_format_32_t)) {
-		xfs_inode_log_format_32_t *in_f32;
+		xfs_inode_log_format_32_t *in_f32 = buf->i_addr;
 
-		in_f32 = (xfs_inode_log_format_32_t *)buf->i_addr;
 		in_f->ilf_type = in_f32->ilf_type;
 		in_f->ilf_size = in_f32->ilf_size;
 		in_f->ilf_fields = in_f32->ilf_fields;
@@ -956,9 +954,8 @@ xfs_inode_item_format_convert(
 		in_f->ilf_boffset = in_f32->ilf_boffset;
 		return 0;
 	} else if (buf->i_len == sizeof(xfs_inode_log_format_64_t)){
-		xfs_inode_log_format_64_t *in_f64;
+		xfs_inode_log_format_64_t *in_f64 = buf->i_addr;
 
-		in_f64 = (xfs_inode_log_format_64_t *)buf->i_addr;
 		in_f->ilf_type = in_f64->ilf_type;
 		in_f->ilf_size = in_f64->ilf_size;
 		in_f->ilf_fields = in_f64->ilf_fields;
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-05-29 18:44:44.180005323 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-05-29 18:44:56.006006719 +0200
@@ -548,7 +548,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 				.magic = XLOG_UNMOUNT_TYPE,
 			};
 			struct xfs_log_iovec reg = {
-				.i_addr = (void *)&magic,
+				.i_addr = &magic,
 				.i_len = sizeof(magic),
 				.i_type = XLOG_REG_TYPE_UNMOUNT,
 			};
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-05-29 18:34:05.795254730 +0200
+++ xfs/fs/xfs/xfs_log.h	2010-05-29 18:44:56.012049463 +0200
@@ -104,7 +104,7 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
 #define XLOG_REG_TYPE_MAX		19
 
 typedef struct xfs_log_iovec {
-	xfs_caddr_t	i_addr;		/* beginning address of region */
+	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2010-05-29 18:44:44.299005460 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2010-05-29 18:44:56.016261643 +0200
@@ -552,7 +552,7 @@ xlog_cil_push(
 	thdr.th_type = XFS_TRANS_CHECKPOINT;
 	thdr.th_tid = tic->t_tid;
 	thdr.th_num_items = num_iovecs;
-	lhdr.i_addr = (xfs_caddr_t)&thdr;
+	lhdr.i_addr = &thdr;
 	lhdr.i_len = sizeof(xfs_trans_header_t);
 	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
 	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-05-29 18:44:44.185264996 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2010-05-29 18:44:56.019268488 +0200
@@ -1561,9 +1561,7 @@ xlog_recover_reorder_trans(
 
 	list_splice_init(&trans->r_itemq, &sort_list);
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
-		xfs_buf_log_format_t	*buf_f;
-
-		buf_f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
+		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
@@ -1888,9 +1886,8 @@ xlog_recover_do_inode_buffer(
 		 * current di_next_unlinked field.  Extract its value
 		 * and copy it to the buffer copy.
 		 */
-		logged_nextp = (xfs_agino_t *)
-			       ((char *)(item->ri_buf[item_index].i_addr) +
-				(next_unlinked_offset - reg_buf_offset));
+		logged_nextp = item->ri_buf[item_index].i_addr +
+				next_unlinked_offset - reg_buf_offset;
 		if (unlikely(*logged_nextp == 0)) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
 				"bad inode buffer log record (ptr = 0x%p, bp = 0x%p).  XFS trying to replay bad (0) inode di_next_unlinked field",
@@ -1969,8 +1966,7 @@ xlog_recover_do_reg_buffer(
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			error = xfs_qm_dqcheck((xfs_disk_dquot_t *)
-					       item->ri_buf[i].i_addr,
+			error = xfs_qm_dqcheck(item->ri_buf[i].i_addr,
 					       -1, 0, XFS_QMOPT_DOWARN,
 					       "dquot_buf_recover");
 			if (error)
@@ -2183,7 +2179,7 @@ xlog_recover_do_buffer_trans(
 	xlog_recover_item_t	*item,
 	int			pass)
 {
-	xfs_buf_log_format_t	*buf_f;
+	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
 	int			error;
@@ -2193,8 +2189,6 @@ xlog_recover_do_buffer_trans(
 	ushort			flags;
 	uint			buf_flags;
 
-	buf_f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
-
 	if (pass == XLOG_RECOVER_PASS1) {
 		/*
 		 * In this pass we're only looking for buf items
@@ -2315,10 +2309,9 @@ xlog_recover_do_inode_trans(
 	}
 
 	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
-		in_f = (xfs_inode_log_format_t *)item->ri_buf[0].i_addr;
+		in_f = item->ri_buf[0].i_addr;
 	} else {
-		in_f = (xfs_inode_log_format_t *)kmem_alloc(
-			sizeof(xfs_inode_log_format_t), KM_SLEEP);
+		in_f = kmem_alloc(sizeof(xfs_inode_log_format_t), KM_SLEEP);
 		need_free = 1;
 		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
 		if (error)
@@ -2366,7 +2359,7 @@ xlog_recover_do_inode_trans(
 		error = EFSCORRUPTED;
 		goto error;
 	}
-	dicp = (xfs_icdinode_t *)(item->ri_buf[1].i_addr);
+	dicp = item->ri_buf[1].i_addr;
 	if (unlikely(dicp->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
@@ -2457,7 +2450,7 @@ xlog_recover_do_inode_trans(
 	}
 
 	/* The core is in in-core format */
-	xfs_dinode_to_disk(dip, (xfs_icdinode_t *)item->ri_buf[1].i_addr);
+	xfs_dinode_to_disk(dip, item->ri_buf[1].i_addr);
 
 	/* the rest is in on-disk format */
 	if (item->ri_buf[1].i_len > sizeof(struct xfs_icdinode)) {
@@ -2574,7 +2567,7 @@ xlog_recover_do_quotaoff_trans(
 		return (0);
 	}
 
-	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].i_addr;
+	qoff_f = item->ri_buf[0].i_addr;
 	ASSERT(qoff_f);
 
 	/*
@@ -2618,9 +2611,8 @@ xlog_recover_do_dquot_trans(
 	if (mp->m_qflags == 0)
 		return (0);
 
-	recddq = (xfs_disk_dquot_t *)item->ri_buf[1].i_addr;
-
-	if (item->ri_buf[1].i_addr == NULL) {
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL) {
 		cmn_err(CE_ALERT,
 			"XFS: NULL dquot in %s.", __func__);
 		return XFS_ERROR(EIO);
@@ -2650,7 +2642,7 @@ xlog_recover_do_dquot_trans(
 	 * The other possibility, of course, is that the quota subsystem was
 	 * removed since the last mount - ENOSYS.
 	 */
-	dq_f = (xfs_dq_logformat_t *)item->ri_buf[0].i_addr;
+	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
 	if ((error = xfs_qm_dqcheck(recddq,
 			   dq_f->qlf_id,
@@ -2717,7 +2709,7 @@ xlog_recover_do_efi_trans(
 		return 0;
 	}
 
-	efi_formatp = (xfs_efi_log_format_t *)item->ri_buf[0].i_addr;
+	efi_formatp = item->ri_buf[0].i_addr;
 
 	mp = log->l_mp;
 	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
@@ -2763,7 +2755,7 @@ xlog_recover_do_efd_trans(
 		return;
 	}
 
-	efd_formatp = (xfs_efd_log_format_t *)item->ri_buf[0].i_addr;
+	efd_formatp = item->ri_buf[0].i_addr;
 	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
 		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
 	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
