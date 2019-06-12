Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfFLKPL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 06:15:11 -0400
Date: Wed, 12 Jun 2019 18:14:52 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 3/5] block: return from __bio_try_merge_page if merging
 occured in the same page
Message-ID: <20190612101449.GB16000@ming.t460p>
References: <20190611151007.13625-1-hch@lst.de>
 <20190611151007.13625-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611151007.13625-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 05:10:05PM +0200, Christoph Hellwig wrote:
> We currently have an input same_page parameter to __bio_try_merge_page
> to prohibit merging in the same page.  The rationale for that is that
> some callers need to account for every page added to a bio.  Instead of
> letting these callers call twice into the merge code to account for the
> new vs existing page cases, just turn the paramter into an output one that
> returns if a merge in the same page occured and let them act accordingly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio.c         | 23 +++++++++--------------
>  fs/iomap.c          | 12 ++++++++----
>  fs/xfs/xfs_aops.c   | 11 ++++++++---
>  include/linux/bio.h |  2 +-
>  4 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 85e243ea6a0e..c34327aa9216 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -636,7 +636,7 @@ EXPORT_SYMBOL(bio_clone_fast);
>  
>  static inline bool page_is_mergeable(const struct bio_vec *bv,
>  		struct page *page, unsigned int len, unsigned int off,
> -		bool same_page)
> +		bool *same_page)
>  {
>  	phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
>  		bv->bv_offset + bv->bv_len - 1;
> @@ -647,15 +647,9 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
>  	if (xen_domain() && !xen_biovec_phys_mergeable(bv, page))
>  		return false;
>  
> -	if ((vec_end_addr & PAGE_MASK) != page_addr) {
> -		if (same_page)
> -			return false;
> -		if (pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
> -			return false;
> -	}
> -
> -	WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);
> -
> +	*same_page = ((vec_end_addr & PAGE_MASK) == page_addr);
> +	if (!*same_page && pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
> +		return false;
>  	return true;
>  }
>  
> @@ -763,8 +757,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * @page: start page to add
>   * @len: length of the data to add
>   * @off: offset of the data relative to @page
> - * @same_page: if %true only merge if the new data is in the same physical
> - *		page as the last segment of the bio.
> + * @same_page: return if the segment has been merged inside the same page
>   *
>   * Try to add the data at @page + @off to the last bvec of @bio.  This is a
>   * a useful optimisation for file systems with a block size smaller than the
> @@ -775,7 +768,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * Return %true on success or %false on failure.
>   */
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off, bool same_page)
> +		unsigned int len, unsigned int off, bool *same_page)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return false;
> @@ -833,7 +826,9 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
>  int bio_add_page(struct bio *bio, struct page *page,
>  		 unsigned int len, unsigned int offset)
>  {
> -	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
> +	bool same_page = false;
> +
> +	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
>  		if (bio_full(bio))
>  			return 0;
>  		__bio_add_page(bio, page, len, offset);
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 23ef63fd1669..12654c2e78f8 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -287,7 +287,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	struct iomap_readpage_ctx *ctx = data;
>  	struct page *page = ctx->cur_page;
>  	struct iomap_page *iop = iomap_page_create(inode, page);
> -	bool is_contig = false;
> +	bool same_page = false, is_contig = false;
>  	loff_t orig_pos = pos;
>  	unsigned poff, plen;
>  	sector_t sector;
> @@ -315,10 +315,14 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	 * Try to merge into a previous segment if we can.
>  	 */
>  	sector = iomap_sector(iomap, pos);
> -	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
> -		if (__bio_try_merge_page(ctx->bio, page, plen, poff, true))
> -			goto done;
> +	if (ctx->bio && bio_end_sector(ctx->bio) == sector)
>  		is_contig = true;
> +
> +	if (is_contig &&
> +	    __bio_try_merge_page(ctx->bio, page, plen, poff, &same_page)) {
> +		if (!same_page && iop)
> +			atomic_inc(&iop->read_count);
> +		goto done;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a6f0f4761a37..8da5e6637771 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -758,6 +758,7 @@ xfs_add_to_ioend(
>  	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
>  	unsigned		len = i_blocksize(inode);
>  	unsigned		poff = offset & (PAGE_SIZE - 1);
> +	bool			merged, same_page = false;
>  	sector_t		sector;
>  
>  	sector = xfs_fsb_to_db(ip, wpc->imap.br_startblock) +
> @@ -774,9 +775,13 @@ xfs_add_to_ioend(
>  				wpc->imap.br_state, offset, bdev, sector);
>  	}
>  
> -	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
> -		if (iop)
> -			atomic_inc(&iop->write_count);
> +	merged = __bio_try_merge_page(wpc->ioend->io_bio, page, len, poff,
> +			&same_page);
> +
> +	if (iop && !same_page)
> +		atomic_inc(&iop->write_count);
> +
> +	if (!merged) {
>  		if (bio_full(wpc->ioend->io_bio))
>  			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
>  		bio_add_page(wpc->ioend->io_bio, page, len, poff);
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 0f23b5682640..f87abaa898f0 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -423,7 +423,7 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
>  extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
>  			   unsigned int, unsigned int);
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off, bool same_page);
> +		unsigned int len, unsigned int off, bool *same_page);
>  void __bio_add_page(struct bio *bio, struct page *page,
>  		unsigned int len, unsigned int off);
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
> -- 
> 2.20.1
> 

Looks fine for v5.2:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming
