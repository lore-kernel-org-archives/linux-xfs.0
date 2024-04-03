Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8626F374CF
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712119384; cv=none; b=RkeTWwF/Kt6SEpFdDU7WgzU6UXrs9yGmx3uC+Cyp0uRXdAefTKx8gw9NYisqAKL4SmRNUOCzm2Mz3gXjO4KrJ9rgVRwoeY4hamaYPz+HUfeM4Upl+foD+G9n54DpqDty6qEzcthaL/jWT/jDQMjdcXU0tLYclZkQfqBMfaHEdO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712119384; c=relaxed/simple;
	bh=6UuxiG+fSKsZNWNd8xUoQxxqpljoLDsibGjkKElTZ98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJEP4GZrQFC6Vec7yuOASV0gDgG3fOF3NitUNtr1JhDD4vzk1k5Iv1JRVTTOZX7Vr/PD1eQ00j087BX6W8M+QgDIaIiFrwC71RP6MA90Mk/N9OpxSL3+SZsnkplUxNgi6YXHqn/KkNuJHMsLRGzXY02VAgkXPJqAA7tWVEoNn8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1QhnUj8B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1QhnUj8B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=leDENevaU7sSp3Dg02D0BTTGja+8vHdHAwPMxxVN8gE=; b=1QhnUj8Bxaf4T0bojquOKxdnzn
	bjpwtNnaWyttHul4X/olByNzWsNpXGGFudn75BIdW/uwF19IhfjVEZvr/SXmDk9dz6Zs70sxaAyCw
	eLfvNB1K3FLgbn6blV+RQsLluiFSeTCe9MMn0E3hbTgyGH7a4J6NTyLXhIGy05CkBfvGMIuQKSkmm
	QwsQIP/rgEI1pvkGJ2jKSSO6KyHid6yX5sHxWuJpgdxwEK/qIYTseCWyFOin2oNBr1eeJYXQEm9ql
	w3VUQvfZ/Slk2GEao+nnG7c9zNicSw2WjIGK++E1Uc1P0Ag6BTmOZ/1nMM4FHtMFNGiuH8eL73zTs
	r0gKhwPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsSl-0000000Dz8K-0a9F;
	Wed, 03 Apr 2024 04:43:03 +0000
Date: Tue, 2 Apr 2024 21:43:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 4/4] xfs: validate block count for XFS_IOC_SET_RESBLKS
Message-ID: <ZgzeV2KDFz4AYS-0@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 08:38:19AM +1100, Dave Chinner wrote:
> Stop the fuzzers ifrom being able to do this by validating that the

s/ifrom/from/

> +		if (fsop.resblks >= mp->m_sb.sb_dblocks)

Even all of dblocks seems too much.  A quarter of all blocks still feels
very generous.

