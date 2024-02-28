Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7983815CD6E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135647; cv=none; b=Po3RC7/DRNHCSDBWmJlJBHoDHqnWOTtd2PsDN8I2mwhI/Xyt8DIr+eohPWUvpTkwJohEjnuNEPRZk/LQRMND44TAWcCU/8lBlfkSIp9FyQUvyO2eMxe6eSGSx/+H6NpoNI1pvNoV/YpXjz9Z1mihLnpmU1ZRprtYaPTHcOSZ66g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135647; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPuZI9i5DZk1Uh5n//snGWszclY/37xPG9Y08mwmSxUDWKF9ZCDMI7tqGtb7zGyJHtLAIhWJElbsYB3jCZCgjbW2/WAsxJPaLEoTNzZYmfIbiKLh2CUHwm8H7SAZWdVFzacnD8IxTOQmO3urnnWWPT4NGhRgIlDg697AKawc4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eNz0CWnn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eNz0CWnn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eNz0CWnnDueSnFMLRTfULre08d
	mGFFrzbFW/wJuEVJz4Qni3sxPK5AuzxEoH0FdzW7Lw62JyK5a535MuPtX3/XAB7IobkAvTe+ujBYN
	9Y6TzXHtz32VtToAdoiEhCvfj85bmqyUuGTajh1uSqqegQgoQKTsMK8OTLbwBFZgQKYGOV+iCk0F5
	Uya1t3v4bb+sZM7FcPJ2bV9aCjG774JVVLPgW3qisNGsHNvNP0Z2EK0feaWrWcewQ3JTT+hdQlgja
	FzfGpm32SCB0DT9j3K7Tiq/ww7avsKYVMYq3i7U95ICazWtF+53Lu+SbBWAbfurS14qVGOM80+VYw
	vmktr/YA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMFy-00000009zSX-0JmO;
	Wed, 28 Feb 2024 15:54:06 +0000
Date: Wed, 28 Feb 2024 07:54:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/9] xfs: add an explicit owner field to xfs_da_args
Message-ID: <Zd9XHi1g3gFlqWug@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013108.938940.17165407332191884972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013108.938940.17165407332191884972.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
