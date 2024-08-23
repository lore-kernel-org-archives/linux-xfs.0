Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F54C3B29D
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724386148; cv=none; b=AN+kTL19hllXz7/rxRlHWLweW5peGZbctlm/mmIwXCvfb0qZsCNDViQv6bihqgsm8CkQnR4Xa5xPlX7UAMQSvWo8RXHZP11AhDgDOm59EF4ennw0o9gOhdlMchfMHmvCLiib3bfjv0+5qo7M4YG7xnLqEqpFf9+xzXOV1zK8ryM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724386148; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hJGhyU7f5xumfNeCEjuWYcN6FNoEAAQRv7Q279ph4eArF21KV/ktNRRCTr+awCfQ1N63SqwvtHRtHggbI+qIBAk0cjhRdI0YQZhaHDJT7ZN94GPsc1pn4xGSIEOaDhCTk6O7wUmE1EzSaxaaDujO//mLv6/23Q6WIub4IOk3tb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3UnDw037; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3UnDw037"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3UnDw037yG1YD3R8Sp6HlviJ2N
	pn+BdgdGY4ray026ckUgPffUXx26cbDDwF4/6wPbygZEHtndcVb4B0gyPEZB11m20/JIq+EYspGWX
	M7GUl4IpsOtULH+66sKNQ/H1u970nDAlreFkUuG5Xq61ZnJHTUFul5TWaf7liA4ypLKU990GCKKQI
	1ycOOk15PPocK6E/FHmtGJd4aw6O8rEW2gsUPko96fCbzK+NMqMHSZLhqbXBUFb66eKARpe7zF4Df
	LSR28smqLqK+UGlNql6xCo+4bFv1TEMxgK+9Sz4yMM68cPWm/SSTRjSjhlaqTt+9WfQKvjTpyRfD5
	LwQK+wGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLbm-0000000F9HC-0c6N;
	Fri, 23 Aug 2024 04:09:06 +0000
Date: Thu, 22 Aug 2024 21:09:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: reset rootdir extent size hint after growfsrt
Message-ID: <ZsgLYtim4pYDekAY@infradead.org>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
 <172437083905.56860.4443371257049623802.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437083905.56860.4443371257049623802.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

