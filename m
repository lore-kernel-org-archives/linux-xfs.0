Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40194 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbcJEQHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 12:07:25 -0400
Date: Wed, 5 Oct 2016 17:07:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
Message-ID: <20161005160720.GD19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com>
 <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com>
 <20161003203539.GW19539@ZenIV.linux.org.uk>
 <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com>
 <20161004142805.GX19539@ZenIV.linux.org.uk>
 <307867218.381779.1475598088901.JavaMail.zimbra@redhat.com>
 <20161004201232.GA19539@ZenIV.linux.org.uk>
 <2021832942.615635.1475677846489.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2021832942.615635.1475677846489.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Wed, Oct 05, 2016 at 10:30:46AM -0400, CAI Qian wrote:

> [  856.537452] idx = 0, offset = 12
> [  856.541066] curbuf = 0, nrbufs = 1, buffers = 1
					^^^^^^^^^^^^

Lovely - that's pretty much guaranteed to make sanity() spew false
positives.
        int delta = (pipe->curbuf + pipe->nrbufs - idx) & (pipe->buffers - 1);
        if (i->iov_offset) {
                struct pipe_buffer *p;
                if (unlikely(delta != 1) || unlikely(!pipe->nrbufs))
                        goto Bad;       // must be at the last buffer...
and at the last buffer it is - idx == (curbuf + nrbufs - 1) % pipe->buffers.
The test would've done the right thing if pipe->buffers had been at least 2,
but...  OK, the patch below ought to fix those; could you check if anything
remains with it?

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c97d661..0ce3411 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -298,21 +298,32 @@ static bool sanity(const struct iov_iter *i)
 {
 	struct pipe_inode_info *pipe = i->pipe;
 	int idx = i->idx;
-	int delta = (pipe->curbuf + pipe->nrbufs - idx) & (pipe->buffers - 1);
+	int next = pipe->curbuf + pipe->nrbufs;
 	if (i->iov_offset) {
 		struct pipe_buffer *p;
-		if (unlikely(delta != 1) || unlikely(!pipe->nrbufs))
+		if (unlikely(!pipe->nrbufs))
+			goto Bad;	// pipe must be non-empty
+		if (unlikely(idx != ((next - 1) & (pipe->buffers - 1))))
 			goto Bad;	// must be at the last buffer...
 
 		p = &pipe->bufs[idx];
 		if (unlikely(p->offset + p->len != i->iov_offset))
 			goto Bad;	// ... at the end of segment
 	} else {
-		if (delta)
+		if (idx != (next & (pipe->buffers - 1)))
 			goto Bad;	// must be right after the last buffer
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
