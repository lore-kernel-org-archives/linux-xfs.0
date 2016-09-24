Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57218 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbcIXEC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 00:02:28 -0400
Date: Sat, 24 Sep 2016 05:02:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 12/12] switch default_file_splice_read() to use of
 pipe-backed iov_iter
Message-ID: <20160924040226.GR2356@ZenIV.linux.org.uk>
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

we only use iov_iter_get_pages_alloc() and iov_iter_advance() -
pages are filled by kernel_readv() via a kvec array (as we used
to do all along), so iov_iter here is used only as a way of
arranging for those pages to be in pipe.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/splice.c | 111 ++++++++++++++++++++++--------------------------------------
 1 file changed, 40 insertions(+), 71 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 58c322a..0df907b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -361,7 +361,7 @@ const struct pipe_buf_operations nosteal_pipe_buf_ops = {
 };
 EXPORT_SYMBOL(nosteal_pipe_buf_ops);
 
-static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
+static ssize_t kernel_readv(struct file *file, const struct kvec *vec,
 			    unsigned long vlen, loff_t offset)
 {
 	mm_segment_t old_fs;
@@ -397,96 +397,65 @@ static ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
+	struct kvec *vec, __vec[PIPE_DEF_BUFFERS];
+	struct iov_iter to;
+	struct page **pages;
 	unsigned int nr_pages;
-	unsigned int nr_freed;
-	size_t offset;
-	struct page *pages[PIPE_DEF_BUFFERS];
-	struct partial_page partial[PIPE_DEF_BUFFERS];
-	struct iovec *vec, __vec[PIPE_DEF_BUFFERS];
+	size_t offset, dummy, copied = 0;
 	ssize_t res;
-	size_t this_len;
-	int error;
 	int i;
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
-		.nr_pages_max = PIPE_DEF_BUFFERS,
-		.flags = flags,
-		.ops = &default_pipe_buf_ops,
-		.spd_release = spd_release_page,
-	};
 
-	if (splice_grow_spd(pipe, &spd))
+	if (pipe->nrbufs == pipe->buffers)
+		return -EAGAIN;
+
+	/*
+	 * Try to keep page boundaries matching to source pagecache ones -
+	 * it probably won't be much help, but...
+	 */
+	offset = *ppos & ~PAGE_MASK;
+
+	iov_iter_pipe(&to, ITER_PIPE | READ, pipe, len + offset);
+
+	res = iov_iter_get_pages_alloc(&to, &pages, len + offset, &dummy);
+	if (res <= 0)
 		return -ENOMEM;
 
-	res = -ENOMEM;
+	nr_pages = res / PAGE_SIZE;
+
 	vec = __vec;
-	if (spd.nr_pages_max > PIPE_DEF_BUFFERS) {
-		vec = kmalloc(spd.nr_pages_max * sizeof(struct iovec), GFP_KERNEL);
-		if (!vec)
-			goto shrink_ret;
+	if (nr_pages > PIPE_DEF_BUFFERS) {
+		vec = kmalloc(nr_pages * sizeof(struct kvec), GFP_KERNEL);
+		if (unlikely(!vec)) {
+			res = -ENOMEM;
+			goto out;
+		}
 	}
 
-	offset = *ppos & ~PAGE_MASK;
-	nr_pages = (len + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	for (i = 0; i < nr_pages && i < spd.nr_pages_max && len; i++) {
-		struct page *page;
-
-		page = alloc_page(GFP_USER);
-		error = -ENOMEM;
-		if (!page)
-			goto err;
+	pipe->bufs[to.idx].offset = offset;
+	pipe->bufs[to.idx].len -= offset;
 
-		this_len = min_t(size_t, len, PAGE_SIZE - offset);
-		vec[i].iov_base = (void __user *) page_address(page);
+	for (i = 0; i < nr_pages; i++) {
+		size_t this_len = min_t(size_t, len, PAGE_SIZE - offset);
+		vec[i].iov_base = page_address(pages[i]) + offset;
 		vec[i].iov_len = this_len;
-		spd.pages[i] = page;
-		spd.nr_pages++;
 		len -= this_len;
 		offset = 0;
 	}
 
-	res = kernel_readv(in, vec, spd.nr_pages, *ppos);
-	if (res < 0) {
-		error = res;
-		goto err;
-	}
-
-	error = 0;
-	if (!res)
-		goto err;
-
-	nr_freed = 0;
-	for (i = 0; i < spd.nr_pages; i++) {
-		this_len = min_t(size_t, vec[i].iov_len, res);
-		spd.partial[i].offset = 0;
-		spd.partial[i].len = this_len;
-		if (!this_len) {
-			__free_page(spd.pages[i]);
-			spd.pages[i] = NULL;
-			nr_freed++;
-		}
-		res -= this_len;
-	}
-	spd.nr_pages -= nr_freed;
-
-	res = splice_to_pipe(pipe, &spd);
-	if (res > 0)
+	res = kernel_readv(in, vec, nr_pages, *ppos);
+	if (res > 0) {
+		copied = res;
 		*ppos += res;
+	}
 
-shrink_ret:
 	if (vec != __vec)
 		kfree(vec);
-	splice_shrink_spd(&spd);
+out:
+	for (i = 0; i < nr_pages; i++)
+		put_page(pages[i]);
+	kvfree(pages);
+	iov_iter_advance(&to, copied);	/* truncates and discards */
 	return res;
-
-err:
-	for (i = 0; i < spd.nr_pages; i++)
-		__free_page(spd.pages[i]);
-
-	res = error;
-	goto shrink_ret;
 }
 
 /*
-- 
2.9.3

