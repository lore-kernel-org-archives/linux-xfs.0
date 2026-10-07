Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C938DC68;
	Wed,  7 Oct 2026 13:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378422; cv=none; b=lVuHVxZWPjtay3AQj+4YeB7oPzFt0I9mhy3UvQznHopBL/Iw7ed/8JGz9vt20jLG5hyrPi9kQEDny1RieE8QSSwF6xs6cieoZ6mN9jZD1CDHGVZqvwCqkebCZYQOAuovR2+O7kL41IGfLaCoYmyrIk6Gn4V6kHQIG6+fTLKxL54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378422; c=relaxed/simple;
	bh=BdsrIHJN6n6YxmCIqfcT2rKon4ZLKVwVjFOmxbx3K0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3P4PUYzelXzVaIy2R1z+K6QX3zkWX8zQ/C8Gg0GitRGGJX8bQk8xXv+7F9oXkx45eJI54KQFBFwtu/ohx2vpa2WHYIXJPgTwlZWhAjWcI7dN15sRN7HgyIkwj3eM9WuxW36Lg9a5oWA2FUY0P8qOM7XVvw4njad9dXrzdBHls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Exh/25Vt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Exh/25Vt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hy+3e+fp2WGrXTvketWSgf1mmtQPkEl0uzmon3Tml9c=; b=Exh/25VttU2qQmNhAvmvnYKSE5
	2ypekvFMvIk4Yq8eLTBi8IKwdOAjJsU3HJToWsm4SaoVlFiUB6+3ZWGyYyNDkd9GOiCKDBu/fU8JK
	PB0T0x6SLRfCdZWMy0bvoWL1cAVH1ajXuqFmvh5R2UAf1QTzwcMtn+S8zBPb8ON/Hc0/xW+N98nCw
	PnWuameBb0A4wGL6jq1HT6CKLPoLmRMXfQYdiboWzOnyc+0b4Ir/ofzqxe7DWTJfqFjSR0odoJmA8
	glAG7WNKUgLUmb/ajBih0COqwe/56h6y5zLJsJS0eSZhOC32qdMF209NnloOv/Axykk5XCWS2UY44
	MsTdgPYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERMA-00000002VPs-1JhL;
	Wed, 07 Oct 2026 13:06:50 +0000
Date: Wed, 7 Oct 2026 06:06:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: always zero the whole shortform header when
 zeroing attr fork
Message-ID: <asZD6sdv-AWosEFx@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965245.614350.13479239208521625776.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965245.614350.13479239208521625776.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:58:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_xattr_fork_remove can decide to reset the attr
> fork contents to an empty shortform header, but then fails to zero the
> padding byte in the header.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
