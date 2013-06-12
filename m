Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D75C7FB6
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C0F4304043
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WVFyNJ6Q3cFzXbkG for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:01 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQD-0001Bc-Hx
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006n8-DE
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/22] libxfs: local to remote format support of remote
	symlinks
Date: Wed, 12 Jun 2013 20:36:21 +1000
Message-Id: <1371033394-26006-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

This conversion was overlooked earlier on. Now that the differences
between userspace and kernel space are getting smaller this bug is
obvious. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_symlink.h |    2 ++
 libxfs/xfs_bmap.c     |   12 ------------
 libxfs/xfs_symlink.c  |   29 +++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
index 55f3f2d..e85dfd1 100644
--- a/include/xfs_symlink.h
+++ b/include/xfs_symlink.h
@@ -31,6 +31,8 @@ struct xfs_dsymlink_hdr {
 int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
 bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4e3c792..1c0939b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1221,18 +1221,6 @@ xfs_bmap_add_attrfork_extents(
 	return error;
 }
 
-STATIC void
-xfs_symlink_local_to_remote(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
-{
-	/* remote symlink blocks are not verifiable until CRCs come along */
-	bp->b_ops = NULL;
-	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-}
-
 /*
  * Called from xfs_bmap_add_attrfork to handle local format files. Each
  * different data fork content type needs a different callout to do the
diff --git a/libxfs/xfs_symlink.c b/libxfs/xfs_symlink.c
index 860b123..f2e69f9 100644
--- a/libxfs/xfs_symlink.c
+++ b/libxfs/xfs_symlink.c
@@ -145,3 +145,32 @@ const struct xfs_buf_ops xfs_symlink_buf_ops = {
 	.verify_write = xfs_symlink_write_verify,
 };
 
+void
+xfs_symlink_local_to_remote(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	char			*buf;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		bp->b_ops = NULL;
+		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		return;
+	}
+
+	/*
+	 * As this symlink fits in an inode literal area, it must also fit in
+	 * the smallest buffer the filesystem supports.
+	 */
+	ASSERT(BBTOB(bp->b_length) >=
+			ifp->if_bytes + sizeof(struct xfs_dsymlink_hdr));
+
+	bp->b_ops = &xfs_symlink_buf_ops;
+
+	buf = bp->b_addr;
+	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
+	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
+}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
