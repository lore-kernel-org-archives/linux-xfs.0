Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB64925A2A5
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311595; cv=none; b=qs9mM0D9TVc7w3lHetqLSYLs4vXIqO5n4e3uv4zY2RpUteV7oLM199DAuX7qm4jTN+VVxOcjbScUsGTCkp0Cb5onGgdM24gOqZjYJ4krm6W+Kijz/mxk3MJCmy7kYCfeXLNOg+aaRP0MLpLNSaRiEREN4MRnRcMgbchiS5S9M/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311595; c=relaxed/simple;
	bh=EEmykcLCxudgb22N1m/hdDNit7Y3+J/6OF+GuyMHxU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZi1E5SSeMg5llHxmITTZGSWRN87EW3/ftezDa9wy6GdJm03Pl/mTcxqF6oQPQ2KyD3mgheBalEWOIPYFuTF9LGHEbRwPhgJbe2WXavxOPK5RrORED6VLHIrqydvxnAKF55bHENehKpx5xKuB9NFh7MkLiCcAl1ZBoj2q5OEPPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=El0sq/qZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="El0sq/qZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gik/9RGvJB6AcWs/z9kVF3eV/JorK0PL9n1MsMYRW9E=; b=El0sq/qZI/j69/52KzIBwhfETp
	WRKAFC4GHZwpdY+4PtvXYYeZ9N8vaRqVsoa6CJ3U1ME3753Tg05gd7Deg6Lz/NwGZHN6abiizcbsR
	vQJ32H3Ar6IUEO2GI/t3l5MGJL08GzV5Jv8jRuvaeG8hXT13BaVD4jaQaVmjVodujAtItBsSU2Amf
	NYMdyKZgW65Bh2TWPxh3i8PnEApJIiZG1Qds6s5QGB891k3D7LEhiP/j5IBCig+4yvhywjbegOOSG
	pW+UKJCjLCEFlK1Ldi3NhUFpT1yVbMT6NQNRS4qilXAoJ4WPXsKX0HM+SintyWHgI6S9RTe71r4S1
	jvb7irKw==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs2b-000000002mN-0xk1;
	Fri, 28 Nov 2025 06:33:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 25/25] logprint: cleanup xfs_log_print
