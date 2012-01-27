Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RLFunW253311 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 15:15:56 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hHUETfsBiOZyNWse for
	<xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:15:55 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/3] filemap: don't call generic_write_sync for -EIOCBQUEUED
Date: Fri, 27 Jan 2012 16:15:49 -0500
Message-Id: <1327698949-12616-4-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
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
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Jeff Moyer <jmoyer@redhat.com>

Hi,

As it stands, generic_file_aio_write will call into generic_write_sync
when -EIOCBQUEUED is returned from __generic_file_aio_write.  EIOCBQUEUED
indicates that an I/O was submitted but NOT completed.  Thus, we will
flush the disk cache, potentially before the write(s) even make it to
the disk!  Up until now, this has been the best we could do, as file
systems didn't bother to flush the disk cache after an O_SYNC AIO+DIO
write.  After applying the prior two patches to xfs and ext4, at least
the major two file systems do the right thing.  So, let's go ahead and
fix this backwards logic.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c4ee2e9..004442f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2634,7 +2634,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
