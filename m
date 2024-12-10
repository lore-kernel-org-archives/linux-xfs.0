Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F196E433CA
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807742; cv=none; b=YzxQCSKDYXA/TdGUxyjJqRfCanGEPwAY93sn/XrnFjNU8NLyDuWJSbg7tCHCQOJiWuzM5yUXUvjb2pz0iIlVmOlYHDIW+T/unGI/cGBNGb4nHfmzT8JNIcuoboTKgCxxH8eC1j/jZcsqxVX9B8JmSU9zZz7/udg03m5jc6wV9ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807742; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nh14KfaTFiGrBEgjDJGOTV1J+QSE6u8/LIQ6rgrSyZqiwVFyesFHWT3vId5lm+VrylKY8lJdc3svW9ywKPPSIXHPTB/7+3mnulie+6DdOcyNoAYBdXDQQJQVoDf21gtD+7Z5WkDEx2ckxwvUx8ATFahD/fK8k2QtujK1KdFKoTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yldlMepR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yldlMepR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yldlMepR+qKhfRsoIg2UlOcc8F
	hTcnEdo8kBe3PZ9G0/7BwG95+fl3o3PZooekU8fuq2qMnef6YmfHy+77PHp64oWpynJiVsAyTzuSp
	Ts2wMTkZYmc5ZkRpQwBbqAo/+1Dj+ocqpcUpok/2vDtniM+vm0/O4BE1BMPewYm+rBpdEGZ6bwOk9
	uRZiDv8qTxFOkPRh/4L4iYPEZVR5cJn+gTumGzhGqD4CiKrghST5ZDHs03CNIEclhbettqPPJ9Aa/
	FjRlFPXWRzGFrL51wGKqYMBuixVgHQE4vMoAzRLBrRBNeSB4eBHLLWXzooAoBHbbJp3qutd3OiKKU
	GVCw+SHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsay-0000000AG7x-2uiS;
	Tue, 10 Dec 2024 05:15:40 +0000
Date: Mon, 9 Dec 2024 21:15:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/41] xfs_repair: check metadata inode flag
Message-ID: <Z1fOfKQTdxRL-LUm@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748649.122992.6460939534773270786.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748649.122992.6460939534773270786.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

