Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9C615B129
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 11:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711365808; cv=none; b=jMqXhj7t6Hp5d+WUSdpO8/IXVJ1SKDf3N7juSQ/pCDkMf3EB9oiql2qXrPDtlAsY/btiM7Mf5sODZ2HLly2cdjNl1qMUhd0ZXc3wVYKRe+09zP4Eg2U1EOsp50Lhy8Xf2VXtOXf6jUM2MDvYixlkaTb6yMEkLdxzWTnfE93j/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711365808; c=relaxed/simple;
	bh=9a1pwrXnR051S+2McaQMWAEDWH4VYLCdDIJKMcPyviE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+Qvu7EP4CphfM3j21M1eDmRIBKWM/AulLRrI9MtWCUBydyZFsAyNTZbXMQELn0Y9LUYLDMTgVSmm59uo5zenjwQTn8Ju3piz3vJs9UDCCJJrzY1GzCN0/2/TTDjYELIIFeGk6qEoXhPmgLMyslGZm7AK3TqMMJ5y2kRXyfRxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=gS5P1NWz; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="gS5P1NWz"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4V39QY3Fhbz9spn;
	Mon, 25 Mar 2024 12:17:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1711365477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/SUZ1hP/5Pgovs9vwAhlpdOizZGMlFGaQSq9NfbN0ZQ=;
	b=gS5P1NWzCuIaUWumB707Z40Q8oXxuKtemdDWMmt0oX0oUa14FyCfuNcALCBI3BAiCr9KLw
	FHLZinaStZR2+YJPJM16i1/UoNEWalGjXC7vC+xoFa0ehL34EEuONqwVgsCJtymxNZiluz
	cCiAcWfP/khfI6hh+gMmzdawKjkmh/oRbozG+8zpxUqdHhXjM/7HekbfB4v3/abMwz2WXS
	Yj7vlsgRaIV9NLPLzu7SMmwetodgurHfTzFx4IiAK9I7q5c1T2K6lRPcWP/GpoOL5pwJtO
	4j9WllJEW+P4NgjHSJCkR7WkVhYxvW0+WDyH/SQOAz7uzflCB5ogSkoUiIMdVw==
Date: Mon, 25 Mar 2024 12:17:55 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <p73usozirhag4kembg43hlfaqwyn2oyjzu3au5p4aw3tdf3cj5@2icixk7z7ltz>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <wa53es767xeoxleltokuhcn5kccv5h2ocys37qqblpbplox2dc@36hvu3j6z5py>
 <Zf4Ag349VrT/kv8n@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf4Ag349VrT/kv8n@dread.disaster.area>
X-Rspamd-Queue-Id: 4V39QY3Fhbz9spn

On Sat, Mar 23, 2024 at 09:04:51AM +1100, Dave Chinner wrote:
> On Fri, Mar 22, 2024 at 09:02:31AM +0100, Pankaj Raghav (Samsung) wrote:
> > >  	 * Bulk filling of pages can take multiple calls. Not filling the entire
> > > @@ -426,7 +484,7 @@ _xfs_buf_map_folios(
> > >  {
> > >  	ASSERT(bp->b_flags & _XBF_FOLIOS);
> > >  	if (bp->b_folio_count == 1) {
> > > -		/* A single page buffer is always mappable */
> > > +		/* A single folio buffer is always mappable */
> > >  		bp->b_addr = folio_address(bp->b_folios[0]);
> > >  	} else if (flags & XBF_UNMAPPED) {
> > >  		bp->b_addr = NULL;
> > > @@ -1525,20 +1583,28 @@ xfs_buf_ioapply_map(
> > >  	int		*count,
> > >  	blk_opf_t	op)
> > >  {
> > > -	int		page_index;
> > > -	unsigned int	total_nr_pages = bp->b_folio_count;
> > > -	int		nr_pages;
> > > +	int		folio_index;
> > > +	unsigned int	total_nr_folios = bp->b_folio_count;
> > > +	int		nr_folios;
> > >  	struct bio	*bio;
> > >  	sector_t	sector =  bp->b_maps[map].bm_bn;
> > >  	int		size;
> > >  	int		offset;
> > >  
> > > -	/* skip the pages in the buffer before the start offset */
> > > -	page_index = 0;
> > > +	/*
> > > +	 * If the start offset if larger than a single page, we need to be
> > > +	 * careful. We might have a high order folio, in which case the indexing
> > > +	 * is from the start of the buffer. However, if we have more than one
> > > +	 * folio single page folio in the buffer, we need to skip the folios in
> > s/folio single page folio/single page folio/
> > 
> > > +	 * the buffer before the start offset.
> > > +	 */
> > > +	folio_index = 0;
> > >  	offset = *buf_offset;
> > > -	while (offset >= PAGE_SIZE) {
> > > -		page_index++;
> > > -		offset -= PAGE_SIZE;
> > > +	if (bp->b_folio_count > 1) {
> > > +		while (offset >= PAGE_SIZE) {
> > > +			folio_index++;
> > > +			offset -= PAGE_SIZE;
> > 
> > Can this be:
> > folio_index = offset >> PAGE_SHIFT;
> > offset = offset_in_page(offset);
> > 
> > instead of a loop?
> 
> It could, but I'm not going to change it or even bother to fix the
> comment as this code goes away later in the patch set.
> 
> See "[PATCH 7/9] xfs: walk b_addr for buffer I/O" later in the
> series - once we can rely on bp->b_addr always being set for buffers
> we convert this code to a simpler and more efficient folio based
> iteration that is not reliant on pages or PAGE_SIZE at all.
> 

Ah, I missed seeing the whole series before replying to individual patches.
Nvm. 

Thanks for the pointer on patch 7, and I agree that it does not make 
sense to change this patch as it goes away later.

--
Pankaj
