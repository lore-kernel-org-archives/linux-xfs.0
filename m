Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189B27FD
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903629; cv=none; b=i/SdG2b4YhbXnkrshlBPxrvfDzuCF8w1Wp3NyK+y0FDpRCSbwnNHIg3TfPRXE8TtIWnkCDa337H6XVAvW9XOzWNo2Mj+ba9dumVfbUxYqopf1jR3URDAgn4T9ox2pW9iVkfOr6pn5JUWsb+IPgSCeuez295i8XUBAxJnN8Zspvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903629; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZRIF7iLiDS/TNmCPI2MFfVduw9hsaCLuUkkiEybrIIZaNu4gEKep7OXuYZXNAfxVs8WEczG5L2SEKzcF4fVt1cnsidd0ihHHz8/HUnwioRMC0fggoA1QpQOAtdMLSf1k1ykiDy21BKn4hi9ofV+gGrBoknqRBKAIMFolvmU6bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T0ORWysC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T0ORWysC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=T0ORWysC6UHLSsXuamw/98tMir
	lfDwFGLTg7nV5hn9EZ8ak/Apc36Q5gGGzt1btJqXAPDJ1yf60yhVIjeC9fUOfYO0AmN0GK82o5yPp
	hXxZPbRgPfRZ4fCiWaR0nDeIp8t2gL82tNe05YuorY7V7avQSQd3j7lWmtLuTb//6Gaj2cUXfBnKg
	wDm1EVzVsLg6wufQsO65WG2ioa6mY/liPf0azPw+QqZlXKXXc8qj5H8ECuCGx8KDZ13xijdQYvTqr
	+4dF7ulp9Dpsg5kpApND2qyiF6rt7CJOfow23gvUnQaosJzPkmFUk6XCFOO694MgGNvD1gzUK3EJA
	Hu2xQbYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGGh-00000008Jha-3Zp4;
	Fri, 07 Feb 2025 04:47:07 +0000
Date: Thu, 6 Feb 2025 20:47:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs_scrub: hoist the phase3 bulkstat single
 stepping code
Message-ID: <Z6WQS_6zrXDSAwQr@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086287.2738568.12350824518838304954.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086287.2738568.12350824518838304954.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

