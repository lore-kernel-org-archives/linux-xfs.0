Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B793612EBEA
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 06:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402893; cv=none; b=ZFH4w/e3bKFwABc+x7ICVJrY76imk0vSRxjXDPlau1J3pk+pW1epvEjWaDRBYS1Jg7Lbfuw/gHC17BGmIBUTIqEFA3Ma2BVkDuUP4cEpt0TmnuuELFxGtv34YaPNmHfbW7wAhkfDS5rp192JWtkddgt/PhqwccIAfbuz+TIHFzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402893; c=relaxed/simple;
	bh=h0EC6Go7fkJ8JvuENNVvXj8pFnhryZUG72okbiGFKC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/K5NBIYeGY90tRnLlFgBaOWpOrPXADPyApP/ZWgeuVGvbKGWQ0DCpbhbIoKaKiq748S9KpT0u5E9GgFc5ORVHHhydbeabgu12MFfAzA2sIBxyhirxCYH0T9oO+AJEwJaFoAZngLbn4BEkCKTlgenH7D1TCdSciyuQT/BsOyMcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bHHnleFy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bHHnleFy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lhzf6PMjDfd/IzcXuFgr5HVmrmuHx/j+bWi1ONU2150=; b=bHHnleFy2BFA7DYjgQDLnB8R0u
	1QCivkZuwBx+qOfuRxFTGUubEkFLKOUEK9i3NPr/M4Um7osDgJbW+Uj97uFMq8T2EFAv1dgbF91cB
	U9jOBadi5ArccKeskDBNzworQpg5w1LzevnaQqBQD+Ll571O0pF3F/IE6qpfv0JxsEcXmgmw3Zoe5
	evVHlhv+3iTbNNzqpXVQYMDKV5rUM3KrZCGLHEGjZUud1bLvHLDA0qKQZzQEuM/4AOa0bK1Jdkq0/
	+MQtLFX/snM6vIG/IU8p7k1sMaIl7JKjYocS8JvauGgWBbk4wZEAyoSPgYyeBSxIE/OL5pdvhc4C9
	pgSLzF0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVli9-0000000AtT1-14pN;
	Thu, 09 Jan 2025 06:08:05 +0000
Date: Wed, 8 Jan 2025 22:08:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-ID: <Z39nxRk8AdTR3BCR@infradead.org>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109005402.GH1387004@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 08, 2025 at 04:54:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We have to lock the buffer before we can delete the dquot log item from
> the buffer's log item list.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I did look a bit over how the inode items handles the equivalent
functionality, and AFAICS there is no direct one.  xfs_qm_dquot_isolate
is for shrinking the dquot LRU, which is handled through the VFS
for inodes.  xfs_qm_dqpurge tries to write back dirty dquots, which
I thought is dead code as all dirty dquots should have log
items and thus be handled through the log and AIL, but it seems like
xfs_qm_quotacheck_dqadjust dirties dquots without logging them.
So we'll need that for now, but I wonder if we should convert this
last bit of meatada to also go through our normal log mechanism
eventually?

