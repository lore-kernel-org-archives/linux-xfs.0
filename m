Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCD23CB907
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475120; cv=none; b=dZshIG0qJzKZ5/ZyAYv5+AnB0rvAF9CqEEklZQBdLlsy6qaIUHRGlwN4eUz1qYZb4oq0sajLtCHGjsTIKIP9mkdQRcLf1s2p1l2RK2+5PLwbYV8Pw4czSmvF/QqIJA7QD37ah/Doy2lvWGqIc9JSvfVqWcv85FdcUtwqzPBMLIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475120; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJg8JUtCgAAZaDmydDMxj0/SeQ9+0JnL5JhXK+svg7wlCURkh6LDB2uLRZCU/WezfXgAa0+bhSXg3Br54EZQFqwCpaCtzizW+mlPNUpVZeXKbpD41FdmkxNvMJehxTpKS7u9xfFj1eE4K5yjmTNSkowJ+uRkNow+56itZxpxuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4yD/jj8Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4yD/jj8Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4yD/jj8QBLSa9S60s+Dn8W76UD
	okkyhom785hOaoUzEoDcBatHORb0yquGV7S5ZQ/6l42+NSVEkIAduclAgjJA8wqqu6B3XS3wHJT1M
	RWXze6y1kbGy2tx/8lqChAM0/pCawuAO4M2Wjq6G++Y87fWyRGDpKilv5VDn1gbQ+7sXPvHQZedez
	29oTlFNpPVToXgkllxE1zf+aF0U7lRC14dSQyJEAo9kTozKBK3VkGgL1OUptE2NDpM9rygAqsdNVM
	OviNi37L1mMSclq1qhfwPE0Yr4xdWA/64ERd2mIQAsxBdDozEoXPzFMj4GpVFC3UOSOCrxBaJxLwr
	XyLBNNeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SDs-00000006U8m-3gHn;
	Tue, 15 Sep 2026 12:25:16 +0000
Date: Tue, 15 Sep 2026 05:25:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] libfrog: clean up xfsquotactl a little bit
Message-ID: <aqk5LLr9CiRze79H@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484843.2108717.10271335394491802697.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484843.2108717.10271335394491802697.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
