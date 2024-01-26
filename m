Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DF91B801
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706288149; cv=none; b=uc8G6Ry97sLrS5kTS3nLKxu9UXjwSfDyr0I4EmHKYdgLlSznSfSes1CjIyLz+UIptey9UAe068syPnBNvaZpWaX+pdinDsWVNgvHDF6IeULKaPSuW5fLizv3y/8/k+zJ014n/IF9QrrMSHhEhR+Ht81PhjtkFqlviyd7bz1ZO58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706288149; c=relaxed/simple;
	bh=cRc0miYazSjnGEd+EQoiEWD4pNFHkgnoD6TA9pNiYlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXlt3cciTC/Bf/HfQkkHzx/VZx6B5JbbDfkh3WLEb4gHx9vQJaN4Sier0jLrF9o9ONg9q44XV7r6tn6fsCttzG79920GpuEPS/Z23dxOZavg9O4s39WYtUWUHdnbQ3erkyknqPs/PLNJZJ8pIDLeG/l5gdJDys3vCqPS9E0oa0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7cZvYLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7cZvYLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2900DC433C7;
	Fri, 26 Jan 2024 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706288149;
	bh=cRc0miYazSjnGEd+EQoiEWD4pNFHkgnoD6TA9pNiYlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V7cZvYLu+Wz9uFxVonT9zlS3FvJSUyrMyP6TpGq1zuwC3etAQTOn1RgzVri7HWcTl
	 nkh8KjKyJsybignhIRrIsWILpmEU+EeHdxVAw3vedr/E5tTqOEeX0Vt/MJBL+fbwW4
	 SSfEiq0PkBwj1005vnpzN2TyEcULNjBqbcHMqTSjS3FttDsztWzVe2F24GRm3enKjQ
	 x5uCZTpP2WD4QQ4Q+NFdzJW3EARbUrOoeCRdUjdg7/s692SCAQVRR+DvxFiEnO0XQ0
	 3WEXk+K8qqoEGtaCNxhcUFNhmEFnoFcIdJpsF2tJ2nBe1g1CeKGC7TZuDMbLwptgND
	 H4t064ocy7B9A==
Date: Fri, 26 Jan 2024 08:55:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 17/21] xfs: add file_{get,put}_folio
Message-ID: <20240126165548.GD1371843@frogsfrogsfrogs>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-18-hch@lst.de>
 <ZbPgme3NpN3F-y6v@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbPgme3NpN3F-y6v@casper.infradead.org>

On Fri, Jan 26, 2024 at 04:40:57PM +0000, Matthew Wilcox wrote:
> On Fri, Jan 26, 2024 at 02:28:59PM +0100, Christoph Hellwig wrote:
> > +	/*
> > +	 * Mark the folio dirty so that it won't be reclaimed once we drop the
> > +	 * (potentially last) reference in xfile_put_folio.
> > +	 */
> > +	if (flags & XFILE_ALLOC)
> > +		folio_set_dirty(folio);
> 
> What I can't tell from skimming the code is whether we ever get the folio
> and don't modify it.  If we do, it might make sense to not set dirty here,
> but instead pass a bool to xfile_put_folio().  Or have the caller dirty
> the folio if they actually modify it.  But perhaps that never happens
> in practice and this is simple and works every time.

Generally we won't be allocating an xfile folio without storing data to it.
It's possible that there could be dirty folios containing zeroes (e.g.
an xfarray that stored a bunch of array elements then nullified all of
them) but setting dirty early is simpler.

(and all the users of xfiles are only interested in ephemeral datasets
so most of the dirty pages and the entire file will get flushed out
quickly)

--D
