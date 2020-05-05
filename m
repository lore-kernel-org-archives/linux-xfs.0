Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E153C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E3220705
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KvCYnkus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgEEBNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgEEBNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045148fL056139
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8/rXfEqpa0yAioOMtICXvzh6M5M0zUGgSfMjiZGcVFE=;
 b=KvCYnkusT/DfKE7Fkqnr32x1fB4SGfpoQ9V7v0MTNxswui6QIxhieucNPz5d85DMVT3P
 bWB3SOWgLERTetoplQELvuMW2OCkiqzvBq1q1bnwaVqpcXMtPA1x1RD13e1+9nIFjIFS
 XejPeMRymOISleU7iJqYVkE+jmcQdF9fXVfD3bofyFil4sFeIOa+8tMqaBdbY+eSOlBN
 BeIs6safPySPP5n+cAyw0atTw/nhbsL3q1XvOhglw0A2QRE2XB+4S7uaMoKfmrJFeBFy
 7PMM6c/qslwBTCEIt7EdzKmPiIYNG+uVwgKt21QSVySMsN4lhe3EFu54f3hRaw7nSf9w FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn1vnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515SAM145416
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjncm1xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451DJpQ028409
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:19 -0700
Subject: [PATCH 26/28] xfs: move log recovery buffer cancellation code to
 xfs_buf_item_recover.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:18 -0700
Message-ID: <158864119836.182683.2865492755380039236.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the helpers that handle incore buffer cancellation records to
xfs_buf_item_recover.c since they're not directly related to the main
log recovery machinery.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item_recover.c |  104 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c      |  102 ----------------------------------------
 2 files changed, 104 insertions(+), 102 deletions(-)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4ca6d47d6c95..99ec6ebbc7f4 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -23,6 +23,110 @@
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
 
+/*
+ * This structure is used during recovery to record the buf log items which
+ * have been canceled and should not be replayed.
+ */
+struct xfs_buf_cancel {
+	xfs_daddr_t		bc_blkno;
+	uint			bc_len;
+	int			bc_refcount;
+	struct list_head	bc_list;
+};
+
+static struct xfs_buf_cancel *
+xlog_find_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct list_head	*bucket;
+	struct xfs_buf_cancel	*bcp;
+
+	if (!log->l_buf_cancel_table)
+		return NULL;
+
+	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
+	list_for_each_entry(bcp, bucket, bc_list) {
+		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
+			return bcp;
+	}
+
+	return NULL;
+}
+
+bool
+xlog_add_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct xfs_buf_cancel	*bcp;
+
+	/*
+	 * If we find an existing cancel record, this indicates that the buffer
+	 * was cancelled multiple times.  To ensure that during pass 2 we keep
+	 * the record in the table until we reach its last occurrence in the
+	 * log, a reference count is kept to tell how many times we expect to
+	 * see this record during the second pass.
+	 */
+	bcp = xlog_find_buffer_cancelled(log, blkno, len);
+	if (bcp) {
+		bcp->bc_refcount++;
+		return false;
+	}
+
+	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
+	bcp->bc_blkno = blkno;
+	bcp->bc_len = len;
+	bcp->bc_refcount = 1;
+	list_add_tail(&bcp->bc_list, XLOG_BUF_CANCEL_BUCKET(log, blkno));
+	return true;
+}
+
+/*
+ * Check if there is and entry for blkno, len in the buffer cancel record table.
+ */
+bool
+xlog_is_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
+}
+
+/*
+ * Check if there is and entry for blkno, len in the buffer cancel record table,
+ * and decremented the reference count on it if there is one.
+ *
+ * Remove the cancel record once the refcount hits zero, so that if the same
+ * buffer is re-used again after its last cancellation we actually replay the
+ * changes made at that point.
+ */
+bool
+xlog_put_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct xfs_buf_cancel	*bcp;
+
+	bcp = xlog_find_buffer_cancelled(log, blkno, len);
+	if (!bcp) {
+		ASSERT(0);
+		return false;
+	}
+
+	if (--bcp->bc_refcount == 0) {
+		list_del(&bcp->bc_list);
+		kmem_free(bcp);
+	}
+	return true;
+}
+
+/* log buffer item recovery */
+
 STATIC enum xlog_recover_reorder
 xlog_recover_buf_reorder(
 	struct xlog_recover_item	*item)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a49435db3be0..0c8a1f4bf4ad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -55,17 +55,6 @@ STATIC int
 xlog_do_recovery_pass(
         struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
 
-/*
- * This structure is used during recovery to record the buf log items which
- * have been canceled and should not be replayed.
- */
-struct xfs_buf_cancel {
-	xfs_daddr_t		bc_blkno;
-	uint			bc_len;
-	int			bc_refcount;
-	struct list_head	bc_list;
-};
-
 /*
  * Sector aligned buffer routines for buffer create/read/write/access
  */
@@ -1981,97 +1970,6 @@ xlog_recover_reorder_trans(
 	return error;
 }
 
-static struct xfs_buf_cancel *
-xlog_find_buffer_cancelled(
-	struct xlog		*log,
-	xfs_daddr_t		blkno,
-	uint			len)
-{
-	struct list_head	*bucket;
-	struct xfs_buf_cancel	*bcp;
-
-	if (!log->l_buf_cancel_table)
-		return NULL;
-
-	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
-	list_for_each_entry(bcp, bucket, bc_list) {
-		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
-			return bcp;
-	}
-
-	return NULL;
-}
-
-bool
-xlog_add_buffer_cancelled(
-	struct xlog		*log,
-	xfs_daddr_t		blkno,
-	uint			len)
-{
-	struct xfs_buf_cancel	*bcp;
-
-	/*
-	 * If we find an existing cancel record, this indicates that the buffer
-	 * was cancelled multiple times.  To ensure that during pass 2 we keep
-	 * the record in the table until we reach its last occurrence in the
-	 * log, a reference count is kept to tell how many times we expect to
-	 * see this record during the second pass.
-	 */
-	bcp = xlog_find_buffer_cancelled(log, blkno, len);
-	if (bcp) {
-		bcp->bc_refcount++;
-		return false;
-	}
-
-	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
-	bcp->bc_blkno = blkno;
-	bcp->bc_len = len;
-	bcp->bc_refcount = 1;
-	list_add_tail(&bcp->bc_list, XLOG_BUF_CANCEL_BUCKET(log, blkno));
-	return true;
-}
-
-/*
- * Check if there is and entry for blkno, len in the buffer cancel record table.
- */
-bool
-xlog_is_buffer_cancelled(
-	struct xlog		*log,
-	xfs_daddr_t		blkno,
-	uint			len)
-{
-	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
-}
-
-/*
- * Check if there is and entry for blkno, len in the buffer cancel record table,
- * and decremented the reference count on it if there is one.
- *
- * Remove the cancel record once the refcount hits zero, so that if the same
- * buffer is re-used again after its last cancellation we actually replay the
- * changes made at that point.
- */
-bool
-xlog_put_buffer_cancelled(
-	struct xlog		*log,
-	xfs_daddr_t		blkno,
-	uint			len)
-{
-	struct xfs_buf_cancel	*bcp;
-
-	bcp = xlog_find_buffer_cancelled(log, blkno, len);
-	if (!bcp) {
-		ASSERT(0);
-		return false;
-	}
-
-	if (--bcp->bc_refcount == 0) {
-		list_del(&bcp->bc_list);
-		kmem_free(bcp);
-	}
-	return true;
-}
-
 void
 xlog_buf_readahead(
 	struct xlog		*log,

