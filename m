Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5E244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311530; cv=none; b=L9ITqNYujiuqrzMdGUFwxeNhRjpf842yCurqoGgFlShl9HA19+BzGkPJyVyUv6DHnrp9wVKFP116n9UfDTcDjTeYdA3N3a5tCvGFvLVfhxyaHIdXtr2wIR5e3Iz4fOKgAoAPkOfbff3ANPZOj6vdBsY1/Mmlfy4q5ezBPez+beg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311530; c=relaxed/simple;
	bh=IeyEeYgi6Yo0xCbN3Yz3TIBwBmtlVuINid04snjvuto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsE4e+dyae3k+bV4OHqrFRi/5br+AWUFrdHRLc9XaAzVEXoCcx63aHv/5h9ox7YrePUHIPwilxfXT7H2OmMZ84IO3YYph7QvG7kVjXPXzzZpEHQNHcmXZIE0Sr1Iok5DdchdykeOpfu0VRCQU+4le1qN5DXNbNVGj8Z1nbCLU2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NmsseZtV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NmsseZtV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QgyLzCqW/Z9CvNuMuU7CW5H6NTV9MwqUAUunHKTbRrQ=; b=NmsseZtVve/KUSiF1GVO1VbSLN
	0U90pFky95I86ikgAVXDZ/27kT524g0nbEmr8Bxhk9kFIDqCC9dtP3UyXAslT6Sz/e8r6qqY0WKoc
	i5X9InWkgzSFwhXzJqeerAnLQ/hxBZAU7K0pDTnMdAXHZ3YetRv33gRNtR4/ZREhdfcwfdHNNE72o
	dXME0S19BMFD7VoA/4dT2QmwlWyUmvjH4WToKQd/U1CbNzLBfCvbROBAsWM3nrgJRIaaWXMAPEntm
	bYZdeMYhpxGst3x+OLXxmyuV4yDZDIwxQ4p1SOZc0TE7QudBUb7TGfGo4OMjSzdQ7htdMypP+K53/
	w2hxxqOw==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1Y-000000002gh-1Hom;
	Fri, 28 Nov 2025 06:32:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 17/25] logprint: factor out a xlog_unpack_rec_header
Date: Fri, 28 Nov 2025 07:29:54 +0100
Message-ID: <20251128063007.1495036-18-hch@lst.de>
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

Split the log record validation and unpacking logic into a separate
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 78 +++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 873ec6673768..efad679e5a81 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1032,6 +1032,47 @@ xlog_print_op(
 	return true;
 }
 
+static bool
+xlog_unpack_rec_header(
+	struct xlog_rec_header	*rhead,
+	struct xlog_rec_ext_header *xhdrs,
+	char			*ptr,
+	int			*read_type,
+	int			i)
+{
+	__be32			*cycle = (__be32 *)ptr;
+
+	/*
+	 * Data should not have magicno as first word as it should be cycle
+	 * number.
+	 */
+	if (*cycle == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
+		 return false;
+
+	/* Verify cycle number. */
+	if (be32_to_cpu(rhead->h_cycle) != be32_to_cpu(*cycle) &&
+	    (*read_type == FULL_READ ||
+	     be32_to_cpu(rhead->h_cycle) + 1 != be32_to_cpu(*cycle)))
+		return false;
+
+	/* Copy back the data from the header */
+	if (i < XLOG_HEADER_CYCLE_SIZE / BBSIZE) {
+		/* from 1st header */
+		*cycle = rhead->h_cycle_data[i];
+	} else {
+		int		j, k;
+
+		ASSERT(xhdrs != NULL);
+
+		/* from extra headers */
+		j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+		k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+		*cycle = xhdrs[j - 1].xh_cycle_data[k];
+	}
+
+	return true;
+}
+
 static int
 xlog_print_record(
 	struct xlog		*log,
@@ -1047,7 +1088,7 @@ xlog_print_record(
     char		*buf, *ptr;
     int			read_len;
     bool		lost_context = false;
-    int			ret, i, j, k;
+    int			ret, i;
 
     if (print_no_print)
 	    return NO_ERROR;
@@ -1100,43 +1141,10 @@ xlog_print_record(
      */
     buf = ptr;
     for (i = 0; ptr < buf + read_len; ptr += BBSIZE, i++) {
-	xlog_rec_header_t *rechead = (xlog_rec_header_t *)ptr;
-
-	/* sanity checks */
-	if (be32_to_cpu(rechead->h_magicno) == XLOG_HEADER_MAGIC_NUM) {
-	    /* data should not have magicno as first word
-	     * as it should by cycle#
-	     */
+	if (!xlog_unpack_rec_header(rhead, xhdrs, ptr, read_type, i)) {
 	    free(buf);
 	    return -1;
-	} else {
-	    /* verify cycle#
-	     * FIXME: cycle+1 should be a macro pv#900369
-	     */
-	    if (be32_to_cpu(rhead->h_cycle) !=
-			be32_to_cpu(*(__be32 *)ptr)) {
-		if ((*read_type == FULL_READ) ||
-		    (be32_to_cpu(rhead->h_cycle) + 1 !=
-				be32_to_cpu(*(__be32 *)ptr))) {
-			free(buf);
-			return -1;
-		}
-	    }
 	}
-
-	/* copy back the data from the header */
-	if (i < XLOG_HEADER_CYCLE_SIZE / BBSIZE) {
-		/* from 1st header */
-		*(__be32 *)ptr = rhead->h_cycle_data[i];
-	}
-	else {
-		ASSERT(xhdrs != NULL);
-		/* from extra headers */
-		j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-		k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-		*(__be32 *)ptr = xhdrs[j-1].xh_cycle_data[k];
-	}
-
     }
 
     ptr = buf;
-- 
2.47.3

