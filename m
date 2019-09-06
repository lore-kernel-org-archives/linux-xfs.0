Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C11C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57DDE20820
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CO8+wBeT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404437AbfIFDeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:34:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404423AbfIFDeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:34:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YfHd110282;
        Fri, 6 Sep 2019 03:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uP4IyuRfuHCEAChnI0vS0qLm57WFRpeJa8Q+yl7RFu4=;
 b=CO8+wBeTALOUGVqsZWg6HDvaVNJFCQAk+cqmfZ0d1EGjPThlKxcnNiCD+Xir9uDDF2G4
 0jyD3um6/1tCnRyyRvYFUHgI/yhbD9Dg9Wijf4yhk1jortgZAcDMEo9iycGHmb4VXXsg
 e9WBggUkFGZjsg98P94jQdzaIcjW3hghfwRT4aDztxk2RaX3crjtYuqkNruKtNEmJMYs
 6IWsB1VXFKph+z2RxztsP5c/GVDauRSV7tL2d214R8mqcMkPjKf6x0vW0vef3CEShcqs
 9jXAn/jcbEdOrg2QjBXStPpHCyc1JQeT4zt0V79dUnQMaiwrQr9AYM/Ws9eY12ng4ICI bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuf4n035g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XbbY069151;
        Fri, 6 Sep 2019 03:34:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2utvr4jtbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863YeSV014281;
        Fri, 6 Sep 2019 03:34:40 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:34:40 -0700
Subject: [PATCH 3/4] libxfs: make xfs_buf_delwri_submit actually do something
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Thu, 05 Sep 2019 20:34:39 -0700
Message-ID: <156774087984.2643362.3110363143998046856.stgit@magnolia>
In-Reply-To: <156774086083.2643362.4042713521116931635.stgit@magnolia>
References: <156774086083.2643362.4042713521116931635.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_buf_delwri_queue doesn't report errors, which means that if the
buffer write fails we have no way of knowing that something bad
happened.  In the kernel we queue and then submit buffers, and the
submit call communicates errors to callers.  Do the same here since
we're going to start using the AG header initialization functions, which
use delwri_{queue,submit} heavily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h   |    6 +++++-
 libxfs/libxfs_priv.h |    1 -
 libxfs/rdwr.c        |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 09ed043b..579df52b 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -71,6 +71,7 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
+	struct list_head	b_list;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
 	const char		*b_func;
@@ -245,11 +246,14 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
 	return bp;
 }
 
+/* Push a single buffer on a delwri queue. */
 static inline void
 xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 {
 	bp->b_node.cn_count++;
-	libxfs_writebuf(bp, 0);
+	list_add_tail(&bp->b_list, buffer_list);
 }
 
+int xfs_buf_delwri_submit(struct list_head *buffer_list);
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 13dab58a..ff35c51e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -382,7 +382,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3282f6de..0d3e6089 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1473,3 +1473,28 @@ libxfs_irele(
 	libxfs_idestroy(ip);
 	kmem_zone_free(xfs_inode_zone, ip);
 }
+
+/*
+ * Write out a buffer list synchronously.
+ *
+ * This will take the @buffer_list, write all buffers out and wait for I/O
+ * completion on all of the buffers. @buffer_list is consumed by the function,
+ * so callers must have some other way of tracking buffers if they require such
+ * functionality.
+ */
+int
+xfs_buf_delwri_submit(
+	struct list_head	*buffer_list)
+{
+	struct xfs_buf		*bp, *n;
+	int			error = 0, error2;
+
+	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
+		list_del_init(&bp->b_list);
+		error2 = libxfs_writebuf(bp, 0);
+		if (!error)
+			error = error2;
+	}
+
+	return error;
+}

