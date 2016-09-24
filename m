Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57136 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932823AbcIXD7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 23:59:53 -0400
Date: Sat, 24 Sep 2016 04:59:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20160924035951.GN2356@ZenIV.linux.org.uk>
References: <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

* splice_to_pipe() stops at pipe overflow and does *not* take pipe_lock
* ->splice_read() instances do the same
* vmsplice_to_pipe() and do_splice() (ultimate callers of splice_to_pipe())
  arrange for waiting, looping, etc. themselves.

That should make pipe_lock the outermost one.

Unfortunately, existing rules for the amount passed by vmsplice_to_pipe()
and do_splice() are quite ugly _and_ userland code can be easily broken
by changing those.  It's not even "no more than the maximal capacity of
this pipe" - it's "once we'd fed pipe->nr_buffers pages into the pipe,
leave instead of waiting".

Considering how poorly these rules are documented, let's try "wait for some
space to appear, unless given SPLICE_F_NONBLOCK, then push into pipe
and if we run into overflow, we are done".

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/dev.c |   2 -
 fs/splice.c   | 138 +++++++++++++++++++++++++++-------------------------------
 2 files changed, 63 insertions(+), 77 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index a94d2ed..eaf56c6 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1364,7 +1364,6 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 		goto out;
 
 	ret = 0;
-	pipe_lock(pipe);
 
 	if (!pipe->readers) {
 		send_sig(SIGPIPE, current, 0);
@@ -1400,7 +1399,6 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 	}
 
 out_unlock:
-	pipe_unlock(pipe);
 
 	if (do_wakeup) {
 		smp_mb();
diff --git a/fs/splice.c b/fs/splice.c
index 31c52e0..02daa61 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -183,79 +183,41 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		       struct splice_pipe_desc *spd)
 {
 	unsigned int spd_pages = spd->nr_pages;
-	int ret, do_wakeup, page_nr;
+	int ret = 0, page_nr = 0;
 
 	if (!spd_pages)
 		return 0;
 
-	ret = 0;
-	do_wakeup = 0;
-	page_nr = 0;
-
-	pipe_lock(pipe);
-
-	for (;;) {
-		if (!pipe->readers) {
-			send_sig(SIGPIPE, current, 0);
-			if (!ret)
-				ret = -EPIPE;
-			break;
-		}
-
-		if (pipe->nrbufs < pipe->buffers) {
-			int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
-			struct pipe_buffer *buf = pipe->bufs + newbuf;
-
-			buf->page = spd->pages[page_nr];
-			buf->offset = spd->partial[page_nr].offset;
-			buf->len = spd->partial[page_nr].len;
-			buf->private = spd->partial[page_nr].private;
-			buf->ops = spd->ops;
-			if (spd->flags & SPLICE_F_GIFT)
-				buf->flags |= PIPE_BUF_FLAG_GIFT;
-
-			pipe->nrbufs++;
-			page_nr++;
-			ret += buf->len;
-
-			if (pipe->files)
-				do_wakeup = 1;
+	if (unlikely(!pipe->readers)) {
+		send_sig(SIGPIPE, current, 0);
+		ret = -EPIPE;
+		goto out;
+	}
 
-			if (!--spd->nr_pages)
-				break;
-			if (pipe->nrbufs < pipe->buffers)
-				continue;
+	while (pipe->nrbufs < pipe->buffers) {
+		int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
+		struct pipe_buffer *buf = pipe->bufs + newbuf;
 
-			break;
-		}
+		buf->page = spd->pages[page_nr];
+		buf->offset = spd->partial[page_nr].offset;
+		buf->len = spd->partial[page_nr].len;
+		buf->private = spd->partial[page_nr].private;
+		buf->ops = spd->ops;
+		if (spd->flags & SPLICE_F_GIFT)
+			buf->flags |= PIPE_BUF_FLAG_GIFT;
 
-		if (spd->flags & SPLICE_F_NONBLOCK) {
-			if (!ret)
-				ret = -EAGAIN;
-			break;
-		}
+		pipe->nrbufs++;
+		page_nr++;
+		ret += buf->len;
 
-		if (signal_pending(current)) {
-			if (!ret)
-				ret = -ERESTARTSYS;
+		if (!--spd->nr_pages)
 			break;
-		}
-
-		if (do_wakeup) {
-			wakeup_pipe_readers(pipe);
-			do_wakeup = 0;
-		}
-
-		pipe->waiting_writers++;
-		pipe_wait(pipe);
-		pipe->waiting_writers--;
 	}
 
-	pipe_unlock(pipe);
-
-	if (do_wakeup)
-		wakeup_pipe_readers(pipe);
+	if (!ret)
+		ret = -EAGAIN;
 
+out:
 	while (page_nr < spd_pages)
 		spd->spd_release(spd, page_nr++);
 
@@ -1339,6 +1301,20 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(do_splice_direct);
 
+static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
+{
+	while (pipe->nrbufs == pipe->buffers) {
+		if (flags & SPLICE_F_NONBLOCK)
+			return -EAGAIN;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+		pipe->waiting_writers++;
+		pipe_wait(pipe);
+		pipe->waiting_writers--;
+	}
+	return 0;
+}
+
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
@@ -1421,8 +1397,13 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 			offset = in->f_pos;
 		}
 
-		ret = do_splice_to(in, &offset, opipe, len, flags);
-
+		pipe_lock(opipe);
+		ret = wait_for_space(opipe, flags);
+		if (!ret)
+			ret = do_splice_to(in, &offset, opipe, len, flags);
+		pipe_unlock(opipe);
+		if (ret > 0)
+			wakeup_pipe_readers(opipe);
 		if (!off_in)
 			in->f_pos = offset;
 		else if (copy_to_user(off_in, &offset, sizeof(loff_t)))
@@ -1434,22 +1415,23 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 	return -EINVAL;
 }
 
