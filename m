Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DED8836
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705905958; cv=none; b=KJoS0NsZoGOCMP8zPXXw57D5ioN0FtlG7sp97V+b96NzAh/SBCkIuCoHchhHbTIJwacdfF+ucwWHhGfhxO2E7waZybfogCdCS/jMOKFd5tP8esWItO2bU7xVG4FL7CFzZTmWRVD1bPWIuYiYosYigL4gqXJG8xH8599/woWA5jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705905958; c=relaxed/simple;
	bh=imapCvc//sDTCXytvtH+77Xun4JwoOjvsyx77T+teas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+NaGiRgxrVD5YdXaHLEQsk5ghtr+m/rRZ9tCkeimQWop9YkLikE8ZUg+7SV50tZRoA/XbHn1HGtnsaig5v0O7eoA8x27+uV5+M97/ka+AI6cHdDlSCSrbGShM12CHitC+3MyGKELWEAE/kyD7U5RAVviZdeG3MZIw7FWbHVQqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ohk6fXLA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ohk6fXLA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fC8PY6sF3cW1oDp1cRiGMw1Oz8p1hQgx1DGXN56mE+4=; b=ohk6fXLAy7dmVf3vrUPNYZcUCA
	ghX81aX6nYkPZgE8qMiAE8bFVNFoEgoemDZIlWY3ydgjRoy9Jr0KSdyKLbWtPbH8+tZxYB3bZ0W7/
	vL3q0Z0fwq7RqEtRG37+pH6YosOL69nfi9OqhTLjAf2zlixpYuJIesQWMPSJLlgDxi23LgQXRozyC
	n0zBUJ6n9fwqFWSVuXFNFckFlp/XUPTQ7SVjVEBL0YU5CsCafpBnFARfeZOcsApYS+vcItH5c1f/a
	wCmVfFHKz6+wmKxhFNTB71iKwVM/jXSqy0hHJEAsAYg4H7dNugKRVG90TOuJ5erFn4Nvz5KMkACpp
	YTBS8hUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRo4B-00AmNS-1f;
	Mon, 22 Jan 2024 06:45:55 +0000
Date: Sun, 21 Jan 2024 22:45:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: convert buffer cache to use high order folios
Message-ID: <Za4PI5h2BQ8DoPrN@infradead.org>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118222216.4131379-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	int		length = BBTOB(bp->b_length);
> +	int		order;
> +
> +	order = ilog2(length);
> +	if ((1 << order) < length)
> +		order = ilog2(length - 1) + 1;
> +
> +	if (order <= PAGE_SHIFT)
> +		order = 0;
> +	else
> +		order -= PAGE_SHIFT;

Shouldn't this simply use get_order()?
