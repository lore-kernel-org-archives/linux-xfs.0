Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C674732F775;
	Thu,  4 Sep 2025 06:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756965643; cv=none; b=C0kJeAxyMKlKsRDtlG8c4qtKFeJdJiWrD6yqX+3yuCDTCnlcTPqa/LNo5AZDepGl3q6bHitXR0caFhSLXHWlzegOqLNrWfkZEX5yxXLG1hls3mv44jkOpKyrJxXU7PkT8WbT6sdHiDK0WdxuE/OY3URCZTQxRZVPv/ZDH+K2QRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756965643; c=relaxed/simple;
	bh=33citsjqgJKqmysaG9AO6VPNkvkmlonfA0zuht2tGg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQYAVflw6GGSpncoAHD5twlm/LuH0IX7c/0f93+n7Hssfq2IfUiqgOvqxV2LGzLGZOouxbzzSc2wrijJDCRQyYJkVQ12FrhyWaUw1TNVb/JM6ExlW3Aqc8BPXAHYl1PQjIBS9QizXqjnBma0Y618YMuwfa1bbgikWFAZHoC6t5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XzqejuaP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XzqejuaP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LlLqJ4E6KRh1PPACkJf/clH5UCgW54K+DvxcXFvIK8c=; b=XzqejuaPM9gaWSIr34HKoP32TN
	+I9lSxLpGjTrFZg85jHSPlI2Zei7smw3OfhW3FjMe67/0ZynhIapXuAzHOVYxJya2jlUBlYVtsDeM
	IoDmAaixEnaaPAMryMVP4HpPDu8cqArpPXIaJL/zkJXzK1G+b4yiUIysrMQIuJwHrd2jGvIEjBd4T
	jeJ3h5VyI1O+MjgfMkQl45J3MaO5xQvetz14jBf9x/eYlcjMg9c2XA8P2clYLJpT+sPqWJStVxYz4
	0hmnZzI2iUe4RrO8Mb1XacSRz4AWnEfkuUWHtbP1sa2+jSLeRrbVySC1TxoC3GQlOUCdzHoCRxU7P
	due5p7qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu31T-00000009Ntg-2ely;
	Thu, 04 Sep 2025 06:00:39 +0000
Date: Wed, 3 Sep 2025 23:00:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org,
	miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com, linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 01/16] iomap: move async bio read logic into helper
 function
Message-ID: <aLkrB7CcPsaEkaA-@infradead.org>
References: <20250829235627.4053234-1-joannelkoong@gmail.com>
 <20250829235627.4053234-2-joannelkoong@gmail.com>
 <20250903201659.GK1587915@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903201659.GK1587915@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 03, 2025 at 01:16:59PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 29, 2025 at 04:56:12PM -0700, Joanne Koong wrote:
> > Move the iomap_readpage_iter() async bio read logic into a separate
> > helper function. This is needed to make iomap read/readahead more
> > generically usable, especially for filesystems that do not require
> > CONFIG_BLOCK.
> > 
> > Rename iomap_read_folio_range() to iomap_read_folio_range_sync() to
> > diferentiate between the synchronous and asynchronous bio folio read
> > calls.
> 
> Hrmm.  Readahead is asynchronous, whereas reading in data as part of an
> unaligned write to a file must be synchronous.  How about naming it
> iomap_readahead_folio_range() ?
> 
> Oh wait, iomap_read_folio also calls iomap_readpage_iter, which uses the
> readahead paths to fill out a folio, but then waits for the folio lock
> to drop, which effectively makes it ... a synchronous user of
> asynchronous code.
> 
> Bleh, naming is hard.  Though the code splitting seems fine...

Maybe we can look at it from a different angle - the code split out
isn't really about async vs sync, but about actually using a bio
to read data from a block device.  Which is also kinda important
for what Joanne is trying to do.  So I'd encode that in the name,
e.g. iomap_read_folio_range_bio to mimici the naming used for
iomap_dio_bio_iter in the direct I/O code.

