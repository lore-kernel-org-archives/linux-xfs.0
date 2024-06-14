Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B0518E0E
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718383605; cv=none; b=JYrQNmpDDHDZOf50C3L5XbymhBRlX543FlazFRkG3+2IapnZimEa5jGorWw9mw5pSNbc6x+k+sDmTlqvA5FNkc1ObBYDn5Dwp5iJpG1AHf8Ao0ubaJATdJej++KCAR8bYzAtPxe49Rjil+ZY5f3hZojUHlDO20KSQaCVAEnl1l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718383605; c=relaxed/simple;
	bh=a5JpdgBmZCFK5bANRGGcWd66/OX6/nSDQ5a5AbZ9POM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MybuYycCiWkSbcAjwpeuF2sbH/c/30/UhvH0BnieoOkxzlrC/NmxK2+Q8XxqDoa0qfnt7g2W4I8/Xj4+MgXKKut7+HcZomLM2eo7lyEHsP6EpZRyVxTetmPhXbE2MCLV9sHynlFIh1xMGu1P3xnhvpVYmReoc4rTgikGWsCmLUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JEZRmpGk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JEZRmpGk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HEqD/0cp5+HSjdHIQXoE4CbIsJpQ52TSJOfclthzLbo=; b=JEZRmpGkPQCuTfykeyECsbfpwd
	SeobsEZ0dUl3X2OcAgdAchQTQdz+oOT3Kk/VpyJmroBQ4mUlA32geH/Ip8jKtJC8EUHdRKOtQPQf2
	LQrfljFMVLAlM7qT4zopd0UqyEB/Tjm/yS0EWzGLrii40Iryg3r38PvVD2o21gdFM4ovv7Qs2ZDUt
	qmA1pEBEraFcoAqL6HjIquTkGbz7DUvgHu8O0KOmoEGeoAvtSV/MQsWLUXMtrzBLlslfmT/jN6BGy
	NSjghc5X/h5LCkdV5EsoKO7JbOMY6nlo84Ts2rIuA2J0sC3hny4Q6mzshQtVqXwQ4CD8Bd46sCICw
	aYsWUh5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sIA4Y-00000003Vx7-10Ed;
	Fri, 14 Jun 2024 16:46:42 +0000
Date: Fri, 14 Jun 2024 09:46:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v3 3/4] xfs_fsr: correct type in fsrprintf() call
Message-ID: <Zmxz8jDbUSCdRzVT@infradead.org>
References: <20240614160643.1879156-1-bodonnel@redhat.com>
 <20240614160643.1879156-4-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614160643.1879156-4-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 14, 2024 at 11:00:15AM -0500, Bill O'Donnell wrote:
> Use %lld instead of %d for howlong variable.
> 
> Coverity-id: 1596598
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
