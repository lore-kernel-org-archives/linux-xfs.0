Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EA8762F7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885837; cv=none; b=pD3daJLugCVoxe5Akw4xJhCwiBganTulEwu1DErrrvp9zIgVrfZH/SEy1g8Cw1vVxwazDLXFYrEZKmTeI7s6/RuPUbjJaVMzVHSZFqHEueEeV3FaRyC2iBSa0jk21EpxJ2jKWuF1e9cPXXRDT3puOUXYzLdCpeJQRnQtbuEoBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885837; c=relaxed/simple;
	bh=YiJIEcW3E2HBSbCUZ0hBWJRAfpubi2wu9Vh68gGLS6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHlb2jdwHcM66wlMYa15ctjL+Ato6rZwq7uZtMAdEucbIi//+Or56XJNOz17LbPo4myOJUt++btfchhXIQRl0mH1TbtTdwtsQ7O62U4kQZM9yig7nBCTkMRBCC4z3lxgKqMZt20FepPOrqWYjcgmWZAw3S/8zpJmbiFlMIetzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iStpUo6l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iStpUo6l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1SQhDy4HkftXoFYK1E+eT8gBd3gUJGSK7PM9+zMSIb8=; b=iStpUo6lSc08yJWztykXLKJcQm
	JR9yisI/Ph1FRrxsM+9HVyeDeZTWxHTHKmS3U8C7M9NnyQV4uS/jlPWAh7xBDTKIWUI/eDmA+wrUT
	0F/9W+Hop/5GdsVC64kL/Kz2UmIhD6/iSVBM9Vy+8NwZfrwryXznFfusn0hfIU595W4Z5yGoZTT4T
	xdODHK/G/ngZNY01sIjRHajG3VXyqVjjNkPvvM3Icz3JDk4EuLA6+b3OagdkXHMMQItXm7P9d6ssg
	N4o4CKS2MmtlpEzHztsoRakJeZgaN5gvMrGtODtD7OBvgASqLibffPrXPvDO2Au3vLwbw5EnUGA4Y
	Ys2V9EPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0EBP-00000003pUp-2rCt;
	Mon, 14 Oct 2024 06:03:55 +0000
Date: Sun, 13 Oct 2024 23:03:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <Zwy0S3hyj2bCYTwg@infradead.org>
References: <20241011182407.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011182407.GC21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Check this with every kernel and userspace build, so we can drop the
> nonsense in xfs/122.  Roughly drafted with:

Is ondisk.h the right file for checks on ioctl structures?  Otherwise
looks good.

