Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22JudbI138276 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 13:56:39 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qHvIwCxebsloj0dU for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 11:56:38 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/7] btrfs: Use generic handlers of O_SYNC AIO DIO
Date: Fri,  2 Mar 2012 14:56:12 -0500
Message-Id: <1330718175-21540-5-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
References: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Cc: hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, jack@suse.cz

From: Jan Kara <jack@suse.cz>

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file. Although we use our own bio->end_io function, we call dio_end_io()
from it and thus, because we don't set any specific dio->end_io function,
generic code ends up calling generic_dio_end_io() which is all what we need
for proper O_SYNC AIO DIO handling.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 81b235a..c0379e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6219,7 +6219,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+		   btrfs_submit_direct, DIO_SYNC_WRITES);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
