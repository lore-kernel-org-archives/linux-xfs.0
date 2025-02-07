Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE81E154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903290; cv=none; b=Gp0BxQYsnrZHNuKI0JrEkhtcHiPMaNocdpHb20/jMqVoLpmUrxGhp+FUPPQU6qu0h5Y4T9ZBL7QA/H5mcVUvbFP44IQ8tBDN3QKSzV1h9NMoRCUETcnKPtk+M2u70Z2C02t1hhKtRF1N+5qhy+mpo27nAwPOiCNujWWv5VuUh7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903290; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HD8y4+yIyWGgYT8mB3rmFORkSRIp9Pwh2yoX2Y71DHC9eAn7yNWmhWmSR6LyGFrCbMgS+1ENu4BnzpCM2jlYdP3yng1pZoYn0iIQdsu8qvEGysdauTdlwPqCWCh48IhJH6vBPmeN9mC1B9ZwmrBltjwMtglkZsMM8i6Fi/l6IJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UIsJpC4P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UIsJpC4P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UIsJpC4PFSXQTIvIgo9Pf5Sn0G
	qXUICopfzwLN/UbElAEdv5x2ZjnBLU0xAPwJtAHWiHeCURxxEU2agcgmbAjzzcvk6opBFWfheajQ/
	OtNnlUiMUTYDBlIGXyfmAEuducJ2T4ZvfDVzPsFI/JHFnbgcXUU6TRRHiOPV07Dpphq6fJ9a4NkRy
	bmsMG48K/xQ32nx1g0oCxa3ALasaE131Xnv6T2zxCz6tQMx7X8+jElJEssdH2h1Di4onM+Pgu2dJ1
	44cQg4Fi4l8EEA6XqToOOTnlxEblpu33OymKF6n7jrEKJrSgP+05lCcRtYlyWDevcvuaICl9NURyV
	O7Urrp+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGBE-00000008JDw-2jFk;
	Fri, 07 Feb 2025 04:41:28 +0000
Date: Thu, 6 Feb 2025 20:41:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/17] xfs_scrub: don't double-scan inodes during phase 3
Message-ID: <Z6WO-PJeoB9PFOWj@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086213.2738568.8939791256440476361.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086213.2738568.8939791256440476361.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

