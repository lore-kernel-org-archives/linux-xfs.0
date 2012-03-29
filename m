Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM5Jcg198834 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:05:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LR2g4WgcBvu2IexK for
	<xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:05:18 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/7] btrfs: Use generic handlers of O_SYNC AIO DIO
Date: Thu, 29 Mar 2012 18:05:02 -0400
Message-Id: <1333058705-31512-5-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
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
Cc: hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

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
index 3a0b5c1..5cb3e22 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6249,7 +6249,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
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
