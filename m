Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769BE244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311504; cv=none; b=UnDUc/woaH8g+2NuUMCRmK11n71NgdVZ4WoCWYOm56NMhfms5hUh+lRo+EREDKJF049iqRloIW7l0jQZhLBgXa52cCW+/6W5uLCrZlytW92fWtjEGV4PGosQrwZvsSrB9E8/fv8RnWBNMk04+GHJ9tLnn6gA3r/WsIl075quY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311504; c=relaxed/simple;
	bh=Q1HP0lXbVtyve35O3KlQCpHN1Nf8kRQ9/slgvKKJiug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2CRopKnj8GRCsvSyypIG/Wk+kkmIGDVCMPld5miNT8Bt57fkHuvZ2ns0CT+BMsBumOW2KqaKfQbfcwEB1tuOXRYuVoQCnWg95ftHoI5UUj72s0YUf0gLoSeNrT3VJjAIjB3eARgFFov+OztbzOISUK4R0vjI6JigPMLMa4sT+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4sEpmSH8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4sEpmSH8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ARrDZpMWS83mAm3TSeWoeDLDwZrdBrFZ6WD7DN451c0=; b=4sEpmSH8E52Mm+3ED0YQklzPyK
	gaSxfO306a4oWkvTU10jQ1kxE/EkvPS+X+yKJvJG4BAaRzCTTwTt4WQ6U+FNQREpzesiVpAxI+2mu
	VtTR7ycOGsKf13jSK+VmQpuAHyQN3FrUCq0fihrmXQ5tbJ49/7h1BsoUugZEL4N9ojeUxxTmZ4nFq
	UyLftvOec6peuTJOpLo6yj/x8N5fDXhWKBVHkLkqpqAkzudV+CMtpbpFuJ0J5Kb/r6NG/BOn+K3Nf
	x3sT04DqUi5QxDFMpul0HjjXtkadB3ATf2i0w7mi9dXQ8F1AbQfbDXZRgnV2ai1GWahf87KCo3AN+
	bdjPzHig==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs18-000000002eT-3P8a;
	Fri, 28 Nov 2025 06:31:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/25] logprint: cleanup xlog_print_trans_inode