Date: Fri, 28 Nov 2025 07:30:02 +0100
Message-ID: <20251128063007.1495036-26-hch@lst.de>
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
 logprint/log_misc.c | 392 ++++++++++++++++++++++----------------------
 1 file changed, 197 insertions(+), 195 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index ea696fb282d3..fbedcabedf1c 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1431,214 +1431,216 @@ xlog_print_extended_headers(
 /*
  * This code is gross and needs to be rewritten.
  */
-void xfs_log_print(struct xlog  *log,
-		   int          fd,
-		   int		print_block_start)
+void xfs_log_print(
+	struct xlog  			*log,
+	int				fd,
+	int				print_block_start)
 {
-    char			hbuf[XLOG_HEADER_SIZE];
-    xlog_rec_header_t		*hdr = (xlog_rec_header_t *)&hbuf[0];
-    xlog_rec_ext_header_t 	*xhdrs = NULL;
-    int				num_ops, len, num_hdrs = 1;
-    xfs_daddr_t			block_end = 0, block_start, blkno, error;
-    xfs_daddr_t			zeroed_blkno = 0, cleared_blkno = 0;
-    int				read_type = FULL_READ;
-    char			*partial_buf;
-    int				zeroed = 0;
-    int				cleared = 0;
-    int				first_hdr_found = 0;
-
-    logBBsize = log->l_logBBsize;
-
-    /*
-     * Normally, block_start and block_end are the same value since we
-     * are printing the entire log.  However, if the start block is given,
-     * we still end at the end of the logical log.
-     */
-    if ((error = xlog_print_find_oldest(log, &block_end))) {
-	fprintf(stderr, _("%s: problem finding oldest LR\n"), progname);
-	return;
-    }
-    if (print_block_start == -1)
-	block_start = block_end;
-    else
-	block_start = print_block_start;
-    xlog_print_lseek(log, fd, block_start, SEEK_SET);
-    blkno = block_start;
-
-    for (;;) {
-	if (read(fd, hbuf, 512) == 0) {
-	    printf(_("%s: physical end of log\n"), progname);
-	    print_xlog_record_line();
-	    break;
-	}
-	if (print_only_data) {
-	    printf(_("BLKNO: %lld\n"), (long long)blkno);
-	    xlog_recover_print_data(hbuf, 512);
-	    blkno++;
-	    goto loop;
-	}
-	num_ops = xlog_print_rec_head(hdr, &len, first_hdr_found);
-	blkno++;
-
-	if (zeroed && num_ops != ZEROED_LOG) {
-	    printf(_("%s: after %d zeroed blocks\n"), progname, zeroed);
-	    /* once we find zeroed blocks - that's all we expect */
-	    print_xlog_bad_zeroed(blkno-1);
-	    /* reset count since we're assuming previous zeroed blocks
-	     * were bad
-	     */
-	    zeroed = 0;
-	}
+	char				hbuf[XLOG_HEADER_SIZE];
+	struct xlog_rec_header		*hdr = (struct xlog_rec_header *)&hbuf[0];
+	struct xlog_rec_ext_header 	*xhdrs = NULL;
+	int				num_ops, len, num_hdrs = 1;
+	xfs_daddr_t			block_end = 0, block_start, blkno, error;
+	xfs_daddr_t			zeroed_blkno = 0, cleared_blkno = 0;
+	int				read_type = FULL_READ;
+	char				*partial_buf;
+	int				zeroed = 0;
+	int				cleared = 0;
+	int				first_hdr_found = 0;
+
+	logBBsize = log->l_logBBsize;
 
-	if (num_ops == ZEROED_LOG ||
-	    num_ops == CLEARED_BLKS ||
-	    num_ops == BAD_HEADER) {
-	    if (num_ops == ZEROED_LOG) {
-		if (zeroed == 0)
-		    zeroed_blkno = blkno-1;
-		zeroed++;
-	    }
-	    else if (num_ops == CLEARED_BLKS) {
-		if (cleared == 0)
-		    cleared_blkno = blkno-1;
-		cleared++;
-	    } else {
-		if (!first_hdr_found)
-			block_start = blkno;
-		else
-			print_xlog_bad_header(blkno-1, hbuf);
-	    }
-
-	    goto loop;
+	/*
+	 * Normally, block_start and block_end are the same value since we are
+	 * printing the entire log.  However, if the start block is given, we
+	 * still end at the end of the logical log.
+	 */
+	error = xlog_print_find_oldest(log, &block_end);
+	if (error) {
+		fprintf(stderr, _("%s: problem finding oldest LR\n"),
+			progname);
+		return;
 	}
 
-	if (be32_to_cpu(hdr->h_version) == 2) {
-	    if (xlog_print_extended_headers(fd, len, &blkno, hdr, &num_hdrs, &xhdrs) != 0)
-		break;
-	}
+	if (print_block_start == -1)
+		block_start = block_end;
+	else
+		block_start = print_block_start;
+	xlog_print_lseek(log, fd, block_start, SEEK_SET);
+	blkno = block_start;
 
-	error =	xlog_print_record(log, fd, num_ops, len, &read_type, &partial_buf,
-				  hdr, xhdrs, first_hdr_found);
-	first_hdr_found++;
-	switch (error) {
-	    case 0: {
-		blkno += BTOBB(len);
-		if (print_block_start != -1 &&
-		    blkno >= block_end)		/* If start specified, we */
-			goto end;		/* end early */
-		break;
-	    }
-	    case -1: {
-		print_xlog_bad_data(blkno-1);
-		if (print_block_start != -1 &&
-		    blkno >= block_end)		/* If start specified, */
-			goto end;		/* we end early */
-		xlog_print_lseek(log, fd, blkno, SEEK_SET);
-		goto loop;
-	    }
-	    case PARTIAL_READ: {
-		print_xlog_record_line();
-		printf(_("%s: physical end of log\n"), progname);
+	for (;;) {
+		if (read(fd, hbuf, 512) == 0) {
+			printf(_("%s: physical end of log\n"), progname);
+			print_xlog_record_line();
+			break;
+		}
+		if (print_only_data) {
+			printf(_("BLKNO: %lld\n"), (long long)blkno);
+			xlog_recover_print_data(hbuf, 512);
+			blkno++;
+			goto loop;
+		}
+		num_ops = xlog_print_rec_head(hdr, &len, first_hdr_found);
+		blkno++;
+
+		if (zeroed && num_ops != ZEROED_LOG) {
+			printf(_("%s: after %d zeroed blocks\n"),
+				progname, zeroed);
+			/* once we find zeroed blocks - that's all we expect */
+			print_xlog_bad_zeroed(blkno - 1);
+			/*
+			 * Reset count since we're assuming previous zeroed
+			 * blocks were bad.
+			 */
+			zeroed = 0;
+		}
+
+		switch (num_ops) {
+		case ZEROED_LOG:
+			if (zeroed == 0)
+				zeroed_blkno = blkno - 1;
+			zeroed++;
+			goto loop;
+		case CLEARED_BLKS:
+			if (cleared == 0)
+				cleared_blkno = blkno - 1;
+			cleared++;
+			goto loop;
+		case BAD_HEADER:
+			if (!first_hdr_found)
+				block_start = blkno;
+			else
+				print_xlog_bad_header(blkno - 1, hbuf);
+			goto loop;
+		default:
+			break;
+		}
+
+		if (be32_to_cpu(hdr->h_version) == 2 &&
+		    xlog_print_extended_headers(fd, len, &blkno, hdr, &num_hdrs,
+				&xhdrs) != 0)
+			break;
+
+		error =	xlog_print_record(log, fd, num_ops, len, &read_type,
+				&partial_buf, hdr, xhdrs, first_hdr_found);
+		first_hdr_found++;
+		switch (error) {
+		case 0:
+			blkno += BTOBB(len);
+			if (print_block_start != -1 &&
+			    blkno >= block_end)		/* If start specified, we */
+				goto end;		/* end early */
+			break;
+		case -1:
+			print_xlog_bad_data(blkno-1);
+			if (print_block_start != -1 &&
+			    blkno >= block_end)		/* If start specified, */
+				goto end;		/* we end early */
+			xlog_print_lseek(log, fd, blkno, SEEK_SET);
+			goto loop;
+		case PARTIAL_READ:
+			print_xlog_record_line();
+			printf(_("%s: physical end of log\n"), progname);
+			print_xlog_record_line();
+			blkno = 0;
+			xlog_print_lseek(log, fd, 0, SEEK_SET);
+			/*
+			 * We may have hit the end of the log when we started at 0.
+			 * In this case, just end.
+			 */
+			if (block_start == 0)
+				goto end;
+			goto partial_log_read;
+		default:
+			xlog_panic(_("illegal value"));
+		}
 		print_xlog_record_line();
-		blkno = 0;
-		xlog_print_lseek(log, fd, 0, SEEK_SET);
-		/*
-		 * We may have hit the end of the log when we started at 0.
-		 * In this case, just end.
-		 */
-		if (block_start == 0)
-			goto end;
-		goto partial_log_read;
-	    }
-	    default: xlog_panic(_("illegal value"));
-	}
-	print_xlog_record_line();
 loop:
-	if (blkno >= logBBsize) {
-	    if (cleared) {
-		printf(_("%s: skipped %d cleared blocks in range: %lld - %lld\n"),
-			progname, cleared,
-			(long long)(cleared_blkno),
-			(long long)(cleared + cleared_blkno - 1));
-		if (cleared == logBBsize)
-		    printf(_("%s: totally cleared log\n"), progname);
-
-		cleared=0;
-	    }
-	    if (zeroed) {
-		printf(_("%s: skipped %d zeroed blocks in range: %lld - %lld\n"),
-			progname, zeroed,
-			(long long)(zeroed_blkno),
-			(long long)(zeroed + zeroed_blkno - 1));
-		if (zeroed == logBBsize)
-		    printf(_("%s: totally zeroed log\n"), progname);
-
-		zeroed=0;
-	    }
-	    printf(_("%s: physical end of log\n"), progname);
-	    print_xlog_record_line();
-	    break;
+		if (blkno >= logBBsize) {
+			if (cleared) {
+				printf(_("%s: skipped %d cleared blocks in range: %lld - %lld\n"),
+					progname, cleared,
+					(long long)(cleared_blkno),
+					(long long)(cleared + cleared_blkno - 1));
+				if (cleared == logBBsize)
+					printf(_("%s: totally cleared log\n"), progname);
+				cleared = 0;
+			}
+			if (zeroed) {
+				printf(_("%s: skipped %d zeroed blocks in range: %lld - %lld\n"),
+					progname, zeroed,
+					(long long)(zeroed_blkno),
+					(long long)(zeroed + zeroed_blkno - 1));
+				if (zeroed == logBBsize)
+					printf(_("%s: totally zeroed log\n"), progname);
+				zeroed = 0;
+			}
+			printf(_("%s: physical end of log\n"), progname);
+			print_xlog_record_line();
+			break;
+		}
 	}
-    }
 
-    /* Do we need to print the first part of physical log? */
-    if (block_start != 0) {
-	blkno = 0;
-	xlog_print_lseek(log, fd, 0, SEEK_SET);
-	for (;;) {
-	    if (read(fd, hbuf, 512) == 0) {
-		xlog_panic(_("xlog_find_head: bad read"));
-	    }
-	    if (print_only_data) {
-		printf(_("BLKNO: %lld\n"), (long long)blkno);
-		xlog_recover_print_data(hbuf, 512);
-		blkno++;
-		goto loop2;
-	    }
-	    num_ops = xlog_print_rec_head(hdr, &len, first_hdr_found);
-	    blkno++;
-
-	    if (num_ops == ZEROED_LOG ||
-		num_ops == CLEARED_BLKS ||
-		num_ops == BAD_HEADER) {
-		/* we only expect zeroed log entries  or cleared log
-		 * entries at the end of the _physical_ log,
-		 * so treat them the same as bad blocks here
-		 */
-		print_xlog_bad_header(blkno-1, hbuf);
-
-		if (blkno >= block_end)
-		    break;
-		continue;
-	    }
-
-	    if (be32_to_cpu(hdr->h_version) == 2) {
-		if (xlog_print_extended_headers(fd, len, &blkno, hdr, &num_hdrs, &xhdrs) != 0)
-		    break;
-	    }
+	/* Do we need to print the first part of physical log? */
+	if (block_start != 0) {
+		blkno = 0;
+		xlog_print_lseek(log, fd, 0, SEEK_SET);
+		for (;;) {
+			if (read(fd, hbuf, 512) == 0)
+				xlog_panic(_("xlog_find_head: bad read"));
+
+			if (print_only_data) {
+				printf(_("BLKNO: %lld\n"), (long long)blkno);
+				xlog_recover_print_data(hbuf, 512);
+				blkno++;
+				goto loop2;
+			}
+			num_ops = xlog_print_rec_head(hdr, &len,
+				first_hdr_found);
+			blkno++;
+
+			if (num_ops == ZEROED_LOG ||
+			    num_ops == CLEARED_BLKS ||
+			    num_ops == BAD_HEADER) {
+				/*
+				 * We only expect zeroed log entries or cleared
+				 * log entries at the end of the _physical_ log,
+				 * so treat them the same as bad blocks here.
+				 */
+				print_xlog_bad_header(blkno-1, hbuf);
+				if (blkno >= block_end)
+					break;
+				continue;
+			}
+
+			if (be32_to_cpu(hdr->h_version) == 2 &&
+			    xlog_print_extended_headers(fd, len, &blkno, hdr,
+					&num_hdrs, &xhdrs) != 0)
+				break;
 
 partial_log_read:
-	    error= xlog_print_record(log, fd, num_ops, len, &read_type,
-				    &partial_buf, (xlog_rec_header_t *)hbuf,
-				    xhdrs, first_hdr_found);
-	    if (read_type != FULL_READ)
-		len -= read_type;
-	    read_type = FULL_READ;
-	    if (!error)
-		blkno += BTOBB(len);
-	    else {
-		print_xlog_bad_data(blkno-1);
-		xlog_print_lseek(log, fd, blkno, SEEK_SET);
-		goto loop2;
-	    }
-	    print_xlog_record_line();
+			error = xlog_print_record(log, fd, num_ops, len,
+					&read_type, &partial_buf,
+					(struct xlog_rec_header *)hbuf,
+					xhdrs, first_hdr_found);
+			if (read_type != FULL_READ)
+				len -= read_type;
+			read_type = FULL_READ;
+			if (error) {
+				print_xlog_bad_data(blkno - 1);
+				xlog_print_lseek(log, fd, blkno, SEEK_SET);
+				goto loop2;
+			}
+			blkno += BTOBB(len);
+			print_xlog_record_line();
 loop2:
-	    if (blkno >= block_end)
-		break;
+			if (blkno >= block_end)
+				break;
+		}
 	}
-    }
 
 end:
-    printf(_("%s: logical end of log\n"), progname);
-    print_xlog_record_line();
+	printf(_("%s: logical end of log\n"), progname);
+	print_xlog_record_line();
 }
-- 
2.47.3

