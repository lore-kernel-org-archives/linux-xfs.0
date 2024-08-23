Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E34D8B8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390201; cv=none; b=kEoNHuIMK3OMULzRSS4vp9DFkmPFRzVzaGP83agVtLqy2IVNTxTMIopvz1+NvnXDm7cPBNnqtCAidViDRJPyodcLIJ5hDStCMUH9oXcufe1fok/+wieNeuSGq7OLTMkYtjErDe9ixo2WyZ/qNMGV2gv1/t1EmNpzD5KDmYt/Z78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390201; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLxD/qu4dMLOEsDGUhtQNb6MND30i5A/mLdgrjAlVVSY8Spu3Dpzw8J3w26g0KccNOHRWzyti/k2zo50zle+p0WZ9LSLXZoCJ4yDWpxB8EWLjITVqhpGdXhANOUWscJOXXJDRtcbWVn+TYDjGUYCTMsNh9kTMNtwlmVolzNkNTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EuhAtc/E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EuhAtc/E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EuhAtc/EYmfgz7is3fzfExm1f1
	bMFvnE7j6Dhyl/NhFb9scRDwMNzb0CYmTuOLvbV6PS+c1Z5qQBFJ7AeWu1TvjPhWuJLThgxDy/gks
	hJaAUKhR3N8cnSI5jnoDqaL8OcMMIGDfLhCoEmyQFO2goFKYKDWjckDV2DIXB+pp88kjxpaEBq2FP
	FqFgDC2sFkuzmDWeWWYoBjopoVDI2Z/zj/sNfDtF/EGHf8//owPYhNxj2FD/DePRWN1rSqb6blUMr
	8BkZbSc/2e1/8yDztj7IZGwedL66ZEPRPSjY+3SH99U28dRB2Ac85BF9nM3jkyTfnrnQDg2Adji7H
	VtIUO3Mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMfA-0000000FHWV-0ZLJ;
	Fri, 23 Aug 2024 05:16:40 +0000
Date: Thu, 22 Aug 2024 22:16:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/26] xfs: store rtgroup information with a bmap intent
Message-ID: <ZsgbOGtB4AjQzLwM@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088782.60592.3733953729473737601.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088782.60592.3733953729473737601.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

