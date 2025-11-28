Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203F4244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311527; cv=none; b=sSvtPNrWhEfLsU0lrQvxFwziX33ojZ1faxR2GYmg0wLmg5Z4RbHE9eCuU1auhTptkuNczqjaz7f/zq47W6Vf1xjQN77mwHq/uIkQV6qD5pcK9pIkm7oRKxrxdHIVn+b5IX3hEa3K94YTQEm4spg+lvA6XVL+8AEU16xzdMfIQrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311527; c=relaxed/simple;
	bh=uhgSN/UZ5EksYmwhnS7HNTOs6res/PVM+w3J2RKjT9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfmI78QbQnx23wCcIQc1UoP0Yeb8P+0BriuF2ecxJf5D9RmBT2mvj1K5xwjS2nh+dMDozG/xf3BzMeYSkea1hCyabbQV0DsYazKWt0ZIi/D1IuRSdFN6fg2mWOhYXuUhanoIZy+L35hXvKRGEWfj0nVh3+LDE1lG9jpF18l08To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lW3pSB5H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lW3pSB5H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qIE+5aUsMZxhzXdrD3XZuLgZdpz/ktha+kNdcJQaW+o=; b=lW3pSB5HC+B/UUDmI6EEKDd35V
	3/tvixSZ4QhscfM5O6Ef65T3rtRyxZ7upAA5/nkhr08i98RaC/f+r5CvmH4Ar2wbOBQCeflOa6HNl
	h6CVo+XnKzQg+HcRK1xBB3/qOty9rIYS/S8WJzHMcvVDAKnsnx/JzPI365Mc6JTY2ptouXb094s6z
	boS0wAALdnk7FtD7fWCO50Et3diAYhoNTM8ghEjqYIvMoGGz5Myg2Ovuk/G/4oWN0BmADAea0+DP/
	UxfqP8ynkMP7Q0hb+rqqa6Ipl6GKfc5a+K1CR1CrY6ChdQ9hcPCC6qdrgY+L/RKlpm6djG9CKOcPT
	hJg7Ujqg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1V-000000002gO-0zBU;
	Fri, 28 Nov 2025 06:32:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/25] logprint: factor out a xlog_print_op helper
Date: Fri, 28 Nov 2025 07:29:53 +0100
Message-ID: <20251128063007.1495036-17-hch@lst.de>
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

Split the inner printing loop from xlog_print_record into a separate
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 134 ++++++++++++++++++++++++--------------------
 1 file changed, 74 insertions(+), 60 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index f10dc57a1edb..873ec6673768 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -966,6 +966,72 @@ xlog_print_region(
 	}
 }
 
