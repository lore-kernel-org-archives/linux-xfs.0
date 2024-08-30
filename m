Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971312F2C;
	Fri, 30 Aug 2024 05:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997362; cv=none; b=ojOWuzCzGt+1f3/ZjcEoXBSG9lmeQvXphzuqicC/LPGz+Fy6nkf9pakeXU2xRpxQOG86Or17iSxh562gyWh8GHfxdvPVXoppBJ5oQrn4uYFAq14XVCKXt5/GcwjviUphtfyKn9mmEWgJCvJCbCFCm3x9Nhhlvkbiq9sh0xlHUQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997362; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uAmmJjsHwHT/qEwyg2lxVjJKaYTvO/s/XYoiAKBEQx5KfSajBRFhNzUmuHjqWmiXIUyxggq6SbTKlhx4XNZ5TXy0YhU2fr+qB1sGOLZc6e3A/sjHv66O+KcwDgDRNtUTugK6sqdHVb+G7l5ZYv85uIhKP7QhAsv0ZbJp0lS7HIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SXjm9jJU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SXjm9jJU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SXjm9jJURpqIy39YFZmIOCRS0H
	PHJoTzLF2f9LL+OeqinDwzCqLUkhDQI4zlTk+F6gMweKk65+hadZTRQfsxNHvYthd1F7UGtPh78eC
	HZRQSB92zgNhMIoRZH/5aIAPapwB/SdXnBJ03A8xoI1Eo+cNSGVLsHLKNZaAPpt2RKHvJa46gjCvP
	EUIwLwILwF6xEU0yn6wnuk0ypPvre/WOii9ac3m7p5TaLTTOAcaL51Lsd5mTnZ+BTg5qyrSRvBMdu
	shB2G51K7Tsyf7ZKPWFT9rwL+SBjDyqlC/tAuXltKrlJLb5QRTbfbmAC/nrFDjy4lskgt+MImQdul
	7MjuE2IA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjuc1-00000004sAs-0w9P;
	Fri, 30 Aug 2024 05:55:57 +0000
Date: Thu, 29 Aug 2024 22:55:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] generic/453: check xfs_scrub detection of confusing
 job offers
Message-ID: <ZtFe7XloxPltVgnF@infradead.org>
References: <172478422285.2039346.9658505409794335819.stgit@frogsfrogsfrogs>
 <172478422317.2039346.8642752505849905499.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478422317.2039346.8642752505849905499.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

