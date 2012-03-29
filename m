Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM5HpR198801 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:05:17 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0ySmJhePCmK6dd73 for
	<xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:05:15 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 7/7] filemap: don't call generic_write_sync for -EIOCBQUEUED
Date: Thu, 29 Mar 2012 18:05:05 -0400
Message-Id: <1333058705-31512-8-git-send-email-jmoyer@redhat.com>
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
index 79c4b2b..ef81dfb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2614,7 +2614,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
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
