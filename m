Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6EkwuV065723 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:46:58 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HO95LNVTdgR9s2ya for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 06:48:54 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA6Ems7H025643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qA6Emssf002585
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 04/10] xfs: make xfs_free_eofblocks() non-static,
	return EAGAIN on trylock failure
Date: Tue,  6 Nov 2012 09:50:41 -0500
Message-Id: <1352213447-59791-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely<tinguely@sgi.com>
---
 fs/xfs/xfs_vnodeops.c |    6 +++---
 fs/xfs/xfs_vnodeops.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index c4c1539..c2ddd7a 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -151,7 +151,7 @@ xfs_readlink(
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
  */
-STATIC int
+int
 xfs_free_eofblocks(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
@@ -200,7 +200,7 @@ xfs_free_eofblocks(
 		if (need_iolock) {
 			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 				xfs_trans_cancel(tp, 0);
-				return 0;
+				return EAGAIN;
 			}
 		}
 
@@ -463,7 +463,7 @@ xfs_release(
 			return 0;
 
 		error = xfs_free_eofblocks(mp, ip, true);
-		if (error)
+		if (error && error != EAGAIN)
 			return error;
 
 		/* delalloc blocks after truncation means it really is dirty */
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 447e146..52fafc4 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -57,5 +57,6 @@ int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
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
