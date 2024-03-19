Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DED5026A
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 06:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710831387; cv=none; b=Do7VwGm8zYXclHkBT74M2mGTBmQswgy0c/dWl40owoACia7MONshpQW3//grB1Z3V5Ya6bWEJ/RuBV63T49V8/R/iH23i4HKhSC/yr8gMfb1QQ0s/wrJ+LJBBDh3S66Gvpa2VVAqvVWaDgZRk7Y+VbXC6m+5gafMT8Y0Dv3O558=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710831387; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWQryNdOmNtd3NtMGc4IZ/f0V8v0PS6Mi+TAXxugOi7iWB4A8b5sMZWvh1O2WhYvvrQUHbWAxvtdJ7Z7j4rxT55OhNcXzRRGOayFLoezlHZIrIdjoCyQ8JAwlk8W4DCX4z2BDqnhpVZjamXdZIjh3s5keaqIo1Mvro56jHzS+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JpIxvGYB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JpIxvGYB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JpIxvGYBmdRLN3KHM/NtRmxNV7
	rF0DS4hhUpI5cBo+YZFxKJNiEKzDAoiEyq2tudcMxgtE2+fnaRgmSHUUyZOX6eaklFtEzGorepM2a
	LXvLAnFkWpI5yoJxooSJ4x/FZgWg3DABAmkGQMzogy/jyXBY/hmU3dALcNC+9b/sx6wXE0WJOPa5a
	zHemgSCcsahrtwDSFJLHwoYQtlrqyUUpRUXK7Apobm1Gfvq7z9BjYE8xpjdqINXtgMxHUd/enYUES
	toby8ZgfUR4nDxKyduyaF1MWVhttPO9zjGLv1OQ1bdwUw5Y1ZcpYQSPIy+fyqXorG4myKKBi6qSi0
	CpF1I7/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmTOb-0000000BarX-2KjJ;
	Tue, 19 Mar 2024 06:56:25 +0000
Date: Mon, 18 Mar 2024 23:56:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: buffer items don't straddle pages anymore
Message-ID: <Zfk3GY7AINqtbAHv@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