Date: Fri, 28 Nov 2025 07:29:49 +0100
Message-ID: <20251128063007.1495036-13-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Re-indent, drop typedefs and invert a conditional to allow for an early
return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 241 ++++++++++++++++++++++----------------------
 1 file changed, 121 insertions(+), 120 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 274d25e94bbd..8cdbb7d5fe42 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -626,140 +626,141 @@ xlog_print_trans_inode(
 	struct xfs_inode_log_format dst_lbuf;
 	struct xfs_inode_log_format src_lbuf;
 	struct xfs_inode_log_format *f;
-	int				mode;
-	int				size;
-	int				skip_count;
+	int			mode;
+	int			size;
+	int			skip_count;
+
+	/*
+	 * Print inode type header region.
+	 *
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * struct xfs_inode_log_format structure.
+	 *
+	 * len can be smaller than struct xfs_inode_log_format if format data
+	 * is split over operations.
+	 */
+	memmove(&src_lbuf, *ptr, min(sizeof(src_lbuf), len));
+	(*i)++;					/* bump index */
+	*ptr += len;
+	if (continued ||
+	    (len != sizeof(struct xfs_inode_log_format_32) &&
+	     len != sizeof(struct xfs_inode_log_format))) {
+		ASSERT(len >= 4);	/* must have at least 4 bytes if != 0 */
+		f = (struct xfs_inode_log_format *)&src_lbuf;
+		printf(_("INODE: #regs: %d   Not printing rest of data\n"),
+			f->ilf_size);
+		return f->ilf_size;
+	}
 
-    /*
-     * print inode type header region
-     *
-     * memmove to ensure 8-byte alignment for the long longs in
-     * struct xfs_inode_log_format structure
-     *
-     * len can be smaller than struct xfs_inode_log_format
-     * if format data is split over operations
-     */
-    memmove(&src_lbuf, *ptr, min(sizeof(src_lbuf), len));
-    (*i)++;					/* bump index */
-    *ptr += len;
-    if (!continued &&
-	(len == sizeof(struct xfs_inode_log_format_32) ||
-	 len == sizeof(struct xfs_inode_log_format))) {
 	f = xfs_inode_item_format_convert((char*)&src_lbuf, len, &dst_lbuf);
 	printf(_("INODE: "));
 	printf(_("#regs: %d   ino: 0x%llx  flags: 0x%x   dsize: %d\n"),
-	       f->ilf_size, (unsigned long long)f->ilf_ino,
-	       f->ilf_fields, f->ilf_dsize);
+		f->ilf_size,
+		(unsigned long long)f->ilf_ino,
+		f->ilf_fields,
+		f->ilf_dsize);
 	printf(_("        blkno: %lld  len: %d  boff: %d\n"),
-	       (long long)f->ilf_blkno, f->ilf_len, f->ilf_boffset);
-    } else {
-	ASSERT(len >= 4);	/* must have at least 4 bytes if != 0 */
-	f = (struct xfs_inode_log_format *)&src_lbuf;
-	printf(_("INODE: #regs: %d   Not printing rest of data\n"),
-	       f->ilf_size);
-	return f->ilf_size;
-    }
-
-    skip_count = f->ilf_size-1;
-
-    if (*i >= num_ops)			/* end of LR */
-	    return skip_count;
-
-    /* core inode comes 2nd */
-    op_head = (xlog_op_header_t *)*ptr;
-    xlog_print_op_header(op_head, *i, ptr);
-
-    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)  {
-        return skip_count;
-    }
-
-    memmove(&dino, *ptr, sizeof(dino));
-    mode = dino.di_mode & S_IFMT;
-    size = (int)dino.di_size;
-    xlog_print_trans_inode_core(&dino);
-    *ptr += xfs_log_dinode_size(log->l_mp);
-    skip_count--;
-
-    switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
-    case XFS_ILOG_DEV:
-	printf(_("DEV inode: no extra region\n"));
-	break;
-    case XFS_ILOG_UUID:
-	printf(_("UUID inode: no extra region\n"));
-	break;
-    }
-
-    /* Only the inode core is logged */
-    if (f->ilf_size == 2)
-	return 0;
-
-    ASSERT(f->ilf_size <= 4);
-    ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
+		(long long)f->ilf_blkno,
+		f->ilf_len,
+		f->ilf_boffset);
+
+	skip_count = f->ilf_size - 1;
+	if (*i >= num_ops)			/* end of LR */
+		return skip_count;
+
+	/* core inode comes 2nd */
+	op_head = (struct xlog_op_header *)*ptr;
+	xlog_print_op_header(op_head, *i, ptr);
+
+	if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
+		return skip_count;
+
+	memmove(&dino, *ptr, sizeof(dino));
+	mode = dino.di_mode & S_IFMT;
+	size = (int)dino.di_size;
+	xlog_print_trans_inode_core(&dino);
+	*ptr += xfs_log_dinode_size(log->l_mp);
+	skip_count--;
+
+	switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
+	case XFS_ILOG_DEV:
+		printf(_("DEV inode: no extra region\n"));
+		break;
+	case XFS_ILOG_UUID:
+		printf(_("UUID inode: no extra region\n"));
+		break;
+	}
 
-    /* does anything come next */
-    op_head = (xlog_op_header_t *)*ptr;
+	/* Only the inode core is logged */
+	if (f->ilf_size == 2)
+		return 0;
 
