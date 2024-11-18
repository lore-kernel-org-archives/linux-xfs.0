Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275B0146A87
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 06:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731912900; cv=none; b=nRMRVEkGYZ09+yfAQFJRkurra411iHdLcF7WznkHjNGAEJE/3tqGbv3cSwqwB8LnTQc6rg4wBZvS7Pv/saD8HIRKCfkgJd1x1vc7zYBPCd30wg2qKyvkhxgM0i/viQaYt4Myfb41PCMz0hJeh7fbNud0itGtrOKslb/GxFcMFlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731912900; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKWhnWimJxhKd+vF2f0bLa3WjujG0kATlOAK5FYZNhbPbNWhheGqPDsRa+Cte3c8pI8nmjC7RNm6/CwLMRKnAj5NsIvGZBddIgeQgz03n9LGGXqvVgcX8qrjAEO13M1Tk5doPA75PPgg40jurK515S17GEBEOUAxHnVSGStFWPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hDtCwzwq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hDtCwzwq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hDtCwzwqqXHo0aBmMAZLhWDa5N
	OeD3PnsOgdxgDcSs113tOls32saG+OWzUmSKZvC2Lcsnd71VB7LsOniz1pNM/+DfZByytyq6FYP01
	Ujsl4C7raSOQZuHvZp15VGO4ch7+6Rpd0LE4gPhmQN3446XOgXHQqaviKfb6koiI3QlFBDLzXEtNa
	fQ/qj1YAFUQHVEABUhDCW1JElSS9p6omj90vv7wYbXkTAj9ry+hkO3aIbnqu9etQh8wEy+0b0LPvx
	o8DixJwYlE6hWYEQiy7LauJ3PGQWssHv/FFNrlgrRUuA5qZhkLABmgI4j5QHw6Um7VLXWpxCr+afM
	5kw8tzGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tCvf0-00000008Zyt-3bSn;
	Mon, 18 Nov 2024 06:54:58 +0000
Date: Sun, 17 Nov 2024 22:54:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH v2] xfs: remove unknown compat feature check in
 superblock write validation
Message-ID: <ZzrkwguSP7smLdZA@infradead.org>
References: <20241113091715.54565-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113091715.54565-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

