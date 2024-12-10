Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AA822619B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809769; cv=none; b=Mt+hhDknP2i5st3pTrhywnGiV1yr0ubzAf3P9Z6GujSB10XpR8bk8ischY/CUtgaIufTOMSgPfcFKkgQTELf34FYpeuBLjkBHoVVYl6+hcn2NEOvAAF2PWWQ16AzT+s03IjSzd8zL7QvGEZ18n4ZyG98StOO0UjbeLPYpIlxLPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809769; c=relaxed/simple;
	bh=1jyaU26sNSXCM7uRcGUAajKl5T6aCBpQx5lqHVlmUXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWT9I80OLk7KMUAWH1mK6WJuHoHeSFFeuFOGfTjqr6znLrRQ4HYf59UevXdijXSZm5cCmbMEt2PtoBH/o5rlA/Z7c/SNT1fcf4czU/n9l+wq2J7aVjZLohAeT0GSwUiHm0KA5nlbiDGF/z/v0OhcWVKWlBCEvnSDB8c0IvxORbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pfr4wnxN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pfr4wnxN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LX6laIUAepp59zt5PyDXOoNsSt5vjE5TCi0EwRSisb0=; b=Pfr4wnxNvKm58D0QjsGyb4dRDK
	xKW9R3y6fS27Xoiif/dbPuItIiQOAbYyHKGy9KX5HSONtQE7is+iCuA2R1obxBoazICBjWtK+HkmC
	oMrcHEc58uD3jN1zP/r5bD6zgu+fz4m+oDFOuu19I2jnojldTV0PfL3jUoYcXU7KTDJIxb+fmRzvd
	kFV15CouePSicm6bOHcfN6xv0Z9mGYRulcJrX89VUMNFeWN8KlX9nuYyAOBOaXPcOOb9sjIM7nm8E
	FhiiXaXwX/1RQN/l5aFwKLwcX6x0oT5WvcCCG8KaVnATFW/mJF+F6vKe5WIyoHdSIylY2Qwtb85qn
	NSCnvdTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKt7f-0000000AJQD-2Xd4;
	Tue, 10 Dec 2024 05:49:27 +0000
Date: Mon, 9 Dec 2024 21:49:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/50] xfs_db: report rt group and block number in the
 bmap command
Message-ID: <Z1fWZ1_LZoJIW2X2@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752480.126362.14408954135415554700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752480.126362.14408954135415554700.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:14:05PM -0800, Darrick J. Wong wrote:
> +static void
> +print_group_bmbt(
> +	bool			isrt,
> +	int			whichfork,
> +	const struct bmap_ext	*be)
> +{
> +	unsigned int		gno;
> +	unsigned long long	gbno;
> +
> +	if (whichfork == XFS_DATA_FORK && isrt) {
> +		gno = xfs_rtb_to_rgno(mp, be->startblock);
> +		gbno = xfs_rtb_to_rgbno(mp, be->startblock);
> +	} else {
> +		gno = XFS_FSB_TO_AGNO(mp, be->startblock);
> +		gbno = XFS_FSB_TO_AGBNO(mp, be->startblock);

Maybe use xfs_fsb_to_gno and xfs_fsb_to_gbno here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
