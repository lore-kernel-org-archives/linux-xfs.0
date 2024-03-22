Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD98814AAE
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 08:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711095025; cv=none; b=fU2tOsi13HE523WT+8+AKPHwjhhZys6V47BoHce0vVLrh1jm9t+6c4WrM1bxmBi1THM76dqle8Xb3E76nSIW7K+s4NOdVch3n1YUw1vciahDZo5WBiiqZdK6XQGHCWuk4QllOw6LTYZC9zQAd5vX1uQzZuSRoE9E5NoWWhoNgK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711095025; c=relaxed/simple;
	bh=xR1sdQX5u2MbG6wjk8jDKn264TgI/eLkmEGL/JGstoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bsc0ekxk4+322KHDkq3oZaAwy8lHOM+10FjJIgJJYU0M5dzjIBtU+LgGZ/4lkGIIpQzVrwHBiiXXsQcwSY3ZkfEuBe99WM9jzC5Rb7TS9nzNdtFnDkyacVYJ5wNGaysMAN/8assTyv+XkXv87TOtP50Y0sKyhP7zoOcoMK+mB2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=hIgzbLXn; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="hIgzbLXn"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4V1FDS66Qtz9sTs;
	Fri, 22 Mar 2024 09:02:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1711094552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lsXh5Dx9/bbdIs1tdhNOLGNHeBUMjJd+GS7Sb5LywHQ=;
	b=hIgzbLXnS+GzopUqaVPxkQPkgjMj3h5VpWSNCfJZO4c9gz/VbsnYcRqaJ/YLCUblegH5X3
	jR2PdXMwWVP+U6OtP3bpWEanVZS/Mci+qDKkXWH2Iz9IaQEYs8OMkYhBCeppu7Ftht9Fur
	NMG1UxMjwnMSHo3XG0b4xDRpFeoPhUylYVGi2G20ll1wR2l7zVpeflFRGATsRi4X2b1oJX
	Gb6xpZIcJ5lufcEg8rzMc8RftVImF2Xi54fK0v9bpbHnUWLpmhwQTZGQJJOO4wGeL0WFHd
	dxf8Mlbw/YxqTdPa+PjIgBv4Es7uLdbGqOMN3rZXV5+e3XtA1pWXf4saa4D4MQ==
Date: Fri, 22 Mar 2024 09:02:31 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <wa53es767xeoxleltokuhcn5kccv5h2ocys37qqblpbplox2dc@36hvu3j6z5py>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-4-david@fromorbit.com>

>  	 * Bulk filling of pages can take multiple calls. Not filling the entire
> @@ -426,7 +484,7 @@ _xfs_buf_map_folios(
>  {
>  	ASSERT(bp->b_flags & _XBF_FOLIOS);
>  	if (bp->b_folio_count == 1) {
> -		/* A single page buffer is always mappable */
> +		/* A single folio buffer is always mappable */
>  		bp->b_addr = folio_address(bp->b_folios[0]);
>  	} else if (flags & XBF_UNMAPPED) {
>  		bp->b_addr = NULL;
> @@ -1525,20 +1583,28 @@ xfs_buf_ioapply_map(
>  	int		*count,
>  	blk_opf_t	op)
>  {
> -	int		page_index;
> -	unsigned int	total_nr_pages = bp->b_folio_count;
> -	int		nr_pages;
> +	int		folio_index;
> +	unsigned int	total_nr_folios = bp->b_folio_count;
> +	int		nr_folios;
>  	struct bio	*bio;
>  	sector_t	sector =  bp->b_maps[map].bm_bn;
>  	int		size;
>  	int		offset;
>  
> -	/* skip the pages in the buffer before the start offset */
> -	page_index = 0;
> +	/*
> +	 * If the start offset if larger than a single page, we need to be
> +	 * careful. We might have a high order folio, in which case the indexing
> +	 * is from the start of the buffer. However, if we have more than one
> +	 * folio single page folio in the buffer, we need to skip the folios in
s/folio single page folio/single page folio/

> +	 * the buffer before the start offset.
> +	 */
> +	folio_index = 0;
>  	offset = *buf_offset;
> -	while (offset >= PAGE_SIZE) {
> -		page_index++;
> -		offset -= PAGE_SIZE;
> +	if (bp->b_folio_count > 1) {
> +		while (offset >= PAGE_SIZE) {
> +			folio_index++;
> +			offset -= PAGE_SIZE;

Can this be:
folio_index = offset >> PAGE_SHIFT;
offset = offset_in_page(offset);

instead of a loop?

> +		}
>  	}
>  
>  	/*

--
Pankaj
