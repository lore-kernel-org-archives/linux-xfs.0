Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DA7C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBF8207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A8B9FtsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgEVCyA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:54:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35454 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgEVCyA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:54:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2lOa1110467;
        Fri, 22 May 2020 02:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AkPEHSWnqzym6gaeuMDK+fBbCjyHTOKfN89IQW2CCa8=;
 b=A8B9FtsICpIb6myB4pexRYO1hclBEHIVJbquZuV0yu+5eiobbsKLjGZ0nYEzHdJeSp/G
 nurl76TjSCTyjiUhMmPt4E6yvXPuzOrdCDN/1N7k3sdGfS3YlzXTI7QEBMxziogMpKg+
 o73e+AZdKPzVsJL9TpbI1v8wyPTH0izv4Y4H13y1sLRFCNbAP3AupO902GZ4iiDFi3LW
 lntMTWaPZJz1C/xuV2giLipjbNhXMKjct1zeRptehPANhhSzfallEZWvjR/ptjzTguDC
 NKlLppUv4s1yuo355k0bkMVjAE2ScV/GUh5w+/wBSrjzrunCsSkSRCUf/sAV+gZt2Tc5 oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krkk1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nF1T173983;
        Fri, 22 May 2020 02:53:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3d3x6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2rs7Y015385;
        Fri, 22 May 2020 02:53:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:54 -0700
Subject: [PATCH 04/12] xfs: remove xfs_inode_ag_iterator_flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:53:53 -0700
Message-ID: <159011603321.77079.320022599197428040.stgit@magnolia>
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

Combine xfs_inode_ag_iterator_flags and xfs_inode_ag_iterator_tag into a
single wrapper function since there's only one caller of the _flags
variant.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c      |   43 +++++++++++++------------------------------
 fs/xfs/xfs_icache.h      |    5 +----
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 3 files changed, 16 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6aafb547f21a..6d7f3014d547 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -956,38 +956,22 @@ xfs_cowblocks_worker(
 	xfs_queue_cowblocks(mp);
 }
 
-int
-xfs_inode_ag_iterator_flags(
+/* Fetch the next (possibly tagged) per-AG structure. */
+static inline struct xfs_perag *
+xfs_inode_walk_get_perag(
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
+	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
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

