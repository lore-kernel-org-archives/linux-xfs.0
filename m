Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE558C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C44A2075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/O+5fBo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgETBpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:45:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETBpt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:45:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1fS5o062118;
        Wed, 20 May 2020 01:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Vm2fNwKgZyXTy6zl+OkDL8SJf8syOvBqf54VSqYhdjo=;
 b=O/O+5fBoMDwd4a09/DDWasMDjAbBqaoTTxSTGjOULPstUpDTG7mHud5zUrcM97Z/w0xE
 wGzrfTR8PaLf9d8rqUQ0K5gsHqwBXqHijwTPM7lghJNYwPMgT3vTjtS4xqaEc7eeiGKO
 HDzfA9tsE2JS4HectfvaGd//6FJMwZAy2/cLyj3qPyGwDUGk7gzFaH3lCTDM5ZW0WCsM
 A6u4qpMXkQp1NYSE2C4LSAo3Qsdjb3CbFnJjiZUz4aUtGaDv3zu0gwFAtxvAJAdXeYNv
 i+4eqbsxJ+9tEjrnMzFutqd3r2zydTam7pZoEnuk5x5jH6dbVtHdOdTJ9o3LX/1eM8QD 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tngf0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:45:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1h2S0132124;
        Wed, 20 May 2020 01:45:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t35yerp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:45:44 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1jiRK008317;
        Wed, 20 May 2020 01:45:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:45:44 -0700
Subject: [PATCH 04/11] xfs: remove xfs_inode_ag_iterator_flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:45:43 -0700
Message-ID: <158993914319.976105.18105362179838631438.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
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

Combine xfs_inode_ag_iterator_flags and xfs_inode_ag_iterator_tag into a
single wrapper function since there's only one caller of the _flags
variant.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |   43 +++++++++++++------------------------------
 fs/xfs/xfs_icache.h      |    5 +----
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 3 files changed, 16 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6aafb547f21a..e716b19879c6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -956,38 +956,22 @@ xfs_cowblocks_worker(
 	xfs_queue_cowblocks(mp);
 }
 
-int
-xfs_inode_ag_iterator_flags(
+/* Fetch the next (possibly tagged) per-AG structure. */
+static inline struct xfs_perag *
+xfs_ici_walk_get_perag(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
-	int			flags,
-	void			*args,
-	int			iter_flags)
+	xfs_agnumber_t		agno,
+	int			tag)
 {
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-
-	ag = 0;
-	while ((pag = xfs_perag_get(mp, ag))) {
-		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, args,
-				XFS_ICI_NO_TAG, iter_flags);
-		xfs_perag_put(pag);
-		if (error) {
-			last_error = error;
-			if (error == -EFSCORRUPTED)
-				break;
-		}
-	}
-	return last_error;
+	if (tag == XFS_ICI_NO_TAG)
+		return xfs_perag_get(mp, agno);
+	return xfs_perag_get_tag(mp, agno, tag);
 }
 
 int
-xfs_inode_ag_iterator_tag(
+xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
+	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, int flags,
 					   void *args),
 	int			flags,
@@ -1000,10 +984,10 @@ xfs_inode_ag_iterator_tag(
 	xfs_agnumber_t		ag;
 
 	ag = 0;
-	while ((pag = xfs_perag_get_tag(mp, ag, tag))) {
+	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
 		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag,
-					  0);
+				iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -1523,8 +1507,7 @@ __xfs_icache_free_eofblocks(
 	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
 		flags = SYNC_WAIT;
 
-	return xfs_inode_ag_iterator_tag(mp, execute, flags,
-					 eofb, tag);
+	return xfs_inode_ag_iterator(mp, 0, execute, flags, eofb, tag);
 }
 
 int
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 0556fa32074f..2d5ab9957d9f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -71,10 +71,7 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-int xfs_inode_ag_iterator_flags(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, int flags, void *args),
-	int flags, void *args, int iter_flags);
-int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
+int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args, int tag);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5d5ac65aa1cc..a9460bdcca87 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -772,6 +772,6 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator_flags(mp, xfs_dqrele_inode, flags, NULL,
-				    XFS_AGITER_INEW_WAIT);
+	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
+			flags, NULL, XFS_ICI_NO_TAG);
 }

