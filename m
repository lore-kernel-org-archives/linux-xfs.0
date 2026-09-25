Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A59738F951
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349372; cv=none; b=DhwnB2MpOaZ86DmIqNhEDubmhI61Tx7gKCaYvWHB9j7ODNKbyZovVZy1uu2KiYZy9aMJ+bkrqV8qviIQS7MM2mrhND+m4KPz6pHCjk7B9rc4EHrX+Dp2XZQTFTrp7sTW5q09CTeAqsyfluobriBVJlUyCp8AU9WabKYeQTQp2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349372; c=relaxed/simple;
	bh=xMWkci7lyU2KsbsQiPqSNH42fnAm3CfTaacAbl1fZXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpPWbJx5eYBPv2iEX6dAaVQ/i3V70SQh6TP0udc1z8s2eslwNQd1Vbw5cOiUx6eZZbkTKLYzJvrro7RIU/TWorMCRpFaOMXHcOeUQ4gdXIn44GuWdwLtlIEf3EVlM7N4Gz8XQkV3EGtJiyhF8y13SryxoGEDQkRNgJLTIRPjgeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BjQVU1ug; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BjQVU1ug"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MObHsdE9sDauy4KIds+1vjCeIM3RM1kX/3FFEdLZiek=; b=BjQVU1ugTOrdUM5IohQiWhXaDU
	xqQw9uvsF3hUjvH8UKbHlJj8jMFe7nUdJh+n1kb5TnJyS1sw5mPG+azy/hOWGLqf/k74JWlpcVDCd
	CkZdb7J6X89L2z/KCEcxhxQ+5/RaLji+wET+ZfAuLmssEOn+S414/D9JpxhtrwTfexkF/j0JbtOHV
	FKV3S5Wmj3MR5fzqr0WoMhF8nmWBxbmKBoV+9Ei+0oTrSpmhek/X+2/Y+Fzb8MNyivsKYjHn/ah9/
	TqfZddq6I7bNbFaBfN0iXlHkA+zzf5zDcvkvsIsdZdi+7sffE8/DyRBaeUq9qy4jm3h+37WYdkUTQ
	siobLQZw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7eT-0000000DjgS-2s68;
	Fri, 25 Sep 2026 15:15:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: optimize cache flushing for CIL commits on multi-device file systems
Date: Fri, 25 Sep 2026 17:15:37 +0200
Message-ID: <20260925151543.3382123-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151543.3382123-1-hch@lst.de>
References: <20260925151543.3382123-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While the flush before writing a start record needs to cover data on the
data and possibly RT devices, the flush before writing the commit record
iclog only needs to ensure previous iclogs are stable on disk.

Split out a new XLOG_ICL_NEED_FLUSH_LOG flag out of XLOG_ICL_NEED_FLUSH
to signal that only the log device needs to be flushed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      |  6 ++++--
 fs/xfs/xfs_log_cil.c  |  9 ++++++---
 fs/xfs/xfs_log_priv.h | 10 ++++++----
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f4f81d893e8c..893ea899a0a8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1619,12 +1619,14 @@ xlog_write_iclog(
 	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
 		if (xlog_flush_data_caches(log))
 			goto shutdown;
-		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 	}
+	if (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))
+		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
-	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
+	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG |
+			     XLOG_ICL_NEED_FUA);
 
 	if (is_vmalloc_addr(iclog->ic_header)) {
 		if (!bio_add_vmalloc(&iclog->ic_bio, iclog->ic_header, count))
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9446ac44ba88..b54a421cab63 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1562,10 +1562,13 @@ xlog_cil_push_work(
 		}
 
 		/*
-		 * We need to issue a pre-flush so that the ordering for this
-		 * checkpoint is correctly preserved down to stable storage.
+		 * We need to issue a pre-flush on the device containing the log
+		 * so that the ordering for this checkpoint is correctly
+		 * preserved down to stable storage.
+		 * There is no need for an extra flush on devices that only
+		 * contain data or non-log metadata.
 		 */
-		ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
+		ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH_LOG;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 6d9673c41cdf..529720a4984b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -71,12 +71,14 @@ enum xlog_iclog_state {
 /*
  * In core log flags
  */
-#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* iclog needs REQ_PREFLUSH */
-#define XLOG_ICL_NEED_FUA	(1u << 1)	/* iclog needs REQ_FUA */
+#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* all devs need REQ_PREFLUSH */
+#define XLOG_ICL_NEED_FLUSH_LOG	(1u << 1)	/* logdev needs REQ_PREFLUSH */
+#define XLOG_ICL_NEED_FUA	(1u << 2)	/* iclog needs REQ_FUA */
 
 #define XLOG_ICL_STRINGS \
-	{ XLOG_ICL_NEED_FLUSH,	"XLOG_ICL_NEED_FLUSH" }, \
-	{ XLOG_ICL_NEED_FUA,	"XLOG_ICL_NEED_FUA" }
+	{ XLOG_ICL_NEED_FLUSH,		"XLOG_ICL_NEED_FLUSH" }, \
+	{ XLOG_ICL_NEED_FLUSH_LOG,	"XLOG_ICL_NEED_FLUSH_LOG" }, \
+	{ XLOG_ICL_NEED_FUA,		"XLOG_ICL_NEED_FUA" }
 
 
 /*
-- 
2.53.0

