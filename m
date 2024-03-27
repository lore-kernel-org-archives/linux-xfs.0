Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD6858AD0;
	Wed, 27 Mar 2024 11:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539133; cv=none; b=MVCFsYvjPPGi+xUfwyttv88pjLFPUqnv0pI5HkvveOntB8emWcYZsmu3JK/3wi58Q/Bxox+b2T8nLLwtOffw+e0t0/p094lR0jFz++EI2aVGX9wS5yE5cZ16JLkNVuPcXop28B1saoG1YvRv+V8jq8Cocao7QEJirqO23tmUmws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539133; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzJT6bcYTDDui/jk93crPyR8ItVS+8ktmAVPhPgVKeMpEXaDRrttoMYwDFMF/5wN57z+mWC8dw+E8JgAdS0Lw6ghp+AvvKx6PimW537MS4I1uYtQMYDZWawkhaLpu/1m/GDoSo66/GWfNHJkHgO3dgrTiWj9lXS253mC1qYc56k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u0dzTLHg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u0dzTLHg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=u0dzTLHgYeb7sEpO6XicsTmbmE
	luyyaJR7FzBVXjBVCm/88YHq4ECneXREkjaLye35LUr6uJ2PgKvqDVIzKXvlYe6BhDqFNRGmUjYiO
	KmUCL0MZukcTCGWanigAL/N8OiLIOB5Dx725MldmLCUidfiOVWy4Php+bW9qrQtasTylVVxlQ+0TJ
	+hPK7OIRrpQrpC9XW0CF0WeQY6RBFeGM6iGt+QijpBzZk/4qOPVrV1AeCfDCOVBFAxUlU2SbpApQE
	z8DxRXcm3ZgdI+BMqZ+bbFnZ5sdtYknX1cdnWno7kC1KzfUdsURHkALKNqV+ajj1QBRDrPRQ6yu3G
	9a8v8Xmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRVp-00000008crn-2I7i;
	Wed, 27 Mar 2024 11:32:09 +0000
Date: Wed, 27 Mar 2024 04:32:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH v1.1 1/4] xfs/270: fix rocompat regex
Message-ID: <ZgQDudQZl6B1-C8i@infradead.org>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150740360.3286541.8931841089205728326.stgit@frogsfrogsfrogs>
 <20240327024852.GV6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327024852.GV6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
