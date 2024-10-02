Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3E917996
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848098; cv=none; b=XKDMNFyND543oLF1l5Ch+MIB5g/vspuZB8z/9cWSjj8JcU+d7ZGBg7TRVKMYUWi6VlZxm2FuAviz57JDIdJ7NK9ssBnhV3OtnVDVjaNSMFk7p59NiLi513i6ef3BjiJpRisg4HoumWK0TOq2zt7B4kpojrQpVK1GtN7j0bopwCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848098; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7OtsG3YmqmLeDjnmHd9pL4XAodJPAsevjszcw2P3htP7KZhAYmSp0pcLEDf1n6FN+c1EsnwRYD9C0fvcxMGyBpgdh7t4+viRVhSwoDtaPirhFBfFHV7ub6LAlqdI2+u1fqVkyCUHY1fyH4FjBtXiEq3Jp1yjjoVaWzimFwc24s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B0CLbc3h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0CLbc3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=B0CLbc3h29t8F6TXvsUH9DEl2/
	9bDJLvGGZJo2Hpfmta3Md2O95PdkMN9KRwsXnVbkfHfPLQaRshUtyf2pfuqiPw0zDot6Xrn/uq+IK
	LYvb2aqo68exHqnx9XykErB6pnPh7zv/rITOe+d1uR96lVi1I1NH79YXhZtgf0q6cMzxLqNzQVTzd
	bxFmWdygredMp24G/j+DQWV2yKiwYHRyISWatx+QQBVMjrnvcSaEX3o8JCuih+Kz/sBAvzeAIRH4g
	9nqA6q6VXtjrWpW2BeJL+/irQC8nazAtnn5NgrFi94ggMu6X2VvTjmmDilcrOT38cPv70XHKDEVy7
	xNSBgl1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsDh-00000004rnp-0XPQ;
	Wed, 02 Oct 2024 05:48:17 +0000
Date: Tue, 1 Oct 2024 22:48:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/64] libxfs: rearrange libxfs_trans_ichgtime call when
 creating inodes
Message-ID: <ZvzeoZxmzcXF_6Gc@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783101962.4036371.5415910489198519953.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783101962.4036371.5415910489198519953.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

