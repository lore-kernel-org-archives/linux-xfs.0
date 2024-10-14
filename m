Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37074374D1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893249; cv=none; b=WDHvTj3bhzHgkSzNKoSCaSy92Ij+weznlJ45V4qSmRkgt2KOFroNfCXWsW/EEbr+Sw4KzBM91xs2DkpGSelacTikbMlJNBVuJj6avYvNh8jHzVx4bIU5wsmbANMkWq8E2ruANMUG5AXq9ZVOe7cIsn4lxYgve/bqg9fRXEeCqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893249; c=relaxed/simple;
	bh=VlCO2NyZu9H1ZR3fMLNnw29czQpeljYT+KZkFbzhSs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B22/91ZIGUaKXKsXfxuWx+4WbtzmDS7IOg3+OXfTDcaMIdPZpgC5vNZjB40XHvLTSd8/ndEOagU93F4I4IlCs/enzeujFSCiJf4yDnnHEAcabxjNTy+O9Z3cZ2Xxu1746rjOQcJMSa2Yc9wD1loGDFAvxDK1Nd8vc7wMS+PQO3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bWlBjbBJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bWlBjbBJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VFAd0B9chY5BMvzreU8rgWXihCcWyl+rkVUlKJESsw0=; b=bWlBjbBJy4LLwlFoTJGgo1lVGI
	bcVvXPjik80xUvo6X0w6aC92NHQ1OA64nMOvHormbq+aCDzc66TKVMuQ6xjhFQ0OLo13Zw3y9Ieui
	DQkNN8pcIPup1zFB8+c5HO+DqyJ5zBhYFaBQJ2wrK14rw73FHAeKGultgKITRrDqWe7mI43jPJZCc
	keTv/4AmaCUXEhRZmdWXDaqqIoVduFgjbZX84rSiJ6TUxgJpi+5/tN4WQwiQ5LNlN3lJJeFPgG/Go
	zyerEW/jk8ieQ2/8nIS2wCg5xz1eQn8LNsWgDSvTySqJtvzRFjjsKbnRbGxz5akd0a+GXwCuJP0Kd
	ovFG17SQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0G6v-00000004CVM-189W;
	Mon, 14 Oct 2024 08:07:25 +0000
Date: Mon, 14 Oct 2024 01:07:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 29/36] xfs: make xfs_rtblock_t a segmented address like
 xfs_fsblock_t
Message-ID: <ZwzRPVnjPoh-T3IK@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644741.4178701.14170094374963023360.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644741.4178701.14170094374963023360.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -	return rtbno << mp->m_blkbb_log;
> +	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
> +	uint64_t		start_bno = (xfs_rtblock_t)rgno * mp->m_rgblocks;

Overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
