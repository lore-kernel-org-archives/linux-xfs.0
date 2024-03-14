Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199A5382
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710382020; cv=none; b=PnfKrtNjBBxMV/B74ik0E92GM0jQO5Z4A7G9RGipmVEAnPRV/l89Lqc3EL2sEBtbH6N24PyZ6h9/u4FBRTl9u/njLUKxcFw+Q+8MCu6saNCbR8ZMhupfVkgfl0YuLMYHFikFlwkFoUy7eNz/Fo41reLl+VBq8YPA2pJH2jF56Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710382020; c=relaxed/simple;
	bh=sUkP5y3s+RCjHlLYBHSypu29zyf7FkgrJbWwBSFLMYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6ZcXH7O/oOgRYVmE0hH+NgpRFZqenA/ag6MorRyMW12zdOHKIL2z1dSl13bgAUiZIh7ovfdPEX+ldQ5qfXUMp5ap0QEwJm4iLmKFu7o49WiDIHd+RIu8zpRTGeIoR8curikJBaoo/RamTxCcLywP3Dc/aJ06eUokbeVoXcIg4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TmKM1wc6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TmKM1wc6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sUkP5y3s+RCjHlLYBHSypu29zyf7FkgrJbWwBSFLMYw=; b=TmKM1wc63UshsMo9baSA/sjMHz
	G0m0Y52cidhEGEHCwBtriBZ6PzP5zPUZm8nhH8t9rGAMFyJ5cQhqktVxioil+ANpR/w1+DcnlAHF9
	cKxp4itQMd2tz0Hh4UKAU0N2wT8AmbNOvzimCPLKqR+TJAlhWh8R5U0PLiutxjsbNMkr5pTG+E1so
	MnDYXgY1enuyOWjm8IxHp2L/341x1lxbo7zzMXnDFU+WbRuIBuYp4ntvgVt+Pxlf9qrBNfxMAu2Zm
	kJICqJ8SdBDVoxltyjd9gWarhA9yeX4CjfA28OIIQXbNOva/26+yyE8ztcrxjgt/p5kGVbFl/ExpS
	iWoHtUQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaUl-0000000Cdax-0t68;
	Thu, 14 Mar 2024 02:06:59 +0000
Date: Wed, 13 Mar 2024 19:06:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs_repair: support more than INT_MAX block maps
Message-ID: <ZfJbwx0CQbsZfUxD@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434843.2065824.16649539998389777667.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434843.2065824.16649539998389777667.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(the new BLKMAP_NEXTS_MAX is much nicer than my previous cleanup as
well)

