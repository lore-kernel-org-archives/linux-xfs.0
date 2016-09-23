Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 80AB97CBC
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2016 14:02:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35BCF304043
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2016 12:02:58 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id AKTyc2oD5DBVUjmk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2016 12:02:54 -0700 (PDT)
Date: Fri, 23 Sep 2016 20:02:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 03/11] splice: switch get_iovec_page_array() to iov_iter
Message-ID: <20160923190250.GA2356@ZenIV.linux.org.uk>
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
Content-Disposition: inline
In-Reply-To: <20160923190032.GA25771@ZenIV.linux.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, CAI Qian <caiqian@redhat.com>, Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/splice.c | 135 ++++++++++++++++--------------------------------------------
 1 file changed, 36 insertions(+), 99 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 36e9353..31c52e0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1434,106 +1434,32 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 	return -EINVAL;
 }
 
-/*
- * Map an iov into an array of pages and offset/length tupples. With the
- * partial_page structure, we can map several non-contiguous ranges into
- * our ones pages[] map instead of splitting that operation into pieces.
- * Could easily be exported as a generic helper for other users, in which
- * case one would probably want to add a 'max_nr_pages' parameter as well.
- */
-static int get_iovec_page_array(const struct iovec __user *iov,
-				unsigned int nr_vecs, struct page **pages,
-				struct partial_page *partial, bool aligned,
+static int get_iovec_page_array(struct iov_iter *from,
+				struct page **pages,
+				struct partial_page *partial,
 				unsigned int pipe_buffers)
 {
-	int buffers = 0, error = 0;
-
-	while (nr_vecs) {
-		unsigned long off, npages;
-		struct iovec entry;
-		void __user *base;
-		size_t len;
-		int i;
-
-		error = -EFAULT;
-		if (copy_from_user(&entry, iov, sizeof(entry)))
-			break;
-
-		base = entry.iov_base;
-		len = entry.iov_len;
-
-		/*
-		 * Sanity check this iovec. 0 read succeeds.
-		 */
-		error = 0;
-		if (unlikely(!len))
-			break;
-		error = -EFAULT;
-		if (!access_ok(VERIFY_READ, base, len))
-			break;
-
-		/*
-		 * Get this base offset and number of pages, then map
-		 * in the user pages.
-		 */
-		off = (unsigned long) base & ~PAGE_MASK;
-
-		/*
-		 * If asked for alignment, the offset must be zero and the
-		 * length a multiple of the PAGE_SIZE.
-		 */
-		error = -EINVAL;
-		if (aligned && (off || len & ~PAGE_MASK))
-			break;
-
-		npages = (off + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		if (npages > pipe_buffers - buffers)
-			npages = pipe_buffers - buffers;
-
-		error = get_user_pages_fast((unsigned long)base, npages,
-					0, &pages[buffers]);
-
-		if (unlikely(error <= 0))
-			break;
-
-		/*
-		 * Fill this contiguous range into the partial page map.
-		 */
-		for (i = 0; i < error; i++) {
-			const int plen = min_t(size_t, len, PAGE_SIZE - off);
-
-			partial[buffers].offset = off;
-			partial[buffers].len = plen;
-
-			off = 0;
-			len -= plen;
+	int buffers = 0;
+	while (iov_iter_count(from)) {
+		ssize_t copied;
+		size_t start;
+
+		copied = iov_iter_get_pages(from, pages + buffers, ~0UL,
+					pipe_buffers - buffers, &start);
+		if (copied <= 0)
+			return buffers ? buffers : copied;
+
+		iov_iter_advance(from, copied);
+		while (copied) {
+			int size = min_t(int, copied, PAGE_SIZE - start);
+			partial[buffers].offset = start;
+			partial[buffers].len = size;
+			copied -= size;
+			start = 0;
 			buffers++;
 		}
-
-		/*
-		 * We didn't complete this iov, stop here since it probably
-		 * means we have to move some of this into a pipe to
-		 * be able to continue.
-		 */
-		if (len)
-			break;
-
-		/*
-		 * Don't continue if we mapped fewer pages than we asked for,
-		 * or if we mapped the max number of pages that we have
-		 * room for.
-		 */
-		if (error < npages || buffers == pipe_buffers)
-			break;
-
-		nr_vecs--;
-		iov++;
 	}
-
-	if (buffers)
-		return buffers;
-
-	return error;
+	return buffers;
 }
 
 static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
@@ -1587,10 +1513,13 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *uiov,
  * as splice-from-memory, where the regular splice is splice-from-file (or
  * to file). In both cases the output is a pipe, naturally.
  */
-static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
+static long vmsplice_to_pipe(struct file *file, const struct iovec __user *uiov,
 			     unsigned long nr_segs, unsigned int flags)
 {
 	struct pipe_inode_info *pipe;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov = iovstack;
+	struct iov_iter from;
 	struct page *pages[PIPE_DEF_BUFFERS];
 	struct partial_page partial[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
@@ -1607,11 +1536,18 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 	if (!pipe)
 		return -EBADF;
 
-	if (splice_grow_spd(pipe, &spd))
+	ret = import_iovec(WRITE, uiov, nr_segs,
+			   ARRAY_SIZE(iovstack), &iov, &from);
+	if (ret < 0)
+		return ret;
+
+	if (splice_grow_spd(pipe, &spd)) {
+		kfree(iov);
 		return -ENOMEM;
+	}
 
-	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
-					    spd.partial, false,
+	spd.nr_pages = get_iovec_page_array(&from, spd.pages,
+					    spd.partial,
 					    spd.nr_pages_max);
 	if (spd.nr_pages <= 0)
 		ret = spd.nr_pages;
@@ -1619,6 +1555,7 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 		ret = splice_to_pipe(pipe, &spd);
 
 	splice_shrink_spd(&spd);
+	kfree(iov);
 	return ret;
 }
 
-- 
2.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
