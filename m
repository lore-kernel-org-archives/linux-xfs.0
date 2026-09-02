Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20243859FC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328204; cv=none; b=kZQvaJcHXPMQsFtZvW21cUK30f6wD0VFb7wylm8DZPdUYXxN+F5ZeBIK+vteRwkx15EKXIc1h3RyI1NBNzpkKIuB8+JdVoQ7xc7fPdpmFaHE5QUToTxRaZBKG68EWPxF74eU8g7lPJeYd8PjmKiz8CGQUyzJjRnR4S9lqVNkvHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328204; c=relaxed/simple;
	bh=3oyeF5XPgK2xuMF5jjkPiltJDrZUEhkR4QJsbysr/Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPk+kzVerXL2EFeJKBErqdTehdfHmpaRoQ88BQV9+rJGhA1yKD3DyEpz4etAsNSQeN+k+b91tZLSSbLkRa5P5yQwhFmehq8yfZOVfzxahlztuZ9lti8UdzwI6gxVjdcgPMta4q2NxmOGeFIEItdvIQwXsTJEiqWsjeLM3zIM3pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C5BQhnDe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C5BQhnDe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Zf0tJey6zhJ3vJN+PW4Ye/k41LK+iMm/hpbPkejnjk=; b=C5BQhnDenj/hMFLdLkypwJ8n14
	9Omxn8e8ynW6AHKV/nXSWW9/v2PNkKDsjvMVDYifYE5VS3+Ae39AhWOF+4IM8wMuHlPjuaHo34Wzp
	0HETwsjA1h/u9jRGpfmT/jVuhCt8VEljQPZvR9qULXCwUeEfCHqOoJetz1ozhBVaBfZRyBVpb3lPx
	zu1y02A4G97mdJiQtOmT7WqY+7lQWA5G4mpFtqnqB2Zt1aMJ/7OYzIi8ENyvq82+5a6wsi68z6jb/
	NSmTVomp1E/6rzuyv1VYi4drUPQzxL44kYQYS6GS/eOPZS/dOQG0X2RA/I45p02BmVwpITkkRBVGJ
	RGeStdDQ==;
Received: from 87-119-185-211.ip.elisa.ee ([87.119.185.211] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1drF-0000000Dp5v-3AbR;
	Wed, 02 Sep 2026 05:50:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: optimize cache flushing for CIL commits on multi-device file systems
Date: Wed,  2 Sep 2026 08:49:19 +0300
Message-ID: <20260902054942.111988-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902054942.111988-1-hch@lst.de>
References: <20260902054942.111988-1-hch@lst.de>
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
---
 fs/xfs/xfs_log.c      |  6 ++++--
 fs/xfs/xfs_log_cil.c  |  9 ++++++---
 fs/xfs/xfs_log_priv.h | 10 ++++++----
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8079f2e003db..a5870877baed 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1613,12 +1613,14 @@ xlog_write_iclog(
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
index 3d159b1350df..e05b77fbfc3d 100644
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
index cf1e4ce61a8c..7c72c3b3ffe1 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -71,12 +71,14 @@ enum xlog_iclog_state {
 /*
  * In core log flags
  */
-#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* iclog needs REQ_PREFLUSH */
-#define XLOG_ICL_NEED_FUA	(1u << 1)	/* iclog needs REQ_FUA */
+#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* all devs need REQ_PREFLUSH */
+#define XLOG_ICL_NEED_FLUSH_LOG	(1u << 0)	/* logdev needs REQ_PREFLUSH */
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

