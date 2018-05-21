Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbeEUD7I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 May 2018 23:59:08 -0400
Subject: Re: [PATCH 05/12] bcache: convert to bioset_init()/mempool_init()
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-6-kent.overstreet@gmail.com>
From: Coly Li <colyli@suse.de>
Message-ID: <52b76a42-2107-36bf-a9e3-7b13b935f4e6@suse.de>
Date: Mon, 21 May 2018 11:58:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180520222558.7053-6-kent.overstreet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On 2018/5/21 6:25 AM, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

Hi Kent,

This change looks good to me,

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/bcache.h  | 10 +++++-----
>  drivers/md/bcache/bset.c    | 13 ++++---------
>  drivers/md/bcache/bset.h    |  2 +-
>  drivers/md/bcache/btree.c   |  4 ++--
>  drivers/md/bcache/io.c      |  4 ++--
>  drivers/md/bcache/request.c | 18 +++++++++---------
>  drivers/md/bcache/super.c   | 38 ++++++++++++++-----------------------
>  7 files changed, 37 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 3a0cfb237a..3050438761 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -269,7 +269,7 @@ struct bcache_device {
>  	atomic_t		*stripe_sectors_dirty;
>  	unsigned long		*full_dirty_stripes;
>  
> -	struct bio_set		*bio_split;
> +	struct bio_set		bio_split;
>  
>  	unsigned		data_csum:1;
>  
> @@ -528,9 +528,9 @@ struct cache_set {
>  	struct closure		sb_write;
>  	struct semaphore	sb_write_mutex;
>  
> -	mempool_t		*search;
> -	mempool_t		*bio_meta;
> -	struct bio_set		*bio_split;
> +	mempool_t		search;
> +	mempool_t		bio_meta;
> +	struct bio_set		bio_split;
>  
>  	/* For the btree cache */
>  	struct shrinker		shrink;
> @@ -655,7 +655,7 @@ struct cache_set {
>  	 * A btree node on disk could have too many bsets for an iterator to fit
>  	 * on the stack - have to dynamically allocate them
>  	 */
> -	mempool_t		*fill_iter;
> +	mempool_t		fill_iter;
>  
>  	struct bset_sort_state	sort;
>  
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 579c696a5f..f3403b45bc 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -1118,8 +1118,7 @@ struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
>  
>  void bch_bset_sort_state_free(struct bset_sort_state *state)
>  {
> -	if (state->pool)
> -		mempool_destroy(state->pool);
> +	mempool_exit(&state->pool);
>  }
>  
>  int bch_bset_sort_state_init(struct bset_sort_state *state, unsigned page_order)
> @@ -1129,11 +1128,7 @@ int bch_bset_sort_state_init(struct bset_sort_state *state, unsigned page_order)
>  	state->page_order = page_order;
>  	state->crit_factor = int_sqrt(1 << page_order);
>  
> -	state->pool = mempool_create_page_pool(1, page_order);
> -	if (!state->pool)
> -		return -ENOMEM;
> -
> -	return 0;
> +	return mempool_init_page_pool(&state->pool, 1, page_order);
>  }
>  EXPORT_SYMBOL(bch_bset_sort_state_init);
>  
> @@ -1191,7 +1186,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
>  
>  		BUG_ON(order > state->page_order);
>  
> -		outp = mempool_alloc(state->pool, GFP_NOIO);
> +		outp = mempool_alloc(&state->pool, GFP_NOIO);
>  		out = page_address(outp);
>  		used_mempool = true;
>  		order = state->page_order;
> @@ -1220,7 +1215,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
>  	}
>  
>  	if (used_mempool)
> -		mempool_free(virt_to_page(out), state->pool);
> +		mempool_free(virt_to_page(out), &state->pool);
>  	else
>  		free_pages((unsigned long) out, order);
>  
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index 0c24280f3b..b867f22004 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -347,7 +347,7 @@ static inline struct bkey *bch_bset_search(struct btree_keys *b,
>  /* Sorting */
>  
>  struct bset_sort_state {
> -	mempool_t		*pool;
> +	mempool_t		pool;
>  
>  	unsigned		page_order;
>  	unsigned		crit_factor;
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 17936b2dc7..2a0968c04e 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -204,7 +204,7 @@ void bch_btree_node_read_done(struct btree *b)
>  	struct bset *i = btree_bset_first(b);
>  	struct btree_iter *iter;
>  
> -	iter = mempool_alloc(b->c->fill_iter, GFP_NOIO);
> +	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
>  	iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
>  	iter->used = 0;
>  
> @@ -271,7 +271,7 @@ void bch_btree_node_read_done(struct btree *b)
>  		bch_bset_init_next(&b->keys, write_block(b),
>  				   bset_magic(&b->c->sb));
>  out:
> -	mempool_free(iter, b->c->fill_iter);
> +	mempool_free(iter, &b->c->fill_iter);
>  	return;
>  err:
>  	set_btree_node_io_error(b);
> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> index 2ddf8515e6..9612873afe 100644
> --- a/drivers/md/bcache/io.c
> +++ b/drivers/md/bcache/io.c
> @@ -17,12 +17,12 @@
>  void bch_bbio_free(struct bio *bio, struct cache_set *c)
>  {
>  	struct bbio *b = container_of(bio, struct bbio, bio);
> -	mempool_free(b, c->bio_meta);
> +	mempool_free(b, &c->bio_meta);
>  }
>  
>  struct bio *bch_bbio_alloc(struct cache_set *c)
>  {
> -	struct bbio *b = mempool_alloc(c->bio_meta, GFP_NOIO);
> +	struct bbio *b = mempool_alloc(&c->bio_meta, GFP_NOIO);
>  	struct bio *bio = &b->bio;
>  
>  	bio_init(bio, bio->bi_inline_vecs, bucket_pages(c));
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 8e3e8655ed..ae67f5fa80 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -213,7 +213,7 @@ static void bch_data_insert_start(struct closure *cl)
>  	do {
>  		unsigned i;
>  		struct bkey *k;
> -		struct bio_set *split = op->c->bio_split;
> +		struct bio_set *split = &op->c->bio_split;
>  
>  		/* 1 for the device pointer and 1 for the chksum */
>  		if (bch_keylist_realloc(&op->insert_keys,
> @@ -548,7 +548,7 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
>  
>  	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
>  				      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
> -			   GFP_NOIO, s->d->bio_split);
> +			   GFP_NOIO, &s->d->bio_split);
>  
>  	bio_key = &container_of(n, struct bbio, bio)->key;
>  	bch_bkey_copy_single_ptr(bio_key, k, ptr);
> @@ -707,7 +707,7 @@ static void search_free(struct closure *cl)
>  
>  	bio_complete(s);
>  	closure_debug_destroy(cl);
> -	mempool_free(s, s->d->c->search);
> +	mempool_free(s, &s->d->c->search);
>  }
>  
>  static inline struct search *search_alloc(struct bio *bio,
> @@ -715,7 +715,7 @@ static inline struct search *search_alloc(struct bio *bio,
>  {
>  	struct search *s;
>  
> -	s = mempool_alloc(d->c->search, GFP_NOIO);
> +	s = mempool_alloc(&d->c->search, GFP_NOIO);
>  
>  	closure_init(&s->cl, NULL);
>  	do_bio_hook(s, bio, request_endio);
> @@ -864,7 +864,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
>  	s->cache_missed = 1;
>  
>  	if (s->cache_miss || s->iop.bypass) {
> -		miss = bio_next_split(bio, sectors, GFP_NOIO, s->d->bio_split);
> +		miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
>  		ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
>  		goto out_submit;
>  	}
> @@ -887,14 +887,14 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
>  
>  	s->iop.replace = true;
>  
> -	miss = bio_next_split(bio, sectors, GFP_NOIO, s->d->bio_split);
> +	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
>  
>  	/* btree_search_recurse()'s btree iterator is no good anymore */
>  	ret = miss == bio ? MAP_DONE : -EINTR;
>  
>  	cache_bio = bio_alloc_bioset(GFP_NOWAIT,
>  			DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),
> -			dc->disk.bio_split);
> +			&dc->disk.bio_split);
>  	if (!cache_bio)
>  		goto out_submit;
>  
> @@ -1008,7 +1008,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  			struct bio *flush;
>  
>  			flush = bio_alloc_bioset(GFP_NOIO, 0,
> -						 dc->disk.bio_split);
> +						 &dc->disk.bio_split);
>  			if (!flush) {
>  				s->iop.status = BLK_STS_RESOURCE;
>  				goto insert_data;
> @@ -1021,7 +1021,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  			closure_bio_submit(s->iop.c, flush, cl);
>  		}
>  	} else {
> -		s->iop.bio = bio_clone_fast(bio, GFP_NOIO, dc->disk.bio_split);
> +		s->iop.bio = bio_clone_fast(bio, GFP_NOIO, &dc->disk.bio_split);
>  		/* I/O request sent to backing device */
>  		bio->bi_end_io = backing_request_endio;
>  		closure_bio_submit(s->iop.c, bio, cl);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3dea06b41d..862b575827 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -766,8 +766,7 @@ static void bcache_device_free(struct bcache_device *d)
>  		put_disk(d->disk);
>  	}
>  
> -	if (d->bio_split)
> -		bioset_free(d->bio_split);
> +	bioset_exit(&d->bio_split);
>  	kvfree(d->full_dirty_stripes);
>  	kvfree(d->stripe_sectors_dirty);
>  
> @@ -809,9 +808,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	if (idx < 0)
>  		return idx;
>  
> -	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio),
> -					   BIOSET_NEED_BVECS |
> -					   BIOSET_NEED_RESCUER)) ||
> +	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
> +			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
>  	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
>  		ida_simple_remove(&bcache_device_idx, idx);
>  		return -ENOMEM;
> @@ -1465,14 +1463,10 @@ static void cache_set_free(struct closure *cl)
>  
>  	if (c->moving_gc_wq)
>  		destroy_workqueue(c->moving_gc_wq);
> -	if (c->bio_split)
> -		bioset_free(c->bio_split);
> -	if (c->fill_iter)
> -		mempool_destroy(c->fill_iter);
> -	if (c->bio_meta)
> -		mempool_destroy(c->bio_meta);
> -	if (c->search)
> -		mempool_destroy(c->search);
> +	bioset_exit(&c->bio_split);
> +	mempool_exit(&c->fill_iter);
> +	mempool_exit(&c->bio_meta);
> +	mempool_exit(&c->search);
>  	kfree(c->devices);
>  
>  	mutex_lock(&bch_register_lock);
> @@ -1683,21 +1677,17 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  	INIT_LIST_HEAD(&c->btree_cache_freed);
>  	INIT_LIST_HEAD(&c->data_buckets);
>  
> -	c->search = mempool_create_slab_pool(32, bch_search_cache);
> -	if (!c->search)
> -		goto err;
> -
>  	iter_size = (sb->bucket_size / sb->block_size + 1) *
>  		sizeof(struct btree_iter_set);
>  
>  	if (!(c->devices = kzalloc(c->nr_uuids * sizeof(void *), GFP_KERNEL)) ||
> -	    !(c->bio_meta = mempool_create_kmalloc_pool(2,
> -				sizeof(struct bbio) + sizeof(struct bio_vec) *
> -				bucket_pages(c))) ||
> -	    !(c->fill_iter = mempool_create_kmalloc_pool(1, iter_size)) ||
> -	    !(c->bio_split = bioset_create(4, offsetof(struct bbio, bio),
> -					   BIOSET_NEED_BVECS |
> -					   BIOSET_NEED_RESCUER)) ||
> +	    mempool_init_slab_pool(&c->search, 32, bch_search_cache) ||
> +	    mempool_init_kmalloc_pool(&c->bio_meta, 2,
> +				      sizeof(struct bbio) + sizeof(struct bio_vec) *
> +				      bucket_pages(c)) ||
> +	    mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size) ||
> +	    bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
> +			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
>  	    !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
>  	    !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
>  						WQ_MEM_RECLAIM, 0)) ||
> 

