Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42583A28D
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724392705; cv=none; b=UMgnzAvIJIjY+DYIEQPuIS5yZdhp+PM+FwD/MWj3rRdPTYr7w19EBW1CzOsubjdjno/Vl2E5jw4GvIO98jJgYA2abSCzlGqcj0UBhXGikFdVyOw3SrCtVOz9Om0S5zfxUVYImI4ElhinyOhAv68Pfq7qBg1qwKtIZHW/coeOm1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724392705; c=relaxed/simple;
	bh=GLdmltoOnwNDdeXrUcc/837ggbIBuZmXNVQlW6dDPz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgGSdpjhuSIe22KtpHhRWuGQ+9lc5Es2QgeS0xZZNx5lckfLyBngbfKpvPcLhhYhZEZeGSM7d+sALShbPJbnoc+tO3fyHkvbHwCgdi/pDcnUpUVoGIIO57VyvbCRPFHnbKC1BM/WK/PbdInpYjF6t1MKkjVfiYQoMmLvFrdD+Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j6K4C7sp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j6K4C7sp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nw4xWaGJp3nxcE0Zlnxhmkjuv6gWjC7Q2H0rsSzUypc=; b=j6K4C7spJzmlM0kI1Sjgvp2znf
	5fIBGssSmyYqmw0VbJNqaovE/yMX0Q+ID4HVe7Ab7EZ2VjzuTwImm7DBwe9f7PAkQ9HGn5VTDkBBl
	oLMINljUrH/O3YgyHKoSPhtMJVTtz/j/FABfyDq3Tui+JQYp6MF40ZnbH0hsIF+rzGwNErnevP+8Z
	iXHwG9TGtDKVsJbiKPuJ7ncbEz30Scaogf4y0Oc45Ev0RohwsAI+RYF1V4WB6XyKXiE94/X9dgrHF
	MonG3Q6rGexd2h81MLQLfIPyEUng18HtLhIzpCRmQOxpCq29g4JidF16KUdPvf+7SGbQ9N5HVJAnq
	2+17uRFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shNJX-0000000FO7A-1vWc;
	Fri, 23 Aug 2024 05:58:23 +0000
Date: Thu, 22 Aug 2024 22:58:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: enable metadata directory feature
Message-ID: <Zsgk_5jBdVVxpaPq@infradead.org>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089467.61495.6398228533025859603.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089467.61495.6398228533025859603.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:29:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enable the metadata directory feature.

Maybe put in just a little bit more information.  E.g.:

With this feature all metadata inodes are places in the metadata
directory and no sb root metadata except for the metadir itself it left.

The RT device is now shared into a number of rtgroups, where 0 rtgroups
mean that no RT extents are supported, and the traditional XFS stub
RT bitmap and summary inodes don't exist, while a single rtgroup gives
roughly identical behavior to the traditional RT setup, just with
checksummed and self identifying metadata.

For quota the quota options are read from the superblock unless
explicitly overridden.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

