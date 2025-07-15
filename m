Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F902219E8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582711; cv=none; b=cw6i8KzyfhUy5zl8eYYV7EI2ij6SuLnIgCmzo0QcWZw3HuU9A60d2FTzyt58RVVUTDn5MYCDGryPvUHArZZA+/+vbqiAloLGw1UZ/UYeqMMdZ+i8HMIhpxeYcuWnrJ0keHWfH6QnJmZ730kIBkT1Pk2fIfePaPdxpnRHs6OkIwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582711; c=relaxed/simple;
	bh=2eLBs3ti65PTX7ox5j890KrRFzbJ2tPsDtoZCAE5wCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1V7sZip9SacwpXRyv+3nWd96pZzO5KA76Qq9Dj/CTzDD96q9nBpWx9JMyCSSYsJR9BxBtIPzxq7fJLikanlOI0GtdVBfo4GJ/FXcvbzHMAPoz5wGfIz5k/ElgNtI7cl2kvdy4p0KGpq7fGK1iXClVuclgomr559ac2NfT+j2cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kCz3gUml; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kCz3gUml"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PUSIn6RE6yRnJ1tWxaRL2DoftVGx2XW+DR1WGEYLEiY=; b=kCz3gUmlMaGeAMJuDxs8JZNgA0
	HUUUxD0B11J695sksySCdpgJ4zFUvHGmRVE9nNj6H8v/I8tn/3StLOtAFhhzmXwA0ya3GjYsLzXrk
	yj9ITMKDlfdMcxDUTM59d1MfcZfpsOBTf1o3htebcHR7jkLQ4M0JyGeOPFQhqwxTrKAuDWfg4ynZY
	k/jGmzFqr8tBh+rQuXMFiW6Uha9CWMHmj2RT4XwTmkmHQ5I6s1XZp0ajkUPDJQywLp/k4Ct9hAbqL
	PBPGeqD37QQpJiS76+LjgKItMOXzFmus19ibafNvCTXDGL1Im7xxCYctweEvmfPBJQX5QI0h8Ixv8
	GWsp1nXQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubep2-000000054pt-1qgJ;
	Tue, 15 Jul 2025 12:31:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/18] xfs: improve the ->iop_format interface
Date: Tue, 15 Jul 2025 14:30:13 +0200
Message-ID: <20250715123125.1945534-9-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Export a higher level interface to format log items.  The xlog_format_buf
structure is hidden inside xfs_log_cil.c and only accessed using two
helpers (and a wrapper build on top), hiding details of log iovecs from
the log items.  This also allows simply using an index into lv_iovecp
instead of keeping a cursor vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c     |  27 +++++-----
 fs/xfs/xfs_bmap_item.c     |  10 ++--
 fs/xfs/xfs_buf_item.c      |  19 +++----
 fs/xfs/xfs_dquot_item.c    |   9 ++--
 fs/xfs/xfs_exchmaps_item.c |  11 ++--
 fs/xfs/xfs_extfree_item.c  |  10 ++--
 fs/xfs/xfs_icreate_item.c  |   6 +--
 fs/xfs/xfs_inode_item.c    |  49 +++++++++---------
 fs/xfs/xfs_log.c           |  56 ---------------------
 fs/xfs/xfs_log.h           |  53 ++++----------------
 fs/xfs/xfs_log_cil.c       | 100 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_refcount_item.c |  10 ++--
 fs/xfs/xfs_rmap_item.c     |  10 ++--
 fs/xfs/xfs_trans.h         |   4 +-
 14 files changed, 180 insertions(+), 194 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index bc970aa6832f..932c9dbb9ab6 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -192,10 +192,9 @@ xfs_attri_item_size(
 STATIC void
 xfs_attri_item_format(
 	struct xfs_log_item		*lip,
-	struct xfs_log_vec		*lv)
+	struct xlog_format_buf		*lfb)
 {
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
-	struct xfs_log_iovec		*vecp = NULL;
 	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
 
 	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
@@ -220,24 +219,23 @@ xfs_attri_item_format(
 	if (nv->new_value.iov_len > 0)
 		attrip->attri_format.alfi_size++;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
-			&attrip->attri_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTRI_FORMAT, &attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME, nv->name.iov_base,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NAME, nv->name.iov_base,
 			nv->name.iov_len);
 
 	if (nv->new_name.iov_len > 0)
-		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NEWNAME,
-			nv->new_name.iov_base, nv->new_name.iov_len);
+		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NEWNAME,
+				nv->new_name.iov_base, nv->new_name.iov_len);
 
 	if (nv->value.iov_len > 0)
