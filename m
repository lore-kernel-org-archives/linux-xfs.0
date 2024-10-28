Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531BB187FE0
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104361; cv=none; b=EwhuJiZExg/e/dbSieaJD1qsiCdcWU2Cy7KLNUcK6bSr4tf6SYrwn92XSzmGp5wmQ0U2z8QBCOymdD3pcGLMx/MCrn6h6GN0freDdPyzI7gTlam5jMiv1lJso73LZxzhW3PiMcHWhiEk3dA8KpWKV4pTQJ2DMM3xpMT27iREXKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104361; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qo/kRXGxMvQMDAFixbRx76We9ams2JwPDIRQRIT/uaWwYn7gMzweNHo5W3JE4YOb4kjUrO309I/nS4CT+SqLbgOQ4qy4stESXsQJzgv0Lr8ZPccJaz4Zz590sKKAr78Q9cvdUhsofU/jcDBqKDK2lHTE+2vVTm6geQZYNiiZHtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WrfwDeoX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WrfwDeoX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WrfwDeoXUpInF9PkzL7ZgcVZ8P
	Jj9+9UOeZiQoyMz/rBUM4DAnFHoiz8hCPdNXBg0HvtOle+sfRjhucATldY9FHeSvi+mURPDbIcdWa
	6alNwHf3l2kghGueHbLS7t5VJOUDqh7SF1w6qowiMHCDS24Svmd62gkLdwphqERYuZ9lSn8vY7Cs2
	qyeWrCfcdxaCqOX2S3y36e7pGtcLU8SKAvDBXYrgc+05Hu0fzO3fK7A0b/Vrh5s5mPD+jqTNLA3qR
	L++lHU4Jma8xtyFO5rfrgLe0lK8HMF9lKgr2DNq0flJsv4ikEct+w8NWMbZhPxqPAYRftYZ5YltkC
	+VDOcd3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LB0-0000000A6i0-3Ncw;
	Mon, 28 Oct 2024 08:32:38 +0000
Date: Mon, 28 Oct 2024 01:32:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libxfs: validate inumber in xfs_iget
Message-ID: <Zx9MJlXUEqKFQf2S@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773390.3040944.4686468112875777629.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773390.3040944.4686468112875777629.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

