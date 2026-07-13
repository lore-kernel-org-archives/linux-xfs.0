Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C936D3BCD20;
	Mon, 13 Jul 2026 08:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932277; cv=none; b=f9/xZcyggYNLYbRLiI/PNXiuWww0gbGc6AjTMWkArLDsL0aMkBMrfROEqm0xDxsQ4azCcnzQGmmKoRm/ygwvc51meErY9UkcZDSjro0thN1wbv2v/I8loSglv29CbD4rB3EHcRF2FXSJUCkEmMbQjm80J9EUpGxqbU7oRywhOGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932277; c=relaxed/simple;
	bh=3U6h5RKT7QOT04j/88jssGr4Kio8LNLTIg2Zynxe97I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkDBOtRCRpPm8drm6aHcic8HJhF/PG6TdPH3WVevG6WTJy+GLO/ieJyWAtmDc+eT2ojqFdDVcL3HnSLgFfa3oARxfWbjanIk5SoVBk6y6WO6qXbAXV51vnYIFOQhMWd+45AFEvO3l1iDvGX9JnIyQaG6t3ERJio2126l6O0mWKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lxSGOa7n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lxSGOa7n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D2dgsAkEEMpIxPn+GH3TMME+xgRgEmfTzzl38skyOh4=; b=lxSGOa7nQahf413yBTW1MDMX0B
	rO81oUMOpHnfrNv753RAt3GreMzWt2jXXrxolCT1hYGzpu6jYr4+WjBTfKVvKCyVuQZOtZHEbrRxL
	WQzNyl78vdAwSC5/spe0Q02G7ci4jexs7N6fMUQw278k5M8s+A0TqlkP0vLrc0EATQUw3zh/c5cxo
	ws0EkBZCM05PS6sL+Hx7zAx1mgJUt7gLyltrcu+iIReZQSGXnJv+d1qyuDML0Rjvzqov0bVhV1jse
	qyzGfJF6cdcVh+gobzKddTTKdWBi7sPdRW512ZgkjCwreDk2PiTtGCnYMgF7T0unODQqDv0V6ILWB
	zyiGagJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCGu-00000008czw-3CHt;
	Mon, 13 Jul 2026 08:44:16 +0000
Date: Mon, 13 Jul 2026 01:44:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH] iomap: prevent ioend merge when io_private differs
Message-ID: <alSlYAelKWwBhMWc@infradead.org>
References: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 03:42:06PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Different io_private values indicate distinct completion contexts that
> must not be merged together, as this could leak or corrupt the private
> data associated with each ioend.

Looks sensible and fine to queue up now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

