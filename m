Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5475C1EDA09
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582703; cv=none; b=qVefwgIsWB6b9puU1gvDHWzRjL8NmJSL3KdlUaHKWmMRd35clVCUoqxd8tVLsDvunYhLwceJkBqhW5ogAmz5NXeiYqOuDtaNWFmXEKuEh+h9woa2yTtiuTQuAc6WDWBN5MZ/hHMDnbS9SJfpxhQm9qqKqxtBUaGZqDqoKZ9GXEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582703; c=relaxed/simple;
	bh=74UpISQXbcXILKTBdLwDS/sR10Jj2SRvl77+dqafLmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBaKoREwl6gXtvk2Bmqj/MiolPJPzjuCW8ZIb4qwSDJqamDMFuYNd78XY6XMdPTK6Jn2gwFhl5CQY+bb8rSVsf3lSfSjwf9uBNb82o7LABSdiveJ5RTMWGqTJB0Pzy8fkt1XmxQO8eALUtciZDvGXsXCH/dQd0MOR+g63VIlSXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q8gu4SQ7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q8gu4SQ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3/rGp8y31EVr4jyxxSFGMfosPoHGx6RklR42k4pjHIw=; b=q8gu4SQ7IL4Ab1r2s263A2IFF/
	f1T75/DZ+XLrLsfWqlDjjLqE/aYbRdHiDXRZ9JeCzWwvnAw2/C+BHm/mYdDEZC5bhfd70/78zsvXF
	Fo2Y9G2vumGU/FCqj1J4syWQ4J4yco2yK2v636w6qb3s7w9OPSySsRwj7+HTN7ahdDydGpuch2KSa
	lth0wqki2ynixZOxvlPv/mcgfYyzQ+DrtjLiXzXISCjjVB3PujdXO/jAm2oLlhYkqCpLmYtCr2MxR
	y51lhOIC4bkMtybmCTw5x5y4TbSq5h59nNT86TkjZ9NXI8h6tNObd1YNytZ/62UcYfFbCL6MHqhu+
	d0yEHYhQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubeou-000000054nf-1CLI;
	Tue, 15 Jul 2025 12:31:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 05/18] xfs: don't use a xfs_log_iovec for ri_buf in log recovery
Date: Tue, 15 Jul 2025 14:30:10 +0200
Message-ID: <20250715123125.1945534-6-hch@lst.de>
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

ri_buf just holds a pointer/len pair and is not a log iovec used for
writing to the log.  Switch to use a kvec instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  4 +--
 fs/xfs/xfs_attr_item.c          | 32 +++++++++---------
 fs/xfs/xfs_bmap_item.c          | 18 +++++-----
 fs/xfs/xfs_buf_item.c           |  8 ++---
 fs/xfs/xfs_buf_item.h           |  2 +-
 fs/xfs/xfs_buf_item_recover.c   | 38 ++++++++++-----------
 fs/xfs/xfs_dquot_item_recover.c | 20 +++++------
 fs/xfs/xfs_exchmaps_item.c      |  8 ++---
 fs/xfs/xfs_extfree_item.c       | 59 +++++++++++++++++----------------
 fs/xfs/xfs_icreate_item.c       |  2 +-
 fs/xfs/xfs_inode_item.c         |  6 ++--
 fs/xfs/xfs_inode_item.h         |  4 +--
 fs/xfs/xfs_inode_item_recover.c | 26 +++++++--------
 fs/xfs/xfs_log_recover.c        | 16 ++++-----
 fs/xfs/xfs_refcount_item.c      | 34 +++++++++----------
 fs/xfs/xfs_rmap_item.c          | 34 +++++++++----------
 fs/xfs/xfs_trans.h              |  1 -
 17 files changed, 157 insertions(+), 155 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 66c7916fb5cd..95de23095030 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -104,7 +104,7 @@ struct xlog_recover_item {
 	struct list_head	ri_list;
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
-	struct xfs_log_iovec	*ri_buf;	/* ptr to regions buffer */
+	struct kvec		*ri_buf;	/* ptr to regions buffer */
 	const struct xlog_recover_item_ops *ri_ops;
 };
 
@@ -117,7 +117,7 @@ struct xlog_recover {
 	struct list_head	r_itemq;	/* q for items */
 };
 
