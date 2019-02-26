Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfBZNnR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Feb 2019 08:43:17 -0500
Date: Tue, 26 Feb 2019 21:42:48 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190226134247.GA30942@ming.t460p>
References: <20190226022249.GA17747@ming.t460p>
 <20190226030214.GI23020@dastard>
 <20190226032737.GA11592@bombadil.infradead.org>
 <20190226045826.GJ23020@dastard>
 <20190226093302.GA24879@ming.t460p>
 <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
 <CACVXFVMX=WpTRBbDTSibfXkTZxckk3ootetbE+rkJtHhsZkRAw@mail.gmail.com>
 <20190226121209.GC11592@bombadil.infradead.org>
 <20190226123545.GA6163@ming.t460p>
 <20190226130230.GD11592@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226130230.GD11592@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block <linux-block@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Tue, Feb 26, 2019 at 05:02:30AM -0800, Matthew Wilcox wrote:
> On Tue, Feb 26, 2019 at 08:35:46PM +0800, Ming Lei wrote:
> > On Tue, Feb 26, 2019 at 04:12:09AM -0800, Matthew Wilcox wrote:
> > > On Tue, Feb 26, 2019 at 07:12:49PM +0800, Ming Lei wrote:
> > > > The buffer needs to be device block size aligned for dio, and now the block
> > > > size can be 512, 1024, 2048 and 4096.
> > > 
> > > Why does the block size make a difference?  This requirement is due to
> > > some storage devices having shoddy DMA controllers.  Are you saying there
> > > are devices which can't even do 512-byte aligned I/O?
> > 
> > Direct IO requires that, see do_blockdev_direct_IO().
> > 
> > This issue can be triggered when running xfs over loop/dio. We could
> > fallback to buffered IO under this situation, but not sure it is the
> > only case.
> 
> Wait, we're imposing a ridiculous amount of complexity on XFS for no
> reason at all?  We should just change this to 512-byte alignment.  Tying
> it to the blocksize of the device never made any sense.

OK, that is fine since we can fallback to buffered IO for loop in case of
unaligned dio.

Then something like the following patch should work for all fs, could
anyone comment on this approach?

--

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5f2c429d4378..76f09f23a410 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -405,3 +405,44 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
+
+static struct kmem_cache *sector_buf_slabs[(PAGE_SIZE >> 9) - 1];
+
+void *blk_alloc_sec_buf(unsigned size, gfp_t flags)
+{
+	int idx;
+
+	size = round_up(size, 512);
+	if (size >= PAGE_SIZE)
+		return NULL;
+
+	idx = (size >> 9) - 1;
+	if (!sector_buf_slabs[idx])
+		return NULL;
+	return kmem_cache_alloc(sector_buf_slabs[idx], flags);
+}
+EXPORT_SYMBOL_GPL(blk_alloc_sec_buf);
+
+void blk_free_sec_buf(void *buf, int size)
+{
+	size = round_up(size, 512);
+	if (size >= PAGE_SIZE)
+		return;
+
+	return kmem_cache_free(sector_buf_slabs[(size >> 9) - 1], buf);
+}
+EXPORT_SYMBOL_GPL(blk_free_sec_buf);
+
+void __init blk_sector_buf_init(void)
+{
+	unsigned size;
+
+	for (size = 512; size < PAGE_SIZE; size += 512) {
+		char name[16];
+		int idx = (size >> 9) - 1;
+
+		snprintf(name, 16, "blk_sec_buf-%u", size);
+		sector_buf_slabs[idx] = kmem_cache_create(name, size, 512,
+							  SLAB_PANIC, NULL);
+	}
+}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index faed9d9eb84c..a4117e526715 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1657,6 +1657,9 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 
+extern void *blk_alloc_sec_buf(unsigned size, gfp_t flags);
+extern void blk_free_sec_buf(void *buf, int size);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 bool blk_req_needs_zone_write_lock(struct request *rq);
 void __blk_req_zone_write_lock(struct request *rq);
@@ -1755,6 +1758,15 @@ static inline int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	return 0;
 }
 
+static inline void *blk_alloc_sec_buf(unsigned size, gfp_t flags)
+{
+	return NULL;
+}
+
+static inline void blk_free_sec_buf(void *buf, int size)
+{
+}
+
 #endif /* CONFIG_BLOCK */
 
 static inline void blk_wake_io_task(struct task_struct *waiter)

Thanks,
Ming
