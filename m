Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC2E3168EE
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 09:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230914; cv=none; b=Dkw3D4eB5eEEHuaLulgzNeMqR/6CWhvq9ySvB5vVMKMCsTjhuiCgxQo3Cr21Fl+jy9PpMuahBckRdltWw0g2kcsKqatXnOUNmgob2BHb/0GvLiDiDQjuUtEuY1yOplFO33+BCck6BknKYG68fXmFDqYXrrsInY9iMJsunqbj3rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230914; c=relaxed/simple;
	bh=vQuctvHJ72X+Ax4sEyviiRsIerknm14no7i23ZndGzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2R7JP/rZK+FvfWHMdsQ3rNScPCiQVAESrsV4erHLiWDF9AB+Xf67MHZ3tyBG/o33D7Pv1LcxdM3QvWDWVFsrhsoiwB5OEVK2mkPV3y3/9FJujRQc6/vYwCiX6VDT35MRPdc+qdRiFUdwr2n4Mv8C9Ciri74vW237MoOe1gh+qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gk+Ic+ib; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gk+Ic+ib"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dwLQDosf8Iy1boq0V20zzVqK3Z9UsPt1Ulh1CSJqieQ=; b=Gk+Ic+ibIcXvClzIcJuqA7TLvT
	wsDnjoineXAs5MNIyt92TJKqlL1k2vMTx+Ba1I4RpQXV9rwxK0d+p9v69o3wpKlaaeCVlffgQVWZ0
	78MYSlFI5WckBvaBer2aZGW6L4iWdMVW02ixR7HXnW8kcizuF3DTbB/hBA5GM46FsG1kI7NE4LA7Z
	BLNlMAqJUcCRmzr+JsfjS2k8wG7URKK0s5VWBPsGaQ66BLBVNVXKGieaS+cFpkjVRSNeMdELLwHA6
	Zt6WzEibaaHvOESX8gEevlBqHuMq94F9Ojge/gNYwGwpc7IOVGB+51dLN1fabQ70N2jcUZwa4390h
	M84HEB4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLH5i-000000063sT-1Kjc;
	Fri, 08 May 2026 09:01:50 +0000
Date: Fri, 8 May 2026 02:01:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v4 1/2] xfs: add xfs_bmap_alloc_or_convert_range function
Message-ID: <af2mfgd0DQTbAahK@infradead.org>
References: <20260501112026.673609-1-p.raghav@samsung.com>
 <20260501112026.673609-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501112026.673609-2-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> I feel like xfs_bmap_alloc_or_convert_range() has become a bit big and
> logic repeated, should we rethink of going back to the original solution? [1]
> 
> [1] https://lore.kernel.org/linux-xfs/20260310194245.848034-2-lukas@herbolt.com/

Looking at the changes here there is almost no shared logic between
the two uses, which doesn't make core "sharing" look useful when there
is nothing left to share.

