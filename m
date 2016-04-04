Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 539E57CA0
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 20:28:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA9B3AC003
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 18:28:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	b0uj7SywtGaKPKGB for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2016 18:28:51 -0700 (PDT)
Date: Mon, 4 Apr 2016 11:28:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] fs: introduce iomap infrastructure
Message-ID: <20160404012849.GB11238@dastard>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
	<1457989370-6904-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457989370-6904-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Mar 14, 2016 at 10:02:45PM +0100, Christoph Hellwig wrote:
> Add infrastructure for multipage buffered writes.  This is implemented
> using an main iterator that applies an actor function to a range that
> can be written.
> 
> This infrastucture is used to implement a buffered write helper, one
> to zero file ranges and one to implement the ->page_mkwrite VM
> operations.  All of them borrow a fair amount of code from fs/buffers.
> for now by using an internal version of __block_write_begin that
> gets passed an iomap and builds the corresponding buffer head.
> 
> The file system is gets a set of paired ->iomap_begin and ->iomap_end
> calls which allow it to map/reserve a range and get a notification
> once the write code is finished with it.
> 
> Based on earlier code from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +/*
> + * Execute a iomap write on a segment of the mapping that spans a
> + * contiguous range of pages that have identical block mapping state.
> + *
> + * This avoids the need to map pages individually, do individual allocations
> + * for each page and most importantly avoid the need for filesystem specific
> + * locking per page. Instead, all the operations are amortised over the entire
> + * range of pages. It is assumed that the filesystems will lock whatever
> + * resources they require in the iomap_begin call, and release them in the
> + * iomap_end call.
> + */
> +static ssize_t
> +iomap_write_segment(struct inode *inode, loff_t pos, ssize_t length,
> +		unsigned flags, struct iomap_ops *ops, void *data,
> +		write_actor_t actor)

This requires external iteration to write the entire range required
if the allocation does not cover the entire length requested (i.e.
written < length).

Also, if the actor returns an error into written, that gets ignored
and the return status is whatever the ->iomap_end call returns.

....

> +int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> +		struct iomap_ops *ops)
> +{
> +	struct page *page = vmf->page;
> +	struct inode *inode = file_inode(vma->vm_file);
> +	unsigned long length;
> +	loff_t size;
> +	int ret;
> +
> +	lock_page(page);
> +	size = i_size_read(inode);
> +	if ((page->mapping != inode->i_mapping) ||
> +	    (page_offset(page) > size)) {
> +		/* We overload EFAULT to mean page got truncated */
> +		ret = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	/* page is wholly or partially inside EOF */
> +	if (((page->index + 1) << PAGE_CACHE_SHIFT) > size)
> +		length = size & ~PAGE_CACHE_MASK;
> +	else
> +		length = PAGE_CACHE_SIZE;
> +
> +	ret = iomap_write_segment(inode, page_offset(page), length,
> +			IOMAP_ALLOCATE, ops, page, iomap_page_mkwrite_actor);
> +	if (unlikely(ret < 0))
> +		goto out_unlock;
> +	set_page_dirty(page);
> +	wait_for_stable_page(page);
> +	return 0;
> +out_unlock:
> +	unlock_page(page);
> +	return ret;
> +}

Because we don't handle short segment writes here,
iomap_page_mkwrite() fails to allocate blocks on partial pages when
block size < page size. This can be seen by generic/030 on XFS with
a 1k block size.

Patch below fixes the issue, as well as the fact that
iomap_page_mkwrite_actor() needs to return the count of bytes
"written", not zero on success for iomap_write_segment() to do the
right thing on multi-segment writes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

iomap: fix page_mkwrite on bs < ps

Fixes generic/030.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d4528cb..c4d3511 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -337,10 +337,16 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, ssize_t length,
 	int ret;
 
 	ret = __block_write_begin_int(page, 0, length, NULL, iomap);
-	if (!ret)
-		ret = block_commit_write(page, 0, length);
+	if (ret)
+		return ret;
+
+	/*
+	 * block_commit_write always returns 0, we need to return the length we
+	 * successfully allocated.
+	 */
+	block_commit_write(page, 0, length);
+	return length;
 
-	return ret;
 }
 
 int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
@@ -350,7 +356,8 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct inode *inode = file_inode(vma->vm_file);
 	unsigned long length;
 	loff_t size;
-	int ret;
+	loff_t offset;
+	ssize_t ret;
 
 	lock_page(page);
 	size = i_size_read(inode);
@@ -367,10 +374,17 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	else
 		length = PAGE_CACHE_SIZE;
 
-	ret = iomap_write_segment(inode, page_offset(page), length,
-			IOMAP_ALLOCATE, ops, page, iomap_page_mkwrite_actor);
-	if (unlikely(ret < 0))
-		goto out_unlock;
+	offset = page_offset(page);
+	while (length > 0) {
+		ret = iomap_write_segment(inode, offset, length,
+				IOMAP_ALLOCATE, ops, page,
+				iomap_page_mkwrite_actor);
+		if (unlikely(ret < 0))
+			goto out_unlock;
+		offset += ret;
+		length -= ret;
+	}
+
 	set_page_dirty(page);
 	wait_for_stable_page(page);
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
