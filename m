Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35709 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbfBSQ2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Feb 2019 11:28:23 -0500
Message-ID: <1550593699.31902.115.camel@acm.org>
Subject: Re: [dm-devel] [PATCH V15 00/18] block: support multi-page bvec
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 19 Feb 2019 08:28:19 -0800
In-Reply-To: <20190217131128.GB7296@ming.t460p>
References: <20190215111324.30129-1-ming.lei@redhat.com>
         <c52b6a8b-d1d4-67ff-f81c-371d09cc6d5b@kernel.dk>
         <1550250855.31902.102.camel@acm.org> <20190217131128.GB7296@ming.t460p>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Sun, 2019-02-17 at 21:11 +-0800, Ming Lei wrote:
+AD4 The following patch should fix this issue:
+AD4 
+AD4 
+AD4 diff --git a/block/blk-merge.c b/block/blk-merge.c
+AD4 index bed065904677..066b66430523 100644
+AD4 --- a/block/blk-merge.c
+AD4 +-+-+- b/block/blk-merge.c
+AD4 +AEAAQA -363,13 +-363,15 +AEAAQA static unsigned int +AF8AXw-blk+AF8-recalc+AF8-rq+AF8-segments(struct request+AF8-queue +ACo-q,
+AD4  	struct bio+AF8-vec bv, bvprv +AD0 +AHs NULL +AH0AOw
+AD4  	int prev +AD0 0+ADs
+AD4  	unsigned int seg+AF8-size, nr+AF8-phys+AF8-segs+ADs
+AD4 -	unsigned front+AF8-seg+AF8-size +AD0 bio-+AD4-bi+AF8-seg+AF8-front+AF8-size+ADs
+AD4 +-	unsigned front+AF8-seg+AF8-size+ADs
+AD4  	struct bio +ACo-fbio, +ACo-bbio+ADs
+AD4  	struct bvec+AF8-iter iter+ADs
+AD4  
+AD4  	if (+ACE-bio)
+AD4  		return 0+ADs
+AD4  
+AD4 +-	front+AF8-seg+AF8-size +AD0 bio-+AD4-bi+AF8-seg+AF8-front+AF8-size+ADs
+AD4 +-
+AD4  	switch (bio+AF8-op(bio)) +AHs
+AD4  	case REQ+AF8-OP+AF8-DISCARD:
+AD4  	case REQ+AF8-OP+AF8-SECURE+AF8-ERASE:

Hi Ming,

With this patch applied test nvmeof-mp/002 fails as follows:

+AFs  694.700400+AF0 kernel BUG at lib/sg+AF8-pool.c:103+ACE
+AFs  694.705932+AF0 invalid opcode: 0000 +AFsAIw-1+AF0 PREEMPT SMP KASAN
+AFs  694.708297+AF0 CPU: 2 PID: 349 Comm: kworker/2:1H Tainted: G    B             5.0.0-rc6-dbg+- +ACM-2
+AFs  694.711730+AF0 Hardware name: QEMU Standard PC (i440FX +- PIIX, 1996), BIOS 1.10.2-1 04/01/2014
+AFs  694.715113+AF0 Workqueue: kblockd blk+AF8-mq+AF8-run+AF8-work+AF8-fn
+AFs  694.716894+AF0 RIP: 0010:sg+AF8-alloc+AF8-table+AF8-chained+-0xe5/0xf0
+AFs  694.758222+AF0 Call Trace:
+AFs  694.759645+AF0  nvme+AF8-rdma+AF8-queue+AF8-rq+-0x2aa/0xcc0 +AFs-nvme+AF8-rdma+AF0
+AFs  694.764915+AF0  blk+AF8-mq+AF8-try+AF8-issue+AF8-directly+-0x2a5/0x4b0
+AFs  694.771779+AF0  blk+AF8-insert+AF8-cloned+AF8-request+-0x11e/0x1c0
+AFs  694.778417+AF0  dm+AF8-mq+AF8-queue+AF8-rq+-0x3d1/0x770
+AFs  694.793400+AF0  blk+AF8-mq+AF8-dispatch+AF8-rq+AF8-list+-0x5fc/0xb10
+AFs  694.798386+AF0  blk+AF8-mq+AF8-sched+AF8-dispatch+AF8-requests+-0x2f7/0x300
+AFs  694.803180+AF0  +AF8AXw-blk+AF8-mq+AF8-run+AF8-hw+AF8-queue+-0xd6/0x180
+AFs  694.808933+AF0  blk+AF8-mq+AF8-run+AF8-work+AF8-fn+-0x27/0x30
+AFs  694.810315+AF0  process+AF8-one+AF8-work+-0x4f1/0xa40
+AFs  694.813178+AF0  worker+AF8-thread+-0x67/0x5b0
+AFs  694.814487+AF0  kthread+-0x1cf/0x1f0
+AFs  694.819134+AF0  ret+AF8-from+AF8-fork+-0x24/0x30

The code in sg+AF8-pool.c that triggers the BUG() statement is as follows:

int sg+AF8-alloc+AF8-table+AF8-chained(struct sg+AF8-table +ACo-table, int nents,
		struct scatterlist +ACo-first+AF8-chunk)
+AHs
	int ret+ADs

	BUG+AF8-ON(+ACE-nents)+ADs
+AFs ... +AF0

Bart.
