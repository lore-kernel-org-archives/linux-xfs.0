Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0BD37C907
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 12:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776341143; cv=none; b=scEecy+rzAKoA1/P06lsHlw+23vJCALP9+wGix5eISGiKC++BCK21S2gzkH0J+70XWy0BzSxWiHfdSySynGidjJBpcpbhR076ICJCzmVUQudSfswy1T4tUTQRNfvsEdHCD0p+0T3buznx8jr35aIxolo5HnaKrf9EUIkLScs7vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776341143; c=relaxed/simple;
	bh=9wHeWQsVrOKXVnqWzrSSyLovqDLP7du8ste6HflDmDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AnOZxQ/s8uCxItEwov7Zp/aCtEjQF+AbOgmbi6DMZGgdIQkRZTjgox1MNOLnclsnpEYz2CH7expFvjspb/7aphWQxz+UMupLLd07ZrE9jgDvmPxc9vUVv7YkAhwyWd0Hkns5rqzK2TUPdKBwm4q4rXGyUhyHq996rPKM0NFfgE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xfBPxdTo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T4/LdxVK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xfBPxdTo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T4/LdxVK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xfBPxdTo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T4/LdxVK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xfBPxdTo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T4/LdxVK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 90A296A7F9;
	Thu, 16 Apr 2026 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776341139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=xfBPxdToC5U8ErxBtunsRT59prlS+QPeDJbP8MISpIr85lpV8SNIAxskf3Z2TescqwqKRS
	Mtnx52HZXpkrmMVmR72ez8LpqgrCT+qE7jcgSfOw+7K3PnsjPC1cBwLMpob+aIZ5mpNzJ7
	EbiGqRohc65yUIINs9Bm8BE8S9K0leE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776341139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=T4/LdxVKWKFmDADmBO/WtToF+wVJa/EczIBvCy3ZlXL4Hio4qD/62bOiZV6/MmBly+pEZG
	78MGpUi8qwmm57Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776341139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=xfBPxdToC5U8ErxBtunsRT59prlS+QPeDJbP8MISpIr85lpV8SNIAxskf3Z2TescqwqKRS
	Mtnx52HZXpkrmMVmR72ez8LpqgrCT+qE7jcgSfOw+7K3PnsjPC1cBwLMpob+aIZ5mpNzJ7
	EbiGqRohc65yUIINs9Bm8BE8S9K0leE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776341139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=T4/LdxVKWKFmDADmBO/WtToF+wVJa/EczIBvCy3ZlXL4Hio4qD/62bOiZV6/MmBly+pEZG
	78MGpUi8qwmm57Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CF22593A3;
	Thu, 16 Apr 2026 12:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IPOmFpPQ4GlRBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Apr 2026 12:05:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DCB6FA0B67; Thu, 16 Apr 2026 14:05:34 +0200 (CEST)
Date: Thu, 16 Apr 2026 14:05:34 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <5l2pnrwodwbey7lwmysjxldqpm2kbyi7kqp5tqg7xozvaoecuh@dcglcdr3ipnz>
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
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,oracle.com,infradead.org,lst.de,gmail.com,suse.cz,mit.edu,samsung.com,anarazel.de,kvack.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 09-04-26 00:15:43, Ojaswin Mujoo wrote:
> This adds initial support for performing buffered non-aio
> RWF_WRITETHROUGH write. The rough flow for a writethrough write is as
> follows:
> 
> 1. Acquire inode lock
> 2. initialize writethrough context (wt_ctx) and mark
>    mapping as stable.
> 3. Start the iomap_iter() loop. For each iomap:
>   3.1. Acquire folio and folio_lock.
>   3.2. perform memcpy from user buffer to the folio and mark it
>        dirty
>   3.3. Wait for any current writeback to complete and then call
>        folio_mkclean() to prevent mmap writes from changing it.
>   3.4. Start writeback on the folio
>   3.5. Add the folio range under write to wt_ctx->bvec and folio_unlock()
>   3.6. If bvec is full, submit the current bvecs for IO.
>   3.7. Repeat 3.2 to 3.6 till the whole iomap is processed. Submit
>        the final set of bvecs for IO.
> 4. Repeat step 3 till we have no more data to write.
> 5. Finally, sleep in the syscall thread till all the IOs are
>    completed (refcount == 0). Once that happens, the end io handler will
>    wake us up.
> 6. Upon waking up, call fs ->end_io() callback (which updates inode
>    size), record any errors and return.
> 7. inode_unlock()
> 
> This design gives buffered writethrough the same semantics as dio and
> any error in the IO is directly returned to the caller. The design has
> delibrately open coded the IO submission and completion flow (inspired
> by dio) rather than reusing the dio functions as accomodating buffered
> writethrough logic in dio code was polluting it with too many if else
> conditionals and special cases.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Overall this looks good to me. Just a few smaller things below:

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
			       ^ missing 'how' here

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
> +
> +
> +	/*
> +	 * For now we don't support any other flag with WRITETHROUGH
> +	 */
> +	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> +		return -EINVAL;
> +	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_DONTCACHE))
> +		return -EINVAL;
> +	if (iocb_is_dsync(iocb))
> +		/* D_SYNC support not implemented yet */
> +		return -EOPNOTSUPP;
> +	if (!is_sync_kiocb(iocb))
> +		/* aio support not implemented yet */
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * +1 to max bvecs to account for unaligned write spanning multiple
> +	 * folios
> +	 */
> +	max_bvecs = DIV_ROUND_UP(
> +		iov_iter_count(i),
> +		PAGE_SIZE << mapping_min_folio_order(inode->i_mapping)) + 1;

Can this overflow? iov_iter_count() returns size_t which is ulong.

> +
> +	if (max_bvecs > BIO_MAX_VECS)
> +		max_bvecs = BIO_MAX_VECS;
> +	if (!max_bvecs)
> +		max_bvecs = 1;

I don't think 0 is possible here since we do +1 in max_bvecs computation
above.

> +
> +	wt_ctx = kzalloc(struct_size(wt_ctx, bvec, max_bvecs), GFP_NOFS);
> +	if (!wt_ctx)
> +		return -ENOMEM;
> +
> +	wt_ctx->iocb = iocb;
> +	wt_ctx->inode = inode;
> +	wt_ctx->dops = wt_ops->dops;
> +	wt_ctx->pos = iocb->ki_pos;
> +	wt_ctx->new_i_size = i_size_read(inode);
> +	wt_ctx->max_bvecs = max_bvecs;
> +	atomic_set(&wt_ctx->ref, 1);
> +	wt_ctx->waiter = current;
> +
> +	mapping_set_stable_writes(inode->i_mapping);
> +

We should check if mapping is already marked as requiring stable pages
avoid messing with (in particular clearing) the flag in that case.

> +	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
> +		WARN_ON(iter.iomap.type != IOMAP_UNWRITTEN &&
> +			iter.iomap.type != IOMAP_MAPPED);
> +		iter.status = iomap_writethrough_iter(wt_ctx, &iter, i, wt_ops);
> +	}
> +	if (ret < 0)
> +		cmpxchg(&wt_ctx->error, 0, ret);
> +
> +	if (!atomic_dec_and_test(&wt_ctx->ref)) {
> +		for (;;) {
> +			set_current_state(TASK_UNINTERRUPTIBLE);
> +			if (!READ_ONCE(wt_ctx->waiter))
> +				break;
> +			blk_io_schedule();
> +		}
> +		__set_current_state(TASK_RUNNING);
> +	}
> +
> +	return iomap_writethrough_complete(wt_ctx);
> +}

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
