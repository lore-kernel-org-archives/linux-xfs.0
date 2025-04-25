Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3713924BBEE
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 13:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745586740; cv=none; b=onga6pfaPmfpvrM/m3OLSrdtvgAVjQXDy2P8r4CXAOCmux4f2fZnRTrGV2WMWYyMe8oj+VlkNrMcPCyjeh+Hg7OBzfB262OFwDeuwWQqQRn5qYDbrgbDnAqJR5Sc9VoVB7mjfCgtBUT+wakzB5Kl2UVletbNIFHX9vGjXyiKrX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745586740; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnY+0shA3lsl5qXDvQx6Qr9v3EBLh11pO0bxvnwSGWYiaCJa8VC+Sn7e21Y2RW3wSYfpSPEFz9yymMQDRsTtFvWQJL5E4vUqLWi+TVaE7uW16g3df2IFrPzDtCve4uuigG67qU7xnNvE8PlWxZgOZIkzn0sTpDgNmlAK503YhGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C/nnVYXE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C/nnVYXE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=C/nnVYXEcv5tInwGL42QpF4Uax
	fMCkMiuahkSSUvEBp8X/TjCzRBgpOPsHGjyYT0jLH31w5y5C7CtbAyR8Z3e3jK7ntmIs9ObbPwcSU
	kJ7bBQUFKfVK0LfKYMz8+9+uvPrzYq/C00FkTxte4BjQ/GBB/NIgI9NZ0vRuFwbzL18Vfq+4MbfAF
	7L0owM/VzyNyl2SrrjgGjtrIwj1wVSt9ZshCOcu1QYSo04cK6UGJn7/3Zwv8aaqRe/CEi7ys+fsQd
	ctSQfxUj2GMK8Mzop+R1i7Ku0Cz99k1zc6Gpdjd5cDZsBpGRp92X+hF65c8h79hwLFi2zl+gxjONZ
	UOiDhdYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u8Iqo-0000000HEUP-2uPq;
	Fri, 25 Apr 2025 13:12:18 +0000
Date: Fri, 25 Apr 2025 06:12:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_io: make statx mask parsing more generally useful
Message-ID: <aAuKMh8l71hR59uR@infradead.org>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149393.1175632.5228793003628060330.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174553149393.1175632.5228793003628060330.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
