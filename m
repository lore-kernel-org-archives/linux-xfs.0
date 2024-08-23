Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503363FBA5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389284; cv=none; b=OBHDS5f0Ri8bmNNujjEgk/tl0GFpj1w5jBW3ZgdMXOmyjr7inIK+mLMHrFkeYxYdflnK/DXQVhN1RtdCitlylT3IioH5NUUGZqLDAr1RFTzybElnnW2bYaFmYh3SqhZab0QcUoaGaQMcklvL6InD8qrkN36JKnA1IKn4XoC7GWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389284; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqq74kTOwiS7dkbko5htTr4iPK6DgK22HhXWiEcNIqndfF6rclKka0Tke6IFeTA+prHr5A9SCze6R+POJ12jiBI4CnyVFtAkukGTmjtZXRI34FJEcq6YikMbN9bEfTLMJusp5eu4VWrrdmW7LksS8iekHOmMQ0U3f0DJ6J8GFMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pUsQsBBd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pUsQsBBd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pUsQsBBd6MKezmOA9a4uQrirk2
	NWf425pboTzzgj9FpgBFTysezpK/n6juEsTwte+t7a5LrsCJ9WGKHlUeuHca14fO9lp9Nh7Hymkd+
	ICtzAlsNJhksa4BMPIZEa+doQBRGd4W7DsHkxp2qIisX5De1y3gsxkl1rlSyPy+bMmGy1cHAgdZY7
	sV9jO0yjUBHR689sOxlYqe7ed6qclS3eC7Cqoos6myd+0w5geeC9l+BNTzqNS2w34VsDlBdJSJzur
	0zkMzebPMWRREhZsOyn6oiIPj2x5NMvpaDCdJD7RzuNI110QM1y6VR6F0e+Jn+A6NbUQSQILhs5iV
	0j6GUJoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMQM-0000000FFIp-3Qy1;
	Fri, 23 Aug 2024 05:01:22 +0000
Date: Thu, 22 Aug 2024 22:01:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/24] xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c
Message-ID: <ZsgXoih3MUjbIGJi@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087416.59588.14421297568216399851.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087416.59588.14421297568216399851.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
