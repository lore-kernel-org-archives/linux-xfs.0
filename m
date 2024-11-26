Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889A7E9;
	Tue, 26 Nov 2024 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597317; cv=none; b=Z3Etj4h2WmEQeq2/m6xJddUyzb2RLnxOPjmyqhJrgeulRUXh00RFHg4xGSaK+2fgBLVzCRoh4lfC0XGP9eHVliu+akwdC5pCyMCpaKRj2sbsJ/mRiZBKPj6gYetuBeUjF1auiLzP6qQgRzcboILfWolJ9eaM0wTY1ttXeyXllwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597317; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFMcqwkln1EmuHoiuBGhqm/Gz9ScCv25A1hsTtdaElQwRq1k6mrEtWOi8PQ7GacwbvdnPL/Wyqg2zA23bULz8UDDDrZj53/dYxagKwE9LvAitLuIUfLL63xd+VE5HnYglYanqWe3I4RngMqBW+VbfNI93dekABPcctUqCKAW6OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iNtIok1d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iNtIok1d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iNtIok1dezufICzDJbs3xV98Wa
	+3oKKxC916u7rLEzIKldR8+pq5ObEYE6iVBOElNt8g9LPOjp+CtdDw14zT8e6WjAYVNuFzLZruwl0
	t5uz9XK/TWfZchYvtv4vO9YXEEP97wCVz5i8KobEx+umEIjPG6NinvHpkwpcOpdwMD/oYtSz/AF6K
	TWTWaR5k/RLGZ8w09041xmIsaSQc85Aq50mzCCYAiHxMndDUDeGP8hWA4X7ZygksVMYaAI/6W4IGA
	lBUvapQv77svYOXEBruEGVFwIcXlR2xrxFNZARLcxLkv5FbpXQM/mD1hRTIjTPCDFEaQX+dUJX3r5
	oXIY0u+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFni0-00000009dta-0Bad;
	Tue, 26 Nov 2024 05:01:56 +0000
Date: Mon, 25 Nov 2024 21:01:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/21] xfs: fix scrub tracepoints when inode-rooted
 btrees are involved
Message-ID: <Z0VWRA36j0ixVp-W@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398008.4032920.2214591217065414920.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398008.4032920.2214591217065414920.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

