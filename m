Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B6C3BBD5
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244614; cv=none; b=WybUznNXyPyVfmXNr0zbHt7KmCEW1VA8tdLwl3BP1QLsktw2rPjubmWJT9jH35BhMpg6sugVyrlpYE3OmGnv15dYUrOlRd7jtNyqKDcHbqERvUp3Q4ZI5Y0qSElWRX+zkbKMZjOT0E+MizMx0+xZHoPhDuWGUXtiYk6D1pftk4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244614; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cc4aPRNb1xCf3BBOSEZ8BxncXKs+UFHBLFPv3I2OGjgp+NY9y7kyYXM/Iq2YxXBMKmIFg/W14W6JFT6GSWoPOll0GozJXQmDxa3x2MnivavNlWiswYmzsByi0fSCOc8gc9pEJidfPbER5Q+VmIK+Dh5+k8r4nz64QJcwcNo1pLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4thaG1yV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4thaG1yV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4thaG1yVl4BdGG2P7HMcNufFQA
	nwxpC3N0n5pcU75/+t+jkE6Bd5MJIKEksH2iqSyfDVmEmVOqDgG6LGXAfjW5f2jMB/lbuZRRAWyKs
	03I0uLH/6tVYxaOqfoVZSkqc9qpq1DL3xgJoDw8Y+W1kWCt69HvGXa0NDHMEjw1AaHb+XKF7+MDRv
	1XDp9npIaiHbmKshJOg22Ms5v7DocZGMGFVLFttKTlgDTrIiknAP+fyJ2k6/OxWsUMWJ+mb3oWOLL
	DQB7i34qtDx93iH84ZC0XpzGotU3HOCqmtvyTQQGjf+2v545ZHjTG5/d+Hev7Q17Kz8TN0T4QIm4x
	8jTnI2VQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbBc-0000000AvFf-1PUV;
	Tue, 16 Apr 2024 05:16:52 +0000
Date: Mon, 15 Apr 2024 22:16:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 09/31] xfs: create attr log item opcodes and formats for
 parent pointers
Message-ID: <Zh4JxKKjSlFkNApR@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323027932.251715.16939257031484099364.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323027932.251715.16939257031484099364.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
