Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388341AbfETQPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:11 -0400
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwQ-0006nh-OD
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:11 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/17] xfs: remove the syncing argument from xlog_verify_iclog
Date: Mon, 20 May 2019 18:13:40 +0200
Message-Id: <20190520161347.3044-11-hch@lst.de>
In-Reply-To: <20190520161347.3044-1-hch@lst.de>
References: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The only caller unconditionally passes true here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c5a78bc9f99b..6eb0b3a6f0d1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -100,8 +100,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing);
+	int			count);
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
@@ -110,7 +109,7 @@ xlog_verify_tail_lsn(
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
-#define xlog_verify_iclog(a,b,c,d)
+#define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
@@ -1926,7 +1925,7 @@ xlog_sync(
 	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
 	iclog->ic_bwritecnt = split ? 2 : 1;
 
-	xlog_verify_iclog(log, iclog, count, true);
+	xlog_verify_iclog(log, iclog, count);
 	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, flush);
 
 	if (split) {
@@ -3759,8 +3758,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing)
+	int			count)
 {
 	xlog_op_header_t	*ophead;
 	xlog_in_core_t		*icptr;
@@ -3804,7 +3802,7 @@ xlog_verify_iclog(
 		/* clientid is only 1 byte */
 		p = &ophead->oh_clientid;
 		field_offset = p - base_ptr;
-		if (!syncing || (field_offset & 0x1ff)) {
+		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
@@ -3827,7 +3825,7 @@ xlog_verify_iclog(
 		/* check length */
 		p = &ophead->oh_len;
 		field_offset = p - base_ptr;
-		if (!syncing || (field_offset & 0x1ff)) {
+		if (field_offset & 0x1ff) {
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
 			idx = BTOBBT((uintptr_t)&ophead->oh_len -
-- 
2.20.1