-static int get_iovec_page_array(struct iov_iter *from,
+static int get_iovec_page_array(const struct iov_iter *from,
 				struct page **pages,
 				struct partial_page *partial,
 				unsigned int pipe_buffers)
 {
+	struct iov_iter i = *from;
 	int buffers = 0;
-	while (iov_iter_count(from)) {
+	while (iov_iter_count(&i)) {
 		ssize_t copied;
 		size_t start;
 
-		copied = iov_iter_get_pages(from, pages + buffers, ~0UL,
+		copied = iov_iter_get_pages(&i, pages + buffers, ~0UL,
 					pipe_buffers - buffers, &start);
 		if (copied <= 0)
 			return buffers ? buffers : copied;
 
-		iov_iter_advance(from, copied);
+		iov_iter_advance(&i, copied);
 		while (copied) {
 			int size = min_t(int, copied, PAGE_SIZE - start);
 			partial[buffers].offset = start;
@@ -1546,14 +1528,20 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *uiov,
 		return -ENOMEM;
 	}
 
-	spd.nr_pages = get_iovec_page_array(&from, spd.pages,
-					    spd.partial,
-					    spd.nr_pages_max);
-	if (spd.nr_pages <= 0)
-		ret = spd.nr_pages;
-	else
-		ret = splice_to_pipe(pipe, &spd);
-
+	pipe_lock(pipe);
+	ret = wait_for_space(pipe, flags);
+	if (!ret) {
+		spd.nr_pages = get_iovec_page_array(&from, spd.pages,
+						    spd.partial,
+						    spd.nr_pages_max);
+		if (spd.nr_pages <= 0)
+			ret = spd.nr_pages;
+		else
+			ret = splice_to_pipe(pipe, &spd);
+		pipe_unlock(pipe);
+		if (ret > 0)
+			wakeup_pipe_readers(pipe);
+	}
 	splice_shrink_spd(&spd);
 	kfree(iov);
 	return ret;
-- 
2.9.3

