Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55E0T136126 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:14 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WeoYEfBOR5Bwu4U8 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:59 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbp-0003KA-Dn
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003jH-BG
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 095/102] xfs: make largest supported offset less shouty
Date: Thu, 23 Aug 2012 15:02:53 +1000
Message-Id: <1345698180-13612-96-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 32972383ca46223aa2b129826b3789721ec147aa

XFS_MAXIOFFSET() is just a simple macro that resolves to
mp->m_maxioffset. It doesn't need to exist, and it just makes the
code unnecessarily loud and shouty.

Make it quiet and easy to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    2 +-
 fs/xfs/quota/xfs_qm.c       |    2 +-
 fs/xfs/xfs_bmap.c           |    2 +-
 fs/xfs/xfs_inode.c          |   10 ++++------
 fs/xfs/xfs_iomap.c          |    2 +-
 fs/xfs/xfs_mount.h          |    2 --
 fs/xfs/xfs_vnodeops.c       |   10 +++++-----
 7 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 642554b8..28e3eed 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -269,7 +269,7 @@ xfs_file_aio_read(
 		}
 	}
 
-	n = XFS_MAXIOFFSET(mp) - iocb->ki_pos;
+	n = mp->m_super->s_maxbytes - iocb->ki_pos;
 	if (n <= 0 || size == 0)
 		return 0;
 
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index fd8ddac..3873d0e 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1381,7 +1381,7 @@ xfs_qm_dqiterate(
 	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), KM_SLEEP);
 
 	lblkno = 0;
-	maxlblkcnt = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	do {
 		nmaps = XFS_DQITER_MAP_SIZE;
 		/*
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 2b4e8d2..d2e5219 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5437,7 +5437,7 @@ xfs_getbmap(
 		if (xfs_get_extsz_hint(ip) ||
 		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
 			prealloced = 1;
-			fixlen = XFS_MAXIOFFSET(mp);
+			fixlen = mp->m_super->s_maxbytes;
 		} else {
 			prealloced = 0;
 			fixlen = XFS_ISIZE(ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4b278d6..591fca1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1202,9 +1202,7 @@ xfs_isize_check(
 	 * an error.
 	 */
 	if (xfs_bmapi(NULL, ip, map_first,
-			 (XFS_B_TO_FSB(mp,
-				       (xfs_ufsize_t)XFS_MAXIOFFSET(mp)) -
-			  map_first),
+			 (XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes) - map_first),
 			 XFS_BMAPI_ENTIRE, NULL, 0, imaps, &nimaps,
 			 NULL))
 	    return;
@@ -1259,11 +1257,11 @@ xfs_file_last_byte(
 
 	last_byte = XFS_FSB_TO_B(mp, last_block);
 	if (last_byte < 0) {
-		return XFS_MAXIOFFSET(mp);
+		return mp->m_super->s_maxbytes;
 	}
 	last_byte += (1 << mp->m_writeio_log);
 	if (last_byte < 0) {
-		return XFS_MAXIOFFSET(mp);
+		return mp->m_super->s_maxbytes;
 	}
 	return last_byte;
 }
@@ -1535,7 +1533,7 @@ xfs_itruncate_finish(
 	 * beyond the maximum file size (ie it is the same as last_block),
 	 * then there is nothing to do.
 	 */
-	last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	ASSERT(first_unmap_block <= last_block);
 	done = 0;
 	if (last_block == first_unmap_block) {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1a7b2e7..388e744 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -290,7 +290,7 @@ xfs_iomap_eof_want_preallocate(
 	 * do any speculative allocation.
 	 */
 	start_fsb = XFS_B_TO_FSBT(mp, ((xfs_ufsize_t)(offset + count - 1)));
-	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	count_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	while (count_fsb > 0) {
 		imaps = nimaps;
 		firstblock = NULLFSBLOCK;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a666de7..cbc8fe9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -298,8 +298,6 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 			PAGE_CACHE_SIZE));
 }
 
-#define XFS_MAXIOFFSET(mp)	((mp)->m_super->s_maxbytes)
-
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
 				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 6ade3c6..e6135e9 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -601,7 +601,7 @@ xfs_free_eofblocks(
 	 * of the file.  If not, then there is nothing to do.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	last_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
+	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return 0;
 	map_len = last_fsb - end_fsb;
@@ -2739,10 +2739,10 @@ xfs_change_file_space(
 
 	llen = bf->l_len > 0 ? bf->l_len - 1 : bf->l_len;
 
-	if (   (bf->l_start < 0)
-	    || (bf->l_start > XFS_MAXIOFFSET(mp))
-	    || (bf->l_start + llen < 0)
-	    || (bf->l_start + llen > XFS_MAXIOFFSET(mp)))
+	if (bf->l_start < 0 ||
+	    bf->l_start > mp->m_super->s_maxbytes ||
+	    bf->l_start + llen < 0 ||
+	    bf->l_start + llen > mp->m_super->s_maxbytes)
 		return XFS_ERROR(EINVAL);
 
 	bf->l_whence = 0;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
