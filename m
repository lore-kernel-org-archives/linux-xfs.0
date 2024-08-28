Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5618030;
	Wed, 28 Aug 2024 04:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819159; cv=none; b=GI4qDQF+ImnbJjt9XfbJDeQQlY4gZF6Lh4pclRor5yEJZkz7gINUWCe0VvnCzNP0nitwy6bM74Mdp3mgqVeMSfpuxUBeef3Wmc9ZeYMaaWxiYYA91yDvJCTnk5J9JvKrbWAhhFV1e+IwdgL9+e+sEP7icj62zk7yAyM1Xz7os78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819159; c=relaxed/simple;
	bh=nVJZ20UZwi9G1iQIPtKo2MLVT8yBwaubD7dhphFN/Ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVGdJcmgunmcztmG8H28ZZfQHD8N4KhHXsX1Dgtpsupx3wYO05Y1mhZSGeD9RasvfotPChAkCbTbATuZETMeLQM87Xro4vvQlBLFJ/bKi5S0ODJqi/E2t0R+rWEOrS5cNLEmJMiy5gmNOPn5OmgIZsE9XkptU0i+vWGVP4EkBgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wQDhIPcz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wQDhIPcz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H66DSH30a1wLetJeIcaRJ0SJaICUB/a3w3PZbe6CiVA=; b=wQDhIPczVdMtCkZQ+MAFv0tSnv
	Bz+8liWciw8F+tJKE6yTanO8hmkkt5EE8Zfh03CbAZeKaMYeD4/JE+LSjghQ2Ki+3wtIW0I+hDjfL
	SVlPNRYYXa5w0L3jukmukR5jJo4jy+snNiCBXa9Ytk2xe8ju2jtRjk5s6YboBZBlrOIwIdcPKw5yd
	8HHYp5LJAeDxG2NHevX6VxXE5tVLN5rOg72DBqwomoNg+Lz+uXpd0VP3ygVX2Xl0RWTtropJM99b3
	khKgTw7JxAHfmg3sKm04MPhsaP0ppLjk+5tpqI1gBqWKB7MLTWyQ0ws+us3wM1YNsKHxwhGwCvfre
	dNIv2eDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjAFo-0000000DmcV-2Qe8;
	Wed, 28 Aug 2024 04:25:56 +0000
Date: Tue, 27 Aug 2024 21:25:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	linux-block <linux-block@vger.kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] block: fix detection of unsupported WRITE SAME in
 blkdev_issue_write_zeroes
Message-ID: <Zs6m1H04ZJ97MaHb@infradead.org>
References: <20240827175340.GB1977952@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827175340.GB1977952@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 10:53:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On error, blkdev_issue_write_zeroes used to recheck the block device's
> WRITE SAME queue limits after submitting WRITE SAME bios.  As stated in
> the comment, the purpose of this was to collapse all IO errors to
> EOPNOTSUPP if the effect of issuing bios was that WRITE SAME got turned
> off in the queue limits.  Therefore, it does not make sense to reuse the
> zeroes limit that was read earlier in the function because we only care
> about the queue limit *now*, not what it was at the start of the
> function.

Yes, that was a bit overeager..

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
