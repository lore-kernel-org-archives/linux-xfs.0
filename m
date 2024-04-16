Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209518468
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245166; cv=none; b=ctlid2m9e3AZ3dnRvhKguSfBzQZyI+uujEP4uL+6laEpTLqD+vytZ4MK/XSWixG+lkphpvP92TMwtxEkIFw7VNpyI6qufPEI707IdYin/Y2Q1qjA2wOya9mSZPPVIqi7JzlFb7lvVCp7gbzDUkabwmjAel30b9D6+QZeEyndKG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245166; c=relaxed/simple;
	bh=tOb17qqrTCefCWjOWkidUy30Un80niIUyi7qUbgjZAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCGcsnNYLo8maT1KvfZl463hlPFh53CT2VpeK/YQEaaURVSouYryUoIHMoHGzgqmw68X3d87bQmf0yFAeSGsORBfoWnCvKYnfHzl4bsZta3rAI9BJjA61zA1rXF2PgF3Y9m3z+FoyZZojGuWF7+EU6PAbWS0gvd/7RYOnuowI/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VRBqLnEg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VRBqLnEg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=krEtIe79RLz0BKqLskuVqRRIGbMT/HrdX5jXkK1C+c8=; b=VRBqLnEgMtGYDIrKVpHUq6/Y4F
	kp+adERMiMuCRr2TdY0RLStPz+MxAXfWzJtUZu90na+36RSTbhYxXeWuWHrDaf/zHMLbTGMWNrhi7
	xCszY+tIAYN0MoG3W6rfxRKWsU9cu46/CtANXUq6XWT9mHCIbmxY0teEswBoBtxFnDR7b/uKj7geE
	CYEVJyANoyQm4MQvib9DJucr7ptqwiepCWkv6x9GS9vBiArWVSjKszOpTB6jSW9/cQKm0vkU66oyr
	NxGsurhfko/Xmz7/oh8xTtI8NwSw9lyJ6s9Z6JTxTJJ0A+zGNS5EBSxOjbAQ2TA5XOEYl+lO4Fu8f
	pPO9pQJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbKW-0000000Avz7-1iYO;
	Tue, 16 Apr 2024 05:26:04 +0000
Date: Mon, 15 Apr 2024 22:26:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/17] xfs: remove some boilerplate from xfs_attr_set
Message-ID: <Zh4L7GHePxopGrNy@infradead.org>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029202.253068.8909364981150861497.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323029202.253068.8909364981150861497.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 06:36:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In preparation for online/offline repair wanting to use xfs_attr_set,
> move some of the boilerplate out of this function into the callers.
> Repair can initialize the da_args completely, and the userspace flag
> handling/twisting goes away once we move it to xfs_attr_change.

Not a huge fan of moving more into the weird attr_change wrapper
that feels entirely misnamed and out of place.  But if this gets us
moving on the parent pointers it looks good enough:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'll probably do a pass on the higher level attr API at some point
anyway to sort much of this out.
