Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899AF17721;
	Fri, 26 Jan 2024 13:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276179; cv=none; b=fk0s7XcChZs8gZ9oKHRijDyYTmL2cBy/+RbLDZbm14Y7Nl80CJsGJqfYn5B5bv8DkF1d1fih9E4d9ZKPGduWHcbXT2hiq7P32iAHgRdoo7uaayD7f5UAlW9vP8vM1oi14vZJxRWdXbxCgx+78sQgNVayQtow44nVdUWnBCEaomI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276179; c=relaxed/simple;
	bh=rJ7qx5hooZYLmd5CxxD+HrO6rv3ur6R7maRyNTJGUg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nv4CaVNEGdlPMzCyh+DmFY7xg9xx6/bZGDEa0cvCKJf9HBzzYjKV3T+ZnpXUmJstqD2yfz2+COWbOvNo7dNz5uAyVIo10rGPTNng7/soK/BWmdEclKSY5azZlUY2satdVY1oUjN22qDyRmJ4ftCLUeqdNE/ZGAFkpYWwzMsly8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OUsUBYbI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OUsUBYbI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rJ7qx5hooZYLmd5CxxD+HrO6rv3ur6R7maRyNTJGUg4=; b=OUsUBYbIqaj2RFkFmnUA9v/R9H
	IOth5vVbizpfRNvcgz2sXPV9zckS/L1voMM2KN4DPRqnbkFB3JvArmj41hb8xzDy2/UU5WHGB6rHg
	wq3pzYfjP8MYj4hvk0EEFl0JT0hjs9FbsDV11qeP86paMu+WoQM5YM7/8ymmJvhc6fjA8r6fQtbOD
	5o74+nERFqCRBETn9MYosAmn0Lk66+HqYKOOXU3nLgEZbon9P/HVASD2nvKsA4rM9+nmPrd0Hmj/g
	iL7gpWBLjcvtlz6tG2EyP8fSM6SVn8K2x5sgib9cLqOQ/Z0V4rNzkqUTBKHEFNC6gTIJ4rg2P6fTj
	Aqvq82BA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMNV-00000004Dvu-2afJ;
	Fri, 26 Jan 2024 13:36:17 +0000
Date: Fri, 26 Jan 2024 05:36:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs/503: split copy and metadump into two tests
Message-ID: <ZbO1Ue1hYr7d-o0R@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924478.3283496.11965906815443674241.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924478.3283496.11965906815443674241.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +++ b/tests/xfs/1876

What's it with these weird high test numbers?


Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
