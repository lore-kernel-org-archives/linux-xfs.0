Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A1CC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8A02064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tuwizh4f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgAABHP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:07:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgAABHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:07:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00114OP0107020
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=F7O79ISFAgKdmdiFix5xqZXYjPJnRIng3J5d9ijqWHQ=;
 b=Tuwizh4fuy5GFXxXFdvTEzvG6BvBG1EcTWgnDQqD8XrIeKpsoxFbK4HhDJ1LIgggAEJ8
 puhZASrDTkqCIXCB6hw62HQHUef5j0Rb7TztmmcHO9QnS3y0ZuObO53y3zZviG1gOTRq
 Jr857u/gDN0dl+orUH52YXFd1iRWhGZvEQM+2YFQm0JSBKO57ZS92Kcsb92wyzDGOE88
 JNLFKNFrqKgOokuk/ENZsy4ySH9cfy0vCj+f8y9WLuEbE506yi6eIW/sDTgtR31vnAbK
 PmF9VC6VqB2QMRISZS7RCKzznyLrxNeW6YSEqSGd88/opvhE+g75RPk6vkWUjD98jopn gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115Nsm039742
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x7medfad0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00117COA026968
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:12 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:12 -0800
Subject: [PATCH 11/11] xfs: hide most of the incore inode walk interface
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:10 -0800
Message-ID: <157784083001.1360343.16484129937624788936.stgit@magnolia>
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

Hide the incore inode walk interface because callers outside of the
icache code don't need to know about iter_flags and radix tags and other
implementation details of the incore inode cache.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |   30 ++++++++++++++++++++++--------
 fs/xfs/xfs_icache.h      |    8 ++++----
 fs/xfs/xfs_qm_syscalls.c |    3 +--
 3 files changed, 27 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d74f426a0293..03d7624fa97e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -748,7 +748,7 @@ xfs_inode_ag_walk_grab(
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_AGITER_INEW_WAIT);
+	bool			newinos = !!(flags & XFS_ICI_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -792,7 +792,7 @@ xfs_inode_ag_walk_grab(
  * inodes with the given radix tree @tag.
  */
 STATIC int
-xfs_inode_ag_walk(
+xfs_ici_walk_ag(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -868,7 +868,7 @@ xfs_inode_ag_walk(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
+			if ((iter_flags & XFS_ICI_WALK_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], args);
@@ -912,8 +912,8 @@ xfs_ici_walk_get_perag(
  * Call the @execute function on all incore inodes matching the radix tree
  * @tag.
  */
-int
-xfs_inode_ag_iterator(
+STATIC int
+xfs_ici_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -928,7 +928,7 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
+		error = xfs_ici_walk_ag(mp, pag, execute, args, tag,
 				iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
@@ -940,6 +940,20 @@ xfs_inode_ag_iterator(
 	return last_error;
 }
 
+/*
+ * Walk all incore inodes in the filesystem.  Knowledge of radix tree tags
+ * is hidden and we always wait for INEW inodes.
+ */
+int
+xfs_ici_walk_all(
+	struct xfs_mount	*mp,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args)
+{
+	return xfs_ici_walk(mp, XFS_ICI_WALK_INEW_WAIT, execute, args,
+			XFS_ICI_NO_TAG);
+}
+
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
  * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -1510,7 +1524,7 @@ xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_eofblocks, eofb,
+	return xfs_ici_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
@@ -1760,7 +1774,7 @@ xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_cowblocks, eofb,
+	return xfs_ici_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e7f86ebd7b22..0dc85a03dc6c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -38,9 +38,9 @@ struct xfs_eofblocks {
 #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
 
 /*
- * flags for AG inode iterator
+ * flags for incore inode iterator
  */
-#define XFS_AGITER_INEW_WAIT	0x1	/* wait on new inodes */
+#define XFS_ICI_WALK_INEW_WAIT	0x1	/* wait on new inodes */
 
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
@@ -71,9 +71,9 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
+int xfs_ici_walk_all(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
+	void *args);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3cb8274ce0d9..c339b7404cf3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -780,6 +780,5 @@ xfs_qm_dqrele_all_inodes(
 	};
 
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode, &dqr,
-			XFS_ICI_NO_TAG);
+	xfs_ici_walk_all(mp, xfs_dqrele_inode, &dqr);
 }

