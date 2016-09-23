Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51376 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758933AbcIWTJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:09:57 -0400
Date: Fri, 23 Sep 2016 20:09:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 10/11] new iov_iter flavour: pipe-backed
Message-ID: <20160923190955.GH2356@ZenIV.linux.org.uk>
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

iov_iter variant for passing data into pipe.  copy_to_iter()
copies data into page(s) it has allocated and stuffs them into
the pipe; copy_page_to_iter() stuffs there a reference to the
page given to it.  Both will try to coalesce if possible.
iov_iter_zero() is similar to copy_to_iter(); iov_iter_get_pages()
and friends will do as copy_to_iter() would have and return the
pages where the data would've been copied.  iov_iter_advance()
will truncate everything past the spot it has advanced to.

New primitive: iov_iter_pipe(), used for initializing those.
pipe should be locked all along.

Running out of space acts as fault would for iovec-backed ones;
in other words, giving it to ->read_iter() may result in short
read if the pipe overflows, or -EFAULT if it happens with nothing
copied there.

In other words, ->read_iter() on those acts pretty much like
->splice_read().  Moreover, all generic_file_splice_read() users,
as well as many other ->splice_read() instances can be switched
to that scheme - that'll happen in the next commit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
[this certainly needs to be documented in more details]
 fs/splice.c            |   2 +-
 include/linux/splice.h |   1 +
 include/linux/uio.h    |  14 +-
 lib/iov_iter.c         | 390 ++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 401 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 085ad37..0daa7d1 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -524,7 +524,7 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 }
 EXPORT_SYMBOL(generic_file_splice_read);
 
