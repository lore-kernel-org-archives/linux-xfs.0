Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0951AA797
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 08:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782461392; cv=none; b=ed8S9umrHwtup6ArIjfaF/NS5pAUvJRnuThKgMOmu6aYEgHZTAAYclGRZSCDBJ9SvkcsYBw8Mh+CAROpM+3rYoShRAuQ2rCYu7ZU9ehGH8UFBgNOZHM8DYOv4tky0sr0mxmdtJhvWe5e9mhbkUYeI3pDJpU2rzJPeq21OxcWWUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782461392; c=relaxed/simple;
	bh=NSrYlo/EeLtWzZDIXVfOaouF1fi6seRPY2StUB0Q988=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOPV3Jo6ggkXzKAvmufekLeU00fcx9CJjyNkPd2iiYE7j7Pub5bmVzAblXEdki/5MlioKQuVor6lTWnHm0YFqlv2Fw6Rj+AvgRplVXWj5jS+RBARw9OqGDtchu08OF+TA7mVxVr7bPOTgs5/BgeEWzxr/zoap8o66MkuT08jdEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T7fLUz/G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T7fLUz/G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n6l7tCnKxEm1TIoNdK9KgGm8Jn3Lz8J0xX6dzVjKNjE=; b=T7fLUz/GFjHfROr+Pt5v5I6CDw
	Z0D8K23Ph12PKQut8R6XJcJ18mMmR/p+3cPlTDWyA9OrqVm2iOm7gLK37LADdGoIKxA9NkXcYsbqp
	9mGRhwc5tYEKkg/XP0CJi/OnMrrusDOVcmzjqccyQg5Qx3EmfpwFmErC0GM37LMXD9tPM2VBmdmQ4
	HaPGrKOvkWnKMAlDs3effKEXjMEL/v7ldJt9IgHX6dIZyB6Bn1W0LE2p18DPv6gyKquySJBKyI4sV
	LpuwY/XJZrZ9sw/TujzWkUNE+4vGK+B6Vlw7Dt08F2MJ6a+LFgKCvMkAgtTpPueTe5Z4sPj1Xh9Xd
	i1dhhgYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wd1dD-0000000AlMc-0RKu;
	Fri, 26 Jun 2026 08:09:47 +0000
Date: Fri, 26 Jun 2026 01:09:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: vmfunc <celeste@collar.sh>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long
 dirent names
Message-ID: <aj4zy64RwzgALUdM@infradead.org>
References: <20260625222337.54449-1-celeste@collar.sh>
 <20260625225758.GN6078@frogsfrogsfrogs>
 <178243370553.73182.935356806206037088@collar.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178243370553.73182.935356806206037088@collar.sh>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 26, 2026 at 12:28:27AM +0000, vmfunc wrote:
> On Thu, Jun 25, 2026 at 03:57:58PM -0700, Darrick J. Wong wrote:
> > Why wouldn't you fix the structure definitions to use the proper VLA
> > syntax (dh_name[]) instead of making the code less readable?
> 
> looked at that first but dh_name[] doesnt drop in cleanly here. the
> declared size isnt slack padding, its the count of name bytes carried
> inline in the fixed-size on-media header, n read_dirent() in
> restore/content.c reads the record back out using sizeof() of that member:
> 
> 	namep = dhdrp->dh_name + sizeof(dhdrp->dh_name);
> 	memcpy(dhdrp->dh_name, dhdr_v1.dh_name, sizeof(dhdr_v1.dh_name));

To me it looks like the problem is that mix up the on-disk and
in-memory structure with different semantics here.  The somewhat
more invasive fix would be to split the

direnthdr structure into an in-memory direnthdr one, and an on-disk
direnthdr_v3.  The former would use a VLA, and the latter the existing
hard coded value.  This would also allow to make the endian conversion
in xlate_direnthdr/xlate_direnthdr_v1 type safe.

