Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q05Ml9s4225130 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 16:47:10 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id O07pSalAFBLUdaxp for <xfs@oss.sgi.com>;
	Thu, 05 Jan 2012 14:47:07 -0800 (PST)
Message-Id: <20120105224402.717841604@clark.kroah.org>
Date: Thu, 05 Jan 2012 14:44:52 -0800
From: Greg KH <gregkh@suse.de>
Subject: [67/73] xfs: log the inode in ->write_inode calls for kupdate
In-Reply-To: <20120105224632.GA14659@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, Ben Myers <bpm@sgi.com>, alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2680
Lines: 86

From: Christoph Hellwig <hch@infradead.org>

Commit 0b8fd3033c308e4088760aa1d38ce77197b4e074 upstream.

If the writeback code writes back an inode because it has expired we currently
use the non-blockin ->write_inode path.  This means any inode that is pinned
is skipped.  With delayed logging and a workload that has very little log
traffic otherwise it is very likely that an inode that gets constantly
written to is always pinned, and thus we keep refusing to write it.  The VM
writeback code at that point redirties it and doesn't try to write it again
for another 30 seconds.  This means under certain scenarious time based
metadata writeback never happens.

Fix this by calling into xfs_log_inode for kupdate in addition to data
integrity syncs, and thus transfer the inode to the log ASAP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_super.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -871,27 +871,6 @@ xfs_fs_dirty_inode(
 }
 
 STATIC int
-xfs_log_inode(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp, 0);
-}
-
-STATIC int
 xfs_fs_write_inode(
 	struct inode		*inode,
 	struct writeback_control *wbc)
@@ -904,10 +883,8 @@ xfs_fs_write_inode(
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
-	if (!ip->i_update_core)
-		return 0;
 
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->for_kupdate) {
 		/*
 		 * Make sure the inode has made it it into the log.  Instead
 		 * of forcing it all the way to stable storage using a
@@ -916,11 +893,14 @@ xfs_fs_write_inode(
 		 * of synchronous log foces dramatically.
 		 */
 		xfs_ioend_wait(ip);
-		error = xfs_log_inode(ip);
+		error = xfs_log_dirty_inode(ip, NULL, 0);
 		if (error)
 			goto out;
 		return 0;
 	} else {
+		if (!ip->i_update_core)
+			return 0;
+
 		/*
 		 * We make this non-blocking if the inode is contended, return
 		 * EAGAIN to indicate to the caller that they did not succeed.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
