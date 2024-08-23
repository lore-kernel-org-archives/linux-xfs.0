Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B3D376E0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389118; cv=none; b=VdCkDQIg2gGZDbOPaC3OgJevh+xr6TvzWYHTBd2cx063tB3UKb/JMxBGYjeVCaq9JYv3bq7+6cYihspNmKdnb3s4iVf6SlKSeXwOF8jJPHZNOlsOY+wC6yqVMe2P9HHAp3d9QPzZ9GDEleG+kIBfiDqLuZ2Hjn6KKrDNwCIl4wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389118; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmvBmFuBCxGRvBmc5rXR+tEq9kM0iC6hHOzWXSa/wMjtBFjQcmBcFgzO9z+prG8XZMS7NNpdd5T5gf9ed4xgvT5SAEYYxLWMsPJ5dElt40cRnUoWcVYFcUnrkCbKUc+IvQYsm7QuYj0qkz8lLilfBSkwHwVArEWBAvn7Ao/KW/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=14NCzVRm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="14NCzVRm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=14NCzVRmYrXqL7LCHgPa+dh9to
	Cps6Lpx2YM5TsWJRcvcl5r0pG4YDarShYwcNghpPFlLs3p2WUxAiU1z3+peqej2wtp76qNfbYOk5p
	MNnyyKyIIhJ1CwHqnFYAQmeKdc8CXkJ+ZOBIpwbZBp+WqNE2BMtvEhuXgE+w+11GrQhXTmD+pF39h
	b0cCPcEHjnmhGDhpW2YXloc3s1/WiTP9MKvl/5uCDcAxGPQiP8CCwSyJQy0mYwKP7evmWjpLolmfI
	7oKfF4Z/O87ivPFwRUt7GZs3OuyF2DPw83p7j4/TLJmUaYYCVgnQFOvOgfvRZDEGHtsPe1N1KIAn7
	Do+ixaWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMNg-0000000FF2o-2vYR;
	Fri, 23 Aug 2024 04:58:36 +0000
Date: Thu, 22 Aug 2024 21:58:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: clean up xfs_rtallocate_extent_exact a bit
Message-ID: <ZsgW_H5oQrCx4Evr@infradead.org>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
 <172437086720.59070.4961232634716192853.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437086720.59070.4961232634716192853.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
