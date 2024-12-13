Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8834A21
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734069826; cv=none; b=h8DX2FryQRQlzEsJsCmYAzduFaNWOKWpSQ2l4gtADTIZDa62YueO59SWoxbbimeN0GTpyY9Urrl1WrKegCdRHDcoTl+Jf2oKYQ8Lb4aNDxao4j7VY9KQTdeEkc6Dg0rlC2LUbxSymQaSmlrQpLk/gu8RMQgTOM16+V5UTMd981U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734069826; c=relaxed/simple;
	bh=KupL+pDcYqWTL52l3lLf6zOBlGinvYyRttGL8ypH81g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gb4YMr4czuPdLv1jvHOVWH4shgIDhBPLYqJ4wJqa1kEGs3O67bWWkDZexMEza2KDGXCY26noVO0896uEUwYBaLD6Gj5zr2kcYsdyJcWo5G/X+WReTzq9G3IzgKHwMlz2vP3ze+CyCJYprkv7BMljUeVk5eqhwQTHXW8QqyV/9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zyoKu6aT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zyoKu6aT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gExojVDRyJlDVnDpIddnUrI/invtDQ9qJGWCuj3SyPQ=; b=zyoKu6aTFy5hf89zJV6ODm262p
	4xwJej79hLTqbX/YpiOWy1SC2muQ5lz/M6skmMZG7oh3ZDx3ORxaYjJyS+MMAy5H+WGMsjDRV+MJF
	CRnkSrpnzuFpjhRbdVMIHycwdls3G6c3flGvyHSJF7JTIHOXLgaVI56gP2nwP9lG4dwDdEVotGj0F
	HgaUupqdKJlmz2MRU405z6hxJ9rxCWIQ0wOGcwqmHItUcpV9WDHq89+NYmYoS0iTIeut8S0cIb1Mn
	CauUdaeMkY9W4b/ggI65aV+YJbeXR+NNax5kGaSOpPK9UAy8rsGYLaooihj2zDHgCNegALhmzzJk5
	6SabCSPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLym8-00000002pWe-1hP9;
	Fri, 13 Dec 2024 06:03:44 +0000
Date: Thu, 12 Dec 2024 22:03:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: tidy up xfs_iroot_realloc
Message-ID: <Z1vOQPX3-jTlMWRW@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122177.1180922.14038648509804731936.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122177.1180922.14038648509804731936.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 04:58:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Tidy up this function a bit before we start refactoring the memory
> handling and move the function to the bmbt code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

