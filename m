Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FFB1E5B85
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747114428; cv=none; b=N4ThbV4zapHQti2YokSYjre8YUKfeLHv07EqtrTpKTWN8nbnZ4pfo6UmqoeduvcHKm+AUaeDtB/rwdMH4XIn11fony5mSTEBr+3DvpRmU0KU/X/K79/yeEB6ZQlo45nEzpuStPpGcD2RB58F9uwvMhmurNmr9ADc8jVjRxxLdPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747114428; c=relaxed/simple;
	bh=mo79ZvUPWP7mLbGcSiGYZlXetR6/YfEHLVj03TWIAaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMkzXifTcVGqKkCQrMNOwFGEn6CtceE3plEGEb4A9EVHEC5a8fcGXvYa4lnGUXwUsi5GoSjvxkSiMead1V4iP4rhnTVMjXyo1Ss/882TaEi1kRFP4sGm5114dNqVdwy8SmXR/P9NKx6wbwluK2afU5fD6A1QTkABjHzA/LYIDsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0gZrn0tD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0gZrn0tD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mo79ZvUPWP7mLbGcSiGYZlXetR6/YfEHLVj03TWIAaU=; b=0gZrn0tDVd6PKBE8Z65Mj3cR87
	eW4zN/oseoWeOZ0ykZCYY3ULRj3Y1d+4RWQ+fjq6hwNj88kORIaw3ztphJAjCN0Gu0hazAxuoD3Np
	Bt2O2FmsJThI9mQlrDclZjVLzNxFtNkEJSLpe2Nsq1RlsJcWAmE4TfADuj+d0iBYEnp/RZPmYEgAQ
	4inEylo3THIesis4vFsYs57TNGpFVRMVD31JqYC/u+AEhCPw6rRkh/zfFjVQIZ+XP9Yx1Zltj/LtE
	dk+swIg8S6XXwEsqi0Hjlrm2KDEJXF1tYS9YVvcbNesRILMdIYcafOFe771LHNKt83sIARjlASQEP
	nazVg/Sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEiGw-0000000BOtE-1bT1;
	Tue, 13 May 2025 05:33:46 +0000
Date: Mon, 12 May 2025 22:33:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Daniel Gomez <da.gomez@kernel.org>, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <aCLZusgpiV4Lasjz@infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <Z6WMXlJrgIIbgNV7@infradead.org>
 <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
 <Z61wnFLUGz6d_WSh@infradead.org>
 <hljsp2xn24z4hjebmrgluwcwvqokt2f6apcuuyd7z3xgfitagh@gk3wr4oh4xrt>
 <Z7RFQQoC5J7Dl6HC@infradead.org>
 <aB4QzM8PTC2qD9EW@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB4QzM8PTC2qD9EW@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 09, 2025 at 07:27:24AM -0700, Luis Chamberlain wrote:
> So this should just be repsined with this just stat blocksize?

No, as mentioned before the entire approach is incorrect.

