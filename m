Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9736268690
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 06:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804536; cv=none; b=uvQgxqROQdHVdd9Q3CneQy2L3FxmgQn//5tfKNCJN41sN01GRKizB2MtS0rdcvvSGW0czAcbXG+VUtht5aMNP+pYRGuewZmviGl97rsv00DF2HYnySO0zSI5GCT/rhH8LLb3BwdAZOsc4/C4AaY5hCxMujcH3nhBsIrS0aPWQZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804536; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrRGiZfBQBqQwsFHdPcVqPZngORhSFaNRfifxAuMKDIZ1Z6NtBexniiYYEVaVTDmPZJGbJnMA+hquYmWm96C+b6vBkQ1nuH2s969vd6bVuGoh4y8RnYLFPW3Y2YlPfV6oVn1gv4UH2ciUJ0lQYL1ZaOi10NW9+wWZG8mRtEdfd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jotOxTEl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jotOxTEl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jotOxTElAkgFEzD37uRH6n63PO
	syK5Y089kPtG07uhbp5Lc8QSAe6plDCQvtk2y/sRmtxuHsLWpkGC5bdVa2NjRkTKvcQr6fs2fw/QE
	g0dtP1luasW5ENGR0zrEW6FQo/KRxNd8NZb+MWg2HVodlP14KkvYdTcYr3l33ImpHyAE3mNJGu1YQ
	E6LftpXyIVMFq8WdkhLDfUKuG5bRe5ZnVXNWqwKTEuAbmTTILyQn4PxP30pgGvvjOtdPOCa9dyazc
	0j3g56IRtEoFQLWmq5CFcQSe9omG07WjwNUczufEtMi94UMk9q5asUUA732UdKKoZg8qXwqifa69l
	gSNkYCtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhirP-00000001PM9-1g7p;
	Mon, 19 Jan 2026 06:35:35 +0000
Date: Sun, 18 Jan 2026 22:35:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Wenwu Hou <hwenwur@gmail.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dchinner@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v2] xfs: fix incorrect context handling in xfs_trans_roll
Message-ID: <aW3QtzxYPU8TKlu0@infradead.org>
References: <20260117065243.42955-1-hwenwur@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117065243.42955-1-hwenwur@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

