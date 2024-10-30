Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D768192597
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 04:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262915; cv=none; b=PfaXsip1gmjpMg5WO2ywjTJ+lG5WObDdlx/8BU9+fr6ZXrziMtUqn+RxXnBZC0uckRkP5Xn9s3tKg9r10s+k+fBml1mFo3elFIfrsK5+tm/0xroqCNOqkkml1BSYgJ9HFOLJiUYcc8S4l6WfLIkxH0NUQVwBHiXj78/0maqAoag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262915; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlBBSW5eT83C/rmCypoH4gtDQ6oSuiT0faC2yKTrisOqnJ8iip5kKnIOieCPyOpZnFxY+zrtn3n7kwgzG+HWWAzRxxLgUSHzcUJJVxpFGLJA2nA41bfbS6LvtlPDkYoYSy6UEqZhdkCiDov6QBCPbrTICNYhVoXRHpOR4SbVEFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E4jFtw9f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E4jFtw9f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=E4jFtw9fyjEPn+j4iLBo2wlT5I
	oFjBKEHNDgbm2mcPS4EiPkRekDHuwdzfFjcNIQp7c10xNhMzs3QSeNORmlF10BV5Ayqe1EZTifYm1
	IFDciA99MapgSxdpgiqnKyTjW0z3+jd9mT5+tO1LPcEC5KTF3n3tWXPZ6XYfr5mikVAULerKiqnoR
	3drj8Tyyz/2Jkae79XffNHERYMezBB6WBIMCpavPHwT11RwDzlaU0+uC2eHgUvyYbnCu/SyIotVZ6
	7euzQQVAzW5mrxyW+rW/wxtC5BzcLflgndTxhq1RBGmGIVwhVU5PGcOv5BeqJzgggFdpzCco0KVKn
	2Kep2piw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t60QL-0000000GgHx-175r;
	Wed, 30 Oct 2024 04:35:13 +0000
Date: Tue, 29 Oct 2024 21:35:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
Message-ID: <ZyG3gaO28rQeae9M@infradead.org>
References: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
 <173021673311.3128727.237498638164875250.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173021673311.3128727.237498638164875250.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

