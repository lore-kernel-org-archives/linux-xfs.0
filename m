Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19534A21
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734069930; cv=none; b=B3hPMClPR1Cw/PlGJzgO2KJWIGpe3jBQzVgDH3GhNfoq6sSPmlDebBnKEQmYTZsdvY00MpX8J96szRYSOg2J2y74fk6ZJZgtGK92WGqqGtQDEfXHQgkJG8bIARv+1uc6aA35FjTbdzwUn861+XxlLF/nsOJu4D/TTmCllYZmIdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734069930; c=relaxed/simple;
	bh=wuTNNqCO045hPjEBf+iJ64A64WjWjtU1PMO7bxzm/Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqX+zonhLLkavTm+zb65bsJGEGeXayV+wiDFZqe4t/0MKwho8qrlR6eLc8SbLrVnWiSP0RObKecjHc0er8rHqZFWxzybE0avp5IH8dCckq6pq+OHpTQtN6YQ/aGxN+phf+eOwndrjksmbCwfBfE2moUEXjdmVapTG36HIbOpp4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2FfFquCx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2FfFquCx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BJTrsHf2NRqszuAYSJfLOBYWYZ52hUFRyM6x7hdosSE=; b=2FfFquCxTsQStrvtX4ActlrXkg
	SnnRYM04Te8CM1daED0oO0olvNn27ih1bHz6Po1fEk0IpqEAUo0k1L/DbcHncQDb8WhXa5s6QmvTQ
	GazhfiRP90Zk5uj9D/wjkTBvjhVbWX+Ge7YNABPSB2xQ4I2uRgumz2pcsS72R3OnY+qkC+QO+1Pax
	mM5mKkNegAz/cJeWfc46c0JO4uiTrdZTNb6BDYsR4lvTohBXTv16Lrf9ZvD2TnX6nl3eJ6lxoVLNZ
	Be3+CULGek1868i3Fonrfb33W5E+D8KgIgIspqtbiBr+O0uPHecr99SO6BSYYCbOAz1pFcfQFPE8Q
	w5v4DIqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyno-00000002pen-0hdj;
	Fri, 13 Dec 2024 06:05:28 +0000
Date: Thu, 12 Dec 2024 22:05:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: refactor the inode fork memory allocation
 functions
Message-ID: <Z1vOqMD-yROh6gY1@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122193.1180922.17980274180527028926.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122193.1180922.17980274180527028926.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 04:58:30PM -0800, Darrick J. Wong wrote:
> -	ifp->if_broot = kmalloc(size,
> -				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> -	ASSERT(ifp->if_broot != NULL);
> +	broot = xfs_broot_alloc(ifp, size);
> +	ASSERT(broot != NULL);

Maybe use the chance to drop this somewhat silly assert?  If a NOFAIL
allocation fails we're in deep trouble, and the NULL pointer dereference
a bit below will catch it anyway.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

