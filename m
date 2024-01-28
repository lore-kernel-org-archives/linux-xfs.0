Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4199C1E508
	for <linux-xfs@vger.kernel.org>; Sun, 28 Jan 2024 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706460955; cv=none; b=FwacENOwLKVRTZk5kWtrc8h1nWXnhpaYqLRHj/qCgGnzmq1ErWEos6NKIiLDqF8/SKRKci9ptIy4kAWg70hG8GLxqD4//qg0lQHH1F6wMZjSjjK/aSurwdG6Lp0jqKBY0Xt7skwTFtB25MUW6+c0XVXWFdC1xbbLkAMLZ3aAKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706460955; c=relaxed/simple;
	bh=2S7qL+i4P+WVYWelrj8XbVWiTJ0BM0SrkIPWuUXOJeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2OZzFW2gZW8Iy27nXHB/OOxzdblKhqPTAqIPE/q9n+edbhh435KrZeXa9ANOM6rXIaR7OUTY7LY6P2CO8MJuH+hcfK9LNZxEzKw5KTD4jJJvm+s6SeUaSmNozFRTllUsJbU/51ue8B0H+G7GsqdY5ROOTgPA4g1A2gPQFYOSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A706E68B05; Sun, 28 Jan 2024 17:55:49 +0100 (CET)
Date: Sun, 28 Jan 2024 17:55:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 16/21] xfs: improve detection of lost xfile contents
Message-ID: <20240128165549.GA5727@lst.de>
References: <20240126132903.2700077-1-hch@lst.de> <20240126132903.2700077-17-hch@lst.de> <ZbPe5FjDaQp1v8En@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbPe5FjDaQp1v8En@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 26, 2024 at 04:33:40PM +0000, Matthew Wilcox wrote:
> > +static inline bool
> > +xfile_has_lost_data(
> > +	struct inode		*inode,
> > +	struct folio		*folio)
> > +{
> > +	struct address_space	*mapping = inode->i_mapping;
> > +
> > +	/* This folio itself has been poisoned. */
> > +	if (folio_test_hwpoison(folio))
> > +		return true;
> > +
> > +	/* A base page under this large folio has been poisoned. */
> > +	if (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))
> > +		return true;
> > +
> > +	/* Data loss has occurred anywhere in this shmem file. */
> > +	if (test_bit(AS_EIO, &mapping->flags))
> > +		return true;
> > +	if (filemap_check_wb_err(mapping, 0))
> > +		return true;
> > +
> > +	return false;
> > +}
> 
> This is too much.  filemap_check_wb_err() will do just fine for your
> needs unless you really want to get fine-grained and perhaps try to
> reconstruct the contents of the file.

As in only call filemap_check_wb_err and do away with all the
hwpoisoned checks and the extra AS_EIO check?
