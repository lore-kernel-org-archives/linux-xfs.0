Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57D81534F4
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135093; cv=none; b=lRjVvpLOU4p7POFU9vfatWowi74iKTKsNPKPwBPhfPtbFA5WNynk1/winAhZsOTTLBsvX1uC8V5k+ZslnF/01UqJSKKVhC6ybP6sZXpEINWQcbGgMCgE9vDeFP3YG5sGJHCxs35cIeA11UvH8EKbmW0WEuUjQkVn30LQsN5RMFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135093; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBB86je0cUwN+tkVwTfnbfbKmmeenc27+KPErT7RWn6eOh7VboAqsHxOXmL2P17kGENv3EZITsVTvQjjUGeeGzBmzxiW5i2Y/0oSoDJ5prMBHAe3m7Ou0qQVEGD4o8nGOKgTipEv0tQo4SGiG6jl5qx+AxKJ8HfDq8W6FpXT93E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P9SbDW0b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P9SbDW0b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P9SbDW0brL4ZZp+Jj9frkJ9yHJ
	I9JfJmI1Gfpe5FNzY9Hi3ryr9cJw320tU1MaqD9l3Fekoi3P78iyQmgijcSIEARoPrMWdJ7tzl7WT
	VqvRgKXRoHm3myx1eJCKh+2R/hSOzROAQ8pqdITcLnlYffRu+eCSsWQZW8bhSvJg6o2eAdbNV7CoJ
	/pLTYP5I4AEytt6iitILS9Wbr2h4G6Mq6auA6X1nxlhljyHNSFaF+C3YpA6cKTe0sXZmYpQ6JjXxz
	Zl16YJkUaWixWl+9C8jjaTLqIV05NdRPEum/py4/H2GSDrNKdZiQPx3BBqDHPGzAn+v/3mclYrie/
	GQl14Vpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfM71-00000009xZ5-1CtU;
	Wed, 28 Feb 2024 15:44:51 +0000
Date: Wed, 28 Feb 2024 07:44:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/14] xfs: create a log incompat flag for atomic file
 mapping exchanges
Message-ID: <Zd9U87Yk2zlN9ma2@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011689.938268.15360453692750885891.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011689.938268.15360453692750885891.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
