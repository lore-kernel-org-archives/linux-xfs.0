Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1DEC33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B03512187F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VRSAt30U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgANGbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:31:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgANGbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:31:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6Cqjh116524;
        Tue, 14 Jan 2020 06:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LEmYjTtKjV2ShBSeQaOcD6Nq5LioPf5fkCW85j46K2g=;
 b=VRSAt30UoZpLrAjOwa+orWplpwW+vWO3vZb2YtgIpes6z3m4Jq4AIjf6SwN+mTSu30dr
 gam889UPPsmsnFBXMMukoGeEI4FvdTwQzyk1EbDoQeUPdPmWz/5ZK6AQsf6p210KcqZM
 +uwSgIN/v+uqCPejium1/ryKfCimsWSEiZhAAensFV2/RnaooW/Qh7Zsv/mr/9bGg9Do
 Hb7xetcvJkl/H0ByrZhHwtJld6/rSxHdBdPiTBVCJ8MPiEPmnSm1hX/SQWUIAJ6ujdTA
 1YFQS6Ku8GNpkd5LtIgwiYA1CE8RDLKdGgzs1/YY2HkrsXkGHRmCBPQP0rT2xoLHyymp rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73tkrx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:31:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6UCTP052953;
        Tue, 14 Jan 2020 06:31:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xh2sbyemg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:31:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00E6Vccs001340;
        Tue, 14 Jan 2020 06:31:38 GMT
Received: from localhost (/10.159.236.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 22:31:38 -0800
Subject: [PATCH 1/6] xfs: refactor remote attr value buffer invalidation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 13 Jan 2020 22:31:35 -0800
Message-ID: <157898349585.1566005.1902604375024932956.stgit@magnolia>
In-Reply-To: <157898348940.1566005.3231891474158666998.stgit@magnolia>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=852
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=910 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140055
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

