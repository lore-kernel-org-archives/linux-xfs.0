Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202550;
	b=PGoVTbqhcowbTM0AK1+Hdg57kMNqgFvfaIlTyzKK8c1nQu2oX36C33cu9r/tD5HLkB6H
	 fqcLB9zkq7kj3RKpXf4Hkvl83GzpDBqGGTApkLADMNSlW2p2MDCtta9P9229w9M2g9D3F
	 dHi9g7I/UUIBCB/ogSS+Q/nB3E57IlDIbFlO5xu0kpD/vfr1Bf0bRV33rbfQm0sNHZhgP
	 QXuAddGi1QYTvC842fl9+m0GylndZ/GNaGVRoaAS/OgTJd596guljjwhqo7vKBm6G9yB/
	 BU0Zs0y9uDK8MnBUD1Daudxu8TzGgW4o2YkgbqqYr2bctYv+Xr6sO/9sec3uCTqHBSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202550;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=CiuRDqGTTiMglp5X29q2PfOgGY2iIY02Xwt73tab8tICsv53Z4l+nz3rA6JeTUVzg/r9
	 QB6U8TbWO8Plsx18XQIQmDtrv/6FP7bCi9abTfdBT5R8vgQ9l9byiqpskvnEp2yGwOzZp
	 EMtJtMItjB8o76wNLhtNpg2e0B0EhKx+C3GS0nsNbI8OIuTeAL9jsK1Q0jBHG+uhjvmO0
	 tlXrZURzJy5ChQfSm5qqmW2V32GrLDRmjm3QzhCyfMxhxGNnYU0NEraFrbFQhcefulFIV
	 PykzwetuVIzO4tfzaFQ6jJUoRFZkNx+kKKEpdqOKLdevjOcXEVUJcIycRw1TGuG+2cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Qdz3yRnQ;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394AD606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 394AD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Qdz3yRnQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Qdz3yRnQsh2tQ30k+c7d+K6Mie
	O5Ex/93qbRoPsEqzOwiw/gwtlYhF7ONgzeTzX+xDo7j5KtorHrfi31C+48HsKVvsFyVQyOsTNUGEG
	leu39esS1xa8SiZSJFE3XHJpzTUIZA5mCNSfFanRKoPuabXY7xll+a4dVf+lCQ1gVPqnZMvlQmxrC
	U3b/m0KeIetj9WZXmHTqCaNEMSuFTUKWCBp/sYVMZyfxW3CtlMBOzkn6npUJxym6UVMs0xsJsmu5J
	x3SHCdy/KL1CqsC+AQno9jEJFFQuaiv7rvY/gI8SD3gBjrHE/D+Hp+7j2ejEbyPFPNbP1DtTIjoGp
	vrcH7A4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5tl-00000007SfF-41ua;
	Wed, 28 Oct 2026 15:49:09 +0000
Date: Wed, 28 Oct 2026 08:49:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dgc@kernel.org
Subject: Re: [PATCH 3/8] xfs: remove redundant stat checks after
 xfs_inobt_insert_rec()
Message-ID: <auIZdQL1QrDlBO-D@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-4-sandeen@redhat.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-4-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

