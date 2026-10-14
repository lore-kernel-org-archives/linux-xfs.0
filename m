Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E176A4BF93A
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984111; cv=none; b=ZJx6P+ZTT/n7EBpi1VcOCDrBVx8uOgocqPQsUSTEwXgwGSim81dyVrKE1YrJIA5bWZgRCZRiSkQWSmUrRoqAYOGEfXO5xorIcpXUarVQMDJbiaY8HIqNM/ZNfb4B4qVxmXzFSb04YfBmic9j15v2gCSJD++rmwbszu5RJFUfApw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984111; c=relaxed/simple;
	bh=YXCGnbl9caPsAnaCtIIJOvWVOat/4r07LTy01tX+cmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVbHv51MvmYvxR+kKOh1r59Yp2WpDFyPnjgnA1rWOGDn7tAxYht9O4U/0Q+Wcp14mC54lc+gzVA8MMnhzp8KxpfX5iPn1Rcffz+5BMMYcDQwp+pGf/xhSQyoY0ywqn1dY7pXHp9tJzW64+7vqY5aaAl72S/zany3baXO5Nr7ZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f08nuD7M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f08nuD7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=noZYwD3GE/wtR6ojG6r3E3LZl6+tpQi2P0OJjYfh2T4=; b=f08nuD7Mod16gwCbGjrOwahL8v
	q37jrlFtt3isbY3MqlxrcI/KCdsg6LQ2GqHuS+WXNltIebGftBpMYaJaI5U1NdzqOwk50a8nVvupF
	Jg/rPhSK8+HMYHdL4VI7IoECuMI+5paeUNfkNYtjx2zPWvcFMZ+Udjg+/q+rTy4Ux8GJcjxcUzNE6
	+K3yOUfsK+PXmpPFb0RM6eu27MgSrkaRY7Dj0919TtTzH0r+rtt0PjqdRiaOy2MTTujANFcvWYXkx
	XLoTGNcwFuic7ZX8Rz0LSuITqLQqTJWCh6PVyOfhOfK80YVHQjk0udBMrid6+bkfTfYLw06fqTjfd
	UouLAhtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGyvU-0000000FZgj-3s2E;
	Wed, 14 Oct 2026 13:21:48 +0000
Date: Wed, 14 Oct 2026 06:21:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <dgc@kernel.org>, Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH 5/5] xfs: remove status parameter from several btree
 insert functions
Message-ID: <as-B7NY2COb-6WRZ@infradead.org>
References: <20261014013505.759089-1-sandeen@redhat.com>
 <20261014013505.759089-6-sandeen@redhat.com>
 <as7-F3aJcKmqu3mO@dread>
 <de05ef54-e9aa-4616-b9cf-8090e408a4f1@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de05ef54-e9aa-4616-b9cf-8090e408a4f1@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 13, 2026 at 11:07:41PM -0500, Eric Sandeen wrote:
> > While you are touching all of these, can you convert them to the
> > more common pattern of:
> > 
> > 	error = xfs_btree_insert(cur);
> > 	if (error)
> > 		return error;
> > 
> > Otherwise the whole series looks good to me.
> That /adds/ lines, what are you talking about! ;) 
> 
> Sure, I can do that if folks prefer.

I'd much prefer it, thanks.

