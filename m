Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E53A9474
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893113; cv=none; b=GdShiJdXFxr4ZdLGiIjReaEUJJDzZlNqfO7h1Kde7Vec7lWl2ZUWnsXVxika3/P/01M7Q2C7nLEWKYF91ETe2c6rPD0wvJGImVzE0KDK6g6N9C/AQ6t+CGwKwhL9ovlsb4XTavY0zq2VmHknwEbc7PXUJsEDUnZmPcYWxNl9TqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893113; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr8grDlJi3YLbqiV8I4rdb4gUtgbyVeWyHdAuwMWYySg7X/pqR7AksyX2yBvzQs8tgM9jike7nz+179Atckl7Aj1RPE18BgJiJem5OgdHaXVrlJ/bVeUnn70zPI0k0HyC1PAJREh/O54xrjxCIwzdujSz0kklfJ0rOwlPbCOE4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LOuX5oY2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LOuX5oY2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LOuX5oY2P03M4LukFYLI7xG7uI
	nAKTFEmzMAtgwaFl/NvY35von5bAUBOxm/AGvNdAc0nxUCyQztePOF08p7mBro3pt0+4mFeZMVAiA
	hlK+4GnPeBQtbvXdc9QflVvNGe0a/jpr7TcEUPpMm+BWlB1OSTC1+anysB2TdYXIKWX3y9Zhj61Jg
	CslaxEZR/V7/GdPp7n9PRjxPpqtobp8YejJdkZgH9ySE65YjbFG3agLTGkfWzgCvN/Ls+q8v3DiSE
	54X379mpJtai3Lnj02WRk5qmQPUdKbgFGMQM+YsD2Fcj+MO6pYuhHVHHTNDECTQ1g2wsp7emNERET
	2G7mzB4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0G4m-00000004CDI-1580;
	Mon, 14 Oct 2024 08:05:12 +0000
Date: Mon, 14 Oct 2024 01:05:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 27/36] xfs: create helpers to deal with rounding
 xfs_fileoff_t to rtx boundaries
Message-ID: <ZwzQuL_HjsBFHgat@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644707.4178701.6278873000359043020.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644707.4178701.6278873000359043020.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

