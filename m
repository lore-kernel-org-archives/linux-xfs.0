Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:29 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNg-0002Br-Hw
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:15:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/24] xfs: remove the l_iclog_size_log field from strut xlog
Date: Wed,  5 Jun 2019 21:14:52 +0200
Message-Id: <20190605191511.32695-6-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This field is never used, so we can simply kill it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 9 ---------
 fs/xfs/xfs_log_priv.h | 1 -
 2 files changed, 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2048e46be4e..8033b64092bb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1307,7 +1307,6 @@ xlog_get_iclog_buffer_size(
 	struct xfs_mount	*mp,
 	struct xlog		*log)
 {
-	int size;
 	int xhdrs;
 
 	if (mp->m_logbufs <= 0)
@@ -1319,13 +1318,6 @@ xlog_get_iclog_buffer_size(
 	 * Buffer size passed in from mount system call.
 	 */
 	if (mp->m_logbsize > 0) {
-		size = log->l_iclog_size = mp->m_logbsize;
-		log->l_iclog_size_log = 0;
-		while (size != 1) {
-			log->l_iclog_size_log++;
-			size >>= 1;
-		}
-
 		if (xfs_sb_version_haslogv2(&mp->m_sb)) {
 			/* # headers = size / 32k
 			 * one header holds cycles from 32k of data
@@ -1346,7 +1338,6 @@ xlog_get_iclog_buffer_size(
 
 	/* All machines use 32kB buffers by default. */
 	log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;
-	log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
 
 	/* the default log size is 16k or 32k which is one header sector */
 	log->l_iclog_hsize = BBSIZE;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b5f82cb36202..78a2abeba895 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -361,7 +361,6 @@ struct xlog {
 	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
-	int			l_iclog_size_log; /* log power size of log */
 	int			l_iclog_bufs;	/* number of iclog buffers */
 	xfs_daddr_t		l_logBBstart;   /* start block of log */
 	int			l_logsize;      /* size of log in bytes */
-- 
2.20.1
