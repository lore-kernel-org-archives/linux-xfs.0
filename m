Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5B376E9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388018; cv=none; b=H7JRFxqDaSgn1r6n4IRFGdnAeVvFEfoO5UM8giujZfDL3gXUEyl/WdmmdMEXWEfkTq/GlH+tFu3XpiiESmKdnxwTni0LBph8D5pKoHmyLHqPdpSMd1PZa76YIdnUoBAT2wKwC2GTvGG1l4rUl6Lv5+myYvUUK20Uma8cVus2Bs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388018; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gv8nkX5glwNDpzeRd4oLOyuAQjdk3kubyASTkpPELeO8K3W7FlPh+IXoW7qo/lH1Tmq58uMEa2d9mcezaFEs49jqhLRd/vVVz5c3+LxHq2zU70qwzY9nnqbtOtvZdz1/rvE8otRGN1o0r2f82yXeHd1kBAJ9lS0Fhr7/bPDKEFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HXHvwVqO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HXHvwVqO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HXHvwVqOjpKTiGs5Tpbc7I29qY
	Oyn+cYHK4H/4PcqxJaFpfX45B6/BGyVzft/YJNQetjhQocptGrCLcfHP3WJH+MkSUDNT/UJSRdO6p
	vwdJ3khdhjytmdIZlE06RG6dekCgGkaxcbVMoiWyBYdQMQQg1qmoQgL33OQfXeDKNgt4TBra/sLYH
	xmEHMgvbsc8BiOvXYWW3JxQ7pBfZqU5EgUNPyF1CzndII9wW3T/mcED30sIuQ4I+98aDVGXcCA0xb
	h5Z9JnXA81dSjMrvpvs6IvLMD75xI7zkCQYtvxMg/TeSf5YImyCzb9IxIi28+jTazBw7Slia3Kl4y
	TYI3L5/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM5w-0000000FDMd-1vhR;
	Fri, 23 Aug 2024 04:40:16 +0000
Date: Thu, 22 Aug 2024 21:40:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs: hide metadata inodes from everyone because
 they are special
Message-ID: <ZsgSsDOaZoT9fkCj@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085312.57482.9340127129544109933.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085312.57482.9340127129544109933.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

