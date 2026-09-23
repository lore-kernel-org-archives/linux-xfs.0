Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9BC43CECB;
	Wed, 23 Sep 2026 06:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144926; cv=none; b=FalV0fYuJeG7V2SDiOCg/djGjP0dTum3nEC5eLNKxa0uSuQqYHQLECTw/fwdp04ifCZ0KcAB5b+RKNTdnCyoeXoIJ5zu6xiq9Hd/IW+52sULJ9QT2qId6Dsx0blrcLAhcp+eDywnNRAJJnmTyhh7GQEoudALibJH7/60t6sDxMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144926; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQsqR9EZfe5cO3SBaAq+jr94zOv/Gj3cCQ3FKB5Fsb2oIHPrxwDA+UICMksFsekQVMS6cWOsdS5VfCPSIz5JZJ2nJCp0AY+W2YEcSsIaXOaOCCF7vMzmn8ABIlUafDs71ydRETktXuH48uhL51Vtw3fD05lvq4/k834uuW0Lph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mDcgACzG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mDcgACzG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mDcgACzGTLs/pyMsKeOtkYQ5+R
	PZlwD6zeYd05PrHSUHUBLjHq3+wFRXuH20AgHTjyia0s0yBda8h0/YfQstem0vmPrQJpdtJZe8aN+
	DWrpRrv55N2UIb9AFCpXGm552W+ZUyr2wwP6DHTJhWI6lO+DqDItTIrVKP69SutjLYSdY64V6jda4
	uUVkG2/ASj0zJjvT7Hr6JbBv4ZdQfITPNNlGthnAsCQ/2DiMW8vRfOmmt3hxdDPJMOdFMc6b2mXzl
	IqB6WONXCr0m9L2Nh3+5rwmUAp6tFoIbBADuVajxcd5B7wm/f/EWM2M5i0oFu1Brb0UZLOH4fOCk6
	nk+eQMCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9GT8-00000007H2E-10ib;
	Wed, 23 Sep 2026 06:28:38 +0000
Date: Tue, 22 Sep 2026 23:28:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfarray: don't crash when sorting if array element
 crosses a folio
Message-ID: <arNxlqbY32US6vTW@infradead.org>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
 <179014159120.1874904.10223064447351373669.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159120.1874904.10223064447351373669.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

