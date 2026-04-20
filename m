Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4C332614
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 11:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776686185; cv=none; b=Bhiw9Lndo2zyPmqSWHb7oW968cXS24BQhj5stkJ7/c4yd1G6JcTGz2iM1N0a5mRQVu6jcr6APcLCFjnQSmU7wDxPGtDFhYkq/5waes8RndVWvSdKDZYBfm1e8tEZFUsJmxW1EmKOZuE2GaxzCOw3FjUHeTuo6gZg3eNkvUklbLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776686185; c=relaxed/simple;
	bh=yYQeHhDuKYxwvEjukQGyDVXUJRhIRZuHKhyF+MSycyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urLKeHJqkTI5fvsIMwqohODBBtIaCnvURWu+zt9jmHiR2TVjNTHAEXxBN8YMjU2tzsvj9vJUA4ZcucRnfQpoBjLKXqXAOoln+DUtqHSgHaeOP1Ya/0qkslR0dEhHVZGBqWZe2s9WM99SBqpQQeRNhtn20Hmk7vXfot+I///+H8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BOO3af0g; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BOO3af0g"
Date: Mon, 20 Apr 2026 13:56:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776686180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uAqAKYkhN6D96c96Mv9PAQs6rNA7+9Ka0YDLN+X5iC4=;
	b=BOO3af0gd3cgHZ6BarDqfWQl4LroCnTbHD7ZxIa8ukzF4qfyDvi5w9ObOE+3H9L6f284ws
	MyPfwi3MypvbroQc88CJMHlPh2BxedJNolYfQO4EqQdCoh7AotS0k7bMMjnzBOcD9LXa8j
	GBifeO6xiuzr5WPOIEakFm1d8dj/ljY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

> +
> +	if (wt_ops->writethrough_submit)
> +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
> +					    len);
> +
> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);

We might want to check if bio_alloc succeeded here.

> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> +	bio->bi_private		= wt_ctx;
> +
> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> +				wt_ctx->bvec[i].bv_len,
> +				wt_ctx->bvec[i].bv_offset);
> +
> +	atomic_inc(&wt_ctx->ref);
> +	submit_bio(bio);
> +	wt_ctx->nr_bvecs = 0;
> +}
> +
<snip>
> +
> +/**
> + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> + * @wt_ctx: writethrough context
> + * @iter: iomap iter holding mapping information
> + * @i: iov_iter for write
> + * @wt_ops: the fs callbacks needed for writethrough
> + *
> + * This function copies the user buffer to folio similar to usual buffered
> + * IO path, with the difference that we immediately issue the IO. For this we
> + * utilize IO submission and completion mechanism that is inspired by dio.
> + *
> + * Folio handling note: We might be writing through a partial folio so we need
> + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> + * in the folio after the writethrough.
> + */
> +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> +				   struct iomap_iter *iter, struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +
> +{
> +	ssize_t total_written = 0;
> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +	unsigned int bs = i_blocksize(iter->inode);
> +
> +	/* copied over based on DIO handles these flags */
> +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> +	if (iter->iomap.flags & IOMAP_F_SHARED)
> +		wt_ctx->flags |= IOMAP_DIO_COW;
> +
> +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> +		return -EINVAL;
> +
> +	do {
> +		struct folio *folio;
> +		size_t offset;		/* Offset into folio */
> +		u64 bytes;		/* Bytes to write to folio */
> +		size_t copied;		/* Bytes copied from user */
> +		u64 written;		/* Bytes have been written */
> +		loff_t pos;
> +		size_t off_aligned, len_aligned;
> +
> +		bytes = iov_iter_count(i);
> +retry:
> +		offset = iter->pos & (chunk - 1);
> +		bytes = min(chunk - offset, bytes);
> +		status = balance_dirty_pages_ratelimited_flags(mapping,
> +							       bdp_flags);
> +		if (unlikely(status))
> +			break;
> +
> +		/*
> +		 * If completions already occurred and reported errors, give up
> +		 * now and don't bother submitting more bios.
> +		 */
> +		if (unlikely(data_race(wt_ctx->error))) {

In the unlikely scenario where we encounter an error, do we have to also
clear the writeback flag on all the folios that is part of this
bvec until now?

Something like explicitly iterate over wt_ctx->bvec[0] through 
wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
on them, and then discard the bvecs by setting the nr_bvecs = 0;

I am wondering if the folios that were processed until now will be in
PG_WRITEBACK state which can affect reclaim as we never clear the flag.

> +			wt_ctx->nr_bvecs = 0;
> +			break;
> +		}
> +

--
Pankaj