-#define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
+#define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].iov_base)
 
 #define	XLOG_RECOVER_CRCPASS	0
 #define	XLOG_RECOVER_PASS1	1
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2b3dde2eec9c..bc970aa6832f 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -954,50 +954,50 @@ static inline void *
 xfs_attri_validate_name_iovec(
 	struct xfs_mount		*mp,
 	struct xfs_attri_log_format     *attri_formatp,
-	const struct xfs_log_iovec	*iovec,
+	const struct kvec		*iovec,
 	unsigned int			name_len)
 {
-	if (iovec->i_len != xlog_calc_iovec_len(name_len)) {
+	if (iovec->iov_len != xlog_calc_iovec_len(name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, sizeof(*attri_formatp));
 		return NULL;
 	}
 
-	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, iovec->i_addr,
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, iovec->iov_base,
 				name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, sizeof(*attri_formatp));
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				iovec->i_addr, iovec->i_len);
+				iovec->iov_base, iovec->iov_len);
 		return NULL;
 	}
 
-	return iovec->i_addr;
+	return iovec->iov_base;
 }
 
 static inline void *
 xfs_attri_validate_value_iovec(
 	struct xfs_mount		*mp,
 	struct xfs_attri_log_format     *attri_formatp,
-	const struct xfs_log_iovec	*iovec,
+	const struct kvec		*iovec,
 	unsigned int			value_len)
 {
-	if (iovec->i_len != xlog_calc_iovec_len(value_len)) {
+	if (iovec->iov_len != xlog_calc_iovec_len(value_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, sizeof(*attri_formatp));
 		return NULL;
 	}
 
 	if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
-	    !xfs_parent_valuecheck(mp, iovec->i_addr, value_len)) {
+	    !xfs_parent_valuecheck(mp, iovec->iov_base, value_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, sizeof(*attri_formatp));
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				iovec->i_addr, iovec->i_len);
+				iovec->iov_base, iovec->iov_len);
 		return NULL;
 	}
 
-	return iovec->i_addr;
+	return iovec->iov_base;
 }
 
 STATIC int
