Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A643B7FA0
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22361AC019
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CVioAj1A5Do9GpjL for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 16/19] xfs: remove unused tp arg from
	xfs_symlink_local_to_remote()
Date: Mon,  7 Apr 2014 14:59:03 -0500
Message-Id: <1396900746-22201-17-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_bmap.c           |    5 ++---
 fs/xfs/xfs_shared.h         |    2 +-
 fs/xfs/xfs_symlink_remote.c |    1 -
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 03b6ff2..6a1e702 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -919,8 +919,7 @@ xfs_bmap_local_to_extents(
 	xfs_extlen_t	total,		/* total blocks needed by transaction */
 	int		*logflagsp,	/* inode logging flags */
 	int		whichfork,
-	void		(*init_fn)(struct xfs_trans *tp,
-				   struct xfs_buf *bp,
+	void		(*init_fn)(struct xfs_buf *bp,
 				   struct xfs_inode *ip,
 				   struct xfs_ifork *ifp))
 {
@@ -977,7 +976,7 @@ xfs_bmap_local_to_extents(
 	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
 
 	/* initialise the block and copy the data */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(bp, ip, ifp);
 
 	/* account for the change in fork size and log everything */
 	xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
diff --git a/fs/xfs/xfs_shared.h b/fs/xfs/xfs_shared.h
index 8c5035a..18dca8c 100644
--- a/fs/xfs/xfs_shared.h
+++ b/fs/xfs/xfs_shared.h
@@ -238,7 +238,7 @@ int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
-void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+void xfs_symlink_local_to_remote(struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index bf59a2b..8e3045e 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -173,7 +173,6 @@ const struct xfs_buf_ops xfs_symlink_buf_ops = {
 
 void
 xfs_symlink_local_to_remote(
-	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*ip,
 	struct xfs_ifork	*ifp)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
