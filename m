Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F5822089
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 05:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723528008; cv=none; b=rx6QLteIQl5Lc2pF5aBC99M89w6YBHGQD04amKx5IsKuQxK30QGMbyXkTGdAI7h8Ox0rTN87XApseRSUgHp88beHbL89WhX/B9pOChoRQHLumMGBsUP4/Y3CoKewBZoM4nJ82VXg4UmrfWbMjhDI8rhcGNIJS4TB4gvUT9C0mL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723528008; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PykX70oF+0VOKbCMPNh/w9L8YYO4Y+Oxp/p2ERV5DoX9wTwhNZ3QjIL+TXNh2ZhXlChv6GmP7natPtNA7mnkWOetgT3/qy52RaR49ljk6J3FXK9cRma7rsB/iswDri5puQ75FPnyqa2bbp/S3qrClO6BiSQMC7tITTqVBm02RQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fGQrorwr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fGQrorwr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fGQrorwrNXjM2JYumYAKWKtxxF
	ErQ4GUQLZ4FqK2063BfGL5vBkRgBLGlaT1Y23TugtdeQkuw9ikk98DWpJpCsFJoxsW8miVgWIRHxT
	MpNH8HikiZR8oR4ujSOb+/xXzJizoZpsFYcOqN4Ov4OBHpt2YztXKPuiwo3qvR0ZqIxrAWU0t9V5d
	VjZ0McC27cs9lFHltDmZ2a4bwlYEyhTtVoWvb0t4W+dX2xYFrz9Y6IDtnnj4RB1ytKLZs4izcwQTE
	UieECdU5mGuvf7TEJ3lB9VK0m90TjdteD75ntLP49QGsQCf26cy5esYzPaTjbZjxNECNPEr+1HfkI
	irnwgI6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdkMo-00000002U10-2fMq;
	Tue, 13 Aug 2024 05:46:46 +0000
Date: Mon, 12 Aug 2024 22:46:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] xfs: fix folio dirtying for XFILE_ALLOC callers
Message-ID: <ZrrzRuv4zeJMfhxy@infradead.org>
References: <20240812223927.GC6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812223927.GC6051@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

