Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879830DEAE
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943067; cv=none; b=epMkL9SXmzdwY7BIJQMDHwfkR2PALzyKLhEGuSffHDPWcskk15UKHzDhQgwzVac7mznW5bEH4zQTKl9gYpYdraBZFpliFpaNe8ajUbQadR7d9C3lapU2bFJSfshBZY0Ftb8362OL/8D4ts4ZW0nnop7gLSYHiHI1MjbGd12US88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943067; c=relaxed/simple;
	bh=PZYi9KGZHvD9UsM3iS/IwHGov/PHUfk1tT1NGCuC9So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc3SxKml3TO1ANxqrDO/tNxPuITdeW+HFS7L+pxYvg6XLXBLn/I8U36lnAoB6NRBnIYghmuiM63ox/HlM6SUlvrkzoIpdEAozXxeV1HHlsLsdW1Scr5/2xS3Pr8/jEqbDZhOXUlhmiYa+y0vjwDNcIZ0Qmzkgh5ppbK/OXMlR5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CuHssb4x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CuHssb4x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vUcZNT+mjC0XDACN3+6/Au3t7ncY+8/wO3IwP6Oayqo=; b=CuHssb4xOanGx97bvGc6IT1V5C
	ZzxmmbGZd4ZZDf40lkkbLVjoL1VW++bMxOtkL3064+Tft8OGi+vnLrit1fV6kvzW4U93Atx+n9g7P
	Kaea22wfxI8Y4YkZktSyfH+1NygWy8T0AIlyaBULq+iYBL2N//Aatvp/7iocwC9OZhvZNx2Q7yg0h
	ZDf5ciavFeB3tC6hdXg7UOFJIMszgNo2yT7CajxSWqTims0l+oXPyZFS5decFko6Y4vbV5D78vAJb
	Ko1aCuZQ/ALzyULTr3vNnFHt3LRyG209Cnwo+lDLdPzz2EC1pOVUHx96xrMlsFCINXgaqiHBnpkz+
	7shC8Rug==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9IQ-00000004KUl-04oP;
	Mon, 15 Sep 2025 13:31:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: centralize error tag definitions
Date: Mon, 15 Sep 2025 06:30:41 -0700
Message-ID: <20250915133104.161037-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915133104.161037-1-hch@lst.de>
References: <20250915133104.161037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Right now 5 places in the kernel and one in xfsprogs need to be updated
for each new error tag.  Add a bit of macro magic so that only the
error tag definition and a single table, which reside next to each
other, need to be updated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_errortag.h |  94 ++++++++++----------
 fs/xfs/xfs_error.c           | 166 +++++------------------------------
 2 files changed, 69 insertions(+), 191 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a53c5d40e084..115b556f2238 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -4,7 +4,7 @@
  * Copyright (C) 2017 Oracle.
  * All Rights Reserved.
  */
-#ifndef __XFS_ERRORTAG_H_
+#if !defined(__XFS_ERRORTAG_H_) || defined(XFS_ERRTAG)
 #define __XFS_ERRORTAG_H_
 
 /*
@@ -71,49 +71,53 @@
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
  */
 #define XFS_RANDOM_DEFAULT				100
