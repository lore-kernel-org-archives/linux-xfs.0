Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AD222F76F
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311538; cv=none; b=d92aj2IQ8ZnTGiM9gkUko0JVJ/d6smrTqZ7xhJtGyDwy2/rLqzOeAwyHaz0/2ZX0DlGxz6PWwO1ynXqupTKaM4h05MbSBUTtShBK1tKLft1JuHRe569zKBVKdRNiT1tKicsbedELzf9xB38niE0LxliMJpWqM7gZydB+GbYbx0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311538; c=relaxed/simple;
	bh=fgFMaZ1XKCdNwwA9H7x+VSO11e1DJqNSmvpZO65tyTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvwgLP16V1Pdo1Qr+zH8jHPGWV53QNkahL9LI4XDyCevcPkmBzpGt5ndiek0js0eP/49xMFmK4bdrq8cMedletiKAVS9E5fygkNziW4XYUTTkF3B6SR+my4tZ85TpEvw3z2gtpisPoq9gsN2SXQfy+ruLj0OGoAK1j3XjVIp9kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wlvi+oFQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wlvi+oFQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ns4gVfRiwb917DOE0hOaIlFLHgKlAbryS+f2XbnoEd0=; b=Wlvi+oFQJz1m5wHODgXav+LmJB
	wJ3e/PQVxPySdB8yNcLvF4Xo6ncYzxm0900Oy6cUsA9++0D22oII9fj98KCIlWBHxtd0Cgq7yqjmM
	Sfw88caR/0AprD5qddZ6qZtv99FRn/SS4vyCQBVz17s9LIfkyXFPBdxGQrvF6hRYeUyzLHR7Qv8cV
	IJZ97yak+E5TmKGSp6IUGUc7iwPOsz3WzVTL1l1pHVzmippp7G6x+CzaWeEZmx3Drq14qOvnx4901
	Bje+0zuVDsv+GNNQ/Kxy+WZOEp8Py4/5yM7x8Hmx4qXDJfNhOl/znV72HsQLQK2vPSrNOJ7QOYeX5
	HCQDrFkA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1g-000000002h9-1fJ9;
	Fri, 28 Nov 2025 06:32:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 18/25] logprint: cleanup xlog_print_record
Date: Fri, 28 Nov 2025 07:29:55 +0100
Message-ID: <20251128063007.1495036-19-hch@lst.de>
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

