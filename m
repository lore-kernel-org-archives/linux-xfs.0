Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8120BC3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550E32469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZlWVv85p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1Xjd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgB1Xjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXabN028494;
        Fri, 28 Feb 2020 23:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QJxVDLmwLiD+cWNO81RSfGGPAA8EdrnezvITrfKJ+qs=;
 b=ZlWVv85pFpI4x/o42kPwsfSYJNc9ZwrYogR8QK7NauovKkbWVstZ3F1vY/xepgb5eL+2
 GN25PIUn1h8dcCxiXFJxIROsmpBU/U32FfDyYN3F1yYdbh5PIdtK52DjQuyHWqsN8Oov
 DQsf6SImu06s0Ls3YPpeObXlkfqcuueEC/iDXCDXYo93ihScswomdZRsSYR5HgW3Pujy
 EqKVoZYstLVLVz97Q3BGT4YsbAEZPZ3rjEfh3sQjOM0gj1Y4sleU4SQJa7nNCrR2Yv/F
 4vwzIZSjGSt1WhYnXnKD63dQfj7us6H+I+KM7II9d4n2XiMhU/g45RYscQEVWJP8OA3R 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct3nt3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWMxW042295;
        Fri, 28 Feb 2020 23:37:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ydcs9vjfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNbPm6020557;
        Fri, 28 Feb 2020 23:37:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:19 -0800
Subject: [PATCH 10/26] libxfs: introduce libxfs_buf_read_uncached
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:18 -0800
Message-ID: <158293303873.1549542.4777689362244384020.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=966 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 2c67edde..3b470266 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1073,6 +1073,73 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
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

