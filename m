Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D24643B6C1;
	Fri, 25 Sep 2026 05:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790315616; cv=none; b=arQhtWGkrhZjKWHZSKqIj1gDeS0fxZSx6iFzCcjHKv/T0KHrz++BXLG/W5h5V8I5BO1OerAr90tNC0Z3VP6yQr/bWRl6SDkpAXzzWasvi8FA0QIcZg4G0VBo7GCaEchY4AUf6qoRztGypX/Q8eHlFEKpm4kT+8ie5AEqK7F/K8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790315616; c=relaxed/simple;
	bh=KEM0XfA1sB17+O8SNf0ps4dVPmvoj1yyqrFVdCgH2LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNao9lMvFTAnib8aaZE1+D3w01pCJWAYMaynXxAH+/c/q3ANcNpE6oRoMbAHX7XBMQuXifFUexqSfLo3ApDrilf81rHHH0/+InLM1ju7vBndaE6VAabmPLFcjBj//0Lw7YFnprLxQtQz3bUebrDDc2JVzv7A1oTbVQ0c1yfgYFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 057BB68BFE; Fri, 25 Sep 2026 07:53:31 +0200 (CEST)
Date: Fri, 25 Sep 2026 07:53:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/21] iomap: add support for data checksumming
Message-ID: <20260925055330.GA3193@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-3-hch@lst.de> <20260924213902.GD2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924213902.GD2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 02:39:02PM -0700, Darrick J. Wong wrote:
> > +void *iomap_csum_alloc(struct iomap_ioend *ioend, u8 csum_shift)
> > +{
> > +	ioend->io_csum_shift = csum_shift;
> > +	ioend->io_csum = __iomap_csum_alloc(ioend);
> > +	return ioend->io_csum;
> > +}
> > +EXPORT_SYMBOL_GPL(iomap_csum_alloc);
> 
> AFAICT, io_csum_inline is a small amount of memory in the ioend itself
> to store checksums for the blocks being written, and io_csum_alloc is a
> dynamically allocated blob if the checksums don't fit inline?

Yes.  And both can only exist for the initial ioend and not a split one.

> And io_csum points to wherever that data lives?
> 
> Hrm.  What if you want to split an ioend, I guess the child's io_csum
> points to somewhere inside io_parent->io_csum?

Yes.

> (Perhaps it would help to point this out in the struct definition?)

I'll find a good place to better document this, thanks.

