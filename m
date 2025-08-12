Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2D2E7633
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 09:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989566; cv=none; b=OBZNJGEButgGCRc8eOjUZvnejj7kqRfhbP8+wM/fTEfHmLhx2RUo3amEqJci3ES/McKJi4gW2yCRIaasNrl6AJXvktc22EMchR4H3zBMHxej9axnBVPlZJReF1lqD6RY0DgYc4T7FJNErIPhX6A/0Axxx0MdvLLtawB4v7i4T1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989566; c=relaxed/simple;
	bh=GCKL+T2kkfQ2xEAVL/0n3/iFltjCQRi2jh5aUg0J5pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X23gnMc8a6AWZeyMdI44tXUfwzg/rXlZh6vjCVfeXcFKAdOGe+0yYAGfNZCGjCnrGCkGlCZfMg0HJYnEDkSuBJ9H1DY64zywSrU388wRjb7KMWGDpFOppOKaXr6pWCaTxd4ptx3p/W1dsSo5RAz+BDuNaQWjqV3LOO96YlwYOMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EVaFZa34; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EVaFZa34"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=V/i1w6x9xxJyZQTPhXKsLbr2lYPJQLrwOAWKvZUPmyg=; b=EVaFZa34HL9iaS4lGByH53+Faq
	zHovqivXcfdtN6bgVxPot5l4zyG2csJSjcKLu48OgnR+lwXyVF9gFBi3arCjNYH3jRiB1TvViIL50
	1ythjluu0pKperEOTvRRj2z4LgBY7x1D1G4heQJNEsfwcifmin9+rVEVWXm/6G0em/6HmsG43t1w1
	QCWMOS8sveg6L3l9VFm4rcotkYGiq4BnvBsuHJuyVZjbxeqHrMAVq/Q8tupEpQzJijIcbB4RLWlMp
	85k132fFUuuUmV+BrYLLNkVyFaUm5TfTdBepdAzrldFftvGi3q4+OY4JsNzyA9DY8NSxPeFyZvwVF
	ZWvAs62w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulkxI-0000000AKMQ-1wmJ;
	Tue, 12 Aug 2025 09:06:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] libxfs: update xfs_log_recover.h to kernel version as of Linux 6.16
Date: Tue, 12 Aug 2025 11:05:38 +0200
Message-ID: <20250812090557.399423-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250812090557.399423-1-hch@lst.de>
References: <20250812090557.399423-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

None of this is used in userland, but it will make automatically
applying kernel changes much easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_recover.h | 131 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 129 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_recover.h b/libxfs/xfs_log_recover.h
index 1745de97e918..66c7916fb5cd 100644
--- a/libxfs/xfs_log_recover.h
+++ b/libxfs/xfs_log_recover.h
@@ -6,6 +6,84 @@
 #ifndef	__XFS_LOG_RECOVER_H__
 #define __XFS_LOG_RECOVER_H__
 
