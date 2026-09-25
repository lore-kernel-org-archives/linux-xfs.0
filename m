Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2183AEB5F;
	Fri, 25 Sep 2026 05:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314964; cv=none; b=Cs+MfM6Ifk8nYe1GCiozxHke61gSkHXjhi2sw9xxI1X57NUG5dGQw/AYMVCOD9DDDcDes0f7XWS0n2+j5qZQnI7eKfOyT9tBz3dA33a77dUTSJtK/naygRU561Yw1G2mHH5dcyDW00Aumy/6E3pWcmQxAvtIA3eknmAstOiA8sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314964; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQSBE+Ln3UIzs/6v+uZW+x0XsEMamD0OlLPv+eMu7cNB+UZCWOF+S7TzeYVZESfQQ5hyYTX3trl8Bea+aI3QfBuuwR9T1+s0u6+4L+cT0dWxIXcObTvyMJSQRGkotcU6lzmIc0aZpA3g+q8hkGsxOifL0lugvn0XmjvKy1bumVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LcMmSQ+X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LcMmSQ+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LcMmSQ+X5WYJSneHC4ThUf5R+a
	JzRSyuYhnHjb5radDRnav7CXFPuKAVgiIgZS7bQ/Dq5bsdQnwujeIkF3+gomER9FMw/iqNI+yxKEN
	VKhkdQMHMimbNkWZ7TU9g1awUdBj4By6zbkjqzbAKrQ4KjuaNZcU26bvCMSHMtK4SoVpmMynVtZoQ
	Kc2ZmFV8r2LxWkjgw52OLdF8i9ELR4OdOzzUjjIew8o8xTSyaf7octMjDCzkgUSlPL7fBafKJBL44
	+l6Q+fbEaTU8F4JzaKaEdd0WhuYAJpIQk6liQP9Lkc6WSqnS3MD+vqS27bGUDdTWfB2Px61jD+LKL
	rCCBKxIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yhk-0000000Ci6z-2PZl;
	Fri, 25 Sep 2026 05:42:40 +0000
Date: Thu, 24 Sep 2026 22:42:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: mark overfull dabtree node blocks as corrupt
Message-ID: <arYJ0A_Fz3YCPPxO@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932282.3344850.1828907677637994070.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932282.3344850.1828907677637994070.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
