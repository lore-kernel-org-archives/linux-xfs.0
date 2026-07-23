Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FC1388E44;
	Thu, 23 Jul 2026 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825736; cv=none; b=q32sQW1vJ6qFmaBsZjgU7rtUqG5KvvBFU1w+49DUqIKvzMUyLnzVQ+NSUC9OFlhBvjawJ2v7OC/Mg2XvSw0vyVOzL7xDH+ccHkBovs1Zv/39CXDdoqaE7nx7ajTvWG4avFXMbg+ExbGG5lzedHlF4Y1aoCKiv1KNt1ASld8uG6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825736; c=relaxed/simple;
	bh=eSbLbWZehfNanoc2ZfyZv68dRR7GD6Deu++FBaBEPqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWYzogNOOrKKCTQJo/QznjWp9MWE35c0NP2CpX1IjHVHURwTiaQbfBeehjuRuXSpz93AAB7eCGKWaCE/Auj3EjrYJPcQvR8qPW9YmMwW7XECtbcWDuFxTcHEuirQd6ZZDHPg4QN58YvBZFA6pYycsNdY4P/f4o31py95I5t3XCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkejCqkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkejCqkD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 559501F000E9;
	Thu, 23 Jul 2026 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784825735;
	bh=HNy8Um9hI6iUDkCD3WMWRqBrFLeWEAAUnAfgx2ymXF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MkejCqkDno6gTpxV+JcdHC0Y8fiHN0yLxNdoi046TQGBZ7bPerdNiHcbadXxn1/Dw
	 0BNl9oX5dQ5ZvE12oBIO5sHpcmS9ZOG6n+1h3BLZfQzX4207ZI7k+MxZBLCB7luuG3
	 /8vEt2nDOkChRk/fdmCsTlQ8fqEJuMKOh95MA8qwQsmFGAI4s0MYDEcTiPimaoi1v5
	 OXxaLwYKzPot4or9qHjXRUXI6VKc68S7K8tZvrCb1HGKeikNmgKeGgILqt50YkeZDd
	 73thst324pPHyDjL3P/YfNqj7sRUqan30v0MVhjJOUYtrlVtUer8JaDmdrq/f/4UWl
	 1FeJGDbZm+qeA==
Date: Thu, 23 Jul 2026 09:55:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/22] iomap: don't free integrity payload that doesn't
 exist
Message-ID: <20260723165534.GB2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-6-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:30PM +0200, Christoph Hellwig wrote:
> fs_bio_integrity_alloc might not allocate a bio integrity payload if PI
> verification is disabled on the block device.  Check for that case before
> calling fs_bio_integirty_free in iomap_bio_read_folio_range_sync to
> avoid a NULL pointer dereferences.
> 
> Make the branch cover the PI verification as well - while
> fs_bio_integrity_verify works without an integrity payload, it requires
> one to actually do useful work.
> 
> Fixes: 0b10a370529c ("iomap: support T10 protection information")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense.

Cc: <stable@vger.kernel.org> # v7.1
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index dc8ac7e370a5..30ef78a66b4f 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -179,7 +179,7 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
>  	if (srcmap->flags & IOMAP_F_INTEGRITY)
>  		fs_bio_integrity_alloc(&bio);
>  	error = submit_bio_wait(&bio);
> -	if (srcmap->flags & IOMAP_F_INTEGRITY) {
> +	if (bio_integrity(&bio)) {
>  		if (!error)
>  			error = fs_bio_integrity_verify(&bio, sector, len);
>  		fs_bio_integrity_free(&bio);
> -- 
> 2.53.0
> 
> 
