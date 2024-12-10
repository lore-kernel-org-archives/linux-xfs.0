Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA8227582
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810734; cv=none; b=PmDqDOuRo5siiglWI62VTTCoZw+D85BZJ/mHxAPZOvO6VPhFnITIm4kfqNm5spgrVHFMZJaCrJ/qSr9mkQxm1R3xv/QXi6c6g9WOdbZeTc6du/lP1GVdDMdnHKazpv/qgdxUmJf2T7qYqFvQ2/evz06iJFiCrSD6ZwQXSQhsBuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810734; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gr083OwWPGCO2/jdJj0ZxPQqVPQoHYUdh1CHVPRzgv9j1x1drab/hKsm+JAROElWntvort2nauw7UoQepa0B8xN9uk14217s26UXk0TjoAnFsKipudjnH0sluXwlA7xl2LGLS4AzvV28dg7PHxxtkBDVxbbGNKyQJS4LT4D24oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wmGG20H1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wmGG20H1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wmGG20H10emOO7+/6I/BhzWQBa
	3d3bQgYvPawst2qr4E8vIT2OrzV9EJ2VMA61+6WSfrvxRkr5Wi3ZKDqEph0IJ1JNY4vkPPybbvNxu
	sj/0Lp0hMipfX2iELF9O/N8WouYyati/Hyt5B7sYhASqK+DFnXhdzMdPQu6kQw0zvQ+7am8iN1GGz
	vxI+IQ7xpBFfhpM5geosLxiI6oJnAfMDGe4u9+acTODYTLM2DnrpcqjNkTjvjuexRUtE0fc+VcNe6
	/xkbVCFy9Zz8EuYwUam7eS7PQgoFWTdJXlguZ2NPgl7GFEQfzu7QfK4u/RwJTx+XU586aCIs0BXAn
	2jkfJteg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtNE-0000000AMis-2qps;
	Tue, 10 Dec 2024 06:05:32 +0000
Date: Mon, 9 Dec 2024 22:05:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 48/50] xfs_scrub: use histograms to speed up phase 8 on
 the realtime volume
Message-ID: <Z1faLKiMY5NMSjWs@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752679.126362.5625686525882316849.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752679.126362.5625686525882316849.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

