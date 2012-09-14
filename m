Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ECIIBF092218 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 07:18:18 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K1Dmg2XggIN6U3KJ for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 05:19:25 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ECJPpp006865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8ECJPVh022223
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 4/8] xfs: export xfs_free_eofblocks() and return EAGAIN on
	trylock failure
Date: Fri, 14 Sep 2012 08:19:51 -0400
Message-Id: <1347625195-6369-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
References: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Turn xfs_free_eofblocks() into a non-static function, return EAGAIN to
indicate trylock failure and make sure this error is not propagated in
xfs_release().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_vnodeops.c |    6 +++---
 fs/xfs/xfs_vnodeops.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 12f5087..a61e852 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -150,7 +150,7 @@ xfs_readlink(
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
  */
-STATIC int
+int
 xfs_free_eofblocks(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
@@ -199,7 +199,7 @@ xfs_free_eofblocks(
 		if (need_iolock) {
 			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 				xfs_trans_cancel(tp, 0);
-				return 0;
+				return EAGAIN;
 			}
 		}
 
@@ -462,7 +462,7 @@ xfs_release(
 			return 0;
 
 		error = xfs_free_eofblocks(mp, ip, true);
-		if (error)
+		if (error && error != EAGAIN)
 			return error;
 
 		/* delalloc blocks after truncation means it really is dirty */
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index d5701e3..1e03c4b 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -95,5 +95,6 @@ int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
 int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
 
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
+int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
 
 #endif /* _XFS_VNODEOPS_H */
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
