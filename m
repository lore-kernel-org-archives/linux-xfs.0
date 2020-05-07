Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B45C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F722082E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bw0MS2Tk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgEGBG0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:06:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgEGBG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:06:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xRT4123224;
        Thu, 7 May 2020 01:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=q4erqzCqt12bMeBV2k9QquZ2cI2sjyr5VjV4KH9fKew=;
 b=Bw0MS2TkK+L0FCbGhLLybppGGiCsg5+SffQUMhLKMconTUh8VaI9+QiK5EM68SxBUzEy
 2/dkMw0n1tlF93abIhlP/nlMdQH+/r3iFytzMzHFpJXJq4xkBoIIp1TTlPFCZEnP25J1
 AdgLNBnkp2EqKO81qwhukF0ywNvzUX/nOdUMlHnHwE4nDug6AMhHxqrINx+nF/ToifUB
 68A0D7fifelGPZH4Pg/zfwN+J2PNy2eQhvwpLVUyKIKPKMCm4jQxLe8DLhQ1mH3KC5V4
 lbwZm7nPzn+5VxMxYzFrZhNDXjUJhfUHKuv0lFLWaj71r2gnRZvJRcNG4N7QsTURMbNn Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq4jhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vXJ9150955;
        Thu, 7 May 2020 01:04:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnmbphy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:21 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04714LRg028939;
        Thu, 7 May 2020 01:04:21 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:04:20 -0700
Subject: [PATCH 24/25] xfs: move log recovery buffer cancellation code to
 xfs_buf_item_recover.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:04:17 -0700
Message-ID: <158881345727.189971.4287628492235319845.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the helpers that handle incore buffer cancellation records to
xfs_buf_item_recover.c since they're not directly related to the main
log recovery machinery.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 -
 fs/xfs/xfs_buf_item_recover.c   |  104 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |  102 --------------------------------------
 3 files changed, 104 insertions(+), 104 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 929366d58c35..641132d0e39d 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -120,9 +120,7 @@ struct xlog_recover {
 
 void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
 		const struct xfs_buf_ops *ops);
-bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
-bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 void xlog_recover_iodone(struct xfs_buf *bp);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4ba2e27a15ca..04faa7310c4f 100644
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
+static bool
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
+static bool
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
 /*
  * Sort buffer items for log recovery.  Most buffer items should end up on the
  * buffer list and are recovered first, with the following exceptions:
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fa1b63bd9031..572e6707362a 100644
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
@@ -1964,97 +1953,6 @@ xlog_recover_reorder_trans(
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

