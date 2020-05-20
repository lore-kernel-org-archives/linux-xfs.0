Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690F7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C232083E
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l6ulyftN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgETBpz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:45:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETBpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:45:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1fOIM062052;
        Wed, 20 May 2020 01:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fpbRGBllXqt5lhMsDJda5t3CZkijtUOeLmu5CFEEELM=;
 b=l6ulyftNUUR9gE6fiJpvk5c1UGWPstxvDkMtOoCFj62EouZLtmpA+saDl7Iiv8fEfw2d
 +CAIiMCUVA+5y+lqqVS4ZaoUZKhhgMDjbe7ShVeeODyO7JpVJGOrLOIyJTyaRYPevn3/
 Ed0Ywlug3pXg/kDnr1aQkW2yyu4aqxOuLUk4QxM4br7lDmxvCTFcyd2bvFN6lrv2HGQT
 D3IgDHdi1iV26QUxebYPGdc9Jxj/6IiTji7e5lMp1J48tSwW9sbzB5I+ls9Ie9Kd9mSJ
 7Eyy8HIbsBO7ByYlOZjOeXWen6lOrv+5I7hh+fnFiiEIOl1Z+t0iZHVrNDTQ+3cE3+hD 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tngf14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:45:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1iPVu078092;
        Wed, 20 May 2020 01:45:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm643e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:45:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1jouJ024243;
        Wed, 20 May 2020 01:45:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:45:50 -0700
Subject: [PATCH 05/11] xfs: remove flags argument from xfs_inode_ag_walk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:45:49 -0700
Message-ID: <158993914950.976105.8586367797907212993.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=3
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=3 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200011
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
 fs/xfs/xfs_icache.c      |   38 ++++++++++++++------------------------
 fs/xfs/xfs_icache.h      |    4 ++--
 fs/xfs/xfs_qm_syscalls.c |   25 +++++++++++++++++--------
 3 files changed, 33 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e716b19879c6..87b98bfdf27d 100644
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
 	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
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
+	int			ret = 0;
+
+	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));
 
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
@@ -1484,7 +1481,7 @@ xfs_inode_free_eofblocks(
 	 * scanner moving and revisit the inode in a subsequent pass.
 	 */
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (flags & SYNC_WAIT)
+		if (wait)
 			ret = -EAGAIN;
 		return ret;
 	}
@@ -1498,16 +1495,10 @@ static int
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
@@ -1732,7 +1723,6 @@ xfs_prep_free_cowblocks(
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
index a9460bdcca87..571ecb17b3bf 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -726,12 +726,17 @@ xfs_qm_scall_getquota_next(
 	return error;
 }
 
+struct xfs_dqrele {
+	uint		flags;
+};
+
 STATIC int
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	int			flags,
 	void			*args)
 {
+	struct xfs_dqrele	*dqr = args;
+
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
 	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
@@ -743,15 +748,15 @@ xfs_dqrele_inode(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
+	if ((dqr->flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+	if ((dqr->flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
+	if ((dqr->flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
@@ -768,10 +773,14 @@ xfs_dqrele_inode(
  */
 void
 xfs_qm_dqrele_all_inodes(
-	struct xfs_mount *mp,
-	uint		 flags)
+	struct xfs_mount	*mp,
+	uint			flags)
 {
+	struct xfs_dqrele	dqr = {
+		.flags		= flags,
+	};
+
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
-			flags, NULL, XFS_ICI_NO_TAG);
+	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode, &dqr,
+			XFS_ICI_NO_TAG);
 }

