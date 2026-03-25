Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21AD2F12D4;
	Wed, 25 Mar 2026 20:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774470099; cv=none; b=SQmdRiIgJ3qx5hBd+5CzpD6PGKvAHlFCdzIvxv6zhUyomlxZ9aCc/cXsSX3NqGy2gweGrfZaxJw8qmIl2arFipOw8GXFVVQcqmEi5B6hOgqT1YzIQtv2Ls5UYmNJiSOQFcXVL1yPZvr2wO3vwMdPOxZGD4qUPEL+kLgOLhL06lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774470099; c=relaxed/simple;
	bh=SiiDBKFAvyFqwglJ55lrG1YAPRNsE5d/+Mi64MwRMi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPXHoOCvtC1K5lSQwJz8PlMnVkDCTuAjlvAq3WJ1bKXBtDbv/T+PPRyf/AhWZS+Sqs1sZVxllEaV0yqdOO/RsWHyiad3VcTA8gMS2l0mHbpJk6XF9XK9O5OXTSBLFTKTinTIIhhROLG8B70ZZSX+a+BAmoC+kDmGBfSDxOdAQvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DM6Wvfqy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DM6Wvfqy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KeJTrDz0ZERUb53okI56kxVXYWflMwMqTR1ZZSCDXMI=; b=DM6WvfqywEbRbUFcvSVOCmaTHT
	aVny9M8t9l80xxaOAw1UaOdFSR5Ar49FQWmbvBFSCKUh0ApwBIBg/QXAkwToKrJU0GOscNN5teXtA
	Ye0W5MSDX+QcsCaEfHOISraJFZgugWBerE278/7b1HXHAsHrH7VASlgBsveK5NjwSVrb5NNmKN+BJ
	yDE5iV2917oILPrH3EVbpz7hNABlLV6/YdU27BTTwOXjzGGvHNzP61lpyJpdCzFVoPSfgHcFpinxb
	LquoV5sPsNV1JFL7RmVGyfch1BJ1l3XZtZ/wqG2aE1QX9lXSsuJEfr1S4kbWofLo+3YLEz9Affatk
	rCW+zEGg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5UjI-0000000GUsO-3sZs;
	Wed, 25 Mar 2026 20:21:28 +0000
Date: Wed, 25 Mar 2026 20:21:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acRDyJrkJhnHHMSe@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>

On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
> context, where folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically, XFS
> no longer needs to route DONTCACHE ioends through its completion
> workqueue for page cache invalidation. Remove the DONTCACHE check from
> xfs_ioend_needs_wq_completion().
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/iomap/ioend.c  | 2 ++
>  fs/xfs/xfs_aops.c | 4 ----
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index e4d57cb969f1..6b8375d11cc0 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>  			       GFP_NOFS, &iomap_ioend_bioset);
>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  	wbc_init_bio(wpc->wbc, bio);
>  	wpc->nr_folios = 0;
>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);

Can't we delete IOMAP_IOEND_DONTCACHE, and just do:

	if (folio_test_dropbehind(folio))
		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);

It'd need to move down a few lines in iomap_add_to_ioend() to after
bio_add_folio() succeeds.
