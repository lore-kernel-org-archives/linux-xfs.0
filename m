Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D748C3E1
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553254; cv=none; b=rbwEwpdd/Pl7EmKKBMTcXzPcYGYhZCYggCKbNcCE2aKzkUY/Fm8URrr39zaMitosur1kq0uB3R53eFA/KYBpuHX3t6LzTKrFGGtULOrYtn2kknEs4ZqqImbIMnxgGd5YBfikPHR0oTbEgnnDZwqoLM63etRt9rkRLq7R4iKe9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553254; c=relaxed/simple;
	bh=Cqr7cSXTpyXHpPEOpqFHpUXIOGN75WTLJfsZ+Ax7aww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oS/Gbgp16YxxlANDf3E4A94BMC7XDsezxD75su0AgZZnaJncEqUBjeeeN2RGl98vG9U9j+XPMSs5VnMY7FUjBcBkIldXbZLjUqbnbfF80vLK1lDQQ5uyUg/91HbC5L8x3FGsAzYJYfDnrIgDVei2PUo420dIsr3WqX8HUUYx/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pqsl2+m8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pqsl2+m8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qx4n7XhywtpA030gKIKXspsOT23OsXlF0Iici/tCMsw=; b=Pqsl2+m8P5QJabGiqP+DJWE9rr
	P/Vs3PRNMXI88RlP1Zvu6fP3FYJRjbtc1cda3jNuYtnFtc12QpFBCW3Fy8Z6QLUFiSaGtl1QVqlck
	3LfU539k+57xicJNweYwBNss4tkS7YQwqI/rs6cOVi8qEiB6D378AldH0xTQ9XzOAbBOdCKjpIGDg
	DMWHRPOOnK27fWDbO2zwIJ9q534QPIv/C3Lh1VCcsD46rO9c9YHuQK+xXPidouw7LvNKlvNYfuEsg
	aC7WhT0YA7BCrgP/fSnd+rnzLtUbsM1st0+yPpK/+rA04MaMXi24wPBuiy1qMMpd2pAbdcS9shzxG
	rSSwiE7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS4a-0000000FTbA-1oHz;
	Tue, 03 Mar 2026 15:54:12 +0000
Date: Tue, 3 Mar 2026 07:54:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs_scrub: perform media scanning of the log region
Message-ID: <aacEJOUyAEx9bem_@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783674.482027.12478934497941662983.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783674.482027.12478934497941662983.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:39:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Scan the log area for media errors because a defect in a region could
> prevent the user from being able to perform log recovery.

Looks good.  Not that we really could do anything here..

Reviewed-by: Christoph Hellwig <hch@lst.de>
