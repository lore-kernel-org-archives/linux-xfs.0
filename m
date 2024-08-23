Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C868493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389998; cv=none; b=UjDsK3FJTMfiAtxaZXql4TYaTmnBKunX5n78Cc39tVRPn9ulNHMmkzgA1BRj4UQdqZ8iq/7yJsDjSg445/IWUIKArXzeEuRWfGL/p9B16f3HHd5+F0NVpUDmPyz6X1ZTBXwTd/qgDQozLSytCTNMLhlnXK4PfZ4pSblxdG+zoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389998; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+vZYkdMPggvtZDb+SwDSTCQbzZx5kBLPG3lZu2ZmYn/fzxa0W8TvfS4fdZlWhzosPWCE72eATbkiyQFZs4vwYUlUCvctIXCbb6157LeEtuZh0iWn3KwLW28Gi2M+IP+XYJgAwxgZrj1X2obxtPnK+/4HWEBul+F2xoi3wAxgYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2+M47WfZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2+M47WfZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2+M47WfZlbTD8T815K7wM3GOV+
	QvH9BASpS0ex5U46UWu0gKjVJMqPAHvbJZ8zaYyU50cdV9ayktRj4j/5krrMkLx4WMqVnWtOJMJe1
	f4yoJDr4Gvh740vbL1UgBQnXfWUHFxBK0FGPbmxEK4jLRTOEK/uVcURQRFWoihPVsD1GHP8LyYDQw
	xfpeDltZWytdzghYbQymEtj8RXIe/VkpYJM9X0v9YXuc5mi9s3LnrLfAajBDxoCz52jfoDaNIX/Ji
	ddEG2f+Mi8ylasISYbmezvj89VSbT9kDD9SmSm0oO2ZsuXvBPXI7p2nXe+HiJZHDQrnnk8T0qln+6
	Qi2uG2Nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMbs-0000000FGyD-2RHO;
	Fri, 23 Aug 2024 05:13:16 +0000
Date: Thu, 22 Aug 2024 22:13:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: check that rtblock extents do not break
 rtsupers or rtgroups
Message-ID: <ZsgabFs2t5Q02Fxx@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088605.60592.17624348368832345999.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088605.60592.17624348368832345999.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

