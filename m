Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HN0AbO115484 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 17:00:10 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id YUhi9TB7bIitzIFL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 15:00:09 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RyWmf-0002F6-1g
	for xfs@oss.sgi.com; Fri, 17 Feb 2012 15:00:09 -0800
Message-ID: <33346051.post@talk.nabble.com>
Date: Fri, 17 Feb 2012 15:00:09 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: [PATCH 4/4] xfs: fix deadlock in xfs_rtfree_extent with kernel v2.6.37
In-Reply-To: <33346043.post@talk.nabble.com>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com> <33346043.post@talk.nabble.com>
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



On the 2.6.37 kernel, xfs_fs_evict_inode() leads to a deadlock when
freeing multiple realtime extents. On further debugging the root
cause it was determined to be recursive locking of the RT bitmap
inode during evict operation within the same task context.
The same vfs evict sequence is replayed by the xfs log recovery on
mounts on a reboot after the problem happens first time.
This problem exists on kernel v2.6.39 as well.

Call stack:
xfs_ilock   <- simple task deadlock in the xfs_ilock(ip,  XFS_ILOCK_EXCL)
               re-acquired on second iteration when the inode is cached
xfs_iget_cache_hit
xfs_iget
xfs_trans_iget
xfs_rtfree_extent <- Call to xfs_trans_iget()
xfs_bmap_del_extent
xfs_bunmapi  <- while loop based on number of extents to free
xfs_itruncate_finish
xfs_inactive
evict

The deadlock fix has two parts :
1) check if the inode is already locked in xfs_iget.c in the
   xfs_iget_cache_hit() function. Do not acquire the inode lock again
   if ip is already locked with the  XFS_ILOCK_EXCL subclass.
   We use the active transaction structure to detect if the inode is
   already lokced.
2) In addition in xfs_trans_inode.c:xfs_trans_iget() prevent joining
   already active transaction.

The above changes are also needed along with the backport of following
2.6.39 kernel patches to 2.6.37 kernel:

xfs: only lock the rt bitmap inode once per allocation
xfs: fix xfs_get_extsz_hint for a zero extent size hint
xfs: add lockdep annotations for the rt inodes

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_iget.c        |   12 +++++++++++-
 fs/xfs/xfs_trans_inode.c |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 0cdd269..f05bdc2 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -143,6 +143,7 @@ xfs_inode_free(
 static int
 xfs_iget_cache_hit(
        struct xfs_perag        *pag,
+       xfs_trans_t             *tp,
        struct xfs_inode        *ip,
        int                     flags,
        int                     lock_flags) __releases(pag->pag_ici_lock)
@@ -234,6 +235,15 @@ xfs_iget_cache_hit(
                trace_xfs_iget_hit(ip);
        }
 
+       /* check inode already locked  */
+       spin_lock(&ip->i_flags_lock);
+       if (tp &&  ip->i_transp == tp) {
+               if ((ip->i_itemp->ili_lock_flags & lock_flags) &
+                       (XFS_ILOCK_EXCL))
+                       lock_flags = 0;
+       }
+       spin_unlock(&ip->i_flags_lock);
+
        if (lock_flags != 0)
                xfs_ilock(ip, lock_flags);
 
@@ -379,7 +389,7 @@ again:
        ip = radix_tree_lookup(&pag->pag_ici_root, agino);
 
        if (ip) {
-               error = xfs_iget_cache_hit(pag, ip, flags, lock_flags);
+               error = xfs_iget_cache_hit(pag, tp, ip, flags, lock_flags);
                if (error)
                        goto out_error_or_again;
        } else {
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index ccb3453..6f8db93 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -58,7 +58,7 @@ xfs_trans_iget(
        int                     error;
 
        error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp);
-       if (!error && tp) {
+       if (!error && tp && !((*ipp)->i_transp)) {
                xfs_trans_ijoin(tp, *ipp);
                (*ipp)->i_itemp->ili_lock_flags = lock_flags;
        }
-- 
1.7.5.4

-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33346051.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
