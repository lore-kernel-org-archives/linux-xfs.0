Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAB2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F8142064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HRyY5mdN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgAABGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:06:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:06:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00116ZAE090344
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PuK3A0zcb7GPD7svSulsgiPk49aByyB0X+yqs+DdN5A=;
 b=HRyY5mdNQpfPcEFmgyf4O8rHpWOYR8t3S8jI9t/3OnJqsdCkQI0c7AfzuhPwTyYI5MvR
 mARISDgpw/g+OBrWqptmHHb1SBp4uRgjN56WUTIWu47hYILkG1tldL8cgTNdoRD+5vP+
 3lfWqoJbJ66tKlWTQ+xyO98c1shYuj2cJ7nAkmn+Z8zDzsg8jB7gHaJ1Hv2DU4hTztsm
 bDx3q7q3tsNWIhfd2sNbMFkx6W3HYVDg8fTLZ3NRAB/c2CTO0yQDREJL2ROwAZsOkW9+
 sJ/wGG11KRfLQhOjUWI/PsK8OyJtzh7wF6YdG/k5EQOVO62qXKzUqjboxvVO4NvtLPuK JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115F1W006731
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guedykk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00116XVY010122
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:33 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:32 -0800
Subject: [PATCH 05/11] xfs: remove flags argument from xfs_inode_ag_walk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:30 -0800
Message-ID: <157784079074.1360343.14648160580278893006.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
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
index 708390f81a2e..3c872d3ac94d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -786,9 +786,7 @@ STATIC int
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
@@ -864,7 +862,7 @@ xfs_inode_ag_walk(
 			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], flags, args);
+			error = execute(batch[i], args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -958,9 +956,7 @@ int
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
@@ -972,7 +968,7 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag,
+		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
 				iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
@@ -1429,12 +1425,14 @@ xfs_inode_match_id_union(
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
@@ -1447,8 +1445,7 @@ xfs_inode_free_eofblocks(
 	 * If the mapping is dirty the operation can block and wait for some
 	 * time. Unless we are waiting, skip it.
 	 */
-	if (!(flags & SYNC_WAIT) &&
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
+	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
 	if (eofb) {
@@ -1470,7 +1467,7 @@ xfs_inode_free_eofblocks(
 	 * scanner moving and revisit the inode in a subsequent pass.
 	 */
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (flags & SYNC_WAIT)
+		if (wait)
 			ret = -EAGAIN;
 		return ret;
 	}
@@ -1484,16 +1481,10 @@ static int
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
@@ -1718,7 +1709,6 @@ xfs_prep_free_cowblocks(
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
index 01fec95edaa7..3cb8274ce0d9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -725,12 +725,17 @@ xfs_qm_scall_getquota_next(
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
@@ -742,15 +747,15 @@ xfs_dqrele_inode(
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
@@ -767,10 +772,14 @@ xfs_dqrele_inode(
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

