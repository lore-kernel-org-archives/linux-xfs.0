Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875C74594A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661056; cv=none; b=ilAuZKzwoBWZAH2ZfiSp1Jhu9BOryo0EIOcq+6/yGL/LZquAeF093d9KmV/c5hcXBSPBo7dh+bj2V9USRdmXkMdVIFE5wNASJaujvenMmve0isls39ooik99hk78kgj9kSsIHPIpNGN/vh1fH9AbX9Kk7aap1bwhsDZksjcy5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661056; c=relaxed/simple;
	bh=2Pgj21kGGIGKFH4TygD7cQLgGCJ2sUMQpOi15zXMm+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teBKok3TxbyvNTvm8ck89FmIec2l8eIYd9io8AuwH5o3ZTKwMlLL61WMU50Z8coxK2boA4b+kmwpA1WA629nWrgMo89m1jAI7vAPL0t1lMswoAf6JZxxN4S/bLAs8XIqpSe3KEVyaGZQjVK569NS0Pm2s2GpCF80RfX8SauOgsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BKdFH3sd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BKdFH3sd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XVPjD1mgyzr/1JfpMat8dyaNxCYp058B/ZHKlXv36CQ=; b=BKdFH3sdGz7c8BHPQq9JCcF4NX
	6W4pKxgR7tr+6uqWr4yYrYSKp3bE16kV8NborKf2/3MN8P/2KgAFJ2BMS38K0rP1jSi4p9zaiHN3P
	F56jzGk+BxZ1XR7ZX1CHQAMIs2j9Tts7pXAznq3V0LoCzczfosz8CiKTfiE605yW2C8Q+jikKjCGH
	/8vDgh20PeZTgHkGWO7PJv9WCeTZSEvQtyF7FfZxlOPvfsQDCdsy3P8Je+aSoY3juQetGYNM2NJO1
	+xP7KXLyuLcykYupkUw20z5P9lwaRCkHPhgoB/fJt8fFsOF020X8Q6Sm3IlfhZAjtdt5LtvSmgojk
	FYHiRT/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQKx3-00000004xmg-3hS5;
	Tue, 02 Dec 2025 07:37:33 +0000
Date: Mon, 1 Dec 2025 23:37:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxfs: fix build warnings
Message-ID: <aS6XPWlc3vBM0hPr@infradead.org>
References: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
 <176463876118.839737.7691382070128152874.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176463876118.839737.7691382070128152874.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 01, 2025 at 05:27:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> gcc 14.2 with all the warnings turn on complains about missing
> prototypes for these two functions:

I would have expected a lot more warnings from that in xfsprogs..

But the change itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

