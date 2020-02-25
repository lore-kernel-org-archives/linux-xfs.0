Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308ECC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F158620838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MUBKyDly"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBYAPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:15:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33296 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:15:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09MsW033750;
        Tue, 25 Feb 2020 00:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SI7c8THkVQb9BuPVjdwhDyNOT+AzPLkFWYvn9ovN2hg=;
 b=MUBKyDlyxYMjVmHo+Puj3wBMzAmkAISXG2BFnUR6g4fMunz3fuT/0GqJZd+PA71OKNMN
 KNQRFAxzONGRFfIIdBr/H0VqqXT/eb+lBh+3W0htCx4+CzKLAHxHrYuZCmdJLYVKdtm8
 J0d8KJBWbXhByvv8t9w8mZ+mUfo9HmCmIJJsf6h+5lOMkMZpz2GvLccGjbIuEpCz4sAo
 4d0cJovJHSLLRxvn7d7rsTTH6u4SSCOQfoyrQ3vIOED440CeZc9OmGwof+P2ukjPUgGj
 VPlCMuBu6r5HFKuaaXVT/lOk+3TLomdLr/jsjyG6hgSed7aNFu/X3eDJQGCBoFJl2/vo bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ycppr8h53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06Z64098320;
        Tue, 25 Feb 2020 00:13:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduvg0y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0DoH9000720;
        Tue, 25 Feb 2020 00:13:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:49 -0800
Subject: [PATCH 22/25] libxfs: remove the libxfs_{get,put}bufr APIs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:13:48 -0800
Message-ID: <158258962890.451378.12681114574724102575.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hide libxfs_getbufr since nobody should be using the internal function,
and fold libxfs_putbufr into its only caller.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 29c9dd68..e46f749c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -21,6 +21,8 @@
 
 #include "libxfs.h"
 
+static void libxfs_brelse(struct cache_node *node);
+
 /*
  * Important design/architecture note:
  *
@@ -430,7 +432,7 @@ __libxfs_getbufr(int blen)
 	return bp;
 }
 
-xfs_buf_t *
+static xfs_buf_t *
 libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 {
 	xfs_buf_t	*bp;
@@ -634,8 +636,11 @@ libxfs_buf_relse(
 
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
@@ -1120,15 +1125,6 @@ libxfs_bflush(
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

