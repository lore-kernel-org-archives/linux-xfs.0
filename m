Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 17:48:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V0mIY0031204
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 17:48:20 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5105D14B4C1C
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 17:48:17 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id JQOev68cRe7KBHRe for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 17:48:17 -0700 (PDT)
Date: Fri, 31 Oct 2008 11:48:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031004814.GN4985@disturbed>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031001249.GM4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 11:12:49AM +1100, Dave Chinner wrote:
> On Thu, Oct 30, 2008 at 06:46:25PM -0400, Christoph Hellwig wrote:
> > On Thu, Oct 30, 2008 at 07:50:20PM +1100, Dave Chinner wrote:
> > > Are there any other ways that we can get a custom ->do_sync
> > > method for XFS? I'd prefer a custom method so we don't have to
> > > revalidate every linux filesystem, especially as XFS already has
> > > everything it needs to provide it's own sync method (used for
> > > freezing) and a test suite to validate it is working correctly.....
> > 
> > I think having a method for this would be useful.  And given that
> > a proper sync should be exactly the same as a filesysytem freeze
> > we should maybe use one method for both of those and use the chance
> > to give filesystem better control over the freeze process?
> 
> Right - that's exactly where we should be going with this, I think.
> I'd suggest two callouts, perhaps: ->sync_data and ->sync_metadata.
> The freeze code can then still operate in two stages, and we can
> also use then for separating data and inode writeback in pdflush....
> 
> FWIW, I mentioned doing this sort of thing here:
> 
> http://xfs.org/index.php/Improving_inode_Caching#Avoiding_the_Generic_pdflush_Code
> 
> I think I'll look at redoing do_sync() to provide a custom sync
> method before trying to fix XFS....

As it is, here's the somewhat cleaned up patch that demonstrates
the changes needed to make xfsqa test 182 pass....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS, RFC: demonstration fix of test 182

This patch shows the various changes needed to ensure sync(1)
leave the filesystem in a consistent state. It shows the different
format of do_sync(), the changes to mark the inode dirty before
data I/O and the changes to xfs_fs_write_super() and the
functions it calls to ensure the log gets covered at the
end of the sync.

