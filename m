Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B45AEBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944697; cv=none; b=Z7BLP+ha4hCAN33H0tmq1idwRwfTRUk1eLOhUHtl9tY/G2RHhbmWr7vOa98a2CPhyElWHhahjTDq8UZHQd0IZD8v/io161dpREAnhPDgry4gmnawvgU6rhsZhiTlK69NCY6BfwH9XZkWJK5uwKVkpQi39/oyDfYMa+A8ZQV2baI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944697; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0tA8HYPQmrg41scgM1YWg9e7dA65jakNnIsGE9dK96ULwq0qManRukdGT+ev/UYzGfBH5oUuanv6sUV4iEbE9zlu8R7PBeeferbhu0F1QqVc2C5KvF51ZWLJ3nzF9xTarhhQVxOmhKdA5UHnh56YQTlTqRRSFsXoBJ7NGSamJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iTbICHrt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iTbICHrt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iTbICHrtsBYj3wFedtjbPDbKa9
	ZivxK2HpWl1ZgZ/iZkujvD1yFr6z2+VV6SHOBZQtbhAZgBp1mNBEmiUmhuiAq36IHce8OE5Gp2Dy+
	0q+GogA5mB9ZntLNbIuzT4bZnxL3T65mVVREUeQdNdUpO5Vt7svuEDUUF+pYZkWa+4XVPrhYK6Vu6
	Zxj08VsDJGawJ2QUOYFKr9lv5EL1f2IcMLKiuugXs7RSLuXUAd29QhWAnZpMiDo49VpS2o01ZeLi2
	lPvSEAr0mJqYYHqrLj28s8EDTjleDwsZqQwFT/29Q5JiOG+d7WTVER6wWlVe//YvuHTydjAYMvVo0
	9X80eunw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW2S-00000007fFd-0hwQ;
	Fri, 21 Jun 2024 04:38:16 +0000
Date: Thu, 20 Jun 2024 21:38:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/24] xfs: hoist inode flag conversion functions to
 libxfs
Message-ID: <ZnUDuNaW9AVeNPlX@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892417963.3183075.6780097546790838079.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892417963.3183075.6780097546790838079.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

