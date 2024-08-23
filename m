Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC8138389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389096; cv=none; b=UrRPU+ySa7wNwE7LismW1SjFct9I/1dewdQ0PxNhaiH7GrNjQ6cGgTKhEFqo3nzH/KuvP+ynTCmeAwdeiR/1s0bJJ2jK4INu+OP1ZLzN5dERvQiiO5OpnAAwLiU1dzzisEUmq1EQpyu03jLsFvL9Lstxky4mB2VX1U1FmDuTM2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389096; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9sA3lkUF6dz0Vbiqid9ylgK2xDqDMhTN6rCykZQT5SassynaK6MCCvVqjWGEYBLjld4s56I3SNwt6kXKKcsQ4Y4PfDDF3bhBJkwKbzyp1R5KDbgq3c01A2/gOcQSjtRAEYaf1orZ/ewrIVxgMv8sU5d5ppD5zsyYyJ+5AGw7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nzghAA6+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nzghAA6+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nzghAA6+y7Wt8Bx+pr//GLbDNC
	qp526GmcgZ9OKkkgVkgnaErO7AdpfRLsmeXqSMBx62v6nnB0zRXMmb5pqTE+lp2QbDzSTJEUSGwmG
	rJQdtNJDMaT6R8XRJcYDGR37oRltwTcp30TgzS1OVhfOhe7XbsMbhcXLlhRkzv2Z+zOyI2o3BGNIU
	i4oS67Ts4hjOTTnxpTG35Z/95ni+XVic7lV0Lx2w0/VARtj32sMTQplvtzrUAQjIWvF/yoVQlHRY9
	iMGMfG1zbTUIJ7TzBpsdOuu5SIF8e4Clnv1/mrz+QYBC4DQRGspefjr+bxcG5vSmENi/GBqKBqpBP
	GaMwW+/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMNL-0000000FF0J-0geD;
	Fri, 23 Aug 2024 04:58:15 +0000
Date: Thu, 22 Aug 2024 21:58:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: refactor aligning bestlen to prod
Message-ID: <ZsgW52ilMiajD3NC@infradead.org>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
 <172437086703.59070.1862088410279807687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437086703.59070.1862088410279807687.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

