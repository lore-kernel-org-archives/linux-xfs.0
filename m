Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A20C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76BDF2469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CIt25Spn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgB1Xkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1Xki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXVd2068838;
        Fri, 28 Feb 2020 23:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BLOXL1mPZbxo6og0lYUfySSKFt1kNmMmYpN56L6Y2Xg=;
 b=CIt25Spn98O9uZY7wraIKVyZgSCE0vsH/X5N5jjery8R9IJ5aw/m29DlEeGix0XmOa91
 vcqYhdZJtSKIPEc1IPC1prcmMqqAxjs5xTEixVurcr5RELNoeWF3hzqcVZIcSwY9+c26
 Xu9vtO9eMFuLrNNX0gIm5wX3rK7X2bsD8wq3qLqgHw61PhsbhMivaYrY5t8X4sUpsgPa
 dzEuodll+IvqshhB8GGQofoGDqXfTW/NIQhbrPfLJFROsnikpCML/EJH91+enK5/o4WH
 Fz8RUHTew21wDxqPIKQaI4ZtiC3yHCOsJ2lKO283x1MjzyR1r9ieUZwwkJ9MU1hQkB94 uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcWxX062170;
        Fri, 28 Feb 2020 23:38:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsgbd5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNcUgI013520;
        Fri, 28 Feb 2020 23:38:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:26 -0800
Subject: [PATCH 20/26] libxfs: remove dangerous casting between xfs_buf and
 cache_node
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:25 -0800
Message-ID: <158293310556.1549542.16088746339623428519.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=863 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=926 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of all the dangerous casting between xfs_buf and cache_node
since we can dereference directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    5 ++---
 libxfs/rdwr.c      |   28 +++++++++++++++-------------
 2 files changed, 17 insertions(+), 16 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 646e340b..cd159881 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -109,10 +109,9 @@ typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_SET_PRIORITY(bp,pri)	cache_node_set_priority( \
 						libxfs_bcache, \
-						(struct cache_node *)(bp), \
+						&(bp)->b_node, \
 						(pri))
-#define XFS_BUF_PRIORITY(bp)		(cache_node_get_priority( \
-						(struct cache_node *)(bp)))
+#define XFS_BUF_PRIORITY(bp)		(cache_node_get_priority(&(bp)->b_node))
 #define xfs_buf_set_ref(bp,ref)		((void) 0)
 #define xfs_buf_ioerror(bp,err)		((bp)->b_error = (err))
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index bb925711..f92c7db9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -525,8 +525,8 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 		bp->b_holder = pthread_self();
 	}
 
-	cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
-		cache_node_get_priority((struct cache_node *)bp) -
+	cache_node_set_priority(libxfs_bcache, &bp->b_node,
+			cache_node_get_priority(&bp->b_node) -
 						CACHE_PREFETCH_PRIORITY);
 #ifdef XFS_BUF_TRACING
 	pthread_mutex_lock(&libxfs_bcache->c_mutex);
@@ -542,7 +542,7 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 
 	return bp;
 out_put:
-	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	cache_node_put(libxfs_bcache, &bp->b_node);
 	return NULL;
 }
 
@@ -639,23 +639,25 @@ libxfs_buf_relse(
 	}
 
 	if (!list_empty(&bp->b_node.cn_hash))
-		cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+		cache_node_put(libxfs_bcache, &bp->b_node);
 	else if (--bp->b_node.cn_count == 0)
 		libxfs_putbufr(bp);
 }
 
 static struct cache_node *
-libxfs_balloc(cache_key_t key)
+libxfs_balloc(
+	cache_key_t		key)
 {
-	struct xfs_bufkey *bufkey = (struct xfs_bufkey *)key;
+	struct xfs_bufkey	*bufkey = (struct xfs_bufkey *)key;
+	struct xfs_buf		*bp;
 
 	if (bufkey->map)
-		return (struct cache_node *)
-		       libxfs_getbufr_map(bufkey->buftarg,
-					  bufkey->blkno, bufkey->bblen,
-					  bufkey->map, bufkey->nmaps);
-	return (struct cache_node *)libxfs_getbufr(bufkey->buftarg,
-					  bufkey->blkno, bufkey->bblen);
+		bp = libxfs_getbufr_map(bufkey->buftarg, bufkey->blkno,
+				bufkey->bblen, bufkey->map, bufkey->nmaps);
+	else
+		bp = libxfs_getbufr(bufkey->buftarg, bufkey->blkno,
+				bufkey->bblen);
+	return &bp->b_node;
 }
 
 
@@ -1127,7 +1129,7 @@ libxfs_putbufr(xfs_buf_t *bp)
 {
 	if (bp->b_flags & LIBXFS_B_DIRTY)
 		libxfs_bwrite(bp);
-	libxfs_brelse((struct cache_node *)bp);
+	libxfs_brelse(&bp->b_node);
 }
 
 

