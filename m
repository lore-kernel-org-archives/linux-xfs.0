Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9756348F01F;
	Mon, 12 Oct 2026 13:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810508; cv=none; b=AT0xhewhUFqxyC6XdEdb2TmaVdjMYmR49jGFG0lGwOUWM/fqVNpmQBfNQ9dFIhr4UMSIxZ0lEsY2LMB1s+bo4vHr3Se3faskXYCpywanN3TS+vEYTiCNWipj9UpffhEZd/eQI4z1arGGJk7WDazX+3vRV8VdLyGEbsZZmZl2Z2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810508; c=relaxed/simple;
	bh=7Ig+Poq+5wda5g6ws2BxxQe7FBWDwkbTkLftSvJRRoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOzPRqUNOUUuSbgi6jEq4iCgLQW1kvd+m8WXafMiVo5xPPZ1ifwCttRDLJjZNKJ3fHnCzCgOIkM9CPUILBlxfMe8WcrFFFA35Yjjf+uJFvubXFjdJreLwRgsXs6NYNF1oCW1N84Bikeui6ApEl8a+u15ZKgrBb+h5hbesIHPW+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vBr6KNqO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vBr6KNqO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4la8eLCSCO4DOS+mGc1iihfaF5wnPh23jAzM46Ai/9w=; b=vBr6KNqOFnYa4LGh1/B/D3EemY
	UZaE02XHsO2BR9aRYUMAKlEYmDvzpxCUWWOyjAb6ji5GHSWDPDZV7YW84hXBEwRHBR+mgRCmEWF6m
	/rsQIg/Ggx84H8YxJ6OVt6wF7Tu5G2Xe7hVAbF5tVJV3dpbXEz8g1PTwae9+8v/wxzsZfGwyTMBWX
	VkbsoJGIINTfe5BCyz8MRF0+er1fWjO+jtJh+mYJBm3+BqituArwo2KSqUusyouCoK8S4XGC/g6Ck
	8nDysdLqHDjz9FPRGryEoodwWq5u+cc4qJWSU6VeBcFli99ti1bXf/siIgpai2GZsCMa3Apie6E+X
	39FF1vdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFlT-0000000AX3i-0z4R;
	Mon, 12 Oct 2026 13:08:27 +0000
Date: Mon, 12 Oct 2026 06:08:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: don't queue rmap update twice when reaping a
 fork
Message-ID: <aszby6lVRHVx3cwW@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065302.1058326.9913406199036939572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065302.1058326.9913406199036939572.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:57:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_reap_bmapi_iter calls xfs_bmap_unmap_extent and
> xfs_rmap_unmap_extent to remove a mapping from a file fork and its
> reverse mapping.  However, xfs_bmap_del_extent_real also queues a
> deferred rmap removal log item, which means that we incorrectly queue
> two rmap removal operations.  Fix that by removing the extra call and
> updating the comment to mention this subtlety that I forgot, having
> written the code. :P

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
