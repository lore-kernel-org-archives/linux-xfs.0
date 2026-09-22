Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806273403E8
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 05:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054662; cv=none; b=DieZ6Hj3JWNERfN8Vae8IRRFMhzlYt+krsIqecJipSNhOdupYeowVOdVWqh5UPTgeuHNjySSBUbbmY7vFt30JdcBCb7KBMqeT1Qi9gcNDeRsX/UBOLklrEa+7iIguqWtqhUgNxdqKDQ34IXITJFiY0ovJs0dXRZL8zGflNRDcQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054662; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQiRoZcqPXlT0/nYFvE+VSWurpND5EFcP+rlKnOVfXqiNOAm3v5FA8ETB0Jm9aNCaUgolHvCyeVUEaJKzplfvLwzLemhI0jHP3OIRvSi5Z7q/kaBWzkIYWK+Y456s8tEtea3cSGV2m3LUiEfma/pRQA3IZnztWl1wayMseEV/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2l0MlwVi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2l0MlwVi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2l0MlwVias6Kt+jquIwMV0Ms48
	XSH3HwE2yyYt/6mlxLIC8ZlGQVdbuMkcchHUns1f56dt/O1Ec26TTaAYF+ehrvlWeATCfm65x3IIC
	CT9Q+yEqDs+wK8dzQdcYiXK/MKMvFdXBC+o0USBCgs0rgkdDHJUxB5hlMFrZCvtXF7bNDsZ8Fhp7m
	pN+kowytxBlQPFgMtO+HUzz9+BtiXjkvKUVKrEOSH68hfGojIxtS4Fd36suTOs8nOWoPKtXWg/jud
	PZ2FTEEUa27ad4cWe3kYR84ugv5TaiXzDB0e5O/UP8pJ56nfL+ry0bM0Qrnd5m/qSGEublOYWHefy
	RON4xtvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8szN-00000004EtO-09J6;
	Tue, 22 Sep 2026 05:24:21 +0000
Date: Mon, 21 Sep 2026 22:24:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: don't allow sorting sparse arrays
Message-ID: <arIRBf9sMJr6VEpI@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120807.181988.9510302652927544095.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120807.181988.9510302652927544095.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

