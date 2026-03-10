Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E614E2773D8
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134720; cv=none; b=arjJQwhHIjLBiFjmsBb0Kc78qSug1f+U/ilofcaouKNdan+PQYKdvuVF1TmkdUT7sL1RtsfCLx1mNX5JBco3Y+eVRHGmSJJM1piVGGCW7ClH9SG8UMeeWD3NU3wJ39p8WKHt/v1DRjNG2sFoVt8QHQHTl7nLSnltsgIxTV1AoxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134720; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZsafXUC0ymYQ5F/EzpqTmFuugWkNygtVVCaa8GQRi+t0JkQVrcDlPXH3YAFnKqXzQZuolCPq7w14SCSEPvTJGKt5NLR01OqHZRgL1syu7hTPaY+bUXlDneBP+Bmd5xqWrDb2Lc+aFpFdoNny2pCJRRRjzp+QcaGJ5UtTLbsMB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0aQJTz/p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0aQJTz/p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0aQJTz/pjW2OozZ53PWDVWYbMR
	gwjO5MchYbTA9lYYTdz0CFUbTe9DGtAYuPUKK4zq9OYOUpXhQZBOQoWe3EjvK4ZkR9BkBnUA4FTKx
	RVGaVPqW4IKMNRUvSkakAjwdj/kK/vi7h5gCaM2l7Y9rxuNLFHhZQ3m8Zra6RzhTqAbIkoWbLBAaN
	VEfWyEvTILcduZDaS3FiSsyMRNdc8dHIzrkBy62HoHWFBF+yXYqow22vPmXoB3s0+UGss/gTQM09l
	dRHjtWCWaZ79fmKRHgUq6+Lr/3FoBWuwnS1P07n1SLgdPvZwFD1dTR0cYC1m0CUmuLe5xbtOdLTAy
	PcRdkiEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztL4-000000095FI-2BZ1;
	Tue, 10 Mar 2026 09:25:18 +0000
Date: Tue, 10 Mar 2026 02:25:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/28] xfs_healer: create a per-mount background
 monitoring service
Message-ID: <aa_jfukpOcDvIwhP@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401699.1183235.9490037199059236561.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401699.1183235.9490037199059236561.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

