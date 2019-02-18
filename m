Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfBRHtk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Feb 2019 02:49:40 -0500
Date: Mon, 18 Feb 2019 15:49:08 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH V15 00/18] block: support multi-page bvec
Message-ID: <20190218074907.GA806@ming.t460p>
References: <20190215111324.30129-1-ming.lei@redhat.com>
 <c52b6a8b-d1d4-67ff-f81c-371d09cc6d5b@kernel.dk>
 <1550250855.31902.102.camel@acm.org>
 <18c711a9-ca13-885d-43cd-4d48e683a6a2@kernel.dk>
 <20190217131332.GC7296@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190217131332.GC7296@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Sun, Feb 17, 2019 at 09:13:32PM +0800, Ming Lei wrote:
> On Fri, Feb 15, 2019 at 10:59:47AM -0700, Jens Axboe wrote:
> > On 2/15/19 10:14 AM, Bart Van Assche wrote:
> > > On Fri, 2019-02-15 at 08:49 -0700, Jens Axboe wrote:
> > >> On 2/15/19 4:13 AM, Ming Lei wrote:
> > >>> This patchset brings multi-page bvec into block layer:
> > >>
> > >> Applied, thanks Ming. Let's hope it sticks!
> > > 
> > > Hi Jens and Ming,
> > > 
> > > Test nvmeof-mp/002 fails with Jens' for-next branch from this morning.
> > > I have not yet tried to figure out which patch introduced the failure.
> > > Anyway, this is what I see in the kernel log for test nvmeof-mp/002:
> > > 
> > > [  475.611363] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> > > [  475.621188] #PF error: [normal kernel read fault]
> > > [  475.623148] PGD 0 P4D 0  
> > > [  475.624737] Oops: 0000 [#1] PREEMPT SMP KASAN
> > > [  475.626628] CPU: 1 PID: 277 Comm: kworker/1:1H Tainted: G    B             5.0.0-rc6-dbg+ #1
> > > [  475.630232] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> > > [  475.633855] Workqueue: kblockd blk_mq_requeue_work
> > > [  475.635777] RIP: 0010:__blk_recalc_rq_segments+0xbe/0x590
> > > [  475.670948] Call Trace:
> > > [  475.693515]  blk_recalc_rq_segments+0x2f/0x50
> > > [  475.695081]  blk_insert_cloned_request+0xbb/0x1c0
> > > [  475.701142]  dm_mq_queue_rq+0x3d1/0x770
> > > [  475.707225]  blk_mq_dispatch_rq_list+0x5fc/0xb10
> > > [  475.717137]  blk_mq_sched_dispatch_requests+0x256/0x300
> > > [  475.721767]  __blk_mq_run_hw_queue+0xd6/0x180
> > > [  475.725920]  __blk_mq_delay_run_hw_queue+0x25c/0x290
> > > [  475.727480]  blk_mq_run_hw_queue+0x119/0x1b0
> > > [  475.732019]  blk_mq_run_hw_queues+0x7b/0xa0
> > > [  475.733468]  blk_mq_requeue_work+0x2cb/0x300
> > > [  475.736473]  process_one_work+0x4f1/0xa40
> > > [  475.739424]  worker_thread+0x67/0x5b0
> > > [  475.741751]  kthread+0x1cf/0x1f0
> > > [  475.746034]  ret_from_fork+0x24/0x30
> > > 
> > > (gdb) list *(__blk_recalc_rq_segments+0xbe)
> > > 0xffffffff816a152e is in __blk_recalc_rq_segments (block/blk-merge.c:366).
> > > 361                                                  struct bio *bio)
> > > 362     {
> > > 363             struct bio_vec bv, bvprv = { NULL };
> > > 364             int prev = 0;
> > > 365             unsigned int seg_size, nr_phys_segs;
> > > 366             unsigned front_seg_size = bio->bi_seg_front_size;
> > > 367             struct bio *fbio, *bbio;
> > > 368             struct bvec_iter iter;
> > > 369
> > > 370             if (!bio)
> > 
> > Just ran a few tests, and it also seems to cause about a 5% regression
> > in per-core IOPS throughput. Prior to this work, I could get 1620K 4k
> > rand read IOPS out of core, now I'm at ~1535K. The cycler stealer seems
> > to be blk_queue_split() and blk_rq_map_sg().
> 
> Could you share us your test setting?
> 
> I will run null_blk first and see if it can be reproduced.

Looks this performance drop isn't reproduced on null_blk with the following
setting by me:

- modprobe null_blk nr_devices=4 submit_queues=48
- test machine : dual socket, two NUMA nodes, 24cores/socket
- fio script:
fio --direct=1 --size=128G --bsrange=4k-4k --runtime=40 --numjobs=48 --ioengine=libaio --iodepth=64 --group_reporting=1 --filename=/dev/nullb0 --name=randread --rw=randread

result: 10.7M IOPS(base kernel), 10.6M IOPS(patched kernel)

And if 'bs' is increased to 256k, 512k, 1024k, IOPS improvement can be ~8%
with multi-page bvec patches in above test.

BTW, there isn't cost added to bio_for_each_bvec(), so blk_queue_split() and
blk_rq_map_sg() should be fine. However, bio_for_each_segment_all()
may not be quick as before.


Thanks,
Ming
