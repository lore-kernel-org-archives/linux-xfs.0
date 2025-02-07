Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085B91552FD
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903678; cv=none; b=pL+f5l7k3ZDT7FoKjm6SAw9ubWsL2sOAXxE/d08keMQ4nK1BdRNVaSX/imsyJXXXiaZBmlCDkXRGIT7Arsk5RyR/WVVPFipcuW1GjRxtE2Z2hlitLysR3XQlFkaMLmkO2E98tRUCPVG/qF4kdCu1ZBX4U4w2og6+f0PExM+On8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903678; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH0G/z+ClzDFK5KwZMEIhyBKicV+3EZpMjpCpPqamqhoRU8VaELnaeR5i4+ypCZ+8s9W7ShWd2xgM+fdqsg2wnu06a8J/n2gHShcEt5yVo9o8nsPBxXutrm4AtlBQpQ0AfOPmqL9Wce+dn9SrZS7DJaAreyNUQVmK6lZtFhbM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UXYQ63Pq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UXYQ63Pq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UXYQ63PqbR3ReL2JlI3k93KjTo
	tSspSs0AAyxPFgixqlrbX8U5F52kpdg53+VNwUJM987U8C5aqH9Vf0Nq0eIhuTwN76XqqTBv/0LwX
	vsw7a3Py4X30HGX+mqAyDGdr3eStw0hwimQiDyDUyp+ozE94TxB2Gy4+X4mcidPqC1Xi45LvaHfDg
	+SOXTFS46COgcnPeY5+BVNzjtpl5XZdoVl4G10oTjPX1o8EFmFJ9Nhwr+5msZwqUhv9jS48sEYkL8
	MXkPI6zV3iI+jJ/Undezxp2ef60L2UW9ixZfo8ujgYJHLDHYnwlqpfT4phtUNQg4QlYC0Aj/LOZ0E
	eX1riIkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGHU-00000008Jj3-2ait;
	Fri, 07 Feb 2025 04:47:56 +0000
Date: Thu, 6 Feb 2025 20:47:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/17] xfs_scrub: ignore freed inodes when
 single-stepping during phase 3
Message-ID: <Z6WQfC_JDuLsz3U3@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086302.2738568.11012690239317955502.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086302.2738568.11012690239317955502.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

