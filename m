Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEB5BA3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809226; cv=none; b=bkzovYwD5Y5O2WHS2r/SnqVsaQs1TvjxXqfuER+MQ0wU28/pBdI7PgUMhXLaRNKshaC/OKkYNaKD1TtifS0frBUFB32rydAxilYQv9PTh/RgzUCCrORIlXaEVnR3rW1Ko+F+OngHPLS4QRHvIyFHqrNqjTCqiTo2jsbYs2Ly6xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809226; c=relaxed/simple;
	bh=UCB34SAmeBH4ov3AOYmsQWd6ynTPDOOXiXFdz+Pm8Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGoEYFXZeSLqpkZ9vEX9EgecYsmwsawWYvuzJ9URJaSgFIktkQIbQgs2/O37PZg00OYFomtoRWSebUPfYQiI6daeFGaSUKFBmSm2284ZA8Fpe9jIhU3g2K6eu+rJIBgtk7QHIm/rMi0ibbkHkCPLyCDNJ9NGQfP9CZpwvKfFQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DXFncA21; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DXFncA21"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8vzamDtNk1E2BJpp19oF0F6bGq3nPeVFnh1ZvU9/toE=; b=DXFncA21domYPVFQ9BgJ6gdxGa
	9ZVFKrUcUx93PXfHyXF3PIYDk/jXD+HLtNt9uaWHP2uyeEbWGazBpqRpMcgdEquva5i525GzG6qrF
	oDaDUZVC4D/cJDGD/JBcwyMCa+vru8j8xqpwmGGmC8PcvW+U3hvv6wX5r3c+kJDpWnsw1YzuGpozB
	9nH8pIfk72kNrPQowTe4hzYgXNoF8k7jiNERlowIcOtRk+O9f2vdq6dh0zjF+jQGAdVx0yHLOzzHn
	7u/EURKhNoG/0j5q92hi6b11RGXloPLiLMiFzutPQSjwBn34pv6fg9fTG9x0kWV/6QQtOOdOfxGZ5
	tJdlC2Hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsyu-0000000AIU9-2Tio;
	Tue, 10 Dec 2024 05:40:24 +0000
Date: Mon, 9 Dec 2024 21:40:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/50] xfs_db: listify the definition of enum typnm
Message-ID: <Z1fUSDMDDEVQRWtT@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752357.126362.17852148009193165099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752357.126362.17852148009193165099.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:11:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the enum definition into a list so that future patches adding
> things to enum typnm don't have to reflow the entire thing.

listify is a weird word :)

But the format looks so much nice, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

