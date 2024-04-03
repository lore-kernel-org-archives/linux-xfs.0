Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34E414386D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 11:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712144624; cv=none; b=oFUs5TRgt8lZdfEXm4idL64JB5qoEKXEPbmci1P8aI+cXsggncz/Pkux3B7pzrAlcmfM8mxxV/uAQcc0aBH7vM6kI8thuOd/BiexKbccebdwWrYOLX6mZgjJdzpEYykqXiRDM6mVfGTE3XPI2Y/yb13NjykbYfmrDr6+ODE+oL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712144624; c=relaxed/simple;
	bh=TaVbDJxdyBmTSnIw1Ar6BtCCc2jWPFHmlDeT41cVGLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZY6xvD2Wax4rKXat3BPOru3Xl0y0NuUVJ55EcYs7/pmunpU9n/nSpJNX/DHZlcv4vjHwNe5ONrNlcQ/n7nrfDfXf7I8d1EHxGTsQwkneeLWU77d9kwDE5+yp+oeze4aewFYVPT6HO3E3B+6fCSJdagmz8aEA6N+612jhdhpgzaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1fBrIDMr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1fBrIDMr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2st1DcL7UBS3vIVfaHP7v53djjQVrZISi7qxZhhpM84=; b=1fBrIDMr/sBpkYOm+BZ8HG8r4v
	73pynEoZ0bRnSQGdx5do+OyPcistPaKTizfEip5IBS0zBm0CWqc7TGmXLhVkyWBvTMfOeTboTLiVi
	Cz73EiA5I4OFePp+sTNk/Cl/vCHT82HxwUnH4RCm7FoYAk06Psjh7sDwUx45+Q6/OLEicGyIZvMdx
	jCbceNvtknEj17P64ustfP5mdtC+5waRbCTDk99vZ1CvL9f1wD2yPyOQdlXOdjke/+HqPKdxYDkli
	Z2a722GfVuN3Fl0fr4nI2FXPj0ApPKPoIeYR9JAPr8TpkMCaiufJCKMaQTGMXozr7AaIoiONSJlBB
	vfpNaoIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrz1r-0000000FpbZ-0VSH;
	Wed, 03 Apr 2024 11:43:43 +0000
Date: Wed, 3 Apr 2024 04:43:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: pass the owner to xfs_symlink_write_target
Message-ID: <Zg1A78oCFIBC2_hz@infradead.org>
References: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
 <171212115387.1525560.11209751388578651990.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212115387.1525560.11209751388578651990.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 02, 2024 at 10:12:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Require callers of xfs_symlink_write_target to pass the owner number
> explicitly.  This sets us up for online repair to be able to write a
> remote symlink target to sc->tempip with sc->ip's inumber in the block
> heaader.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
