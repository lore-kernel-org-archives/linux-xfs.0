Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539D22F2D
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 06:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402906; cv=none; b=uejHtC5RLMusOX6iU9Tl2FT7jIhRz69yQcT/Yjww0mlJ46Msi9o9NwLzvJp/ZvJwGemYLugc8PZ19euA0Fm1YdC1paMdl5dyoIIBwOSRqWsZOazGVtG0MDInbfCe4AN/47cVg5qFmE4Ecu9NrbVLABKJcWeSddL/6zv/rEB/zJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402906; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpSqajgqfLXDCnZmxWz1/sMOio8p5nVtnf+zDixAtmW95VcxZBDvHn56cbgIVS6BdSqdHsgplyxUoYkY/v9mk+AS/ygolzcLiLLYyZ4FCAOFBzolxqx1+gIdvIKEAm+WbzO4geLUsbEO9EJOYiU9/QrNuJrWJRuqx52XRp7PePM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Lxj8ZgE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Lxj8ZgE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1Lxj8ZgE//pRhhxhzIJKULEYIw
	USPrV/+N+laNL2YEkYDrZTfx54MRVfYBDhIHSd9tJds1gmIIiaXY5nAE2stZTsc6AW/WgIrwYzWQu
	p9CWdXBsQa2Uk5c3K/M/vMXKXVQBSlYCjTFHx+lagoSidaCVT+iZm+FxlJty5o1ciz/El36rbjNMs
	PpY+Y4K8rQGnPoeBFqGE5I8dDlc379RHRgCra0m5+7JQQRpuoOOn6lrWwEGKUD+tJrX5/5n8GUy3M
	zqfQjzdjh7/SW5CqXq/7EI/Fsd5NAp8hvJeTWY6kTynakzYnyhv/TPF4bUvBsGz6s052FzP/Fab8c
	d4UEs7FQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVliR-0000000AtUV-22LG;
	Thu, 09 Jan 2025 06:08:23 +0000
Date: Wed, 8 Jan 2025 22:08:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Tom Samstag <tom.samstag@netrise.io>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_db: fix multiple dblock commands
Message-ID: <Z39n18oaaOW7glL0@infradead.org>
References: <20250109005522.GI1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109005522.GI1387004@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

