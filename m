Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1NGqx6m130241 for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 10:52:59 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id 5iVBzqaCR2nWGnBn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Feb 2012 08:52:58 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S0bub-0006S7-Ms
	for xfs@oss.sgi.com; Thu, 23 Feb 2012 08:52:57 -0800
Message-ID: <33379323.post@talk.nabble.com>
Date: Thu, 23 Feb 2012 08:52:57 -0800 (PST)
From: Kamal Dasu <kdasu.kdev@gmail.com>
Subject: [PATCH 4/4] V2 xfs: fix deadlock in xfs_rtfree_extent with kernel
	v2.6.37
In-Reply-To: <33365485.post@talk.nabble.com>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com> <33346043.post@talk.nabble.com>
	<33346051.post@talk.nabble.com>
	<20120219224118.GA31535@infradead.org>
	<33365485.post@talk.nabble.com>
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


To fix the deadlock caused by recursively calling xfs_rtfree_extent
from xfs_bunmapi():

 - removed  xfs_trans_iget() from xfs_rtfree_extent(),
   instead added asserts that the inode is locked and has an inode_item
   attached to it.
 - in xfs_bunmapi() when dealing with an inode with the rt flag
   call xfs_ilock() and xfs_trans_ijoin() so that the
   reference count is bumped on the inode and attached it to the
   transaction before calling into xfs_bmap_del_extent, similar to
   what we do in xfs_bmap_rtalloc.

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_bmap.c    |   10 ++++++++++
 fs/xfs/xfs_rtalloc.c |   13 ++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 36c317c..103a253 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5058,6 +5058,16 @@ xfs_bunmapi(
                cur->bc_private.b.flags = 0;
        } else
                cur = NULL;
+
+       if (isrt) {
+               /*
+                * Synchronize by locking the bitmap inode.
+                */
+               xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+               xfs_trans_ijoin_ref(tp, mp->m_rbmip,
+                                   XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+       }
+
        extno = 0;
        while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
               (nexts == 0 || extno < nexts)) {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f592ac9..d0a48d4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2160,13 +2160,12 @@ xfs_rtfree_extent(
        xfs_buf_t       *sumbp;         /* summary file block buffer */
 
        mp = tp->t_mountp;
-       /*
-        * Synchronize by locking the bitmap inode.
-        */
-       error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-                              XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
-       if (error)
-               return error;
+
+       ASSERT(mp->m_rbmip->i_itemp != NULL);
+       ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+
+       ip = mp->m_rbmip;
+
 #if defined(__KERNEL__) && defined(DEBUG)
        /*
         * Check to see that this whole range is currently allocated.
-- 
1.7.5.4

-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--RFC-xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33379323.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
