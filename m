Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44190 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdIKUHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 16:07:17 -0400
Date: Mon, 11 Sep 2017 21:07:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170911200713.GK5426@ZenIV.linux.org.uk>
References: <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911003113.GO17782@dastard>
 <20170911033222.GI5426@ZenIV.linux.org.uk>
 <20170911064440.GP17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911064440.GP17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 04:44:40PM +1000, Dave Chinner wrote:

> > iov_iter_get_pages() for pipe-backed destination does page allocation
> > and inserts freshly allocated pages into pipe.
> 
> Oh, it's hidden more layers down than the code implied I needed to
> look.
> 
> i.e. there's no obvious clue in the function names that there is
> allocation happening in these paths (get_pipe_pages ->
> __get_pipe_pages -> push_pipe -> page allocation). The function
> names imply it's getting a reference to pages (like
> (get_user_pages()) and the fact it does allocation is inconsistent
> with it's naming.  Worse, when push_pipe() fails to allocate pages,
> the error __get_pipe_pages() returns is -EFAULT, which further hides
> the fact push_pipe() does memory allocation that can fail....
> 
> And then there's the companion interface that implies page
> allocation: pipe_get_pages_alloc(). Which brings me back to there
> being no obvious clue while reading the code from the top down that
> pages are being allocated in push_pipe()....
> 
> Comments and documentation for this code would help, but I can't
> find any of that, either. Hence I assumed naming followed familiar
> patterns and so mistook these interfaces being one that does page
> allocation and the other for getting references to pre-existing
> pages.....

_NONE_ of those is a public interface - they are all static, to start
with.

The whole damn point is to have normal ->read_iter() work for read-to-pipe
without changes.  That's why -EFAULT as error (rather than some other
mechanism for saying that pipe is full), etc.

Filesystem should *not* be changed to use that.  At all.  As far as it is
concerned,
	copy_to_iter()
	copy_page_to_iter()
	iov_iter_get_pages()
	iov_iter_get_pages_alloc()
	iov_iter_advance()
are black boxes.

Note that one of the bugs there applies to normal read() as well - if you
are reading from a hole in file into an array with a read-only page in
the middle, you want a short read.  Ignoring return value from iov_iter_zero()
is wrong for iovec-backed case as well as for pipes.

Another one manages to work for iovec-backed case, albeit with rather odd
resulting semantics.  readv(2) is underspecified (to put it politely) enough
for compliance, but it's still bloody strange.  Namely, if you have a contiguous
50Mb chunk of file on disk and run into e.g. a failure to fault the destination
pages in halfway through that extent, you act as if *nothing* in the damn thing
had been read, nevermind that 25Mb had been actually already read and that had
there been a discontinuity 5Mb prior, the first 20Mb would've been reported
read just fine.

Strictly speaking that behaviour doesn't violate POSIX.  It is, however,
atrocious from the QoI standpoint, and for no good reason whatsoever.
It's quite easy to do better, and doing so would've eliminated the problems
in pipe-backed case as well (see below).  In addition to that, I would
consider teaching bio_iov_iter_get_pages() to take the maximal bio size
as an explict argument.  That would've killed the need of copying the
iterator and calling iov_iter_advance() in iomap_dio_actor() at all.
Anyway, the minimal candidate fix follows; it won't do anything about
the WARN_ON() in there, seeing that those are deliberate "program is
doing something bogus" things, but it should eliminate all crap with
->splice_read() misreporting the amount of data it has copied.

diff --git a/fs/iomap.c b/fs/iomap.c
index 269b24a01f32..836fe27b00e2 100644
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
@@ -880,6 +881,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	}
 
 	do {
+		size_t n;
 		if (dio->error)
 			return 0;
 
@@ -897,17 +899,21 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 			return ret;
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
 
@@ -923,9 +929,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		if (pad)
 			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
 	}
-
-	iov_iter_advance(dio->submit.iter, length);
-	return length;
+	return copied;
 }
 
 ssize_t
