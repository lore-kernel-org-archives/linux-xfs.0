Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9D01426C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727998; cv=none; b=jFyp5RmY97zwRFMqt8Vv3hd54t+Vnsu0dJtMkgAYDpP7sEIJ6lT5cf4crqkatVaAqS+XHDIZqgnVcdwCwjJb699qnH+tCqibJ7mxm6bALo0vNCyKDqq7lBQO6vM6+CRpiMA4IRqh/FqBWmVQELz5AmozSZ7QaqKZGZIsiUnBDq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727998; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YP1e/NUEmgNFEZBI9JXticVzDDgxBmxWpWNKQYQhu5/yS4yR0T4SbcSHfvV4ctz792ZLjUUGqja77ZIkDCH378ghE8K/2eNHyD13LmUAdAaJB3jdREHN0Q4uKq/zqOvUKosvm5W34yIAr4MffiKQUg05IIV3T6zkJMgeCSVnNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Oaw9AgVF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oaw9AgVF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Oaw9AgVFj9sOkX/nFMrsT2CNMM
	MsW6DCIQf0TEV79KNWn/v3XCqPF1+PyiioekepgaTer+k3ybjQKf/pfvqykDlvioOZh5frtgE9zn2
	gBn2InTaFGYb0MLmqn7kZO8jZpIdtvT/4T5IT/FtBWUZy5v8IpInQ+9RSlDGEqwjDXPeMi0WmjUgm
	s5fgHql+YagCQvHbFUXrO4H+AO3Nqm0aK8st49ucJJip6qV9hNkJuSWZKxFFU3TWoktkD1ii/R9Pk
	De1e9VD6neRNJJZC2jU0/zbRjnKJZeWz27UA1zn9NPtBAxsF2mb+dUNLOirr7RjRBObDNb+szThjH
	uhBsWqig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQn7-00000005FRy-12XC;
	Wed, 10 Apr 2024 05:46:37 +0000
Date: Tue, 9 Apr 2024 22:46:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/32] xfs: Add parent pointers to xfs_cross_rename
Message-ID: <ZhYnvdu8mGwpGA3i@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969925.3631889.2928122008436370702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969925.3631889.2928122008436370702.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

