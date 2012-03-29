Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM5Hn2198803 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:05:17 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qd8Ifb8U3ZAfQKSl for
	<xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:05:16 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/7] ocfs2: Use generic handlers of O_SYNC AIO DIO
Date: Thu, 29 Mar 2012 18:05:00 -0400
Message-Id: <1333058705-31512-3-git-send-email-jmoyer@redhat.com>
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
file.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/ocfs2/aops.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..60457cc 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -593,9 +593,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
 
-	if (is_async)
-		aio_complete(iocb, ret, 0);
-	inode_dio_done(inode);
+	generic_dio_end_io(iocb, offset, bytes, private, ret, is_async);
 }
 
 /*
@@ -642,7 +640,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
 				    iov, offset, nr_segs,
 				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+				    ocfs2_dio_end_io, NULL, DIO_SYNC_WRITES);
 }
 
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
