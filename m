Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10ADC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914CB207D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nt0TRMB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgETBsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:48:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:48:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gFP0163706;
        Wed, 20 May 2020 01:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SNyndvqO6CnDp0iVq2j/ZLCqWmZYJhuQJoGQpLT+3OI=;
 b=nt0TRMB3cKE86pAhvewxEnSRvX/HdKDLAbdJdYS4zT0jxoaEv3pU1q6O4jAppuaLNTKP
 rP5ZHbtSblQJo/oPVzJDrMlKvFeo34E+/AQLNJaUjHlkziO2+RXDvRhsd7mkEYZpH9Ku
 Np3E1ZhM0PeNsbyRg6r8/fk57M3iiYzgpwkN3zvYTFQmpXKc9QIeQbo2lmSZmO3fe5a0
 iLqAsrhe6BkAS4HBANeFYjpgpFtDUtgR99nuseCsiQ21XOoaNiwE7FgytmfxIzYFTyee
 HdZ89VBy+5bXl9PW9xOnTo736LIZm3qMyCUI+mMw3QwcP9R8eJfNU006DbUYsPcxP09A nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284m0hc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:46:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gab4143098;
        Wed, 20 May 2020 01:46:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj2kbdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:46:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1kStb004130;
        Wed, 20 May 2020 01:46:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:46:27 -0700
Subject: [PATCH 11/11] xfs: hide most of the incore inode walk interface
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:46:27 -0700
Message-ID: <158993918698.976105.6231244252663510379.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200011
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
index 05614758fb1e..73ac0e18498e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -752,7 +752,7 @@ xfs_inode_ag_walk_grab(
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_AGITER_INEW_WAIT);
+	bool			newinos = !!(flags & XFS_ICI_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -796,7 +796,7 @@ xfs_inode_ag_walk_grab(
  * inodes with the given radix tree @tag.
  */
 STATIC int
-xfs_inode_ag_walk(
+xfs_ici_walk_ag(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -872,7 +872,7 @@ xfs_inode_ag_walk(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
+			if ((iter_flags & XFS_ICI_WALK_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], args);
@@ -916,8 +916,8 @@ xfs_ici_walk_get_perag(
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
@@ -932,7 +932,7 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
+		error = xfs_ici_walk_ag(mp, pag, execute, args, tag,
 				iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
@@ -944,6 +944,20 @@ xfs_inode_ag_iterator(
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
@@ -1524,7 +1538,7 @@ xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_eofblocks, eofb,
+	return xfs_ici_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
@@ -1774,7 +1788,7 @@ xfs_icache_free_cowblocks(
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
index 571ecb17b3bf..95c44d5c57a8 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -781,6 +781,5 @@ xfs_qm_dqrele_all_inodes(
 	};
 
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode, &dqr,
-			XFS_ICI_NO_TAG);
+	xfs_ici_walk_all(mp, xfs_dqrele_inode, &dqr);
 }

