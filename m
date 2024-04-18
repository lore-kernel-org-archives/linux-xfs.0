Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C6253AC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414230; cv=none; b=Fqr6p2IpKpxwC71/AE+h/5lZx/foPcEHxNS09HZnjjxaVn8priZwARNSzP4as+VjEORcqxawzWLY7ZNz+TBxKOS15KLRTzIE9dqtqSNdvQUInBiu57bfCZOYNMxrzF2VWGNEuH+MtqyQzdzL1snDgzD9uSRsOdtsQeEJ2KhbCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414230; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsU+xO57WApQzI28cSDR8qdMh3+JZJA+b/TnqwlIUiul6vyG7x+6eLWtdvOpw7PVUX6gPnO9dSUfxuZfnq58jz+gGk4LZyuebH19dwc4lvkJoytle5Vqg6Pe/hCoj7Y8be2DoWR816gDFvGJukXwzgo/uBMJfzQ5SXpVORQeQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Mt+BOv9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Mt+BOv9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3Mt+BOv9NjeQLjE5NixBDEZEJI
	ZLqab4p82/QwnxMllWI6xs9wExQuO0p6fywRINj4gWVSp0kojvZ3XA3mzoGOIGILRq+2WCfG1321M
	8M2InWf2QfI7ybkMbb2VqpEPHMp+TlJspL2W+UY3Oj/1jHj0FNEEQz/BdOHx4v9hNjpwFuXUF8TWT
	/hTNj7EouR4eJh+5GV0WJg0dwDVyohTTYc4G3ys2wcsE933/M0SYdQJdjpdm+P1xL2GjXhbnYkUNF
	+YiJ9xLnOfW3lHO9x5+N2I5sMekPTYNrTy4vZzcEj9ovmcbBZLTvzylxaKkr9kyoQBewLttnOOcib
	evEJOqrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJJN-00000000tJg-0mYc;
	Thu, 18 Apr 2024 04:23:49 +0000
Date: Wed, 17 Apr 2024 21:23:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] xfs: fix iunlock calls in xrep_adoption_trans_alloc
Message-ID: <ZiCgVdJEo4W7usRW@infradead.org>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
 <171339555995.2000000.4526556907495165731.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339555995.2000000.4526556907495165731.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

