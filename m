Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E87C38D419;
	Tue, 25 Aug 2026 07:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644757; cv=none; b=bkxyC4yaAHjDkamcu/PidXfXCwjGVW2UVgYki6BavpRIYMi1P0Ray+LTr4iRZ291ErW8OnnD1fii5tKQD/yNXTUxOadrVyyfVUTUMCp7qEzISA+ti1QXKP957dyTcposQqAa3GILXwwotzpkJs9ZkTxFxq/NYAEtVMVpxVLPurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644757; c=relaxed/simple;
	bh=Z2FerkZua6EPtJf2RIJxu1CMU/0rBP1f7eRXOo3u964=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhCorSFfDu9lwyWcamB+xlH6Dvuf3VzoVXrueTqR4vUC07DGh+BqMrR6Bv43V1/lRuQ9/hD2TOCl5kETiZihk+4JQhHNomUh2D4trrCEyRR6D1Th8yuU+9+QHu/E4iy9LFtKForvOm4q98vIjSY7xur84d9V4OHOawd0L1Pa2Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0CGHFwao; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wzWFMzHs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ejcDYF8o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xcviFUOY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0CGHFwao";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wzWFMzHs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ejcDYF8o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xcviFUOY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E124E86D73;
	Tue, 25 Aug 2026 07:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787644750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=0CGHFwaoWm7q5XPbizZrjrEEmhZxSYM8K8G206/zLI19IzemgvLdq5t7T2QLT8DUG2Ctdc
	cuwpc6wJDzs2STPCTEP03APDHWg8gWn08PaGN+M2+2iLhCHpdZVBTAy1EaDOuQNlQ3oQAU
	i/aoEkLKiMy2CLn/yG+Nt/yHuS8Pnog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787644750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=wzWFMzHsk/+iPH0SX3CW/v7SVM4ql+8QOqiO3b/4mzZi3QmHTvhxZX6nwlXuogVYKIf8pK
	3l5GkiJkHpZ/jICg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787644745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=ejcDYF8o8x7QWlAQNDisoLJNh26DKtQQmIE5Cgr7JM8Pii2nbdpQYM11aphcMrtCBVEeNE
	Tj9XHndboopHuaVIFem8QRP9LIpLbERg8wWNNwlMcgJYlvY82A4Naz10g+z9qKKuFvjyYq
	aQ21vQTC6lmy2Gb4tx+ctir7coTGQIE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787644745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=xcviFUOYu9qnGpVA+fmFz9/SxZ/wGd6G3cp34iELyzBa9ZmroK2UNmsCjOEbLmYXuofl/j
	M9sR+JSaOGL9eNBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D2F713332;
	Tue, 25 Aug 2026 07:59:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NydOO0hLjWrWbwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Aug 2026 07:59:04 +0000
Date: Tue, 25 Aug 2026 08:59:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>, 
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao1Kbcu4Mmtrr_Sa@pedro-suse>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
 <aoye694JQLwUuqxC@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoye694JQLwUuqxC@casper.infradead.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.985];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On Mon, Aug 24, 2026 at 08:43:39PM +0100, Matthew Wilcox wrote:
> On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
> > > My proposal is this:
> > > 
> > >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> > >    If it's true, do the writeback, but retain/recreate whatever data
> > >    structures you need in order to write the folio again; behave as if
> > >    ->page_mkdirty() had been called again for each page in the folio is
> > >    marked as dirty.
> > 
> > Yes, that would work nicely.
> > 
> > >  - The MM behaves similarly; we do not clear the writeback flag for
> > >    folio_maybe_dma_pinned().
> > > 
> > > This will have the effect of writing pinned folios back every time the
> > > inode is scheduled for writeback.  But since we have no idea whether
> > > the folio is actually dirty (because the GUP user won't tell us),
> > > this is the correct behaviour.
> > > 
> > > I'm probably missing some stuff here.  Let me know.
> > 
> > OK, so working through the end of the pinning, I think it still is
> > correct: device finishes writing to pinned memory, device driver
> > unpins the memory but the page has been left marked dirty the whole
> > time and still is, so the next writeback still does the writeback,
> > but this time sees no pins and so it marks the page clean.
> 
> Excellent!  By the way, what would you think to this?
> 
> @@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
>          * Here, for that overflow case, use the sign bit to count a little
>          * bit higher via unsigned math, and thus still get an accurate result.
>          */
> -       return ((unsigned int)folio_ref_count(folio)) >=
> +       mapcount = folio_mapcount(folio);
> +       return (folio_ref_count(folio) - mapcount) >=
>                 GUP_PIN_COUNTING_BIAS;
>  }
> 
> 
> It should improve the accuracy of folio_maybe_dma_pinned() for folios
> which are mapped many, many times (eg a page of libc).  I'm a little
> concerned about races turning that number negative since we don't
> necessarily have the folio locked at that point.

It's perhaps a radical idea, but how about just not incrementing
refcount for mappings? Essentially, for the main state transitions
(mapped to unmapped, and vice-versa):

0 mapcount -> 1 mapcount: refcount++
1 mapcount -> 0 mapcount: refcount--

and anything else doesn't touch refcount.

I think it's worth considering standalone (one less atomic inc :) and
reduces any ambiguity in folio_maybe_dma_pinned() to essentially 0 (unless
you have 2048 short-term pins for the folio, rather unlikely I would say).

-- 
Pedro
