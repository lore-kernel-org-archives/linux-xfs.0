Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF5E39B947
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 12:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342863; cv=none; b=kOjD9EHUAniLuJJ+olE1moMWXOh60wmh4D3CAvBM5H2j7sSks4TwkWM2ReL66Enyk4GCmZ3IjUZmTdE+G2m08Qt7r0wAiMcjr00JFf2zPyFnCUyNnV+lh4xLXX6QRfQodxz7ASFse7ZKzWQYfnUmK5ZHj9KinG2dRhJD3VUzGp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342863; c=relaxed/simple;
	bh=s71mqQoinwz1Nad3szTLRy+45Affj7FGnL/Omovd0mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cl243t2ovcQEuQQPzIDYY2Cv9l5afxp/lROovcsRD8Q16KOmLJ+FwKeeW20B8uUFxJ5mjHZ4KMDO9mgEUNU/k47Lr7B5AuQ06o+XhO7VIf1n2j4zgkAQA5uVBGAlKDIGUO9mSPx73RaE0303/A/s8fpcBlJWFxR3tI/yVrSf50A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2lAvgDJA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TRzt6xZc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2lAvgDJA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TRzt6xZc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2lAvgDJA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TRzt6xZc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2lAvgDJA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TRzt6xZc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B9866A7EC;
	Thu, 16 Apr 2026 12:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776342860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=2lAvgDJAq/JoBGC7FwG9XFNG6323BkBaYk2YGa6y2Wg8d7U/VoNhv7l/kpUCDLGwn85Xmc
	ENOpKOhp0HqlXQ/YdUQ8Z7Wyz128OW/zrrZvn24GDdtEdjm1ehJppkJn/MjHfMWONGzqvN
	mRUjmYvrDKwjfJeBSaSpOtA3D9fmHZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776342860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=TRzt6xZc9OrfkCBcA7qKq99GsLISMToJjn4dVQlYzcKF8VIjubsyHlqCadtqpUpD8Un4UU
	fqu2kzSHAKnwQcDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2lAvgDJA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TRzt6xZc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776342860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=2lAvgDJAq/JoBGC7FwG9XFNG6323BkBaYk2YGa6y2Wg8d7U/VoNhv7l/kpUCDLGwn85Xmc
	ENOpKOhp0HqlXQ/YdUQ8Z7Wyz128OW/zrrZvn24GDdtEdjm1ehJppkJn/MjHfMWONGzqvN
	mRUjmYvrDKwjfJeBSaSpOtA3D9fmHZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776342860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=TRzt6xZc9OrfkCBcA7qKq99GsLISMToJjn4dVQlYzcKF8VIjubsyHlqCadtqpUpD8Un4UU
	fqu2kzSHAKnwQcDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F409B593A3;
	Thu, 16 Apr 2026 12:34:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DSuOO0vX4GmxIgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Apr 2026 12:34:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B287FA0B67; Thu, 16 Apr 2026 14:34:15 +0200 (CEST)
Date: Thu, 16 Apr 2026 14:34:15 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
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
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,oracle.com,infradead.org,lst.de,gmail.com,suse.cz,mit.edu,samsung.com,anarazel.de,kvack.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1B9866A7EC

Some more thoughs... :)

> @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
>  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
>  }
>  
> +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> +{
> +	struct kiocb *iocb	= wt_ctx->iocb;
> +	struct inode *inode	= wt_ctx->inode;
> +	ssize_t ret		= wt_ctx->error;
> +
> +	if (wt_ctx->dops && wt_ctx->dops->end_io) {
> +		int err = wt_ctx->dops->end_io(iocb, wt_ctx->written,
> +						wt_ctx->error,
> +						wt_ctx->flags);

It's a bit odd to use only ->end_io from dops also because we don't really
use direct IO submission path. So perhaps you can have just an end_io
handler pointer in iomap_writethrough_ops similarly as you have a
submission one?

> +		if (err)
> +			ret = err;
> +	}
> +
> +	mapping_clear_stable_writes(inode->i_mapping);
> +
> +	if (!ret) {
> +		ret = wt_ctx->written;
> +		iocb->ki_pos = wt_ctx->pos + ret;
> +	}
> +
> +	kfree(wt_ctx);
> +	return ret;
> +}

...

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
> +			wt_ctx->nr_bvecs = 0;
> +			break;
> +		}
> +
> +		if (bytes > iomap_length(iter))
> +			bytes = iomap_length(iter);
> +
> +		/*
> +		 * Bring in the user page that we'll copy from _first_.
> +		 * Otherwise there's a nasty deadlock on copying from the
> +		 * same page as we're writing to, without it being marked
> +		 * up-to-date.
> +		 *
> +		 * For async buffered writes the assumption is that the user
> +		 * page has already been faulted in. This can be optimized by
> +		 * faulting the user page.
> +		 */
> +		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
> +			status = -EFAULT;
> +			break;
> +		}
> +
> +		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
> +					   &offset, &bytes);
> +		if (unlikely(status)) {
> +			iomap_write_failed(iter->inode, iter->pos, bytes);
> +			break;
> +		}
> +		if (iter->iomap.flags & IOMAP_F_STALE)
> +			break;
> +
> +		pos = iter->pos;
> +
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_folio(folio);
> +
> +		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
> +		written = iomap_write_end(iter, bytes, copied, folio) ?
> +			  copied : 0;
> +
> +		if (!written)
> +			goto put_folio;
> +
> +		off_aligned = round_down(offset, bs);
> +		len_aligned = round_up(offset + written, bs) - off_aligned;
> +
> +		iomap_folio_prepare_writethrough(folio, off_aligned,
> +						 len_aligned);
> +
> +		if (!wt_ctx->nr_bvecs)
> +			wt_ctx->bio_pos = round_down(pos, bs);
> +
> +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> +			       len_aligned, off_aligned);

Shouldn't we zero out the tail of the folio if we are submitting partial
folio for write?

> +		wt_ctx->nr_bvecs++;
> +		wt_ctx->written += written;
> +
> +		if (pos + written > wt_ctx->new_i_size)
> +			wt_ctx->new_i_size = pos + written;

I'm probably missing something here but where is i_size update handled? I
don't see new_i_size used anywhere? Also why is it OK to not call
pagecache_isize_extended() but that goes with the i_size update...

> +
> +		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs)
> +			iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
> +
> +put_folio:
> +		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
> +
> +		cond_resched();
> +		if (unlikely(written == 0)) {
> +			iomap_write_failed(iter->inode, pos, bytes);
> +			iov_iter_revert(i, copied);
> +
> +			if (chunk > PAGE_SIZE)
> +				chunk /= 2;
> +			if (copied) {
> +				bytes = copied;
> +				goto retry;
> +			}
> +		} else {
> +			total_written += written;
> +			iomap_iter_advance(iter, written);
> +		}
> +	} while (iov_iter_count(i) && iomap_length(iter));

Overall the differences of this function from iomap_write_iter() seem
relatively small so maybe it would be possible to just extend
iomap_write_iter() to support writethrough IO as well? Basically once we've
copied data into the folio and called iomap_write_end() we can have "if
writethrough, call function to prepare & submit the folio for IO".

> +
> +	if (wt_ctx->nr_bvecs)
> +		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
> +
> +	return total_written ? 0 : status;
> +}
> +

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
