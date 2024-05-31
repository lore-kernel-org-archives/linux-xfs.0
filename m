Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245897F7C3
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 06:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717136540; cv=none; b=aYcecuaxQcnWY0oRtkeV3dJgxkRsYUSQtZ3CdLFIpqMMOhdiUAbraxlHkkhjAl1og39A9BU9w4iN3Bx8XKCi6S4IPxpH9W+8IeyB0QhhegR40HIOuOm3+ODx3O9HZadD1C1TOWHpCuGSKzr6hSkPBV56nlBkZsZ2qclGqCJD0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717136540; c=relaxed/simple;
	bh=0K0PEBCOYq7gnVXD9TNvN0u12+jiDL0HuoaXsF+6wM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4M1os4kZJQEyVotOfWgbBxi4bovKRvRlgaX/QZ8oLMXcfLvE2EhJniSQNH1zgTbBxPNwkFtUMMQOtLNHW6OJ4kzNJ8HqH4TuSZN1sXTZegoHZaht87MuonToQsPTWwh6FPF58QbWCVWEGQNLPF0XQVmQUjVcfgy0ZHl2JFt8mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WXQ6r7Fs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WXQ6r7Fs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zUv9C85EGOhbzrDmDyoQt2KmE01FD9XJHtPA6/RrkiU=; b=WXQ6r7FsG65VJ4b2FPhSfPiLHH
	99sPeyaMv0q2EbV8qG3qK3+v/d0kr3aMfAGuaRTn+LL9wGKkAZED9RL9kMT8p/lgw+SBxSY/IDchZ
	6dEGqhSeRN2xYN1ufSaVVY7VwrALYmFTVmlBUDHc8Pi4R+5lQJbRisjIqwn98PUMlLlqFJ1aPHIGz
	GYDNSykerGANmtsMxW17JobbbAtKHVhETZNQqXGAwUmwTWax0AwKJYK/xEZFbY2U5cspDhpgIOKTF
	Y54kCU7DgcjKJaeHjXiJsli/3Lp0R1HGwhjBJd5cCp07odTr3fK90PX9QPSm07Y27FTI1N5eR/v1n
	rIR6ohAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCveX-00000009NZn-35Pg;
	Fri, 31 May 2024 06:22:13 +0000
Date: Thu, 30 May 2024 23:22:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: weird splats in xfs/561 on 6.10-rc1?
Message-ID: <ZllslcE-Oj6JkYfD@infradead.org>
References: <20240530225912.GC52987@frogsfrogsfrogs>
 <ZllikUoZiO3jVqru@infradead.org>
 <20240531061822.GG53013@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531061822.GG53013@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 30, 2024 at 11:18:22PM -0700, Darrick J. Wong wrote:
> Yeah.  You might want to revert all of Zhang Yi's patches first, though
> maybe his new series actually fixes all the problems.
> 
> (Hm, no, it's still missing that cow-over-hole thing Dave was musing
> about.)

I've kicked off a run with realtime and rthinherit on your current
realtime reflink tree and haven't seen any warning yet.  Do you know
if it's limited to > 4K page sizes?  My testing ability on that is
unfortunately limited to a used macbook running linux in a VM as that
Asahi installer sucks ass, so rather limited.