-		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
-			nv->value.iov_base, nv->value.iov_len);
+		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_VALUE,
+				nv->value.iov_base, nv->value.iov_len);
 
 	if (nv->new_value.iov_len > 0)
-		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NEWVALUE,
-			nv->new_value.iov_base, nv->new_value.iov_len);
+		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NEWVALUE,
+				nv->new_value.iov_base, nv->new_value.iov_len);
 }
 
 /*
@@ -322,16 +320,15 @@ xfs_attrd_item_size(
  */
 STATIC void
 xfs_attrd_item_format(
-	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xfs_log_item		*lip,
+	struct xlog_format_buf		*lfb)
 {
 	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
-	struct xfs_log_iovec		*vecp = NULL;
 
 	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
 	attrdp->attrd_format.alfd_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTRD_FORMAT,
 			&attrdp->attrd_format,
 			sizeof(struct xfs_attrd_log_format));
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 80f0c4bcc483..f38ed63fe86b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -92,10 +92,9 @@ unsigned int xfs_bui_log_space(unsigned int nr)
 STATIC void
 xfs_bui_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(atomic_read(&buip->bui_next_extent) ==
 			buip->bui_format.bui_nextents);
@@ -103,7 +102,7 @@ xfs_bui_item_format(
 	buip->bui_format.bui_type = XFS_LI_BUI;
 	buip->bui_format.bui_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUI_FORMAT, &buip->bui_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_BUI_FORMAT, &buip->bui_format,
 			xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents));
 }
 