@@ -1024,13 +1024,13 @@ xlog_recover_attri_commit_pass2(
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[i].i_len != len) {
+	if (item->ri_buf[i].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
-	attri_formatp = item->ri_buf[i].i_addr;
+	attri_formatp = item->ri_buf[i].iov_base;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
@@ -1219,10 +1219,10 @@ xlog_recover_attrd_commit_pass2(
 {
 	struct xfs_attrd_log_format	*attrd_formatp;
 
-	attrd_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
+	attrd_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_attrd_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 646c515ee355..80f0c4bcc483 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -654,24 +654,24 @@ xlog_recover_bui_commit_pass2(
 	struct xfs_bui_log_format	*bui_formatp;
 	size_t				len;
 
-	bui_formatp = item->ri_buf[0].i_addr;
+	bui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_bui_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_bui_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
 	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_bui_log_format_sizeof(bui_formatp->bui_nextents);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[0].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -705,10 +705,10 @@ xlog_recover_bud_commit_pass2(
 {
 	struct xfs_bud_log_format	*bud_formatp;
 
-	bud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
+	bud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_bud_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7fc54725c5f6..8d85b5eee444 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -90,16 +90,16 @@ xfs_buf_item_relse(
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
-	struct xfs_log_iovec		*iovec)
+	struct kvec			*iovec)
 {
-	struct xfs_buf_log_format	*blfp = iovec->i_addr;
+	struct xfs_buf_log_format	*blfp = iovec->iov_base;
 	char				*bmp_end;
 	char				*item_end;
 
-	if (offsetof(struct xfs_buf_log_format, blf_data_map) > iovec->i_len)
+	if (offsetof(struct xfs_buf_log_format, blf_data_map) > iovec->iov_len)
 		return false;
 
-	item_end = (char *)iovec->i_addr + iovec->i_len;
+	item_end = (char *)iovec->iov_base + iovec->iov_len;
 	bmp_end = (char *)&blfp->blf_data_map[blfp->blf_map_size];
 	return bmp_end <= item_end;
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 416890b84f8c..3159325dd17b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -61,7 +61,7 @@ static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
 }
 #endif /* CONFIG_XFS_QUOTA */
 void	xfs_buf_iodone(struct xfs_buf *);
-bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
+bool	xfs_buf_log_check_iovec(struct kvec *iovec);
 
 unsigned int xfs_buf_inval_log_space(unsigned int map_count,
 		unsigned int blocksize);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d4c5cef5bc43..5d58e2ae4972 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -159,7 +159,7 @@ STATIC enum xlog_recover_reorder
 xlog_recover_buf_reorder(
 	struct xlog_recover_item	*item)
 {
-	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
 
 	if (buf_f->blf_flags & XFS_BLF_CANCEL)
 		return XLOG_REORDER_CANCEL_LIST;
@@ -173,7 +173,7 @@ xlog_recover_buf_ra_pass2(
 	struct xlog                     *log,
 	struct xlog_recover_item        *item)
 {
-	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
 
 	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
 }
@@ -187,11 +187,11 @@ xlog_recover_buf_commit_pass1(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
 {
-	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
+	struct xfs_buf_log_format	*bf = item->ri_buf[0].iov_base;
 
 	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
-		xfs_err(log->l_mp, "bad buffer log item size (%d)",
-				item->ri_buf[0].i_len);
+		xfs_err(log->l_mp, "bad buffer log item size (%zd)",
+				item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -487,8 +487,8 @@ xlog_recover_do_reg_buffer(
 		nbits = xfs_contig_bits(buf_f->blf_data_map,
 					buf_f->blf_map_size, bit);
 		ASSERT(nbits > 0);
-		ASSERT(item->ri_buf[i].i_addr != NULL);
-		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
+		ASSERT(item->ri_buf[i].iov_base != NULL);
+		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
 		ASSERT(BBTOB(bp->b_length) >=
 		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
 
@@ -500,8 +500,8 @@ xlog_recover_do_reg_buffer(
 		 * the log. Hence we need to trim nbits back to the length of
 		 * the current region being copied out of the log.
 		 */
-		if (item->ri_buf[i].i_len < (nbits << XFS_BLF_SHIFT))
-			nbits = item->ri_buf[i].i_len >> XFS_BLF_SHIFT;
+		if (item->ri_buf[i].iov_len < (nbits << XFS_BLF_SHIFT))
+			nbits = item->ri_buf[i].iov_len >> XFS_BLF_SHIFT;
 
 		/*
 		 * Do a sanity check if this is a dquot buffer. Just checking
@@ -511,18 +511,18 @@ xlog_recover_do_reg_buffer(
 		fa = NULL;
 		if (buf_f->blf_flags &
 		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-			if (item->ri_buf[i].i_addr == NULL) {
+			if (item->ri_buf[i].iov_base == NULL) {
 				xfs_alert(mp,
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < size_disk_dquot) {
+			if (item->ri_buf[i].iov_len < size_disk_dquot) {
 				xfs_alert(mp,
-					"XFS: dquot too small (%d) in %s.",
-					item->ri_buf[i].i_len, __func__);
+					"XFS: dquot too small (%zd) in %s.",
+					item->ri_buf[i].iov_len, __func__);
 				goto next;
 			}
-			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
+			fa = xfs_dquot_verify(mp, item->ri_buf[i].iov_base, -1);
 			if (fa) {
 				xfs_alert(mp,
 	"dquot corrupt at %pS trying to replay into block 0x%llx",
@@ -533,7 +533,7 @@ xlog_recover_do_reg_buffer(
 
 		memcpy(xfs_buf_offset(bp,
 			(uint)bit << XFS_BLF_SHIFT),	/* dest */
-			item->ri_buf[i].i_addr,		/* source */
+			item->ri_buf[i].iov_base,		/* source */
 			nbits<<XFS_BLF_SHIFT);		/* length */
  next:
 		i++;
@@ -669,8 +669,8 @@ xlog_recover_do_inode_buffer(
 		if (next_unlinked_offset < reg_buf_offset)
 			continue;
 
-		ASSERT(item->ri_buf[item_index].i_addr != NULL);
-		ASSERT((item->ri_buf[item_index].i_len % XFS_BLF_CHUNK) == 0);
+		ASSERT(item->ri_buf[item_index].iov_base != NULL);
+		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
 		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
 
 		/*
@@ -678,7 +678,7 @@ xlog_recover_do_inode_buffer(
 		 * current di_next_unlinked field.  Extract its value
 		 * and copy it to the buffer copy.
 		 */
-		logged_nextp = item->ri_buf[item_index].i_addr +
+		logged_nextp = item->ri_buf[item_index].iov_base +
 				next_unlinked_offset - reg_buf_offset;
 		if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
 			xfs_alert(mp,
@@ -1002,7 +1002,7 @@ xlog_recover_buf_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			current_lsn)
 {
-	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	int				error;
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 2c2720ce6923..89bc9bcaf51e 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -34,10 +34,10 @@ xlog_recover_dquot_ra_pass2(
 	if (mp->m_qflags == 0)
 		return;
 
-	recddq = item->ri_buf[1].i_addr;
+	recddq = item->ri_buf[1].iov_base;
 	if (recddq == NULL)
 		return;
-	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
+	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot))
 		return;
 
 	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
@@ -45,7 +45,7 @@ xlog_recover_dquot_ra_pass2(
 	if (log->l_quotaoffs_flag & type)
 		return;
 
-	dq_f = item->ri_buf[0].i_addr;
+	dq_f = item->ri_buf[0].iov_base;
 	ASSERT(dq_f);
 	ASSERT(dq_f->qlf_len == 1);
 
@@ -79,14 +79,14 @@ xlog_recover_dquot_commit_pass2(
 	if (mp->m_qflags == 0)
 		return 0;
 
-	recddq = item->ri_buf[1].i_addr;
+	recddq = item->ri_buf[1].iov_base;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EFSCORRUPTED;
 	}
-	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
-		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
-			item->ri_buf[1].i_len, __func__);
+	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot)) {
+		xfs_alert(log->l_mp, "dquot too small (%zd) in %s.",
+			item->ri_buf[1].iov_len, __func__);
 		return -EFSCORRUPTED;
 	}
 
@@ -108,7 +108,7 @@ xlog_recover_dquot_commit_pass2(
 	 * The other possibility, of course, is that the quota subsystem was
 	 * removed since the last mount - ENOSYS.
 	 */
-	dq_f = item->ri_buf[0].i_addr;
+	dq_f = item->ri_buf[0].iov_base;
 	ASSERT(dq_f);
 	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
 	if (fa) {
@@ -147,7 +147,7 @@ xlog_recover_dquot_commit_pass2(
 		}
 	}
 
-	memcpy(ddq, recddq, item->ri_buf[1].i_len);
+	memcpy(ddq, recddq, item->ri_buf[1].iov_len);
 	if (xfs_has_crc(mp)) {
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
@@ -192,7 +192,7 @@ xlog_recover_quotaoff_commit_pass1(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
 {
-	struct xfs_qoff_logformat	*qoff_f = item->ri_buf[0].i_addr;
+	struct xfs_qoff_logformat	*qoff_f = item->ri_buf[0].iov_base;
 	ASSERT(qoff_f);
 
 	/*
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 264a121c5e16..229cbe0adf17 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -558,12 +558,12 @@ xlog_recover_xmi_commit_pass2(
 	size_t				len;
 
 	len = sizeof(struct xfs_xmi_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[0].iov_len != len) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
 
-	xmi_formatp = item->ri_buf[0].i_addr;
+	xmi_formatp = item->ri_buf[0].iov_base;
 	if (xmi_formatp->__pad != 0) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
@@ -598,8 +598,8 @@ xlog_recover_xmd_commit_pass2(
 {
 	struct xfs_xmd_log_format	*xmd_formatp;
 
-	xmd_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_xmd_log_format)) {
+	xmd_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d574f5f639fa..47ee598a9827 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -182,15 +182,18 @@ xfs_efi_init(
  * It will handle the conversion of formats if necessary.
  */
 STATIC int
-xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
+xfs_efi_copy_format(
+	struct kvec			*buf,
+	struct xfs_efi_log_format	*dst_efi_fmt)
 {
-	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
-	uint i;
-	uint len = xfs_efi_log_format_sizeof(src_efi_fmt->efi_nextents);
-	uint len32 = xfs_efi_log_format32_sizeof(src_efi_fmt->efi_nextents);
-	uint len64 = xfs_efi_log_format64_sizeof(src_efi_fmt->efi_nextents);
+	struct xfs_efi_log_format	*src_efi_fmt = buf->iov_base;
+	uint				len, len32, len64, i;
 
-	if (buf->i_len == len) {
+	len = xfs_efi_log_format_sizeof(src_efi_fmt->efi_nextents);
+	len32 = xfs_efi_log_format32_sizeof(src_efi_fmt->efi_nextents);
+	len64 = xfs_efi_log_format64_sizeof(src_efi_fmt->efi_nextents);
+
+	if (buf->iov_len == len) {
 		memcpy(dst_efi_fmt, src_efi_fmt,
 		       offsetof(struct xfs_efi_log_format, efi_extents));
 		for (i = 0; i < src_efi_fmt->efi_nextents; i++)
@@ -198,8 +201,8 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 			       &src_efi_fmt->efi_extents[i],
 			       sizeof(struct xfs_extent));
 		return 0;
-	} else if (buf->i_len == len32) {
-		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->i_addr;
+	} else if (buf->iov_len == len32) {
+		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->iov_base;
 
 		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
@@ -212,8 +215,8 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 				src_efi_fmt_32->efi_extents[i].ext_len;
 		}
 		return 0;
-	} else if (buf->i_len == len64) {
-		xfs_efi_log_format_64_t *src_efi_fmt_64 = buf->i_addr;
+	} else if (buf->iov_len == len64) {
+		xfs_efi_log_format_64_t *src_efi_fmt_64 = buf->iov_base;
 
 		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
@@ -227,8 +230,8 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 		}
 		return 0;
 	}
-	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, NULL, buf->i_addr,
-			buf->i_len);
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, NULL, buf->iov_base,
+			buf->iov_len);
 	return -EFSCORRUPTED;
 }
 
@@ -865,11 +868,11 @@ xlog_recover_efi_commit_pass2(
 	struct xfs_efi_log_format	*efi_formatp;
 	int				error;
 
-	efi_formatp = item->ri_buf[0].i_addr;
+	efi_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_efi_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -904,11 +907,11 @@ xlog_recover_rtefi_commit_pass2(
 	struct xfs_efi_log_format	*efi_formatp;
 	int				error;
 
-	efi_formatp = item->ri_buf[0].i_addr;
+	efi_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_efi_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -933,7 +936,7 @@ xlog_recover_rtefi_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-			item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+			item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 	return -EFSCORRUPTED;
 }
 #endif
@@ -958,9 +961,9 @@ xlog_recover_efd_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_efd_log_format	*efd_formatp;
-	int				buflen = item->ri_buf[0].i_len;
+	int				buflen = item->ri_buf[0].iov_len;
 
-	efd_formatp = item->ri_buf[0].i_addr;
+	efd_formatp = item->ri_buf[0].iov_base;
 
 	if (buflen < sizeof(struct xfs_efd_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
@@ -968,9 +971,9 @@ xlog_recover_efd_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	if (item->ri_buf[0].i_len != xfs_efd_log_format32_sizeof(
+	if (item->ri_buf[0].iov_len != xfs_efd_log_format32_sizeof(
 						efd_formatp->efd_nextents) &&
-	    item->ri_buf[0].i_len != xfs_efd_log_format64_sizeof(
+	    item->ri_buf[0].iov_len != xfs_efd_log_format64_sizeof(
 						efd_formatp->efd_nextents)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
 				efd_formatp, buflen);
@@ -995,9 +998,9 @@ xlog_recover_rtefd_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_efd_log_format	*efd_formatp;
-	int				buflen = item->ri_buf[0].i_len;
+	int				buflen = item->ri_buf[0].iov_len;
 
-	efd_formatp = item->ri_buf[0].i_addr;
+	efd_formatp = item->ri_buf[0].iov_base;
 
 	if (buflen < sizeof(struct xfs_efd_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
@@ -1005,9 +1008,9 @@ xlog_recover_rtefd_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	if (item->ri_buf[0].i_len != xfs_efd_log_format32_sizeof(
+	if (item->ri_buf[0].iov_len != xfs_efd_log_format32_sizeof(
 						efd_formatp->efd_nextents) &&
-	    item->ri_buf[0].i_len != xfs_efd_log_format64_sizeof(
+	    item->ri_buf[0].iov_len != xfs_efd_log_format64_sizeof(
 						efd_formatp->efd_nextents)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
 				efd_formatp, buflen);
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 4345db501714..f83ec2bd0583 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -158,7 +158,7 @@ xlog_recover_icreate_commit_pass2(
 	int				nbufs;
 	int				i;
 
-	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].iov_base;
 	if (icl->icl_type != XFS_LI_ICREATE) {
 		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
 		return -EINVAL;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 285e27ff89e2..829675700fcd 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1182,12 +1182,12 @@ xfs_iflush_shutdown_abort(
  */
 int
 xfs_inode_item_format_convert(
-	struct xfs_log_iovec		*buf,
+	struct kvec			*buf,
 	struct xfs_inode_log_format	*in_f)
 {
-	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
+	struct xfs_inode_log_format_32	*in_f32 = buf->iov_base;
 
-	if (buf->i_len != sizeof(*in_f32)) {
+	if (buf->iov_len != sizeof(*in_f32)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 377e06007804..ba92ce11a011 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -46,8 +46,8 @@ extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_abort(struct xfs_inode *);
 extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
-extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
-					 struct xfs_inode_log_format *);
+int xfs_inode_item_format_convert(struct kvec *buf,
+		struct xfs_inode_log_format *in_f);
 
 extern struct kmem_cache	*xfs_ili_cache;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 7205fd14f6b3..9d1999d41be1 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -30,13 +30,13 @@ xlog_recover_inode_ra_pass2(
 	struct xlog                     *log,
 	struct xlog_recover_item        *item)
 {
-	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
-		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
+		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].iov_base;
 
 		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
 				   &xfs_inode_buf_ra_ops);
 	} else {
-		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
+		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].iov_base;
 
 		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
 				   &xfs_inode_buf_ra_ops);
@@ -326,8 +326,8 @@ xlog_recover_inode_commit_pass2(
 	int				need_free = 0;
 	xfs_failaddr_t			fa;
 
-	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
-		in_f = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
+		in_f = item->ri_buf[0].iov_base;
 	} else {
 		in_f = kmalloc(sizeof(struct xfs_inode_log_format),
 				GFP_KERNEL | __GFP_NOFAIL);
@@ -366,7 +366,7 @@ xlog_recover_inode_commit_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	ldip = item->ri_buf[1].i_addr;
+	ldip = item->ri_buf[1].iov_base;
 	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_alert(mp,
 			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %lld",
@@ -472,12 +472,12 @@ xlog_recover_inode_commit_pass2(
 		goto out_release;
 	}
 	isize = xfs_log_dinode_size(mp);
-	if (unlikely(item->ri_buf[1].i_len > isize)) {
+	if (unlikely(item->ri_buf[1].iov_len > isize)) {
 		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
 				     mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-			"Bad inode 0x%llx log dinode size 0x%x",
-			in_f->ilf_ino, item->ri_buf[1].i_len);
+			"Bad inode 0x%llx log dinode size 0x%zx",
+			in_f->ilf_ino, item->ri_buf[1].iov_len);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
@@ -500,8 +500,8 @@ xlog_recover_inode_commit_pass2(
 
 	if (in_f->ilf_size == 2)
 		goto out_owner_change;
-	len = item->ri_buf[2].i_len;
-	src = item->ri_buf[2].i_addr;
+	len = item->ri_buf[2].iov_len;
+	src = item->ri_buf[2].iov_base;
 	ASSERT(in_f->ilf_size <= 4);
 	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
@@ -538,8 +538,8 @@ xlog_recover_inode_commit_pass2(
 		} else {
 			attr_index = 2;
 		}
-		len = item->ri_buf[attr_index].i_len;
-		src = item->ri_buf[attr_index].i_addr;
+		len = item->ri_buf[attr_index].iov_len;
+		src = item->ri_buf[attr_index].iov_base;
 		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
 
 		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2f76531842f8..e6ed9e09c027 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2131,15 +2131,15 @@ xlog_recover_add_to_cont_trans(
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
 
-	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
-	old_len = item->ri_buf[item->ri_cnt-1].i_len;
+	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
+	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
 	ptr = kvrealloc(old_ptr, len + old_len, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
 	memcpy(&ptr[old_len], dp, len);
-	item->ri_buf[item->ri_cnt-1].i_len += len;
-	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
+	item->ri_buf[item->ri_cnt-1].iov_len += len;
+	item->ri_buf[item->ri_cnt-1].iov_base = ptr;
 	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
 	return 0;
 }
@@ -2223,7 +2223,7 @@ xlog_recover_add_to_trans(
 		}
 
 		item->ri_total = in_f->ilf_size;
-		item->ri_buf = kzalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+		item->ri_buf = kcalloc(item->ri_total, sizeof(*item->ri_buf),
 				GFP_KERNEL | __GFP_NOFAIL);
 	}
 
@@ -2237,8 +2237,8 @@ xlog_recover_add_to_trans(
 	}
 
 	/* Description region is ri_buf[0] */
-	item->ri_buf[item->ri_cnt].i_addr = ptr;
-	item->ri_buf[item->ri_cnt].i_len  = len;
+	item->ri_buf[item->ri_cnt].iov_base = ptr;
+	item->ri_buf[item->ri_cnt].iov_len  = len;
 	item->ri_cnt++;
 	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
@@ -2262,7 +2262,7 @@ xlog_recover_free_trans(
 		/* Free the regions in the item. */
 		list_del(&item->ri_list);
 		for (i = 0; i < item->ri_cnt; i++)
-			kvfree(item->ri_buf[i].i_addr);
+			kvfree(item->ri_buf[i].iov_base);
 		/* Free the item itself */
 		kfree(item->ri_buf);
 		kfree(item);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 076501123d89..3728234699a2 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -717,18 +717,18 @@ xlog_recover_cui_commit_pass2(
 	struct xfs_cui_log_format	*cui_formatp;
 	size_t				len;
 
-	cui_formatp = item->ri_buf[0].i_addr;
+	cui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_cui_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_cui_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[0].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -759,18 +759,18 @@ xlog_recover_rtcui_commit_pass2(
 	struct xfs_cui_log_format	*cui_formatp;
 	size_t				len;
 
-	cui_formatp = item->ri_buf[0].i_addr;
+	cui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_cui_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_cui_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[0].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -791,7 +791,7 @@ xlog_recover_rtcui_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-			item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+			item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 	return -EFSCORRUPTED;
 }
 #endif
@@ -817,10 +817,10 @@ xlog_recover_cud_commit_pass2(
 {
 	struct xfs_cud_log_format	*cud_formatp;
 
-	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+	cud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_cud_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -843,10 +843,10 @@ xlog_recover_rtcud_commit_pass2(
 {
 	struct xfs_cud_log_format	*cud_formatp;
 
-	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+	cud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_cud_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c99700318ec2..15f0903f6fd4 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -746,18 +746,18 @@ xlog_recover_rui_commit_pass2(
 	struct xfs_rui_log_format	*rui_formatp;
 	size_t				len;
 
-	rui_formatp = item->ri_buf[0].i_addr;
+	rui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_rui_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[0].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -788,18 +788,18 @@ xlog_recover_rtrui_commit_pass2(
 	struct xfs_rui_log_format	*rui_formatp;
 	size_t				len;
 
-	rui_formatp = item->ri_buf[0].i_addr;
+	rui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].i_len < xfs_rui_log_format_sizeof(0)) {
+	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[0].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -820,7 +820,7 @@ xlog_recover_rtrui_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-			item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+			item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
 	return -EFSCORRUPTED;
 }
 #endif
@@ -846,10 +846,10 @@ xlog_recover_rud_commit_pass2(
 {
 	struct xfs_rud_log_format	*rud_formatp;
 
-	rud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_rud_log_format)) {
+	rud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_rud_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				rud_formatp, item->ri_buf[0].i_len);
+				rud_formatp, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -872,10 +872,10 @@ xlog_recover_rtrud_commit_pass2(
 {
 	struct xfs_rud_log_format	*rud_formatp;
 
-	rud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_rud_log_format)) {
+	rud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_rud_log_format)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				rud_formatp, item->ri_buf[0].i_len);
+				rud_formatp, item->ri_buf[0].iov_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2b366851e9a4..fa1724b4690e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -15,7 +15,6 @@ struct xfs_efd_log_item;
 struct xfs_efi_log_item;
 struct xfs_inode;
 struct xfs_item_ops;
-struct xfs_log_iovec;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_trans_res;
-- 
2.47.2

