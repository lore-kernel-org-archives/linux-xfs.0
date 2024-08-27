Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39251A254C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761009; cv=none; b=Xhpkn2jTLckqmiyWTlrEi7/Hmai3nk9X3fivp6tgOHJmbshTtdGyGWdffprLCDf3ecxuFaGeJJRt53mdss9J/M2Jgjzu9IJ/5TWNiVePPEKm6L/SK1Li6uRTSuTBLXyc6XaeI8p6reYnd/dhrKDHu1RqkQan/jY4Kb1/0jVRfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761009; c=relaxed/simple;
	bh=uKVglm0pQu2iKnVuT/3rmtQSC45uNCuQyR8NMF5B6KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCBbkC2al/RAu3Z+oexSVhFoZYqU0RSAgtT/Qa8s9lvY7JX4DyijTUDKGh0MuuXs4cBn17HuXSKkJ6aEvbWDNpEMw2LpTp6lHeXIGVTqw9lakHaNWKl9NGhoWpzTdsPK8KL6uNPqyXrKFIe9zIf6rffDrcFoQFTY9pbXn4fIfmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mbk5uYle; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mbk5uYle"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l6XigH9m3NgY57Gzhq3iooi6wzQXDVcGwyIjhmG6DDk=; b=Mbk5uYlepeg5774rZ96YHIM/lu
	oYRHt+AvEgxWPzap6Jeilw7syjsP4+ohhbXgofl1FrpxhEnx5gDxNSWeXbn1QD1zf+OVoUQlB7nAY
	gebqTrOkg3l00CHUxDVxs+8JzUgSpqXU8GWUVQmBdf2GPO5WP1dIoh0y+h1zPHK6vCu0nEAR6aLVj
	okV/FZjLazTzlmn378aqBvLYJHSAJP3mgAPiYU8ct10szSx6qUMVChUxMia8F+30UZJ4v4zeCNBsj
	RyjCa9LM6m5QmAMu7SZdewYzbkyYSAU1ty0iehitg25dNgTKo3uYCOINyFfEah8j5COFpDZG+hijS
	HBNSbEEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1siv7v-0000000BAsQ-1KP9;
	Tue, 27 Aug 2024 12:16:47 +0000
Date: Tue, 27 Aug 2024 05:16:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	hch@infradead.org
Subject: Re: [PATCH 3/3] scrub: Remove libattr dependency
Message-ID: <Zs3Dr2wwcaAFhMMO@infradead.org>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827115032.406321-4-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>   */
> +
>  #define ATTR_ENTRY(buffer, index)		\

Spurious whitespace change.

>  	((struct xfs_attrlist_ent *)		\
>  	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])
>  
> +/* Attr flags used within xfsprogs, must match the definitions from libattr */
> +#define ATTR_ROOT	0x0002	/* use root namespace attributes in op */
> +#define ATTR_SECURE	0x0008	/* use security namespaces attributes in op */

Why do we need these vs just using XFS_ATTR_ROOT/XFS_ATTR_SECURE from
xfs_da_format.h?

> +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;

Overly long line.

