Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807644DA00
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724392275; cv=none; b=UivM+7bsTrkSRK1LEXeu4JfdyBb5+sWCTcOUjrP31lzUp5gzMSdjd5IvwR717L7pWDJI8LwMeEYPm/MTbbcUldSW6Ph4xKKBmnHxgx2KsgQSXqVUOxtRljhXRB3dZ7XRzUsNWAQz25pkWVGVHr1elXZj4+74PMsdDJAQKcIUV+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724392275; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gal03y6bNEkeVZ6W9B2jqQRY8iZ05ynWs6rzhdxqjSYTi0tVWxuS2xBh4BocxV4cKFRAGbjp2Syy+cKQhyEwXPTokL/RNP/q85fKem8gg7mvwFmn8J8aW9cHlw7pbRAnrW6T22R3WYeNrWwiUCDuRtfjuPqcEr46/sfMolOMVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KEROLO74; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KEROLO74"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KEROLO74kINPjBcN8KFVG6zQDH
	ARZVYDetpoyICcR1RVkzWKsj3A5kEsxjSd7vBfYs8LBPh5tJsEE/MjZAwLgCQeptWGwBA2ltgutj0
	cxbSfzzXdpzPmlcN57Io6QNa9ni+obbxCPT9r+f/UbNmA2s2u0yGHVy1kFEHTU5954TUq/k1K2OoX
	9YHVuth9Ck+HvhMJ4wHaJ9CeqrgJcFUfdlv9vcPnGJkcsEK78ihYrLIQasEg1lAS3NL7LzSY9RfWs
	D4Kl2MYNDqdyKwfvUSLdjGaQMGL709BmlSj4vJJN10QXNdIdpd6OqHhCjCJ8xZmm06+Fof6V5gfbQ
	E596qrng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shNCb-0000000FMu5-09RB;
	Fri, 23 Aug 2024 05:51:13 +0000
Date: Thu, 22 Aug 2024 22:51:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: refactor xfs_qm_destroy_quotainos
Message-ID: <ZsgjUf2yy0VsqWEd@infradead.org>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089380.61495.10149120499984603964.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089380.61495.10149120499984603964.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

