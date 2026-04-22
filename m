Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A930C60D;
	Wed, 22 Apr 2026 06:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776839643; cv=none; b=QcJheJoRSxuuh4iEaktkQGtWAtRfW0VJEcUdtRIUq0Cngg50SmfTyg4BjxGngRqP3HTH5JqMUgnLvgtbJ4a/6DF90hr3kQB3kdkI8oTgSkyWYuHt+/FCaP3uME7NZbT7IKtaU+5eVRZd3iaGDNPa71QVEny1gcWzQu0EbYtIrNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776839643; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CHJoIAoe+EgBowHVxGTT6u195P2dCc6bIIG03tVFNsyqZEWbU9A/GcQZZi7azEkkfhc0sEiJYf7h/mz9P62sGNwPbu/1GTOJWg+BjunIhk5affmHZf6dNuKJ6NACjIz3Vp1aTvIbdYI6W+jSzaP5QcVH3sBmaDOW5vmbMmPBWGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YdA1fg7E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YdA1fg7E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YdA1fg7E9F57Ys7OPdHPtrzdef
	2pdbekkVLYPo9LtmZXZggekEEIu+temlrAFnU0M1OpaxE7dRJ+3rGBQHKTpNEF6vaVIg04h1JM698
	JVT5c/G2oMkpNHnBLk6sZ4kVd2QthPgFSa0VpSKrb+qcmw/JNKRlibq9gwGsJYVBH5Mt7/nj93aX8
	0ZpISW+vJPwE/qzi8u4Ma1jXirDhSGxQC3Anik0614XUP9qDw5mmuhjJ/+yxLH5mQfYXuQYFQLBKc
	hGGj+4C5kaINtigsIVQV1K90GzGqaa+H8L/bDXYC2CGMyWwX+rnlAgvydwH8CB3pvw/dVAldii0KV
	+lQtzhTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFR9t-00000009fTJ-35jR;
	Wed, 22 Apr 2026 06:34:01 +0000
Date: Tue, 21 Apr 2026 23:34:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <fengnanchang@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH v2] iomap: avoid memset iomap when iter is done
Message-ID: <aehr2XeOlt8hk0Ry@infradead.org>
References: <20260420061630.62077-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420061630.62077-1-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

