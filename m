Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA0411187
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848228; cv=none; b=TSh9NWRiq1V1Bo/a/T8Pn6PEw8d7nBFKoLU0rFDGc+s62PR9q5cAFl2Zj1/1oeElyHnd7x9Ygm3+H6U2zJfiM9knGsJqzrXUsMhmIvPlgyrAYOyLvnsLGdwnYHj+5HlhGpKxggwmM89lVM0z9vxzyr6ksZ8xmCW7cSQwYsJR1vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848228; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBRkou8PVaY8A6kw1rjHn3LO+Spv/usY6IqjXCa98/6gMq6QFtK2Ua4GNHAKKPtR+PKpJGgBOmTPxSrSsTceEXto61QMKkfGor7NJu4LxOHYlhXCdANITT9peqZrfN9ib4yqjSxYX+F7bBL4WufwIuTeDbST+hwZB32v9b15vT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ikCrBfJK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ikCrBfJK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ikCrBfJKR1TtzdZIAM8ygTG77J
	V52u/2y9WHlugMfr0YpVmp2aUix8KtVlYRaOhnP5+RPniGGAr00fyRv92xOILXzG/DES9il5xc6xh
	HblPD4HMxokwAFi7Nd1wGOwFWjm65rV5qwWb9hPYWFAG8kwcAyUvZ5tqBWP4R/PuCMx58r5JLpDv1
	K1rtz5gqBQsKJWIrptZugN7N0Gjd3+9pHX0/vq+QZGOp934qqO9YaI45k3uJt9vXntW84Ynt0vUY/
	tLef3ndNsUobMW4QSSbQ+KKUo1Sn/UTdfm2GEgqvkRW14lmTEtxRtTDGhmg1ey+UB2hpGoA+xIUuk
	zMV8WSYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsFm-00000004s0M-3C8q;
	Wed, 02 Oct 2024 05:50:26 +0000
Date: Tue, 1 Oct 2024 22:50:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/64] libxfs: backport inode init code from the kernel
Message-ID: <ZvzfIh9CsYwwZB-W@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783102052.4036371.16066393511881832802.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783102052.4036371.16066393511881832802.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

