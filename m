Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404628EC
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718774817; cv=none; b=RO0qtU9R7tpWQXevVYZLIpcWDWeWktynnLsFBwnAUsQHtB4JPsv+b/4c0lIW1JTdFIwfF7M+73gpE97FY2OvUSGsPwMaBWdJdcrWZ4jGy1XfrVesfD0x36jIBZ0k5wffCcJuSfqEBBso7KUplzoz+n0uCiGRK/KDKZIz1iWGFWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718774817; c=relaxed/simple;
	bh=vqnmXUgbLbLmOPJdGBmxb99op2sp9/1syq6Az/yJxcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfTYacD/+ocysHy4w4HrEdDgO4vkux8AmlQrpjwK+9ruDHZpSifQLwrX7HdiwEhhJau1N3B5L9vMmRSnfhKgh1LuUzNXHgyLRkTsotDbvNDuQBIup15Dpneyb2dUgdP53He/n7b/Pk4f3kXcKrSFvFI915oKKkG764qXYO0BuC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zEiGSNn9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zEiGSNn9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=34WNhyXtMJ+gu+YvCNh8TtTjdq7cmqM5M7kd3xlWpUE=; b=zEiGSNn9wZgTMUYrpB78F9gRUX
	hQ85kSu5iR3/NI6gNGew6VbWJsDl7oC6NcA8QJYOC/oiYRE0Y/XEbosw9zkTBFkr0RrC5zaKBayIq
	k1euYfEL2qXq11RBWW8ht+t0wXuBxj1Askg3hoJQGWqv7rUbdLTIS3W+77vgMBInK98TcADEnkVwE
	L9nFTl3XLx+SzCpzPcn4q/8iSA28rDuWk1u1pqYPRpHo+Bq0K9szP/j7pwHwo7If8zCLUYB+xIJMh
	Se+tMCnRqwfjtshL6qSraaGCzWMj4YSB+cmjRTitH0boObqF0jrEkTvmbCxbKlPZQkE2fOM5RW8o7
	UJphfLEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJnqP-0000000HVvG-1MCl;
	Wed, 19 Jun 2024 05:26:53 +0000
Date: Tue, 18 Jun 2024 22:26:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: don't leak the rootdir inode when orphanage
 already exists
Message-ID: <ZnJsHTJfXOmlNXDo@infradead.org>
References: <20240618232207.GG103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618232207.GG103034@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 18, 2024 at 04:22:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If repair calls mk_orphanage and the /lost+found directory already
> exists, we need to irele the root directory before exiting the function.
> 
> Fixes: 6c39a3cbda32 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

