Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F73C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF7E20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eOIkVxvu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgBYAPl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:15:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52792 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgBYAPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:15:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07cBo050107;
        Tue, 25 Feb 2020 00:15:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Dn8DLgPmUaWLmVosLAnWyJYtb7dps4ii+tS5WbZLqgY=;
 b=eOIkVxvuX60fgzsYnQbqhjg5hiDvUfpSN6bnAWjJPz9e477y0FSWDv+DRqR9LsEBA1xf
 Vr0xh585NphHr4Yn0JN1JbUSmSZb2SgBD1wWT7CQmWQKyM9HotgGTmvj7/mscT67Ch3V
 VRmkaWekQkSazSE5iiEleIlB19XulTiBIUOeuSVDBQaRRxQU4vsE9ADb9sxAz5Oaz4sY
 6LsRQ6Ay3/Nzwq+jjLgDFXW4/iQqkqGhIEhytvUkYjVyCZR2Zrp/lv/miffuwqhjmIX2
 bs1G25Fhj5SPCctv1Mv6LHCDUUs8foLNxY66rGhKa8Ezb9N3odmky1yonFGDFbaRyZ80 cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06gYP099062;
        Tue, 25 Feb 2020 00:13:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybduvg0n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0Dbob032052;
        Tue, 25 Feb 2020 00:13:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:37 -0800
Subject: [PATCH 20/25] libxfs: remove dangerous casting between xfs_buf and
 cache_node
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:13:36 -0800
Message-ID: <158258961671.451378.13182510046201286918.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=834 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=891 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of all the dangerous casting between xfs_buf and cache_node
since we can dereference directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 5285abd5..09a2a716 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -518,8 +518,8 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 		bp->b_holder = pthread_self();
 	}
 
-	cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
-		cache_node_get_priority((struct cache_node *)bp) -
+	cache_node_set_priority(libxfs_bcache, &bp->b_node,
+			cache_node_get_priority(&bp->b_node) -
 						CACHE_PREFETCH_PRIORITY);
 #ifdef XFS_BUF_TRACING
 	pthread_mutex_lock(&libxfs_bcache->c_mutex);
@@ -535,7 +535,7 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 
 	return bp;
 out_put:
-	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	cache_node_put(libxfs_bcache, &bp->b_node);
 	return NULL;
 }
 
@@ -632,23 +632,25 @@ libxfs_buf_relse(
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
 
 
@@ -1120,7 +1122,7 @@ libxfs_putbufr(xfs_buf_t *bp)
 {
 	if (bp->b_flags & LIBXFS_B_DIRTY)
 		libxfs_bwrite(bp);
-	libxfs_brelse((struct cache_node *)bp);
+	libxfs_brelse(&bp->b_node);
 }
 
 