-static const struct pipe_buf_operations default_pipe_buf_ops = {
+const struct pipe_buf_operations default_pipe_buf_ops = {
 	.can_merge = 0,
 	.confirm = generic_pipe_buf_confirm,
 	.release = generic_pipe_buf_release,
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 58b300f..00a2116 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -85,4 +85,5 @@ extern void splice_shrink_spd(struct splice_pipe_desc *);
 extern void spd_release_page(struct splice_pipe_desc *, unsigned int);
 
 extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
+extern const struct pipe_buf_operations default_pipe_buf_ops;
 #endif
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 1b5d1cd..c4fe1ab 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -13,6 +13,7 @@
 #include <uapi/linux/uio.h>
 
 struct page;
+struct pipe_inode_info;
 
 struct kvec {
 	void *iov_base; /* and that should *never* hold a userland pointer */
@@ -23,6 +24,7 @@ enum {
 	ITER_IOVEC = 0,
 	ITER_KVEC = 2,
 	ITER_BVEC = 4,
+	ITER_PIPE = 8,
 };
 
 struct iov_iter {
@@ -33,8 +35,12 @@ struct iov_iter {
 		const struct iovec *iov;
 		const struct kvec *kvec;
 		const struct bio_vec *bvec;
+		struct pipe_inode_info *pipe;
+	};
+	union {
+		unsigned long nr_segs;
+		int idx;
 	};
-	unsigned long nr_segs;
 };
 
 /*
@@ -64,7 +70,7 @@ static inline struct iovec iov_iter_iovec(const struct iov_iter *iter)
 }
 
 #define iov_for_each(iov, iter, start)				\
-	if (!((start).type & ITER_BVEC))			\
+	if (!((start).type & (ITER_BVEC | ITER_PIPE)))		\
 	for (iter = (start);					\
 	     (iter).count &&					\
 	     ((iov = iov_iter_iovec(&(iter))), 1);		\
@@ -94,6 +100,8 @@ void iov_iter_kvec(struct iov_iter *i, int direction, const struct kvec *kvec,
 			unsigned long nr_segs, size_t count);
 void iov_iter_bvec(struct iov_iter *i, int direction, const struct bio_vec *bvec,
 			unsigned long nr_segs, size_t count);
+void iov_iter_pipe(struct iov_iter *i, int direction, struct pipe_inode_info *pipe,
+			size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
@@ -109,7 +117,7 @@ static inline size_t iov_iter_count(struct iov_iter *i)
 
 static inline bool iter_is_iovec(struct iov_iter *i)
 {
-	return !(i->type & (ITER_BVEC | ITER_KVEC));
+	return !(i->type & (ITER_BVEC | ITER_KVEC | ITER_PIPE));
 }
 
 /*
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 9e8c738..02efc898 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -3,8 +3,11 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/splice.h>
 #include <net/checksum.h>
 
+#define PIPE_PARANOIA /* for now */
+
 #define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
 	size_t left;					\
 	size_t wanted = n;				\
@@ -290,6 +293,82 @@ done:
 	return wanted - bytes;
 }
 
+#ifdef PIPE_PARANOIA
+static bool sanity(const struct iov_iter *i)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	int idx = i->idx;
+	int delta = (pipe->curbuf + pipe->nrbufs - idx) & (pipe->buffers - 1);
+	if (i->iov_offset) {
+		struct pipe_buffer *p;
+		if (unlikely(delta != 1) || unlikely(!pipe->nrbufs))
+			goto Bad;	// must be at the last buffer...
+
+		p = &pipe->bufs[idx];
+		if (unlikely(p->offset + p->len != i->iov_offset))
+			goto Bad;	// ... at the end of segment
+	} else {
+		if (delta)
+			goto Bad;	// must be right after the last buffer
+	}
+	return true;
+Bad:
+	WARN_ON(1);
+	return false;
+}
+#else
+#define sanity(i) true
+#endif
+
+static inline int next_idx(int idx, struct pipe_inode_info *pipe)
+{
+	return (idx + 1) & (pipe->buffers - 1);
+}
+
+static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	struct pipe_buffer *buf;
+	size_t off;
+	int idx;
+
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	if (!sanity(i))
+		return 0;
+
+	off = i->iov_offset;
+	idx = i->idx;
+	buf = &pipe->bufs[idx];
+	if (off) {
+		if (offset == off && buf->page == page) {
+			/* merge with the last one */
+			buf->len += bytes;
+			i->iov_offset += bytes;
+			goto out;
+		}
+		idx = next_idx(idx, pipe);
+		buf = &pipe->bufs[idx];
+	}
+	if (idx == pipe->curbuf && pipe->nrbufs)
+		return 0;
+	pipe->nrbufs++;
+	buf->ops = &page_cache_pipe_buf_ops;
+	get_page(buf->page = page);
+	buf->offset = offset;
+	buf->len = bytes;
+	i->iov_offset = offset + bytes;
+	i->idx = idx;
+out:
+	i->count -= bytes;
+	return bytes;
+}
+
 /*
  * Fault in the first iovec of the given iov_iter, to a maximum length
  * of bytes. Returns 0 on success, or non-zero if the memory could not be
@@ -376,9 +455,98 @@ static void memzero_page(struct page *page, size_t offset, size_t len)
 	kunmap_atomic(addr);
 }
 
+static inline bool allocated(struct pipe_buffer *buf)
+{
+	return buf->ops == &default_pipe_buf_ops;
+}
+
+static inline void data_start(const struct iov_iter *i, int *idxp, size_t *offp)
+{
+	size_t off = i->iov_offset;
+	int idx = i->idx;
+	if (off && (!allocated(&i->pipe->bufs[idx]) || off == PAGE_SIZE)) {
+		idx = next_idx(idx, i->pipe);
+		off = 0;
+	}
+	*idxp = idx;
+	*offp = off;
+}
+
+static size_t push_pipe(struct iov_iter *i, size_t size,
+			int *idxp, size_t *offp)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	size_t off;
+	int idx;
+	ssize_t left;
+
+	if (unlikely(size > i->count))
+		size = i->count;
+	if (unlikely(!size))
+		return 0;
+
+	left = size;
+	data_start(i, &idx, &off);
+	*idxp = idx;
+	*offp = off;
+	if (off) {
+		left -= PAGE_SIZE - off;
+		if (left <= 0) {
+			pipe->bufs[idx].len += size;
+			return size;
+		}
+		pipe->bufs[idx].len = PAGE_SIZE;
+		idx = next_idx(idx, pipe);
+	}
+	while (idx != pipe->curbuf || !pipe->nrbufs) {
+		struct page *page = alloc_page(GFP_USER);
+		if (!page)
+			break;
+		pipe->nrbufs++;
+		pipe->bufs[idx].ops = &default_pipe_buf_ops;
+		pipe->bufs[idx].page = page;
+		pipe->bufs[idx].offset = 0;
+		if (left <= PAGE_SIZE) {
+			pipe->bufs[idx].len = left;
+			return size;
+		}
+		pipe->bufs[idx].len = PAGE_SIZE;
+		left -= PAGE_SIZE;
+		idx = next_idx(idx, pipe);
+	}
+	return size - left;
+}
+
+static size_t copy_pipe_to_iter(const void *addr, size_t bytes,
+				struct iov_iter *i)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	size_t n, off;
+	int idx;
+
+	if (!sanity(i))
+		return 0;
+
+	bytes = n = push_pipe(i, bytes, &idx, &off);
+	if (unlikely(!n))
+		return 0;
+	for ( ; n; idx = next_idx(idx, pipe), off = 0) {
+		size_t chunk = min_t(size_t, n, PAGE_SIZE - off);
+		memcpy_to_page(pipe->bufs[idx].page, off, addr, chunk);
+		i->idx = idx;
+		i->iov_offset = off + chunk;
+		n -= chunk;
+		addr += chunk;
+	}
+	i->count -= bytes;
+	return bytes;
+}
+
 size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 {
 	const char *from = addr;
+	if (unlikely(i->type & ITER_PIPE))
+		return copy_pipe_to_iter(addr, bytes, i);
 	iterate_and_advance(i, bytes, v,
 		__copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
 			       v.iov_len),
@@ -394,6 +562,10 @@ EXPORT_SYMBOL(copy_to_iter);
 size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
 	char *to = addr;
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user((to += v.iov_len) - v.iov_len, v.iov_base,
 				 v.iov_len),
@@ -409,6 +581,10 @@ EXPORT_SYMBOL(copy_from_iter);
 size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 {
 	char *to = addr;
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
@@ -429,14 +605,20 @@ size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
 		kunmap_atomic(kaddr);
 		return wanted;
-	} else
+	} else if (likely(!(i->type & ITER_PIPE)))
 		return copy_page_to_iter_iovec(page, offset, bytes, i);
+	else
+		return copy_page_to_iter_pipe(page, offset, bytes, i);
 }
 EXPORT_SYMBOL(copy_page_to_iter);
 
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
 	if (i->type & (ITER_BVEC|ITER_KVEC)) {
 		void *kaddr = kmap_atomic(page);
 		size_t wanted = copy_from_iter(kaddr + offset, bytes, i);
@@ -447,8 +629,34 @@ size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 }
 EXPORT_SYMBOL(copy_page_from_iter);
 
+static size_t pipe_zero(size_t bytes, struct iov_iter *i)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	size_t n, off;
+	int idx;
+
+	if (!sanity(i))
+		return 0;
+
+	bytes = n = push_pipe(i, bytes, &idx, &off);
+	if (unlikely(!n))
+		return 0;
+
+	for ( ; n; idx = next_idx(idx, pipe), off = 0) {
+		size_t chunk = min_t(size_t, n, PAGE_SIZE - off);
+		memzero_page(pipe->bufs[idx].page, off, chunk);
+		i->idx = idx;
+		i->iov_offset = off + chunk;
+		n -= chunk;
+	}
+	i->count -= bytes;
+	return bytes;
+}
+
 size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 {
+	if (unlikely(i->type & ITER_PIPE))
+		return pipe_zero(bytes, i);
 	iterate_and_advance(i, bytes, v,
 		__clear_user(v.iov_base, v.iov_len),
 		memzero_page(v.bv_page, v.bv_offset, v.bv_len),
@@ -463,6 +671,11 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
 	char *kaddr = kmap_atomic(page), *p = kaddr + offset;
+	if (unlikely(i->type & ITER_PIPE)) {
+		kunmap_atomic(kaddr);
+		WARN_ON(1);
+		return 0;
+	}
 	iterate_all_kinds(i, bytes, v,
 		__copy_from_user_inatomic((p += v.iov_len) - v.iov_len,
 					  v.iov_base, v.iov_len),
@@ -475,8 +688,55 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 }
 EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
 
+static void pipe_advance(struct iov_iter *i, size_t size)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	struct pipe_buffer *buf;
+	size_t off;
+	int idx;
+	
+	if (unlikely(i->count < size))
+		size = i->count;
+
+	idx = i->idx;
+	off = i->iov_offset;
+	if (size || off) {
+		/* take it relative to the beginning of buffer */
+		size += off - pipe->bufs[idx].offset;
+		while (1) {
+			buf = &pipe->bufs[idx];
+			if (size > buf->len) {
+				size -= buf->len;
+				idx = next_idx(idx, pipe);
+				off = 0;
+			} else {
+				buf->len = size;
+				i->idx = idx;
+				i->iov_offset = off = buf->offset + size;
+				break;
+			}
+		}
+		idx = next_idx(idx, pipe);
+	}
+	if (pipe->nrbufs) {
+		int unused = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
+		/* [curbuf,unused) is in use.  Free [idx,unused) */
+		while (idx != unused) {
+			buf = &pipe->bufs[idx];
+			buf->ops->release(pipe, buf);
+			buf->ops = NULL;
+			idx = next_idx(idx, pipe);
+			pipe->nrbufs--;
+		}
+	}
+}
+
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
+	if (unlikely(i->type & ITER_PIPE)) {
+		pipe_advance(i, size);
+		return;
+	}
 	iterate_and_advance(i, size, v, 0, 0, 0)
 }
 EXPORT_SYMBOL(iov_iter_advance);