@@ -188,15 +187,14 @@ unsigned int xfs_bud_log_space(void)
 STATIC void
 xfs_bud_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	budp->bud_format.bud_type = XFS_LI_BUD;
 	budp->bud_format.bud_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
 			sizeof(struct xfs_bud_log_format));
 }
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8d85b5eee444..c998983ade64 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -263,24 +263,21 @@ xfs_buf_item_size(
 
 static inline void
 xfs_buf_item_copy_iovec(
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp,
+	struct xlog_format_buf	*lfb,
 	struct xfs_buf		*bp,
 	uint			offset,
 	int			first_bit,
 	uint			nbits)
 {
 	offset += first_bit * XFS_BLF_CHUNK;
-	xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK,
-			xfs_buf_offset(bp, offset),
+	xlog_format_copy(lfb, XLOG_REG_TYPE_BCHUNK, xfs_buf_offset(bp, offset),
 			nbits * XFS_BLF_CHUNK);
 }
 
 static void
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp,
+	struct xlog_format_buf	*lfb,
 	uint			offset,
 	struct xfs_buf_log_format *blfp)
 {
@@ -308,7 +305,7 @@ xfs_buf_item_format_segment(
 		return;
 	}
 
-	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
+	blfp = xlog_format_copy(lfb, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
 	blfp->blf_size = 1;
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -331,8 +328,7 @@ xfs_buf_item_format_segment(
 		nbits = xfs_contig_bits(blfp->blf_data_map,
 					blfp->blf_map_size, first_bit);
 		ASSERT(nbits > 0);
-		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-					first_bit, nbits);
+		xfs_buf_item_copy_iovec(lfb, bp, offset, first_bit, nbits);
 		blfp->blf_size++;
 
 		/*
@@ -357,11 +353,10 @@ xfs_buf_item_format_segment(
 STATIC void
 xfs_buf_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	struct xfs_log_iovec	*vecp = NULL;
 	uint			offset = 0;
 	int			i;
 
@@ -398,7 +393,7 @@ xfs_buf_item_format(
 	}
 
 	for (i = 0; i < bip->bli_format_count; i++) {
-		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
+		xfs_buf_item_format_segment(bip, lfb, offset,
 					    &bip->bli_formats[i]);
 		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 271b195ebb93..9c2fcfbdf7dc 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -44,25 +44,24 @@ xfs_qm_dquot_logitem_size(
 STATIC void
 xfs_qm_dquot_logitem_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_disk_dquot	ddq;
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_dq_logformat	*qlf;
 
-	qlf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_QFORMAT);
+	qlf = xlog_format_start(lfb, XLOG_REG_TYPE_QFORMAT);
 	qlf->qlf_type = XFS_LI_DQUOT;
 	qlf->qlf_size = 2;
 	qlf->qlf_id = qlip->qli_dquot->q_id;
 	qlf->qlf_blkno = qlip->qli_dquot->q_blkno;
 	qlf->qlf_len = 1;
 	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
-	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
+	xlog_format_commit(lfb, sizeof(struct xfs_dq_logformat));
 
 	xfs_dquot_to_disk(&ddq, qlip->qli_dquot);
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT, &ddq,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_DQUOT, &ddq,
 			sizeof(struct xfs_disk_dquot));
 }
 
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 229cbe0adf17..10d6fbeff651 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -83,16 +83,14 @@ xfs_xmi_item_size(
 STATIC void
 xfs_xmi_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_xmi_log_item	*xmi_lip = XMI_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	xmi_lip->xmi_format.xmi_type = XFS_LI_XMI;
 	xmi_lip->xmi_format.xmi_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_XMI_FORMAT,
-			&xmi_lip->xmi_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_XMI_FORMAT, &xmi_lip->xmi_format,
 			sizeof(struct xfs_xmi_log_format));
 }
 
@@ -166,15 +164,14 @@ xfs_xmd_item_size(
 STATIC void
 xfs_xmd_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_xmd_log_item	*xmd_lip = XMD_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	xmd_lip->xmd_format.xmd_type = XFS_LI_XMD;
 	xmd_lip->xmd_format.xmd_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_XMD_FORMAT, &xmd_lip->xmd_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_XMD_FORMAT, &xmd_lip->xmd_format,
 			sizeof(struct xfs_xmd_log_format));
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 47ee598a9827..750557641604 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -98,10 +98,9 @@ unsigned int xfs_efi_log_space(unsigned int nr)
 STATIC void
 xfs_efi_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(atomic_read(&efip->efi_next_extent) ==
 				efip->efi_format.efi_nextents);
@@ -110,7 +109,7 @@ xfs_efi_item_format(
 	efip->efi_format.efi_type = lip->li_type;
 	efip->efi_format.efi_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT, &efip->efi_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_EFI_FORMAT, &efip->efi_format,
 			xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents));
 }
 
@@ -277,10 +276,9 @@ unsigned int xfs_efd_log_space(unsigned int nr)
 STATIC void
 xfs_efd_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
 	ASSERT(lip->li_type == XFS_LI_EFD || lip->li_type == XFS_LI_EFD_RT);
@@ -288,7 +286,7 @@ xfs_efd_item_format(
 	efdp->efd_format.efd_type = lip->li_type;
 	efdp->efd_format.efd_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT, &efdp->efd_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_EFD_FORMAT, &efdp->efd_format,
 			xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents));
 }
 
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index f83ec2bd0583..004dd22393dc 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -49,13 +49,11 @@ xfs_icreate_item_size(
 STATIC void
 xfs_icreate_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICREATE,
-			&icp->ic_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ICREATE, &icp->ic_format,
 			sizeof(struct xfs_icreate_log));
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 829675700fcd..5558befd9741 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -346,8 +346,7 @@ STATIC void
 xfs_inode_item_format_data_fork(
 	struct xfs_inode_log_item *iip,
 	struct xfs_inode_log_format *ilf,
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
@@ -364,9 +363,9 @@ xfs_inode_item_format_data_fork(
 
 			ASSERT(xfs_iext_count(&ip->i_df) > 0);
 
-			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IEXT);
+			p = xlog_format_start(lfb, XLOG_REG_TYPE_IEXT);
 			data_bytes = xfs_iextents_copy(ip, p, XFS_DATA_FORK);
-			xlog_finish_iovec(lv, *vecp, data_bytes);
+			xlog_format_commit(lfb, data_bytes);
 
 			ASSERT(data_bytes <= ip->i_df.if_bytes);
 
@@ -384,7 +383,7 @@ xfs_inode_item_format_data_fork(
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			ASSERT(ip->i_df.if_broot != NULL);
-			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IBROOT,
+			xlog_format_copy(lfb, XLOG_REG_TYPE_IBROOT,
 					ip->i_df.if_broot,
 					ip->i_df.if_broot_bytes);
 			ilf->ilf_dsize = ip->i_df.if_broot_bytes;
@@ -402,8 +401,9 @@ xfs_inode_item_format_data_fork(
 		    ip->i_df.if_bytes > 0) {
 			ASSERT(ip->i_df.if_data != NULL);
 			ASSERT(ip->i_disk_size > 0);
-			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
-					ip->i_df.if_data, ip->i_df.if_bytes);
+			xlog_format_copy(lfb, XLOG_REG_TYPE_ILOCAL,
+					ip->i_df.if_data,
+					ip->i_df.if_bytes);
 			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
 			ilf->ilf_size++;
 		} else {
@@ -426,8 +426,7 @@ STATIC void
 xfs_inode_item_format_attr_fork(
 	struct xfs_inode_log_item *iip,
 	struct xfs_inode_log_format *ilf,
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
@@ -445,9 +444,9 @@ xfs_inode_item_format_attr_fork(
 			ASSERT(xfs_iext_count(&ip->i_af) ==
 				ip->i_af.if_nextents);
 
-			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT);
+			p = xlog_format_start(lfb, XLOG_REG_TYPE_IATTR_EXT);
 			data_bytes = xfs_iextents_copy(ip, p, XFS_ATTR_FORK);
-			xlog_finish_iovec(lv, *vecp, data_bytes);
+			xlog_format_commit(lfb, data_bytes);
 
 			ilf->ilf_asize = data_bytes;
 			ilf->ilf_size++;
@@ -463,7 +462,7 @@ xfs_inode_item_format_attr_fork(
 		    ip->i_af.if_broot_bytes > 0) {
 			ASSERT(ip->i_af.if_broot != NULL);
 
-			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_BROOT,
+			xlog_format_copy(lfb, XLOG_REG_TYPE_IATTR_BROOT,
 					ip->i_af.if_broot,
 					ip->i_af.if_broot_bytes);
 			ilf->ilf_asize = ip->i_af.if_broot_bytes;
@@ -479,8 +478,9 @@ xfs_inode_item_format_attr_fork(
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_af.if_bytes > 0) {
 			ASSERT(ip->i_af.if_data != NULL);
-			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
-					ip->i_af.if_data, ip->i_af.if_bytes);
+			xlog_format_copy(lfb, XLOG_REG_TYPE_IATTR_LOCAL,
+					ip->i_af.if_data,
+					ip->i_af.if_bytes);
 			ilf->ilf_asize = (unsigned)ip->i_af.if_bytes;
 			ilf->ilf_size++;
 		} else {
@@ -629,14 +629,13 @@ xfs_inode_to_log_dinode(
 static void
 xfs_inode_item_format_core(
 	struct xfs_inode	*ip,
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_log_dinode	*dic;
 
-	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
+	dic = xlog_format_start(lfb, XLOG_REG_TYPE_ICORE);
 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
-	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
+	xlog_format_commit(lfb, xfs_log_dinode_size(ip->i_mount));
 }
 
 /*
@@ -654,14 +653,13 @@ xfs_inode_item_format_core(
 STATIC void
 xfs_inode_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_inode_log_format *ilf;
 
-	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
+	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
 	ilf->ilf_ino = ip->i_ino;
 	ilf->ilf_blkno = ip->i_imap.im_blkno;
@@ -678,13 +676,12 @@ xfs_inode_item_format(
 	ilf->ilf_asize = 0;
 	ilf->ilf_pad = 0;
 	memset(&ilf->ilf_u, 0, sizeof(ilf->ilf_u));
+	xlog_format_commit(lfb, sizeof(*ilf));
 
-	xlog_finish_iovec(lv, vecp, sizeof(*ilf));
-
-	xfs_inode_item_format_core(ip, lv, &vecp);
-	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
+	xfs_inode_item_format_core(ip, lfb);
+	xfs_inode_item_format_data_fork(iip, ilf, lfb);
 	if (xfs_inode_has_attr_fork(ip)) {
-		xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
+		xfs_inode_item_format_attr_fork(iip, ilf, lfb);
 	} else {
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2e2e1202e5bd..621d22328622 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -74,62 +74,6 @@ xlog_iclogs_empty(
 static int
 xfs_log_cover(struct xfs_mount *);
 
-/*
- * We need to make sure the buffer pointer returned is naturally aligned for the
- * biggest basic data type we put into it. We have already accounted for this
- * padding when sizing the buffer.
- *
- * However, this padding does not get written into the log, and hence we have to
- * track the space used by the log vectors separately to prevent log space hangs
- * due to inaccurate accounting (i.e. a leak) of the used log space through the
- * CIL context ticket.
- *
- * We also add space for the xlog_op_header that describes this region in the
- * log. This prepends the data region we return to the caller to copy their data
- * into, so do all the static initialisation of the ophdr now. Because the ophdr
- * is not 8 byte aligned, we have to be careful to ensure that we align the
- * start of the buffer such that the region we return to the call is 8 byte
- * aligned and packed against the tail of the ophdr.
- */
-void *
-xlog_prepare_iovec(
-	struct xfs_log_vec	*lv,
-	struct xfs_log_iovec	**vecp,
-	uint			type)
-{
-	struct xfs_log_iovec	*vec = *vecp;
-	struct xlog_op_header	*oph;
-	uint32_t		len;
-	void			*buf;
-
-	if (vec) {
-		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
-		vec++;
-	} else {
-		vec = &lv->lv_iovecp[0];
-	}
-
-	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
-	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
-		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
-					sizeof(struct xlog_op_header);
-	}
-
-	vec->i_type = type;
-	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
-
-	oph = vec->i_addr;
-	oph->oh_clientid = XFS_TRANSACTION;
-	oph->oh_res2 = 0;
-	oph->oh_flags = 0;
-
-	buf = vec->i_addr + sizeof(struct xlog_op_header);
-	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
-
-	*vecp = vec;
-	return buf;
-}
-
 static inline void
 xlog_grant_sub_space(
 	struct xlog_grant_head	*head,
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index af6daf4f6792..110f02690f85 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -6,6 +6,7 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
+struct xlog_format_buf;
 struct xfs_cil_ctx;
 
 struct xfs_log_vec {
@@ -33,58 +34,24 @@ xlog_calc_iovec_len(int len)
 	return roundup(len, sizeof(uint32_t));
 }
 
-void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
-		uint type);
-
-static inline void
-xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
-		int data_len)
-{
-	struct xlog_op_header	*oph = vec->i_addr;
-	int			len;
-
-	/*
-	 * Always round up the length to the correct alignment so callers don't
-	 * need to know anything about this log vec layout requirement. This
-	 * means we have to zero the area the data to be written does not cover.
-	 * This is complicated by fact the payload region is offset into the
-	 * logvec region by the opheader that tracks the payload.
-	 */
-	len = xlog_calc_iovec_len(data_len);
-	if (len - data_len != 0) {
-		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
-
-		memset(buf + data_len, 0, len - data_len);
-	}
-
-	/*
-	 * The opheader tracks aligned payload length, whilst the logvec tracks
-	 * the overall region length.
-	 */
-	oph->oh_len = cpu_to_be32(len);
-
-	len += sizeof(struct xlog_op_header);
-	lv->lv_buf_used += len;
-	lv->lv_bytes += len;
-	vec->i_len = len;
-
-	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
-		(void *)lv + lv->lv_alloc_size);
-}
+void *xlog_format_start(struct xlog_format_buf *lfb, uint16_t type);
+void xlog_format_commit(struct xlog_format_buf *lfb, unsigned int data_len);
 
 /*
  * Copy the amount of data requested by the caller into a new log iovec.
  */
 static inline void *
-xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
-		uint type, void *data, int len)
+xlog_format_copy(
+	struct xlog_format_buf	*lfb,
+	uint16_t		type,
+	void			*data,
+	unsigned int		len)
 {
 	void *buf;
 
-	buf = xlog_prepare_iovec(lv, vecp, type);
+	buf = xlog_format_start(lfb, type);
 	memcpy(buf, data, len);
-	xlog_finish_iovec(lv, *vecp, len);
+	xlog_format_commit(lfb, len);
 	return buf;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 1ac2cd9a5a36..3be2e6b097a8 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -409,6 +409,102 @@ xfs_cil_prepare_item(
 		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
 }
 
+struct xlog_format_buf {
+	struct xfs_log_vec	*lv;
+	unsigned int		idx;
+};
+
+/*
+ * We need to make sure the buffer pointer returned is naturally aligned for the
+ * biggest basic data type we put into it. We have already accounted for this
+ * padding when sizing the buffer.
+ *
+ * However, this padding does not get written into the log, and hence we have to
+ * track the space used by the log vectors separately to prevent log space hangs
+ * due to inaccurate accounting (i.e. a leak) of the used log space through the
+ * CIL context ticket.
+ *
+ * We also add space for the xlog_op_header that describes this region in the
+ * log. This prepends the data region we return to the caller to copy their data
+ * into, so do all the static initialisation of the ophdr now. Because the ophdr
+ * is not 8 byte aligned, we have to be careful to ensure that we align the
+ * start of the buffer such that the region we return to the call is 8 byte
+ * aligned and packed against the tail of the ophdr.
+ */
+void *
+xlog_format_start(
+	struct xlog_format_buf	*lfb,
+	uint16_t		type)
+{
+	struct xfs_log_vec	*lv = lfb->lv;
+	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
+	struct xlog_op_header	*oph;
+	uint32_t		len;
+	void			*buf;
+
+	ASSERT(lfb->idx < lv->lv_niovecs);
+
+	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
+	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
+		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
+					sizeof(struct xlog_op_header);
+	}
+
+	vec->i_type = type;
+	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
+
+	oph = vec->i_addr;
+	oph->oh_clientid = XFS_TRANSACTION;
+	oph->oh_res2 = 0;
+	oph->oh_flags = 0;
+
+	buf = vec->i_addr + sizeof(struct xlog_op_header);
+	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
+	return buf;
+}
+
+void
+xlog_format_commit(
+	struct xlog_format_buf	*lfb,
+	unsigned int		data_len)
+{
+	struct xfs_log_vec	*lv = lfb->lv;
+	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
+	struct xlog_op_header	*oph = vec->i_addr;
+	int			len;
+
+	/*
+	 * Always round up the length to the correct alignment so callers don't
+	 * need to know anything about this log vec layout requirement. This
+	 * means we have to zero the area the data to be written does not cover.
+	 * This is complicated by fact the payload region is offset into the
+	 * logvec region by the opheader that tracks the payload.
+	 */
+	len = xlog_calc_iovec_len(data_len);
+	if (len - data_len != 0) {
+		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
+
+		memset(buf + data_len, 0, len - data_len);
+	}
+
+	/*
+	 * The opheader tracks aligned payload length, whilst the logvec tracks
+	 * the overall region length.
+	 */
+	oph->oh_len = cpu_to_be32(len);
+
+	len += sizeof(struct xlog_op_header);
+	lv->lv_buf_used += len;
+	lv->lv_bytes += len;
+	vec->i_len = len;
+
+	/* Catch buffer overruns */
+	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
+		(void *)lv + lv->lv_alloc_size);
+
+	lfb->idx++;
+}
+
 /*
  * Format log item into a flat buffers
  *
@@ -454,6 +550,7 @@ xlog_cil_insert_format_items(
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		struct xfs_log_vec *lv = lip->li_lv;
 		struct xfs_log_vec *shadow = lip->li_lv_shadow;
+		struct xlog_format_buf lfb = { };
 
 		/* Skip items which aren't dirty in this transaction. */
 		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
