Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558CB16C6A7;
	Thu,  3 Oct 2024 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727957434; cv=none; b=SKiCYne57MGUX8VPTdsYy6inLmkhPNWWJh7rFm9B3dcWWP3rtyRTw7mH7DskDaNDEF7XtT5oC2zH1UGN5F+OYVWW6oxFJacPPgi4i62SCJmDWaVMctxelDOFRqpJ7xz0D01zuDSOneBMChBUcsvHSqgyOxExqkXnHfDX70pV100=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727957434; c=relaxed/simple;
	bh=OWlwSTuz71Q7lD4aIdVYhZWH4N4lAcwbMk82xUp7i8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSf5xR27hrQw9IQMWKnPEjB+Ue958p1Hbx5ZsIy579OylTYmCCta+3zgX7n17En9C4E1JgJomSRqYCiCgJQXk5pykvD/BhhuMyCfbDJPOsNIVsFuGhkHjTta+yQQJVfwMdiBmwN2yYdIq+tI6H8YSoq44BZCCRLxVTnEhuEmDUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QXnXY4Bz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QXnXY4Bz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Iw9Wy/uWYzSU1EZsoJQN6CDEZza24jejh7Gtsxza4zI=; b=QXnXY4BzSN69w+kWMmh1Q+0PUT
	hFeQLaNvJhbgdov7XC/scDfxX/uC/tsfn1wW7GEd3uhMz5LIAi+NwwGxysQbAz2h2Pemt/L8GXF22
	B55QADcFLpnJZbNfKQ5Pl1+fPpfeHORKc37/yfm/zUgmrYEl+8LUu+NiXgVL+cnMWcnNXwdNnwR3y
	eing0tzox/28gBVdV2Eeexv7dUR7lYx3ONOGWh4zq+72YFkJo2g/ImVeYw6EsEedLwu9DBB//93GR
	L8DrFciHPmyiFbjgIWPFFH/7DWPQzvghYuHHgsTUF1Ra/9C4JnncDwyXg7Igu9GftVLaM4Lhrzhiy
	nFY/UZsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1swKfA-00000008yx6-3Vq6;
	Thu, 03 Oct 2024 12:10:32 +0000
Date: Thu, 3 Oct 2024 05:10:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/122: add tests for commitrange structures
Message-ID: <Zv6JuEeS4F-B5efx@infradead.org>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
 <ZvzeDhbIUPEHCP2D@infradead.org>
 <20241002224700.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002224700.GG21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 02, 2024 at 03:47:00PM -0700, Darrick J. Wong wrote:
> Oh right, we had a plan to autotranslate the xfs/122 stuff to
> xfs_ondisk.h didn't we... I'll put that back on my list.

xfs_ondisk.h should be fully covered.  You pointed out that were
are missing ioctls, though.  Let me find some time to add those
as well.

