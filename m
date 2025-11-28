Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2121D5B0
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311472; cv=none; b=cvW+BlZGikyKMBEumFHLJRVPUYQw/cqZ3/nMokIUb8HsXrrrwFNVY5i0VMW+wJeiH3vvGLOgWZ79Npsy/Rvt0GX/fYSk8un0F7Hu+4M5Qq5hjcvV9LvcDYXiQpzQoTrZZD+gLqcGG1pnM1HeqsRJ7gFpIU5QdhovRL6p12IRpMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311472; c=relaxed/simple;
	bh=qSTUYigc5aQZs+Kro+T4Q/1hPW7y7ELbxV4PxKuKp24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQ+D+pwpKy81mnYtddCjBVP8mHL5ZuHiZauX+nCmAzT8KydJUUDUxZyJMzRLwSJKaRRCqehKc9i/C5XoiftZU1SqJO2Q4/8QovM/Aa4HqVwBLr5n5D/RgjaZjU8nD4BbYqrtK2yKqgHDzXKLIxkNxw+ip0JSh8vxKZrNTRPoWtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TxqJDKap; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TxqJDKap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NklsoHcwvwsbtuO6azzdgFAcTOaWx7n9F/lHw2UuEWQ=; b=TxqJDKapv2K1ELjCZsymmvvwr9
	1mZ0K+fF6YGn1PZQWyYEc1FKKahUSTvvKR6PYk8ZizY3ZA81+OrVDxxXXWH7FbPU8+eb8u3kecP/y
	x/qmVVzWeBkM8XCEkiqUMPK+5/6ewzizSn6pkS+uxEgt8QfCn9X83JXRKtx78/hKMLkil10VnKPpf
	9i+yOLFFgbVE5z8coBIBK1Ci3xLazx8Z9dRGWmnWf+ybGoYnw7VQ0mrDWDEeBFa3OPV8+dVULvnO1
	SeewyBn6n4YsYlYg5O+8alebk/2uVLPzhEJRmaF1KuBeYwOPVOoSVneutsfcsYxgyG668TXlkO+p2
	pW5ddJ0Q==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs0c-000000002cE-136P;
	Fri, 28 Nov 2025 06:31:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/25] logprint: cleanup xlog_print_trans_buffer
Date: Fri, 28 Nov 2025 07:29:45 +0100
Message-ID: <20251128063007.1495036-9-hch@lst.de>
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
 logprint/log_misc.c | 142 +++++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 67 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a47b955c4204..533f57bdfc36 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -422,84 +422,92 @@ xlog_print_buf_data(
 }
 
 static int
-xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
+xlog_print_trans_buffer(
+	char			**ptr,
+	int			len,
+	int			*i,
+	int			num_ops)
 {
-    xfs_buf_log_format_t *f;
-    xlog_op_header_t	 *head = NULL;
-    int			 num, skip;
-    int			 super_block = 0;
-    int64_t			 blkno;
-    xfs_buf_log_format_t lbuf;
-    int			 size, blen, map_size, struct_size;
-    unsigned short	 flags;
+	struct xfs_buf_log_format blf;
+	struct xlog_op_header	*ophdr = NULL;
+	int			num, skip;
+	int			super_block = 0;
+	int64_t			blkno;
+	int			size, blen, map_size, struct_size;
+	unsigned short		flags;
 
-    /*
-     * memmove to ensure 8-byte alignment for the long longs in
-     * buf_log_format_t structure
-     */
-    memmove(&lbuf, *ptr, min(sizeof(xfs_buf_log_format_t), len));
-    f = &lbuf;
-    *ptr += len;
-
-    ASSERT(f->blf_type == XFS_LI_BUF);
-    printf("BUF:  ");
-    blkno = f->blf_blkno;
-    size = f->blf_size;
-    blen = f->blf_len;
-    map_size = f->blf_map_size;
-    flags = f->blf_flags;
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * struct xfs_buf_log_format.
+	 */
+	memmove(&blf, *ptr, min(sizeof(blf), len));
+	*ptr += len;
 
-    /*
-     * size of the format header is dependent on the size of the bitmap, not
-     * the size of the in-memory structure. Hence the slightly obtuse
-     * calculation.
-     */
-    struct_size = offsetof(struct xfs_buf_log_format, blf_map_size) + map_size;
+	ASSERT(blf.blf_type == XFS_LI_BUF);
+	printf("BUF:  ");
+	blkno = blf.blf_blkno;
+	size = blf.blf_size;
+	blen = blf.blf_len;
+	map_size = blf.blf_map_size;
+	flags = blf.blf_flags;
 
-    if (len >= struct_size) {
+	/*
+	 * size of the format header is dependent on the size of the bitmap, not
+	 * the size of the in-memory structure. Hence the slightly obtuse
+	 * calculation.
+	 */
+	struct_size = offsetof(struct xfs_buf_log_format, blf_map_size) +
+			map_size;
+	if (len < struct_size) {
+		ASSERT(len >= 4);	/* must have at least 4 bytes if != 0 */
+		printf(_("#regs: %d   Not printing rest of data\n"), blf.blf_size);
+		return size;
+	}
 	ASSERT((len - sizeof(struct_size)) % sizeof(int) == 0);
 	printf(_("#regs: %d   start blkno: %lld (0x%llx)  len: %d  bmap size: %d  flags: 0x%x\n"),
-	       size, (long long)blkno, (unsigned long long)blkno, blen, map_size, flags);
+		size,
+		(long long)blkno,
+		(unsigned long long)blkno,
+		blen,
+		map_size,
+		flags);
+
 	if (blkno == 0)
-	    super_block = 1;
-    } else {
-	ASSERT(len >= 4);	/* must have at least 4 bytes if != 0 */
-	printf(_("#regs: %d   Not printing rest of data\n"), f->blf_size);
-	return size;
-    }
-    num = size-1;
+		super_block = 1;
 
-    /* Check if all regions in this log item were in the given LR ptr */
-    if (*i+num > num_ops-1) {
-	skip = num - (num_ops-1-*i);
-	num = num_ops-1-*i;
-    } else {
-	skip = 0;
-    }
-    while (num-- > 0) {
-	(*i)++;
-	head = (xlog_op_header_t *)*ptr;
-	xlog_print_op_header(head, *i, ptr);
-	if (super_block) {
-		xlog_print_sb_buf(head, *ptr);
-		super_block = 0;
-	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
-		if (!xlog_print_agi_buf(head, *ptr))
-			continue;
-	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
-		xlog_print_agf_buf(head, *ptr);
-	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_DQUOT_MAGIC) {
-		xlog_print_dquot_buf(head, *ptr);
+	/* Check if all regions in this log item were in the given LR ptr */
+	num = size-1;
+	if (*i + num > num_ops - 1) {
+		skip = num - (num_ops - 1 - *i);
+		num = num_ops - 1 - *i;
 	} else {
-		xlog_print_buf_data(head, *ptr);
+		skip = 0;
 	}
-	*ptr += be32_to_cpu(head->oh_len);
-    }
-    if (head && head->oh_flags & XLOG_CONTINUE_TRANS)
-	skip++;
-    return skip;
-}	/* xlog_print_trans_buffer */
 
+	while (num-- > 0) {
+		(*i)++;
+		ophdr = (struct xlog_op_header *)*ptr;
+		xlog_print_op_header(ophdr, *i, ptr);
+		if (super_block) {
+			xlog_print_sb_buf(ophdr, *ptr);
+			super_block = 0;
+		} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
+			if (!xlog_print_agi_buf(ophdr, *ptr))
+				continue;
+		} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
+			xlog_print_agf_buf(ophdr, *ptr);
+		} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_DQUOT_MAGIC) {
+			xlog_print_dquot_buf(ophdr, *ptr);
+		} else {
+			xlog_print_buf_data(ophdr, *ptr);
+		}
+		*ptr += be32_to_cpu(ophdr->oh_len);
+	}
+
+	if (ophdr && ophdr->oh_flags & XLOG_CONTINUE_TRANS)
+		skip++;
+	return skip;
+}
 
 static int
 xlog_print_trans_qoff(char **ptr, uint len)
-- 
2.47.3

