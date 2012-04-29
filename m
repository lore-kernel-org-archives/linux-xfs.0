Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TCvX65122421 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 07:57:33 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tAkOaVGgaoVkUZtH for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 05:57:31 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1SOTgv-0000au-Gs
	for xfs@oss.sgi.com; Sun, 29 Apr 2012 22:57:29 +1000
Date: Sun, 29 Apr 2012 22:57:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/3] xfs: make largest supported offset less shouty
Message-ID: <20120429125729.GU9541@dastard>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335519922-14371-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS_MAXIOFFSET() is just a simple macro that resolves to
mp->m_maxioffset. It doesn't need to exist, and it just makes the
code unnecessarily loud and shouty.

Make it quiet and easy to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c     |    2 +-
 fs/xfs/xfs_file.c     |    2 +-
 fs/xfs/xfs_inode.c    |    2 +-
 fs/xfs/xfs_iomap.c    |    2 +-
 fs/xfs/xfs_mount.h    |    2 --
 fs/xfs/xfs_qm.c       |    2 +-
 fs/xfs/xfs_vnodeops.c |   10 +++++-----
 7 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 478bce9..919e038 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5517,7 +5517,7 @@ xfs_getbmap(
 		if (xfs_get_extsz_hint(ip) ||
 		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
 			prealloced = 1;
-			fixlen = XFS_MAXIOFFSET(mp);
+			fixlen = mp->m_maxioffset;
 		} else {
 			prealloced = 0;
 			fixlen = XFS_ISIZE(ip);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a37e43d..2d99208 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -273,7 +273,7 @@ xfs_file_aio_read(
 		}
 	}
 
-	n = XFS_MAXIOFFSET(mp) - iocb->ki_pos;
+	n = mp->m_maxioffset - iocb->ki_pos;
 	if (n <= 0 || size == 0)
 		return 0;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a59eea0..95e0d4a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1226,7 +1226,7 @@ xfs_itruncate_extents(
 	 * then there is nothing to do.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	last_block = XFS_B_TO_FSB(mp, mp->m_maxioffset);
 	if (first_unmap_block == last_block)
 		return 0;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4a08ea3..9172d80 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -285,7 +285,7 @@ xfs_iomap_eof_want_preallocate(
 	 * do any speculative allocation.
 	 */
 	start_fsb = XFS_B_TO_FSBT(mp, ((xfs_ufsize_t)(offset + count - 1)));
-	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	count_fsb = XFS_B_TO_FSB(mp, mp->m_maxioffset);
 	while (count_fsb > 0) {
 		imaps = nimaps;
 		firstblock = NULLFSBLOCK;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 401ca2e..d0c6a0c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -297,8 +297,6 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 			PAGE_CACHE_SIZE));
 }
 
-#define XFS_MAXIOFFSET(mp)	((mp)->m_maxioffset)
-
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
 				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 249db19..58cd3bd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -940,7 +940,7 @@ xfs_qm_dqiterate(
 	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), KM_SLEEP);
 
 	lblkno = 0;
-	maxlblkcnt = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_maxioffset);
 	do {
 		nmaps = XFS_DQITER_MAP_SIZE;
 		/*
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 82b000f..e6580ea 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -174,7 +174,7 @@ xfs_free_eofblocks(
 	 * of the file.  If not, then there is nothing to do.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	last_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	last_fsb = XFS_B_TO_FSB(mp, mp->m_maxioffset);
 	if (last_fsb <= end_fsb)
 		return 0;
 	map_len = last_fsb - end_fsb;
@@ -2262,10 +2262,10 @@ xfs_change_file_space(
 
 	llen = bf->l_len > 0 ? bf->l_len - 1 : bf->l_len;
 
-	if (   (bf->l_start < 0)
-	    || (bf->l_start > XFS_MAXIOFFSET(mp))
-	    || (bf->l_start + llen < 0)
-	    || (bf->l_start + llen > XFS_MAXIOFFSET(mp)))
+	if (bf->l_start < 0 ||
+	    bf->l_start > mp->m_maxioffset ||
+	    bf->l_start + llen < 0 ||
+	    bf->l_start + llen > mp->m_maxioffset)
 		return XFS_ERROR(EINVAL);
 
 	bf->l_whence = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