+/*
+ * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
+ * define how recovery should work for that type of log item.
+ */
+struct xlog_recover_item;
+struct xfs_defer_op_type;
+
+/* Sorting hat for log items as they're read in. */
+enum xlog_recover_reorder {
+	XLOG_REORDER_BUFFER_LIST,
+	XLOG_REORDER_ITEM_LIST,
+	XLOG_REORDER_INODE_BUFFER_LIST,
+	XLOG_REORDER_CANCEL_LIST,
+};
+
+struct xlog_recover_item_ops {
+	uint16_t	item_type;	/* XFS_LI_* type code. */
+
+	/*
+	 * Help sort recovered log items into the order required to replay them
+	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
+	 * not have to supply a function here.  See the comment preceding
+	 * xlog_recover_reorder_trans for more details about what the return
+	 * values mean.
+	 */
+	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
+
+	/* Start readahead for pass2, if provided. */
+	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
+
+	/* Do whatever work we need to do for pass1, if provided. */
+	int (*commit_pass1)(struct xlog *log, struct xlog_recover_item *item);
+
+	/*
+	 * This function should do whatever work is needed for pass2 of log
+	 * recovery, if provided.
+	 *
+	 * If the recovered item is an intent item, this function should parse
+	 * the recovered item to construct an in-core log intent item and
+	 * insert it into the AIL.  The in-core log intent item should have 1
+	 * refcount so that the item is freed either (a) when we commit the
+	 * recovered log item for the intent-done item; (b) replay the work and
+	 * log a new intent-done item; or (c) recovery fails and we have to
+	 * abort.
+	 *
+	 * If the recovered item is an intent-done item, this function should
+	 * parse the recovered item to find the id of the corresponding intent
+	 * log item.  Next, it should find the in-core log intent item in the
+	 * AIL and release it.
+	 */
+	int (*commit_pass2)(struct xlog *log, struct list_head *buffer_list,
+			    struct xlog_recover_item *item, xfs_lsn_t lsn);
+};
+
+extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
+extern const struct xlog_recover_item_ops xlog_buf_item_ops;
+extern const struct xlog_recover_item_ops xlog_inode_item_ops;
+extern const struct xlog_recover_item_ops xlog_dquot_item_ops;
+extern const struct xlog_recover_item_ops xlog_quotaoff_item_ops;
+extern const struct xlog_recover_item_ops xlog_bui_item_ops;
+extern const struct xlog_recover_item_ops xlog_bud_item_ops;
+extern const struct xlog_recover_item_ops xlog_efi_item_ops;
+extern const struct xlog_recover_item_ops xlog_efd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rui_item_ops;
+extern const struct xlog_recover_item_ops xlog_rud_item_ops;
+extern const struct xlog_recover_item_ops xlog_cui_item_ops;
+extern const struct xlog_recover_item_ops xlog_cud_item_ops;
+extern const struct xlog_recover_item_ops xlog_attri_item_ops;
+extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
+extern const struct xlog_recover_item_ops xlog_xmi_item_ops;
+extern const struct xlog_recover_item_ops xlog_xmd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtefi_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtefd_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtrui_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtrud_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtcui_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtcud_item_ops;
+
 /*
  * Macros, structures, prototypes for internal log manager use.
  */
@@ -24,10 +102,10 @@
  */
 struct xlog_recover_item {
 	struct list_head	ri_list;
-	int			ri_type;
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
-	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
+	struct xfs_log_iovec	*ri_buf;	/* ptr to regions buffer */
+	const struct xlog_recover_item_ops *ri_ops;
 };
 
 struct xlog_recover {
@@ -41,7 +119,56 @@ struct xlog_recover {
 
 #define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
 
+#define	XLOG_RECOVER_CRCPASS	0
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
 
+void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
+		const struct xfs_buf_ops *ops);
+bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
+
+int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
+		struct xfs_inode **ipp);
+int xlog_recover_iget_handle(struct xfs_mount *mp, xfs_ino_t ino, uint32_t gen,
+		struct xfs_inode **ipp);
+void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
+		uint64_t intent_id);
+int xlog_alloc_buf_cancel_table(struct xlog *log);
+void xlog_free_buf_cancel_table(struct xlog *log);
+
+#ifdef DEBUG
+void xlog_check_buf_cancel_table(struct xlog *log);
+#else
+#define xlog_check_buf_cancel_table(log) do { } while (0)
+#endif
+
+/*
+ * Transform a regular reservation into one suitable for recovery of a log
+ * intent item.
+ *
+ * Intent recovery only runs a single step of the transaction chain and defers
+ * the rest to a separate transaction.  Therefore, we reduce logcount to 1 here
+ * to avoid livelocks if the log grant space is nearly exhausted due to the
+ * recovered intent pinning the tail.  Keep the same logflags to avoid tripping
+ * asserts elsewhere.  Struct copies abound below.
+ */
+static inline struct xfs_trans_res
+xlog_recover_resv(const struct xfs_trans_res *r)
+{
+	struct xfs_trans_res ret = {
+		.tr_logres	= r->tr_logres,
+		.tr_logcount	= 1,
+		.tr_logflags	= r->tr_logflags,
+	};
+
+	return ret;
+}
+
+struct xfs_defer_pending;
+
+void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn, const struct xfs_defer_op_type *ops);
+int xlog_recover_finish_intent(struct xfs_trans *tp,
+		struct xfs_defer_pending *dfp);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
-- 
2.47.2

