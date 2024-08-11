Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD2622615
	for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 08:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723365773; cv=none; b=Pmwf0GHIOZZYrFRRO/BG9ed8GamfzldYfkDxVWxc30C5uFC4iUg3MLpBORVBiH5C7ROcX9FWhR339oilvYumTNMgEBf8ZR7KruLS6T49KiH8M/SHvzz9PN8Wtnfw7swdyNMrcrkdWehrBmJulYjWIJPSdgCUeWwaaR+rR40nF3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723365773; c=relaxed/simple;
	bh=9fPEJAFfFBch1VyluyjbQBGdj2yVj+cmqnsc/aJ4D+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZwexoiGAEBKF24NrVRboZT+1Q7y0FELt9ympYTTgPKyntpfYED4qnO8ER1UE2dNcpjI9+Hw0zqtWFhIgPhsNaSsrYyejk3UfKkKZb8ACrCXht4ayer75LZQ/+1D/8jcETbIXEUUJvUQ3X85PXmJj3LhhVyHrcfC5MwBfVM3mOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D7H9yMuE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D7H9yMuE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gB2qGgB6s/L25LJEMeoAFrD7PestCWhe3vBarTTvG0k=; b=D7H9yMuEnzh/UVo/JqZ1khWPEH
	iwhIbgRAbiYoYyNgFEJNVNyIPsjWGwBYMrOZpX2Y18yjZdteHDZfUKB9Idul84aefDwbZsXMFqqA/
	7lkjuvw44TM/21766EZUm0QkQSK43UBBWjcenGoI69+87adSWZH3NDM1B6sEBagDAxhdM/ayqd3qK
	8xTpQxQ72fEXXpPhiwjN5heDuiqeJHvjes74ednLIrcig6QCxY0u7WE/xOnr48rAX1V+R6vaD21DP
	ZdfGRgF+F4iLRNneQaYFjOM+BjwF1jEcO7Oo4oKVFoap1Nw8tCJTfyua6Iu68K9ro4Ez1Le2iy0Lr
	x+LWHizg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sd4A7-0000000FJs1-0Jsv;
	Sun, 11 Aug 2024 08:42:51 +0000
Date: Sun, 11 Aug 2024 01:42:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: Use POSIX-conformant strerror_r
Message-ID: <Zrh5izvj2X3l-A4G@infradead.org>
References: <20240811025104.54614-1-AWilcox@Wilcox-Tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811025104.54614-1-AWilcox@Wilcox-Tech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +++ b/scrub/inodes.c
> @@ -65,9 +65,9 @@ bulkstat_for_inumbers(
>  	error = -xfrog_bulkstat(&ctx->mnt, breq);
>  	if (error) {
>  		char	errbuf[DESCR_BUFSZ];
> +		strerror_r(error, errbuf, DESCR_BUFSZ);
>  
> -		str_info(ctx, descr_render(dsc), "%s",
> -			 strerror_r(error, errbuf, DESCR_BUFSZ));
> +		str_info(ctx, descr_render(dsc), "%s", errbuf);

Please keep an empty line after the variable declaration.  I'd
skip the one between the strerror_r and str_info calls instead,
though.

Otherwise this looks good to me.
