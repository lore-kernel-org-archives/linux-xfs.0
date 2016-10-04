Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:55504 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbcJDUMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 16:12:36 -0400
Date: Tue, 4 Oct 2016 21:12:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
Message-ID: <20161004201232.GA19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
 <20161003014218.GS19539@ZenIV.linux.org.uk>
 <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com>
 <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com>
 <20161003203539.GW19539@ZenIV.linux.org.uk>
 <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com>
 <20161004142805.GX19539@ZenIV.linux.org.uk>
 <307867218.381779.1475598088901.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <307867218.381779.1475598088901.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Tue, Oct 04, 2016 at 12:21:28PM -0400, CAI Qian wrote:
> 
> > Not enough information, unfortunately (descriptor in question opened
> > outside of that log, sendfile(out_fd=578, in_fd=578, offset=0x7f8318a07000,
> > count=0x3ffc00) doesn't tell what *offset was before the call) ;-/
> > 
> > Anyway, I've found and fixed a bug in pipe_advance(), which might or might
> > not help with those.  Could you try vfs.git#work.splice_read (or #for-next)
> > and see if these persist?
> I am afraid that this can also reproduced in the latest #for-next . The warning
> always showed up at the end of trinity run. I captured more information this time.

OK, let's try to get more information about what's going on (this is on top
of either for-next or work.splice_read):

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c97d661..a9cb9ff 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -313,6 +313,15 @@ static bool sanity(const struct iov_iter *i)
 	}
 	return true;
 Bad:
+	printk(KERN_ERR "idx = %d, offset = %zd\n", i->idx, i->iov_offset);
+	printk(KERN_ERR "curbuf = %d, nrbufs = %d, buffers = %d\n",
+			pipe->curbuf, pipe->nrbufs, pipe->buffers);
+	for (idx = 0; idx < pipe->buffers; idx++)
+		printk(KERN_ERR "[%p %p %d %d]\n",
+			pipe->bufs[idx].ops,
+			pipe->bufs[idx].page,
+			pipe->bufs[idx].offset,
+			pipe->bufs[idx].len);
 	WARN_ON(1);
 	return false;
 }
@@ -339,8 +348,11 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 	if (unlikely(!bytes))
 		return 0;
 
-	if (!sanity(i))
+	if (!sanity(i)) {
+		printk(KERN_ERR "page = %p, offset = %zd, size = %zd\n",
+			page, offset, bytes);
 		return 0;
+	}
 
 	off = i->iov_offset;
 	idx = i->idx;
@@ -518,6 +530,8 @@ static size_t copy_pipe_to_iter(const void *addr, size_t bytes,
 		addr += chunk;
 	}
 	i->count -= bytes;
+	if (!sanity(i))
+		printk(KERN_ERR "buggered after copy_to_iter\n");
 	return bytes;
 }
 
@@ -629,6 +643,8 @@ static size_t pipe_zero(size_t bytes, struct iov_iter *i)
 		n -= chunk;
 	}
 	i->count -= bytes;
+	if (!sanity(i))
+		printk(KERN_ERR "buggered after zero_iter\n");
 	return bytes;
 }
 
@@ -673,6 +689,8 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 	struct pipe_buffer *buf;
 	int idx = i->idx;
 	size_t off = i->iov_offset;
+	struct iov_iter orig = *i;
+	size_t orig_size = size;
 	
 	if (unlikely(i->count < size))
 		size = i->count;
@@ -702,6 +720,9 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 			pipe->nrbufs--;
 		}
 	}
+	if (!sanity(i))
+		printk(KERN_ERR "buggered pipe_advance by %zd from [%d.%zd]",
+			orig_size, orig.idx, orig.iov_offset);
 }
 
 void iov_iter_advance(struct iov_iter *i, size_t size)
