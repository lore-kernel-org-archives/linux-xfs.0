Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F86536494C
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139718; cv=none; b=On5cCFwTjkir+dpFTx15nOck/yZpFpPjJVC8U8ZeCwhUPYGZQi6K0nU8XiZvlybDvDAP6DSDdc6YPfGp01gRXGtK7rE46LOfXMOMf0hu25/k1YxR2pmjvdv+HWWtQxy6Cm6u1gqPwzwrA1ErlSrArnfwrQG3hXYitMRDEfOq3kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139718; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Deym+CUELqzepyWBp5RtTVSERpP/oYT8gP9hbpT+Q3qnZ1CvVc4jdjTJ9K86ieHYHtYqpYgmw4bA87EPl/l41zUddiaaU/RG4MBQ/YeTyTJImmpqf4eh/+gk3gg1HS2/B6A3hmcecUS+auVKYMlcYUnXMIRHCUMkca2FtOwTUME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mS66EFgb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mS66EFgb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mS66EFgb3yGlPevi1wcU5r6YAf
	Be/dofOQ9P7KaXH+dbevZM7OH0zh9668ycfcITK22EauCMqYdyr0+UsGxFRCnA7qylG140052iXtS
	xyZLnIYzTLerwyA+emg1VHDFM/u7LUBywlu5OhE3+0Mv+lTOXJmV+VSa3DbqNtkmc4MHz+HnAHkIh
	XwRRfqAFH3g67jipIx+ZxckRGbMU3/HBEW9+8+v1ghoe9Js0ojx/OMWV8Mq36EYcTfZTFDaLQLKkb
	aIm+tpzINDB0lvNQNWVlurVzicH4/pssnQLt3lsQmKREBawNcoCSICVeGSh5xmwl/C5FDXUrS4Pmb
	MBo/KZNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52yB-0000000H1Hl-1uUY;
	Fri, 11 Sep 2026 15:15:15 +0000
Date: Fri, 11 Sep 2026 08:15:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_spaceman: print configuration file for mounted
 filesystems
Message-ID: <aqQbAyk9RtbgOIas@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910603.4047311.12837558814877841635.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910603.4047311.12837558814877841635.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

