Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D14537F47
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 09:42:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A04438F804C
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 07:42:57 -0800 (PST)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
	[209.85.212.170]) by cuda.sgi.com with ESMTP id
	8ORDK74pjBkfCBld (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 07:42:55 -0800 (PST)
Received: by mail-wi0-f170.google.com with SMTP id r20so2179875wiv.1
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 07:42:54 -0800 (PST)
Date: Tue, 11 Nov 2014 16:42:50 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
Message-ID: <20141111154250.GA16906@gmail.com>
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
	<87bnofnzop.fsf@rustcorp.com.au> <54614AE7.2080204@kernel.dk>
	<CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>
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
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>

Hi Ming,

On 11.11.2014 08:56, Ming Lei wrote:
> On Tue, Nov 11, 2014 at 7:31 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > Known, I'm afraid, Ming is looking into it.

Actually I had also tried to reproduce this bug, without success.
But today I happened to know how to trigger the bug, by coincidence,
during testing other things.

Try to run xfstests/generic/034. You'll see the crash immediately.
Tested on a QEMU VM with kernel 3.18-rc4, virtio-blk, dm-flakey and xfs.

> There is one obvious bug which should have been fixed by below
> patch(0001-block-blk-merge-fix-blk_recount_segments.patch"):
> 
> http://marc.info/?l=linux-virtualization&m=141562191719405&q=p3

This patch didn't bring anything to me, as Lukas said.

> And there might be another one, I appreciate someone can post
> log which is printed by patch("blk-seg.patch") in below link if the
> bug still can be triggered even with above fix:
> 
> http://marc.info/?l=linux-virtualization&m=141473040618467&q=p3

"blk_recount_segments: 1-1-1 vcnt-128 segs-128"

As long as I understood so far, the reason is that bi_phys_segments gets
sometimes bigger than queue_max_sectors() after blk_recount_segments().
That happens no matter whether segments are recalculated or not.

I'm not completely sure about what to do, but how about the attached patch?
It seems to work, according to several xfstests runs.

Cheers,
Dongsu

----

>From 1db98323931eb9ab430116c4d909d22222c16e22 Mon Sep 17 00:00:00 2001
From: Dongsu Park <dongsu.park@profitbricks.com>
Date: Tue, 11 Nov 2014 13:10:59 +0100
Subject: [RFC PATCH] blk-merge: make bi_phys_segments consider also
 queue_max_segments()

When recounting the number of physical segments, the number of max
segments of request_queue must be also taken into account.
Otherwise bio->bi_phys_segments could get bigger than
queue_max_segments(). Then this results in virtio_queue_rq() seeing
req->nr_phys_segments that is greater than expected. Although the
initial queue_max_segments was set to (vblk->sg_elems - 2), a request
comes in with a larger value of nr_phys_segments, which triggers the
BUG_ON() condition.

This commit should fix a kernel crash in virtio_blk, which occurs
especially frequently when it runs with blk-mq, device mapper, and xfs.
The simplest way to reproduce this bug is to run xfstests/generic/034.
Note, test 034 requires dm-flakey to be turned on in the kernel config.

See the kernel trace below:
------------[ cut here ]------------
kernel BUG at drivers/block/virtio_blk.c:172!
invalid opcode: 0000 [#1] SMP
CPU: 1 PID: 3343 Comm: mount Not tainted 3.18.0-rc4+ #55
RIP: 0010:[<ffffffff81561027>]
 [<ffffffff81561027>] virtio_queue_rq+0x277/0x280
Call Trace:
 [<ffffffff8142e908>] __blk_mq_run_hw_queue+0x1a8/0x300
 [<ffffffff8142f00d>] blk_mq_run_hw_queue+0x6d/0x90
 [<ffffffff8143003e>] blk_sq_make_request+0x23e/0x360
 [<ffffffff81422e20>] generic_make_request+0xc0/0x110
 [<ffffffff81422ed9>] submit_bio+0x69/0x130
 [<ffffffff812f013d>] _xfs_buf_ioapply+0x2bd/0x410
 [<ffffffff81315f38>] ? xlog_bread_noalign+0xa8/0xe0
 [<ffffffff812f1bd1>] xfs_buf_submit_wait+0x61/0x1d0
 [<ffffffff81315f38>] xlog_bread_noalign+0xa8/0xe0
 [<ffffffff81316917>] xlog_bread+0x27/0x60
 [<ffffffff8131ad11>] xlog_find_verify_cycle+0xe1/0x190
 [<ffffffff8131b291>] xlog_find_head+0x2d1/0x3c0
 [<ffffffff8131b3ad>] xlog_find_tail+0x2d/0x3f0
 [<ffffffff8131b78e>] xlog_recover+0x1e/0xf0
 [<ffffffff8130fbac>] xfs_log_mount+0x24c/0x2c0
 [<ffffffff813075db>] xfs_mountfs+0x44b/0x7a0
 [<ffffffff8130a98a>] xfs_fs_fill_super+0x2ba/0x330
 [<ffffffff811cea64>] mount_bdev+0x194/0x1d0
 [<ffffffff8130a6d0>] ? xfs_parseargs+0xbe0/0xbe0
 [<ffffffff813089a5>] xfs_fs_mount+0x15/0x20
 [<ffffffff811cf389>] mount_fs+0x39/0x1b0
 [<ffffffff8117bf75>] ? __alloc_percpu+0x15/0x20
 [<ffffffff811e9887>] vfs_kern_mount+0x67/0x110
 [<ffffffff811ec584>] do_mount+0x204/0xad0
 [<ffffffff811ed18b>] SyS_mount+0x8b/0xe0
 [<ffffffff81788e12>] system_call_fastpath+0x12/0x17
RIP [<ffffffff81561027>] virtio_queue_rq+0x277/0x280
---[ end trace ae3ec6426f011b5d ]---

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: virtualization@lists.linux-foundation.org
---
 block/blk-merge.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b3ac40a..d808601 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -103,13 +103,16 @@ void blk_recount_segments(struct request_queue *q, struct bio *bio)
 
 	if (no_sg_merge && !bio_flagged(bio, BIO_CLONED) &&
 			merge_not_need)
-		bio->bi_phys_segments = bio->bi_vcnt;
+		bio->bi_phys_segments = min_t(unsigned int, bio->bi_vcnt,
+				queue_max_segments(q));
 	else {
 		struct bio *nxt = bio->bi_next;
 
 		bio->bi_next = NULL;
-		bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio,
-				no_sg_merge && merge_not_need);
+		bio->bi_phys_segments = min_t(unsigned int,
+				__blk_recalc_rq_segments(q, bio, no_sg_merge
+					&& merge_not_need),
+				queue_max_segments(q));
 		bio->bi_next = nxt;
 	}
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
