Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180012BD015
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 06:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770013524; cv=none; b=d90MFrriMm/t/R/znTQIyBgX4A+VtMMwfjEIv4SxAYz5XSO9DRqJ4o0v6z9EtKUhbOwp8wIrgoRjYq9yLcsDtQP+HMCAHFnnfr2dDrbouyp8ueO+StWYzLlf0Ox7sS1yN2O2086icCnbZq3FQCstYeQoBiE1HtyoPM3zg6LhB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770013524; c=relaxed/simple;
	bh=Y68wovBysM/ximJqeczz4eS49yY2LbFFvceZbAAOOYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1IY1vi6gRtg8rvCDHUdnaZHBQTMF4nYgQXjnvy/bTA3GXj3zNAyGtlHefwPc0b1R9yapuNaTpw0+FlygM0kKFoXA06EG7E6pDxtCOgBGUacJjqjxLWg5zfPk48l18HsxQa1YNdvG9qPGXMIn5KqXUkQq5ryhFB9+kV5RGHWjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mYBp3ytH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mYBp3ytH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y68wovBysM/ximJqeczz4eS49yY2LbFFvceZbAAOOYc=; b=mYBp3ytHLkdlxkx1GGk+Wr8ax+
	owTBbSzNgoyh+oYoOELSFep12tXpV5W1g68NAGNb+uKFTf/iO3Z2VlOy/MVv1ZSWWo9UO/9AqNHUk
	xhHu7bRR/c06CjTRsUgU3q4xqx9wnCvMIUFmd+EcCfZLloT6izO7gs59oz0dZsXXd67ZjjwPWyl5B
	sW90PVEusi/0z++vulfZfNDHzexlPi/iEGXCrOlwW6RqY8d1Jo+NNHpQhtp5blzyrqgtGvr4pGMdX
	WJn+0oeDQaCz6EcdYHgVRud8Gm8NGDu0Iuein85zM/jGEWSZdO2lkNhNrwXe0smRfN/OtTgfITipQ
	G1rDICFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmnNB-00000004VNj-3oB4;
	Mon, 02 Feb 2026 06:25:21 +0000
Date: Sun, 1 Feb 2026 22:25:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hch@infradead.org
Subject: Re: [PATCH v1 2/2] xfs: Fix in xfs_rtalloc_query_range()
Message-ID: <aYBDUUGjK213oZBi@infradead.org>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <43e717d7864a2662c067d8013e462209c7b2952a.1769613182.git.nirjhar.roy.lists@gmail.com>
 <20260128171443.GL5966@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128171443.GL5966@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 28, 2026 at 09:14:43AM -0800, Darrick J. Wong wrote:
> # mkfs.xfs -m metadir=1 -r rtdev=/dev/sdb /dev/sda -r rgsize=65536b,size=131073b -f
> # mount /dev/sda /mnt -o rtdev=/dev/sdb
> # xfs_scrub -dTvn /mnt

Can we get this wired up in xfstests?

