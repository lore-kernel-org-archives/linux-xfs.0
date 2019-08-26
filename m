Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA067C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B1A721881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PjojIHfl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfHZVVz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:21:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfHZVVy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:21:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLF1VS161951;
        Mon, 26 Aug 2019 21:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JByBuDKcthLdTjuFdH8vn9DZ3oUYwRHAGRe5Uju/qwc=;
 b=PjojIHflTIpBpRc2Hn4TDnt3QrgvhT6S9LuO44vGUFQEqNxxoBCcXgw44Wj9Izq4bRbA
 Ns6x+IBfCpaF7hvI5wkS4X8Tf/L6w1e8poAsYEw4cz+Edone4UgeiGmyIRTx0XcDDk3t
 kJXBeGIAS2LJuB/GrQ+ntP1jOb9l5tO7kj8qyBTibRY9kjh0yFDmOB19BvwVZKYDvbNC
 tdTy52tbLRikJA3Kygfa2AkakSoG1XIxiKaCeRybqlQRu/HvbGaVwMC2XN+ssPmMTUTt
 Pi5cdPZ03DsDvQ8YiKtw1gtdFbP44oNnM6OHNMfCcaOCi8UjcpcPseksI15WMcWMScxF kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t80yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIIO8169911;
        Mon, 26 Aug 2019 21:21:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2umj277tjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLLmcl030553;
        Mon, 26 Aug 2019 21:21:48 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:21:47 -0700
Subject: [PATCH 1/4] libxfs: fix uncached buffer refcounting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 26 Aug 2019 14:21:46 -0700
Message-ID: <156685450680.2840210.3212526932977200554.stgit@magnolia>
In-Reply-To: <156685449440.2840210.11908449959921635294.stgit@magnolia>
References: <156685449440.2840210.11908449959921635294.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, uncached buffers in userspace are created with zero refcount
and are fed to cache_node_put when they're released.  This is totally
broken -- the refcount should be 1 (because the caller now holds a
reference) and we should never be dumping uncached buffers into the
cache.  Fix both of these problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h   |   18 ++++++++++++++++++
 libxfs/libxfs_priv.h |    2 --
 libxfs/rdwr.c        |    5 ++++-
 3 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 0b8d9774..7dcb4bff 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -227,4 +227,22 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 	return 0;
 }
 
+/*
+ * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
+ * and the cache node hash list will be empty to indicate that it's uncached.
+ */
+static inline struct xfs_buf *
+xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
+{
+	struct xfs_buf	*bp;
+
+	bp = libxfs_getbufr(targ, XFS_BUF_DADDR_NULL, bblen);
+	if (!bp)
+		return NULL;
+
+	INIT_LIST_HEAD(&bp->b_node.cn_hash);
+	bp->b_node.cn_count = 1;
+	return bp;
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 8b3de170..99cfac1f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -379,8 +379,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_buf_get_uncached(t,n,f)     \
-	libxfs_getbufr((t), XFS_BUF_DADDR_NULL, (n));
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 1f2c129b..3282f6de 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -867,7 +867,10 @@ libxfs_putbuf(xfs_buf_t *bp)
 		}
 	}
 
-	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	if (!list_empty(&bp->b_node.cn_hash))
+		cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	else if (--bp->b_node.cn_count == 0)
+		libxfs_putbufr(bp);
 }
 
 void

