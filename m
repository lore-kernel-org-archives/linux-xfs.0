Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08341D638
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365586; cv=none; b=lbXCjF00uAtFa4m3WIh+h+ySoAQbl1ZDHoTujjja+pPDydOzVM/uVgsrx7n31cwwpRC1bXhIKB/1yNpCIJZP8CBaIke4ZuDgIKmyan3XwDP8CbqOGdHJXb/aoHV8XVEJdGLQMkY2GIjQnnl+df7gAHPYMHx9LxVEEdBSpSuI9l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365586; c=relaxed/simple;
	bh=Rp4xtoKq14kvi6mCZhjkc+uj21SFRhqayBCWLQcZ6pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/PZyCvrD8RzPRp2qPPSTZGOEW2LuRpCZSwSr4V9HZdngACVjkFh4Nrk2PamWuRZMTvs1kwKYiWHqjQKJL6PbtFF1m7RTttApjgZB7XgqAfDXPJqCGlSDyXtVthZZ2hFMScyvI/OmSZaq802kUytHgfdQxcFzJC9k9NuSUC+Fn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JhLCfMNa; arc=none smtp.client-ip=95.215.58.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JhLCfMNa"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Rp4xtoKq14kvi6mCZhjkc+uj21SFRhqayBCWLQcZ6pw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791365567; v=1; x=1791970367;
 b=JhLCfMNapF4DoBIkAE4LhDJXI5yPnuHFADOEN9QFY7BoONhlUq620V4LkVAQ16vgHYCnka2P
 cn8K6bzV0W/BL9Gpl46pi1xE5t+pIFrxt8wDReyOZ2C2h3PGefO6jrwOyDlmdWYMDsQsxFiY004
 4ovm1JQvoTm366DEAXwA58y0=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f254123b51092fc3;
	Wed, 07 Oct 2026 09:32:47 +0000
X-Mizu-Trace-ID: f254123b51092fc3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 7 Oct 2026 11:32:36 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andres Freund <andres@anarazel.de>, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 05/12] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <asYOJs4PYv326KNe@quentin>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>

One general comment, all your commit headers are starting with
uppercase.

iomap: Add initial support for buffered RWF_WRITETHROUGH

s/Add/add

Overall this looks good to me. I will run some tests via fio. Do you
have a branch with WRITETHROUGH by any chance?

On Mon, Sep 28, 2026 at 05:33:06PM +0530, Ojaswin Mujoo wrote:
> +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> +				   struct iomap_iter *iter, struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +
> +{
> +	ssize_t total_written = 0, pending = 0;
> +	loff_t submit_start_pos;
> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +	unsigned int bs = i_blocksize(iter->inode);
> +
> +	/* copied over based on how DIO handles these flags */
> +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> +	if (iter->iomap.flags & IOMAP_F_SHARED)
> +		wt_ctx->flags |= IOMAP_DIO_COW;
> +
> +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> +		return -EINVAL;
> +
> +	/*
> +	 * IOMAP_INLINE mappings have NULL bdev and would cause
> +	 * iomap_sector() to dereference invalid memory. Reject them.
> +	 */

Nit:
I noticed that gfs2 sets the bdev even for IOMAP_INLINE. A better
filesystem agnostic comment might be something like this?

/*
 * Inline data lives in the inode's metadata buffer, so it cannot be
 * written via a bio built from the folio.
 */

> +	if (iter->iomap.type == IOMAP_INLINE)
> +		return -EINVAL;
> +
> +	do {
> +		 * blocks in the bvec again.
> +		 */
> +		if (wt_ctx->nr_bvecs && prev_pos + prev_len > pos_aligned) {
> +			size_t delta = prev_pos + prev_len - pos_aligned;
> +
> +			/* Everything already added to bvec, nothing to do */
> +			if (delta >= len_aligned)
> +				goto put_folio;
> +
> +			pos_aligned += delta;
> +			off_aligned += delta;
> +			len_aligned -= delta;
> +		}
> +
> +		prev_pos = off_aligned;

I think this is a mistake?
prev_pos = pos_aligned; ?

> +		prev_len = len_aligned;
> +
> +		iomap_folio_prepare_writethrough(folio, off_aligned,
> +						 len_aligned);
> +
> +		if (!wt_ctx->nr_bvecs) {
> +			wt_ctx->bio_pos = round_down(pos, bs);

We could reuse pos_aligned variable here instead of recalculating?

> +			submit_start_pos = pos;
> +ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
> +				      const struct iomap_writethrough_ops *wt_ops,
> +				      void *private)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(i),
> +		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
> +		.private	= private,
> +	};
> +	struct iomap_writethrough_ctx *wt_ctx;
> +	unsigned int max_bvecs;
> +	ssize_t ret;
> +	struct blk_plug plug;
> +	size_t min_folio_bytes = PAGE_SIZE
> +				 << mapping_min_folio_order(inode->i_mapping);

min_folio_nr_bytes could be used here.
> +
> +	/*
> +	 * For now we don't support any other flag with WRITETHROUGH
> +	 */
> +	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> +		return -EINVAL;
> +	if (iocb->ki_flags & (IOCB_DONTCACHE))
> +		return -EINVAL;
> +	if (iocb_is_dsync(iocb))
> +		/* D_SYNC support not implemented yet */
> +		return -EOPNOTSUPP;
> +	if (!is_sync_kiocb(iocb))
> +		/* aio support not implemented yet */
> +		return -EOPNOTSUPP;
> +

-- 
Pankaj
