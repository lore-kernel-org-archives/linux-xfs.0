Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45248D515
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724026; cv=none; b=Xww17JWpVkHKsZq2zEAYphMKxrBlEYq39sjkLq2RWCm+rXSSKDnDdhzUckAlWzm4qA48LnVcFvLv7fLX6mIEjhkUBa7Yt2TLRXs28IcWJw44e4RpN4xmdAnpFOdIlp1ZCTFWwu81dmxij2Ue7VovveKVgDqZ2jK1O48jX96GdZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724026; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfpbv6DnxD9sfxG785zipHDbRDQodoHE0gRPr66/5eraXnUOS4/Ggm5rdBRkyL7wum43NnxwpZj9mWTB8BLKgKz+VhhAxeAiU+cDyF3dM6Rb8Q2YEhv9ubVJKDHkdZWTzcULBj2DTCCqvn/7lhSYQfRSakOIT4GVfHjZZSMhkUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oitplPcG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oitplPcG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oitplPcGFK6ElFGPi1fjvzTqmS
	ruGBVP37rMYZP+OC4kOCyOjmzYhbQfn373vm4VjUhp5dDa6sSA854QUjFNjdfAStrrnewCrhEFFvv
	aNc0ZWUba5GJKIoXerBYdu86LlP0pNvpcMmt1w32O/LcLrwrdPMPvHzfxJJg47Dinc8h4r6pE+nok
	+29kn1xM0C1kmJM0iWrAdR5R0v68qvAAonmcuVmYb7TCOrMi95m4gw7rUvN1oESrxG0mjLPukV8QP
	fsHUjDnONLNuz6Ns1Hvr35Tzr4Gl1eTA53mpIS99Kg5qiJ1j8o8dE7RY4IeVI5crfrlY4FXoKZRZe
	adiqf8Sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPl2-000000053Mw-24P6;
	Wed, 10 Apr 2024 04:40:24 +0000
Date: Tue, 9 Apr 2024 21:40:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] docs: update online directory and parent pointer
 repair sections
Message-ID: <ZhYYOP9WCUKpruxZ@infradead.org>
References: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
 <171270967499.3631017.12364220130145297814.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967499.3631017.12364220130145297814.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

