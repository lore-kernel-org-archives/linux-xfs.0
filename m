Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:42886 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755277AbcJZNxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 09:53:50 -0400
Date: Wed, 26 Oct 2016 09:53:43 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1700618561.12920142.1477490023642.JavaMail.zimbra@redhat.com>
In-Reply-To: <1477408098-10153-6-git-send-email-hch@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de> <1477408098-10153-6-git-send-email-hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, kent overstreet <kent.overstreet@gmail.com>, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

----- Original Message -----
| This adds a full fledget direct I/O implementation using the iomap
| interface. Full fledged in this case means all features are supported:
| AIO, vectored I/O, any iov_iter type including kernel pointers, bvecs
| and pipes, support for hole filling and async apending writes.  It does
| not mean supporting all the warts of the old generic code.  We expect
| i_rwsem to be held over the duration of the call, and we expect to
| maintain i_dio_count ourselves, and we pass on any kinds of mapping
| to the file system for now.
| 
| The algorithm used is very simple: We use iomap_apply to iterate over
| the range of the I/O, and then we use the new bio_iov_iter_get_pages
| helper to lock down the user range for the size of the extent.
| bio_iov_iter_get_pages can currently lock down twice as many pages as
| the old direct I/O code did, which means that we will have a better
| batch factor for everything but overwrites of badly fragmented files.
| 
| Signed-off-by: Christoph Hellwig <hch@lst.de>
| ---
(snip)
| +static blk_qc_t
| +iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
| +		unsigned len)
| +{
| +	struct page *page = ZERO_PAGE(0);
| +	struct bio *bio;
| +
| +	bio = bio_alloc(GFP_KERNEL, 1);

It's unlikely, but bio_alloc can return NULL; shouldn't the code be checking for that?

| +	bio->bi_bdev = iomap->bdev;
| +	bio->bi_iter.bi_sector =
| +		iomap->blkno + ((pos - iomap->offset) >> 9);
| +	bio->bi_private = dio;
| +	bio->bi_end_io = iomap_dio_bio_end_io;
| +
| +	get_page(page);
| +	if (bio_add_page(bio, page, len, 0) != len)
| +		BUG();
| +	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_ODIRECT);
| +
| +	atomic_inc(&dio->ref);
| +	return submit_bio(bio);
| +}
| +
| +static loff_t
| +iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
| +		void *data, struct iomap *iomap)
| +{
| +	struct iomap_dio *dio = data;
| +	unsigned blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
| +	unsigned fs_block_size = (1 << inode->i_blkbits), pad;
| +	struct iov_iter iter = *dio->submit.iter;
| +	struct bio *bio;
| +	bool may_zero = false;
| +	int nr_pages, ret;
| +
| +	if ((pos | length | iov_iter_alignment(&iter)) & ((1 << blkbits) - 1))
| +		return -EINVAL;
| +
| +	switch (iomap->type) {
| +	case IOMAP_HOLE:
| +		/*
| +		 * We return -ENOTBLK to fall back to buffered I/O for file
| +		 * systems that can't fill holes from direct writes.
| +		 */
| +		if (dio->flags & IOMAP_DIO_WRITE)
| +			return -ENOTBLK;
| +		/*FALLTHRU*/
| +	case IOMAP_UNWRITTEN:
| +		if (!(dio->flags & IOMAP_DIO_WRITE)) {
| +			iov_iter_zero(length, dio->submit.iter);
| +			dio->size += length;
| +			return length;
| +		}
| +		dio->flags |= IOMAP_DIO_UNWRITTEN;
| +		may_zero = true;
| +		break;
| +	case IOMAP_MAPPED:
| +		if (iomap->flags & IOMAP_F_SHARED)
| +			dio->flags |= IOMAP_DIO_COW;
| +		if (iomap->flags & IOMAP_F_NEW)
| +			may_zero = true;
| +		break;
| +	default:
| +		WARN_ON_ONCE(1);
| +		return -EIO;
| +	}
| +
| +	iov_iter_truncate(&iter, length);
| +	nr_pages = iov_iter_npages(&iter, BIO_MAX_PAGES);
| +	if (nr_pages <= 0)
| +		return nr_pages;
| +
| +	if (may_zero) {
| +		pad = pos & (fs_block_size - 1);
| +		if (pad)
| +			iomap_dio_zero(dio, iomap, pos - pad, pad);
| +	}
| +
| +	do {
| +		if (dio->error)
| +			return 0;
| +
| +		bio = bio_alloc(GFP_KERNEL, nr_pages);

Same here. Also: the code that follows is nearly identical; do you want to make
it a macro or inline function or something?

Regards,

Bob Peterson
Red Hat File Systems
