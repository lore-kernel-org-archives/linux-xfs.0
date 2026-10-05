Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022284766A7;
	Mon,  5 Oct 2026 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205173; cv=none; b=SbsqT8A/Cnh6L8cW61b9dwyJ2SKip79Yd/o62OHfkPhJhWZdRXCPsxNqEOSSpAXzJsZiYOuvch/Q3v8rmNnK0UQ54xWsYyq6z9m/fUr7jo3zLvx9Z1SlEsH7aDmkOpKh3P8o8EDrVdILS1V8202Aq7H/iLt5VtsnFWSyPQF9gzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205173; c=relaxed/simple;
	bh=XCaZn+eC/NkpzKv/UhZh2LfTYdVZyn4LLagbbDImyeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3vSzqQ98vTf3HpyHadinCqB3TvMnDIwLEO+nPyiu81o2Ztyqhs5583vlmTGo0RY+mGLt2n0/VclV2h0HQbhGROi97KnrOmPFSpfvCQ6/0l63oJ2hbgOqCG6XodgzkA3umw1xI//DSPKlf6csp3jGnjNMvGUux/l3IONdVe8xms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BEAC468AFE; Mon,  5 Oct 2026 14:59:27 +0200 (CEST)
Date: Mon, 5 Oct 2026 14:59:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/21] xfs: add support for reading with data checksums
Message-ID: <20261005125927.GA26805@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-15-hch@lst.de> <20260929004204.GV2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929004204.GV2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 05:42:04PM -0700, Darrick J. Wong wrote:
> > +	error = -EIO;
> > +	if (WARN_ON_ONCE(ioend->io_bio.bi_iter.bi_idx))
> 
> What does this warning mean?  That we've somehow already advanced the
> bvec iterator?

Yes.  I've added the following comment:

	/*
         * The main I/O end bio is either freshly build by iomap, and has both
         * bi_idx and bi_offset set to zero, or comes from a bvec iter for
         * direct I/O, in which case bi_offset can be non-zero, but bi_idx still
         * must be zero as the bio always points to the first actually used
         * bio_vec in the iov_iter.
         */


> > +	/* No bp for early xfs_rtcsum_prepare_read failures. */
> > +	if (!bp)
> > +		return error;
> 
> Is it possible for error to be zero here?

It shouldn't.  I've added an assert and clarified the comment.

