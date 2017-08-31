Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55546 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdHaNrY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 09:47:24 -0400
Date: Thu, 31 Aug 2017 15:47:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170831134722.GA6912@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org

I think something like the following patch (totally untested,
just an idea) should fix the issue, right?

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c4893e226fd8..555fcae9a18f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -135,7 +135,7 @@ xfs_file_fsync(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
-	int			log_flushed = 0;
+	unsigned int		flushseq;
 	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
@@ -143,6 +143,7 @@ xfs_file_fsync(
 	error = file_write_and_wait_range(file, start, end);
 	if (error)
 		return error;
+	flushseq = READ_ONCE(mp->m_flushseq);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -181,7 +182,7 @@ xfs_file_fsync(
 	}
 
 	if (lsn) {
-		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
+		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 		ip->i_itemp->ili_fsync_fields = 0;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -193,8 +194,9 @@ xfs_file_fsync(
 	 * an already allocated file and thus do not have any metadata to
 	 * commit.
 	 */
-	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
-	    mp->m_logdev_targp == mp->m_ddev_targp)
+	if (!XFS_IS_REALTIME_INODE(ip) &&
+	    mp->m_logdev_targp == mp->m_ddev_targp &&
+	    flushseq == READ_ONCE(mp->m_flushseq))
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
 	return error;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bcb2f860e508..3c0cbb98581e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2922,6 +2922,8 @@ xlog_state_done_syncing(
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
 	}
 
+	log->l_mp->m_flushseq++;
+
 	/*
 	 * Someone could be sleeping prior to writing out the next
 	 * iclog buffer, we wake them all, one will get to do the
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d036be2..556e01a0175e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -79,6 +79,7 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
 	struct percpu_counter	m_fdblocks;	/* free block counter */
+	unsigned int		m_flushseq;
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
