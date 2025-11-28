Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6B7244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311512; cv=none; b=A6BDu6PdL1iL5jzlOleD6rWvLK2p6JMEa9qsDLw0W8xso+Rt/bFvOFsT9uKGPwoq+np+ss1ZdSC5KQxF/jQk6taSSDynUw+9hC4aWZzyJog/Ey6FKHKwH6MsdNQP5aPb4UY8pH2+NNK+ORP4FJbGoBPF1asz6XOuz2VBTEXfyfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311512; c=relaxed/simple;
	bh=gKNHYYgUshYOj8uTZosTcRn79X1pZZ4FnftyH3TUwi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDCvyombDbuvLMlpZBJ9dTboLQ3Nsr7ozaps8xijyVu0CgUCGhA1MEVPGPSBWBgwDsfEQnZ5Z5Q6NvPRLb9I8tjH33BKtoKttFqnXIHrZb064wPENVqQVkIsjvfyyRxjcXxZhb2DMVaWtjqWRsLxxWzoVXGa6N9ddZFakX7h5BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=28JNilos; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="28JNilos"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m1MPiEmTJonG2dI33pAPNLz4wGeu6mJYxAx3V5C36ws=; b=28JNilosK9p6mg2uRBkjtLKetF
	Lx6DYwlzF6cwTqqNY73GRvkCDMGfXnW39tzeFtN624yq1mMlJYA+NeS2Ig2mjH0oxUgwDwiHTyuP6
	MfdmDDSO/89VceFhSW0/tNWm1ue90U37zYfUyD8/OKUJcfMSHzWDGslh45aB7VFJNKIXdVuVhcW9X
	Dumhu7LvzQfobxIUmAiq4DSlHr38bHxLebG+X7rCF253eL/xatdHS/AbtlGZeLWaFSl9KElfYwJW1
	RAjarP6yH4LxqtOUQ2Cgb3UkTHfPJ3zZuDrlNiTzfxNCBFXPmwTpVoAmB+1/tlCEoBwG1URMxJt/f
	BcIcArAg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1G-000000002ey-3lrC;
	Fri, 28 Nov 2025 06:31:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/25] logprint: cleanup xlog_print_trans_dquot
Date: Fri, 28 Nov 2025 07:29:50 +0100
Message-ID: <20251128063007.1495036-14-hch@lst.de>
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
 logprint/log_misc.c | 103 ++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 47 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8cdbb7d5fe42..73dd7ab46938 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -763,59 +763,68 @@ xlog_print_trans_inode(
 }
 
 static int
-xlog_print_trans_dquot(char **ptr, int len, int *i, int num_ops)
+xlog_print_trans_dquot(
+	char			**ptr,
+	int			len,
+	int			*i,
+	int			num_ops)
 {
-    xfs_dq_logformat_t		*f;
-    xfs_dq_logformat_t		lbuf = {0};
-    struct xfs_disk_dquot	ddq;
-    xlog_op_header_t		*head = NULL;
-    int				num, skip;
+	struct xfs_dq_logformat	*f;
+	struct xfs_dq_logformat lbuf = {0};
+	struct xfs_disk_dquot	ddq;
+	struct xlog_op_header	*head = NULL;
+	int			num, skip;
 
-    /*
-     * print dquot header region
-     *
-     * memmove to ensure 8-byte alignment for the long longs in
-     * xfs_dq_logformat_t structure
-     */
-    memmove(&lbuf, *ptr, min(sizeof(xfs_dq_logformat_t), len));
-    f = &lbuf;
-    (*i)++;					/* bump index */
-    *ptr += len;
+	/*
+	 * Print dquot header region.
+	 *
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * the xfs_dq_logformat structure.
+	 */
+	memmove(&lbuf, *ptr, min(sizeof(struct xfs_dq_logformat), len));
+	f = &lbuf;
+	(*i)++;					/* bump index */
+		*ptr += len;
 
-    if (len == sizeof(xfs_dq_logformat_t)) {
-	printf(_("#regs: %d   id: 0x%x"), f->qlf_size, f->qlf_id);
-	printf(_("  blkno: %lld  len: %d  boff: %d\n"),
-		(long long)f->qlf_blkno, f->qlf_len, f->qlf_boffset);
-    } else {
-	ASSERT(len >= 4);	/* must have at least 4 bytes if != 0 */
-	printf(_("DQUOT: #regs: %d   Not printing rest of data\n"),
-		f->qlf_size);
-	return f->qlf_size;
-    }
-    num = f->qlf_size-1;
+	if (len != sizeof(struct xfs_dq_logformat)) {
+		ASSERT(len >= 4);	/* must have at least 4 bytes if != 0 */
+		printf(_("DQUOT: #regs: %d   Not printing rest of data\n"),
+			f->qlf_size);
+		return f->qlf_size;
+	}
 
-    /* Check if all regions in this log item were in the given LR ptr */
-    if (*i+num > num_ops-1) {
-	skip = num - (num_ops-1-*i);
-	num = num_ops-1-*i;
-    } else {
-	skip = 0;
-    }
+	printf(_("#regs: %d   id: 0x%x"),
+		f->qlf_size,
+		f->qlf_id);
+	printf(_("  blkno: %lld  len: %d  boff: %d\n"),
+		(long long)f->qlf_blkno,
+		f->qlf_len,
+		f->qlf_boffset);
 
-    while (num-- > 0) {
-	head = (xlog_op_header_t *)*ptr;
-	xlog_print_op_header(head, *i, ptr);
-	ASSERT(be32_to_cpu(head->oh_len) == sizeof(struct xfs_disk_dquot));
-	memmove(&ddq, *ptr, sizeof(struct xfs_disk_dquot));
-	printf(_("DQUOT: magic 0x%hx flags 0%ho\n"),
-	       be16_to_cpu(ddq.d_magic), ddq.d_type);
-	*ptr += be32_to_cpu(head->oh_len);
-    }
-    if (head && head->oh_flags & XLOG_CONTINUE_TRANS)
-	skip++;
-    return skip;
-}	/* xlog_print_trans_dquot */
+	/* Check if all regions in this log item were in the given LR ptr */
+	num = f->qlf_size - 1;
+	if (*i + num > num_ops - 1) {
+		skip = num - (num_ops - 1 - *i);
+		num = num_ops - 1 - *i;
+	} else {
+		skip = 0;
+	}
 
+	while (num-- > 0) {
+		head = (struct xlog_op_header *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		ASSERT(be32_to_cpu(head->oh_len) ==
+			sizeof(struct xfs_disk_dquot));
+		memmove(&ddq, *ptr, sizeof(struct xfs_disk_dquot));
+		printf(_("DQUOT: magic 0x%hx flags 0%ho\n"),
+			be16_to_cpu(ddq.d_magic),
+			ddq.d_type);
+		*ptr += be32_to_cpu(head->oh_len);
+	}
+	if (head && (head->oh_flags & XLOG_CONTINUE_TRANS))
+		skip++;
+	return skip;
+}
 
 STATIC int
 xlog_print_trans_icreate(
-- 
2.47.3

