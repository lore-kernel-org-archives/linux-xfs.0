Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC8528FFF6;
	Wed, 10 Jun 2026 13:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781098108; cv=none; b=dqFj+NT1nat8ettpcBa/0vkb5GPJ/bVUWzHMhmFBna/0sZp2bMuCePG5szkb5CwbPjZ/owTwIeN8B57sYHfT0hFlofu07hWpNuJ9w2WrpkL3T6gDsyyzYQGjYTiI3VaXD9Elvc1VmoLG/vFcCrQJeBGkCNBj+4dNdr8f7YEe6pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781098108; c=relaxed/simple;
	bh=wno8a41msfZqOczpt0J2qX/wWUyjLxL0s/yTkb53/L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ae0SlKf/aY9YDd4xhqWsULtZKye6Z2g3CNiKQ5cmsqa0YdCXqfFVpwWD51aej637zImR/BEtQ/3IhdzxUBkG6JtWcJ8plt9TGPZWTSQ7/pQImV5w8/2XtA4+hezFYoUEb9+98YuarvtK1RTDSDqqaFMByETAkUeXfXEmvYzD7rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=taR3M7N5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="taR3M7N5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0R9RrWDu9Hl3Upe2gXgrHqPl4+Rv7lSjXVAjjFMZNGE=; b=taR3M7N5fl82uylW7mso+V6XvV
	qloE8ON4WSBUwnxfBL9GTEtrMSBtUEPlc5oMylyZ2coNITMY8ZNJ1wGlzTn2pIF14c+wOmig2bICq
	w43OE8iL74fRcxiialOBmvWk8WH30C39/xwNYEKdU0tyVgGrh61dLpC/mDxaNSTfkaqgYWCGbd2/c
	OfbI74bPDLKN4RJlrBQz44bbAm4/H1WoC2VlPY2nBEvN9Lt7N6B5QdQcvpDwkj85vOjn6AGMT51Iw
	9BfeIJVliPcni2AiuwPC0+9ByOiyjdBUMwdLrsVS8qU9dsJq6BV/vkvN/F2OI3s7dBkCQr6h5+Awd
	QnzA/n2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXIyl-00000007mMU-3Xoq;
	Wed, 10 Jun 2026 13:28:23 +0000
Date: Wed, 10 Jun 2026 06:28:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: prevent close() from hanging on frozen filesystems
Message-ID: <ailmd8JNOT62E6vD@infradead.org>
References: <20260610131341.1733-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610131341.1733-1-aditya.ansh182@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 10, 2026 at 01:13:41PM +0000, Aditya Srivastava wrote:
> A simple C reproducer demonstrating the hang (compile with -pthread):

Can you contribute this under the GPL or a compatible license, and
maybe even wire it up to xfstests?

> +	/*
> +	 * If the filesystem is frozen or freezing, don't trigger transactions
> +	 * that would block close() indefinitely. Background block garbage
> +	 * collection will clean up these speculative preallocations once
> +	 * the filesystem thaws.
> +	 */
> +	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
> +		return 0;

Note that this is still racy as the freeze could come in right after
this check.  Basically what we'd need to fix this properly is a flag
to xfs_trans_alloc that uses sb_start_intwrite_trylock when set, and
returns a suitable error case in that case, which we'd then use to
unwind safely from release.

