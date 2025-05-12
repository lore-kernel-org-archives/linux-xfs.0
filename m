Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6818F10A3E
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 04:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747024466; cv=none; b=oUS6OUt4jOWgK6e5+HzUaSFGMviYG3prxXU39ySN4aPKTerw5sD7Ljf2x8oYrmZcVFMg16odfs4CDZmWiknhXavsOEebbArGG2UZzuscpsVj+J5/j/F2Zd8MSYNdVRxa9vekJt+VUDKKKOhOtXdim6ENqDh48WlZRkLszjMiicE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747024466; c=relaxed/simple;
	bh=5OvAkH5nCKtxDnG9K8ml0lRJXrzQackACK+cXaDRLu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbD0oeHKEeKxJ5wQ66H58LAXhc+/4FMa50z4gSo+55rgWn38ct9PFPqdBi4SHd/9swtxjyHf/etFCGPLwLaejP0g1rS4QvZXYb9hyHR38Jg9uE4xiq4J9eKfNlV/USKa2pUpQLudMEaeiv/g8jqZnfavaoKe1/bpoz1B12hvl+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YXk8Ax+U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YXk8Ax+U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/dY64huXcKvzwlYMvcwNfwB5AjkKxeHtGTA9SXldSgU=; b=YXk8Ax+Utxf0RDfT3ssgOTWdG4
	yePxuPqHD7BkK0TnqNhLgz3YVGJuAcnLBtnyfvmqhvwWz9YzJl79Ony5bIG03PBBj33cnS1sHWZht
	UkAqtgtXFdN9EyiWb7Q+pqX1ZeqO/R5iJLXZqWUoJgGQB38XE70obTB+31D3FYYi2pYyn1bvTfSV4
	h2sxbiNU5P4Xa4VEzlAvhqca92o6bm+MsEw/iAu3vbDVwRCPY0YhGlV1c9ANcomkLkzsvExKHayhv
	Evi0DXcZtLnIgg07h+26w48w8hNed7QUcroo+Vk15uPpP9WCZWsDvCb8wlPHY/8twmGgyoJPHjN4B
	usIfpSog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEKrw-00000008LCZ-49V5;
	Mon, 12 May 2025 04:34:25 +0000
Date: Sun, 11 May 2025 21:34:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <aCF6UHNzRqZaH2dK@infradead.org>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250510155301.GC2701446@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, May 10, 2025 at 08:53:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> syscall and parent pointers were merged in the same cycle.  None of
> these have encountered any serious errors in the year that they've been
> in the kernel (or the many many years they've been under development) so
> let's drop the shouty warnings.

Looks good.  Talking about experimental warnings, I'd also like to
drop the pnfs warning.  The code has been around forever, and while
we found occasional issues in the nfsd side of it, they were quickly
fixed.

