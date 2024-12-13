Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2C17BEC5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081457; cv=none; b=kh3B9+BEF8zSLgDhpFlzrlUnvMqnXWiBSQ+MKx3YqVtOFjIEnxgGiikCZTyyOFZLJIFL32WyS5aGLpqgTrXa3BTG1GeAXMwqs4M5B39FAx0L78yKMZJl4R8uPaCR+Fro+84VQ5KGch8oCRriGs5kuoDh0p8x8OPMW7YwbY8a+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081457; c=relaxed/simple;
	bh=LZUdxQrPFNoRLO1oPQm+2v8XW6Saf9A03Ss2SGurYoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOeI2t05DdziQp6qWLlli6EuRkukEmKPKRFXz1r/okg9qJbq5d01UNfB5AzvTmmn/G5Haa4NTOL0bgiqQRms2KP5EiKhsl74j9xnLDt9a6c4Mxoqy9Az+W66wtsrYz462xs+3buEuydNFQgiU4jd6OIXUzuCDQltzSz5aRuTnII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UlZnqYpR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UlZnqYpR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OTfK1vqSPClve9CkTasvQC2xK8Kp/p+076xCNygOsZA=; b=UlZnqYpR2hBDaU6JyWouOQBRoN
	YM70dVLFDqOd4t0AAPUaUd/P6Cz0udkprEGx+VPE0O3Y1gO9ICryArNtHXpaMMSQx6L+H1Kk+DyQp
	gpoyfwnD5IUK5L3SWOsG9GW54x9h2rG6Z5iuBNVuqxCs6AzcOVRbL9RaeBahkfNIGRaQ4iKiSuhz/
	V6oRJ/NDYgQ/sZLmi9qHTKB1BzpdNziMjpgVgyJGc4n0vg2fVOgR17NoLMCi5JAO6Cbek7vQ+lCgD
	Ai5eIHZg89oEZGQhORz0JVgW1Uh9YpF8c1r02opGawFM9VO1cgTxOt+gabtOPmeZcQx3qv5XXEoCN
	HKgDod2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1nk-00000003DZP-187e;
	Fri, 13 Dec 2024 09:17:36 +0000
Date: Fri, 13 Dec 2024 01:17:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/43] xfs: report realtime refcount btree corruption
 errors to the health system
Message-ID: <Z1v7sPPnayUziZlC@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125029.1182620.6787400699658875832.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125029.1182620.6787400699658875832.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:17:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Whenever we encounter corrupt realtime refcount btree blocks, we should
> report that to the health monitoring system for later reporting.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

