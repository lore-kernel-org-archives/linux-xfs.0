Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683342D63E5
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 10:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989814; cv=none; b=Hb9jVJwQOCx+wJxW0ABO/9PmZXgfIg1Jn7gCUrU79nwKezblHlvoMLbjlH3AGkAAsMTRCI1Knngi1Y+zAvRMaj4OTadjCrAHRPm6WjuWuk6Zb21VPB1kB7hTyk5c6lYqgkK54cxpkmXKqoidmRQHbk5EWKcLiuBM0WTZkR4e85A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989814; c=relaxed/simple;
	bh=MOLGT0wpEI2QgVZ/U9SxLJq55lOS/i2bl7BlEUarszQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjrcxjFmWxPyNmI0D/FnO/Sydg4pM2fPkwtQdhrHtYMqoUUz0vnOymEJcevLeCpyx0GCtnSRInCALfiDbJg8rRAi6BuISSPkq7e+CebHnkCgmWi4VAlFN7TXoszbPY1pcsx5zISdy4GQIx0nLiBfLG9CUNVVHfwRSyeHa7vljjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MVlOi2o3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MVlOi2o3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jZos+ryvpsrHoMsBt2hZg0ksUqeET6yr0PeglR19pJA=; b=MVlOi2o3188yUjqqFqgSTc2c76
	L+eQusu3yP6iM1gq2SJcfsqRCul3oW5gQ/5W3Fv7I1iSCcoK7MoLMKh8Cl8vdzqZUsBreJS259rNi
	dfL62xVHWTKn+UAXFevjFiISriVNJ2r5/Va9fvb4oEFj5rE/RIC7sSZR5p7dn9JlhosFA0NOY4r9t
	o3G98oV33OHZNLortyszsAWCMDbvWMT8cjri5vQMxvlBYQxhkrrZJCjFeBUFpAxaroBoazz7Jwf65
	4njYSVTQzCGVdj3QaEXTcAy8JyZZ6YGkwRnRZjYcQE9lgVlRJg4Icf+HDH/JXNoKkkwgSYN/HY+TQ
	78VhDztg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfF6B-00000004F24-2CdT;
	Thu, 02 Jul 2026 10:56:51 +0000
Date: Thu, 2 Jul 2026 03:56:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Weiming Shi <bestswngs@gmail.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 3/3] xfs: fail recovery on a committed log item with
 no regions
Message-ID: <akZD87nbm6q0KXrP@infradead.org>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-5-bestswngs@gmail.com>
 <20260701220838.GI6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701220838.GI6526@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 01, 2026 at 03:08:38PM -0700, Darrick J. Wong wrote:
> I agree that a totally empty log item is a sign of corruption, or at
> least something going seriously wrong.  Can the runtime log code ever be
> tricked into emitting a bare transaction header?

I don't think so.  This looks like an automated search for bugs in the
parser.  And while I'm happy about tightening up all parsing, I still
think this should be stated in the commit log much more clearly.