-#define XFS_RANDOM_IFLUSH_1				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IFLUSH_2				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IFLUSH_3				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IFLUSH_4				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IFLUSH_5				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IFLUSH_6				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_DA_READ_BUF				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_BTREE_CHECK_LBLOCK			(XFS_RANDOM_DEFAULT/4)
-#define XFS_RANDOM_BTREE_CHECK_SBLOCK			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_ALLOC_READ_AGF			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IALLOC_READ_AGI			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_ITOBP_INOTOBP			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IUNLINK				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IUNLINK_REMOVE			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_DIR_INO_VALIDATE			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_BULKSTAT_READ_CHUNK			XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_IODONE_IOERR				(XFS_RANDOM_DEFAULT/10)
-#define XFS_RANDOM_STRATREAD_IOERR			(XFS_RANDOM_DEFAULT/10)
-#define XFS_RANDOM_STRATCMPL_IOERR			(XFS_RANDOM_DEFAULT/10)
-#define XFS_RANDOM_DIOWRITE_IOERR			(XFS_RANDOM_DEFAULT/10)
-#define XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_FREE_EXTENT				1
-#define XFS_RANDOM_RMAP_FINISH_ONE			1
-#define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
-#define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
-#define XFS_RANDOM_BMAP_FINISH_ONE			1
-#define XFS_RANDOM_AG_RESV_CRITICAL			4
-#define XFS_RANDOM_LOG_BAD_CRC				1
-#define XFS_RANDOM_LOG_ITEM_PIN				1
-#define XFS_RANDOM_BUF_LRU_REF				2
-#define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
-#define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
-#define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
-#define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
-#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
-#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
-#define XFS_RANDOM_AG_RESV_FAIL				1
-#define XFS_RANDOM_LARP					1
-#define XFS_RANDOM_DA_LEAF_SPLIT			1
-#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
-#define XFS_RANDOM_WB_DELAY_MS				3000
-#define XFS_RANDOM_WRITE_DELAY_MS			3000
-#define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
-#define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
+
+#define XFS_ERRTAGS \
+XFS_ERRTAG(NOERROR,		noerror,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IFLUSH_1,		iflush1,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IFLUSH_2,		iflush2,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IFLUSH_3,		iflush3,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IFLUSH_4,		iflush4,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IFLUSH_5,		iflush5,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IFLUSH_6,		iflush6,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(DA_READ_BUF,		dareadbuf,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(BTREE_CHECK_LBLOCK,	btree_chk_lblk,		XFS_RANDOM_DEFAULT/4) \
+XFS_ERRTAG(BTREE_CHECK_SBLOCK,	btree_chk_sblk,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(ALLOC_READ_AGF,	readagf,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IALLOC_READ_AGI,	readagi,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(ITOBP_INOTOBP,	itobp,			XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IUNLINK,		iunlink,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IUNLINK_REMOVE,	iunlinkrm,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(DIR_INO_VALIDATE,	dirinovalid,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(BULKSTAT_READ_CHUNK,	bulkstat,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(IODONE_IOERR,	logiodone,		XFS_RANDOM_DEFAULT/10) \
+XFS_ERRTAG(STRATREAD_IOERR,	stratread,		XFS_RANDOM_DEFAULT/10) \
+XFS_ERRTAG(STRATCMPL_IOERR,	stratcmpl,		XFS_RANDOM_DEFAULT/10) \
+XFS_ERRTAG(DIOWRITE_IOERR,	diowrite,		XFS_RANDOM_DEFAULT/10) \
+XFS_ERRTAG(BMAPIFORMAT,		bmapifmt,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(FREE_EXTENT,		free_extent,		1) \
+XFS_ERRTAG(RMAP_FINISH_ONE,	rmap_finish_one,	1) \
+XFS_ERRTAG(REFCOUNT_CONTINUE_UPDATE, \
+				refcount_continue_update, 1) \
+XFS_ERRTAG(REFCOUNT_FINISH_ONE,	refcount_finish_one,	1) \
+XFS_ERRTAG(BMAP_FINISH_ONE,	bmap_finish_one,	1) \
+XFS_ERRTAG(AG_RESV_CRITICAL,	ag_resv_critical,	4) \
+XFS_ERRTAG(LOG_BAD_CRC,		log_bad_crc,		1) \
+XFS_ERRTAG(LOG_ITEM_PIN,	log_item_pin,		1) \
+XFS_ERRTAG(BUF_LRU_REF,		buf_lru_ref,		2) \
+XFS_ERRTAG(FORCE_SCRUB_REPAIR,	force_repair,		1) \
+XFS_ERRTAG(FORCE_SUMMARY_RECALC, bad_summary,		1) \
+XFS_ERRTAG(IUNLINK_FALLBACK,	iunlink_fallback,	XFS_RANDOM_DEFAULT/10) \
+XFS_ERRTAG(BUF_IOERROR,		buf_ioerror,		XFS_RANDOM_DEFAULT) \
+XFS_ERRTAG(REDUCE_MAX_IEXTENTS,	reduce_max_iextents,	1) \
+XFS_ERRTAG(BMAP_ALLOC_MINLEN_EXTENT, bmap_alloc_minlen_extent, 1) \
+XFS_ERRTAG(AG_RESV_FAIL,	ag_resv_fail,		1) \
+XFS_ERRTAG(LARP,		larp,			1) \
+XFS_ERRTAG(DA_LEAF_SPLIT,	da_leaf_split,		1) \
+XFS_ERRTAG(ATTR_LEAF_TO_NODE,	attr_leaf_to_node,	1) \
+XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
+XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
+XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
+XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 44dd8aba0097..ac895cd2bc0a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -10,61 +10,17 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_sysfs.h"
 #include "xfs_inode.h"
 
 #ifdef DEBUG
 
-static unsigned int xfs_errortag_random_default[] = {
-	XFS_RANDOM_DEFAULT,
-	XFS_RANDOM_IFLUSH_1,
-	XFS_RANDOM_IFLUSH_2,
-	XFS_RANDOM_IFLUSH_3,
-	XFS_RANDOM_IFLUSH_4,
-	XFS_RANDOM_IFLUSH_5,
-	XFS_RANDOM_IFLUSH_6,
-	XFS_RANDOM_DA_READ_BUF,
-	XFS_RANDOM_BTREE_CHECK_LBLOCK,
-	XFS_RANDOM_BTREE_CHECK_SBLOCK,
-	XFS_RANDOM_ALLOC_READ_AGF,
-	XFS_RANDOM_IALLOC_READ_AGI,
-	XFS_RANDOM_ITOBP_INOTOBP,
-	XFS_RANDOM_IUNLINK,
-	XFS_RANDOM_IUNLINK_REMOVE,
-	XFS_RANDOM_DIR_INO_VALIDATE,
-	XFS_RANDOM_BULKSTAT_READ_CHUNK,
-	XFS_RANDOM_IODONE_IOERR,
-	XFS_RANDOM_STRATREAD_IOERR,
-	XFS_RANDOM_STRATCMPL_IOERR,
-	XFS_RANDOM_DIOWRITE_IOERR,
-	XFS_RANDOM_BMAPIFORMAT,
-	XFS_RANDOM_FREE_EXTENT,
-	XFS_RANDOM_RMAP_FINISH_ONE,
-	XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE,
-	XFS_RANDOM_REFCOUNT_FINISH_ONE,
-	XFS_RANDOM_BMAP_FINISH_ONE,
-	XFS_RANDOM_AG_RESV_CRITICAL,
-	0, /* XFS_RANDOM_DROP_WRITES has been removed */
-	XFS_RANDOM_LOG_BAD_CRC,
-	XFS_RANDOM_LOG_ITEM_PIN,
-	XFS_RANDOM_BUF_LRU_REF,
-	XFS_RANDOM_FORCE_SCRUB_REPAIR,
-	XFS_RANDOM_FORCE_SUMMARY_RECALC,
-	XFS_RANDOM_IUNLINK_FALLBACK,
-	XFS_RANDOM_BUF_IOERROR,
-	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
-	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
-	XFS_RANDOM_AG_RESV_FAIL,
-	XFS_RANDOM_LARP,
-	XFS_RANDOM_DA_LEAF_SPLIT,
-	XFS_RANDOM_ATTR_LEAF_TO_NODE,
-	XFS_RANDOM_WB_DELAY_MS,
-	XFS_RANDOM_WRITE_DELAY_MS,
-	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
-	XFS_RANDOM_METAFILE_RESV_CRITICAL,
-};
+#define XFS_ERRTAG(_tag, _name, _default) \
+	[XFS_ERRTAG_##_tag]	= (_default),
+#include "xfs_errortag.h"
+static unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
+#undef XFS_ERRTAG
 
 struct xfs_errortag_attr {
 	struct attribute	attr;
@@ -125,110 +81,28 @@ static const struct sysfs_ops xfs_errortag_sysfs_ops = {
 	.store = xfs_errortag_attr_store,
 };
 
-#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
+#define XFS_ERRTAG(_tag, _name, _default)				\
 static struct xfs_errortag_attr xfs_errortag_attr_##_name = {		\
 	.attr = {.name = __stringify(_name),				\
 		 .mode = VERIFY_OCTAL_PERMISSIONS(S_IWUSR | S_IRUGO) },	\
-	.tag	= (_tag),						\
-}
-
-#define XFS_ERRORTAG_ATTR_LIST(_name) &xfs_errortag_attr_##_name.attr
-
-XFS_ERRORTAG_ATTR_RW(noerror,		XFS_ERRTAG_NOERROR);
-XFS_ERRORTAG_ATTR_RW(iflush1,		XFS_ERRTAG_IFLUSH_1);
-XFS_ERRORTAG_ATTR_RW(iflush2,		XFS_ERRTAG_IFLUSH_2);
-XFS_ERRORTAG_ATTR_RW(iflush3,		XFS_ERRTAG_IFLUSH_3);
-XFS_ERRORTAG_ATTR_RW(iflush4,		XFS_ERRTAG_IFLUSH_4);
-XFS_ERRORTAG_ATTR_RW(iflush5,		XFS_ERRTAG_IFLUSH_5);
-XFS_ERRORTAG_ATTR_RW(iflush6,		XFS_ERRTAG_IFLUSH_6);
-XFS_ERRORTAG_ATTR_RW(dareadbuf,		XFS_ERRTAG_DA_READ_BUF);
-XFS_ERRORTAG_ATTR_RW(btree_chk_lblk,	XFS_ERRTAG_BTREE_CHECK_LBLOCK);
-XFS_ERRORTAG_ATTR_RW(btree_chk_sblk,	XFS_ERRTAG_BTREE_CHECK_SBLOCK);
-XFS_ERRORTAG_ATTR_RW(readagf,		XFS_ERRTAG_ALLOC_READ_AGF);
-XFS_ERRORTAG_ATTR_RW(readagi,		XFS_ERRTAG_IALLOC_READ_AGI);
-XFS_ERRORTAG_ATTR_RW(itobp,		XFS_ERRTAG_ITOBP_INOTOBP);
-XFS_ERRORTAG_ATTR_RW(iunlink,		XFS_ERRTAG_IUNLINK);
-XFS_ERRORTAG_ATTR_RW(iunlinkrm,		XFS_ERRTAG_IUNLINK_REMOVE);
-XFS_ERRORTAG_ATTR_RW(dirinovalid,	XFS_ERRTAG_DIR_INO_VALIDATE);
-XFS_ERRORTAG_ATTR_RW(bulkstat,		XFS_ERRTAG_BULKSTAT_READ_CHUNK);
-XFS_ERRORTAG_ATTR_RW(logiodone,		XFS_ERRTAG_IODONE_IOERR);
-XFS_ERRORTAG_ATTR_RW(stratread,		XFS_ERRTAG_STRATREAD_IOERR);
-XFS_ERRORTAG_ATTR_RW(stratcmpl,		XFS_ERRTAG_STRATCMPL_IOERR);
-XFS_ERRORTAG_ATTR_RW(diowrite,		XFS_ERRTAG_DIOWRITE_IOERR);
-XFS_ERRORTAG_ATTR_RW(bmapifmt,		XFS_ERRTAG_BMAPIFORMAT);
-XFS_ERRORTAG_ATTR_RW(free_extent,	XFS_ERRTAG_FREE_EXTENT);
-XFS_ERRORTAG_ATTR_RW(rmap_finish_one,	XFS_ERRTAG_RMAP_FINISH_ONE);
-XFS_ERRORTAG_ATTR_RW(refcount_continue_update,	XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE);
-XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
-XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
-XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
-XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
-XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
-XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
-XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
-XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
-XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
-XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
-XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
-XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
-XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
-XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
-XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
-XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
-XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
-XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
-XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
-XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+	.tag	= XFS_ERRTAG_##_tag,					\
+};
+#include "xfs_errortag.h"
+XFS_ERRTAGS
+#undef XFS_ERRTAG
 
+#define XFS_ERRTAG(_tag, _name, _default) \
+	&xfs_errortag_attr_##_name.attr,
+#include "xfs_errortag.h"
 static struct attribute *xfs_errortag_attrs[] = {
-	XFS_ERRORTAG_ATTR_LIST(noerror),
-	XFS_ERRORTAG_ATTR_LIST(iflush1),
-	XFS_ERRORTAG_ATTR_LIST(iflush2),
-	XFS_ERRORTAG_ATTR_LIST(iflush3),
-	XFS_ERRORTAG_ATTR_LIST(iflush4),
-	XFS_ERRORTAG_ATTR_LIST(iflush5),
-	XFS_ERRORTAG_ATTR_LIST(iflush6),
-	XFS_ERRORTAG_ATTR_LIST(dareadbuf),
-	XFS_ERRORTAG_ATTR_LIST(btree_chk_lblk),
-	XFS_ERRORTAG_ATTR_LIST(btree_chk_sblk),
-	XFS_ERRORTAG_ATTR_LIST(readagf),
-	XFS_ERRORTAG_ATTR_LIST(readagi),
-	XFS_ERRORTAG_ATTR_LIST(itobp),
-	XFS_ERRORTAG_ATTR_LIST(iunlink),
-	XFS_ERRORTAG_ATTR_LIST(iunlinkrm),
-	XFS_ERRORTAG_ATTR_LIST(dirinovalid),
-	XFS_ERRORTAG_ATTR_LIST(bulkstat),
-	XFS_ERRORTAG_ATTR_LIST(logiodone),
-	XFS_ERRORTAG_ATTR_LIST(stratread),
-	XFS_ERRORTAG_ATTR_LIST(stratcmpl),
-	XFS_ERRORTAG_ATTR_LIST(diowrite),
-	XFS_ERRORTAG_ATTR_LIST(bmapifmt),
-	XFS_ERRORTAG_ATTR_LIST(free_extent),
-	XFS_ERRORTAG_ATTR_LIST(rmap_finish_one),
-	XFS_ERRORTAG_ATTR_LIST(refcount_continue_update),
-	XFS_ERRORTAG_ATTR_LIST(refcount_finish_one),
-	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
-	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
-	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
-	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
-	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
-	XFS_ERRORTAG_ATTR_LIST(force_repair),
-	XFS_ERRORTAG_ATTR_LIST(bad_summary),
-	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
-	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
-	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
-	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
-	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
-	XFS_ERRORTAG_ATTR_LIST(larp),
-	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
-	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
-	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
-	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
-	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
-	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
-	NULL,
+	XFS_ERRTAGS
+	NULL
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
+#undef XFS_ERRTAG
+
+/* -1 because XFS_ERRTAG_DROP_WRITES got removed, + 1 for NULL termination */
+static_assert(ARRAY_SIZE(xfs_errortag_attrs) == XFS_ERRTAG_MAX);
 
 static const struct kobj_type xfs_errortag_ktype = {
 	.release = xfs_sysfs_release,
-- 
2.47.2

