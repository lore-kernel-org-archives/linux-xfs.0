Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F62DE1FA;
	Fri, 23 Jan 2026 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157359; cv=none; b=KypCMqpaD3SjGk9ThvndYxUfdOTH/FujGYXtgxZiMhXb6AmHnWQ4eyNb8MkdBDVXsONMAOxIHFAj7I1u0dpIeAo2rZiQ1Ig0kex5WH2yRIusoLEapma/oWLe2HgCBSbNSyx3AR6eovgh7RQSW7Mp9cDlHyHO4wKLyDU7pJgDJss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157359; c=relaxed/simple;
	bh=4xe7FzvjqGCo86DTA9TePIu6gBkFRDzmOQywZnr4y7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqliJ7gF/PMTc6xWpSpaosO1d8mcUq3NT47Wq3Gzf7n8M+E61ifZnWFxYqOfQd3q4RlE16WzCN7l7ANGWxOkxejTnkRl/c7uJzkotMruKjPvT+D19sMniYeDblQU7KXTD5nWhBLCLg3Z4STuHGVNNkUNkXZsUahsPVS7p7p5bJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F08D227AAF; Fri, 23 Jan 2026 09:35:54 +0100 (CET)
Date: Fri, 23 Jan 2026 09:35:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/14] block: refactor get_contig_folio_len
Message-ID: <20260123083554.GA30708@lst.de>
References: <20260119074425.4005867-1-hch@lst.de> <20260119074425.4005867-2-hch@lst.de> <824538a6-ce9d-41e7-9485-10ff9e4d5334@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <824538a6-ce9d-41e7-9485-10ff9e4d5334@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 23, 2026 at 07:32:04PM +1100, Damien Le Moal wrote:
> > -	unsigned int j;
> > +	struct folio *folio = page_folio(pages[0]);
> > +	size_t contig_sz = min_t(size_t, PAGE_SIZE - offset, left);
> > +	unsigned int max_pages, i;
> > +	size_t folio_offset, len;
> > +
> > +	folio_offset = PAGE_SIZE * folio_page_idx(folio, pages[0]) + offset;
> 
> folio_page_idx(folio, pages[0]) is always going to be 0 here, no ?

No, page could be at an offset into the folio.