@@ -501,8 +598,9 @@ xlog_cil_insert_format_items(
 			lv->lv_item = lip;
 		}
 
+		lfb.lv = lv;
 		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
-		lip->li_ops->iop_format(lip, lv);
+		lip->li_ops->iop_format(lip, &lfb);
 		xfs_cil_prepare_item(log, lip, lv, diff_len);
 	}
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3728234699a2..a41f5b577e22 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -93,10 +93,9 @@ unsigned int xfs_cui_log_space(unsigned int nr)
 STATIC void
 xfs_cui_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(atomic_read(&cuip->cui_next_extent) ==
 			cuip->cui_format.cui_nextents);
@@ -105,7 +104,7 @@ xfs_cui_item_format(
 	cuip->cui_format.cui_type = lip->li_type;
 	cuip->cui_format.cui_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
 			xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents));
 }
 
@@ -199,17 +198,16 @@ unsigned int xfs_cud_log_space(void)
 STATIC void
 xfs_cud_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(lip->li_type == XFS_LI_CUD || lip->li_type == XFS_LI_CUD_RT);
 
 	cudp->cud_format.cud_type = lip->li_type;
 	cudp->cud_format.cud_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
 			sizeof(struct xfs_cud_log_format));
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 15f0903f6fd4..8bf04b101156 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -92,10 +92,9 @@ unsigned int xfs_rui_log_space(unsigned int nr)
 STATIC void
 xfs_rui_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_rui_log_item	*ruip = RUI_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(atomic_read(&ruip->rui_next_extent) ==
 			ruip->rui_format.rui_nextents);
