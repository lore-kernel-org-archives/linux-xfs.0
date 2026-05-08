Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5897E2571C7
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230616; cv=none; b=pnU9mCS4M4xHiVf1F8zMLGpJi7f6dhSkr8DxmQy6kYLJ2gBn5JVosOQk6e+oMS230LSFVcLNX5uaLCUczkpCgzomO0nUmWRF2bPQcwP7fG2zWM3ulJJpB9wHNkbM5DBfsHLPE9SSzu6HQK9buJvdtJXirOIH3jnK1MoPhRjW5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230616; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWjVg0bMUV2fixndhXvYe1QBMQeGxFueDrRUqtul5PDiMxp1d3YHlM2RHSzJPyem5hACJNHRg50uuBa5QyusLRgz23Wvnxl0daPFi5TgV0AMYFkDih4B/hrplCBhRo8RuhpVz8tM++zsqPurHwMOS99ov97Zch/6UHhLJjOvqSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vS1cMkRw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vS1cMkRw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vS1cMkRwGAVqpx3hWZgRm+30PK
	L+7wlkE9pwliBh1rflZOauiOp2YXVxTUwgGOCuSimnDU68MZsW0MxHDAIJH3Zk1E2cP+CfVYqF0jC
	VOkY7F+ADE4Wx0/gNvFxrAw0syGQEntA6etJuHGXVhIxYmRLbm1fIMj1nA0e5MJQLzO+q7OQyD1be
	xYuKouBrUz4rNtkESZOzskMhuD0akgV6A6cIM9wUiTbuGsTESuvdSQS28+xogOrMoToOApG0NZanb
	HCJrbuLq4cGyCB5emWFltRwyIljSIuKbJYJ2Ee1O8DBfGLadfcSZQafrsdDHaBAicBD16cVux+97K
	P/dk3M1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLH0x-000000063MU-0KUn;
	Fri, 08 May 2026 08:56:55 +0000
Date: Fri, 8 May 2026 01:56:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_scrub: remove dead code
Message-ID: <af2lV7S3RK0bVSvy@infradead.org>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
 <177819182695.3486034.12265585124906674650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819182695.3486034.12265585124906674650.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

