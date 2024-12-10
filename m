Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA2E224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809254; cv=none; b=J5MTWlukUXiwD47QTjLZ6iTFFHZanEOLHH1yuLE3IZd3uWQ+wGQAWi5xHLI7rukvWU6jIkEzaEZGKjBq/7em7RTtx0frOTKh4wTIa45xQ7Ph4UmMaHzZXSCrbj+zKXpBzQNWYQJrP1ZfJB643DzEalBpkyg6xjXMVILLPP9WXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809254; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7Vh9Vyh0QAbC2THd9ZFGZbcU3oqBursPjItu5NMkg/yQHFTN3zTsOpc1xGNcPfJLewWjc2uOvZmRxx80ImFnLDcZMBfW5gh7D2lx7CuqAFQhd++SJYxMl2+wkUW+E3OgZ5d9scF/qo/9UeMohgW5bjipYhpoyYWTOQz1Fm2+Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ACFtvtpp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ACFtvtpp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ACFtvtpp1DOuQHlr5IFoX4apG1
	9QayV9hTmdCxtvFmQJm6ISxQv8FKAJoqXdVlBcm00Vl/eV5XmB11P5Jhx+DFKqU2xsKL6gV82w+sL
	DI/ToAvo1jRQ2rz2rlMA+bzw0DXAyFHPnjN+42j6qHMcVuBaRhVEPGX4p4LWbhDPnf6kM3vRwPEnl
	MG2iUYNZNq3qxBFDxJJGPkIkpSvK29yX4ChOyKFeiFvLubjPT0gA+0n2bySliOr9uTbNnSnbP3uEU
	z2Coy0H2QuKGkoOLfq4+ucUtzABUi4x3E0/5fWUQf2WH5STwcxNX7zaBMWmwfxC0T1HIsMApzKnc0
	a5b8WmQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKszM-0000000AIWI-2f5l;
	Tue, 10 Dec 2024 05:40:52 +0000
Date: Mon, 9 Dec 2024 21:40:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/50] xfs_db: support dumping realtime group data and
 superblocks
Message-ID: <Z1fUZFdlf9GuWTTB@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752373.126362.17848531751610324154.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752373.126362.17848531751610324154.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

