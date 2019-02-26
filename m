Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-36.smtp-out.amazonses.com ([54.240.9.36]:35466 "EHLO
        a9-36.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbfBZPak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 10:30:40 -0500
Date: Tue, 26 Feb 2019 15:30:39 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via
 page_frag_alloc
In-Reply-To: <20190226134247.GA30942@ming.t460p>
Message-ID: <010001692a6de63c-e2304a50-263c-49c5-a9fd-675cfb7094f5-000000@email.amazonses.com>
References: <20190226022249.GA17747@ming.t460p> <20190226030214.GI23020@dastard> <20190226032737.GA11592@bombadil.infradead.org> <20190226045826.GJ23020@dastard> <20190226093302.GA24879@ming.t460p> <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
 <CACVXFVMX=WpTRBbDTSibfXkTZxckk3ootetbE+rkJtHhsZkRAw@mail.gmail.com> <20190226121209.GC11592@bombadil.infradead.org> <20190226123545.GA6163@ming.t460p> <20190226130230.GD11592@bombadil.infradead.org> <20190226134247.GA30942@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block <linux-block@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Tue, 26 Feb 2019, Ming Lei wrote:

> Then something like the following patch should work for all fs, could
> anyone comment on this approach?

Note that various subsystems have similar implementations. Have a look at

drivers/dma/dmaengine.c

struct dmaengine_unmap_pool {
        struct kmem_cache *cache;
        const char *name;
        mempool_t *pool;
        size_t size;
};

#define __UNMAP_POOL(x) { .size = x, .name = "dmaengine-unmap-"
__stringify(x) }
static struct dmaengine_unmap_pool unmap_pool[] = {
        __UNMAP_POOL(2),
        #if IS_ENABLED(CONFIG_DMA_ENGINE_RAID)
        __UNMAP_POOL(16),
        __UNMAP_POOL(128),
        __UNMAP_POOL(256),
        #endif
};

Or drivers/md/dm-bufio.c:

struct dm_bufio_client {
        struct mutex lock;

        struct list_head lru[LIST_SIZE];
        unsigned long n_buffers[LIST_SIZE];

        struct block_device *bdev;
        unsigned block_size;
        s8 sectors_per_block_bits;
        void (*alloc_callback)(struct dm_buffer *);
        void (*write_callback)(struct dm_buffer *);

        struct kmem_cache *slab_buffer;
        struct kmem_cache *slab_cache;
        struct dm_io_client *dm_io;

        struct list_head reserved_buffers;
        unsigned need_reserved_buffers;

        unsigned minimum_buffers;

        struct rb_root buffer_tree;
        wait_queue_head_t free_buffer_wait;

        sector_t start;

        int async_write_error;

        struct list_head client_list;
        struct shrinker shrinker;
};
