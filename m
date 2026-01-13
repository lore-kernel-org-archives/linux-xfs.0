Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DF2AD5A;
	Tue, 13 Jan 2026 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768319890; cv=none; b=EjmoKcPzxMNBdpNS9NBKQVsHtn8sizsB5x2ayshjyggdplqBVkCaGlOyiqZvqIUAcz2LRW1D9AIyXFPcSDnRFzCPrYpwih1vVOTXvm51MxhK0xypMbmQCJWd4j9m62JGdOLxGG8mQF3tqQMFJO4ziNx14ELFh7Y/VB2RduPiG6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768319890; c=relaxed/simple;
	bh=STwS1iOUfZ7Lwx6nnQwadfZDFDVePAofhZgw553iIAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEfy1obLvMoaH+sHiHrdJ7L8ake5vqtr0qwanIMQR9hznBEdDfX1W2U5mJqfFgnEpK2Ji7t59tRdXhKPFDOn6aVIcsHiU4Y7B7sksIFyybXP6vcDAKyFX1UUf8pyKpVGBMnGju6A1pI8+x5UMsxWhAZeolgGlGVHfSBoDE6pIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA716227AA8; Tue, 13 Jan 2026 16:58:05 +0100 (CET)
Date: Tue, 13 Jan 2026 16:58:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, bfoster@redhat.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: wait for batched folios to be stable in
 __iomap_get_folio
Message-ID: <20260113155805.GA3726@lst.de>
References: <20260113153943.3323869-1-hch@lst.de> <20260113154855.GH15583@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113154855.GH15583@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 13, 2026 at 07:48:55AM -0800, Darrick J. Wong wrote:
> I wonder if we ought to have a filemap_fbatch_next() that would take
> care of the relocking, revalidation, and stabilization... but this spot
> fix is good as-is.

Let's wait until we have another user or two.  Premature refactoring
tends to backfire.

