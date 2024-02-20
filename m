Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549431E484
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 05:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708405469; cv=none; b=KP46RLTbjL9N4RK+t8qZ6p/o401BJYZ+ng0o1mwIhnxkDA6T/rwjQOV0b+hlptNmVoFn07dqwApnWHCuBX/Vg+2QT7AhKj3Hap4GeqMn3+sb9I8iky1/Msk2TV95Fd7/wwlmAPibQ7Qu+9xHjQRB5pmM9NXehBHgY8s0+Y995LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708405469; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0ebCgqjEDya5KfAOXCC8J2zszTo+LO8Kv+0GpUFLN5NZaxKa6ing/UZhWzB8SfT5wzg52q8FW0IZanbTGdMMJSp+tSDSHLVzBQ6z/vKe52ArD9nUjkeDuJ/ditlhscpIjk8mtkuc3N+z2n3UB0pGIRUwtmm5fcs7Jm0cppBylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mzf3aYfD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mzf3aYfD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Mzf3aYfD9/lSTtrqpypWxOsfkY
	WzWYu0XjblRxN9ew+DxCF/0SIMcIFQIaIIb8qr9H/MBSz2Z5E6fV/jU/QUftIg+l5/gbVJrnQqavz
	gSlmdpKp69PnniMW+4PKo5xT4nZf4Gah3a7FiXutvRSA2x3yKqF5LPW1BPaB7BCDKirK4xeBVeSZf
	MCwTzZvAGGvTlf95g6RJkXTmTQl/RN0/oJ72fwGNV9ZzwUoEU1PCf07u3BBSzK2bEEZYZZVS2F4Ua
	Nt5Yh0nbZ9xh2DVbZ8sw7w0w3ZzVWRAX4q8w2e/S9kZUWFRXTZWpHG8Jdy5FUsMbOPYWJkR3vcBhL
	ZAzRL5MQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcIIs-0000000DAPM-17Ct;
	Tue, 20 Feb 2024 05:04:26 +0000
Date: Mon, 19 Feb 2024 21:04:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: use kvfree() in xfs_ioc_attr_list()
Message-ID: <ZdQy2mE424siwVm7@infradead.org>
References: <20240220000923.4107684-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220000923.4107684-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
