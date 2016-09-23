Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51272 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161383AbcIWTE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:04:59 -0400
Date: Fri, 23 Sep 2016 20:04:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 07/11] fuse_dev_splice_read(): switch to add_to_pipe()
Message-ID: <20160923190457.GE2356@ZenIV.linux.org.uk>
References: <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160923190032.GA25771@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/dev.c | 46 +++++++++-------------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index eaf56c6..0a6a808 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1342,9 +1342,8 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 				    struct pipe_inode_info *pipe,
 				    size_t len, unsigned int flags)
 {
-	int ret;
+	int total, ret;
 	int page_nr = 0;
-	int do_wakeup = 0;
 	struct pipe_buffer *bufs;
 	struct fuse_copy_state cs;
 	struct fuse_dev *fud = fuse_get_dev(in);
@@ -1363,50 +1362,23 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 	if (ret < 0)
 		goto out;
 
-	ret = 0;
-
-	if (!pipe->readers) {
-		send_sig(SIGPIPE, current, 0);
-		if (!ret)
-			ret = -EPIPE;
-		goto out_unlock;
-	}
-
 	if (pipe->nrbufs + cs.nr_segs > pipe->buffers) {
 		ret = -EIO;
-		goto out_unlock;
+		goto out;
 	}
 
-	while (page_nr < cs.nr_segs) {
-		int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
-		struct pipe_buffer *buf = pipe->bufs + newbuf;
-
-		buf->page = bufs[page_nr].page;
-		buf->offset = bufs[page_nr].offset;
-		buf->len = bufs[page_nr].len;
+	for (ret = total = 0; page_nr < cs.nr_segs; total += ret) {
 		/*
 		 * Need to be careful about this.  Having buf->ops in module
 		 * code can Oops if the buffer persists after module unload.
 		 */
-		buf->ops = &nosteal_pipe_buf_ops;
-
-		pipe->nrbufs++;
-		page_nr++;
-		ret += buf->len;
-
-		if (pipe->files)
-			do_wakeup = 1;
-	}
-
-out_unlock:
-
-	if (do_wakeup) {
-		smp_mb();
-		if (waitqueue_active(&pipe->wait))
-			wake_up_interruptible(&pipe->wait);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+		bufs[page_nr].ops = &nosteal_pipe_buf_ops;
+		ret = add_to_pipe(pipe, &bufs[page_nr++]);
+		if (unlikely(ret < 0))
+			break;
 	}
-
+	if (total)
+		ret = total;
 out:
 	for (; page_nr < cs.nr_segs; page_nr++)
 		put_page(bufs[page_nr].page);
-- 
2.9.3

