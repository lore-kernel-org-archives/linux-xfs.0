Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6BDC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF4C20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ltQ6viLu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBYAMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:12:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAMf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08WbX129978;
        Tue, 25 Feb 2020 00:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UP9TdHDLf/q1HEzmRNv5H44U5lc0SryU93vIdIIFZdg=;
 b=ltQ6viLuvfubWaXCpz0TTeLJOYku5A/K1sS5Fi+WUq/5r7vWjXg3CzxbD3Tr22Az6wCk
 7yv70gQ7jtRsCqAMym9854WpF81joefCw4GSenXYbIDQ4v245OpIKIlPsulJPAuuqscy
 tpO9KIdA2yLxrsljUuVhwSQvD9BQtoqMWwyZHAOJo4nY//W0J1UnSo+XoGKDrdvFGqmZ
 Q7f/1epvdF1a0i9hemZSkorKxj3JszDF+KwKl13ILVWrleyQJjBUegUQKMGBpye837S0
 ZZwX8g2VFNqqZ6HwSc5T3h/fGkAT9ZMUMKr/qvWRYil6PJaXQeHL9HCn/2fDr93nWleS kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrjrtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08EaR015026;
        Tue, 25 Feb 2020 00:12:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ybdshxy5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0CWJ7032553;
        Tue, 25 Feb 2020 00:12:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:32 -0800
Subject: [PATCH 10/25] libxfs: introduce libxfs_buf_read_uncached
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:12:31 -0800
Message-ID: <158258955183.451378.11324668365381818225.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=951 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=994
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce an uncached read function so that userspace can handle them in
the same way as the kernel.  This also eliminates the need for some of
the libxfs_purgebuf calls (and two trips into the cache code).

Refactor the get/read uncached buffer functions to hide the details of
uncached buffer-ism in rdwr.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_io.h       |   22 +++------------
 libxfs/rdwr.c            |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 17 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index df267c98..1149e301 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -45,7 +45,9 @@
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
+#define xfs_buf_get_uncached		libxfs_buf_get_uncached
 #define xfs_buf_read			libxfs_buf_read
+#define xfs_buf_read_uncached		libxfs_buf_read_uncached
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index d96b5318..21afc99c 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -255,23 +255,11 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 	return 0;
 }
 
-/*
- * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
- * and the cache node hash list will be empty to indicate that it's uncached.
- */
-static inline struct xfs_buf *
-xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
-{
-	struct xfs_buf	*bp;
-
-	bp = libxfs_getbufr(targ, XFS_BUF_DADDR_NULL, bblen);
-	if (!bp)
-		return NULL;
-
-	INIT_LIST_HEAD(&bp->b_node.cn_hash);
-	bp->b_node.cn_count = 1;
-	return bp;
-}
+struct xfs_buf *libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen,
+		int flags);
+int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
+		size_t bblen, int flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
 
 /* Push a single buffer on a delwri queue. */
 static inline void
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9ee9d557..9324ee1c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1066,6 +1066,73 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	return bp;
 }
 
+/* Allocate a raw uncached buffer. */
+static inline struct xfs_buf *
+libxfs_getbufr_uncached(
+	struct xfs_buftarg	*targ,
+	xfs_daddr_t		daddr,
+	size_t			bblen)
+{
+	struct xfs_buf		*bp;
+
+	bp = libxfs_getbufr(targ, daddr, bblen);
+	if (!bp)
+		return NULL;
+
+	INIT_LIST_HEAD(&bp->b_node.cn_hash);
+	bp->b_node.cn_count = 1;
+	return bp;
+}
+
+/*
+ * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
+ * and the cache node hash list will be empty to indicate that it's uncached.
+ */
+struct xfs_buf *
+libxfs_buf_get_uncached(
+	struct xfs_buftarg	*targ,
+	size_t			bblen,
+	int			flags)
+{
+	return libxfs_getbufr_uncached(targ, XFS_BUF_DADDR_NULL, bblen);
+}
+
+/*
+ * Allocate and read an uncached buffer.  The refcount will be 1, and the cache
+ * node hash list will be empty to indicate that it's uncached.
+ */
+int
+libxfs_buf_read_uncached(
+	struct xfs_buftarg	*targ,
+	xfs_daddr_t		daddr,
+	size_t			bblen,
+	int			flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	*bpp = NULL;
+	bp = libxfs_getbufr_uncached(targ, daddr, bblen);
+	if (!bp)
+		return -ENOMEM;
+
+	error = libxfs_readbufr(targ, daddr, bp, bblen, flags);
+	if (error)
+		goto err;
+
+	error = libxfs_readbuf_verify(bp, ops);
+	if (error)
+		goto err;
+
+	*bpp = bp;
+	return 0;
+err:
+	libxfs_buf_relse(bp);
+	return error;
+}
+
 static int
 __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 {

