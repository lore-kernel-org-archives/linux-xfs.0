Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6AD1D5CDB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810716; cv=none; b=IumkBycZYEo9QtzvYN7Z8zouU4IlQm+ECCt+AunzahmIh5ZYQxt+wnp0Y9Fiy6oEK+bOs0Dxsmv6nTQEQ3CtFoX3EfcwaM/Qb2zhFY2ycXM6Pt8894yHCWsIhNXcbLGXzWkn99gKJsX3i54E2i5ak2qWBO5BE+ZhAeQNfcyXcDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810716; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGhDd7MRugNQhW/ehM/H6sLwTQRvA2P/DIYHjCzKJBEBIaefc96uUxIohYdjJdAEV8PgcM0fsUTb2jH7L4yHK6Yq/8quTRQye4n1t5IOTVGplZ+q3INxH6u+Jc1vka6paBfKeavkxdZBrwV7DoF4uOlaJ6iJiQbB3btOT5+eQQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SGhOUziN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SGhOUziN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SGhOUziNsZHI6SjUxGhEY6tHqu
	zvdxT6LpOaeseP2XR2odnCcedEP+jvKRwemt1so5ZenZeQ3RLrwXG0YMijV7Y02bEwW/FIub5n23A
	tYz6xptwYioA8xmY4b39CgLvL7e+4IZNkupxdXGFfnULRv8OeEGG0KErqiBDJZpQdIs/cibyEj7w3
	cza9cywvx524j1/Nn4zSgpgE726UU4a97y8lxXIh7t8n2nL5fEnu5yqs3Fl1XidPvNJ3qyubm3Wda
	39++j6m5A3hMpdD6rbg92ZW8fda9q7MlnTgtOwgYsmzSPTIeo5Wr8ftssDYrG778Ne7Y6qbsB0tI1
	SOnU6aeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtMx-0000000AMeQ-0ztJ;
	Tue, 10 Dec 2024 06:05:15 +0000
Date: Mon, 9 Dec 2024 22:05:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 47/50] xfs_scrub: trim realtime volumes too
Message-ID: <Z1faG97ndOMWeXSa@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752664.126362.6074533714975702330.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752664.126362.6074533714975702330.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

