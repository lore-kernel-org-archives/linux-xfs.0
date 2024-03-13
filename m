Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC9E54BCF
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367302; cv=none; b=IrzROchh/sDop7IfbTzKMfYOmzy2hNQtZ8E8nZ2v/XyitzzIpg1QKEslog975h29rwm+rK9tQcfOMNjnutdSqSygq74ZzGjjGM4wiqIhgCJtqCokNQC+vogLIHl64jK+/50szxrfwr5FZTbP/WVzR4j1LldO5JQAeCmxFagvOG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367302; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFuH2UyGXcwHN9rqH+PCDhE5+XTzpm6sqD3yhscDykGTsuQJxrbFVuWMwdZbYmn/KkJbduUbyLuEcq3+API4T0RsU+qPRZCOa+K6zBcgFhaXO+qno4BdWdduzcwk7G7JkK+wgGWIqKnR6Owla7mtoIEzCMtOek6uVkBTfeajOPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2Dfh71yF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2Dfh71yF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2Dfh71yF0Tw9mqxkYj47StYjNL
	jdDeDDGs7v3MfYVegm84AXg6JDrqiXnly3PZwsX1oT+faQTTzpYuz+CBwFi9e5mDoke2stary/C0q
	+RWv3KI4nvsYpCurO8bf2SeqQfiPdmmh+Y2lyD/Zm9YI5lLYVmCUwyMmrJOjfsrJupgaHRjAv2aaj
	U1yNCsplGLrF2ks/CudVl1WzDIfVWNKg22qpJDUlgMsqW63N1nYR/uoPzvyRhoJQTEE18zP+uXlii
	4pEMaPX9SoEoWSsf5sgUrY8zTaEGEG+re/+BSLt0f9ofddhHBTM7RHKHy0WOfwxVe2gYFSl+KmPsv
	br/bqgKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWfN-0000000C3vV-1RuX;
	Wed, 13 Mar 2024 22:01:41 +0000
Date: Wed, 13 Mar 2024 15:01:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs_{db,repair}: convert open-coded xfs_rtword_t
 pointer accesses to helper
Message-ID: <ZfIiRSjh_hVsQVZQ@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430672.2061422.3068891686655718546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430672.2061422.3068891686655718546.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
