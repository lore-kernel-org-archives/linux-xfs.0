Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FD12FC007
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943218; cv=none; b=TWloIws8hNOHJKoc6/dY7Qlt5VlRyfyNHQgi1lQ+481+9mDJNFFCvCjarhG6r3Ln7yWnLGpsrpTySgP26QHRch8zdQ1ACRoQ9qfMDr/O1zClwCTCaGJuxjfF1q74EiWTDIhoCFvcDqO/KnPcIUDGJwW7sqaaKduuvfYezR5S2tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943218; c=relaxed/simple;
	bh=oTsy3/lt415jib9ZTyVA6wl+m903+LVZLl8GAFua4+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz0645VqD4Ez3RiKgYcMQ6jJKB4yVbeSfbeuT4RsS/7dLUBJwfk54oEkHcGHShPTWN5BpjW4LKZBfpK6y7+0ZRHIPLJWIfU9ZAYIcoKYOYCOzJEDEdwvVv1AQLtp7FDcPwmp5TdIawVBtFPOLWhvDRP3pLmOOWZkkm6hdLDwoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h4V+mSb5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h4V+mSb5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JBEhkdj9y25/MDlnAmR5diqTksVetpM4okjdTL7dRew=; b=h4V+mSb5b9EyFNXbQkCy0RPTXe
	xZGMsqWtarQMjrU6/5kxzGXGs5tcyxUdPmDEfEJwHMzW0chS2xiX7RHUW57zDcVFfVyzhBrm2RdGt
	/oIsD37PzL+/c+kAUhnwMYwn3RF5vp2WTSBoYVyXqlwivP1IMB6Ww5bRX90qlm9xtbMfGam4TKGnT
	k9+RDHWK5yzqAs66bi+beksZGSONS/3JJ4QfWIhlsJ/HaBZGSDoMMqbo23b7CkpuBDE2QEzOVxorE
	P/tDTcx73Bl4f87dBxVX0APrh4MYJCxOx8qtYieEaVxLEs4vfLf/lcKERykPIYJUCZUfO4fRqeqrj
	bGpaC71g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Kq-00000004L1a-2RNM;
	Mon, 15 Sep 2025 13:33:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: centralize error tag definitions
Date: Mon, 15 Sep 2025 06:33:16 -0700
Message-ID: <20250915133336.161352-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915133336.161352-1-hch@lst.de>
References: <20250915133336.161352-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 52aeb4e21ee033a95798217e4cea3ac98cc442d7

Right now 5 places in the kernel and one in xfsprogs need to be updated
for each new error tag.  Add a bit of macro magic so that only the
error tag definition and a single table, which reside next to each
other, need to be updated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_errortag.h | 94 ++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 45 deletions(-)

diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index a53c5d40e084..115b556f2238 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
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
-- 
2.47.2

