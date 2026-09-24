Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317F3161A1;
	Thu, 24 Sep 2026 05:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229280; cv=none; b=bQO0lopxVjufGx8I0uQvssr+rqxSrSbpcqCyxxFtHPsIx+rqpAnYrrCNjFM7CZ4NcVihZsBhK+pSx9+xSi036GfTbCS6MXg5ONDH6ucqxgHhEP5bv2xIZZAxXzBPs22xv8NcLYPDiDh38wGJmkxLxBn0Wtb4P4pBa4qUQVI7dMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229280; c=relaxed/simple;
	bh=bTWmSxg0DrF8j1kVxelXaXE71IbpqVaO0WUJD6Snu1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knvWBsKUIz8TphWhLaQGjG3CoKkkOhPgBWpA6RM3OspGnm9In8SGaLUZGSrRE7Z5f7pJVpPLOrEI/D2T2fLmAHPsviwK/BeUqtofnKE2biPIbzUqPfKCe+gvJ0LDNdYzCQcTjAx3BHc5XqFrZjohmLjced4oHe+DuXtw9jfiWvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n5YOXYJL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n5YOXYJL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qFAj7aqBiK5qClv/cZ3T6/LcModyeQc/I74asqMXKDE=; b=n5YOXYJL+8+XsSBie7TFhUIF0J
	slTNSZOUC8plP1Uw2/DzT/NUId6JW26E2mNEwb/rielfUgu+rqBhmgt3iZ65Bg0kmKGcQhzXPmFyl
	PhAYE9Qv8NX4iCa70II8qnJ8ESb4HzqQxpGP9SsSRdjnop63D84C8QIxXMi70Xrt2cc/6Hgkyn8wO
	Wz2hs6wLR4bccLUMBm4FlUzUZQWob72p+9A9spLMOWZIW6HDoKDXHSD6HeNhqk/nM8oO/7CaofYaS
	fLcq6T/9rHKnaulB/whw/hxMIIala+s4GvvBQm7/PczxZJhD52HrYbxJmxQoGgGm7d4szLiUbTXP6
	8qOySo5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cPm-0000000A5sc-45KJ;
	Thu, 24 Sep 2026 05:54:38 +0000
Date: Wed, 23 Sep 2026 22:54:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: fix unnecessary dapos truncation in
 xchk_dir_walk
Message-ID: <arS7Ho2yZJ3M6KZG@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159756.1875436.1369162178937848347.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159756.1875436.1369162178937848347.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:03:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that the all the implementations of xchk_dirent_fn can
> handle a signed @dapos parameter, so the truncation here breaks the
> information captured in scrub tracepoints if the directory is very
> large.  I don't think it ever made sense to do the truncation for the
> VFS readdir code for programs that can handle 64-bit offsets, but commit
> 15440319767942 has been around for 17 years without complaints so I'll
> leave that alone.

That code doesn't make sense for various other reasons..

But the Posix definition of seekdir/telldir, to which the offset is tied,
have a hardcoded signed long, not a off_t of some kind, so we can't
really go beyond that.  But silently truncating in readdir for this
almost impossible to hit case doesn't make thing better.

Enough ranting, the fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

