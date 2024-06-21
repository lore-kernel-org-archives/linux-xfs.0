Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B2D13B59E
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 05:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718946366; cv=none; b=aH6Kq3XlZ2z/GV/7Muh4/QRNK86NlzsHa9BfazUBir7XxqQkZmwZCA3/Q96TLQLnhiXfPBaXvHxa7uzUQ4Mxf3acnWNa0n5awFXcmk5EGPY5zoDRgWWv2199wcXxLIoYp1JLpa5fGNx+HppNia4b1wBGAUxCLsMlzvUasGyQ/tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718946366; c=relaxed/simple;
	bh=WWanii8ktDufkH2YFTn+AwQYLJCFg8YOjIPaHWEbO6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QX1FThg1yQ4szRxbeC/r5G15f9omhGvPVoDU9gCW+4HzSoNGROk2MKAyJVNW0a10WqyDf0qTQMFxQs7hcpBxNGdvEjAkZXZI9HWaJ7LfhyOvsUvZ/nww0C/sogeXKVT/3lYuEZUa4NeUgHEfYV0drf3OjnNimTBBZmajX/WKvOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BFB868BFE; Fri, 21 Jun 2024 07:05:59 +0200 (CEST)
Date: Fri, 21 Jun 2024 07:05:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: simplify xfs_dax_fault
Message-ID: <20240621050558.GB15463@lst.de>
References: <20240619115426.332708-1-hch@lst.de> <20240619115426.332708-4-hch@lst.de> <20240620185026.GA103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620185026.GA103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 20, 2024 at 11:50:26AM -0700, Darrick J. Wong wrote:
> > +	if (!IS_ENABLED(CONFIG_FS_DAX)) {
> > +		ASSERT(0);
> > +		return VM_FAULT_SIGBUS;
> 
> Does this actually work if FS_DAX=n?  AFAICT there's no !DAX stub for
> dax_iomap_fault, so won't that cause a linker error?

IS_ENABLED expands to a compile time constant, so the compiler eliminates
the call and no stub is needed.

