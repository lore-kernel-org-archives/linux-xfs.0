Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EDE2E644
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 06:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723528880; cv=none; b=c2muvFiFjvdtVNfKc7rSiFfUwgLGFMhOexZ0fd1eC9LyE3LVRIW/AABa2NknsoOKcXb62DHZb+xOiGWs9TrUYolFLwAwVCf05B8v24pwJaIIgLYMikNlMhpnhli7zgGpX9bZ40r7yTGUNAXYvvVE6H4GyXwSDtrFn+AmkKUHp+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723528880; c=relaxed/simple;
	bh=b0mgEXRnLFIyUY7qmBj7bgjDF7Xj6V4Vn4NF6K7+/uM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QrPfbGi43/bLkuYbeCK//m+v6w39pLRHva1SyCTAMUAlZGa6YhvxNZz77IpYm3f1U9YRsK4vD7DLYeRN8wbvObyPt+OUFup1MO6q48Lv7vLIjvt7ExK0ijNj0MaXzhZQhsc6OTizMACYqJlT6f57dSm3DQdyLW42Tv/JCO48tPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4M+xS7u+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4M+xS7u+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b0mgEXRnLFIyUY7qmBj7bgjDF7Xj6V4Vn4NF6K7+/uM=; b=4M+xS7u+w67l+ySOa/15jgbAHl
	csKY3It0A4MhEh4KDEC0FfCyj2UDoP3YDBKEEGeMiyMW9yF2TVP7z5M4mVwCNKIIKSsjCdu5SfaJs
	UO+RsootXeX6BAa8DVX/QShiljxTsvKHvIqlMKcIUcyF1z6ZwWohwrP2Xcv9KHg6XspCF+Esc65Up
	fkLsSDlD8wJ4pjSZmH7mK5yCsV66FPmuGqfk501PcNsLHraWU7x2D6Lc69M95j3w4IO3ytqgor+Cc
	MxbRcBZDqsFs1/xFX2WV1rcrjzrjjqHz7CTJeEO0/7imGpqUWay17FdNmnwEEWZB0aPH+lUrPfmhW
	DqO1u1Uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdkas-00000002Vyg-3JnJ;
	Tue, 13 Aug 2024 06:01:18 +0000
Date: Mon, 12 Aug 2024 23:01:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: dirty buffers should be marked uptodate too
Message-ID: <Zrr2rvp3mXcnkcwS@infradead.org>
References: <20240812223836.GB6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812223836.GB6051@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 12, 2024 at 03:38:36PM -0700, Darrick J. Wong wrote:
> Hence change both buffer dirtying functions to set UPTODATE, since a
> dirty buffer is by definition at least as recent as whatever's on disk.

This also matches what the kernel does in xfs_trans_dirty_buf (
except that it weirdly spells the uptodate flag done..) and other
page / buffer caches:

Reviewed-by: Christoph Hellwig <hch@lst.de>

