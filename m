Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B303A17721;
	Fri, 26 Jan 2024 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276266; cv=none; b=qldQeN//IpZnuW7tyLql/yJzqAUC9VHPr+O3TObpiA0yBguIxjySwVxszOBALI6KbDAUOxbOiWZHJ7IXe3v1bnBFoSLIfIVWeiIc6yRe742XmenRwQvp0NLIZDk4qh8dHdRj3BpyopBTkppfahyckQ10v0KgUQ7VSL405nNJXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276266; c=relaxed/simple;
	bh=T/k4o1Hub3MsL1LDgA3vrxfaiG0a2BqPv28v7QiK1Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jh3R/gAZELBxUysDr/2LO1IHU6z8LduQiEYLAiGz+k0m6PH+iIuv7TBj3xQRaQ/SthMvlxpKfpPoT5oXq5+zK4iulpZAdooL1s0UonAFmPvP9Y2LZdrr9NqkuybjqYCHSdkqyGMpK3fbwSOYPXuHPjP+u+EUBvnlpdjPwbGww1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y2pcthfz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y2pcthfz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ktZS6mPga3FjtLgvVgEDxYeJH+iUzNHI+ufWdyq3LFU=; b=y2pcthfzi4UVfTsLxxcne723OC
	OiBTAu1oDYrfWIzErmljjb0krrK3sKdwIBdLd83iG7ZdgGn8HT6UksQ39lmBPE+mSInXv3/dwLXsG
	OwpTXfX0yFDFFEcbqNu4cYLEKHYSfz36zChxJGapKs5eAjvFLlXr8RWUw1rE0t9MKitky00347wQS
	6C75JazMj4XSN6FFoZE+RnEl6tBP2+1BMnxB+akTbcQdYzM01IIUXcCrn+h+zWkvizU2rLnFscXXw
	P+ojnwSJ7x4K8gSxzgsB0vsFudPBmu6dAkLxf7okq+w4dmmJPJ+r7Sue1Jlqgih7emhzPWseDhgV8
	GJypqk5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMOu-00000004E1Z-1pQ1;
	Fri, 26 Jan 2024 13:37:44 +0000
Date: Fri, 26 Jan 2024 05:37:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs/122: fix for xfs_attr_shortform removal in 6.8
Message-ID: <ZbO1qL2Z37NFDaf0@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924507.3283496.17636943697618850238.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924507.3283496.17636943697618850238.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 25, 2024 at 11:06:35AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xfs_attr_shortform struct (with multiple flexarrays) was removed in
> 6.8.  Check the two surviving structures (the attr sf header and entry)
> instead.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although we really need to just kill this test.  Let me resubmit my
series to do the checking in libxfs using the newly shared kernel code.

