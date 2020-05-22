Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BCFC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C84B5207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d/FoubmW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgEVC4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:56:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39404 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgEVC4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:56:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2lruP069924;
        Fri, 22 May 2020 02:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GlvWHUecCVXPn2SplohlLmgMmupSZSClXjkLk/1NwHs=;
 b=d/FoubmWi1FoRlc0dmvSp5tNIVdJpTlR1x+ZXj/iIrZdBhJYeWgk/9Bp1IMpNssRHqdV
 8EecIBukkyg5vf7ElBfsA3XL7MhIjOZrmqJQ0UKXPXv3vkEUEkUC7id7FFaoJd55dsws
 ba1yYs2SqAH2dFMXBl/vSljugsV0j4ER3QnSwfCy+pDWBp3/9aUMEIZXayaO+QQclR+U
 EId9D1SOvy+BaEkrzg01GWwqKZ4ScSfRCOLwstgcMqtJFAVonoLfhr/EtGvMQd8XZfvr
 sQTe9S02eYvJv5k+buxwstApj/wCiq7vR4dGih8nuHQ9CCZ6rDvP3rEelfv1T5YUiTVO EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31501rj2r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:56:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nHxh151991;
        Fri, 22 May 2020 02:54:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 315023h6xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2selx015623;
        Fri, 22 May 2020 02:54:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:39 -0700
Subject: [PATCH 11/12] xfs: straighten out all the naming around incore inode
 tree walks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Thu, 21 May 2020 19:54:38 -0700
Message-ID: <159011607872.77079.14383762107157416126.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=3 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We're not very consistent about function names for the incore inode
iteration function.  Turn them all into xfs_inode_walk* variants.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |   18 +++++++++---------
 fs/xfs/xfs_icache.h      |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0e25d50372e2..baf59087caa5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -747,12 +747,12 @@ xfs_icache_inode_is_allocated(
  * ignore it.
  */
 STATIC bool
-xfs_inode_ag_walk_grab(
+xfs_inode_walk_ag_grab(
 	struct xfs_inode	*ip,
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_AGITER_INEW_WAIT);
+	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -796,7 +796,7 @@ xfs_inode_ag_walk_grab(
  * inodes with the given radix tree @tag.
  */
 STATIC int
-xfs_inode_ag_walk(
+xfs_inode_walk_ag(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -844,7 +844,7 @@ xfs_inode_ag_walk(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_ag_walk_grab(ip, iter_flags))
+			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
 				batch[i] = NULL;
 
 			/*
@@ -872,7 +872,7 @@ xfs_inode_ag_walk(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
+			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], args);
@@ -917,7 +917,7 @@ xfs_inode_walk_get_perag(
  * @tag.
  */
 int
-xfs_inode_ag_iterator(
+xfs_inode_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -932,7 +932,7 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
+		error = xfs_inode_walk_ag(mp, pag, execute, args, tag,
 				iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
@@ -1528,7 +1528,7 @@ xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_eofblocks, eofb,
+	return xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
@@ -1778,7 +1778,7 @@ xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_cowblocks, eofb,
+	return xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e7f86ebd7b22..93b54e7d55f0 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -24,7 +24,7 @@ struct xfs_eofblocks {
  * tags for inode radix tree
  */
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_ag_iterator */
+					   in xfs_inode_walk */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 #define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
 #define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
@@ -40,7 +40,7 @@ struct xfs_eofblocks {
 /*
  * flags for AG inode iterator
  */
-#define XFS_AGITER_INEW_WAIT	0x1	/* wait on new inodes */
+#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
 
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
@@ -71,7 +71,7 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
+int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
 	int (*execute)(struct xfs_inode *ip, void *args),
 	void *args, int tag);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 4b61a683a43e..e8b63af93eb5 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -773,6 +773,6 @@ xfs_qm_dqrele_all_inodes(
 	uint			flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
+	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
 			&flags, XFS_ICI_NO_TAG);
 }