+static bool
+xlog_print_op(
+	struct xlog		*log,
+	char			**ptr,
+	int			*i,
+	int			num_ops,
+	bool			bad_hdr_warn,
+	bool			*lost_context)
+{
+	struct xlog_op_header	*ophdr = (struct xlog_op_header *)*ptr;
+	bool			continued;
+	int			skip, n;
+
+	print_xlog_op_line();
+	xlog_print_op_header(ophdr, *i, ptr);
+
+	continued = (ophdr->oh_flags & XLOG_WAS_CONT_TRANS) ||
+		    (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
+	if (continued && be32_to_cpu(ophdr->oh_len) == 0)
+		return true;
+
+	if (print_no_data) {
+		for (n = 0; n < be32_to_cpu(ophdr->oh_len); n++) {
+			printf("0x%02x ", (unsigned int)**ptr);
+			if (n % 16 == 15)
+				printf("\n");
+			ptr++;
+		}
+		printf("\n");
+		return true;
+	}
+
+	/* print transaction data */
+	if (xlog_print_find_tid(be32_to_cpu(ophdr->oh_tid),
+			ophdr->oh_flags & XLOG_WAS_CONT_TRANS)) {
+		printf(_("Left over region from split log item\n"));
+		/* Skip this leftover bit */
+		(*ptr) += be32_to_cpu(ophdr->oh_len);
+		/* We've lost context; don't complain if next one looks bad too */
+		*lost_context = true;
+		return true;
+	}
+
+	if (!ophdr->oh_len)
+		return true;
+
+	skip = xlog_print_region(log, ptr, ophdr, i, num_ops, continued);
+	if (skip == -1) {
+		if (bad_hdr_warn && !*lost_context) {
+			fprintf(stderr,
+	_("%s: unknown log operation type (%x)\n"),
+				progname, *(unsigned short *)*ptr);
+			if (print_exit)
+				return false;
+		} else {
+			printf(
+	_("Left over region from split log item\n"));
+		}
+		(*ptr) += be32_to_cpu(ophdr->oh_len);
+		*lost_context = false;
+	} else if (skip) {
+		xlog_print_add_to_trans(be32_to_cpu(ophdr->oh_tid), skip);
+	}
+	return true;
+}
+
 static int
 xlog_print_record(
 	struct xlog		*log,
@@ -979,8 +1045,9 @@ xlog_print_record(
 	int			bad_hdr_warn)
 {
     char		*buf, *ptr;
-    int			read_len, skip, lost_context = 0;
-    int			ret, n, i, j, k;
+    int			read_len;
+    bool		lost_context = false;
+    int			ret, i, j, k;
 
     if (print_no_print)
 	    return NO_ERROR;
@@ -1073,64 +1140,11 @@ xlog_print_record(
     }
 
     ptr = buf;
-    for (i=0; i<num_ops; i++) {
-	int continued;
-
-	xlog_op_header_t *op_head = (xlog_op_header_t *)ptr;
-
-	print_xlog_op_line();
-	xlog_print_op_header(op_head, i, &ptr);
-	continued = ((op_head->oh_flags & XLOG_WAS_CONT_TRANS) ||
-		     (op_head->oh_flags & XLOG_CONTINUE_TRANS));
-
-	if (continued && be32_to_cpu(op_head->oh_len) == 0)
-		continue;
-
-	if (print_no_data) {
-	    for (n = 0; n < be32_to_cpu(op_head->oh_len); n++) {
-		printf("0x%02x ", (unsigned int)*ptr);
-		if (n % 16 == 15)
-			printf("\n");
-		ptr++;
-	    }
-	    printf("\n");
-	    continue;
-	}
-
-	/* print transaction data */
-	if (xlog_print_find_tid(be32_to_cpu(op_head->oh_tid),
-				op_head->oh_flags & XLOG_WAS_CONT_TRANS)) {
-	    printf(_("Left over region from split log item\n"));
-	    /* Skip this leftover bit */
-	    ptr += be32_to_cpu(op_head->oh_len);
-	    /* We've lost context; don't complain if next one looks bad too */
-	    lost_context = 1;
-	    continue;
-	}
-
-	if (be32_to_cpu(op_head->oh_len) != 0) {
-		skip = xlog_print_region(log, &ptr, op_head, &i, num_ops,
-				continued);
-		if (skip == -1) {
-			if (bad_hdr_warn && !lost_context) {
-				fprintf(stderr,
-			_("%s: unknown log operation type (%x)\n"),
-					progname, *(unsigned short *)ptr);
-				if (print_exit) {
-					free(buf);
-					return BAD_HEADER;
-				}
-			} else {
-				printf(
-			_("Left over region from split log item\n"));
-			}
-			skip = 0;
-			ptr += be32_to_cpu(op_head->oh_len);
-			lost_context = 0;
-		}
-
-		if (skip)
-			xlog_print_add_to_trans(be32_to_cpu(op_head->oh_tid), skip);
+    for (i = 0; i < num_ops; i++) {
+	if (!xlog_print_op(log, &ptr, &i, num_ops, bad_hdr_warn,
+			&lost_context)) {
+		free(buf);
+		return BAD_HEADER;
 	}
     }
     printf("\n");
-- 
2.47.3

