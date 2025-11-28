Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EEA244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311496; cv=none; b=KAj1PrjSXNF8mIT2rwx9WMUhkh2V9XJm2FPYWl0/BZ3f4AO0D46C35/fcQ3RpOVW4Av0XvU6x5JlKrdW5VHEiuDZwQG8PsvdxssMMUaf9fev86jODuq3LtwLaGshqJCOeFjztuqVQqmZ9bobDRUlnf2bHr86MBNaNt/0VKKv0rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311496; c=relaxed/simple;
	bh=rkBm3ZgLrvTQpQMoo10XNkqWeslC2kt75r0GHrg0OFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZ6tDBQtRwkBGzrSxwGapFqSywmyUlesZ6y5xstxAv+1UVHm/IYOiZwacMJeH4lA5cXBAuJpWJZ3GomDjcqAt5PJP/F/KlouxEa/SPADFdUO8ZzEzT5/jDgvtqlmznlc8eO5qtrkoKgvRwbkF2AkevMAp8UzHGxfZbj8RNjDy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c+Px34N/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c+Px34N/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RFZi/LIlCzoB38R8MFs7AAhxN0GQClHTdXl/DEGGQlo=; b=c+Px34N/WyJ57e1FD/7N/Ltv5o
	Kr5r5DEhLLSjS0uu3PXoJ+IXbswxb6v3bt2vShxesEDWw89UjHk3BYbf8IyLwk2ARwwoar7PYxztU
	utlihc2boHjfJqOEUuStHZ60XSVw+c+WziM/dfM8YoxV9uthIawuLao91TKwSGyRy517s9VRzIeyT
	iFfLRgxptJjwHAxSM6dKO5EckCQJTC3LmSIgxDSEji857l1Cz0CmxqfFf5IjoP/GzoMZwDfo4VIw9
	dxv1n+wFPVaEhewopMWS0a3zIIIrzt7vVVYi2EliiHNgDjhohypFStAiagHOFMC9AgGNG5W0NgzpT
	JWcNhOEQ==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs10-000000002dz-318r;
	Fri, 28 Nov 2025 06:31:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/25] logprint: move xfs_inode_item_format_convert up
Date: Fri, 28 Nov 2025 07:29:48 +0100
Message-ID: <20251128063007.1495036-12-hch@lst.de>
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

Toward the caller.  And reindent it while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 80 +++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a3aa4a323193..274d25e94bbd 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -527,6 +527,39 @@ xlog_print_trans_qoff(
 	return 0;
 }
 
+/*
+ * if necessary, convert an xfs_inode_log_format struct from the old 32bit version
+ * (which can have different field alignments) to the native 64 bit version
+ */
+struct xfs_inode_log_format *
+xfs_inode_item_format_convert(
+	char			*src_buf,
+	uint			len,
+	struct xfs_inode_log_format *in_f)
+{
+	struct xfs_inode_log_format_32	*in_f32;
+
+	/* if we have native format then just return buf without copying data */
+	if (len == sizeof(struct xfs_inode_log_format))
+		return (struct xfs_inode_log_format *)src_buf;
+
+	in_f32 = (struct xfs_inode_log_format_32 *)src_buf;
+	in_f->ilf_type = in_f32->ilf_type;
+	in_f->ilf_size = in_f32->ilf_size;
+	in_f->ilf_fields = in_f32->ilf_fields;
+	in_f->ilf_asize = in_f32->ilf_asize;
+	in_f->ilf_dsize = in_f32->ilf_dsize;
+	in_f->ilf_ino = in_f32->ilf_ino;
+	/* copy biggest field of ilf_u */
+	memcpy(&in_f->ilf_u.__pad, &in_f32->ilf_u.__pad,
+					sizeof(in_f->ilf_u.__pad));
+	in_f->ilf_blkno = in_f32->ilf_blkno;
+	in_f->ilf_len = in_f32->ilf_len;
+	in_f->ilf_boffset = in_f32->ilf_boffset;
+
+	return in_f;
+}
+
 static void
 xlog_print_trans_inode_core(
 	struct xfs_log_dinode	*ip)
@@ -588,14 +621,14 @@ xlog_print_trans_inode(
 	int			num_ops,
 	int			continued)
 {
-    struct xfs_log_dinode	dino;
-    struct xlog_op_header	*op_head;
-    struct xfs_inode_log_format	dst_lbuf;
-    struct xfs_inode_log_format	src_lbuf;
-    struct xfs_inode_log_format *f;
-    int				mode;
-    int				size;
-    int				skip_count;
+	struct xfs_log_dinode	dino;
+	struct xlog_op_header	*op_head;
+	struct xfs_inode_log_format dst_lbuf;
+	struct xfs_inode_log_format src_lbuf;
+	struct xfs_inode_log_format *f;
+	int				mode;
+	int				size;
+	int				skip_count;
 
     /*
      * print inode type header region
@@ -1582,34 +1615,3 @@ end:
     printf(_("%s: logical end of log\n"), progname);
     print_xlog_record_line();
 }
-
-/*
- * if necessary, convert an xfs_inode_log_format struct from the old 32bit version
- * (which can have different field alignments) to the native 64 bit version
- */
-struct xfs_inode_log_format *
-xfs_inode_item_format_convert(char *src_buf, uint len, struct xfs_inode_log_format *in_f)
-{
-	struct xfs_inode_log_format_32	*in_f32;
-
-	/* if we have native format then just return buf without copying data */
-	if (len == sizeof(struct xfs_inode_log_format)) {
-		return (struct xfs_inode_log_format *)src_buf;
-	}
-
-	in_f32 = (struct xfs_inode_log_format_32 *)src_buf;
-	in_f->ilf_type = in_f32->ilf_type;
-	in_f->ilf_size = in_f32->ilf_size;
-	in_f->ilf_fields = in_f32->ilf_fields;
-	in_f->ilf_asize = in_f32->ilf_asize;
-	in_f->ilf_dsize = in_f32->ilf_dsize;
-	in_f->ilf_ino = in_f32->ilf_ino;
-	/* copy biggest field of ilf_u */
-	memcpy(&in_f->ilf_u.__pad, &in_f32->ilf_u.__pad,
-					sizeof(in_f->ilf_u.__pad));
-	in_f->ilf_blkno = in_f32->ilf_blkno;
-	in_f->ilf_len = in_f32->ilf_len;
-	in_f->ilf_boffset = in_f32->ilf_boffset;
-
-	return in_f;
-}
-- 
2.47.3

