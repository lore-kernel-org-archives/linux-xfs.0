Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835B7C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5537C206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N2UGOX4i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgAABGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:06:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABGa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:06:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00116TVU108392
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eS29yflu1EuVPyKhfT0e4MRhBdA+1QP7ppNSrorhRjw=;
 b=N2UGOX4i2WSM3j+RCjaC5jIxJn7bcJiBcjGdbv/70l7h36v8DOty7lFtUYHRmCADhVaH
 tQ53JhDIkEKuOKfqV3bDZ7RZozAZSfVPKTQr9SuKAHj56Nw3D5V8k8A7EIvMTBTLR4Ej
 wCJQXhr2HQFpnvWN2LUh+yvy2Px20+KPR15kTlmnqVxrSSHfCPOAJgt05X899hwldw0r
 c2Imz42dlJ38OBOd0bWRc2LhbE0BOKqKVSfeYj8mukfVsllzg3aLWk9/oIIWCoEK9bME
 6qGBPM3AbqfanhyEAbeLG8cN+7HGgjxAfGGXXeEnti6YsMybq3/ysjPoJ7gghSVv/mZR cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftk2an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115EU7165814
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj914c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00116RKZ030472
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:28 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:26 -0800
Subject: [PATCH 04/11] xfs: remove xfs_inode_ag_iterator_flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:22 -0800
Message-ID: <157784078227.1360343.2856875463786215818.stgit@magnolia>
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
index 76f7ec754cca..708390f81a2e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -942,38 +942,22 @@ xfs_cowblocks_worker(
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
@@ -986,10 +970,10 @@ xfs_inode_ag_iterator_tag(
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
@@ -1509,8 +1493,7 @@ __xfs_icache_free_eofblocks(
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
index 1ea82764bf89..01fec95edaa7 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -771,6 +771,6 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator_flags(mp, xfs_dqrele_inode, flags, NULL,
-				    XFS_AGITER_INEW_WAIT);
+	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
+			flags, NULL, XFS_ICI_NO_TAG);
 }

