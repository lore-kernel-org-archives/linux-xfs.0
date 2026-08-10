Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE83431A5C;
	Mon, 10 Aug 2026 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383464; cv=none; b=O5YrKgSDN3J9QG8IfJC+RgOdGrDpkHyw5GlF0e3s/3kRBMgOmaguo50MvfEl4z82mlk8AhMZadAD8FV5GONan9JOf9nOX2wILOBBA9IaX2rYzzsposcKPJpNrkr3Vap54qGmhbv2RBktGgDInj+ugyz9Ko7F1yGUHB/Hq/YoUnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383464; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5RmtC4EHv50To5KiubUvyb57atznJr6HnfpXmRH0KS4g2uvZZZ6vRf/v9BMj5yYENXLjXtucPvZSszmfDY2apTlgFOQGXghz5GnLBW39JUsR6ACCbURW3MaDOWUTrFqgVtEj8/Q+eHyPsuna9lls3vBuEBgGPGz8Rt1hNmvxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gLKKJ95q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gLKKJ95q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gLKKJ95qMnStmz+clE3bqwlSeO
	GXPCSup2kZhnSPclCH09eQVmSCGZTdE2o3e4xP6KBU1ELyeD8Nlna85HWGDKwVnEudvcb5KMz1PGW
	vj66ubP7aQn9QXiYrmGKgSM3KHpELxD+fLdKeC6MAptdrqIEeaaAD0moDimRUd1Mr9CMNgQp8SQzn
	Q8pSRW9DeVCRCm4ghSJ5dh/LtvkFsu/z1Xg1AXuy/cQPj049Mf6644wOMLVqM+ctVR6FGAa4dz4Ys
	csggNh1W8lP5kWu9lNWZih33n9/yEcfFg/IVWnrVdgIh8Sn2N86NP4nHDqZ6LAZtUrNwkj97XDfF8
	nPJmJehQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtTwS-0000000CXcM-43l5;
	Mon, 10 Aug 2026 17:37:40 +0000
Date: Mon, 10 Aug 2026 10:37:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: avoid double deferrals for RWF_DONTCACHE writes
Message-ID: <anoMZMav724xyGB6@infradead.org>
References: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

