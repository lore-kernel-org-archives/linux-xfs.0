Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19B23312A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808214; cv=none; b=dPXl9egxSOp6YQmuiqcS7yz3I9V9+OnCjaVL5YWKxC6wwKnAZZZGBIuNS6K2k25w+pMvvit+lBZaG8haY0DOn4ExZuzZiniUXaTJ1sPecXjwRrvNvlRq80rmz7cWShBLcfKyf2YzizvOyy7DIWhlFPYxxGIT3ykWiLIagIcPLMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808214; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgd7OmC3Ho6MVFXXuQKAoIs83mgo3M3uPDiSJIkDgrIJKMGz80a0pYq7jQQknr/aR+VhRi//dszO4fnrOD2sOyW6LeKqqL54P/6qFt+AsRRgLu9+DsFkDC1Xfvo0fjdjrh/qTztnJTOgQYoCpHet3zpvkOzijum73M4a/Ou/vzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fN/zxGvt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fN/zxGvt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fN/zxGvtBWW5l6BUlrSZVF2cim
	IV128WS5HPyRChSlDmd2QAbUyV5lA5ITWF0ikWiPKihia+pWlKq9hQLByjnffFHjGCwAMYpo3JakB
	c5wj4BnNHgs6ffmcjuK+F7nGkq0AWanU6Smkba+ka8OovHK4gzrkZdH7rav04LZm9dMVzKV3BFhEp
	jRTlM/kKxHyYx0vkPNAaqPX0zISVyDAC/XniV8x0Kxik0Vi3rRk0SL12NZHb1POMNz5/WCb7b8dQy
	ScAvrC9PWER84ofitT7kUDqxpN3OIp0aa0cMa9xBe0zR5FVGeu4qZDxGxIbUvnVrCO8wbv3L/uMvE
	vB2MrUGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsib-0000000AGli-032d;
	Tue, 10 Dec 2024 05:23:33 +0000
Date: Mon, 9 Dec 2024 21:23:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: resync libxfs_alloc_file_space interface
 with the kernel
Message-ID: <Z1fQVJYiHYuyMCZE@infradead.org>
References: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
 <173352749331.124368.17875844919571380397.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352749331.124368.17875844919571380397.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

