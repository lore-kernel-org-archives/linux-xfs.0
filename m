Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B751C5D57
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885565; cv=none; b=fXEA8cHMuGIquoUcK/81ejNwLoj06M/c2YXE9Z//FcWHi3BT0Wz95M2q1IOLQKSTRU+V09QFiCIA0OFP7YKZkFit1+lhNdR0P7QBuF6YTq4QtcMRUeqzKH+w3W6aGmr5MDOdkJRh/dNyfq4R7DXwzgTA1apW1/Lrz+mpeQ4QvZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885565; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awl0+xtztlCT9EyLTBokeHFldyJiWyCcmf1nEszkF+fiRT9HOXLqpYHGTLZ8EcGHQkGVNQi+QiGtyOQPGvoKl+9v//sjED22cHqW0ckIzaNWG4/xftn4h1EGGhp/Wbt2McRACuj1HQWDK+3yO5+NLn3Gd1RSXfX1m/ndQ+JxTX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D1sFQ2KP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D1sFQ2KP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D1sFQ2KPzKc2ahhGorMlfGfmVg
	HNHr6utOnAJ68t8oDMOl+MuOYGdxuuRe+EnHQy+Ujyo+nhOXcQzeS7LF7dLv4+RLl8jYJVBZXebme
	eVqnmTvyGpSKb4qpJTkjs2CK8vf3Y1a4eoYQi5BxCxiaFbSwxeOmwJ1Ogwv5wFuUgG1e8Z+mYN+e3
	gCZITuuZ31GPHSlTyI8fT7YsFKwrp/39AJZoZ5HQ2dfl6agdFjzD2avKeF+3HP4vXoxesZ1XS/4tc
	+IPi+rUK28Dx+BnPqvmr3HIAlDHoQikMFqu8LlkDPl9zODGJPWzsr9DG8qAKFFpuT/Kq0hMbRg9RB
	qXycqqNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7kq-00000001jhR-0UFO;
	Wed, 30 Jul 2025 14:26:04 +0000
Date: Wed, 30 Jul 2025 07:26:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] misc: fix reversed calloc arguments
Message-ID: <aIorfNIwWlrF5Ewk@infradead.org>
References: <175381999056.3030568.12773129144419141720.stgit@frogsfrogsfrogs>
 <175381999075.3030568.1303902231364782556.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381999075.3030568.1303902231364782556.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

