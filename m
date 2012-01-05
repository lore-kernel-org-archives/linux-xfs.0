Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q05MlC4G225136 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 16:47:12 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2ZOUSFyMePSjMhX3 for <xfs@oss.sgi.com>;
	Thu, 05 Jan 2012 14:47:10 -0800 (PST)
Message-Id: <20120105224402.805767225@clark.kroah.org>
Date: Thu, 05 Jan 2012 14:44:53 -0800
From: Greg KH <gregkh@suse.de>
Subject: [68/73] xfs: log all dirty inodes in xfs_fs_sync_fs
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
Content-Length: 3536
Lines: 104


From: Christoph Hellwig <hch@infradead.org>

Commit be4f1ac828776bbc7868a68b465cd8eedb733cfd upstream.

Since Linux 2.6.36 the writeback code has introduces various measures for
live lock prevention during sync().  Unfortunately some of these are
actively harmful for the XFS model, where the inode gets marked dirty for
metadata from the data I/O handler.

The older_than_this checks that are now more strictly enforced since

    writeback: avoid livelocking WB_SYNC_ALL writeback

by only calling into __writeback_inodes_sb and thus only sampling the
current cut off time once.  But on a slow enough devices the previous
asynchronous sync pass might not have fully completed yet, and thus XFS
might mark metadata dirty only after that sampling of the cut off time for
the blocking pass already happened.  I have not myself reproduced this
myself on a real system, but by introducing artificial delay into the
XFS I/O completion workqueues it can be reproduced easily.

Fix this by iterating over all XFS inodes in ->sync_fs and log all that
are dirty.  This might log inode that only got redirtied after the
previous pass, but given how cheap delayed logging of inodes is it
isn't a major concern for performance.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_sync.h |    2 ++
 2 files changed, 39 insertions(+)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -336,6 +336,32 @@ xfs_sync_fsdata(
 	return xfs_bwrite(mp, bp);
 }
 
+int
+xfs_log_dirty_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (!ip->i_update_core)
+		return 0;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp, 0);
+}
+
 /*
  * When remounting a filesystem read-only or freezing the filesystem, we have
  * two phases to execute. This first phase is syncing the data before we
@@ -365,6 +391,17 @@ xfs_quiesce_data(
 
 	/* push and block till complete */
 	xfs_sync_data(mp, SYNC_WAIT);
+
+	/*
+	 * Log all pending size and timestamp updates.  The vfs writeback
+	 * code is supposed to do this, but due to its overagressive
+	 * livelock detection it will skip inodes where appending writes
+	 * were written out in the first non-blocking sync phase if their
+	 * completion took long enough that it happened after taking the
+	 * timestamp for the cut-off in the blocking phase.
+	 */
+	xfs_inode_ag_iterator(mp, xfs_log_dirty_inode, 0);
+
 	xfs_qm_sync(mp, SYNC_WAIT);
 
 	/* write superblock and hoover up shutdown errors */
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -42,6 +42,8 @@ void xfs_quiesce_attr(struct xfs_mount *
 
 void xfs_flush_inodes(struct xfs_inode *ip);
 
+int xfs_log_dirty_inode(struct xfs_inode *ip, struct xfs_perag *pag, int flags);
+
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
