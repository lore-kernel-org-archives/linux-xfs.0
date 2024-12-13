Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965FF157A6C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734080909; cv=none; b=GY2yDqHWrM3p982yE4zY0p6gvKQkgOqQKtiSDIwwiKE+OHklIlOrI1x9xcJUAfXhQu2UH50jlSp2ZbhquX61EgvdGHtm5SPTfkuz13lWp2v3jQ3Sburlk2s8AhjBrhYRwFiY4OMcERs+iO9eLmvTGf8ja7O2w6XBvVczoNJpsC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734080909; c=relaxed/simple;
	bh=h3TVI51bp/LBvoWtV/uZmrTjE0nxL6YCSvJxnMOox4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqhRaJCf3niN77xgSRzv2eNhMVItgstOTY4DZwci/J0xtuwyWAniLWlPh3xsj0R3NCiv1fpEJsh/bMEqT6FkUGDsYG3LHoIuNkqqS32i7H4eXb8MosIBg01xuKCiIh4Fw3tQknTqbOaO6yrNuYHmBdkW4PvFOyYeB+3mypwmQEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0KATDZe4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0KATDZe4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TCZpT1nUrDBstdMKj6VzkzUAlf68cmlh2BC1n5aGCYY=; b=0KATDZe4dcroxhBSe375qWyqBQ
	FkbFX8+n2MMgI16FGh2h0A+qD1GYIiez2ENbrP1J+oAiWC1JGM/UTlQQphk2GPhVoSZdI+6d8j1xV
	7trHStNgKTfUTdli6B232najLpG1rSwjdRpe4K6rZjMzIlqz5gBqn/QxNMrLVVwc5KYb9Wlo+UFBH
	LRRn51xXf1VQKF+V+jgJwrbQDBUPP8Xq+7NRs0jMCgUa6V4Y5RTo10v97R4Dd/uCE4MSp42XzyJQ+
	nR5r/NmsMEVrbmVTZT/0YsWJt8LMY2XLR7tKVZvlIQg8fUZQG+N6k2S/7WRWUPxDsXRWwcoDsiNsl
	fba9MxoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1eu-00000003BjI-18st;
	Fri, 13 Dec 2024 09:08:28 +0000
Date: Fri, 13 Dec 2024 01:08:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/43] xfs: introduce realtime refcount btree ondisk
 definitions
Message-ID: <Z1v5jJFM4COV9cKY@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124618.1182620.6370020995613116382.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124618.1182620.6370020995613116382.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  xfs_rtbtree_compute_maxlevels(
>  	struct xfs_mount	*mp)
>  {
> -	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
> +	unsigned int		levels;
> +
> +	levels = max(mp->m_rtrmap_maxlevels, mp->m_rtrefc_maxlevels);
> +	mp->m_rtbtree_maxlevels = levels;
>  }

I'd drop the extra local variable here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
