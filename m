Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACDAC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF955214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IIz7YPiA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgAORDQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAORDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhXBd193122;
        Wed, 15 Jan 2020 17:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bo4C+FjZ6pC9B5172rgVcQ00PpkmYirHMO77OF2J/ww=;
 b=IIz7YPiAe6VYeyg/Ti3BBFAnGuBv/98YCkuKPG7eSz9SaXndEPSygQ4Je/s+1jRi4YIc
 RP/qMzhO5uGZOb2mOUX5e/0aXfwZO3xj1kPFmu2scQ/Ks/T5Hyqsu3lLIP1zBzJlwwQ8
 t99OcR4ihBq4I15rrWwKQUj/sqpYs//4/FTClDVeq1LydGEJ8Vr8dN1mVpTg0meZU8XS
 3ELeIbe6zgbmQC+pnkq077qcz4d2vC9Fh7kWiVPN0KSJJ2xKf9pW93JDl4MOSG0R5xhM
 TICRdj97NCotRm1VOk/64YL7hXm3pO86PYmWJx040rCMGUMAi7+aMFMYDJPmhEaKWT8s 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73twb8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhwRT021632;
        Wed, 15 Jan 2020 17:03:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xj1prgm04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:02 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH316M023256;
        Wed, 15 Jan 2020 17:03:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:00 -0800
Subject: [PATCH 1/7] xfs: refactor remote attr value buffer invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 15 Jan 2020 09:02:59 -0800
Message-ID: <157910777966.2028015.5063424466481996316.stgit@magnolia>
In-Reply-To: <157910777330.2028015.5017943601641757827.stgit@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=898
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=948 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the code that invalidates remote extended attribute value buffers
into a separate helper function.  This prepares us for a memory
corruption fix in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   52 ++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr_remote.h |    2 ++
 2 files changed, 34 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a6ef5df42669..df1ab0569481 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -552,6 +552,33 @@ xfs_attr_rmtval_set(
 	return 0;
 }
 
+/* Mark stale any incore buffers for the remote value. */
+int
+xfs_attr_rmtval_stale(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*map,
+	xfs_buf_flags_t		incore_flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (XFS_IS_CORRUPT(mp, map->br_startblock == DELAYSTARTBLOCK) ||
+	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
+		return -EFSCORRUPTED;
+
+	bp = xfs_buf_incore(mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, map->br_startblock),
+			XFS_FSB_TO_BB(mp, map->br_blockcount), incore_flags);
+	if (bp) {
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+	}
+
+	return 0;
+}
+
 /*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
@@ -560,7 +587,6 @@ int
 xfs_attr_rmtval_remove(
 	struct xfs_da_args	*args)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
@@ -575,9 +601,6 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	while (blkcnt > 0) {
 		struct xfs_bmbt_irec	map;
-		struct xfs_buf		*bp;
-		xfs_daddr_t		dblkno;
-		int			dblkcnt;
 		int			nmap;
 
 		/*
@@ -588,22 +611,11 @@ xfs_attr_rmtval_remove(
 				       blkcnt, &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-
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
+		if (XFS_IS_CORRUPT(args->dp->i_mount, nmap != 1))
+			return -EFSCORRUPTED;
+		error = xfs_attr_rmtval_stale(args->dp, &map, XBF_TRYLOCK);
+		if (error)
+			return error;
 
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66ad379..6fb4572845ce 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
+		xfs_buf_flags_t incore_flags);
 
 #endif /* __XFS_ATTR_REMOTE_H__ */

