Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF336FBE
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 05:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717218161; cv=none; b=Ec7/RuHuddMvVGYwzUnfbVnhk+8dpvASsDGHIs81y22lIjuNS8F7fsJLsTCa1Yh1ZhME1BAckzmH6dcatX77vQwglhaYJlpZ/Vv0W1DoDAdj4Xf+KPDhZFmx2cgufNOW6oA7pynXPy5xhtNknfltKWnpvA7ZaKrK78gwPXzS7vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717218161; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8DUn/JGRvtXRETWDfb/4MbktOUo26VxHSMavxZyBpXfVuT6jbLEBLMe/8bWiovfbPJhjbAj1Nj2TseNd6Ai0mPk80JlRARneMp5fmVosIs3/K4DjwExGuX/+ArAKq2ShrKmIeVLq4lHoiHfr3ySMnsiCNYfYtR1BaWqWRqMCLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TI8+Gebi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TI8+Gebi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TI8+GebigWavy3Iey2CRX2j/7T
	9uweIty4agFMlvIuGWU9e0rTA7fLomlG28rJ8K42jjzaWCAFkJG96oNNlB7IGSWGaqvvC4a/+eQbL
	5kwE+c9NwwEtl8zg+U+vm0zWVp9YV/P9jE9Xynvhu4IWORInTiREoHZlXAnth1BMwPirx3kQvS4+b
	siaXLSynUs9+yQyGzBO8MVyqoDhBlq4o0xx1h4WvqTTlbcDZSiccSd9ZWzC42Y7JjOnQrMP1CK4/O
	invgu29UEzic4ypw7EUpoA8vJKAtSF+mO2XI7Ns5JmIA0uoSfkgcIEK6t6gXJkf32Ws7ES2vgvfk1
	YVM//bzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDGt6-0000000BzC4-0amX;
	Sat, 01 Jun 2024 05:02:40 +0000
Date: Fri, 31 May 2024 22:02:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix gcc complaints about potentially
 uninitialized variables
Message-ID: <ZlqrcFeOUpgkPM_o@infradead.org>
References: <20240531201222.GS52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531201222.GS52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

