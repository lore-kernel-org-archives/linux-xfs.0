Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/20] xfs: remove the syncing argument from xlog_verify_iclog
Date: Mon,  3 Jun 2019 19:29:36 +0200
Message-Id: <20190603172945.13819-12-hch@lst.de>
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>

The only caller unconditionally passes true here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa0414b8b111..70627debb954 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -103,8 +103,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing);
+	int			count);
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
@@ -113,7 +112,7 @@ xlog_verify_tail_lsn(
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
-#define xlog_verify_iclog(a,b,c,d)
+#define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
@@ -1958,7 +1957,7 @@ xlog_sync(
 	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
 	iclog->ic_bwritecnt = split ? 2 : 1;
 
-	xlog_verify_iclog(log, iclog, count, true);
+	xlog_verify_iclog(log, iclog, count);
 	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, need_flush);
 
 	if (split) {
@@ -3798,8 +3797,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing)
+	int			count)
 {
 	xlog_op_header_t	*ophead;
 	xlog_in_core_t		*icptr;
@@ -3843,7 +3841,7 @@ xlog_verify_iclog(
 		/* clientid is only 1 byte */
 		p = &ophead->oh_clientid;
 		field_offset = p - base_ptr;
-		if (!syncing || (field_offset & 0x1ff)) {
+		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
@@ -3866,7 +3864,7 @@ xlog_verify_iclog(
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
