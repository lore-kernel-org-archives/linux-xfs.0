Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964903AbeEIPMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 11:12:45 -0400
Date: Wed, 9 May 2018 08:12:43 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/33] block: add a lower-level bio_add_page interface
Message-ID: <20180509151243.GA1313@bombadil.infradead.org>
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509074830.16196-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 09:47:58AM +0200, Christoph Hellwig wrote:
> +/**
> + * __bio_try_merge_page - try adding data to an existing bvec
> + * @bio: destination bio
> + * @page: page to add
> + * @len: length of the range to add
> + * @off: offset into @page
> + *
> + * Try adding the data described at @page + @offset to the last bvec of @bio.
> + * Return %true on success or %false on failure.  This can happen frequently
> + * for file systems with a block size smaller than the page size.
> + */

Could we make this:

/**
 * __bio_try_merge_page() - Try appending data to an existing bvec.
 * @bio: Destination bio.
 * @page: Page to add.
 * @len: Length of the data to add.
 * @off: Offset of the data in @page.
 *
 * Try to add the data at @page + @off to the last bvec of @bio.  This is
 * a useful optimisation for file systems with a block size smaller than
 * the page size.
 *
 * Context: Any context.
 * Return: %true on success or %false on failure.
 */

(page, len, off) is a bit weird to me.  Usually we do (page, off, len).

> +/**
> + * __bio_add_page - add page to a bio in a new segment
> + * @bio: destination bio
> + * @page: page to add
> + * @len: length of the range to add
> + * @off: offset into @page
> + *
> + * Add the data at @page + @offset to @bio as a new bvec.  The caller must
> + * ensure that @bio has space for another bvec.
> + */

/**
 * __bio_add_page - Add page to a bio in a new segment.
 * @bio: Destination bio.
 * @page: Page to add.
 * @len: Length of the data to add.
 * @off: Offset of the data in @page.
 *
 * Add the data at @page + @off to @bio as a new bvec.  The caller must
 * ensure that @bio has space for another bvec.
 *
 * Context: Any context.
 */

> +static inline bool bio_full(struct bio *bio)
> +{
> +	return bio->bi_vcnt >= bio->bi_max_vecs;
> +}

I really like this helper.
