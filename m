Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D94376E0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389176; cv=none; b=DShde6hS0FrNxNtUV5JEqG879bpVjkcXjEFHsQGARU7ro1GnqTyrS0oallzJ0aEBbjOuE8Hh/v0z3hYzW4/3rUZgaw3POwtMeUDQZegTESrKpy3WNKSQhety2L56HYZxgTpaMB1Ps2gYA97DILXku8wCwQ7Rtl6ieFbMwk9+Vt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389176; c=relaxed/simple;
	bh=8i0Pgmk5gEcEhjy5WH9IaUbczDKTjsdIxeTtFQ/tzwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5lPei6b9xOT2DfPT2NgFHLUQMtnHT8koaTwSW6bhDtaHFRfb6RFKqrt0pgmA0UJF2Wlx6WhPbq/FYqW3OmGGFHeKKMB65TzyawJmFCowPqD3bElxH41BBAVyT6O0WG089fo/VHTOfYzP0Up4NogcIuOHX/grXZ3+7Xc2xh2vN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y3SjsUqX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y3SjsUqX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8i0Pgmk5gEcEhjy5WH9IaUbczDKTjsdIxeTtFQ/tzwo=; b=Y3SjsUqXTMWoWWihwWQ0kW7zB6
	FXpf/31//MlG0swXSaA39UdLZQ6+efyFFWTPj9Ff5fPzVLplMghhZcjvqIJfNdSDmLuKSzm4Z0TVL
	Qq+ZPBOqdTnumEizgGO4/IEBcOB9tphjaLv3OahO0+qPQmZjfgUyb7ZASdrBBlak6VXd4z5TkOqCy
	mWcmVuGrvccWMG35ZsYphmUhegZXDHK7jDAhJtxDOEV1iOL9KAEBicshJDe0eyuNkOqQjzXRePU+H
	sFUEmZVOzK3jdZ1Nt98LXj8MFFNlcm+f/85jnrGkScPdhh+dkRz+84eCP5/h81/hQmX6LJtSOz2ct
	79TUNz0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMOc-0000000FFA6-38zx;
	Fri, 23 Aug 2024 04:59:34 +0000
Date: Thu, 22 Aug 2024 21:59:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: fix broken variable-sized allocation
 detection in xfs_rtallocate_extent_block
Message-ID: <ZsgXNjQw_RNhPC6x@infradead.org>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
 <172437086754.59070.15167835843175811059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437086754.59070.15167835843175811059.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks:

Reviewed-by: Christoph Hellwig <hch@lst.de>
