Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234573112AB;
	Fri, 29 May 2026 05:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033512; cv=none; b=GhkBxi67JESYzpurhmrqugSvbp3n4EXIMityy/9/P16bUgRvu6ZglIF8bsTYi/mRV7O+pf+B3cNWwCLNptB6abVm23yswuW+S1tmMA0nqIVxw1StYRzAkp82PEZuPCKeZBrIzvaX/HblKZFq88z4vpp8W7sN5D8aXXTxSrUr0No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033512; c=relaxed/simple;
	bh=6zAwC2PhkquG5vEMrjdxU/LPs3A40xGTpSytS42LEBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDnrWQmsyOKvx8Khuz9PZrDqpMio27DU6YVF9Ox/PcmHNpAGDKqEmzvCfGEMUDXRufcdOK7Hgq5ZBt8pql6HETv8d4m0qTofmO+PfuXR3CWKCGPaiBGmSYmnTpbqF/lH7MhA8tBEOWxdqQzQ5sgK0BHddZbzG4ILAR9XaYoOfCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KT8WJD1K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KT8WJD1K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+HtO4cf8uEU69g9b5lAa+gM9C4YNMHMk7SrXlLZzstQ=; b=KT8WJD1KL4FjyDLcrIMyeoIp8j
	5SBBVS7q4r2Xsw7I8fZOVujzHi8+DsqeZC4DoCzaBg6/v7pRkbIPmm1sah7iryPBkmMyca/TiXGlN
	7diIZ7GBi0HSwgOOoLwHB6laqDMX1OyMHVP6xpoU0WsNDVjsJvf2WIzCuz31uUPMDnMm7wlcyQrRB
	5vKQbY+gEtbK56QyLSoMccfhwOtDIrZiiDlbW74Q26W9oMpRnhfsQ6WLEtCcArFQwBE8AXRl5YkBs
	/o40wfVzCmKU6gRntfUAaEYJAAkdo+O3AL8SQfGFRyN88iLccIWP19j60fp13QqFVIESjPTRQRP4f
	1ALxvujA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSq1u-00000006m3y-2xLl;
	Fri, 29 May 2026 05:45:10 +0000
Date: Thu, 28 May 2026 22:45:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <ahkn5tjDTbVQF9nm@infradead.org>
References: <20260520185202.GD9544@frogsfrogsfrogs>
 <20260520190112.GE9544@frogsfrogsfrogs>
 <ahPiIAJNwjiZ9PTR@infradead.org>
 <20260529042131.GA6070@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529042131.GA6070@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 28, 2026 at 09:21:31PM -0700, Darrick J. Wong wrote:
> On Sun, May 24, 2026 at 10:46:08PM -0700, Christoph Hellwig wrote:
> > On Wed, May 20, 2026 at 12:01:12PM -0700, Darrick J. Wong wrote:
> > > +_mkfs_xfs_supported()
> > 
> > Can you add a top of function comment explaininging this helper?
> 
> Done:
> 
> # Figure out if the supplied mkfs.xfs options are supported.  A device
> # or file path must be specified as one of the options, though it will
> # not be written.

Sounds good.

> Digression: I wonder if _scratch_mkfs_xfs_supported should have a
> "-f" in its $XFS_MKFS_PROG invocations?

Probably, otherwise if you run this when something else was on the
device it randomly fails.

