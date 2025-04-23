Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C60263F2D
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 15:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423063; cv=none; b=Aj4KJ7R6XSo+Vl1DKQVyCargdfX1m65KSZz3etdFT4s0PgYXypF9fy0Yr3jicMG9CUK1CUdzpISow1ltiD6lfGS0Ug71Lr8lDjsy+qIz8latF/QUH6qO4tEnv7Xr9BI/8SopxFByTYVfuXWtYsCEYWt+JSeSf1+yx4Iy6vqafqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423063; c=relaxed/simple;
	bh=de+6NkosunfKdsYHF/y19+Bqi8DsqWnP00WGTHJCZFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDAu1o2egFOUofqITtp+sdZD6cuT06CoS4bF1I2RmHEAMg37onQ8ig7fRzyVWNntLmerZ4QwY5ICPAsWc4hULA5o1jvE6n3/W0IVubZEK93nB5lfaHqw2sXIkq2/U0tE2iicluj4r9KZbN3VstjqX3v/kH+KJvffs7VykPY/57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yG9Qnh/Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yG9Qnh/Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6oaLs/ZhV4q8jLVSinJfjOId2Sng7a5twmI3kSBKMhs=; b=yG9Qnh/ZqggWynrt169frfT1t3
	a/FY8izFa6Ws+MNWjdtGxrUVKLOnWGlbzJ/TaClR4QzAdJI1NFyjpt9efXgFnIgx2zktTm7w16fbr
	KW7nNEmWl0C60FbZ0k+bYauSMRqjCAiEa0slgQu6cBVH+RNLuX7NY7aCK1Gd2EpR1VqyfldoPbIm8
	Lj6g9N0x9MhT1cDXkCw7C/hT+4RayfowKluey8b+BVN921V4NkLfE/F3hapLHouoRBAmHbnQgdBtk
	/XtveqhNu5KTIXuAqAvKBtmiHpW95LNoW0tj4FJp3hlTZx1oh+9Xk++Oj9488naBHg7Ub+hoRJMeN
	wBvsa1Pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u7cGr-0000000B0Z6-3W2I;
	Wed, 23 Apr 2025 15:44:21 +0000
Date: Wed, 23 Apr 2025 08:44:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs_io: make statx mask parsing more generally useful
Message-ID: <aAkK1SGc0GYuk7yW@infradead.org>
References: <20250416052134.GB25675@frogsfrogsfrogs>
 <20250416052251.GC25675@frogsfrogsfrogs>
 <aAc1UtYb2HL3w5T_@infradead.org>
 <20250423153352.GF25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423153352.GF25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 23, 2025 at 08:33:52AM -0700, Darrick J. Wong wrote:
> Hrm.  Nothing in fstests uses it AFAICT so maybe we could just get rid
> of the -m option.  Or we could redefine "all" to map to ~1U so it
> actually does what that word means?

The latter sounds reasonable to me.

