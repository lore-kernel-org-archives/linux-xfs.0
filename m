Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54057244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311546; cv=none; b=VmR4An/vsKCTDRNkApYCRH/rsXgBwz6zv2s4LiQARg3KKN96ZVI1N11O3oSA6fiUB6NDK/UH5RCAp8omMaqsTtPjp0scVyZQBtB7n3c4AF8taQ8FYTu4QXYjUxEreKsEqFYmy5Fq8eketfUMz7IZlRcduvjmfYZIO9/CE66N+aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311546; c=relaxed/simple;
	bh=QThx+tXPhu5gApmLGfD00c57RzOCKDkIyz3Aaipxp0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+PxKr8nz0ZPQQNkL2um1fdk2NmqFynDEquoQYBoo3lj1xImvHsI1/erXxPEHTZzKTlmRMIQ8WAqRrlonpuIUBKXHWTlWganVJc4v/+jnyUkLV4DoPqxuDVXYTRz15lwW3G8Acg/CZfvm/ZKfat9s3aMcLxpKSFP8xfogwj2uQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dfChPhXy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dfChPhXy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HIbRAKHdxZWb1oSdxjHcY+x/hXIJTbUnYTTTGfcCYQI=; b=dfChPhXyIdyoMRRiKngXWRuUK2
	npnJqRDWOXfsSNhEEyjLrfIgZW2dHN1uF09TzRScautVeK+hSMRK1i6rH2/XtJUtsp3uGqvUZoHTc
	jE0eX1tHxRcpj1Xew77xO5H73PyulC9SXG/5BLOD+QOGEwaTRv5Csez54A4ST9vibJCFVlqT5hGy+
	zsqq3Ju78UJApPH0cASqnMzcZDieby+ZRvuV4Tc8A8ZBsI7FxnKSdevVYaaVRsHmSR2Ja7XyOl107
	n6eKhfzBLygoJpNWxO6g6LPR50+1UqhZaaykNsBWNb54Td4p1ALUzlxSfDvAJ2kY+SshPDGsVZUk0
	LUWd+JPg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1o-000000002he-22bb;
	Fri, 28 Nov 2025 06:32:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 19/25] logprint: cleanup xlog_print_rec_head
Date: Fri, 28 Nov 2025 07:29:56 +0100
Message-ID: <20251128063007.1495036-20-hch@lst.de>
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

Re-indent and drop typedefs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 119 +++++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 3e67187d3fd4..1ac45a926c40 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1171,78 +1171,81 @@ xlog_print_record(
 }
 
 static int
-xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
+xlog_print_rec_head(
+	struct xlog_rec_header	*head,
+	int			*len,
+	int			bad_hdr_warn)
 {
-    int i;
-    char uub[64];
-    int datalen,bbs;
+	int			datalen, bbs;
+	char			uub[64];
+	int			i;
 
-    if (print_no_print)
-	    return be32_to_cpu(head->h_num_logops);
+	if (print_no_print)
+		return be32_to_cpu(head->h_num_logops);
 
-    if (!head->h_magicno)
-	return ZEROED_LOG;
+	if (!head->h_magicno)
+		return ZEROED_LOG;
 
-    if (be32_to_cpu(head->h_magicno) != XLOG_HEADER_MAGIC_NUM) {
-	if (bad_hdr_warn)
-		printf(_("Header 0x%x wanted 0x%x\n"),
-			be32_to_cpu(head->h_magicno),
-			XLOG_HEADER_MAGIC_NUM);
-	return BAD_HEADER;
-    }
+	if (be32_to_cpu(head->h_magicno) != XLOG_HEADER_MAGIC_NUM) {
+		if (bad_hdr_warn) {
+			printf(_("Header 0x%x wanted 0x%x\n"),
+				be32_to_cpu(head->h_magicno),
+				XLOG_HEADER_MAGIC_NUM);
+		}
+		return BAD_HEADER;
+	}
 
-    /* check for cleared blocks written by xlog_clear_stale_blocks() */
-    if (!head->h_len && !head->h_crc && !head->h_prev_block &&
-	!head->h_num_logops && !head->h_size)
-	return CLEARED_BLKS;
-
-    datalen=be32_to_cpu(head->h_len);
-    bbs=BTOBB(datalen);
-
-    printf(_("cycle: %d	version: %d	"),
-	    be32_to_cpu(head->h_cycle),
-	    be32_to_cpu(head->h_version));
-    print_lsn("	lsn", &head->h_lsn);
-    print_lsn("	tail_lsn", &head->h_tail_lsn);
-    printf("\n");
-    printf(_("length of Log Record: %d	prev offset: %d		num ops: %d\n"),
-	   datalen,
-	    be32_to_cpu(head->h_prev_block),
-	    be32_to_cpu(head->h_num_logops));
+	/* check for cleared blocks written by xlog_clear_stale_blocks() */
+	if (!head->h_len && !head->h_crc && !head->h_prev_block &&
+	    !head->h_num_logops && !head->h_size)
+		return CLEARED_BLKS;
 
-    if (print_overwrite) {
-	printf(_("cycle num overwrites: "));
-	for (i=0; i< min(bbs, XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++)
-	    printf("%d - 0x%x  ",
-		    i,
-		    be32_to_cpu(head->h_cycle_data[i]));
+	datalen = be32_to_cpu(head->h_len);
+	bbs = BTOBB(datalen);
+
+	printf(_("cycle: %d	version: %d	"),
+		be32_to_cpu(head->h_cycle),
+		be32_to_cpu(head->h_version));
+	print_lsn("	lsn", &head->h_lsn);
+	print_lsn("	tail_lsn", &head->h_tail_lsn);
 	printf("\n");
-    }
+	printf(_("length of Log Record: %d	prev offset: %d		num ops: %d\n"),
+		datalen,
+		be32_to_cpu(head->h_prev_block),
+		be32_to_cpu(head->h_num_logops));
+
+	if (print_overwrite) {
+		printf(_("cycle num overwrites: "));
+		for (i = 0; i < min(bbs, XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++)
+			printf("%d - 0x%x  ",
+				i, be32_to_cpu(head->h_cycle_data[i]));
+		printf("\n");
+	}
 
-    platform_uuid_unparse(&head->h_fs_uuid, uub);
-    printf(_("uuid: %s   format: "), uub);
-    switch (be32_to_cpu(head->h_fmt)) {
+	platform_uuid_unparse(&head->h_fs_uuid, uub);
+	printf(_("uuid: %s   format: "), uub);
+	switch (be32_to_cpu(head->h_fmt)) {
 	case XLOG_FMT_UNKNOWN:
-	    printf(_("unknown\n"));
-	    break;
+		printf(_("unknown\n"));
+		break;
 	case XLOG_FMT_LINUX_LE:
-	    printf(_("little endian linux\n"));
-	    break;
+		printf(_("little endian linux\n"));
+		break;
 	case XLOG_FMT_LINUX_BE:
-	    printf(_("big endian linux\n"));
-	    break;
+		printf(_("big endian linux\n"));
+		break;
 	case XLOG_FMT_IRIX_BE:
-	    printf(_("big endian irix\n"));
-	    break;
+		printf(_("big endian irix\n"));
+		break;
 	default:
-	    printf("? (%d)\n", be32_to_cpu(head->h_fmt));
-	    break;
-    }
-    printf(_("h_size: %d\n"), be32_to_cpu(head->h_size));
+		printf("? (%d)\n", be32_to_cpu(head->h_fmt));
+		break;
+	}
+	printf(_("h_size: %d\n"), be32_to_cpu(head->h_size));
 
-    *len = be32_to_cpu(head->h_len);
-    return(be32_to_cpu(head->h_num_logops));
-}	/* xlog_print_rec_head */
+	*len = be32_to_cpu(head->h_len);
+	return(be32_to_cpu(head->h_num_logops));
+}
 
 static void
 xlog_print_rec_xhead(xlog_rec_ext_header_t *head, int coverage)
-- 
2.47.3

