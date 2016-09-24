Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57156 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750697AbcIXEAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 00:00:24 -0400
Date: Sat, 24 Sep 2016 05:00:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 06/12] new helper: add_to_pipe()
Message-ID: <20160924040022.GO2356@ZenIV.linux.org.uk>
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

single-buffer analogue of splice_to_pipe(); vmsplice_to_pipe() switched
to that, leaving splice_to_pipe() only for ->splice_read() instances
(and that only until they are converted as well).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/splice.c            | 113 ++++++++++++++++++++++++++++---------------------
 include/linux/splice.h |   2 +
 2 files changed, 67 insertions(+), 48 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 02daa61..e13d935 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -203,8 +203,6 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		buf->len = spd->partial[page_nr].len;
 		buf->private = spd->partial[page_nr].private;
 		buf->ops = spd->ops;
-		if (spd->flags & SPLICE_F_GIFT)
-			buf->flags |= PIPE_BUF_FLAG_GIFT;
 
 		pipe->nrbufs++;
 		page_nr++;
@@ -225,6 +223,27 @@ out:
 }
 EXPORT_SYMBOL_GPL(splice_to_pipe);
 
+ssize_t add_to_pipe(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
+{
+	int ret;
+
+	if (unlikely(!pipe->readers)) {
+		send_sig(SIGPIPE, current, 0);
+		ret = -EPIPE;
+	} else if (pipe->nrbufs == pipe->buffers) {
+		ret = -EAGAIN;
+	} else {
+		int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
+		pipe->bufs[newbuf] = *buf;
+		pipe->nrbufs++;
+		return buf->len;
+	}
+	buf->ops->release(pipe, buf);
+	buf->ops = NULL;
+	return ret;
+}
+EXPORT_SYMBOL(add_to_pipe);
+
 void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 {
 	put_page(spd->pages[i]);
@@ -1415,33 +1434,50 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 	return -EINVAL;
 }
 
-static int get_iovec_page_array(const struct iov_iter *from,
-				struct page **pages,
-				struct partial_page *partial,
-				unsigned int pipe_buffers)
+static int iter_to_pipe(struct iov_iter *from,
+			struct pipe_inode_info *pipe,
+			unsigned flags)
 {
-	struct iov_iter i = *from;
-	int buffers = 0;
-	while (iov_iter_count(&i)) {
+	struct pipe_buffer buf = {
+		.ops = &user_page_pipe_buf_ops,
+		.flags = flags
+	};
+	size_t total = 0;
+	int ret = 0;
+	bool failed = false;
+
+	while (iov_iter_count(from) && !failed) {
+		struct page *pages[16];
 		ssize_t copied;
 		size_t start;
+		int n;
 
-		copied = iov_iter_get_pages(&i, pages + buffers, ~0UL,
-					pipe_buffers - buffers, &start);
-		if (copied <= 0)
-			return buffers ? buffers : copied;
+		copied = iov_iter_get_pages(from, pages, ~0UL, 16, &start);
+		if (copied <= 0) {
+			ret = copied;
+			break;
+		}
 
-		iov_iter_advance(&i, copied);
-		while (copied) {
+		for (n = 0; copied; n++, start = 0) {
 			int size = min_t(int, copied, PAGE_SIZE - start);
-			partial[buffers].offset = start;
-			partial[buffers].len = size;
+			if (!failed) {
+				buf.page = pages[n];
+				buf.offset = start;
+				buf.len = size;
+				ret = add_to_pipe(pipe, &buf);
+				if (unlikely(ret < 0)) {
+					failed = true;
+				} else {
+					iov_iter_advance(from, ret);
+					total += ret;
+				}
+			} else {
+				put_page(pages[n]);
+			}
 			copied -= size;
-			start = 0;
-			buffers++;
 		}
 	}
-	return buffers;
+	return total ? total : ret;
 }
 
 static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
@@ -1502,17 +1538,11 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *uiov,
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	struct iov_iter from;
-	struct page *pages[PIPE_DEF_BUFFERS];
-	struct partial_page partial[PIPE_DEF_BUFFERS];
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
-		.nr_pages_max = PIPE_DEF_BUFFERS,
-		.flags = flags,
-		.ops = &user_page_pipe_buf_ops,
-		.spd_release = spd_release_page,
-	};
 	long ret;
+	unsigned buf_flag = 0;
+
+	if (flags & SPLICE_F_GIFT)
+		buf_flag = PIPE_BUF_FLAG_GIFT;
 
 	pipe = get_pipe_info(file);
 	if (!pipe)
@@ -1523,26 +1553,13 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *uiov,
 	if (ret < 0)
 		return ret;
 
-	if (splice_grow_spd(pipe, &spd)) {
-		kfree(iov);
-		return -ENOMEM;
-	}
-
 	pipe_lock(pipe);
 	ret = wait_for_space(pipe, flags);
-	if (!ret) {
-		spd.nr_pages = get_iovec_page_array(&from, spd.pages,
-						    spd.partial,
-						    spd.nr_pages_max);
-		if (spd.nr_pages <= 0)
-			ret = spd.nr_pages;
-		else
-			ret = splice_to_pipe(pipe, &spd);
-		pipe_unlock(pipe);
-		if (ret > 0)
-			wakeup_pipe_readers(pipe);
-	}
-	splice_shrink_spd(&spd);
+	if (!ret)
+		ret = iter_to_pipe(&from, pipe, buf_flag);
+	pipe_unlock(pipe);
+	if (ret > 0)
+		wakeup_pipe_readers(pipe);
 	kfree(iov);
 	return ret;
 }
diff --git a/include/linux/splice.h b/include/linux/splice.h
index da2751d..58b300f 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -72,6 +72,8 @@ extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
 				  struct splice_desc *, splice_actor *);
 extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 			      struct splice_pipe_desc *);
+extern ssize_t add_to_pipe(struct pipe_inode_info *,
+			      struct pipe_buffer *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 
-- 
2.9.3

