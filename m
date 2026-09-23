Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17360346782
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 04:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790138389; cv=none; b=SNPGdUJbYhoUe3uGNn7yaerMgUSV39tnU9ypULxnZB0DtCCpUAUWqH0o3T5wnFx84qA29oM9VwoDvBNnKK4owFmn6xOwr/kJDHL0D5dfn1XlIc/KQxVjO8+p6qaeX+KrYRyurAAxqr+RZa/ny0z80GLzJNZ+N9p36KGAoGJ2dDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790138389; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfOf92H3pf+h8RdqIgebqSofLu/yEMWkf+7uBgdIA90GblpiEjVprBAv4UiWLfPqFeBLTVKQd6JjD6RdOWNb85+214mhrD/z6hBctvGkUEwkW6IHMF+8FeefrZdtDon2P7rVTtsVSV5PXEn48O8vUylqdsPxS71y41TNUaHQ5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UJRzAelf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UJRzAelf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UJRzAelfYMPKhfFGirBZWcLEJK
	If82f4AXvwEGnWZP4e5UxAkNtAPcVnxvVxjUsSfd9TADMerN14C8VP9wKhW6gMNvUtEGQyyt6IYy6
	rydNRemas/Du/N7yE+spgxRcYSmvpOQvWkAWU5ZMqduwZ1qzV3MUpzV3r7h7GVEATlLHhQt/TUV6E
	qd9DHDL4Eg7rQVEqWOyV/jIa5T8wmnh19uMKMfJ7f/+jn7AyS1c1dakHjz5mDispsKcZ9COHDiEEy
	nZq5BaxzzhdWEzHMPB3R55WJRyM6KCJ41hhvnFOC7DDbD2HYLUijipJ1E476ZxCwSggT+2azmF3zI
	JbjmqS7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9Eln-000000077gk-1zt7;
	Wed, 23 Sep 2026 04:39:47 +0000
Date: Tue, 22 Sep 2026 21:39:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	djwong@kernel.org
Subject: Re: [PATCH 2/2] xfs: share the AG refcount btree with the rt
 refcount btree
Message-ID: <arNYE_0ZqelqeM-7@infradead.org>
References: <20260922231845.3266784-1-sandeen@redhat.com>
 <20260922231845.3266784-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922231845.3266784-3-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

