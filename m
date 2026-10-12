Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D13750D5;
	Mon, 12 Oct 2026 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810631; cv=none; b=IK6ZQUmH6UvPTpoE9scfO8INDDWM9iFLeV/h4B2fr2x1emEvrCR1rgy9Vnjc2HzlVMk59LA1HFSfbDSDNTBAQmUyz4aaQRXE8PN4XyKeeQqjOCvUGfNX74GnQF9vpy/TwuGkrC2KUk/F2O7JZLTiXbBQs3EU2gdx4/ycgBTcu2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810631; c=relaxed/simple;
	bh=Ar7o7rl7eHmATqb9BZctRC5ixPuwgkUY1eqBlEw1S3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSMVyegjSvm70Pu7swBt04HKMtGss9dz6eEqlRXSaxk/SWLYM7zl7DjQK+rz/a6uSw7L5279NL0q26Nw7+Nt4Q2M5+WtSLP/BoM8VcnTV8vssiTtBoCHs5DywhZxpYyF2UO+liuG4/l14g5FQxQ5fEqnel37tpMX7VfBREqs2tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nfjGejfp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nfjGejfp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i+Q12/i9pgmRsHw+Cr5k+g9GNG5l6j/5ZcgTqeeomDM=; b=nfjGejfpd4CJeFxXRRZBmy4phl
	Ff+wySCSQQ3GNMWceqGapPYP7T30eeRmhibgxhPfZiEGIpI5GH9dLSKTyElzQlb+qzeKTEKV2qqLV
	2K8uPI5VUD7Pp7hOJ599WiTO8sXf+vD8sA9NfGOJwGnUfQ/2DcmU2d2V86Uw0zd4Z2JsGcMt1ASyG
	Io/CZZO8rI9ZQyQUhKJDxu+vVXbCi5bB47SYA32z4ppmvPyZCK/lTvGo3QNYbKBj9OgpH5hCcxcVQ
	cs49ggFXe/jQUXHdBfSXSNtz94sfeMtrXPI8RdZBPDpFJop3bzfDbkltTPtwBjAAVZCaHdKBH+eZD
	uVBwcT8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFnR-0000000AXH5-3IUm;
	Mon, 12 Oct 2026 13:10:29 +0000
Date: Mon, 12 Oct 2026 06:10:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: don't clear COWEXTSIZE on directories on
 reflink filesystems
Message-ID: <aszcRWQRX9Pj5O4L@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065367.1058326.6266297742144507394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065367.1058326.6266297742144507394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:57:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_dinode_flags clears the COWEXTSIZE flag
> unnecessarily on directories on reflink filesystems.  Directories just
> pass the hint along to new children, so it's valid to leave the flag
> set.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Sashiko complains this could corrupt v2 inodes, but IIRC we don't
support online repair on < v5 file sytems, so this should not happen.
Or are we missing a check and accidentally allow repair on v4 file
systems?

