Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3740FC32766
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E7A2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TTI9QmzD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAABJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011902c089143
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dXT8pDbDTzTbyC4PJoFV5C/xMOxnD/zUWGAjFQuy2do=;
 b=TTI9QmzD+lbdmwXwP0cMWMwi+fOxEarWBMbOhDWyL9AEsrpFnOUbDJFiXrxj9r2iPG2M
 j0H9GNJ6PGxttJi2/2Q72mx6kxl0MUsi1e1dVYeNFGJsYxBhk9BNQXlcL/QNyS2+ub7P
 5FdMWGih3Is5wdu80fo7cbSXgTtJK7fuigzp3jxwH92bIybkYJhjmMO/LogoOP8GYXT8
 fWgi+vZW5zLxAMF6+xaiHFSm2lRxf/ofgqMDKinj5DNwSJRSiIUyFIrbQovFd1jRe7bS
 YOUvrhwSJTdDdJ1xJ5+rUt5rxEBvrWeSdvfe8FaZATvpglLgcM/QynKLiJVFJq998AsR Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119058012550
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guee93u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00118Clm010707
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:12 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:12 -0800
Subject: [PATCH 2/6] xfs: consolidate incore inode radix tree
 posteof/cowblocks tags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:08 -0800
Message-ID: <157784088879.1361683.14999161892680165559.stgit@magnolia>
In-Reply-To: <157784087594.1361683.5987233633798863051.stgit@magnolia>
References: <157784087594.1361683.5987233633798863051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The clearing of posteof blocks and cowblocks serve the same purpose:
removing speculative block preallocations from inactive files.  We don't
need to burn two radix tree tags on this, so combine them into one.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |  104 +++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_icache.h |    4 +-
 fs/xfs/xfs_trace.h  |    6 +--
 3 files changed, 54 insertions(+), 60 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 83f2db32bc04..294143608813 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -966,7 +966,7 @@ xfs_queue_eofblocks(
 	struct xfs_mount *mp)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
 		queue_delayed_work(mp->m_eofblocks_workqueue,
 				   &mp->m_eofblocks_work,
 				   msecs_to_jiffies(xfs_eofb_secs * 1000));
@@ -1008,7 +1008,7 @@ xfs_queue_cowblocks(
 	struct xfs_mount *mp)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_COWBLOCKS_TAG))
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
 		queue_delayed_work(mp->m_eofblocks_workqueue,
 				   &mp->m_cowblocks_work,
 				   msecs_to_jiffies(xfs_cowb_secs * 1000));
@@ -1505,6 +1505,9 @@ xfs_inode_free_eofblocks(
 
 	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));
 
+	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
+		return 0;
+
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
 		trace_xfs_inode_free_eofblocks_invalid(ip);
@@ -1543,7 +1546,7 @@ xfs_icache_free_eofblocks(
 	struct xfs_eofblocks	*eofb)
 {
 	return xfs_ici_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
-			XFS_ICI_EOFBLOCKS_TAG);
+			XFS_ICI_BLOCK_GC_TAG);
 }
 
 /*
@@ -1622,61 +1625,48 @@ xfs_inode_free_blocks(
 	return xfs_blockgc_scan(mp, &eofb);
 }
 
-static inline unsigned long
-xfs_iflag_for_tag(
-	int		tag)
-{
-	switch (tag) {
-	case XFS_ICI_EOFBLOCKS_TAG:
-		return XFS_IEOFBLOCKS;
-	case XFS_ICI_COWBLOCKS_TAG:
-		return XFS_ICOWBLOCKS;
-	default:
-		ASSERT(0);
-		return 0;
-	}
-}
-
 static void
 __xfs_inode_set_blocks_tag(
-	xfs_inode_t	*ip,
-	void		(*execute)(struct xfs_mount *mp),
-	void		(*set_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
-				  int error, unsigned long caller_ip),
-	int		tag)
+	struct xfs_inode	*ip,
+	void			(*execute)(struct xfs_mount *mp),
+	unsigned long		iflag)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	struct xfs_perag *pag;
-	int tagged;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	int			tagged;
+
+	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
 	/*
 	 * Don't bother locking the AG and looking up in the radix trees
 	 * if we already know that we have the tag set.
 	 */
