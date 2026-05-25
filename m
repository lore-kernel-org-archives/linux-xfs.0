Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F122433D4FD;
	Mon, 25 May 2026 05:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779686745; cv=none; b=RmRbe+ydR8whKa1VEMgxFmU9dkxT4xrdQH3udXAUAnPQp4xgE/TVUbWT5JoK8VC/DnEePu4fC2/JGq1lKZULMNRZ1UXmCiuCNfYNCdUbjA8nBUt8lUlpHDbh2MPtU4Ij37hp9AUcpDqQZcG4+lLjEUS6lhfEvA6xTLK3V0+u/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779686745; c=relaxed/simple;
	bh=S6khAx6ykVeLunP8OFwX6cQ04QXCDLxnHXfZcm0QiAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tW7eHraIl1gQ+6D90ociFfUh8XGWynKt0tnOuUdK1Syp8KUV1synsWrNhuLuyKBYt9x0D1BgLl90V7iXJb6xlf0af/3KALlqAKR7qF+WQ3VQcwjBG+ps2MhbqQ1Ht45QB+8HMFAjPdhngyQe+iMFJtjRA/BY2lX0I+lycKDdsRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2D3kGnnE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2D3kGnnE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dbF7MJcCgIyAYXJD23Ro/8c5fqjTJVY5GxCFHAVpzuw=; b=2D3kGnnEPa4tteIstuM+in0UvE
	LjeBx8ypFM5ooVAOA8OTtXN/xgEtB19J9VaFXQ8cnLUHS1ylPfHvIPwEBelKgbQV6/czNp6RAqMco
	BRSO9/6fowpf776p+3OcZnNayjzGcKBL4si1XlWyby486whG8YsUUhcVatRYSX27wrNg/hm9vx8wR
	71rjXNlyO6s4hBrS2FYFqvX1W4SMCCyp2mXlOEcKjj7gtYF+mc3kS/I2UIp814X41CawZ5HeFzNML
	whtOifCXxXuh3Naltgb59vHRlxLUxFODiui0yiXcd7D41akJCHw8WQ0CyITPVgzKOUZFF1PY3qz1h
	PbxYOihQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNos-0000000GJqa-1Dxg;
	Mon, 25 May 2026 05:25:42 +0000
Date: Sun, 24 May 2026 22:25:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 3/4] buffer: add dropbehind writeback support
Message-ID: <ahPdVoZdW5WRePbb@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
 <d98a35c1-882b-4752-a2c7-378872fc97a3@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d98a35c1-882b-4752-a2c7-378872fc97a3@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 22, 2026 at 07:14:46PM -0400, Tal Zussman wrote:
> >  	if (IS_ERR(folio))
> >  		return PTR_ERR(folio);
> > @@ -2160,6 +2165,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> >  	*foliop = folio;
> >  	return status;
> >  }
> 
> Q: "Is an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() needed for
> block_write_begin_iocb()?
> Since the legacy wrapper block_write_begin() remains exported, it appears
> filesystems compiled as loadable modules (like ext4 or fat) will encounter
> linker errors if they attempt to transition to the new API."
> 
> A: Can be added once filesystems want to use it.

Yeah, Sashiko is really stupid and counterproductive here.

> > @@ -2715,6 +2727,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
> >  
> >  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
> >  
> > +	if (folio_test_dropbehind(bh->b_folio))
> > +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> > +
> 
> Q: "Does this add unnecessary workqueue overhead for read operations?
> While task-context deferral is required for asynchronous writeback completions
> to allow folio_end_writeback() to sleep and invalidate the folio, read
> dropbehind invalidation is handled synchronously in the reader's task context
> via filemap_end_dropbehind_read().
> Could this be gated by an op == REQ_OP_WRITE or op_is_write(opf) check so
> that read bio completions aren't forced into a workqueue?"
> 
> A: Seems worth adding a op_is_write(opf) check to avoid deferring read
> dropbehind completions.

Yes.

