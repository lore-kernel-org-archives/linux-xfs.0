Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FBE29B0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430140; cv=none; b=ie3XS8Cz9oa8apQG9pxbsjaXexbFVRW/ZWAaPvN458PjlZtdic8eplRa2Vy9LosPvu7i6mktckDdz6E0BpFUqRnTyq2kw9nNWuw0L3Qz36YthXN4oncblX7IOqw62uqz3utH2bntBr6nsVq+eGarmEamVAj/X6opCfOMnDgMmVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430140; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlvUVjnKH1TxppcQv9Rm2RzvDEfU0TgwdmQDHEQLX74fdbBBxxA0NNcdunMmL00pAKVq4tFyPSgIE+mQvE94mDKr5Ahv+4QAvwBocUce9pGHB8nj0lVC0OUOUvPentlUGXaeEHzjNX60xWHMxNpHe3TAFfSaD2J690jxWyZpyOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UQyPRUc8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UQyPRUc8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UQyPRUc8FQDt6/teWCB53VHFIM
	iL2xH4S0CzpOJB5qk6X97t5ZFeu4xa3Y5yVtRHgbHZICWmtYxRvc6gA6Ua8kpS2xIdmDDXfOkFwuO
	di5rtwy/6tR399dN/AWX/M0ClJzwwFSGJl7o2u5aq50ShG+wVi2ikwo1ajPaNITrcqlRuncEvw0xf
	WB/DV8hx1bJPTJ2Qa0D4JjHMrroieRs/CvdXCDvw+WYkHnYHKSjn6gKRI4dFUsrffOzVqGh88VoMZ
	gjfiFRVDNWJxSbAueSihH4NI0F7SPp94eRMGbym/3RzUkt807PM+GoMQ9W6rDZejyZL3kHdhXY1tm
	KRpe/AMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roz9u-000000037Nu-0UKd;
	Tue, 26 Mar 2024 05:15:38 +0000
Date: Mon, 25 Mar 2024 22:15:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub: don't fail while reporting media scan
 errors
Message-ID: <ZgJZ-lTezXBmGZSm@infradead.org>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128620.2214086.9691663764474963447.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142128620.2214086.9691663764474963447.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
