Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72BB3822AE;
	Mon, 20 Apr 2026 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776712338; cv=none; b=tcWnBuTWjCMhXVB9j4VZsfD4FPTQp0rMUGR2AEnOBdMRAo5rMLpk3oKTA0SGmbPweYhgyufDGVLgvL0hz60dd01KVA3aa2rZaCpeqYTXKrfvumvcL45shf+VliLWR5m5RrinzilZVi9iSaZ4/HDvmt6rIcbouJI/pwxqu3VaQ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776712338; c=relaxed/simple;
	bh=ZhcM4Z6zSJMUteDVf4VCTHIMv9Csk1+zmy0thoEn6VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ody2Q448VxvUu98Y8JNdgaDhfWdaE2xpPPaaQRaiNmjujSYZl4tAFunutgYc/xZKP/Qu+YXKy3HUMkarXVI79nRJ0M6A1f3CIHN+8X/7h+HpshScR8MqWw2/tT5Rj1xdRo4aiR1O7wHUKIYUNh4gBQnhUSGjjUNI8RayQQQSheg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vgU6OGKK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vgU6OGKK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VkzMuMQfcdnmbiI4D9AB8V2Ucb0IPvboF8F0c8KdAw8=; b=vgU6OGKKtV1z6cr8YCFIYl0jab
	svVav+9t3+DNXbKDQ3pXw4PLkD63DkQUz+4XXOKeb09ver8XDUQ5DQiynDb9FTYrP3pExGfIniDyo
	0nmQvm6+iVI5SO1A7SAnQvKtsUgGHDSXO9qvnLt9yEraGAMxKFvHhhA3Kke5V1Gc/Tbttq+v6GARY
	tPJic+KrlBKRpsAIKCDnnSnveEBGPhNSNDKhym213FZvY7Pj+QImPB9hy1VCIHfiSVk06yf3RssB6
	JmbhUiVexUbS1t19gHL2xkVGS8lxcUaqF50TKs6cY+vxOEkSyRgU4kvQTblwbeUE1v6qsenLGRsEd
	n6Yr4mBA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEu2Y-00000008uTB-05QR;
	Mon, 20 Apr 2026 19:12:14 +0000
Date: Mon, 20 Apr 2026 20:12:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, ritesh.list@gmail.com,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio
 allocations
Message-ID: <aeZ6jQKL7zSCXNaP@casper.infradead.org>
References: <20260420161404.642-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420161404.642-1-dipiets@amazon.it>

On Mon, Apr 20, 2026 at 04:14:03PM +0000, Salvatore Dipietro wrote:
> v2: 
> - strip __GFP_DIRECT_RECLAIM to avoid costly reclaim for high-order
>   folio allocations
> - Moved fix from iomap to mm/filemap layer

I don't think filemap is the right place for this.  And neither does
Dave Chinner, nor Christoph Hellwig:

https://lore.kernel.org/all/adSY3GnLHyQatigQ@infradead.org/

I asked you for performance results with different patches, and you
didn't reply.  Now you're asking for this patch to be merged instead.
THIS IS NOT HOW IT WORKS.  You answer the damned questions being asked
of you by your fellow developers.

>  			err = -ENOMEM;
> -			if (order > min_order)
> -				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> +			if (order > min_order) {
> +				alloc_gfp |= __GFP_NOWARN;
> +				if (order > PAGE_ALLOC_COSTLY_ORDER)
> +					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> +				else
> +					alloc_gfp |= __GFP_NORETRY;
> +			}
>  			folio = filemap_alloc_folio(alloc_gfp, order, policy);
>  			if (!folio)
>  				continue;
> 
> base-commit: c7275b05bc428c7373d97aa2da02d3a7fa6b9f66
> -- 
> 2.47.3
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 
> 
