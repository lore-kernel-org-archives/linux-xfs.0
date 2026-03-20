Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F881358377
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990784; cv=none; b=nWRh5Glm8rP2wXbF60sP0i15D/6fGurTI1OVSBwV3tWij0JDJ5Z6TmfqW3iOIrn8rtpjyXaZFKo3nsc3hIduYpVveeHPwUoD//l/IXLEtwDP7UKFLUEOghVEJX/lSYYvwTVpufWZOKGOVOWaAn7tOCuDa0ucIyj8mGcTnUC07Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990784; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pe713zz7mjl1UMfW1uzeiomSfXI1Tau2y0PqgKJprogWTf5yaYxpxsI0BzkRIGt+UT9qP0at84oHEMFu/R/jCvzAyhgDCzEHOwChJUl52qZxhVIhaCelO50A5yq4ltprq/Tp5XWcFf4LuieXIBm/T9NB152u2PKvOk9aUzLLeH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a/Gw0Pto; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a/Gw0Pto"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a/Gw0PtohCc0bi0ftxUvqdRsSA
	YalIwtH85PBex6Bd8Ok5pKvDlS9VUIY1X7EYx+FJa7iWZsCaciOCYSkyF7xt7sga/rAn3JrrTLtTc
	HK3qTEY1s5t5Xb91+mrh0JSDuxhvrmEAgF3ExAKt2WMq8iGT+dUcTMAIvfC+74sWPQAjZGssMO2rd
	Y8OK0IHlvgIOAzl8QPchIg4+E4LYUYQGhWouzFb0/Uwjlk8/b/uohUFB/cwfSuxXdA6CpzzwIeQQM
	D6r+Iie5SmdesgPn+2/ZQmOC5Vsd+4csZySOEm4daZEIIC5X37HNftXUez2EnD4kw+TNm8eS6qhk6
	C6NPixUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U2Y-0000000CDQP-3MiU;
	Fri, 20 Mar 2026 07:13:02 +0000
Date: Fri, 20 Mar 2026 00:13:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs_scrub: report truncated devices as media errors
Message-ID: <abzzfsXzABexlkkd@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507014.3681140.10664326482423206046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507014.3681140.10664326482423206046.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