-	if (ip->i_flags & xfs_iflag_for_tag(tag))
+	if (ip->i_flags & iflag)
 		return;
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags |= xfs_iflag_for_tag(tag);
+	ip->i_flags |= iflag;
 	spin_unlock(&ip->i_flags_lock);
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	tagged = radix_tree_tagged(&pag->pag_ici_root, tag);
+	tagged = radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCK_GC_TAG);
 	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_BLOCK_GC_TAG);
 	if (!tagged) {
-		/* propagate the eofblocks tag up into the perag radix tree */
+		/* propagate the blockgc tag up into the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
 				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				   tag);
+				   XFS_ICI_BLOCK_GC_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
 		execute(ip->i_mount);
 
-		set_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
+		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
+				_RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1689,37 +1679,43 @@ xfs_inode_set_eofblocks_tag(
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
 	return __xfs_inode_set_blocks_tag(ip, xfs_queue_eofblocks,
-			trace_xfs_perag_set_eofblocks,
-			XFS_ICI_EOFBLOCKS_TAG);
+			XFS_IEOFBLOCKS);
 }
 
 static void
 __xfs_inode_clear_blocks_tag(
-	xfs_inode_t	*ip,
-	void		(*clear_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
-				    int error, unsigned long caller_ip),
-	int		tag)
+	struct xfs_inode	*ip,
+	unsigned long		iflag)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	struct xfs_perag *pag;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	bool			clear_tag;
+
+	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~xfs_iflag_for_tag(tag);
+	ip->i_flags &= ~iflag;
+	clear_tag = (ip->i_flags & (XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	if (!clear_tag)
+		return;
+
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
 	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
-	if (!radix_tree_tagged(&pag->pag_ici_root, tag)) {
-		/* clear the eofblocks tag from the perag radix tree */
+			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			     XFS_ICI_BLOCK_GC_TAG);
+	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCK_GC_TAG)) {
+		/* clear the blockgc tag from the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
 				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				     tag);
+				     XFS_ICI_BLOCK_GC_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
-		clear_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
+		trace_xfs_perag_clear_blockgc(ip->i_mount, pag->pag_agno, -1,
+				_RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1731,8 +1727,7 @@ xfs_inode_clear_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_eofblocks_tag(ip);
-	return __xfs_inode_clear_blocks_tag(ip,
-			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
+	return __xfs_inode_clear_blocks_tag(ip, XFS_IEOFBLOCKS);
 }
 
 /*
@@ -1790,6 +1785,9 @@ xfs_inode_free_cowblocks(
 
 	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));
 
+	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
+		return 0;
+
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
@@ -1831,7 +1829,7 @@ xfs_icache_free_cowblocks(
 	struct xfs_eofblocks	*eofb)
 {
 	return xfs_ici_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
-			XFS_ICI_COWBLOCKS_TAG);
+			XFS_ICI_BLOCK_GC_TAG);
 }
 
 void
@@ -1840,8 +1838,7 @@ xfs_inode_set_cowblocks_tag(
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
 	return __xfs_inode_set_blocks_tag(ip, xfs_queue_cowblocks,
-			trace_xfs_perag_set_cowblocks,
-			XFS_ICI_COWBLOCKS_TAG);
+			XFS_ICOWBLOCKS);
 }
 
 void
@@ -1849,8 +1846,7 @@ xfs_inode_clear_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_cowblocks_tag(ip);
-	return __xfs_inode_clear_blocks_tag(ip,
-			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
+	return __xfs_inode_clear_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
 
 /* Disable post-EOF and CoW block auto-reclamation. */
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 979e3e669be3..3bf3862e6a32 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -26,8 +26,8 @@ struct xfs_eofblocks {
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
 					   in xfs_inode_ag_iterator */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
-#define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
-#define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
+/* Inode has speculative preallocations (posteof or cow) to clean. */
+#define XFS_ICI_BLOCK_GC_TAG	1
 
 /*
  * Flags for xfs_iget()
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index df912c9a148d..cee45e6cdb39 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -131,10 +131,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_cowblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_cowblocks);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_blockgc);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_blockgc);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

