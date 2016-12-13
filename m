Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:54177 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbcLMXdq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Dec 2016 18:33:46 -0500
Date: Wed, 14 Dec 2016 10:31:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Block core changes for 4.10
Message-ID: <20161214103123.20d9b2d0@canb.auug.org.au>
In-Reply-To: <6176de36-7f4f-040b-f277-e872cc98eb5e@kernel.dk>
References: <6176de36-7f4f-040b-f277-e872cc98eb5e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Linus,

On Sun, 11 Dec 2016 18:52:29 -0700 Jens Axboe <axboe@kernel.dk> wrote:
>
> Note that this pull will throw 3 trivial merge conflicts, since we had
> patches that went into mainline after 4.9-rc1 (upon which this branch is
> based), and one that will not show up in block/blk-flush.c. The latter
> is due to a fix that went in for the flush code using an old request
> flag that is now changed to a per-request one. To ensure that this all
> goes smoothly, I just merged 4.9 with this branch and provide that as a
> reference:
> 
>   git://git.kernel.dk/linux-block.git for-4.10/merge
> 
> But really, the only one you to watch for is this line in
> block/blk-flush.c:
> 
>         /* for avoiding double accounting */
> 	rq->cmd_flags &= ~REQ_STARTED;
> 
> which should now be:
> 
>         rq->rq_flags &= ~RQF_STARTED;
> 
> and the three merge conflicts that do show up are trivially resolvable.

I have also been carrying a fix patch for the merge between the block
tree and the xfs tree:

Commits

  70fd76140a6c ("block,fs: use REQ_* flags directly")
  bbd7bb7017d5 ("block: move poll code to blk-mq")

from the block tree interacting with commit

  ff6a9292e6f6 ("iomap: implement direct I/O")

from the xfs tree.


From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 1 Dec 2016 13:45:33 +1100
Subject: [PATCH] iomap: fix up for blk_poll and WRITE_ODIRECT change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/iomap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index fc2446242935..c9d6c1176345 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -722,7 +722,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	get_page(page);
 	if (bio_add_page(bio, page, len, 0) != len)
 		BUG();
-	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_ODIRECT);
+	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
 
 	atomic_inc(&dio->ref);
 	return submit_bio(bio);
@@ -805,7 +805,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		if (dio->flags & IOMAP_DIO_WRITE) {
-			bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_ODIRECT);
+			bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
 			task_io_account_write(bio->bi_iter.bi_size);
 		} else {
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
@@ -930,7 +930,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, struct iomap_ops *ops,
 
 			if (!(iocb->ki_flags & IOCB_HIPRI) ||
 			    !dio->submit.last_queue ||
-			    !blk_poll(dio->submit.last_queue,
+			    !blk_mq_poll(dio->submit.last_queue,
 					dio->submit.cookie))
 				io_schedule();
 		}
-- 
2.10.2


-- 
Cheers,
Stephen Rothwell
