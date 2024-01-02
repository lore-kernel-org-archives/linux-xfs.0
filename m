Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F72D313
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K9HAcIZC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qnLLsC863ewR6L4nFn3nx9J1YryYoV3fkWK2VBxGKxA=; b=K9HAcIZCZwCk2v6Ekf06yaL3Mf
	6bK2zGJwu2aLUWFm9lDTeHgONSCw2kgJ5PsahyTQTE05pkcwJ/B/a5xqPvh8soJUyO9oE+bnjOJGE
	TM0EgOjyOncfO6yiXZAi0OZzDcN857jdic2AcyYJXgflRbcRzMmsmbLFvjtZgo9LUONVopiEm11MP
	ydVDphNyfBt2Ou002EMUokLAi9qkVeSNoy4ffTwZ9KIjGhKcRAw35FcVi1Rp7HwsHG/lqzLxDU72l
	vlpyYYmxgxS6wudItnRaf3G16kJtIdXYppTXn+/jTwgtohlEcKyussdEestcJttfNHyEJauOwnBLh
	L5Gcc/gA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcGl-007dMW-1n;
	Tue, 02 Jan 2024 10:45:11 +0000
Date: Tue, 2 Jan 2024 02:45:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: reuse xfs_bmap_update_cancel_item
Message-ID: <ZZPpNymYGUa2UuK1@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831504.1749708.16128807281068864794.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831504.1749708.16128807281068864794.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:21:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reuse xfs_bmap_update_cancel_item to put the AG/RTG and free the item in
> a few places that currently open code the logic.
> 
> Inspired-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Isn't this actually pretty much exactly my patch?

Either way this looks (obviously :)) good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
