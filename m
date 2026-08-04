Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7283B394EBA;
	Tue,  4 Aug 2026 18:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869823; cv=none; b=eF7siKxBvALoDX1/CkhHSq1TsWCwHZKY8Y2wDyJGrHv3vHtsffZu+9kbneXpwY/eJhEYQpYw43XRQTPL2fENqwOsemZMiRSo8Q6bCbwvza3eKEeYNGKfyd1H6/z7yQWqhg/h0ueFST2mkq54r21H2UX3q3E0s2qlwucwBxHhS98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869823; c=relaxed/simple;
	bh=LHSZsrwWDBaz8zP92XmnGn8A5ADmrhSn0wLK+F/uS0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9YmQsrZEJJdskLOWI/x2t15agmwDRDXyK6loL8lq3h/QoiR3pk1VzdqUMotWa5qQIlG/ZpzAiEaa8cigu0gNiVv3NEro7AQ6Rodmm1u5WSidRrjtQs1KfOIlV53eJNNQvxIcVZNQ8PQ/EOPegyIJTCKjmsSDCgcIbqta8VokOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTBfxSVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTBfxSVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD491F000E9;
	Tue,  4 Aug 2026 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785869822;
	bh=uhwOVppSRbXMKKCTiEx73huPloNqZB23NIsD+UJKgS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bTBfxSVxHNSSiTMy+XjmV9JBgdMXcWkEebXrsyCKAkbJNr8hufQTkhA6FGGPT2uzo
	 iZYvyjT3K2TFnrn3clOypQEb4II+OrC8nJvvox9oLcUqGhJfIEUvW/+P+vFJZ6xMK+
	 gFxLsdaYceaMJzuiWoV+70e6FHCwN8TL33ngig3OwaoZEawbkDLSE5snIUptVic/Bt
	 GCABBSFvEra2BcEDwDwK5/5LASdWsesh/FNkh9B8Hgdnf1J+VnTqbAtpf9Gylcsmct
	 dgSVt7rxeCQPVfNr6yaiMTOj3KxtKb9jzMjxe54cdXAPZAcE7PQoB8FxDk+43jgl3B
	 5evwlyUajkuCg==
Date: Tue, 4 Aug 2026 18:57:00 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260804185700.GE2904385@google.com>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
 <20260804174223.GB14046@lst.de>
 <20260804183752.GC2904385@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804183752.GC2904385@google.com>

On Tue, Aug 04, 2026 at 06:37:52PM +0000, Eric Biggers wrote:
> On Tue, Aug 04, 2026 at 07:42:23PM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> > > The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> > > flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> > > systems. Open code folio mapping and flushing to copy all digests at
> > > once.
> > 
> > This looks correct, although to me optimizing for this feels like
> > premature optimizations not worth the ugly code unless we have numbers
> > to justify it.
> > 
> > If Eric wants it:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > > +		if (folio_test_partial_kmap(folio) &&
> > > +		    off > PAGE_SIZE - offset_in_page(offset))
> > > +			off = PAGE_SIZE - offset_in_page(offset);
> > > +		for (; to < (vaddr + off); to += vi->tree_params.digest_size)
> > 
> > Style nitpick: no need for braces when comparing with simple
> > integer arithmetics like this.
> > 
> > > +	for (off = offset; off < (offset + len);
> > 
> > Same here.
> 
> Well I didn't ask for it per se, but I pointed it out and asked whether
> anyone will care about the combination of XFS && FS_VERITY && HIGHMEM.
> Based on Darrick's email it seems the answer may be no?
> 
> If it's kept as-is, adding a comment mentioning that it doesn't need to
> be optimized for HIGHMEM would help preempt any questions about it.

Note that the explanation in the commit message seems to be confusing
people as well.  It only mentions flush_dcache_folio(), when the actual
performance problem on HIGHMEM would be the mapping and unmapping.

- Eric
