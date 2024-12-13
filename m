Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6155917AE1C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072785; cv=none; b=hIwJQ3Syaj9A8C4uQF3HWNYnZ0a0ds4iA0rhhfp1w2rMdu5ZOOx+H3HZ+aq2jul+gec4zIyNqHp/J8wNyv0OHxs+A3wMyWDy3R0iM1WpzJxeoSxfzKSjBOg8SP6VMqQTw6i4rC8P9QMSxRhlPFwKfMFv1Mz4kLrySqa6PCXFSjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072785; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HytXiWr2jXirUF0cysEUAMhHh+/IX5QrdUv3ddAujiGP0a1p5zLqvFc770SBF3s0bZYOS1HoS5bxPaPGnCyK+r3xCyuxoOhnvCvKkZ5Y+Kb0UvuLhy3qRcC3PnT2VCbVv2MDvtbGy+A6D7NEA3Ql44BikzIGQ15AzMepUQV8lsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LoTLP34z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LoTLP34z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LoTLP34zaolbvdwydLurFaiTG0
	2moYwCZU7QQnvGIzWDAVTiWM74N091k92ObD6ym7ez0B2wqG2Q3Xg98xX2ilpwkPbsvpZHP62AbkB
	3eQkXsJsDdD7OnEFZ88uNfPz+98hB+Rfq1L3ftWsIdY6PLMYs+avrowYFXSHC9mj91Mk2l9OQ0glE
	t/syLDPh3PPcpViQOdW4R4qEfcDPWBWqrqIvVEory+VV/0qnwpGw32OZijH9i/KkaIONOhy1NGbrf
	NKqT7STBCGAEyB0Tcr2RBiB2nlH07JxH5Dkm4uGjLUDjcJut+T5X2FnIqNZ20pLtkWj/9ilf3RuZM
	jC0UDY9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzXs-00000002uHc-0EJm;
	Fri, 13 Dec 2024 06:53:04 +0000
Date: Thu, 12 Dec 2024 22:53:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/37] xfs: wire up getfsmap to the realtime reverse
 mapping btree
Message-ID: <Z1vZ0C6yDw-7Y5tY@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123606.1181370.13332852313724906133.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123606.1181370.13332852313724906133.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