This is in no way a real fix for the problem, merely a demonstration
of the problem. The real fix is to make the XFS sync code use
the same flush algorithm as freeze, but that first requires VFS
level changes to provide a method for doing so.
---
 fs/sync.c                    |    7 +++----
 fs/xfs/linux-2.6/xfs_aops.c  |   38 ++++++++++++++++++++++++++++----------
 fs/xfs/linux-2.6/xfs_super.c |   29 +++++++++++------------------
 fs/xfs/linux-2.6/xfs_sync.c  |   41 ++++++++++++++++++++++++++---------------
 fs/xfs/linux-2.6/xfs_sync.h  |    2 +-
 5 files changed, 69 insertions(+), 48 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 137b550..69f40b7 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -23,13 +23,12 @@
  */
 static void do_sync(unsigned long wait)
 {
-	wakeup_pdflush(0);
-	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
-	DQUOT_SYNC(NULL);
-	sync_supers();		/* Write the superblocks */
 	sync_filesystems(0);	/* Start syncing the filesystems */
 	sync_filesystems(wait);	/* Waitingly sync the filesystems */
+	DQUOT_SYNC(NULL);
+	sync_supers();		/* Write the superblocks */
 	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
+	sync_supers();		/* Write the superblocks, again */
 	if (!wait)
 		printk("Emergency Sync complete\n");
 	if (unlikely(laptop_mode))
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index f8fa620..cb79a21 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -143,19 +143,37 @@ xfs_destroy_ioend(
 }
 
 /*
+ * If the end of the current ioend is beyond the current EOF,
+ * return the new EOF value, otherwise zero.
+ */
+STATIC xfs_fsize_t
+xfs_ioend_new_eof(
+	xfs_ioend_t		*ioend)
+{
+	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
+	xfs_fsize_t		isize;
+	xfs_fsize_t		bsize;
+
+	bsize = ioend->io_offset + ioend->io_size;
+	isize = MAX(ip->i_size, ip->i_new_size);
+	isize = MIN(isize, bsize);
+	return isize > ip->i_d.di_size ? isize : 0;
+}
+
+/*
  * Update on-disk file size now that data has been written to disk.
  * The current in-memory file size is i_size.  If a write is beyond
  * eof i_new_size will be the intended file size until i_size is
  * updated.  If this write does not extend all the way to the valid
  * file size then restrict this update to the end of the write.
  */
+
 STATIC void
 xfs_setfilesize(
 	xfs_ioend_t		*ioend)
 {
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
-	xfs_fsize_t		bsize;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
 	ASSERT(ioend->io_type != IOMAP_READ);
@@ -163,19 +181,13 @@ xfs_setfilesize(
 	if (unlikely(ioend->io_error))
 		return;
 
-	bsize = ioend->io_offset + ioend->io_size;
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	isize = MAX(ip->i_size, ip->i_new_size);
-	isize = MIN(isize, bsize);
-
-	if (ip->i_d.di_size < isize) {
+	isize = xfs_ioend_new_eof(ioend);
+	if (isize) {
 		ip->i_d.di_size = isize;
 		ip->i_update_size = 1;
 		xfs_mark_inode_dirty_sync(ip);
 	}
-
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 }
 
@@ -366,10 +378,16 @@ xfs_submit_ioend_bio(
 	struct bio	*bio)
 {
 	atomic_inc(&ioend->io_remaining);
-
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
 
+	/*
+	 * if the I/O is beyond EOF we mark the inode dirty immediately
+	 * but don't update the inode size until I/O completion.
+	 */
+	if (xfs_ioend_new_eof(ioend))
+		xfs_mark_inode_dirty_sync(XFS_I(ioend->io_inode));
+
 	submit_bio(WRITE, bio);
 	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
 	bio_put(bio);
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index c5cfc1e..bbac9e3 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1118,8 +1118,7 @@ xfs_fs_write_super(
 	struct super_block	*sb)
 {
 	if (!(sb->s_flags & MS_RDONLY))
-		xfs_sync_fsdata(XFS_M(sb), 0);
-	sb->s_dirt = 0;
+		xfs_sync_fsdata(XFS_M(sb), SYNC_WAIT);
 }
 
 STATIC int
@@ -1131,22 +1130,16 @@ xfs_fs_sync_super(
 	int			error;
 
 	/*
-	 * Treat a sync operation like a freeze.  This is to work
-	 * around a race in sync_inodes() which works in two phases
-	 * - an asynchronous flush, which can write out an inode
-	 * without waiting for file size updates to complete, and a
-	 * synchronous flush, which wont do anything because the
-	 * async flush removed the inode's dirty flag.  Also
-	 * sync_inodes() will not see any files that just have
-	 * outstanding transactions to be flushed because we don't
-	 * dirty the Linux inode until after the transaction I/O
-	 * completes.
+	 * Treat a blocking sync operation like a data freeze.
+	 * The are effectively the same thing - both need to
+	 * get all the data on disk and wait for it to complete.
+	 *
+	 * Also, no point marking the superblock clean - we'll
+	 * dirty metadata flushing data out....
 	 */
-	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE))
-		error = xfs_quiesce_data(mp);
-	else
-		error = xfs_sync_fsdata(mp, 0);
-	sb->s_dirt = 0;
+	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE))
+		wait = 1;
+	error = xfs_quiesce_data(mp, wait);
 
 	if (unlikely(laptop_mode)) {
 		int	prev_sync_seq = mp->m_sync_seq;
@@ -1283,7 +1276,7 @@ xfs_fs_remount(
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
-		xfs_quiesce_data(mp);
+		xfs_quiesce_data(mp, 1);
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d12d31b..975534b 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -64,8 +64,6 @@ xfs_sync_inodes_ag(
 	int		last_error = 0;
 	int		fflag = XFS_B_ASYNC;
 
-	if (flags & SYNC_DELWRI)
-		fflag = XFS_B_DELWRI;
 	if (flags & SYNC_WAIT)
 		fflag = 0;		/* synchronous overrides all */
 
@@ -127,6 +125,8 @@ xfs_sync_inodes_ag(
 		/*
 		 * If we have to flush data or wait for I/O completion
 		 * we need to hold the iolock.
+		 *
+		 * XXX: this doesn't catch I/O in progress
 		 */
 		if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
 			xfs_ilock(ip, XFS_IOLOCK_SHARED);
@@ -202,11 +202,15 @@ xfs_sync_inodes(
 STATIC int
 xfs_commit_dummy_trans(
 	struct xfs_mount	*mp,
-	uint			log_flags)
+	uint			flags)
 {
 	struct xfs_inode	*ip = mp->m_rootip;
 	struct xfs_trans	*tp;
 	int			error;
+	int			log_flags = XFS_LOG_FORCE;
+
+	if (flags & SYNC_WAIT)
+		log_flags |= XFS_LOG_SYNC;
 
 	/*
 	 * Put a dummy transaction in the log to tell recovery
@@ -224,13 +228,12 @@ xfs_commit_dummy_trans(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	/* XXX(hch): ignoring the error here.. */
 	error = xfs_trans_commit(tp, 0);
-
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
+	/* the log force ensures this transaction is pushed to disk */
 	xfs_log_force(mp, 0, log_flags);
-	return 0;
+	return error;
 }
 
 int
@@ -270,6 +273,7 @@ xfs_sync_fsdata(
 		 */
 		if (XFS_BUF_ISPINNED(bp))
 			xfs_log_force(mp, 0, XFS_LOG_FORCE);
+		xfs_flush_buftarg(mp->m_ddev_targp, 1);
 	}
 
 
@@ -278,7 +282,13 @@ xfs_sync_fsdata(
 	else
 		XFS_BUF_ASYNC(bp);
 
-	return xfs_bwrite(mp, bp);
+	error = xfs_bwrite(mp, bp);
+	if (!error && xfs_log_need_covered(mp)) {
+		error = xfs_commit_dummy_trans(mp, (flags & SYNC_WAIT));
+		if (flags & SYNC_WAIT)
+			mp->m_super->s_dirt = 0;
+	}
+	return error;
 
  out_brelse:
 	xfs_buf_relse(bp);
@@ -305,18 +315,21 @@ xfs_sync_fsdata(
  */
 int
 xfs_quiesce_data(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	int			wait)
 {
 	int error;
 
 	/* push non-blocking */
-	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
+	xfs_sync_inodes(mp, SYNC_DELWRI);
 	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
-	xfs_filestream_flush(mp);
 
-	/* push and block */
-	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
-	XFS_QM_DQSYNC(mp, SYNC_WAIT);
+	/* push and block till complete */
+	if (wait) {
+		xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
+		XFS_QM_DQSYNC(mp, SYNC_WAIT);
+		xfs_filestream_flush(mp);
+	}
 
 	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp, 0);
@@ -480,8 +493,6 @@ xfs_sync_worker(
 		/* dgc: errors ignored here */
 		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
 		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
-		if (xfs_log_need_covered(mp))
-			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 5f6de1e..5586f7a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -39,7 +39,7 @@ void xfs_syncd_stop(struct xfs_mount *mp);
 int xfs_sync_inodes(struct xfs_mount *mp, int flags);
 int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
 
-int xfs_quiesce_data(struct xfs_mount *mp);
+int xfs_quiesce_data(struct xfs_mount *mp, int wait);
 void xfs_quiesce_attr(struct xfs_mount *mp);
 
 void xfs_flush_inode(struct xfs_inode *ip);
