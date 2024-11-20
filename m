Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF041AA794
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732112895; cv=none; b=O3gYDatRct6q/VOsFAWKrUVcXgkNuPE2fxj11N8ng/+loUHY0fBffjH81uksZIsHdMGzDRHgJz3Mne6+LyCH7hyTuc94DsWMuDeyCGXcgQ5xi+Yk65ew2OjAskKzZKkMIyVlSBJojyneENyDNbKGIuHAQNDqc3a+Mls8d3PI2oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732112895; c=relaxed/simple;
	bh=VcfT+TOEehb0BHrfRCO4ylVJVaRSqpSV7NZiJJXUZBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLCPYtTSZO/3cuF8LHvBgxuGEQo1jhijae9f/aX2ZZvqf+U2Cxvv3BJYPAj9ZR9iJGBwZYpC0J9ibz5ojnedFWtWZfM9RS6VIfchKgWZMWzgZLaAba60A1BAWKSoPAzWh4Tg0QnSQu/9IsjF1kb9btueO4ry/6GUwQKYhN8kccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3nLzdb4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3nLzdb4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732112891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fOqVT7qgxsLioMds4Vj1na0BAUHhzs1xNTntAsj3qsQ=;
	b=d3nLzdb4yo7UC+koxzIdfA3LnKvSwLIdySE66zaUk1X3p3/KW5kncgNFpEfwM445Y2sgym
	mwcdhO2SwvNe4b88HeU4nqiSBY/oc/3YJhoT7KY5npyB/qjG6ObJVyIruUl3dwS/MwN69o
	yLw7x7nIOAPbBwG7/Fea5Fw2PrfW36o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-jcY-4ndsPW2-UX94IAH32w-1; Wed,
 20 Nov 2024 09:28:08 -0500
X-MC-Unique: jcY-4ndsPW2-UX94IAH32w-1
X-Mimecast-MFC-AGG-ID: jcY-4ndsPW2-UX94IAH32w
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD4CC1955F56;
	Wed, 20 Nov 2024 14:28:06 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A9D21956086;
	Wed, 20 Nov 2024 14:28:05 +0000 (UTC)
Date: Wed, 20 Nov 2024 09:29:38 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] iomap: allow passing a folio into write begin
 path
Message-ID: <Zz3yUlYfrqAKiwbV@bfoster>
References: <20241119154656.774395-1-bfoster@redhat.com>
 <20241119154656.774395-2-bfoster@redhat.com>
 <Zz2gEfgY8G7oTpdV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz2gEfgY8G7oTpdV@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Nov 20, 2024 at 12:38:41AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 19, 2024 at 10:46:53AM -0500, Brian Foster wrote:
> > To facilitate batch processing of dirty folios for zero range, tweak
> > the write begin path to allow the caller to optionally pass in its
> > own folio/pos combination.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index ce73d2a48c1e..d1a86aea1a7a 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -781,7 +781,7 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
> >  {
> >  	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
> >  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> > -	struct folio *folio;
> > +	struct folio *folio = *foliop;
> >  	int status = 0;
> >  
> >  	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
> > @@ -794,9 +794,15 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
> >  	if (!mapping_large_folio_support(iter->inode->i_mapping))
> >  		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
> >  
> > -	folio = __iomap_get_folio(iter, pos, len);
> > -	if (IS_ERR(folio))
> > -		return PTR_ERR(folio);
> > +	/*
> > +	 * XXX: Might want to plumb batch handling down through here. For now
> > +	 * let the caller do it.
> 
> Yeah, plumbing in the batch here would be nicer.
> 

Ok, I'll take a closer look at that. IIRC I punted on it initially
because we'll also have to fix up pos/len down in this path when the
next folio is not contiguous. This was easier to just get the basics
working.

Brian

> I suspect doing batch processing might actually be a neat thing for
> the normal write patch as well.
> 

