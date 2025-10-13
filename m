Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA8A235041
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323358; cv=none; b=DNd4uZGHRSv7X0nqRK+Siz6ezKVtcmfzwRnTfFpfrJPJhfdNub6YdgcFqLCtHjNXU/2YxpMYKcQHNlLa4xxo0e7eaIwDpRORGnCS2XcnUpvFSxRGtfgpUzHho67poir7ulP6s3+jH9L9AMyc4zOw3GQDfCuAlQwZAGFI7QhmC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323358; c=relaxed/simple;
	bh=rslePG0yLJdKlcu562xeP8TNMr1NaVCICfpwDbT5xU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMd+63EQdksu/90+WP1SguS9nc4S7/e0qGYxlXSIrTzuB3to/5rhY3cEXoXK+te20vp1r3KryNpxaFKfnG2cgdQ7/Wd+bkXyP1gduQeNYlqE/nztxBDbY4GRfEmCk80SV4pUBxYxqLOKjEhQb4Pe/KtOyHzFnlEixCStNb0SACw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sg8AMg4V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sg8AMg4V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hKWDJiEFxpthRFVnvoIrT2jFsXHg4u+HnCaGX96Io/Q=; b=sg8AMg4VklR2Q3Je6VVmXszmRy
	QPS3ugIDlhNCWRA4wfUZTNrCWyWs2u1904aIec53f/wri6gcvfbehyMHRwyxpgielFlmqMxmZzN+G
	os7dc1nCJcDlacASAYhwmF31d85qxjKOG4jCIQncL3y/qo8D8qNZ/0k1LTVPJJbIYsWbl2okDVVkd
	kEd9oAGFJbUqitw5DvN7QQ89o5RNGoVKgZce7nQswy6WWrmNwhm8dES7+xHX04o4w5l45vKJ95lof
	cRzB8+I8P20AXHNT2sup2zE+zkDTjv3clh9E8WIkAjde/BCAUankIWVKiGQrORBC31eQtHI8h1iub
	9rn66FuA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88WB-0000000C7F4-1u0A;
	Mon, 13 Oct 2025 02:42:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: add a XLOG_CYCLE_DATA_SIZE constant
Date: Mon, 13 Oct 2025 11:42:05 +0900
Message-ID: <20251013024228.4109032-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024228.4109032-1-hch@lst.de>
References: <20251013024228.4109032-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The XLOG_HEADER_CYCLE_SIZE / BBSIZE expression is used a lot
in the log code, give it a symbolic name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |  5 +++--
 fs/xfs/xfs_log.c               | 18 +++++++++---------
 fs/xfs/xfs_log_recover.c       |  6 +++---
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 6c50cb2ece19..91a841ea5bb3 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -31,6 +31,7 @@ typedef uint32_t xlog_tid_t;
 #define XLOG_BIG_RECORD_BSIZE	(32*1024)	/* 32k buffers */
 #define XLOG_MAX_RECORD_BSIZE	(256*1024)
 #define XLOG_HEADER_CYCLE_SIZE	(32*1024)	/* cycle data in header */
+#define XLOG_CYCLE_DATA_SIZE	(XLOG_HEADER_CYCLE_SIZE / BBSIZE)
 #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
 #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
 #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
@@ -135,7 +136,7 @@ typedef struct xlog_rec_header {
 	__le32	  h_crc;	/* crc of log record                    :  4 */
 	__be32	  h_prev_block; /* block number to previous LR		:  4 */
 	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
-	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
+	__be32	  h_cycle_data[XLOG_CYCLE_DATA_SIZE];
 
 	/* fields added by the Linux port: */
 	__be32    h_fmt;        /* format of log record                 :  4 */
@@ -172,7 +173,7 @@ typedef struct xlog_rec_header {
 
 typedef struct xlog_rec_ext_header {
 	__be32	  xh_cycle;	/* write cycle of log			: 4 */
-	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
+	__be32	  xh_cycle_data[XLOG_CYCLE_DATA_SIZE];		/*	: 256 */
 } xlog_rec_ext_header_t;
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 603e85c1ab4c..e09e5f71ed8c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1533,7 +1533,7 @@ xlog_pack_data(
 
 	dp = iclog->ic_datap;
 	for (i = 0; i < BTOBB(size); i++) {
-		if (i >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE))
+		if (i >= XLOG_CYCLE_DATA_SIZE)
 			break;
 		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
 		*(__be32 *)dp = cycle_lsn;
@@ -1544,8 +1544,8 @@ xlog_pack_data(
 		xlog_in_core_2_t *xhdr = iclog->ic_data;
 
 		for ( ; i < BTOBB(size); i++) {
-			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			j = i / XLOG_CYCLE_DATA_SIZE;
+			k = i % XLOG_CYCLE_DATA_SIZE;
 			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
 			*(__be32 *)dp = cycle_lsn;
 			dp += BBSIZE;
@@ -3368,9 +3368,9 @@ xlog_verify_iclog(
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
-			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
-				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			if (idx >= XLOG_CYCLE_DATA_SIZE) {
+				j = idx / XLOG_CYCLE_DATA_SIZE;
+				k = idx % XLOG_CYCLE_DATA_SIZE;
 				clientid = xlog_get_client_id(
 					xhdr[j].hic_xheader.xh_cycle_data[k]);
 			} else {
@@ -3392,9 +3392,9 @@ xlog_verify_iclog(
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
 			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
-			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
-				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			if (idx >= XLOG_CYCLE_DATA_SIZE) {
+				j = idx / XLOG_CYCLE_DATA_SIZE;
+				k = idx % XLOG_CYCLE_DATA_SIZE;
 				op_len = be32_to_cpu(xhdr[j].hic_xheader.xh_cycle_data[k]);
 			} else {
 				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 549d60959aee..bb2b3f976deb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2866,7 +2866,7 @@ xlog_unpack_data(
 	int			i, j, k;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
-		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
+		  i < XLOG_CYCLE_DATA_SIZE; i++) {
 		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
 		dp += BBSIZE;
 	}
@@ -2874,8 +2874,8 @@ xlog_unpack_data(
 	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
-			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			j = i / XLOG_CYCLE_DATA_SIZE;
+			k = i % XLOG_CYCLE_DATA_SIZE;
 			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
 			dp += BBSIZE;
 		}
-- 
2.47.3

