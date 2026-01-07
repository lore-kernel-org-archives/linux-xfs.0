Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BB7333431;
	Wed,  7 Jan 2026 20:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767816535; cv=none; b=PFhogYU86JTy9cLRIOOnohgaAuEpuMY/r3NK/cuvJGORzGTFJf6CWVCFL9+Tmx3DgtxjS9RDMfgbUVpRVJ83vtuy5XtO6QmOfc6i/IzQleWDUQfT4s0vBSBwjatcDSkXKC824De/88m6ZexRj0R6IQy8+wj/J1g9/mDU8et1iIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767816535; c=relaxed/simple;
	bh=suiBVf8rdljWGmCx6x7pZWDICn1WiNPdKfSGtKjr49M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DplkjgQrwcg5ViKFnJfa2WweHvc+X2G5yDdrfKAr1ctzLYlJRXoSifO2Yr0gzR6nElwa6if3gxfZUmG0Q093b9ccNicrK74U85RzyB6ULHmr2gZmAXKayWkSum+OvohyV55FWpu/MFDH4AOq0Jc6tAmohs5L+Mv51ruc7gNs3Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9OGphUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9OGphUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9D2C16AAE;
	Wed,  7 Jan 2026 20:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767816534;
	bh=suiBVf8rdljWGmCx6x7pZWDICn1WiNPdKfSGtKjr49M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g9OGphUD6tlLyT6hyKyk204VkOZ9TJBG75kizlc6h8C1Rtbr5JlUoxrMDKCDWINiC
	 lcYocZm7gtlA95MRspXWf8MOG7/S8UAPhMJiwc/zYNNSmdg6Qp5KinSVHHasT4WOF2
	 gz5hahXMxLC2BsTcogQq9VisyUrSZ1niriyAucP/E30JMsIrx1Za5ZiJ8xO2RngVEg
	 D1i5+bzs5mE+osk8Tdjwn3Mhlcg8NCCJz7WVC4fRTgD1DPokWpUQBz4TjGnuay99lc
	 XqNKwrDBnp/HuAkVApxDHApPGC1WTSESYpxcL3turcXvR1QYRO5LIcBEif7gPjMbiA
	 bz5qdh92H39fw==
Date: Wed, 7 Jan 2026 12:08:54 -0800
From: Kees Cook <kees@kernel.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <202601071206.87F85EF2C@keescook>
References: <20260107183614.782245-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107183614.782245-1-dmantipov@yandex.ru>

On Wed, Jan 07, 2026 at 09:36:13PM +0300, Dmitry Antipov wrote:
> Introduce 'memvalue()' which uses 'memparse()' to parse a string with
> optional memory suffix into a number and returns this number or ULLONG_MAX
> if the number is negative or an unrecognized character was encountered.

ULLONG_MAX is a valid address, though. I don't like this as an error
canary. How about using __must_check with 0/negative return value and
put the parsed value into a passed-by-reference variable instead? This
has the benefit of also performing type checking on the variable so that
a returned value can never be truncated accidentally:


int __must_check memvalue(const char *ptr, unsigned long long *addr);

-- 
Kees Cook
