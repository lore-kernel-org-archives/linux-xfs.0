Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC74A1A
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 04:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744778175; cv=none; b=lnjHFM2kM0VKxroFkGqkPILIC1EOwNP1pIe+px0UXC7J7l946cNGK+OYDCc3zTpedscgh6ugyVFlgWw4w+/yFr9s08zPNznbzRkRSbM6Zalv8thahMhrY79OykxqxbHIriNs9r+8dkRg/FcLJvuHG+CCfxfl7XXtGqmnuaWCl7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744778175; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rk9WduEH4O1Bjasxub5RM4lBLdQXoRI9kNTvW6lOs6nYPnGDUKQhoju3OBxZfrJLhULWuaBJGbI+ZPonmf+UfiCjUsC+c9ig721SRVJ0RZ10BU6Dv+e23bFF6qjntZW9RXxWbv+6dcQQdTXR3vZnMnMhTBeqaGzOE20v2NuTSOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PqA5HRnQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PqA5HRnQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PqA5HRnQvMg9c4cOWZfusqprgC
	GCcvFSYTEUPbX4NU/eztoojznGFk8qHSggp5l26jU2BsDXTMFL6Vv5k1eyFXNeG59CsKICriN2sIz
	uZnsGyZftKJ7GRN+J35+1k6HknYLqbBSXsRHc6luyz7+uziNPJttiNiNi/NOpPE1YGOrdjRS45jKE
	Hmrb880tUWvmK069ARg/6lxzgvvusGfvpznk3W4KiNb/r42YbyCVQe3n5I8LyLMwJ5/84Y6SsRuD/
	43LTnFNzeB4cMhtPt3KOSP/p1GeNGtDVUyej513i0oMdjecGJjYOaXCIhQPS8lNF7/rQsBIpzEGF/
	Prc0xkLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4uVS-00000008AFS-07cH;
	Wed, 16 Apr 2025 04:36:14 +0000
Date: Tue, 15 Apr 2025 21:36:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix fsmap for internal zoned devices
Message-ID: <Z_8zvnmHAYewIP_l@infradead.org>
References: <20250415003345.GF25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415003345.GF25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

