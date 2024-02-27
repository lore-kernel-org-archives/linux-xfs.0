Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FEB1468E4
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709048997; cv=none; b=MrpUHjomm0H2IaLLCN7I0lVEHqmVDWiy+poOy7XHftmKsG12pFGIiU967nSr0ZMHobFlw76NcYc1I8fbWb3GEiQsawr2cf1Lj/H2pfnvfl+jdFo5Ss2OfjiLDTW1yANNO2rvnAc/IUvKbCroAjN1LUJnZHrkomYRlzv5gKe1ifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709048997; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueObAdzfoAik00fCr42nstOjUPRTIkmZEB3TAHgZgbkUs+cpU4a0g+ZOndlsnnOe9xe9o5oJ121BQ2Q+vRuVGqysEkF9Ahe2gMyztqOm0HFpamg+LP0TPu+gg/ey0uOi15Wvnr1irRh7+14nGqfT9/j9+kfsXzgwD/yN86ox+2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HqGeKO+r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HqGeKO+r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HqGeKO+rBL7dD2rq1fcNU8g6kb
	+wtJOpSxvSs2HU/wl6uwq1e/Cvrc4PJkSJkGcJYBhOCWHeI+iIbTyWPlUh+4lbk5PkhtseGyIubYD
	frxIQTNJ0eFnBu3IbfGOQOe/MJd/UkOgQ2W4HN6nU1iGOl6aTRZMxShnb+fVPQrymE0rAwKRIggFW
	rfPA/uRpvQmTTPxPZdlAF2coUY73yHeQ9MgAgIW4qZsorjuTxYSXuIHnKzf1yVsuPn9em3JQgKcR1
	wHPbFye+9h13JaeIFS9892ndwpWew5VbCwrc+tzzi5X2QHER7trRYOjL3T/OMRHnjpL1R806ZIRXC
	cR82PP1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reziO-00000005rBz-0pUD;
	Tue, 27 Feb 2024 15:49:56 +0000
Date: Tue, 27 Feb 2024 07:49:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] xfs: move xfs_iops.c declarations out of xfs_inode.h
Message-ID: <Zd4EpPOeJ0PKhieN@infradead.org>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011166.938068.15976644595631519866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011166.938068.15976644595631519866.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
