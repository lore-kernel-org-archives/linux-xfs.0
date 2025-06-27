Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E688EEDE
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751042122; cv=none; b=VTbarLTRIBi1WNReMEL3DK0TsXUbz23zl638W9YB+nqQxUqiRbsZ8fmDfvUpGiSiJH2BK+D903q5j4Fai/4iYfsbsDn/2g71IBa0YubwaP8ZrrwTpJJCUIuUuZrqUkP5BrXd4OM2DldS5IZJooMuWKgXQvShS/e4tylX6W62170=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751042122; c=relaxed/simple;
	bh=vvSdh6Pu/vbKF1fhGZAQmkhDpdQhyfqNHF4KpTD9x/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiRVkhSavTenIrYgu9YGC6dhsA5l66LpVwlGARnq51wwLiO5UC8PFgOt4D1vXhiZDCvFyHs22e96S9lwkXUdofbJBhyFtZgm8xexhl0Q8m2imAfjuNmr9Iwn+YiqtC+63wyfTQjZr+aI8sVDkw3eI8N6QHDEfn/1B4AgiZLQFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJxUWC77; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJxUWC77"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751042120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/NvqSFSTyD4E2t2FSiuoiOcmymYTYmDyujSBCRIZBE=;
	b=SJxUWC771X3L3yyv2pdBgVPzgNoYfGOVPE0ke7QgjJJwU3zUkZELpNtt46YZoIygqknYuV
	J2e4rUCX/ffwtVOmK59sstppfCEqFtXzc95iIxywyAPbHXKtsd7fkCV28wt/lSPB8VisAB
	HpJwJlBciQk703QKJIBJFASYxM72u3U=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-K2Zj34qTMCql6hSQpCf5WA-1; Fri,
 27 Jun 2025 12:35:17 -0400
X-MC-Unique: K2Zj34qTMCql6hSQpCf5WA-1
X-Mimecast-MFC-AGG-ID: K2Zj34qTMCql6hSQpCf5WA_1751042116
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F9661955EC1;
	Fri, 27 Jun 2025 16:35:16 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.142])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 816C9195609D;
	Fri, 27 Jun 2025 16:35:14 +0000 (UTC)
Date: Fri, 27 Jun 2025 12:38:52 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, gfs2@lists.linux.dev
Subject: Re: [PATCH 08/12] iomap: move folio_unlock out of
 iomap_writeback_folio
Message-ID: <aF7JHFdLCi89sFpn@bfoster>
References: <20250627070328.975394-1-hch@lst.de>
 <20250627070328.975394-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627070328.975394-9-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Jun 27, 2025 at 09:02:41AM +0200, Christoph Hellwig wrote:
> From: Joanne Koong <joannelkoong@gmail.com>
> 
> Move unlocking the folio out of iomap_writeback_folio into the caller.
> This means the end writeback machinery is now run with the folio locked
> when no writeback happend, or writeback completed extremely fast.
> 

I notice that folio_end_dropbehind_write() (via folio_end_writeback())
wants to trylock the folio in order to do its thing. Is this going to
cause issues with that (i.e. prevent invalidations)?

Brian

> This prepares for exporting iomap_writeback_folio for use in folio
> laundering.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> [hch: split from a larger patch]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/buffered-io.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index c28eb6a6eee4..a1dccf4e7063 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1656,10 +1656,8 @@ static int iomap_writeback_folio(struct iomap_writeback_ctx *wpc,
>  
>  	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
>  
> -	if (!iomap_writeback_handle_eof(folio, inode, &end_pos)) {
> -		folio_unlock(folio);
> +	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
>  		return 0;
> -	}
>  	WARN_ON_ONCE(end_pos <= pos);
>  
>  	if (i_blocks_per_folio(inode, folio) > 1) {
> @@ -1713,7 +1711,6 @@ static int iomap_writeback_folio(struct iomap_writeback_ctx *wpc,
>  	 * already at this point.  In that case we need to clear the writeback
>  	 * bit ourselves right after unlocking the page.
>  	 */
> -	folio_unlock(folio);
>  	if (ifs) {
>  		if (atomic_dec_and_test(&ifs->write_bytes_pending))
>  			folio_end_writeback(folio);
> @@ -1740,8 +1737,10 @@ iomap_writepages(struct iomap_writeback_ctx *wpc)
>  			PF_MEMALLOC))
>  		return -EIO;
>  
> -	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error)))
> +	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
>  		error = iomap_writeback_folio(wpc, folio);
> +		folio_unlock(folio);
> +	}
>  
>  	/*
>  	 * If @error is non-zero, it means that we have a situation where some
> -- 
> 2.47.2
> 
> 

