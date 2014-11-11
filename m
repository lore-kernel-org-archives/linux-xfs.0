Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 599E97F55
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 10:42:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44AEB8F8049
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 08:42:13 -0800 (PST)
Received: from mail-ob0-f171.google.com (mail-ob0-f171.google.com
	[209.85.214.171]) by cuda.sgi.com with ESMTP id
	q7Etj3CAcA5JNJ2K (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 08:42:12 -0800 (PST)
Received: by mail-ob0-f171.google.com with SMTP id wp18so7749375obc.30
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 08:42:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141111154250.GA16906@gmail.com>
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
	<87bnofnzop.fsf@rustcorp.com.au> <54614AE7.2080204@kernel.dk>
	<CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>
	<20141111154250.GA16906@gmail.com>
Date: Wed, 12 Nov 2014 00:42:11 +0800
Message-ID: <CACVXFVNXSmw=Gu_9JAtpF3uxupSMr4kN2ge-jnZMxZAMcaHrfw@mail.gmail.com>
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
From: Ming Lei <tom.leiming@gmail.com>
Content-Type: multipart/mixed; boundary=089e01634be8f258ff050797f529
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>

--089e01634be8f258ff050797f529
Content-Type: text/plain; charset=UTF-8

On Tue, Nov 11, 2014 at 11:42 PM, Dongsu Park
<dongsu.park@profitbricks.com> wrote:
> Hi Ming,
>
> On 11.11.2014 08:56, Ming Lei wrote:
>> On Tue, Nov 11, 2014 at 7:31 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> > Known, I'm afraid, Ming is looking into it.
>
> Actually I had also tried to reproduce this bug, without success.
> But today I happened to know how to trigger the bug, by coincidence,
> during testing other things.
>
> Try to run xfstests/generic/034. You'll see the crash immediately.
> Tested on a QEMU VM with kernel 3.18-rc4, virtio-blk, dm-flakey and xfs.
>
>> There is one obvious bug which should have been fixed by below
>> patch(0001-block-blk-merge-fix-blk_recount_segments.patch"):
>>
>> http://marc.info/?l=linux-virtualization&m=141562191719405&q=p3
>
> This patch didn't bring anything to me, as Lukas said.
>
>> And there might be another one, I appreciate someone can post
>> log which is printed by patch("blk-seg.patch") in below link if the
>> bug still can be triggered even with above fix:
>>
>> http://marc.info/?l=linux-virtualization&m=141473040618467&q=p3
>
> "blk_recount_segments: 1-1-1 vcnt-128 segs-128"
>
> As long as I understood so far, the reason is that bi_phys_segments gets
> sometimes bigger than queue_max_sectors() after blk_recount_segments().
> That happens no matter whether segments are recalculated or not.

I know the problem now, since bi_vcnt can't be used for cloned bio,
and the patch I sent last time is wrong too.

> I'm not completely sure about what to do, but how about the attached patch?
> It seems to work, according to several xfstests runs.
>
> Cheers,
> Dongsu
>
> ----
>
> From 1db98323931eb9ab430116c4d909d22222c16e22 Mon Sep 17 00:00:00 2001
> From: Dongsu Park <dongsu.park@profitbricks.com>
> Date: Tue, 11 Nov 2014 13:10:59 +0100
> Subject: [RFC PATCH] blk-merge: make bi_phys_segments consider also
>  queue_max_segments()
>
> When recounting the number of physical segments, the number of max
> segments of request_queue must be also taken into account.
> Otherwise bio->bi_phys_segments could get bigger than
> queue_max_segments(). Then this results in virtio_queue_rq() seeing
> req->nr_phys_segments that is greater than expected. Although the
> initial queue_max_segments was set to (vblk->sg_elems - 2), a request
> comes in with a larger value of nr_phys_segments, which triggers the
> BUG_ON() condition.
>
> This commit should fix a kernel crash in virtio_blk, which occurs
> especially frequently when it runs with blk-mq, device mapper, and xfs.
> The simplest way to reproduce this bug is to run xfstests/generic/034.
> Note, test 034 requires dm-flakey to be turned on in the kernel config.
>
> See the kernel trace below:
> ------------[ cut here ]------------
> kernel BUG at drivers/block/virtio_blk.c:172!
> invalid opcode: 0000 [#1] SMP
> CPU: 1 PID: 3343 Comm: mount Not tainted 3.18.0-rc4+ #55
> RIP: 0010:[<ffffffff81561027>]
>  [<ffffffff81561027>] virtio_queue_rq+0x277/0x280
> Call Trace:
>  [<ffffffff8142e908>] __blk_mq_run_hw_queue+0x1a8/0x300
>  [<ffffffff8142f00d>] blk_mq_run_hw_queue+0x6d/0x90
>  [<ffffffff8143003e>] blk_sq_make_request+0x23e/0x360
>  [<ffffffff81422e20>] generic_make_request+0xc0/0x110
>  [<ffffffff81422ed9>] submit_bio+0x69/0x130
>  [<ffffffff812f013d>] _xfs_buf_ioapply+0x2bd/0x410
>  [<ffffffff81315f38>] ? xlog_bread_noalign+0xa8/0xe0
>  [<ffffffff812f1bd1>] xfs_buf_submit_wait+0x61/0x1d0
>  [<ffffffff81315f38>] xlog_bread_noalign+0xa8/0xe0
>  [<ffffffff81316917>] xlog_bread+0x27/0x60
>  [<ffffffff8131ad11>] xlog_find_verify_cycle+0xe1/0x190
>  [<ffffffff8131b291>] xlog_find_head+0x2d1/0x3c0
>  [<ffffffff8131b3ad>] xlog_find_tail+0x2d/0x3f0
>  [<ffffffff8131b78e>] xlog_recover+0x1e/0xf0
>  [<ffffffff8130fbac>] xfs_log_mount+0x24c/0x2c0
>  [<ffffffff813075db>] xfs_mountfs+0x44b/0x7a0
>  [<ffffffff8130a98a>] xfs_fs_fill_super+0x2ba/0x330
>  [<ffffffff811cea64>] mount_bdev+0x194/0x1d0
>  [<ffffffff8130a6d0>] ? xfs_parseargs+0xbe0/0xbe0
>  [<ffffffff813089a5>] xfs_fs_mount+0x15/0x20
>  [<ffffffff811cf389>] mount_fs+0x39/0x1b0
>  [<ffffffff8117bf75>] ? __alloc_percpu+0x15/0x20
>  [<ffffffff811e9887>] vfs_kern_mount+0x67/0x110
>  [<ffffffff811ec584>] do_mount+0x204/0xad0
>  [<ffffffff811ed18b>] SyS_mount+0x8b/0xe0
>  [<ffffffff81788e12>] system_call_fastpath+0x12/0x17
> RIP [<ffffffff81561027>] virtio_queue_rq+0x277/0x280
> ---[ end trace ae3ec6426f011b5d ]---
>
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Ming Lei <tom.leiming@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jeff Layton <jlayton@poochiereds.net>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: virtualization@lists.linux-foundation.org
> ---
>  block/blk-merge.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index b3ac40a..d808601 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -103,13 +103,16 @@ void blk_recount_segments(struct request_queue *q, struct bio *bio)
>
>         if (no_sg_merge && !bio_flagged(bio, BIO_CLONED) &&
>                         merge_not_need)
> -               bio->bi_phys_segments = bio->bi_vcnt;
> +               bio->bi_phys_segments = min_t(unsigned int, bio->bi_vcnt,
> +                               queue_max_segments(q));
>         else {
>                 struct bio *nxt = bio->bi_next;
>
>                 bio->bi_next = NULL;
> -               bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio,
> -                               no_sg_merge && merge_not_need);
> +               bio->bi_phys_segments = min_t(unsigned int,
> +                               __blk_recalc_rq_segments(q, bio, no_sg_merge
> +                                       && merge_not_need),
> +                               queue_max_segments(q));
>                 bio->bi_next = nxt;
>         }

The above change may cause some data not written to/read from
device, and we have to merge if segments number will become
bigger than the limit.

The attached patch should fix the problem, and hope it is the last one, :-)


Thanks,
-- 
Ming Lei

--089e01634be8f258ff050797f529
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-block-blk-merge-fix-blk_recount_segments.patch"
Content-Disposition: attachment;
	filename="0001-block-blk-merge-fix-blk_recount_segments.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2dhiak90

RnJvbSA5Y2VkZWI4Y2ZkNDIwZWNmY2QzZTJiMmUwYmNiNjk5ZDM1YWUyYTAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8dG9tLmxlaW1pbmdAZ21haWwuY29tPgpEYXRl
OiBXZWQsIDEyIE5vdiAyMDE0IDAwOjE1OjQxICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmxvY2s6
IGJsay1tZXJnZTogZml4IGJsa19yZWNvdW50X3NlZ21lbnRzKCkKCkZvciBjbG9uZWQgYmlvLCBi
aW8tPmJpX3ZjbnQgY2FuJ3QgYmUgdXNlZCBhdCBhbGwsIGFuZCB3ZQpoYXZlIHJlc29ydCB0byBi
aW9fc2VnbWVudHMoKSB0byBmaWd1cmUgb3V0IGhvdyBtYW55CnNlZ21lbnQgdGhlcmUgYXJlIGlu
IHRoZSBiaW8uCgpTaWduZWQtb2ZmLWJ5OiBNaW5nIExlaSA8dG9tLmxlaW1pbmdAZ21haWwuY29t
PgotLS0KIGJsb2NrL2Jsay1tZXJnZS5jIHwgICAxOSArKysrKysrKysrKy0tLS0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9ibG9jay9ibGstbWVyZ2UuYyBiL2Jsb2NrL2Jsay1tZXJnZS5jCmluZGV4IGIzYWM0MGEuLjg5
Yjk3YjUgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1tZXJnZS5jCisrKyBiL2Jsb2NrL2Jsay1tZXJn
ZS5jCkBAIC05NywxOSArOTcsMjIgQEAgdm9pZCBibGtfcmVjYWxjX3JxX3NlZ21lbnRzKHN0cnVj
dCByZXF1ZXN0ICpycSkKIAogdm9pZCBibGtfcmVjb3VudF9zZWdtZW50cyhzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvKQogewotCWJvb2wgbm9fc2dfbWVyZ2UgPSAhIXRl
c3RfYml0KFFVRVVFX0ZMQUdfTk9fU0dfTUVSR0UsCi0JCQkmcS0+cXVldWVfZmxhZ3MpOwotCWJv
b2wgbWVyZ2Vfbm90X25lZWQgPSBiaW8tPmJpX3ZjbnQgPCBxdWV1ZV9tYXhfc2VnbWVudHMocSk7
CisJdW5zaWduZWQgc2hvcnQgc2VnX2NudDsKKworCS8qIGVzdGltYXRlIHNlZ21lbnQgbnVtYmVy
IGJ5IGJpX3ZjbnQgZm9yIG5vbi1jbG9uZWQgYmlvICovCisJaWYgKGJpb19mbGFnZ2VkKGJpbywg
QklPX0NMT05FRCkpCisJCXNlZ19jbnQgPSBiaW9fc2VnbWVudHMoYmlvKTsKKwllbHNlCisJCXNl
Z19jbnQgPSBiaW8tPmJpX3ZjbnQ7CiAKLQlpZiAobm9fc2dfbWVyZ2UgJiYgIWJpb19mbGFnZ2Vk
KGJpbywgQklPX0NMT05FRCkgJiYKLQkJCW1lcmdlX25vdF9uZWVkKQotCQliaW8tPmJpX3BoeXNf
c2VnbWVudHMgPSBiaW8tPmJpX3ZjbnQ7CisJaWYgKHRlc3RfYml0KFFVRVVFX0ZMQUdfTk9fU0df
TUVSR0UsICZxLT5xdWV1ZV9mbGFncykgJiYKKwkJCShzZWdfY250IDwgcXVldWVfbWF4X3NlZ21l
bnRzKHEpKSkKKwkJYmlvLT5iaV9waHlzX3NlZ21lbnRzID0gc2VnX2NudDsKIAllbHNlIHsKIAkJ
c3RydWN0IGJpbyAqbnh0ID0gYmlvLT5iaV9uZXh0OwogCiAJCWJpby0+YmlfbmV4dCA9IE5VTEw7
Ci0JCWJpby0+YmlfcGh5c19zZWdtZW50cyA9IF9fYmxrX3JlY2FsY19ycV9zZWdtZW50cyhxLCBi
aW8sCi0JCQkJbm9fc2dfbWVyZ2UgJiYgbWVyZ2Vfbm90X25lZWQpOworCQliaW8tPmJpX3BoeXNf
c2VnbWVudHMgPSBfX2Jsa19yZWNhbGNfcnFfc2VnbWVudHMocSwgYmlvLCBmYWxzZSk7CiAJCWJp
by0+YmlfbmV4dCA9IG54dDsKIAl9CiAKLS0gCjEuNy45LjUKCg==
--089e01634be8f258ff050797f529
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--089e01634be8f258ff050797f529--
