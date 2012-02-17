Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HMwCxx115367 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:58:12 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id FTvICSYDzG77NgMM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 14:58:11 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RyWkk-000244-R3
	for xfs@oss.sgi.com; Fri, 17 Feb 2012 14:58:10 -0800
Message-ID: <33346043.post@talk.nabble.com>
Date: Fri, 17 Feb 2012 14:58:10 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: [PATCH 3/4] xfs: add lockdep annotations for the rt inodes
In-Reply-To: <33346035.post@talk.nabble.com>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com>
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


The rt bitmap and summary inodes do not participate in the normal inode
locking protocol.  Instead the rt bitmap inode can be locked in any
transaction involving rt allocations, and the both of the rt inodes can
be locked at the same time.  Add specific lockdep subclasses for the rt
inodes to prevent lockdep from blowing up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_bmap.c    |    2 +-
 fs/xfs/xfs_inode.h   |   23 +++++++++++++++--------
 fs/xfs/xfs_rtalloc.c |   16 ++++++++++------
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 9d9970b..36c317c 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2354,7 +2354,7 @@ xfs_bmap_rtalloc(
         * Lock out other modifications to the RT bitmap inode.
         */
        error = xfs_trans_iget(mp, ap->tp, mp->m_sb.sb_rbmino, 0,
-                              XFS_ILOCK_EXCL, &ip);
+                              XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
        if (error)
                return error;
        ASSERT(ip == mp->m_rbmip);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fb2ca2e..a9e82d4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -408,28 +408,35 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 /*
  * Flags for lockdep annotations.
  *
- * XFS_I[O]LOCK_PARENT - for operations that require locking two inodes
- * (ie directory operations that require locking a directory inode and
- * an entry inode).  The first inode gets locked with this flag so it
- * gets a lockdep subclass of 1 and the second lock will have a lockdep
- * subclass of 0.
+ * XFS_LOCK_PARENT - for directory operations that require locking a
+ * parent directory inode and a child entry inode.  The parent gets locked
+ * with this flag so it gets a lockdep subclass of 1 and the child entry
+ * lock will have a lockdep subclass of 0.
+ *
+ * XFS_LOCK_RTBITMAP/XFS_LOCK_RTSUM - the realtime device bitmap and
summary
+ * inodes do not participate in the normal lock order, and thus have their
+ * own subclasses.
  *
  * XFS_LOCK_INUMORDER - for locking several inodes at the some time
  * with xfs_lock_inodes().  This flag is used as the starting subclass
  * and each subsequent lock acquired will increment the subclass by one.
- * So the first lock acquired will have a lockdep subclass of 2, the
- * second lock will have a lockdep subclass of 3, and so on. It is
+ * So the first lock acquired will have a lockdep subclass of 4, the
+ * second lock will have a lockdep subclass of 5, and so on. It is
  * the responsibility of the class builder to shift this to the correct
  * portion of the lock_mode lockdep mask.
  */
 #define XFS_LOCK_PARENT                1
-#define XFS_LOCK_INUMORDER     2
+#define XFS_LOCK_RTBITMAP      2
+#define XFS_LOCK_RTSUM         3
+#define XFS_LOCK_INUMORDER     4
 
 #define XFS_IOLOCK_SHIFT       16
 #define        XFS_IOLOCK_PARENT       (XFS_LOCK_PARENT <<
XFS_IOLOCK_SHIFT)
 
 #define XFS_ILOCK_SHIFT                24
 #define        XFS_ILOCK_PARENT        (XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
+#define        XFS_ILOCK_RTBITMAP      (XFS_LOCK_RTBITMAP <<
XFS_ILOCK_SHIFT)
+#define        XFS_ILOCK_RTSUM         (XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
 
 #define XFS_IOLOCK_DEP_MASK    0x00ff0000
 #define XFS_ILOCK_DEP_MASK     0xff000000
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 037fab1..f592ac9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1972,8 +1972,10 @@ xfs_growfs_rt(
                /*
                 * Lock out other callers by grabbing the bitmap inode lock.
                 */
-               if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-                                               XFS_ILOCK_EXCL, &ip)))
+               error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
+                                      XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP,
+                                      &ip);
+               if (error)
                        goto error_cancel;
                ASSERT(ip == mp->m_rbmip);
                /*
@@ -1986,8 +1988,9 @@ xfs_growfs_rt(
                /*
                 * Get the summary inode into the transaction.
                 */
-               if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0,
-                                               XFS_ILOCK_EXCL, &ip)))
+               error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0,
+                                      XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM,
&ip);
+               if (error)
                        goto error_cancel;
                ASSERT(ip == mp->m_rsumip);
                /*
@@ -2160,8 +2163,9 @@ xfs_rtfree_extent(
        /*
         * Synchronize by locking the bitmap inode.
         */
-       if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-                                       XFS_ILOCK_EXCL, &ip)))
+       error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
+                              XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
+       if (error)
                return error;
 #if defined(__KERNEL__) && defined(DEBUG)
        /*
-- 
1.7.5.4


-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33346043.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
