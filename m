Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32BE352C54;
	Fri, 12 Jun 2026 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781248214; cv=none; b=TlFwjO4kw2H3EvAu+GGtSygkQ+ZQWLeu6fTMRRMJJyPro/Wx9TcV4/z4HQViVcpOhfBTQlwexW9rW53//fwllAYLB4lKDi8LTc0YPpFRAihxg/yJ+YKkOdUYk8tx8dEnm4fv7Nrr/eChr9H4AKVdC8Vo6UespoTP5SbCUrcoLEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781248214; c=relaxed/simple;
	bh=RUg/7WhNtpIVc47JPJzdLEvsPkxVnq5owEE8jm0ugLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdmZaoz8QXNH3Zi9wO9HI4GplwPA65rDFCpIbFgzYkd+I/jRX5hu9YPXili7ef9k942/OxHb+n3WNy3G8tFqIlh5Fkr61nDuZdKLs3k+MJd0/B2P+omyidzXHD+5VZ4kHtLtwgLuqfNfz1Xpk6RtDRaPeW4cN6ajXg/zzQcyvwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SfmYAIrp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SfmYAIrp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XE7l43niiLaN14nrCHPCXNTwQNW0zvc1XGeK+ca3pYI=; b=SfmYAIrpzZaWgoAUgEKeN4JBmW
	DQ5Cwrho677W4xT9wnSXwLnsdQkLi9i3qUBIwas2hUzwCL0e9ScUIfr2FsiZph8iDtb0zVrg9jB3H
	I4pEP2I25mPgjTzMnlebEQam/6MRUmpzOxUVGx7BrcjGjJfSoBczr+alHVtBp6v71+Av3W/mt5TqH
	gDPnH53rOZ4C2mi/hez/WYQgMAd/Geobc7nl2TxWYazaDeFIGxNGLjv21G/tjQter2ROhuewUnVHn
	fKvTen2kvguqn31TaxdQFdhe7yik7/TqopD07sL3KoUBT65Skh8FUY4788wUi9mOb/AZDeaEOizGY
	3EhZYb9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXw1p-0000000ASQo-169T;
	Fri, 12 Jun 2026 07:10:09 +0000
Date: Fri, 12 Jun 2026 00:10:09 -0700
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
Message-ID: <aiuw0QvFIhEWUPG-@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 02:54:47PM +0800, Gao Xiang wrote:
> hmm, currently erofs could return block-sized iomap (if the chunk
> size is 4k) even it can be merged with the following chunks.
> 
> Previously it was fairly good since consecutive chunks will be
> added to the current bio if possible, but after this patch,
> there will be a lot of 4k bios.
> 
> But if iomap goes into this way, I could make iomap_begin maps
> more chunks in one shot, but that needs more changes in erofs,
> it's fine anyway.
> 
> ... I was thinking the following diff (space-damaged):

That should work too for your case.  But we definitively have various
cases where merging over iomaps is a bad idea.  You'll also end up with
other efficiency gains by merging consecutive entries, especially for
direct I/O and when using large folios.

