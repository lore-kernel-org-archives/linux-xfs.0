Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95E612C475;
	Wed,  7 Aug 2024 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047269; cv=none; b=m+yPbmmt8RjOAlzz1/FneA+rAxFuk+zhY1MBkg6OHnjU1tEbfgtqtoTm33ojhPY+6R7LWiStSwCq3oOt6Mpl0xhkEaxHcPLr4ADkFdgb3JaucuYJ2H8krG2hdUBkaybCh/ybNsNcPFu6FI6ZCKZzFoCAAbBFUe7r3EW3PimTOaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047269; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9XZnP0mkt7HTHcT2qCw1MPAPHXZ3nsnqI5+V8f/Z5Gp6md0TCGlvlLEI4UbsC2gG5Yq7T7i+CICT2LsZLpfCDR+ttN+gJCWsz2attah149iyS1vaXw71COaNMUcaw0NpmoPvKdH2jikCnCG6BhPKNikTx5OnjZZ5pcdIfowCgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dnRqr+11; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dnRqr+11"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dnRqr+11Ajk+YVms9GpX/K5jDC
	7mnqOrMP1jTNJBXaDQV6a9UPpLFmu6UKsEQ+9GcRsS6m3J3MwPfR28Iatsv1onKHsR2SnR5tD0UZj
	tqvr5nfQUmi5IwSM+/V+3JpQc18ayYaBVz+WOUAl115afYsmm384lK+yojjPJeptoyvtFS+PoSdrf
	vdOfyTIC9ioHmhnZgXdWDMmHL1WHXPsr0IunDLjbiEtJSFjHea528KXj24YD1GZ6Dli9zhYCuMF3t
	lmDePHQdctSzW41+KsWlovU2L95EXaSka/cgJNpXp2uIl9I2yEjCXIwOcwxPhmWfPQDXxr/lWv/RX
	GL7Ww+Qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbjIx-00000005dcH-18M7;
	Wed, 07 Aug 2024 16:14:27 +0000
Date: Wed, 7 Aug 2024 09:14:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test online repair when xfiles consists of THPs
Message-ID: <ZrOdY777-tGJImVH@infradead.org>
References: <20240806225523.GB623922@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806225523.GB623922@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

