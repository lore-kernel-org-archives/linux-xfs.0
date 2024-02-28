Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B48D146015
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135967; cv=none; b=UaaDm5ObY2EBA2WCWsV/E9/LePIbibwMCeioGvUY8rwFAB27Qvj/5sv9tFjUz8mrxelFZnt2vZfdgs9FsNJhYtWdehbinimPzkaq2GOkZu1F3XOqLZt94TGvFAZ/lIvQvyeFzIeYBMwSDFR8TE5tVkSYINxzRLhmDox3L1cAcTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135967; c=relaxed/simple;
	bh=6gaYMITeLdJ7SPppifoODrG27h29SwzavwvNjTjm49w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDKMmftTrdp7jtB/rTxfn2OYuzrOf3ssMc1rKgTUwnOI29Bghxnvs3f9NtBBFlWxWREPCdkyOrRcyFUlYZ01ju8sdGLN0ewRDPrmO4oujuSgjG6QiD8X75WJTADs2vB/APjWCBYVerot78mLDP1qajpaz4jbEii+6A/0/udDS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fryk+JnB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fryk+JnB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gwwyeAITqV4EwoX4PgUXQBikov722mpL77dutxRd4xY=; b=Fryk+JnBDrc9T6vIP0ubrWjGJ/
	GTUDhByp6pOqkG/cxjX/0RhhadCKDCDShca2iUnHrpIp03tu7zw2U1iCqFYaoqnonJjaQX90CNqH9
	HExcpPb8JOJ5DFybxZV3NeLjbtXECU8qTEJlGMLLln2iHNefjtNUDRzkOM5Zud+ssSP9m4XRq2mQP
	q+zAfZq9L2km90ldW+m4CqJ5VYbNURudJADgiPSVYraJV0WW41ZZ5F216YVrrwiKRDf08VdKsWOzc
	8ZNnKt/tCd/9qEBZagc4Vkt7HiSfRfKzV0KPzZpBS8lqhQ1BxhJSn55iFH3+TBcAsbSeADW74+b+y
	jh6zWzzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfML8-0000000A0Qk-0NjK;
	Wed, 28 Feb 2024 15:59:26 +0000
Date: Wed, 28 Feb 2024 07:59:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 8/9] xfs: validate explicit directory block buffer owners
Message-ID: <Zd9YXv8bdaw0EcUE@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013227.938940.2647775527419976410.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013227.938940.2647775527419976410.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  /* xfs_dir2_block.c */
>  extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -			       struct xfs_buf **bpp);
> +			       xfs_ino_t owner, struct xfs_buf **bpp);

Might be worth to drop the extern while you're at it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
