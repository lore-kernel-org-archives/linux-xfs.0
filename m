Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44540 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdIKURL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 16:17:11 -0400
Date: Mon, 11 Sep 2017 21:17:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170911201709.GL5426@ZenIV.linux.org.uk>
References: <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911003113.GO17782@dastard>
 <20170911033222.GI5426@ZenIV.linux.org.uk>
 <20170911064440.GP17782@dastard>
 <20170911200713.GK5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911200713.GK5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 09:07:13PM +0100, Al Viro wrote:
> Strictly speaking that behaviour doesn't violate POSIX.  It is, however,
> atrocious from the QoI standpoint, and for no good reason whatsoever.
> It's quite easy to do better, and doing so would've eliminated the problems
> in pipe-backed case as well (see below).  In addition to that, I would
> consider teaching bio_iov_iter_get_pages() to take the maximal bio size
> as an explict argument.  That would've killed the need of copying the
> iterator and calling iov_iter_advance() in iomap_dio_actor() at all.
> Anyway, the minimal candidate fix follows; it won't do anything about
> the WARN_ON() in there, seeing that those are deliberate "program is
> doing something bogus" things, but it should eliminate all crap with
> ->splice_read() misreporting the amount of data it has copied.

... and after minimal testing and fixing a braino in "found an IO error"
case, that's

diff --git a/fs/iomap.c b/fs/iomap.c
index 269b24a01f32..012e1f247e13 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -832,6 +832,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	struct bio *bio;
 	bool need_zeroout = false;
 	int nr_pages, ret;
+	size_t copied = 0;
 
 	if ((pos | length | align) & ((1 << blkbits) - 1))
 		return -EINVAL;
@@ -843,7 +844,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		/*FALLTHRU*/
 	case IOMAP_UNWRITTEN:
 		if (!(dio->flags & IOMAP_DIO_WRITE)) {
-			iov_iter_zero(length, dio->submit.iter);
+			length = iov_iter_zero(length, dio->submit.iter);
 			dio->size += length;
 			return length;
 		}
@@ -880,8 +881,11 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	}
 
 	do {
-		if (dio->error)
+		size_t n;
+		if (dio->error) {
+			iov_iter_revert(dio->submit.iter, copied);
 			return 0;
+		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
 		bio_set_dev(bio, iomap->bdev);
@@ -894,20 +898,24 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		ret = bio_iov_iter_get_pages(bio, &iter);
 		if (unlikely(ret)) {
 			bio_put(bio);
-			return ret;
+			return copied ? copied : ret;
 		}
 
+		n = bio->bi_iter.bi_size;
 		if (dio->flags & IOMAP_DIO_WRITE) {
 			bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
-			task_io_account_write(bio->bi_iter.bi_size);
+			task_io_account_write(n);
 		} else {
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 			if (dio->flags & IOMAP_DIO_DIRTY)
 				bio_set_pages_dirty(bio);
 		}
 
-		dio->size += bio->bi_iter.bi_size;
-		pos += bio->bi_iter.bi_size;
+		iov_iter_advance(dio->submit.iter, n);
+
+		dio->size += n;
+		pos += n;
+		copied += n;
 
 		nr_pages = iov_iter_npages(&iter, BIO_MAX_PAGES);
 
@@ -923,9 +931,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		if (pad)
 			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
 	}
-
-	iov_iter_advance(dio->submit.iter, length);
-	return length;
+	return copied;
 }
 
 ssize_t
