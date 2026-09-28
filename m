Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B490443313;
	Mon, 28 Sep 2026 06:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577487; cv=none; b=Qr0Pr/sC9Pcgd6FY8FcX4Q5gt4V58pzw4in2+BSCbJZTiUGHVFbmfFVbut6SbdUfDJKS+Bj5yi2pe4HUqEink6DfKgqA2dn0bByoePv8T8vMTF0MzYqxipwi/6aFiZZ+hwYU7Jt2D5UPTvQaMxJrR5VSYVYX5lLtclqrfvvK0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577487; c=relaxed/simple;
	bh=qeOUsq+C9zyNvnKO3mLP0NfgfZ7bqj4btL74RWQcCNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccZ9u2nM2ISWFPHBBplKyHz0yNEm2QGSnLRgDdoP9XKpuNxVsrSpLXU4iovRx5ozc4+qEHJnuylemJtZJUSvAD2uDKRrMcYmt4JVTacruX3TtPCkahVAYKC/3c/1gD9qA/f/YC5h0yp7bUBSAcbv0BQ+x0wvMHjKLU2GdrYJwzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xgeN1SVH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xgeN1SVH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y39RnOGgHaklDSryUdwLQ64fu8IiCeCA9mooZ+j8iY4=; b=xgeN1SVHEpRXMXnlX8elOETd9y
	LZP6bgwtxOecPlHwATjf8sxRuXWrxcGPu9YgAFIQ1GQxaM4aKDPyXsM+QQE1UTqzj1DnPSlEsPfHK
	9BekERnaFlJqgAdVxEhqFlMZ3NLaxEhzgN2OedVeSVxITBR8nw7BBhxQRnp5QITA6nmhtdQt5wL1J
	oIveDbxtJEWGt5rdTfnD11nXM6Esc6Qwv5mxDlbrSvuJcAF3D6bMtt6oFS8RavSHwcMvRtTuhlC3f
	IWrFXZH58fU2/Xrbua4Ib8puEedEnGg6SRVOvyHOm/Mb0lDyeM2m0s9HtZGw/7EYwiLn1VkaHNgB1
	uVRym9AQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4zy-0000000HSrB-2kd0;
	Mon, 28 Sep 2026 06:38:02 +0000
Date: Sun, 27 Sep 2026 23:38:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: abort dirtree repair if the live update hook
 dies
Message-ID: <aroLSmgnHV_7vT_v@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612661.479634.452473932902566402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612661.479634.452473932902566402.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:16:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that if the live update hook for the directory tree repair
> code hits an error, it will set dl->aborted and stops working.  If the
> repair code ever sees that condition, it ought to bail out immediately
> instead of continuing with obsolete data.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
