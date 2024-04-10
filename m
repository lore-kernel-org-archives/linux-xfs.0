Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25C10A1F
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725508; cv=none; b=fQddaP5TTgT2tzm47hWgCflGlNMQ6yUf1LhfnML1UshZVW2ZMalso4Ow+mWphB39eZK8Fsb0rM+4YhWR7hJYA0FELKoIzZ3D01zQ+OzTXTABC8vC4ZanPzj0+IZcDufMIP3I4EsUO3/NPVJeStaLq+o2BePicKqjqEvYKS1Wu4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725508; c=relaxed/simple;
	bh=s+eAXLMYuI0WZ/ObySPNTYd+IT0keDDHLc7YFiGSu60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iisTxRQMgAAeVyQ9WZULPokEjqnjYktoXFPrqOQCpUv0PKvuhAjywOwpR0zOkeZt91GAV1buYP1mH6sATIJ4m5h2oRsuygaK+jIgVbjKPAsWCsPQtHZZ3iWm9CbCZ+qFva3q8RllXosa9doaWNTWEZFHjyPD+CPwh7v87VG90uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iEjE01PJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iEjE01PJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d+hV7P/DLjRG406dKDcqM+lSpp12eNlZbBK7uQ4/xlw=; b=iEjE01PJdctSXuCPcUDK8hBWFu
	GnhWKgnfR/v0C6ORFu3EzgQqJe0eeXsQj2VLDFWCN4rea2vhM8VqL3tD71Voj7O+0/i3jpua3wLpq
	Uso2Aw2QLDvRytkkniazLnjOo6Sk6hhHvrG9mLQwQKxi9XP5HuFeDYKMS1JEjIe1c0BtDlJFCh1Nh
	qpJ8Cb0jOxAnoqCqfqqZE/2zbgLU+qKScK4MlNbMTImfxtDjs6DRhrAzh3wzaPYr+rAjlIcAZFxtU
	5mHdZBux2RpmxrcqKODcjfGdQ7H9fozzr6MKFvvlE7R2OY9E+9aFmQfm47zYwHcgI9BaqlFlbuq31
	vWieMzGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQ8w-000000057ID-48tT;
	Wed, 10 Apr 2024 05:05:06 +0000
Date: Tue, 9 Apr 2024 22:05:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: use an XFS_OPSTATE_ flag for detecting if
 logged xattrs are available
Message-ID: <ZhYeAvz1cPKKdHI3@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968902.3631545.15407860268151301275.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968902.3631545.15407860268151301275.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:51:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Per reviewer request, use an OPSTATE flag (+ helpers) to decide if
> logged xattrs are enabled, instead of querying the xfs_sb.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
