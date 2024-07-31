Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D549627
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722455033; cv=none; b=mjpsWKDyc7cFV6VBegMIc4ATANJdobFo/rVW0IslcJPHQboh/k7HXdkTrYxJJDGFtksmfNcJXlmjqckkO+ESKoUSWNELQIpyNEJpUEapD2q6QJNaTaURJu2Aca+9O7XKtWum8lz/IbV1dWfxbYwJsZnUCPnrItKEkDO814JDvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722455033; c=relaxed/simple;
	bh=JNSZV+tTmWnzr7ZSmaMdiFGrXU3q1JIm0UvwsyMhfb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0I9S+aRhhc+ugrgKl+Ow+r5iu2UKrOx400/blhvuqnkkIdBqqxFe8itIx2Gg6JjvMShhJP6Ya0A3MsYoJswk+Phsl90wwh5sqtfSpqfLmPA+ecp72HKRGDNuyqTRSB+2uCQedRlezjk68mKvtfe4jTQ9XR5zFAPCMt9ZO3Qf0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BePamlAJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BePamlAJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P9gDS5GTZ7CdVZh+jd4x6OwtKjb0JjHzTYmYRStNC2M=; b=BePamlAJg5NqIkFLIVl7hm8InF
	8cM7v+qRVWNeqDd6JSg3Gyk/Lm2g/YyLRXMXGMZfub8yMbf63nCGn+NWYn/e2wHuvQQm8xcql+T0T
	vHraRBtI1Dz2dMo1MRqUFE5OawGIiszm3TOgtvcwFgMzrOMSNDAY69QJc3Dxr0Wo2Ml7X8yI2cFU5
	sMP4LgUh9pQbipU18i/bybThem9xZgkYRbjPtcH+B3/MwhtgiLzcH8qCchZVUzKgHhYBv0sszjMCv
	25N0jqHUz00Y3kKLS5xu2aCU7U0mBTn9+LevBHuXqKKwcXy3lE8Dm3ZR4S599ukzvkvln2iXVdJgB
	3LeYq7EQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZFEl-00000002Kp4-2Wq2;
	Wed, 31 Jul 2024 19:43:51 +0000
Date: Wed, 31 Jul 2024 12:43:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libfrog: define a self_healing filesystem property
Message-ID: <ZqqT9wGQzrAkpS5_@infradead.org>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
 <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
 <ZqlhopUMJNAyxuSw@infradead.org>
 <20240730235103.GM6352@frogsfrogsfrogs>
 <Zqpbl9cc_nM60I1A@infradead.org>
 <20240731174531.GJ6374@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731174531.GJ6374@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 31, 2024 at 10:45:31AM -0700, Darrick J. Wong wrote:
> Better just to have one attribute and make them pick the one they want.
> 
> How about auto_fsck={none,check,optimize,repair} ?

Sounds good.

