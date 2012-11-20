Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK8F68O125862 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 02:15:06 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pKZcFikZYrJNXfZC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 00:17:16 -0800 (PST)
Subject: [PATCH 5/9] btrfs: Use generic handlers of O_SYNC AIO DIO
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Nov 2012 23:51:14 -0800
Message-ID: <20121120075114.25270.85716.stgit@blackbox.djwong.org>
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
MIME-Version: 1.0
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
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file. Although we use our own bio->end_io function, we call dio_end_io()
from it and thus, because we don't set any specific dio->end_io function,
generic code ends up calling generic_dio_end_io() which is all what we need
for proper O_SYNC AIO DIO handling.

From: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
[darrick.wong@oracle.com: Don't issue flush if aio is queued]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/file.c  |    2 +-
 fs/btrfs/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..37b5bb3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1495,7 +1495,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	 * one running right now.
 	 */
 	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
-	if (num_written > 0 || num_written == -EIOCBQUEUED) {
+	if (num_written > 0) {
 		err = generic_write_sync(file, pos, num_written);
 		if (err < 0 && num_written > 0)
 			num_written = err;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..c8b6049 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6579,7 +6579,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	return __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+		   btrfs_submit_direct, DIO_SYNC_WRITES);
 }
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
