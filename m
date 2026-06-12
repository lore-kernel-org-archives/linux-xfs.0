Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE96364022;
	Fri, 12 Jun 2026 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251473; cv=none; b=GHCUD/yIf2uW0iwCnvy1r00sefqKJnoevQmYvMqILcFXm3OOSHyXc7Cc3SSWIsGWV2thZEKkpHZdWpn4ds7ZMwpqODqCxRlN+sjOQ/Lop9C5NHF+XCxW+JFNnEBqLCe4sMv/P5qEEBIPRBtIyzsQYQGvwTI5cmKpvFt8fCU0KnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251473; c=relaxed/simple;
	bh=TH04H+GRBZfDZ1FLROksCDBC9BC621Kkov4M+5FyVgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYCVeYEz8Xf5JHYuR2tbH+49nl/8Hae7l/lj6orhBBI6q7lm36qBjEw0EL/d7dLux0X8IIYlIHGa//wBvdehw+YaUIPhL8mbyI/zxnPs85UPlh2s1/5TY81QEynvj/Aw0AT/srqQRQbp0xuqVqoeNzuZbju7QhqZ2wWp3JUrttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wc5Cag2Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wc5Cag2Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0ihkg1BpPN6WDh+Xj+gutcck2344hxpx3EQTJxaNIzM=; b=wc5Cag2Zc4drAvR4ORaMcn9cZS
	mnahB9H3My+1sQ6zybnO5AG9bad2yEZveqEdNU7DYahkvGihQqLxraVFiDpD1U8j3GDPJ9wewnkTj
	Iwoa1F+MfjOQJwWSmhxkQfjE/sg5xmWO354Ka4uc3Siptoz3fQYlhaovas52qkEnrPJZY9+cR/cXA
	HA/jQEo7z+966L2nK6GHdVXTONE1ip31wzYgOM+k3fjfsWIG0H9VK6h5J6bEFciAcCzYhqSU1saYV
	u3X/KNzq3KkNQj7q8p5+MUxls3XKjmh/P626GdTKZHuskhLQwjrmqLS+GYt0lKwVXGM0fIC3SPyMO
	yfbrodNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXwsM-0000000AXjf-1g9e;
	Fri, 12 Jun 2026 08:04:26 +0000
Date: Fri, 12 Jun 2026 01:04:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, yekelu1@huawei.com,
	jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <aiu9imWL_c1eyerw@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
 <aiuw0QvFIhEWUPG-@infradead.org>
 <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
 <befed994-02bc-42f8-945c-2aea3e3b10b2@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befed994-02bc-42f8-945c-2aea3e3b10b2@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 03:35:38PM +0800, Gao Xiang wrote:
> btw, there may be be some edge cases like:
> written | hole | written | hole | written ...
> 
> and if bios cannot across multiple iomaps, bios could be
> amplified according to the shuffle pattern even all written
> data is consecutive on disk (the block allocator may
> allocate written blocks consecutively.)
> 
> Anyway, I never tried to argue with this cases (yet both
> previous buffer-head and mpage codebase will merge this
> except for some specific exceptions), maybe it's just a
> pure artificial pattern and I'm worried too much.

We actually just had something like this come for XFS even
with the current merging:

https://lore.kernel.org/linux-xfs/6csdtjn33va4ivyycr4uh2ogac22xput4kgzxzt3mczdkvwjaf@37audfdijskv/T/#t


although this involves REQ_NOWAIT and thus is a bit more complicated.
But the merging scheme discussed there should also help with your
above case in general.
