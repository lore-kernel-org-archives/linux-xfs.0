Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338242DC78C;
	Thu,  2 Jul 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010888; cv=none; b=nzIGLpZ3dKbmWeyZDuS1fhV2oZJWCO/jWpREndk6TlMM4pCRwm2z63n53eWoah0Wl6FxrTggbnYryYn1xeLQoI6EPUmVGDWru3xfqfGkR0RRTpB7T3OiFEUIFJT9UgJl8r2Oq0WYdAfX3Pi1b8Bjz6MXjfWX+p2NsFDCazEYWKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010888; c=relaxed/simple;
	bh=GijFF3a3+r93FI8Jahli6KDThLCIB8Iji292Su1urDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIiAZiiYlMlmbHn5prsOvV5aTSe78zLisBZbApUMV3Y7KlZlaBsDR4UM9c8X5oISm8q0jWiCQouuG3ClmSAdFJ3306NqdO6wrUoshs/0YFxN9eSLtMsLchIaWRJaWRC/bJy0+SbAGRKNX/dT70yGEGio1YtvghP07WxNkzXiFhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iT0hOuA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT0hOuA9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0BCB71F00A3A;
	Thu,  2 Jul 2026 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010887;
	bh=Gd5kA5A31flTBZyx3a3MBWamKVj3YR2epWeGvGQK9Rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iT0hOuA9atcQ/cgo2w5iY+jhukGAFDxPDOgyjFzjIPCvb+PuZoVW+OSuOwSaZ85Hz
	 XWTEMbwvJRAPAAUOAvYJth7hgOzZQz1ifjzrqd8Yl05mgAoX4D9iqB5tFms5JNwI6I
	 CCRhBhNqVlRngZsa58PwtNcJp4ihooXF+8JKGiuELj3nfFn5DfrsGzaQEl+s1HCxAc
	 A1lnKTWLKEugGEDKWzjszGYrNlMcHczYNrI/mXK0EAtUQeBMUjM80v/yVdLFPHux7K
	 ZL1rQgICkNoB6V9b0MlgvAHCavyaQHPmYa6uQY5pQo8U82xJegj/bMk7ZPmMx5JGlI
	 39muA137Pwfdw==
Date: Thu, 2 Jul 2026 09:48:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260702164806.GJ9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com>
 <20260702140301.GB21339@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702140301.GB21339@lst.de>

On Thu, Jul 02, 2026 at 04:03:01PM +0200, Christoph Hellwig wrote:
> > -	 * The retry mechanism is based on the ->iomap_begin method returning
> > +	 * The retry mechanism is based on the ->iomap_next method returning
> 
> Nit: Maybe the drop the "->" in preparation of the last patch that would
> make it slightly misleading with the ops struct removal?
> 
> > +static int
> > +xfs_direct_write_iomap_next(
> > +	const struct iomap_iter *iter,
> > +	struct iomap		*iomap,
> > +	struct iomap		*srcmap)
> > +{
> > +	return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> > +			NULL);
> > +}
> 
> I wonder if we want a "simple" version of iomap_process that only takes
> a begin callback, as most current ops seems to be that way.  Then again
> between needing at least one longer function name it's probably not
> helping much with readability.  So not sure, just dropping it here if
> anyone has a good idea or storng opinion.

You /could/ use a bunch of fugly macros to simulate a default NULL
iomap_end_fn parameter.

#define __default_iomap_end(a,b,...) b
#define default_iomap_end(...) __default_iomap_end(,##__VA_ARGS,NULL)

#define iomap_process(iter, iomap, srcmap, iomap_begin, ...) \
	__iomap_process((iter), (iomap), (srcmap), (iomap_begin),
			default_iomap_end(__VA_ARGS__))

--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
