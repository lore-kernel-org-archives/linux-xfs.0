Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPYBk227393 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:34 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B333A1057B5B
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:34 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id Pg7sweBIEQ8XmVrV for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:34 -0700 (PDT)
Message-Id: <20100422190908.397864177@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:42 -0700
From: Greg KH <gregkh@suse.de>
Subject: [011/197] xfs: I/O completion handlers must use NOFS allocations
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@infradead.org>

commit 80641dc66a2d6dfb22af4413227a92b8ab84c7bb upstream

When completing I/O requests we must not allow the memory allocator to
recurse into the filesystem, as we might deadlock on waiting for the
I/O completion otherwise.  The only thing currently allocating normal
GFP_KERNEL memory is the allocation of the transaction structure for
the unwritten extent conversion.  Add a memflags argument to
_xfs_trans_alloc to allow controlling the allocator behaviour.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Thomas Neumann <tneumann@users.sourceforge.net>
Tested-by: Thomas Neumann <tneumann@users.sourceforge.net>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_fsops.c |    2 +-
 fs/xfs/xfs_iomap.c |    9 ++++++++-
 fs/xfs/xfs_mount.c |    2 +-
 fs/xfs/xfs_trans.c |    7 ++++---
 fs/xfs/xfs_trans.h |    2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -611,7 +611,7 @@ xfs_fs_log_dummy(
 	xfs_inode_t	*ip;
 	int		error;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -860,8 +860,15 @@ xfs_iomap_write_unwritten(
 		 * set up a transaction to convert the range of extents
 		 * from unwritten to real. Do allocations in a loop until
 		 * we have covered the range passed in.
+		 *
+		 * Note that we open code the transaction allocation here
+		 * to pass KM_NOFS--we can't risk to recursing back into
+		 * the filesystem here as we might be asked to write out
+		 * the same inode that we complete here and might deadlock
+		 * on the iolock.
 		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
+		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
 		tp->t_flags |= XFS_TRANS_RESERVE;
 		error = xfs_trans_reserve(tp, resblks,
 				XFS_WRITE_LOG_RES(mp), 0,
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1471,7 +1471,7 @@ xfs_log_sbcount(
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return 0;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -236,19 +236,20 @@ xfs_trans_alloc(
 	uint		type)
 {
 	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-	return _xfs_trans_alloc(mp, type);
+	return _xfs_trans_alloc(mp, type, KM_SLEEP);
 }
 
 xfs_trans_t *
 _xfs_trans_alloc(
 	xfs_mount_t	*mp,
-	uint		type)
+	uint		type,
+	uint		memflags)
 {
 	xfs_trans_t	*tp;
 
 	atomic_inc(&mp->m_active_trans);
 
-	tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
+	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
 	tp->t_magic = XFS_TRANS_MAGIC;
 	tp->t_type = type;
 	tp->t_mountp = mp;
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -924,7 +924,7 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces.
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
