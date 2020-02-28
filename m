Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3F6C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30D821927
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oWCtiKPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgB1Xkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55962 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB1Xkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXYol068912;
        Fri, 28 Feb 2020 23:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fJOkw7/OjzptillpcCLzfHPLGEC+w/SCF6ObHsXYeBI=;
 b=oWCtiKPsWT0puCnVADv/Tujzn3voES+2jczo870C2zAZP20fWvkH3fKLXqReZQq8spXC
 MeRS0bXY+fHKO15ND6ZOy+FlMaE/yEnAuLPFKD53pYicmjv6Q8baXKwWmOCiJp44avb+
 Jt1RXSDxLbmblQKOe3tMtBwxT7E6vj+kmbxDDneXNzOkILq/n8h7pwJtPeCXsSGWcyCx
 7yQzZqFzZPvbvJChBwq2mFUkhZlfivZhyVID18eckxDTH5Xsml6hkdB53HdqH9wwFZ4N
 sGecVq0aeNyaUThXZvoZoVNWDpT90rDHFl1PfMc+C2FygV6Pajxvt7yxKxC3oDt8boFO 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNam3B112994;
        Fri, 28 Feb 2020 23:38:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcsgem3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNcdu2013578;
        Fri, 28 Feb 2020 23:38:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:39 -0800
Subject: [PATCH 22/26] libxfs: remove the libxfs_{get,put}bufr APIs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:38 -0800
Message-ID: <158293311854.1549542.2526961953403828383.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hide libxfs_getbufr since nobody should be using the internal function,
and fold libxfs_putbufr into its only caller.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    3 ---
 libxfs/rdwr.c      |   20 ++++++++------------
 2 files changed, 8 insertions(+), 15 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index cd159881..c69eea97 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -213,9 +213,6 @@ extern void	libxfs_bcache_flush(void);
 extern int	libxfs_bcache_overflowed(void);
 
 /* Buffer (Raw) Interfaces */
-extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
-extern void	libxfs_putbufr(xfs_buf_t *);
-
 int		libxfs_bwrite(struct xfs_buf *bp);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 68e8e014..82f15af9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -21,6 +21,8 @@
 
 #include "libxfs.h"
 
+static void libxfs_brelse(struct cache_node *node);
+
 /*
  * Important design/architecture note:
  *
@@ -437,7 +439,7 @@ __libxfs_getbufr(int blen)
 	return bp;
 }
 
-xfs_buf_t *
+static xfs_buf_t *
 libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 {
 	xfs_buf_t	*bp;
@@ -641,8 +643,11 @@ libxfs_buf_relse(
 
 	if (!list_empty(&bp->b_node.cn_hash))
 		cache_node_put(libxfs_bcache, &bp->b_node);
-	else if (--bp->b_node.cn_count == 0)
-		libxfs_putbufr(bp);
+	else if (--bp->b_node.cn_count == 0) {
+		if (bp->b_flags & LIBXFS_B_DIRTY)
+			libxfs_bwrite(bp);
+		libxfs_brelse(&bp->b_node);
+	}
 }
 
 static struct cache_node *
@@ -1127,15 +1132,6 @@ libxfs_bflush(
 	return bp->b_error;
 }
 
-void
-libxfs_putbufr(xfs_buf_t *bp)
-{
-	if (bp->b_flags & LIBXFS_B_DIRTY)
-		libxfs_bwrite(bp);
-	libxfs_brelse(&bp->b_node);
-}
-
-
 void
 libxfs_bcache_purge(void)
 {

