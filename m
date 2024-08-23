Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF9238389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389077; cv=none; b=K+gg7+2+7HRnnF0aEi4bDO4bkif0jVP3wnswqdM8p2p4gbFVMekurvsTRH/aV+EhOWXmKe7huwcuM3I/9uonPf96qoso5hW/riHflJhraPbURR9OIb3JNjQ0VEM9lOJfTKMWlLzm9NYnjfv5nS8mHETxErsplP112fXVjaqcJZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389077; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEd25q8AZysXRLHBAYLXQmSv0JEgQ7Rc1rkkdphL71NAdzEXGs2y2rNTpCyU9WkOgGlFH0AEykge0BnjwRe29jstpbFHcpW2LuQZYnhW6BC+gl4foevY6lBzYkJBOq2fZoMklp+ZhLwjt6T1YgFFoxjbfxlYuK4e39SHTEt7ec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rwvWEMKc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rwvWEMKc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rwvWEMKczt/wgOgFykUwOIW/EL
	HfEUUSfLo84Q2J7vjPWMIhKvvYUmSC0YO74mYIro7jTi5CxPa6g6vK2hRrWyO9G8Ne+eCjXER7vFt
	YUYiWgFKt9x8wxV27fyYAO4fI92IEs2lW+12438fugOc5mE5dLjE9dGHTPG75ByzktUwfS99d4nbC
	c2rYEWRzqbXxENUK5VRAxikapLO5TsLvdFt7bQT+7CRv4TbtWRMJWdX+nWX0mV2SEtxwOxYSVvRX8
	oipfQ6FfCiBgbJfm4rEhHYzfKrMZLsp1adSubTR65g4dWLk2/wdmxIN08MOfVFiOAuShcWuYEwYZN
	Rg9801aA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMN1-0000000FEyi-0kXP;
	Fri, 23 Aug 2024 04:57:55 +0000
Date: Thu, 22 Aug 2024 21:57:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: don't scan off the end of the rt volume in
 xfs_rtallocate_extent_block
Message-ID: <ZsgW0ySyt4NKUBwc@infradead.org>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
 <172437086686.59070.3726598549775443534.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437086686.59070.3726598549775443534.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
