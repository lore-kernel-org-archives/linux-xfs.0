Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DA4388E6B
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403680; cv=none; b=WkrjhBPa1y4A9JpcadNIZN/YCODIWUx/n6QH3OJvoWmlu77O8pDgDBwW1dVj8e6ELFjig8OSkUJiHfJPuFwV0v2vTcXSklUzsWiqmz0r7UHNOiEDVFisoQHuI1uK5MEtBJIgUHCmpuwYsGIeIVLesx9BoydsBynIa340f8ihSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403680; c=relaxed/simple;
	bh=FDlnKY5EwjpwfZYf4zHl0D9M9kexVg+wLkqDnLMWJdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuqnuP2uJdelLdc8xC3iywcJQnzgYE/U+aBp9/dZjOltaeg813LccdvpXcczQub0rgU5cQJ6309Fg/1WTiJJZdlwNYVM4pig2ZuENgZhThVlno+Z6hY8oIisRT71LYxCrIHiW3OEcibMd38674Lsl4hsMs3G2REGeM7LoxxrABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 074AA68C7B; Sat, 26 Sep 2026 08:21:16 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:21:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/32] xfs_db: support RT data checksum
Message-ID: <20260926062115.GL20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-31-hch@lst.de> <20260925234358.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925234358.GP2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:43:58PM -0700, Darrick J. Wong wrote:
> > +	{ "csums", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
> 
> FLDT_SUMINFO is 4 bytes, this won't work for crc64.

Ouch, yes.

> You might want to add a FLDT_CRC32C and FLDT_CRC64 so that the sizes can
> be correct, db can convert them from big-endian to host for display, and
> the display can be '0x%x' instead of decimal.

The values are little endian, just like the xfs metadata csum.

Do you remember how to dynamically switch between different
interpretations of a field in xfs_db code?

