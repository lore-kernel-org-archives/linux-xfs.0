Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B3B1DF26A;
	Mon, 14 Jul 2025 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752490769; cv=none; b=pzjlDfJ2U3jh+vOeFI7eOTP8qHSTmymrS7PFgMOIqdbVX6TqJeI8X+Dl3fAVKhOr+2DM3eiJitn30QLmfiiCy1oOn7b7ny30p41IDzYFwF0tg8SSW4Nc7oxRpp1RySOLMNM2rFni4GjwbOXhpSlrZwZ+xVhtYn2c1WINj1NI98E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752490769; c=relaxed/simple;
	bh=cpatPhjGSChBfeayVzxZ9beDHoG63u9phrhYlNlQ/Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2wSxcozQz+gcB+Nrjw/xSTNsRyQn9o3uion+vxrDADO4xbM65lOt/NgPBIBXRvP9RViq+hTP/YJKWTp0ZI81AkSRsjiXtIQUsdxDXoi5uqBLnVRA+CTFUxoG9FkewT6CIgspCNx2Aup1q3MBN5uCRylJAQzvJtdGEaE8keYNKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3uzhHdHK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3uzhHdHK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vm+j97b5alvltA79gK6cjufqYW1r2riUwjMxVXnVH9U=; b=3uzhHdHKKgUEL315yDZTsyTjkl
	viGOcwMPdYYqGVIUQMQP4uGUQsfTtw1Nd+/Nf10SVGt8fkP3BwseN2CT8moTA6pYKyhV3HKHZdpuB
	cBR0TXo4SlEDvt7omSH9nFzbRhFUS1ybjTwMMfNwyhfga3xtRQqpMzdPRpdeOnejvGa9h3+6BJPbv
	hAmYVlZa49Ibn052FdddYQxMhpye/KfGLqAw/6pZHe8Du0lYjznvmMbkP+bvoWRcNkNcqLvS9VL7h
	aBilYADw9GutwPSeSJ6Xcio9T9yEs5L+ZHSE7gm0JG2BdWCX86AoG8ss1ZiF3vxGsy6thdd9XgOkZ
	SkKZqUgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubGu7-00000001ysx-0t2U;
	Mon, 14 Jul 2025 10:59:27 +0000
Date: Mon, 14 Jul 2025 03:59:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: George Hu <integral@archlinux.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
Message-ID: <aHTjD6FxJYEu6C6R@infradead.org>
References: <20250712145741.41433-1-integral@archlinux.org>
 <9ba1a836-c4c9-4e1a-903d-42c8b88b03c4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba1a836-c4c9-4e1a-903d-42c8b88b03c4@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 14, 2025 at 08:58:59AM +0100, John Garry wrote:
> > @@ -1133,9 +1133,7 @@ xfs_max_open_zones(
> >   	/*
> >   	 * Cap the max open limit to 1/4 of available space
> >   	 */
> 
> Maybe you can keep this comment, but it was pretty much describing the code
> and not explaining the rationale.

Let me send an incremental patch to explain the rational as long as I
can still remember it :)

