Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5CCDD7F95
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 396E2304053
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MsXBOyr716rs6sCH for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 17/19] xfs: remove unused xfs_mount arg from
	xfs_symlink_hdr_ok()
Date: Mon,  7 Apr 2014 14:59:04 -0500
Message-Id: <1396900746-22201-18-git-send-email-sandeen@redhat.com>
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
 fs/xfs/xfs_shared.h         |    2 +-
 fs/xfs/xfs_symlink.c        |    2 +-
 fs/xfs/xfs_symlink_remote.c |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_shared.h b/fs/xfs/xfs_shared.h
index 18dca8c..46d0e7b 100644
--- a/fs/xfs/xfs_shared.h
+++ b/fs/xfs/xfs_shared.h
@@ -236,7 +236,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
 int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
-bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 14e58f2..3d1c3bb 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -88,7 +88,7 @@ xfs_readlink_bmap(
 
 		cur_chunk = bp->b_addr;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			if (!xfs_symlink_hdr_ok(mp, ip->i_ino, offset,
+			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
 							byte_cnt, bp)) {
 				error = EFSCORRUPTED;
 				xfs_alert(mp,
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index 8e3045e..4d873d3 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -80,7 +80,6 @@ xfs_symlink_hdr_set(
  */
 bool
 xfs_symlink_hdr_ok(
-	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	uint32_t		offset,
 	uint32_t		size,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
