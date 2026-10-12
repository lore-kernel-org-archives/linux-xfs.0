Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FF0374A0B;
	Mon, 12 Oct 2026 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811105; cv=none; b=l1S5G14XCCxKubW5PUHMHQVyPYNFxrXaux96u+t9AvOOvDep5er7N0+Hg9udJSmqf+8JCt1WRD3IOcsSCY/5E1GO1V6gjvlC0IXXEsts2YrWfVGk1DwwA1XhFqKpceHa1hPiinVoAlUMKK4YEr8c94BKVyhSuiREXO1MiWXfK0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811105; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWjk2gRliCC1yrlBy+Qi3v4CbUqM+gn0f+XVo4OVYBKb5svcOkAJGn2+CqkO3wz2mgDevmC0vtXfSTBM65/dX6LH/i7WlKsP/M24sJKDqwhjgZ5MkW4lnDnPTh1jXV+TPhs06bL3K7o9KFhjQokzrJOKAhfq481uFH3653W7UpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DIwBPy/B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DIwBPy/B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DIwBPy/BuGNacj+ijKqRc4IBBW
	c2MMILM5d+mYHv91RNsRj2mqyxwWHYg2bKTYHsAc/3vy4k2buloH0fYQNFi+y7gsLxb3FhxDht2bt
	qsUxUlPsdZX38vDjrgEDYycnMRRQjj1ddOag3G7eUeZblQiXql0+wtuf8GVu3Fb77dmGtXwcxSzhl
	dYkadYqmj3vR2TjBzCPI2lUt1Bh8LI+t8vcZ3Dj5fZwARZa3Nv+yM+e3n4T5k71PN3gLp6NzRgqZp
	Iie2WN1p864E84eGLU1eLQLvjVRa+sM8XCAKMTFMGNWyJigjVuDsB8Gsq/msKeLgow+JCmRrgl09w
	ih9G615Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFv6-0000000AXtw-1uzi;
	Mon, 12 Oct 2026 13:18:24 +0000
Date: Mon, 12 Oct 2026 06:18:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: improve dirent bounds checking in scrub and
 repair
Message-ID: <aszeIMtWI4Fe1y4F@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065946.1058822.5630800433093455691.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065946.1058822.5630800433093455691.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

