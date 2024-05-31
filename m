Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6B2208B0
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 05:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717133983; cv=none; b=U6J72VsmPzrVtiOCKPuPX2HkICjrzJHqcbdSqqFD58eJBS12Dop/7EuQUbI10YQYd+/uBnyzbkvInostCA5kowhHIYNubYBkpKHm6AI73dSIjaagvj94Eb6MRnFe3vBPahBmhrsYR4qjquxpJslbkhExA8AsbacvaAQv6OXAw5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717133983; c=relaxed/simple;
	bh=U9K7vthrZBx4zAbKMxLJ8tSCyrG/WA4XH3LZzdhdItU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQya9ejvmOwUO6sDBeo6OAFQxg8oRZ96RRsBV9inhshJbhslip4LnkkOB5mDaLOlF0efShCqePtdPwS1N+fEpbRXbSA4p07tzuaJr9/+5ZzaSTpO+OvukPaTT+xfV9/K/XXH5aYvf+Bv/Q1fsurccFzfv5sZfbOkhF8jdnM78+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z9JIs3ve; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z9JIs3ve"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Go4G8dS4dXXXlJkkZc/NSNYCFIJHZ1Bl8Nkn/fxg7sA=; b=Z9JIs3veysZHNMClmgBTdpZ1IY
	Kcz4K7YtVcAjGp1fREIEVxOmdWy0HyuuTeRne5V1iS8lyGFh129A5JU0RsUk0TnGMDwJ25uI1kosa
	/tUAG0edzumcjxFz7Q+UpHA+GTQ7drTwDV4hhdovQEViwFQv4AwAyfLdV3Qf0iFi5CsJYxvCSgc79
	BG+BPdjBrWPlG+MHseT2bBL5g8n+jy3gJhHMmLKdRC67Xn6o0xG0UD1TwcnURHNSL2Lsprlmcha46
	+9iHa41rWB3egPAcPkizhwrROECtvB2YhPNcfYl5lYU2zTU9hDue8/vGQHyLLId4mKH26XooHTsP6
	KnxzYlXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCuzC-00000009IQI-03Ic;
	Fri, 31 May 2024 05:39:30 +0000
Date: Thu, 30 May 2024 22:39:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: weird splats in xfs/561 on 6.10-rc1?
Message-ID: <ZllikUoZiO3jVqru@infradead.org>
References: <20240530225912.GC52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530225912.GC52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 30, 2024 at 03:59:12PM -0700, Darrick J. Wong wrote:
> >From what I can tell, this wasn't happening with my 6.9 djwong-dev
> branch, so I suspect it's something that came in from when I rebased
> against 6.10-rc1.  It seems to happen all over the place (and not just
> with realtime files) if I leave Zhang Yi's iomap patches applied.  If I
> revert them, the screaming seems to go down to just this one test.

When testing Linus' tree I haven't seen this yet, but I also haven't
done a lot of testing yet.  I mostly triggered odd MM warnings that
Johannes fixes, but I haven't seen something like this yet. 

> The file itself is ~1482KB, or enough for the file to have 0x169 actual
> blocks of written data to it, so the delalloc reservation is beyond the
> eof block.  Any thoughts?

I'll see if I can reproduce it with your tree.  I have a pretty full
plate given that yesterday was a public holiday here which doesn't
really help my catch up rate..