-    if (f->ilf_fields & XFS_ILOG_DFORK) {
-	    if (*i == num_ops-1)
-	        return skip_count;
-	    (*i)++;
-	    xlog_print_op_header(op_head, *i, ptr);
+	ASSERT(f->ilf_size <= 4);
+	ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
 
-	    switch (f->ilf_fields & XFS_ILOG_DFORK) {
-	    case XFS_ILOG_DEXT:
-		printf(_("EXTENTS inode data\n"));
-		break;
-	    case XFS_ILOG_DBROOT:
-		printf(_("BTREE inode data\n"));
-		break;
-	    case XFS_ILOG_DDATA:
-		printf(_("LOCAL inode data\n"));
-		if (mode == S_IFDIR)
-		    printf(_("SHORTFORM DIRECTORY size %d\n"), size);
-		break;
-	    default:
-		ASSERT((f->ilf_fields & XFS_ILOG_DFORK) == 0);
-		break;
-	    }
+	/* does anything come next */
+	op_head = (struct xlog_op_header *)*ptr;
 
-	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-	        return skip_count;
-	    op_head = (xlog_op_header_t *)*ptr;
-	    skip_count--;
-    }
+	if (f->ilf_fields & XFS_ILOG_DFORK) {
+		if (*i == num_ops-1)
+			return skip_count;
+		(*i)++;
+		xlog_print_op_header(op_head, *i, ptr);
 
-    if (f->ilf_fields & XFS_ILOG_AFORK) {
-	    if (*i == num_ops-1)
-	        return skip_count;
-	    (*i)++;
-	    xlog_print_op_header(op_head, *i, ptr);
+		switch (f->ilf_fields & XFS_ILOG_DFORK) {
+		case XFS_ILOG_DEXT:
+			printf(_("EXTENTS inode data\n"));
+			break;
+		case XFS_ILOG_DBROOT:
+			printf(_("BTREE inode data\n"));
+			break;
+		case XFS_ILOG_DDATA:
+			printf(_("LOCAL inode data\n"));
+			if (mode == S_IFDIR)
+				printf(_("SHORTFORM DIRECTORY size %d\n"),
+					size);
+			break;
+		default:
+			ASSERT((f->ilf_fields & XFS_ILOG_DFORK) == 0);
+			break;
+		}
 
-	    switch (f->ilf_fields & XFS_ILOG_AFORK) {
-	    case XFS_ILOG_AEXT:
-		printf(_("EXTENTS attr data\n"));
-		break;
-	    case XFS_ILOG_ABROOT:
-		printf(_("BTREE attr data\n"));
-		break;
-	    case XFS_ILOG_ADATA:
-		printf(_("LOCAL attr data\n"));
-		break;
-	    default:
-		ASSERT((f->ilf_fields & XFS_ILOG_AFORK) == 0);
-		break;
-	    }
-	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-	        return skip_count;
-	    skip_count--;
-    }
+		*ptr += be32_to_cpu(op_head->oh_len);
+		if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
+			return skip_count;
+		op_head = (struct xlog_op_header *)*ptr;
+		skip_count--;
+	}
 
-    ASSERT(skip_count == 0);
+	if (f->ilf_fields & XFS_ILOG_AFORK) {
+		if (*i == num_ops-1)
+			return skip_count;
+		(*i)++;
+		xlog_print_op_header(op_head, *i, ptr);
 
-    return 0;
-}	/* xlog_print_trans_inode */
+		switch (f->ilf_fields & XFS_ILOG_AFORK) {
+		case XFS_ILOG_AEXT:
+			printf(_("EXTENTS attr data\n"));
+			break;
+		case XFS_ILOG_ABROOT:
+			printf(_("BTREE attr data\n"));
+			break;
+		case XFS_ILOG_ADATA:
+			printf(_("LOCAL attr data\n"));
+			break;
+		default:
+			ASSERT((f->ilf_fields & XFS_ILOG_AFORK) == 0);
+			break;
+		}
+		*ptr += be32_to_cpu(op_head->oh_len);
+		if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
+			return skip_count;
+		skip_count--;
+	}
 
+	ASSERT(skip_count == 0);
+	return 0;
+}
 
 static int
 xlog_print_trans_dquot(char **ptr, int len, int *i, int num_ops)
-- 
2.47.3

