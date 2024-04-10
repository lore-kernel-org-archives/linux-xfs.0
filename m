Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33F13C9DE
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712733810; cv=none; b=FKhFUmoNnlwhwA/xYg6IgG4iqtphSfrmm5FAKoxqQjYCJFgN6aeMcAldZRtghkr9wK2I33007XHtyJnbdNwgnurv6Zy6JSWMRVa6Du/qEXTBud4MJ8aPg2OVyRq+vI9GIqeuel4n9e253EszOOL5aURpaTSV9r/eJGw5FluJ8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712733810; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uU9AazzMjKzNJlHGY9IN3u5qngrHkp79OMXzOWnb3J+Gtq/KCfqLNjD+EA+7ibw957TpZXqYUgYBQAAIUgb86rDTlB7VpZAEsHfLlI8xTaxaR8KBE2LRdTeY8upOdPzVpIcV5fvnbI5u7BimICv0A9it6xlwl0un8pe15aQVfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bFBizY7U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bFBizY7U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bFBizY7UJtu5l7fZVltsoVq4FW
	LmZI6mdRbuAqQwjv3eODfcsXzzaMn3w0PEf/dMJ7udr3dklPVOtLdWwe6m9uOXA6HJCiPrFJhqeNR
	FrTsdDp9Ugn6cEd8jp0c1tPh7T6n7UCiF3jrAi8flaYxgqRn5q3BneiJioJDrXRtbALkUZFCDx8Rk
	DLUuDJdWuFOEVlLsSltdrSYpWLTvTNzRKp1i80eq35eUFu0xjGML9iUJNZy3sJEzUtnxc9Qy4tNce
	xSo81psxLxTZ3m0yGs2SBAopZVRX/6L5jBXlkhjHk3QVBrzdHSK1aHq+8L1O/Lqr6uwFP+y4UDBRJ
	ZGUSm2hQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruSIq-00000005arz-0plJ;
	Wed, 10 Apr 2024 07:23:28 +0000
Date: Wed, 10 Apr 2024 00:23:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: report directory tree corruption in the health
 information
Message-ID: <ZhY-cHJb0sAaRG3c@infradead.org>
References: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
 <171270971640.3633329.13764771670901784778.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971640.3633329.13764771670901784778.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