@@ -486,6 +746,8 @@ EXPORT_SYMBOL(iov_iter_advance);
  */
 size_t iov_iter_single_seg_count(const struct iov_iter *i)
 {
+	if (unlikely(i->type & ITER_PIPE))
+		return i->count;	// it is a silly place, anyway
 	if (i->nr_segs == 1)
 		return i->count;
 	else if (i->type & ITER_BVEC)
@@ -521,6 +783,19 @@ void iov_iter_bvec(struct iov_iter *i, int direction,
 }
 EXPORT_SYMBOL(iov_iter_bvec);
 
+void iov_iter_pipe(struct iov_iter *i, int direction,
+			struct pipe_inode_info *pipe,
+			size_t count)
+{
+	BUG_ON(direction != ITER_PIPE);
+	i->type = direction;
+	i->pipe = pipe;
+	i->idx = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
+	i->iov_offset = 0;
+	i->count = count;
+}
+EXPORT_SYMBOL(iov_iter_pipe);
+
 unsigned long iov_iter_alignment(const struct iov_iter *i)
 {
 	unsigned long res = 0;
@@ -529,6 +804,11 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 	if (!size)
 		return 0;
 
+	if (unlikely(i->type & ITER_PIPE)) {
+		if (i->iov_offset && allocated(&i->pipe->bufs[i->idx]))
+			return size | i->iov_offset;
+		return size;
+	}
 	iterate_all_kinds(i, size, v,
 		(res |= (unsigned long)v.iov_base | v.iov_len, 0),
 		res |= v.bv_offset | v.bv_len,
@@ -545,6 +825,11 @@ unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
 	if (!size)
 		return 0;
 
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return ~0U;
+	}
+
 	iterate_all_kinds(i, size, v,
 		(res |= (!res ? 0 : (unsigned long)v.iov_base) |
 			(size != v.iov_len ? size : 0), 0),
@@ -557,6 +842,47 @@ unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
 }
 EXPORT_SYMBOL(iov_iter_gap_alignment);
 
+static inline size_t __pipe_get_pages(struct iov_iter *i,
+				size_t maxsize,
+				struct page **pages,
+				int idx,
+				size_t *start)
+{
+	struct pipe_inode_info *pipe = i->pipe;
+	size_t n = push_pipe(i, maxsize, &idx, start);
+	if (!n)
+		return 0;
+
+	maxsize = n;
+	n += *start;
+	while (n >= PAGE_SIZE) {
+		*pages++ = pipe->bufs[idx].page;
+		idx = next_idx(idx, pipe);
+		n -= PAGE_SIZE;
+	}
+
+	return maxsize;
+}
+
+static ssize_t pipe_get_pages(struct iov_iter *i,
+		   struct page **pages, size_t maxsize, unsigned maxpages,
+		   size_t *start)
+{
+	unsigned npages;
+	size_t capacity;
+	int idx;
+
+	if (!sanity(i))
+		return 0;
+
+	data_start(i, &idx, start);
+	/* some of this one + all after this one */
+	npages = ((i->pipe->curbuf - idx - 1) & (i->pipe->buffers - 1)) + 1;
+	capacity = min(npages,maxpages) * PAGE_SIZE - *start;
+
+	return __pipe_get_pages(i, min(maxsize, capacity), pages, idx, start);
+}
+
 ssize_t iov_iter_get_pages(struct iov_iter *i,
 		   struct page **pages, size_t maxsize, unsigned maxpages,
 		   size_t *start)
@@ -567,6 +893,8 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 	if (!maxsize)
 		return 0;
 
+	if (unlikely(i->type & ITER_PIPE))
+		return pipe_get_pages(i, pages, maxsize, maxpages, start);
 	iterate_all_kinds(i, maxsize, v, ({
 		unsigned long addr = (unsigned long)v.iov_base;
 		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
@@ -602,6 +930,37 @@ static struct page **get_pages_array(size_t n)
 	return p;
 }
 
+static ssize_t pipe_get_pages_alloc(struct iov_iter *i,
+		   struct page ***pages, size_t maxsize,
+		   size_t *start)
+{
+	struct page **p;
+	size_t n;
+	int idx;
+	int npages;
+
+	if (!sanity(i))
+		return 0;
+
+	data_start(i, &idx, start);
+	/* some of this one + all after this one */
+	npages = ((i->pipe->curbuf - idx - 1) & (i->pipe->buffers - 1)) + 1;
+	n = npages * PAGE_SIZE - *start;
+	if (maxsize > n)
+		maxsize = n;
+	else
+		npages = DIV_ROUND_UP(maxsize + *start, PAGE_SIZE);
+	p = get_pages_array(npages);
+	if (!p)
+		return -ENOMEM;
+	n = __pipe_get_pages(i, maxsize, p, idx, start);
+	if (n)
+		*pages = p;
+	else
+		kvfree(p);
+	return n;
+}
+
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
 		   size_t *start)
@@ -614,6 +973,8 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 	if (!maxsize)
 		return 0;
 
+	if (unlikely(i->type & ITER_PIPE))
+		return pipe_get_pages_alloc(i, pages, maxsize, start);
 	iterate_all_kinds(i, maxsize, v, ({
 		unsigned long addr = (unsigned long)v.iov_base;
 		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
@@ -655,6 +1016,10 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 	__wsum sum, next;
 	size_t off = 0;
 	sum = *csum;
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
 	iterate_and_advance(i, bytes, v, ({
 		int err = 0;
 		next = csum_and_copy_from_user(v.iov_base, 
@@ -693,6 +1058,10 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, __wsum *csum,
 	__wsum sum, next;
 	size_t off = 0;
 	sum = *csum;
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);	/* for now */
+		return 0;
+	}
 	iterate_and_advance(i, bytes, v, ({
 		int err = 0;
 		next = csum_and_copy_to_user((from += v.iov_len) - v.iov_len,
@@ -732,7 +1101,20 @@ int iov_iter_npages(const struct iov_iter *i, int maxpages)
 	if (!size)
 		return 0;
 
-	iterate_all_kinds(i, size, v, ({
+	if (unlikely(i->type & ITER_PIPE)) {
+		struct pipe_inode_info *pipe = i->pipe;
+		size_t off;
+		int idx;
+
+		if (!sanity(i))
+			return 0;
+
+		data_start(i, &idx, &off);
+		/* some of this one + all after this one */
+		npages = ((pipe->curbuf - idx - 1) & (pipe->buffers - 1)) + 1;
+		if (npages >= maxpages)
+			return maxpages;
+	} else iterate_all_kinds(i, size, v, ({
 		unsigned long p = (unsigned long)v.iov_base;
 		npages += DIV_ROUND_UP(p + v.iov_len, PAGE_SIZE)
 			- p / PAGE_SIZE;
@@ -757,6 +1139,10 @@ EXPORT_SYMBOL(iov_iter_npages);
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 {
 	*new = *old;
+	if (unlikely(new->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return NULL;
+	}
 	if (new->type & ITER_BVEC)
 		return new->bvec = kmemdup(new->bvec,
 				    new->nr_segs * sizeof(struct bio_vec),
-- 
2.9.3