Indent to the normal style, use structs instead of typedefs, and move
assignments out of conditionals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 141 +++++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 66 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index efad679e5a81..3e67187d3fd4 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1081,85 +1081,94 @@ xlog_print_record(
 	int			len,
 	int			*read_type,
 	char			**partial_buf,
-	xlog_rec_header_t	*rhead,
-	xlog_rec_ext_header_t	*xhdrs,
+	struct xlog_rec_header	*rhead,
+	struct xlog_rec_ext_header *xhdrs,
 	int			bad_hdr_warn)
 {
-    char		*buf, *ptr;
-    int			read_len;
-    bool		lost_context = false;
-    int			ret, i;
+	bool			lost_context = false;
+	char			*buf, *ptr;
+	int			read_len;
+	int			ret, i;
 
-    if (print_no_print)
-	    return NO_ERROR;
+	if (print_no_print)
+		return NO_ERROR;
 
-    if (!len) {
-	printf("\n");
-	return NO_ERROR;
-    }
+	if (!len) {
+		printf("\n");
+		return NO_ERROR;
+	}
 
-    /* read_len must read up to some block boundary */
-    read_len = (int) BBTOB(BTOBB(len));
+	/* read_len must read up to some block boundary */
+	read_len = (int) BBTOB(BTOBB(len));
 
-    /* read_type => don't malloc() new buffer, use old one */
-    if (*read_type == FULL_READ) {
-	if ((ptr = buf = malloc(read_len)) == NULL) {
-	    fprintf(stderr, _("%s: xlog_print_record: malloc failed\n"), progname);
-	    exit(1);
+	/* read_type => don't malloc() new buffer, use old one */
+	if (*read_type == FULL_READ) {
+		buf = malloc(read_len);
+		if (!buf) {
+			fprintf(stderr,
+	_("%s: xlog_print_record: malloc failed\n"), progname);
+			exit(1);
+		}
+		ptr = buf;
+	} else {
+		read_len -= *read_type;
+		buf = (char *)((intptr_t)(*partial_buf) +
+			(intptr_t)(*read_type));
+		ptr = *partial_buf;
 	}
-    } else {
-	read_len -= *read_type;
-	buf = (char *)((intptr_t)(*partial_buf) + (intptr_t)(*read_type));
-	ptr = *partial_buf;
-    }
-    if ((ret = (int) read(fd, buf, read_len)) == -1) {
-	fprintf(stderr, _("%s: xlog_print_record: read error\n"), progname);
-	exit(1);
-    }
-    /* Did we overflow the end? */
-    if (*read_type == FULL_READ &&
-	BLOCK_LSN(be64_to_cpu(rhead->h_lsn)) + BTOBB(read_len) >=
-		logBBsize) {
-	*read_type = BBTOB(logBBsize - BLOCK_LSN(be64_to_cpu(rhead->h_lsn))-1);
-	*partial_buf = buf;
-	return PARTIAL_READ;
-    }
 
-    /* Did we read everything? */
-    if ((ret == 0 && read_len != 0) || ret != read_len) {
-	*read_type = ret;
-	*partial_buf = buf;
-	return PARTIAL_READ;
-    }
-    if (*read_type != FULL_READ)
-	read_len += *read_type;
+	ret = (int) read(fd, buf, read_len);
+	if (ret == -1) {
+		fprintf(stderr,
+	_("%s: xlog_print_record: read error\n"), progname);
+		exit(1);
+	}
 
-    /* Everything read in.  Start from beginning of buffer
-     * Unpack the data, by putting the saved cycle-data back
-     * into the first word of each BB.
-     * Do some checks.
-     */
-    buf = ptr;
-    for (i = 0; ptr < buf + read_len; ptr += BBSIZE, i++) {
-	if (!xlog_unpack_rec_header(rhead, xhdrs, ptr, read_type, i)) {
-	    free(buf);
-	    return -1;
+	/* Did we overflow the end? */
+	if (*read_type == FULL_READ &&
+	    BLOCK_LSN(be64_to_cpu(rhead->h_lsn)) + BTOBB(read_len) >=
+			logBBsize) {
+		*read_type = BBTOB(logBBsize -
+			BLOCK_LSN(be64_to_cpu(rhead->h_lsn))-1);
+		*partial_buf = buf;
+		return PARTIAL_READ;
 	}
-    }
 
-    ptr = buf;
-    for (i = 0; i < num_ops; i++) {
-	if (!xlog_print_op(log, &ptr, &i, num_ops, bad_hdr_warn,
-			&lost_context)) {
-		free(buf);
-		return BAD_HEADER;
+	/* Did we read everything? */
+	if ((ret == 0 && read_len != 0) || ret != read_len) {
+		*read_type = ret;
+		*partial_buf = buf;
+		return PARTIAL_READ;
 	}
-    }
-    printf("\n");
-    free(buf);
-    return NO_ERROR;
-}	/* xlog_print_record */
+	if (*read_type != FULL_READ)
+		read_len += *read_type;
 
+	/*
+	 * Everything read in.  Start from beginning of buffer
+	 * Unpack the data, by putting the saved cycle-data back into the first
+	 * word of each BB.
+	 * Do some checks.
+	 */
+	buf = ptr;
+	for (i = 0; ptr < buf + read_len; ptr += BBSIZE, i++) {
+		if (!xlog_unpack_rec_header(rhead, xhdrs, ptr, read_type, i)) {
+			free(buf);
+			return -1;
+		}
+	}
+
+	ptr = buf;
+	for (i = 0; i < num_ops; i++) {
+		if (!xlog_print_op(log, &ptr, &i, num_ops, bad_hdr_warn,
+				&lost_context)) {
+			free(buf);
+			return BAD_HEADER;
+		}
+	}
+	printf("\n");
+	free(buf);
+	return NO_ERROR;
+}
 
 static int
 xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
-- 
2.47.3

