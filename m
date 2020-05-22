Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0299C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC91207E8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tsD4UKBr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgEVC4I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:56:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgEVC4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:56:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2meZi123404;
        Fri, 22 May 2020 02:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uiOC/fAJkZeZ9ACDLE93T4gNlzupIPPPvoiU7vtHj4E=;
 b=tsD4UKBriq1KNYa419imWV4hn+twA+4qOYTZRbeNGm28MqgkjMMcwhufhjNXry9zQTfG
 jBTh3GEyFM2omSYgx+SYmOjLdmS2WnmpIiO+YQsqceIhtHMBApNoMm+oquKTeoRax5h1
 dl5f6sqYOTDhqWEJOlAEby3IVlDstO8lLG8U8kfcQIfMlusKJy+VzG2pPj/8ft2Wmq6m
 nGQR6SQ04meCNNoeaWTiYDULMvQtup+lJitSCppCeNVsjV5YZm6XFBZ5ryhU/yhCVMGE
 Pj268qUZz0C08MZeNNGTcqtsArNLkrIuXBt2/FPXRIGCgP4jh+UpMGhKNspiad0ExZ5Z Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krkk1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:54:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nG8q174128;
        Fri, 22 May 2020 02:54:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3d3xeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2s1oc030147;
        Fri, 22 May 2020 02:54:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:00 -0700
Subject: [PATCH 05/12] xfs: remove flags argument from xfs_inode_ag_walk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Thu, 21 May 2020 19:53:59 -0700
Message-ID: <159011603978.77079.10531037194098683108.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=3 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The incore inode walk code passes a flags argument and a pointer from
the xfs_inode_ag_iterator caller all the way to the iteration function.
We can reduce the function complexity by passing flags through the
private pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |   43 +++++++++++++++++--------------------------
 fs/xfs/xfs_icache.h      |    4 ++--
 fs/xfs/xfs_qm_syscalls.c |   15 ++++++++-------
 3 files changed, 27 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6d7f3014d547..53c6cc7bc02a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -790,9 +790,7 @@ STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
-	int			flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	int			tag,
 	int			iter_flags)
@@ -868,7 +866,7 @@ xfs_inode_ag_walk(
 			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], flags, args);
+			error = execute(batch[i], args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -972,9 +970,7 @@ int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
 	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
-	int			flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	int			tag)
 {
@@ -986,7 +982,7 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag,
+		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
 				iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
@@ -1443,12 +1439,14 @@ xfs_inode_match_id_union(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	int			flags,
 	void			*args)
 {
-	int ret = 0;
-	struct xfs_eofblocks *eofb = args;
-	int match;
+	struct xfs_eofblocks	*eofb = args;
+	bool			wait;
+	int			match;
+	int			ret;
+
+	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1461,8 +1459,7 @@ xfs_inode_free_eofblocks(
 	 * If the mapping is dirty the operation can block and wait for some
 	 * time. Unless we are waiting, skip it.
 	 */
-	if (!(flags & SYNC_WAIT) &&
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
+	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
 	if (eofb) {
@@ -1484,10 +1481,11 @@ xfs_inode_free_eofblocks(
 	 * scanner moving and revisit the inode in a subsequent pass.
 	 */
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (flags & SYNC_WAIT)
-			ret = -EAGAIN;
-		return ret;
+		if (wait)
+			return -EAGAIN;
+		return 0;
 	}
+
 	ret = xfs_free_eofblocks(ip);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
@@ -1498,16 +1496,10 @@ static int
 __xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
+	int			(*execute)(struct xfs_inode *ip, void *args),
 	int			tag)
 {
-	int flags = SYNC_TRYLOCK;
-
-	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
-		flags = SYNC_WAIT;
-
-	return xfs_inode_ag_iterator(mp, 0, execute, flags, eofb, tag);
+	return xfs_inode_ag_iterator(mp, 0, execute, eofb, tag);
 }
 
 int
@@ -1732,7 +1724,6 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
-	int			flags,
 	void			*args)
 {
 	struct xfs_eofblocks	*eofb = args;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2d5ab9957d9f..e7f86ebd7b22 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -72,8 +72,8 @@ void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
 int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
-	int (*execute)(struct xfs_inode *ip, int flags, void *args),
-	int flags, void *args, int tag);
+	int (*execute)(struct xfs_inode *ip, void *args),
+	void *args, int tag);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index a9460bdcca87..4b61a683a43e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -729,9 +729,10 @@ xfs_qm_scall_getquota_next(
 STATIC int
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	int			flags,
 	void			*args)
 {
+	uint			*flags = args;
+
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
 	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
@@ -743,15 +744,15 @@ xfs_dqrele_inode(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
+	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
+	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
@@ -768,10 +769,10 @@ xfs_dqrele_inode(
  */
 void
 xfs_qm_dqrele_all_inodes(
-	struct xfs_mount *mp,
-	uint		 flags)
+	struct xfs_mount	*mp,
+	uint			flags)
 {
 	ASSERT(mp->m_quotainfo);
 	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
-			flags, NULL, XFS_ICI_NO_TAG);
+			&flags, XFS_ICI_NO_TAG);
 }

