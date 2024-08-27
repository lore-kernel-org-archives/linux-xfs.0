Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5F19D8BB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724760763; cv=none; b=p3vByaNcqXOQ4zl+/7jCOd5HBcSSlbw27Oty7FsBn23PXtJwoQ7lZN75wa1kJ9P2HJfOHJZONdAJ9YASyiDJpLea/Kyo4bRZT9BYUEDiO+g/ycx/j6wRsubQVUPJ6Wa341ihsT9JECoOxy44aaDKvauz2ftsvP56wmLlQwgfbDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724760763; c=relaxed/simple;
	bh=wqQ6teiew57GGi/DBxZMtsqiyo+u5HAyCKM/YjP7O9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgYId1GUYJGkUXgpCvkGpUM8RViS0xgyP465tsyUuI0c83iZAaMJV7JWvCwMBReZ8Gkgtw5zdEdImZJAzf23BsRp3TYt0XwwfiLZbYasRt1h+rgHHXVWU5JKztxRUuwld/evvk1fLlSknc90hoTIqDMq/BG4Jazq/Xd1L7etN7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U388cq02; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U388cq02"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tMUN1jC+35GevkbaPRHlMePEwJfk+6tBaMEJ4G2J7oU=; b=U388cq02GGlUcb1Nvu605x2qZg
	1ZoMB9AzWCau+eFkLLl48Rk3k3LxO4Xi+KjvDoD4iXqi19d4LvTU4MNBfU40j989PXE471+jWQKzS
	V67fqtLkZhZfMswr6iZTOtee74GSMJV9Z2h/v8fJp/QYujw3HpttSPDT240oFyX7y9sxNpkfj1pUW
	UZMVDlDZlUQ8jw4T6ejxDNmvYWg8hQ4KMO2hlBWxewwR4NmoGbZPXgNehpIAcMsTMGjlEn6CoUb9u
	9/5UgT2LMW7GgNravl4P2u0JsF0onVM2Nls2lNu48NkKCVGj7/XtF1ccsjo1IgtBUPE3Nv0WpqDnY
	hue5q3AA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1siv3x-0000000BARj-30QC;
	Tue, 27 Aug 2024 12:12:41 +0000
Date: Tue, 27 Aug 2024 05:12:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	hch@infradead.org
Subject: Re: [PATCH 1/3] libhandle: Remove libattr dependency
Message-ID: <Zs3CuTVfX1f2oZTD@infradead.org>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827115032.406321-2-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 01:50:22PM +0200, cem@kernel.org wrote:
> +	struct xfs_attrlist_cursor	cur = { };
> +	char				attrbuf[XFS_XATTR_LIST_MAX];
> +	struct attrlist			*attrlist = (struct attrlist *)attrbuf;

Not really changed by this patch, but XFS_XATTR_LIST_MAX feels pretty
large for an on-stack allocation.  Maybe this should use a dynamic
allocation, which would also remove the need for the cast?

Same in few other spots.

Not really something to worry about for this patch, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

