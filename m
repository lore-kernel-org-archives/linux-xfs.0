Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFCC342CB1;
	Tue, 13 Jan 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768328798; cv=none; b=XB6fE0hMcUCrIe051rEVZkaLNJivtuiQeYMaYIHBq9z5AgBl+PQXWeMGlTkQjth9O6V8pHMBQr55O42smlOC1x8aY+WSXwhrAMBKN8ZXlfVSAUBM110agnCC2e3YjVhCCFV+BX5vdJHhZVwi5UNUwWoqOKyRJ8hFSa1SbPSaQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768328798; c=relaxed/simple;
	bh=jh7/eYIHMILsLEFfo4BthZi8zyqYrl3uhdHXbRUAmFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLi/6fAM7CspknX/4ymlb9wSHclxL5kqcvfbUpeGYXwtD4dtldJHugRm6R2LViOx0sD4v1LcpVToWI2gA0jh3tZqXnIO0Z578q41L+EDgSWPyH8vJSIyNwQ2KH3IgbZYo9HuH17VEbaVZtwG/piTUL6O8lINa7tuqZ+abfk3xrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6GrqHA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6GrqHA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738B5C116C6;
	Tue, 13 Jan 2026 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768328797;
	bh=jh7/eYIHMILsLEFfo4BthZi8zyqYrl3uhdHXbRUAmFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q6GrqHA/OZD057vy4y74WtcRaDgTQi3SIuatkLJSpIHyflAegUY6dFYIwZ5ai3eTh
	 jIdeRNbMHYj5Rf8MERPbP6inJiiQ4XKXlLgvdSAdpElCehCb9t5OJnhRgjDmuanuQP
	 6UBAb8aDTtf1qztmjbMS3KV8yDs7E59ceiiWnx0Bo8y5X6/ojKxoQiJVGvOg/L+X/U
	 FZTBlQaYn5RcNm2HgzUHNbc9Va1JcIPJDZIcAuRBLwVRxSs3ObeeJg0Pu2/bcDBJjA
	 CxdU6s+lNtDE1jkYzmjAymDOCYRWFZGVKihKab3XcSwSfTFOm19i9quV5nDxFP5Zq/
	 Hpghpz1dWm78Q==
Date: Tue, 13 Jan 2026 11:26:35 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Message-ID: <aWaOW-mjk7uuEcyW@kbusch-mbp>
References: <20260113071912.3158268-1-hch@lst.de>
 <20260113071912.3158268-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113071912.3158268-3-hch@lst.de>

On Tue, Jan 13, 2026 at 08:19:02AM +0100, Christoph Hellwig wrote:
> @@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_move_tail(&chunk->entry, &data->writing);
>  
> -	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> -	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> -			offset_in_folio(chunk->scratch->folio, bvec_paddr));
> -
> +	bio_reuse(&chunk->bio);

bio_reuse() uses the previous bio->bi_opf value, so don't you need to
explicitly override it to REQ_OP_WRITE here? Or maybe bio_reuse() should
take the desired op as a parameter so it doesn't get doubly initialized
by the caller.
