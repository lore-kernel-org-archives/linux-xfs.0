Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC84136338;
	Wed,  4 Dec 2024 08:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300726; cv=none; b=q8KBa7Zciu/ZOQANbvT59thVdaueAhmrVmSQ6Ug7l0eEpy1WI40Od8NHix9DMcGklx6OuVNT7h7iJqSZPHls4e+dKc5slB3Rr1KKZcyPhBpSy1FR+not5EoQ4P0pmbM3qRKTO60FoalTN7pQL7vnCz3mVd+krwYofoASb4eZEzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300726; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpCZuFIb+/GRUuzEicTVPQoTwjIU6n0Eu7VSbrILByq3aZNZdvEvmByFk/9YW0kqW46X4mIyYjAXNO0Yx3YDSAB49671X1J72t4S0vYu+2klvhbpta1t6QSotDRXUfRiyjIWkuteMWq7dzGQdTcTSBNrgL1NJHfrNLbcl9haJbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1pl3gsXV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1pl3gsXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1pl3gsXV0pGNuXyOlBI7H3pRLH
	fDDK5CXW8KlGsY/QF/AOLKZDwarc5/nitVGxLbMbTPrsxBc1JtXcBlgEtckwpa+jCudJK5WPlCAtc
	o/aPYYZPPhkmZNlHzu7KNjgPz24SA+bsAY63PwooPhoFZoTnlTZxwFBFR6pHPVK3FfmaClqmdEuR8
	+2yzo8MiIXcS4qWB6+UJ9beAojoMaJPjrI4o2asMkrkoSKxBRWGloG86LdKQjG37ZOHrc+7YEAXUt
	ILsTMzgfuwQLOPWutxSkTJ/4qHcjJ2vAdMRWEf3U6AK/gsdVdFWvA1YgJ13oFNKGW43vRqYVNj+re
	+LZFZmVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIkhH-0000000BsP9-0D2q;
	Wed, 04 Dec 2024 08:25:23 +0000
Date: Wed, 4 Dec 2024 00:25:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 3/6] xfs: check pre-metadir fields correctly
Message-ID: <Z1AR8zZvJgvrsSXZ@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106635.1145623.13324476061274052225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106635.1145623.13324476061274052225.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

