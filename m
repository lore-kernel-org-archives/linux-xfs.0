Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B274A32AAD4
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762870792; cv=none; b=nZhFUjHUnrMJJq4HWJI+n6pYO8eHy2RH095X3P6qAv7+GeNH8yG6nLh7KqkveeeHrDqbsYMue7wUUPrpeZETo1EpvOnorZkSfdnPVPs0hxThLhvE616hfwO5DhSsCE/7JadsWN8fqcxFAYGqJPmR01ixTb1WG1uD7ai3fjSr8uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762870792; c=relaxed/simple;
	bh=Fm2FN9U+y7VY9pB7oSF0WfcrsUu13mFDdg/CUjF9dkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtNsjZgjxKBuX+/P0vx9n8nJ9A0Uu6aZsMwwiQ3/k9jaP3bUJm3SqHV1m0XVLnv98YTE7EZKhmLeuvUXkSDGGY2kgZAUiXUC233C93ZWO1TyqPezZfxFsJcWlQDKk1YC9iA2pHhlGhNV7lGVlCpIq4alS9G/C0+BAolNuc+3IBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MojdgW5z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MojdgW5z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nhw5FxvJegSXHKBweHHe0DkjHygnkNv2xsks6C0GUN4=; b=MojdgW5z3DWIdfXFjqupd9yIvL
	ORK/1UxXmWT2V8e0dvYg1YokVl/1aWKjJxo6rNoeP4VxU7UGbBHiNFv+BImX+b+Cbkn9OHNxlKQ+D
	9492DCotueLMgLjsBsAXbHRH0hsgCxtvmP+ZycLKL0j2OjC2CwUdS4xCTJGoGCFZB2eA9MZUsxMKE
	x4UBV75dmRq0xewaedr/s5gIEyJE4ajosUOByg6mShFtjCv69lR3MmvCLR8RqRLduV9PeGc7Hi2Xp
	SpUGKiyIBiy7faNmh11CyEXSQCXZfW3U0ftM16+ndJsIyo117+rgfiJe1Bkn+//eoI0ltw5zlTVnv
	wOVi+X0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIpDq-00000007JAf-1R0V;
	Tue, 11 Nov 2025 14:19:50 +0000
Date: Tue, 11 Nov 2025 06:19:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: aalbersh@kernel.org, david@fromorbit.com, hubjin657@outlook.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: catch used extent array overflow
Message-ID: <aRNGBoLES2Re4L5m@infradead.org>
References: <20251111141139.638844-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111141139.638844-1-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 11, 2025 at 03:10:57PM +0100, cem@kernel.org wrote:
> -	int			used = nex * sizeof(struct xfs_bmbt_rec);
> +	xfs_extnum_t		used = nex * sizeof(struct xfs_bmbt_rec);

used really isn't a xfs_extnum_t, so you probably just want to use an
undecored uint64_t.

Otherwise this looks good.
