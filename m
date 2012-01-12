Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C1L7YY205325 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 19:21:07 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id icIOLT1IsfWJQqGQ for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 17:21:06 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] xfs: Protect xfs_file_aio_write() with sb_start_write -
	sb_end_write
Date: Thu, 12 Jan 2012 02:20:53 +0100
Message-Id: <1326331253-6497-5-git-send-email-jack@suse.cz>
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org

Replace racy xfs_wait_for_freeze() check with reliable sb_start_write()
- sb_end_write() locking. Due to lock ranking dictated by the page fault
code we have to call sb_start_write() after we acquire ilock.

CC: Ben Myers <bpm@sgi.com>
CC: Alex Elder <elder@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..c5f879b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -862,9 +862,11 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_SHARED;
 	}
 
+	sb_start_write(inode->i_sb);
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
 	ret = generic_file_direct_write(iocb, iovp,
 			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+	sb_end_write(inode->i_sb);
 
 	/* No fallback to buffered IO on errors for XFS. */
 	ASSERT(ret < 0 || ret == count);
@@ -899,6 +901,7 @@ xfs_file_buffered_aio_write(
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
+	sb_start_write(inode->i_sb);
 write_retry:
 	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
 	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
@@ -914,6 +917,7 @@ write_retry:
 		enospc = 1;
 		goto write_retry;
 	}
+	sb_end_write(inode->i_sb);
 	current->backing_dev_info = NULL;
 	return ret;
 }
@@ -945,8 +949,6 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
-
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
