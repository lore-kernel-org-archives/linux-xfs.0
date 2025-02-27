Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCE125F7A2
	for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740669288; cv=none; b=D1PbCZ1vfJPsNve9iUhgQuOK1BboBQJKZBsYZWmm/J7eYIJnE95/fp3HhMCBxwmRePj+L9Yv51zlvY8Y/l4Qy8aNPJK1Zv5cYsu6uCrU274Y3uzByZieNgAAhpF0PCWW7F00VLo5fCswz5BgsUBYPmQIVcKRtwNG9EAqRUIFPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740669288; c=relaxed/simple;
	bh=IuSAkZbmZ9a8TBY3Xl9QjazWycO8uK7Jxx4ixMJtyk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cERfWmCR2S8hzjLk14ZdWORfJnuVY0dje5t/bYL2tQxyP7+FKhrjdRp99AbctkCT+6d6Fjr+iS//46Whg31n5n2Xm/eVCkegYzET77FEITq2bAauycplJKagZFJ0sCRlVb/65y9Hxbml6PG+c20vABOvapbyKcMKEVFH4NZHi0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZbLGOgyS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZbLGOgyS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TakgCBjFUszd1VquxUUES89pjHLVC30v33TbqBAxDk0=; b=ZbLGOgySJAMcgjT3cWqhxIfSK3
	BNiPpgLbdq2v4pd24ZJb5JDqGl67LQvnnsk71tWBBaBIV60VUJkEof4v2SKXMZltNxmRBx+YsCicV
	sW6XMkE356vzdgIKg7lTO6W0D/SoghEU9e6/4xIT5trHMHBvrb0Wmcdu2ZmazZndjT+bKqUepeJim
	o4NsIiz0n5hyCmptaMDZcFjILHsDy7uUypp+uAgJmK8KxuJGFkm8feOyKhCrv5YsUYN8eb3gKAycD
	yu2+wvY0ATmjMCW9MZBEmNeS4PKHsrUNG31MyphRHU0smFS6lAHNA/hz6XOgVjCuu7U+dCNYKh2Su
	jLRoL9jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tnfb1-00000007sQV-3Yeh;
	Thu, 27 Feb 2025 15:14:43 +0000
Date: Thu, 27 Feb 2025 07:14:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, djwong@kernel.org,
	linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Message-ID: <Z8CBYyGvZ23iEU0w@infradead.org>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <SujyHEXdLL7UN_WtUztdhJ4EVptQ0_LCUdvNOf1xxqSNH50lT37n_wi_zDG7Jrg8Ar87Nvn8D3HaH4B0KscrRQ==@protonmail.internalid>
 <20250204184047.356762-2-axboe@kernel.dk>
 <hij4ycssasmyuzawb2mhq44wec7ybquxxpgxqutbdutfmgaizs@cvpx2km2pg6j>
 <20250227-beulen-tragbar-2873bd766761@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227-beulen-tragbar-2873bd766761@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 27, 2025 at 11:30:39AM +0100, Christian Brauner wrote:
> > https://lore.kernel.org/linux-xfs/20250204184047.356762-1-axboe@kernel.dk/
> 
> vfs-6.15.iomap has a lot of iomap changes already so we should use a
> shared tree we can both merge. I've put this on:

Note that we'll also need the earliest changes in vfs.iomap for the
zoned xfs changes that are about to be ready.  So we might as well
pull in the entire vfs.iomap branch.

