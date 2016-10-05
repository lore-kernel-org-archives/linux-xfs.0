Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbcJEI33 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Oct 2016 04:29:29 -0400
Date: Wed, 5 Oct 2016 10:29:26 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] fs: update atime before I/O in generic_file_read_iter
Message-ID: <20161005082926.GA7291@quack2.suse.cz>
References: <1475225194-3702-1-git-send-email-hch@lst.de>
 <1475225194-3702-3-git-send-email-hch@lst.de>
 <20161004081324.GC17515@quack2.suse.cz>
 <20161004114830.GA2359@lst.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20161004114830.GA2359@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 04-10-16 13:48:30, Christoph Hellwig wrote:
> On Tue, Oct 04, 2016 at 10:13:24AM +0200, Jan Kara wrote:
> > But frankly it looks like a nasty catch that iocb->ki_filp can go away
> > under you in the AIO case. Do I get it right that this means there must be
> > some other thread closing your fd while the read is running, right?
> 
> Yes, that's what generic/323 tests.
> 
> > Also it seems that file_end_write(file) call in aio_run_iocb() is prone to
> > the same race?
> 
> Indeed.  That's easy to fix by moving the file_end_write to aio_complete,
> though.

Now that you speak about that I even had a patch for that (attached) but
Benjamin didn't quite like the lockdep dance you have to do so the patch
just got dropped... Now looking at the patch the lockdep annotation
actually still has the use-after-free issue and I don't see an easy way of
avoiding that. Any idea?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--UugvWAfsgieZRqgk
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-aio-Fix-freeze-protection-of-aio-writes.patch"

>From df3f86d497e7fc11f3a03e26ee1333f2c03025e5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 24 Nov 2015 14:19:22 +0100
Subject: [PATCH] aio: Fix freeze protection of aio writes

Currently we dropped freeze protection of aio writes just after IO was
submitted. Thus aio write could be in flight while the filesystem was
frozen and that could result in unexpected situation like aio completion
wanting to convert extent type on frozen filesystem. Testcase from
Dmitry triggering this is like:

for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done &
fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
    --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite

Fix the problem by dropping freeze protection only once IO is completed
in aio_complete().

Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/aio.c           | 31 ++++++++++++++++++++++++++++---
 include/linux/fs.h |  1 +
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 155f84253f33..ee0871cb4677 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1065,6 +1065,19 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
 	unsigned tail, pos, head;
 	unsigned long	flags;
 
+	if (kiocb->ki_flags & IOCB_WRITE) {
+		struct file *f = kiocb->ki_filp;
+
+		/*
+		 * Tell lockdep we inherited freeze protection from submission
+		 * thread.
+		 */
+		percpu_rwsem_acquire(
+			&f->f_inode->i_sb->s_writers.rw_sem[SB_FREEZE_WRITE-1],
+			1, _THIS_IP_);
+		file_end_write(f);
+	}
+
 	/*
 	 * Special case handling for sync iocbs:
 	 *  - events go directly into the iocb for fast handling
@@ -1449,13 +1462,25 @@ rw_common:
 
 		len = ret;
 
-		if (rw == WRITE)
+		if (rw == WRITE) {
 			file_start_write(file);
+			req->ki_flags |= IOCB_WRITE;
+		}
 
 		ret = iter_op(req, &iter);
 
-		if (rw == WRITE)
-			file_end_write(file);
+		if (rw == WRITE) {
+			/*
+			 * We release freeze protection in aio_complete(). Fool
+			 * lockdep by telling it the lock got released so that
+			 * it doesn't complain about held lock when we return
+			 * to userspace.
+			 */
+			percpu_rwsem_release(
+				&file->f_inode->i_sb->s_writers.rw_sem[SB_FREEZE_WRITE-1],
+				1, _THIS_IP_);
+		}
+
 		kfree(iovec);
 		break;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3aa514254161..54af40ed6a26 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -319,6 +319,7 @@ struct writeback_control;
 #define IOCB_EVENTFD		(1 << 0)
 #define IOCB_APPEND		(1 << 1)
 #define IOCB_DIRECT		(1 << 2)
+#define IOCB_WRITE		(1 << 3)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.6.2


--UugvWAfsgieZRqgk--
