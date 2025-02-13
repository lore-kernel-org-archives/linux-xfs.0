Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED12054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420569; cv=none; b=sXREu8hDwtF5jXGSU6OWKWbnuVW7xcKlaYCs1DpfT/1tQp7hmO4wgBPqZewQGN+GBAR97yfEuYs5jsuPOISC9JdfcWpwETvBGP6bDi9m1f4xVx7JSwPps8LbuOy1Ud/jEYU08d3mF9I1d2zPT+X13v/BqbDc97/zF3VH0kivODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420569; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxRMYwSQq5TM/LOcItfg9Og7K/aNMotzCsQo72hHMA5e3Ha1a+A5eAUIxU17TF3e9I1u95nSnIGLrwdG6fs6V6bA2vOSBKkUAZ2nzmozLFcAz2TPPS4ilR4HdhnbRvIRNUHfUtxmwQ3AyPC6yQ/hXk0xC17hHXze8hYvQbiXVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qlKH0WlL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qlKH0WlL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qlKH0WlLw21VLKJ6gU2oct5wTn
	v/nVh79TqyIuS+coS3vqvbpfy8+u4KHXsQn7TW4t6jTfbP2wO3lCwcHK7dP+vLyyZQRTeBbyPsJfu
	wXOMSdeLbmslyc0mHSb/w5qA7hm878e87Xkxa+umDv/Xn5FtgYToeYVBo7m+UjrkKCDnMTWj8ihF4
	5HVILHVjGvUPGMrP9KjyfhnAsKK+zcogqiJvPb7Dbrn9asI7Qvy61VYqH75y/C1upVU+sldjp8ZCM
	5uAvno5r97EmN/bmApH8ztzWKSdcQQIAQPKZMQY5D286jXdwHkqCvs860+i6I1ZNTd7YhXHHZsm/k
	ozioXo/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQkS-00000009i1H-1Ae6;
	Thu, 13 Feb 2025 04:22:48 +0000
Date: Wed, 12 Feb 2025 20:22:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/22] xfs_db: support the realtime refcountbt
Message-ID: <Z61zmBXW0da97I6R@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089041.2741962.5577654086707722081.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089041.2741962.5577654086707722081.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

