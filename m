Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D161D9A5F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532624; cv=none; b=pKDqm3CNFv1YKDL9xemVpRrH3hOSAZ8OEqcCojONbv3UjjA8i1ghI+knWSDyQ6ggTJdQu4m4Z8fFtVN/cROXF7vDgrCI/y1EYz1zbw23fOKZYLfuYDQOJtwAEGA8rwSZvT7/+SNgerqGDoUPtPEvPMasZ8ZR1LjFiHhpl0HsKKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532624; c=relaxed/simple;
	bh=JzUPCEHEaMR5HPQPEZPrY9xFAPaAnZTxIp75EBt1OHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7hm4tZqTTGqvBilojGFtsJzIj2nNuLiaN+SaHwstYaUNra3BYkDWzP1xOVzXCnkZ3EvPmgrjrji+KtjO0LBid8g2F5BR/65erw68hiTQqU+YjwicNv7TomR2QqFnpHxa+6nL1O6NMh0bMCrZPgBAVcPLR2tCrUPuQ6BMw+5rJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LeD92UmA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LeD92UmA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2oW+DWa7H3/hrrIWTzugvUMeZBMhDFKZPm3/jfyMIlU=; b=LeD92UmAZNyBocG1PTA+IvlsPl
	j6XxjMkUO0/BWsLU9tvmJakVpGZozoKhrViFgdsErgzp9cIo3oG0LHdhM95af6+Uz6pZhQzrZUVLK
	r6dV1BIoChhvu5mDE0+X0RPbNanW2/OAz9N6F9MFTb8UB4jnt0eJpSeo5btOScOYaXM9jPknUr1wS
	p2z81wS/7NVf8vtlQEDXpki8Aks45S0GzkMkgvRt8xXALVSb2JRSjid42xQUXCcxgdN5CDJjBryeB
	N97854V0IFdQb2C1aJ75QdE0V0HeJZHMTWo/C3Zuk2IhYAPMU2GTm8gG+xsmsSzBFnRpG0NcsoIxW
	JH/t7rUw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrM6-00000005pIt-36OW;
	Tue, 10 Jun 2025 05:17:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/17] xfs: add a xlog_write_one_vec helper
Date: Tue, 10 Jun 2025 07:15:04 +0200
Message-ID: <20250610051644.2052814-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a wrapper for xlog_write for the two callers who need to build a
log_vec and add it to a single-entry chain instead of duplicating the
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 35 +++++++++++++++++++++--------------
 fs/xfs/xfs_log_cil.c  | 11 +----------
 fs/xfs/xfs_log_priv.h |  2 ++
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5352efabf8f9..fa1bd1fc79ba 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -792,6 +792,26 @@ xlog_wait_on_iclog(
 	return 0;
 }
 
+int
+xlog_write_one_vec(
+	struct xlog		*log,
+	struct xfs_cil_ctx	*ctx,
+	struct xfs_log_iovec	*reg,
+	struct xlog_ticket	*ticket)
+{
+	struct xfs_log_vec	lv = {
+		.lv_niovecs	= 1,
+		.lv_iovecp	= reg,
+	};
+	LIST_HEAD		(lv_chain);
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= reg->i_len;
+
+	list_add(&lv.lv_list, &lv_chain);
+	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
+}
+
 /*
  * Write out an unmount record using the ticket provided. We have to account for
  * the data space used in the unmount ticket as this write is not done from a
@@ -820,21 +840,8 @@ xlog_write_unmount_record(
 		.i_len = sizeof(unmount_rec),
 		.i_type = XLOG_REG_TYPE_UNMOUNT,
 	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
-	LIST_HEAD(lv_chain);
-	list_add(&vec.lv_list, &lv_chain);
-
-	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
-		      sizeof(struct xfs_unmount_log_format)) !=
-							sizeof(unmount_rec));
-
-	/* account for space used by record data */
-	ticket->t_curr_res -= sizeof(unmount_rec);
 
-	return xlog_write(log, NULL, &lv_chain, ticket, reg.i_len);
+	return xlog_write_one_vec(log, NULL, &reg, ticket);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index dd20ca57c1b9..5a0f80cdfa5a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1194,13 +1194,7 @@ xlog_cil_write_commit_record(
 		.i_len = sizeof(struct xlog_op_header),
 		.i_type = XLOG_REG_TYPE_COMMIT,
 	};
-	struct xfs_log_vec	vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
 	int			error;
-	LIST_HEAD(lv_chain);
-	list_add(&vec.lv_list, &lv_chain);
 
 	if (xlog_is_shutdown(log))
 		return -EIO;
@@ -1208,10 +1202,7 @@ xlog_cil_write_commit_record(
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _COMMIT_RECORD);
 	if (error)
 		return error;
-
-	/* account for space used by record data */
-	ctx->ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, reg.i_len);
+	error = xlog_write_one_vec(log, ctx, &reg, ctx->ticket);
 	if (error)
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	return error;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 39a102cc1b43..463daf51da15 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -511,6 +511,8 @@ void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
 		struct list_head *lv_chain, struct xlog_ticket *tic,
 		uint32_t len);
+int	xlog_write_one_vec(struct xlog *log, struct xfs_cil_ctx *ctx,
+		struct xfs_log_iovec *reg, struct xlog_ticket *ticket);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
-- 
2.47.2

