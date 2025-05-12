Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5823BCEC
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063449; cv=none; b=hjKDDen/G5+0y14wo+JOImp0sOnUvUzZaBIfq+32UoMSWDXh7McSuTiycRMz0LCAF1iI/MffzYJVCs08UzXMj/FHsgb9b4PKzy293eRRhJDje1LK6DL/Rl4IL+B1wGdBj0VJOAaV2CwOtUdidWoCb01j1ZapgFcmndMD0wsdWHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063449; c=relaxed/simple;
	bh=AUiRwhQJMkp/COWpyA4DrRHijLQDYxQ24AGOGJZVZTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/VFSdN+7xVbsJY05BrOHdmrM3g5O3FrNBKH8qAfTiQYZLS6jvkEkikm6FGRTLXg0WMi32bopMRHkflLHihrMvF/cj5NJXNIpz9felV9xfNIMV29CBMv1tc1eJT+HImlTN6Oy6x+uAmKjGvZ3StbZotYx26vArYeW9szm5JLrZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AFB/6DP6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AFB/6DP6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=de2Of+uLxmkntcS9H4WQ4aEdc7CGcIXNtrM7GUOa+II=; b=AFB/6DP6hbtRfYPHS7unpQK+9d
	ncs4rhN5BFdx2ex6XRIy/LNRYfNXx2vMbKMbOjvey6fNmBZPwWZxnCrlQb/BJHYNzFU7+gSeYmw3e
	qM2HnD9Y2wbO5RC03vWCqLfn7Eil7sn3lx1Vc57rPxsGFQdeCaXHy4/llRConfWQXDtGDQFwZGCd1
	X9OHwK0UYZp/5fk7x5pbcib9Io4KK5SSu1Bw523ril27sFFPm6GajuYw7yU/acDwBEdj1FL9fKlqZ
	5PSbvNR86O1CLu8ruBBmz1Tjc4B7wUARi2Yc2Bn2QbOBs+NQyDXMSpEUkP8iF+L+C5g3mYSsOSdqL
	WuRCsDKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEV0h-00000009rZN-1Z5x;
	Mon, 12 May 2025 15:24:07 +0000
Date: Mon, 12 May 2025 08:24:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <aCISl_Y7vL4MX1LT@infradead.org>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
 <aCF6UHNzRqZaH2dK@infradead.org>
 <20250512151430.GF2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512151430.GF2701446@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 12, 2025 at 08:14:30AM -0700, Darrick J. Wong wrote:
> I agree, let's drop the pnfs warning since warts or not the code has
> been stable for a long time.  However, would you (hch) mind writing that
> patch since you're the author of xfs_pnfs.c and I've never even used it.

Sure, I'll take care of it.

