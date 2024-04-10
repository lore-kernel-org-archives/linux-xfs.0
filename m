Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C3C26AC7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 07:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712733699; cv=none; b=RvEoPtN1Zn/5EwzkemlQ5NswRvI5V1B6bRbybOiWvF0SG2Nob91FAprTObyOmLA6gQmAvgx94NkCj4dbxsT7afsaZqSQOMvly/4pXX3QsRN9L32sy0iKCKIZdZtzqTH+F37nVNzMP1amCcdB8DPpB79ZVqUgb0I1nFH2qFumT8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712733699; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oC5ImzlXufYb2RLtBjUFG5k8+XYcEpFTn6/MAPFS/6yGoCtzCTL5MdLhfOFXfpLvas70gIlXPtwxN73OMLQq76AOQF/O7loSmxuKOh+dMFZl8Ex1AtJNgdvCAUMN/jwK4jwt0K8CKF2LJ2cCe42uMeNklema2Zxc5+goICQOe2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CF6lOdR9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CF6lOdR9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CF6lOdR96PnI3oFgVxXS1BPqci
	DFPGuvUQpLhCopTOJlv+175pNed0EALWcNzqUpv1oEGtug5ecS4sKp1709vhqrnYHxQet0CDFXisF
	XC/VfZb+8lnYcqKaE6f0Ze9yi9e3dIEFG5GN3tQLibxN+GBOSyE6NZfbhvEnIixDGx2r5lYIK+9Ku
	HeDiko8FBvUkYRzN/m7zSUYcBZmOqKIQwt2U/69T5yLr9tuZ21/lZu5QSnUOpW1gn+95wN9FHiReW
	GJ9qMkcqcMD3IehK4xA847Dxkt/mpcrlr8r9EDU+AjpMqK77etYynZZO3etJb6g0YKC25CI1cQ0Zb
	NdX8g/2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruSH3-00000005ac9-3ipp;
	Wed, 10 Apr 2024 07:21:37 +0000
Date: Wed, 10 Apr 2024 00:21:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: teach online scrub to find directory tree
 structure problems
Message-ID: <ZhY-ASeJt7KSOkKe@infradead.org>
References: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
 <171270971606.3633329.15313164484455302292.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971606.3633329.15313164484455302292.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

