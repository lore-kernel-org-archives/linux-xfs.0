Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C117B12BF23
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945686; cv=none; b=i6EQIDo98JdV+G4snwaGGauOnhWa9+MFPAgfYJGG9V1OWKSwV9dJkYVyZxyEq47GkAO131nV8KJatjTCezTGEymEFUMGIUnIg9UuZn17so4vHKLnbpDAiMpnclxBoLENFDS59z/UbedA4rpAGBmKsRVZRMpEixxFBX9W1+fhoLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945686; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poRQfjF6POon95R5wS5Nc7iEDsoKCZ9tmurrMQThicsvL70raS4mT6eoJZWbUQjl7S+XtywuX23s6OzQ+6DL5VjWNEZL0lXumLSnQJlLDD21Wt6FpJtuAM/dZmp5VAAmn/2qTpT/+/Ci/Dld637Ct1kESmNNzii+G3mYZSVajxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N0svpiEx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N0svpiEx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=N0svpiExfiSAyPAap5mH9CPuwO
	2WJGk9NQ2VFDtgZeiHOQx7PcOt9ErThX5Yfq0Z+xjtEY0z+WaJCtkHw0bFS+gYk/31m3mQ0LBLLZa
	kB4RxM/Taz019RE4R9F2r1hSAN3P00UGYbIzK+9NYOomyfhHFO7Nbz/HveinU+OWWl2OrBpHRUHai
	ExXtoWJ+auFnnvw+kQpN3u0h0SjYD1i8t1B8i3iKKe+Tmpp8s8Lz97sIA3Te4ZDFYL3RMt/9PpAex
	CazjWwvQpVKQxXuJLkGRODElfhUZGKpMFuz9Xi0gM3/O9Ti6425BO8lYr5kQCfcr7qaDuY5Y0HHOA
	8oX52F+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWIP-00000007h2l-0uGf;
	Fri, 21 Jun 2024 04:54:45 +0000
Date: Thu, 20 Jun 2024 21:54:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: simplify usage of the rcur local variable in
 xfs_refcount_finish_one
Message-ID: <ZnUHldsovktjvzZ5@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419926.3184748.7669666442192075027.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419926.3184748.7669666442192075027.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
