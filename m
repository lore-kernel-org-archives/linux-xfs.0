Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66461383B0
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 05:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720677297; cv=none; b=s8dVkgl/K4EL5jzMgcIQ1JklnxitN1pCrL736Ri4VQcBhfEgFT0ydRKx9j9xclG/oKRvkDZL5TyvIoX9igXMzt+aqkerrONaNlG0HxTYW9olTeQAdrwy7KmbWRHQ8AqWUWuV46wsGGY5nfUNjH8BfDeA2G/ob0VuYvtDuJnEIyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720677297; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dl6RZXZqEmWyx+dMX6kWUPO3GlkfusZaejT6W3Z78i7GuDSS9d7CGjPquGL2qrbIOQJf8/7DOYOJx8WgM52o/6VXSR4uJcxZVHxba95U4A7VToMIpiPeqorDKmvCfQnoA000STOIxuXIzOF4e3wwajDwAwi5qhFTTpIAwblqurk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oBDOYa1D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oBDOYa1D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oBDOYa1D3Bfm3qm/+OvhwgPmSq
	ZlU5CwiycXHV8/JsJFRqWmcuBGri6ruC2Gvai+KMJr43kxBtUi0a0hyoKp9smwM7se7xaEhuXse/9
	LRJo6BLmMQ0IRam1hfChTo+ixSZf81pq5vrbUV5/1IkrVod3RoBvuGpFr/qzW67Yp1F0tikToqvJo
	tkJ3TIhhl7qDE3i8kRScW62iXwlhLo9H6oCyn613P3qEUMaogmqrz0fxTahX3/NbN80HciCkt1/M9
	/3KyASL2TNuS/uVhT0NKNZM/7cmF/XgELgWz2+LsdJ6LxolYcowFn3XDU8DZzeTNN4acgtFvHcF0e
	9kEMxIUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sRmlb-0000000CphS-2f08;
	Thu, 11 Jul 2024 05:54:55 +0000
Date: Wed, 10 Jul 2024 22:54:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: validate inumber in xfs_iget
Message-ID: <Zo9zr0MnR1_w2bk_@infradead.org>
References: <20240711054430.GN612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711054430.GN612460@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