@@ -105,7 +104,7 @@ xfs_rui_item_format(
 	ruip->rui_format.rui_type = lip->li_type;
 	ruip->rui_format.rui_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUI_FORMAT, &ruip->rui_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_RUI_FORMAT, &ruip->rui_format,
 			xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents));
 }
 
@@ -200,17 +199,16 @@ unsigned int xfs_rud_log_space(void)
 STATIC void
 xfs_rud_item_format(
 	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
+	struct xlog_format_buf	*lfb)
 {
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
 
 	ASSERT(lip->li_type == XFS_LI_RUD || lip->li_type == XFS_LI_RUD_RT);
 
 	rudp->rud_format.rud_type = lip->li_type;
 	rudp->rud_format.rud_size = 1;
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
+	xlog_format_copy(lfb, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
 			sizeof(struct xfs_rud_log_format));
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index fa1724b4690e..20ed112850d3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -9,6 +9,7 @@
 /* kernel only transaction subsystem defines */
 
 struct xlog;
+struct xlog_format_buf;
 struct xfs_buf;
 struct xfs_buftarg;
 struct xfs_efd_log_item;
@@ -70,7 +71,8 @@ struct xfs_log_item {
 struct xfs_item_ops {
 	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
-	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
+	void (*iop_format)(struct xfs_log_item *lip,
+			struct xlog_format_buf *lfb);
 	void (*iop_pin)(struct xfs_log_item *);
 	void (*iop_unpin)(struct xfs_log_item *, int remove);
 	uint64_t (*iop_sort)(struct xfs_log_item *lip);
-- 
2.47.2

