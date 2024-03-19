Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE176AC0
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 01:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710810671; cv=none; b=NUf2Ro0st/95iW4KBiPwkriSGbL6eEE89FmZux0WpWBM9l4HhO859SL5lbd5y/erRKgwkYsqN/qVOxwPmCJr/LVRWHZZGI+JD8hOQWPQuxXaby91dfvPPfuONZ98Xjg9IHJxyXBCnOI4RaB1cM7583OO+0Qus2Dn78NEozYNf9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710810671; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEpgY+gEF9A8stf8u2PO0hei0f2Y8fgwuA6CjcqrP5KIton9zgm9ilGq6DAlDUQVRQIIcm+2K0rmelpBn9i8zHfKbWj592VkLoMCCqnh7X5OjYhKBm11f3Z+Whq9JnfTm1cn6Iw6O3sVxWKpxMnS9CLoTITeVczs0O+GNzLoa1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pLbNi1Ja; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pLbNi1Ja"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pLbNi1Jah6gbBjKf07jk3FGzk8
	XCqNY+bCXsZGpWlHVvfwEy6Cl9e2He4L2MfhQAMLZRq4o7JTCVaIYsXlyLAWpZ1Bdr6D5rRVbZXwW
	bxuc+uo/dC3epFb5R1TcVjzSXPp1uhQyxwiRikYC/TOxbT9TcaEPo4lNfOnaSjf1HoK2OwDrQfBYs
	Um6t/PTsx8lxAfi+nyyvEuOdqgwrxNpBbjlWF2AaPgk8l1ZhEtvcVjyoY2aha+plgfHenWz/bE2j7
	eLlHpqdg9poF/+tAl9ya6CnKIUywU7DUx1M10rdYuu59jYQvRAyqYLmwKh5uwm8AHCe3WE1CEDHeJ
	tkMzPXHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmO0P-0000000AlpU-0C4u;
	Tue, 19 Mar 2024 01:11:05 +0000
Date: Mon, 18 Mar 2024 18:11:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: allow sunit mount option to repair bad primary
 sb stripe values
Message-ID: <ZfjmKe5udMuTZTlY@infradead.org>
References: <ZfjcTxZEYl5Mzg9O@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfjcTxZEYl5Mzg9O@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

