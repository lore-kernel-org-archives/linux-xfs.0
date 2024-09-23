Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6397C1990C4;
	Mon, 23 Sep 2024 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727093047; cv=none; b=gQdIyyDBuLR1JRkiatFUf7/i2rT3PBSuoPYLcYEnAe62dxdQcJ3Ezf95Eo1V7X8SQxnnDAe/B0c+2py3WTTrMCRCAVtv+/37NNRt7c3inZjRb6wdW7qia/32+5xoNNfoK9I5u0YD6tZgR7rrPUKIp+ujUMuWIEq/SN6WiM27Z/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727093047; c=relaxed/simple;
	bh=60JPb/SxVp0k0GzxfIDVVzpaHFf60YyWCTt78PnVF3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5eYt+Wpwx5Dy9lKTTI0ebuQMXCHnHHmN28ytHA90B1mQubRZ2KyiEv1baDB59syAsnlI1Sy8pysi3Nw7hCGO89HTD32HKVBbCFnaBzbVaYPNpvwlDRrfKCNZQnAt4wL7ggqZRn50mkcTFncbM+QBvQ9HO2Hvl0UAe24g3geJRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BU+45pDj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BU+45pDj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9WrfLD09J1aGLdGEu8N8g2HJpWPSa/jlk0R+UCPenVE=; b=BU+45pDj5KRKiUpsDZUJiKgPK5
	pja6PIM1vIPcO2X+9uUUG83uCwoyMWiM9UmGYHuErTQf5eqag/NLL/M8QTGXc6PNl0Ad3SjqByzG9
	67lli4krgmyQLqXB8Mzd/WpYEoWDY+TmQ2VLvagnCAzk3PG7XN/jxxxhkJldaLxvr8nvxj0zuhT0S
	1pinKBDdQ5YAOIZEZmn2jX47uj8Ih0ykohCe2BbuHjK6qreyVxbypa8mBRrKIQhdzj3afIVnjTJ7o
	kwB3HzatUz6yCumDx6jKP/E3OEEFS5ExAQGDgOj9bo8cpOllIB4ZEX3JAwr8YTrObpWRzM8MpJ2Ui
	O57KfSAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sshnI-0000000H8IN-2ahM;
	Mon, 23 Sep 2024 12:03:56 +0000
Date: Mon, 23 Sep 2024 05:03:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: Use try_cmpxchg() in
 xlog_cil_insert_pcp_aggregate()
Message-ID: <ZvFZLKMVMMig4ZCh@infradead.org>
References: <20240922170746.11361-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922170746.11361-1-ubizjak@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  {
> -	struct xlog_cil_pcp	*cilpcp;
> -	int			cpu;
> -	int			count = 0;
> +	int	cpu;
> +	int	count = 0;

This should not be reformatted, but maye Carlos can fix it up when
applying the patch.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

