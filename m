Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E5E3BE635;
	Mon,  6 Jul 2026 06:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317839; cv=none; b=DZkLU6M9W/TeO/IQvXv6A4irF70TYMReTO30o1kQ1zvFHR8VdYd5CF6N3mh7izGW5impiFjq83zlx7bhNBj0z2qW3j2HuAgLTMNqCdX4CgZFEStfCvqSX3X05hioVNvmlHMPVgPOKMbMSde7YhMl7JqI7m5Lwvb0+y2k+KxSKMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317839; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeYWu7RMAqOa4GrzIBg70X1QDmkHHbWvFH00GFi393zCe1eQWDeN1ADPdQM+QP+nNQSSY9zRa70WDwJR/3LCSHZ+Pllcsu7i4eqYvYkqFN1wvwbRWShHgc2eQaFe6MIKVVHG96rNBth0v4NlfVKmGqGUhZz9l23mX4HlvoUfdGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BLGW/f3/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BLGW/f3/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BLGW/f3/87xYbummncuE76UtQn
	NennMTA/mjU9KCvHkDn5bxNoz1pcU1IQt0KjikWi7ThbFARiYjDzlL4UJGJ6j92c7lnbPpV1Z4Jf+
	gSgXcOAerUx34jyyBao5/fexE6A6+QIyZX5Sq3jeUCVk05ad3OvG44s4T6j1sT83qdtLW2wvOaPGS
	RJYcsvVtWMjbyFJzlvb3QLkQi08Zek0cMERWN0OYwVY5Rgfr8IaJtPifcG0tHdTeTUyyJLz0jjpxR
	L4RIyleuJjuUci9ARwrc3sqfW32qmaHvidPoQO/kGLO+f3M9CE3Y6MV8m++bVs8HPXLeH0fEyK6XA
	ecH2ArEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgcQu-0000000BZ1l-0JyV;
	Mon, 06 Jul 2026 06:03:56 +0000
Date: Sun, 5 Jul 2026 23:03:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: caina <caina@uniontech.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@uniontech.com
Subject: Re: [PATCH v3] xfs: clean up spelling and grammar errors in comments
Message-ID: <aktFTGyKsor7HGaL@infradead.org>
References: <20260703093402.3146-1-caina@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703093402.3146-1-caina@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

