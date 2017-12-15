Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755650AbdLORLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 12:11:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBFH7rsj168194
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:21 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2evje0r1dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBKEi023536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:21 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBFHBKnA016737
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:20 GMT
Subject: [PATCH 1/4] xfs: track cowblocks separately in i_flags
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 15 Dec 2017 09:11:19 -0800
Message-ID: <151335787965.26575.17711793213679430025.stgit@magnolia>
In-Reply-To: <151335786780.26575.15542999972223359181.stgit@magnolia>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The EOFBLOCKS/COWBLOCKS tags are totally separate things, so track them
with separate i_flags.  Right now we're abusing IEOFBLOCKS for both,
which is totally bogus because we won't tag the inode with COWBLOCKS if
IEOFBLOCKS was set by a previous tagging of the inode with EOFBLOCKS.
Found by wiring up clonerange to fsstress in xfs/017.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   33 ++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.h  |    1 +
 2 files changed, 25 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 43005fb..58d2d42 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1536,8 +1536,23 @@ xfs_inode_free_quota_eofblocks(
 	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
 }
 
+static inline unsigned long
+xfs_iflag_for_tag(
+	int		tag)
+{
+	switch (tag) {
+	case XFS_ICI_EOFBLOCKS_TAG:
+		return XFS_IEOFBLOCKS;
+	case XFS_ICI_COWBLOCKS_TAG:
+		return XFS_ICOWBLOCKS;
+	default:
+		ASSERT(0);
+		return 0;
+	}
+}
+
 static void
-__xfs_inode_set_eofblocks_tag(
+__xfs_inode_set_blocks_tag(
 	xfs_inode_t	*ip,
 	void		(*execute)(struct xfs_mount *mp),
 	void		(*set_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1552,10 +1567,10 @@ __xfs_inode_set_eofblocks_tag(
 	 * Don't bother locking the AG and looking up in the radix trees
 	 * if we already know that we have the tag set.
 	 */
-	if (ip->i_flags & XFS_IEOFBLOCKS)
+	if (ip->i_flags & xfs_iflag_for_tag(tag))
 		return;
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags |= XFS_IEOFBLOCKS;
+	ip->i_flags |= xfs_iflag_for_tag(tag);
 	spin_unlock(&ip->i_flags_lock);
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
@@ -1587,13 +1602,13 @@ xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
-	return __xfs_inode_set_eofblocks_tag(ip, xfs_queue_eofblocks,
+	return __xfs_inode_set_blocks_tag(ip, xfs_queue_eofblocks,
 			trace_xfs_perag_set_eofblocks,
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
 static void
-__xfs_inode_clear_eofblocks_tag(
+__xfs_inode_clear_blocks_tag(
 	xfs_inode_t	*ip,
 	void		(*clear_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
 				    int error, unsigned long caller_ip),
@@ -1603,7 +1618,7 @@ __xfs_inode_clear_eofblocks_tag(
 	struct xfs_perag *pag;
 
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~XFS_IEOFBLOCKS;
+	ip->i_flags &= ~xfs_iflag_for_tag(tag);
 	spin_unlock(&ip->i_flags_lock);
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
@@ -1630,7 +1645,7 @@ xfs_inode_clear_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_eofblocks_tag(ip);
-	return __xfs_inode_clear_eofblocks_tag(ip,
+	return __xfs_inode_clear_blocks_tag(ip,
 			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
 }
 
@@ -1724,7 +1739,7 @@ xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
-	return __xfs_inode_set_eofblocks_tag(ip, xfs_queue_cowblocks,
+	return __xfs_inode_set_blocks_tag(ip, xfs_queue_cowblocks,
 			trace_xfs_perag_set_cowblocks,
 			XFS_ICI_COWBLOCKS_TAG);
 }
@@ -1734,6 +1749,6 @@ xfs_inode_clear_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_cowblocks_tag(ip);
-	return __xfs_inode_clear_eofblocks_tag(ip,
+	return __xfs_inode_clear_blocks_tag(ip,
 			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b2136af..d383e39 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -232,6 +232,7 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
  * log recovery to replay a bmap operation on the inode.
  */
 #define XFS_IRECOVERY		(1 << 11)
+#define XFS_ICOWBLOCKS		(1 << 12)/* has the cowblocks tag set */
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during

