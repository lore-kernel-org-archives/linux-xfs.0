Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F3C282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27902072A
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LAB1byoS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgAISow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:44:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:44:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdJjP140002
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DTOJOSuPErwAvsLr6L1B3JcqlOue6bhYn89Bzt4RScc=;
 b=LAB1byoSUvtiV0RYMIHmKJzou+iW4NOKLetpw/B1aCku1V6PI3yGmoz5XOpRSPmTUDBJ
 ItK947KegkdVk1v/THn0AOTxE2k+itkfFc6MruI4klZ/GBBfwjt+SXOb0nfsS2GVi/+e
 JjWzjksz+/ZWrkcSpYXtses5Yf46b/IKz2R3UTnEgfb9VcVDa3yux+KLm6sn90wrWLOm
 jHeCzreSbb5/7/CQGBlffJNEMpZO9yS0V3Jhj98qwPbMt8ELW60PyIMz0PwJYvYsm8F8
 FRvDbn0S0vGbfIYcI2wSDLcgHBuqWXZ5ZRw6TI3GRu6DR7vGeqHqKpKt4ZoxaGB+5+bk 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xakbr4psg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdhWN050929
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xdj4r95bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009IinZ6011736
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:44:48 -0800
Subject: [PATCH 1/5] xfs: refactor remote attr value buffer invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:44:46 -0800
Message-ID: <157859548668.164065.18078635787497973193.stgit@magnolia>
In-Reply-To: <157859548029.164065.5207227581806532577.stgit@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=951
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the code that invalidates remote extended attribute value buffers
into a separate helper function.  This prepares us for a memory
corruption fix in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   44 +++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_remote.h |    1 +
 2 files changed, 29 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a6ef5df42669..6babdaac6057 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -552,6 +552,32 @@ xfs_attr_rmtval_set(
 	return 0;
 }
 
+/* Mark stale any incore buffers for the remote value. */
+void
+xfs_attr_rmtval_stale(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*map)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		dblkno;
+	int			dblkcnt;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	dblkno = XFS_FSB_TO_DADDR(mp, map->br_startblock),
+	dblkcnt = XFS_FSB_TO_BB(mp, map->br_blockcount);
+
+	/*
+	 * If the "remote" value is in the cache, remove it.
+	 */
+	bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
+	if (bp) {
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+	}
+}
+
 /*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
@@ -560,7 +586,6 @@ int
 xfs_attr_rmtval_remove(
 	struct xfs_da_args	*args)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
@@ -575,9 +600,6 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	while (blkcnt > 0) {
 		struct xfs_bmbt_irec	map;
-		struct xfs_buf		*bp;
-		xfs_daddr_t		dblkno;
-		int			dblkcnt;
 		int			nmap;
 
 		/*
@@ -592,18 +614,8 @@ xfs_attr_rmtval_remove(
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
 
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
-
-		/*
-		 * If the "remote" value is in the cache, remove it.
-		 */
-		bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
-		if (bp) {
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-			bp = NULL;
-		}
+		if (map.br_startblock != HOLESTARTBLOCK)
+			xfs_attr_rmtval_stale(args->dp, &map);
 
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66ad379..ce7287ac5b1f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,6 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+void xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */

