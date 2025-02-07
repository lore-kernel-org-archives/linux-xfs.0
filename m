Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFCAFC1D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907939; cv=none; b=fnAagJbh9FGKIMWUaFQKgAWQc2mzdKTPDskhn5kPGfsDPiVZAhud3PW/yS4jNsxoD4H32Mk74eG0mvKPidO1WkaQn6X6jpKq/THngxY6YwfxQxXssaj0qt94WPTAhzN2A2gqXysaT1WY/8sa9u3nj4VUYxbpAZkRy1Mtiam3U+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907939; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drkGYuqHOxX/VQiHolHaMsxGuwBjyzbdacCCP0kkPzTWEJlnLi1cxgO+crJI2gkWr6dDeT56bNbUud4Ol5oVxicooYNa6rl2fj1qhp7AoiBjgGguYrEDMUy71WAKsyoH+7ENXhAL+vzzNogR5VFkOgD0KnBs2GEQgJJH6IAyAXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z7NO8KIN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z7NO8KIN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=z7NO8KINN1qayIb0lZDKwZ/z0J
	DHjr9LoMJg8p0KKiS+IUPQsVpFOvL6XDzO5jy1+WHkkoBRpWsdTZHBn2w/PGVBYfjLurEEyqBB+Z7
	I3n0m45WFYBgceVjVVpalkjphmG8M8o+MYdlXtUIEtXOrv0dPrkTFbtUe0ATI/X6s2y65rFSomLmm
	B2KhMNAKRuaRMYzHud1WKrG3WFw1+4AA/FWPc8T1iayN0MRLJsT6JrqOdSZ9wEcOz1i0BzxpSXdn0
	yoIMOWO600aAmSFmB0/oEb8Emekte6OCVkhXrNVeej3Z6rdIE2CvSTFFo+P+U5FAqkr+7uxjGXNec
	TOe/NBWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHOE-00000008RKp-1lIV;
	Fri, 07 Feb 2025 05:58:58 +0000
Date: Thu, 6 Feb 2025 21:58:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/27] xfs_logprint: report realtime RUIs
Message-ID: <Z6WhIqYx9ZJEXFFi@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088479.2741033.18274174802899432825.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088479.2741033.18274174802899432825.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

