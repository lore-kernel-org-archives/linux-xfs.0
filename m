Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9DC25A2A5
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311579; cv=none; b=KjFb/UVd/8shHyuDq/Dqqx3bSKW+1KoSpzdbkpF32BMn6GdFFsF9wL98uumTGDuwluKI5tUoXx47FgY8MA5Nhgd9bDaKF62gHny6+nP5PZAwnUgzVcuBUs7Rb/B5BmBYlpDOnJMdWluh+lKQjRRSkWHpC70sfduc+uKojzfLuW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311579; c=relaxed/simple;
	bh=c99eU8ZZHQNkmMy+oiGhb530Lj6yUBxZbxZyvSNxXPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtKpRgYyyoDKnsWavOPnFkwVTqLOZPfdaGX2V36Ri8hsCK6A9bCaAwPir4JMKsq2XCnWZsrR77DH/jXqzFER2KxRSEN4kSSDsQXS5xwMQSem/0p3RaxEE/nJksUfk2NLvqgSfkoeyGc6qq3rFhUqEBvwtEj2bRAs6BH5Vca7QtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wr+029uv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wr+029uv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3gNqgsh6ybaDiMTCS1eBkq+jbtD7TVi5y5r0REUpfw8=; b=wr+029uvfSF/hTaHgReAA/l+Ai
	oPmFqzjbCi7vteAPEondzTA0sZ3yQAFN0YvF1N9JUI9lYZq5PuB//9MRSpvxfb/EgJkWg6kRPu/Sg
	229x1lJwtYGNj/hnIAR3MAJij6n81ODKlOBiQdxYXKWRfmIPu8vynr970PsmnYAwcSCCCA+a4/DdK
	vlAeaPsCyFW6Z0GFk/RTaNP8KgWkHLqvYyywHXXG7AOl8bFyS1bxZ9TYh8lcoMy0rgzQlFSWIlt37
	TsLSCjYMDyZX5isNFpc2C0sZeA1RoCVVWm9tlAcgWops6AcRCm3L2g5T6FREQb/9PcNDWlLBqNloY
	bbBqfBhA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs2L-000000002ka-0Cqh;
	Fri, 28 Nov 2025 06:32:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 23/25] logprint: factor out a xlog_print_ext_header helper
Date: Fri, 28 Nov 2025 07:30:00 +0100
Message-ID: <20251128063007.1495036-24-hch@lst.de>
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

Split the inner extheader printing loop into a separate helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 89 ++++++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 37 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index b67a2e9d91a4..94efd3839f8b 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1336,6 +1336,55 @@ xlog_reallocate_xhdrs(
 	}
 }
 
+static int
+xlog_print_ext_header(
+	int				fd,
+	int				len,
+	xfs_daddr_t			blkno,
+	struct xlog_rec_ext_header	*xhdr,
+	bool				last)
+{
+	char				xhbuf[XLOG_HEADER_SIZE];
+	struct xlog_rec_ext_header	*rbuf =
+		(struct xlog_rec_ext_header *)xhbuf;
+	int				j;
+
+	/* read one extra header blk */
+	if (read(fd, xhbuf, 512) == 0) {
+		printf(_("%s: physical end of log\n"), progname);
+		print_xlog_record_line();
+		/* reached the end */
+		return 1;
+	}
+
+	if (print_only_data) {
+		printf(_("BLKNO: %lld\n"), (long long)blkno);
+		xlog_recover_print_data(xhbuf, 512);
+	} else {
+		int		coverage_bb;
+
+		if (last) {
+			coverage_bb =
+				BTOBB(len) % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+		} else {
+			coverage_bb = XLOG_HEADER_CYCLE_SIZE / BBSIZE;
+		}
+		xlog_print_rec_xhead(rbuf, coverage_bb);
+	}
+
+	/*
+	 * Copy from buffer into xhdrs array for later.
+	 *
+	 * We could endian convert here but then code later on will look
+	 * asymmetric with the single header case which does endian coversion on
+	 * access.
+	 */
+	xhdr->xh_cycle = rbuf->xh_cycle;
+	for (j = 0; j < XLOG_HEADER_CYCLE_SIZE / BBSIZE; j++)
+		xhdr->xh_cycle_data[j] = rbuf->xh_cycle_data[j];
+	return 0;
+}
+
 /* for V2 logs read each extra hdr and print it out */
 static int
 xlog_print_extended_headers(
@@ -1346,11 +1395,9 @@ xlog_print_extended_headers(
 	int 			*ret_num_hdrs,
 	xlog_rec_ext_header_t	**ret_xhdrs)
 {
-	int			i, j;
-	int			coverage_bb;
+	int			i;
 	int 			num_hdrs;
 	int 			num_required;
-	char			xhbuf[XLOG_HEADER_SIZE];
 	xlog_rec_ext_header_t	*xhdr;
 
 	num_required = howmany(len, XLOG_HEADER_CYCLE_SIZE);
@@ -1377,40 +1424,8 @@ xlog_print_extended_headers(
 
 	/* don't include 1st header */
 	for (i = 1, xhdr = *ret_xhdrs; i < num_hdrs; i++, (*blkno)++, xhdr++) {
-	    /* read one extra header blk */
-	    if (read(fd, xhbuf, 512) == 0) {
-		printf(_("%s: physical end of log\n"), progname);
-		print_xlog_record_line();
-		/* reached the end so return 1 */
-		return 1;
-	    }
-	    if (print_only_data) {
-		printf(_("BLKNO: %lld\n"), (long long)*blkno);
-		xlog_recover_print_data(xhbuf, 512);
-	    }
-	    else {
-		if (i == num_hdrs - 1) {
-		    /* last header */
-		    coverage_bb = BTOBB(len) %
-				    (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-		}
-		else {
-		    /* earliear header */
-		    coverage_bb = XLOG_HEADER_CYCLE_SIZE / BBSIZE;
-		}
-		xlog_print_rec_xhead((xlog_rec_ext_header_t*)xhbuf, coverage_bb);
-	    }
-
-	    /* Copy from buffer into xhdrs array for later.
-	     * Could endian convert here but then code later on
-	     * will look asymmetric with the 1 hdr normal case
-	     * which does endian coversion on access.
-	     */
-	    xhdr->xh_cycle = ((xlog_rec_ext_header_t*)xhbuf)->xh_cycle;
-	    for (j = 0; j < XLOG_HEADER_CYCLE_SIZE / BBSIZE; j++) {
-		xhdr->xh_cycle_data[j] =
-		    ((xlog_rec_ext_header_t*)xhbuf)->xh_cycle_data[j];
-	    }
+	    if (xlog_print_ext_header(fd, len, *blkno, xhdr, i == num_hdrs - 1))
+	        return 1;
 	}
 	return 0;
 }
-- 
2.47.3

