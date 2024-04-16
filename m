Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076137165
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285676; cv=none; b=En4y92E2H33oWvcY2huhMcahjPaT4tyTB0uZhIkYTZl9lm6GLSfMvbAoWUUPTp9ErCiNUDEMnFO9MytyekJHnDUIgQnkkuOapR+e3X0D+4Au+anD3gv8kCzneq6YPBBzXrTMx9hzsfsGfZutyKtE3xfgYUFjJUU/WkK7HzAF2Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285676; c=relaxed/simple;
	bh=XVlCZNeF9QlzXJiAPVCUOLKxxlcw8Fkianld4CXe1BA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYprjdEuzel2fiqOfw+34vN7+baalCn1TnxzkTscdoPU3puEUa/JpU61H4C761R1/VQBFc5FkqDp2d0GIJbvfLwy8wLlz0J6QH7JmU3OfKNONEijzkIe+1/PV6t5NJZPkhk5PFjJkGj6xJX903Q/mcQtaSncMZlDmpT8Kn1IihQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nS4M+jhm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nS4M+jhm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HN0MGDVrOApibXSf/f7cL0DX3HVXAB6peGbVDnXQHEc=; b=nS4M+jhml7wlA5ZZ5zb2l3gvOj
	IwUzqPafKLAc6bdEK61H+RQH/lrzqd4B53a7nrJ61sfUCTB2dMUoYhkaQEWx3Ebs4Ubo/ctQZQrXt
	t0AlUSgdq+wlK7mcXn+K6XpTqP5/0BffZiJSj4YSiQis4NPRmJzDJ8uuO62WoQdxRNC1eyaq2PCyB
	AU9Tv/gB7nter7UIB2BnAmeOzCUM1i0ShVlWCxo2eVLhtXSxH7hvO3/GOXUir6hvrmdR/zV0LnaAG
	IuP86vjFuoWl35S12rP+BYOKj1dLuvK2563Z0gSAcOshs7qWxuZedEBUgF9M/sNyeHR9i3wnjGVQY
	ug3s+4RA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwlrv-0000000D3SV-04V5;
	Tue, 16 Apr 2024 16:41:15 +0000
Date: Tue, 16 Apr 2024 09:41:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_fsr: convert fsrallfs to use time_t instead of
 int
Message-ID: <Zh6qKqdOC-U0749N@infradead.org>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-6-aalbersh@redhat.com>
 <20240416162125.GN11948@frogsfrogsfrogs>
 <2269d1fa-670d-440c-9f37-1724c3b5aa4e@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2269d1fa-670d-440c-9f37-1724c3b5aa4e@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 11:39:14AM -0500, Eric Sandeen wrote:
> >> +fsrallfs(char *mtab, time_t howlong, char *leftofffile)
> > 
> > Do you have to convert the printf format specifier too?
> 
> Hm, yeah. Another approach might be to just change "howlong"
> to an int and reject run requests of more than 24855 days. ;)

That feels easier.  Especially when you have to deal with format
specifiers of ny kind sticking to "simple" types makes life way
easier.

> 
> *shrug* either way.
> 
> > Also what happens if there's a parsing error and atoi() fails?  Right
> > now it looks like -t garbage gets you a zero run-time instead of a cli
> > parsing complaint?
> 
> That seems like a buglet, but unrelated to the issue at hand, right?
> So another patch, perhaps (using strtoul instead of atoi which can't
> actually fail and just returns 0, if I remember correctly.)

Yeah, getting rid of atoi is always a good thing.

---end quoted text---
