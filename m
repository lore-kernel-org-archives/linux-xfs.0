Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA8D154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903423; cv=none; b=AfUBLo4ylR/KyUUgRlQqTrbm3O1Tqz7qKlm4Dw1gYHlGjQkUDaayHxFUjhzLNrtpAgDk452thX+aHYyQU0mnXWvIcwrML+n/8Eg1ps0MtuTLYjD9ri6wZtJSoQEnf0g8tHpFS8eaHDOcVJ8A0mqcL7jWTjHvH3GKlNBUqeOcsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903423; c=relaxed/simple;
	bh=CNBKTGDplhnKSko2R+oL9k7P4jAaOotY2DghY76uCw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktOe/XngOWKnvizK1wIA8PxCB6g0TXmANuH4qM+oIzgd11zhEvg4ziC+94UpraxDFYokY2klLXV8LipWOyqUlpOPAgj6PEFlQ9VvdibB0TrlRG2MlIu0JYPPZ1FZpAZw1/S/b4LYPa1p9BRGuavvXST2nZG1fznN/izFaWvlfF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G5qWcCw5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G5qWcCw5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BSYmQPv0YinyQsmj0Vu38Y5/LyNzZkdnB3ZLIvrIas0=; b=G5qWcCw5OD7FRfVYBpKQ3kAcY4
	BMdCGu+P+DRhv74JW2Q77M28S2LTXhItbzD2nWNUHsHu/aGywuAe+z0CAD+KVG+D5jWphQcInrTNr
	juyfZlpkNldg/siMedfRUoqnT/UiqSLgXVDdljhFX9Wl4Kgn4xm/DwC6WEqJ9sOxIYwwRH2DJI8JS
	hD8VuADljlLbaWaQzXWEb6U4O+oHxF7KuU4emuWUaCuYIZyH1+uAEWbW9kGwJSI3Llt5mpPuhqGCf
	rKRszPYg9yEDTT+pVTN1gyHaNQQxTiknE1K6tNFfxigfSAgD04olDLloim9gnLIeTo7BqYTy7c4gX
	HxopPMxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGDO-00000008JQF-0IJ4;
	Fri, 07 Feb 2025 04:43:42 +0000
Date: Thu, 6 Feb 2025 20:43:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17] xfs_scrub: return early from bulkstat_for_inumbers
 if no bulkstat data
Message-ID: <Z6WPftSPlXEZrO32@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086259.2738568.15642483253868951064.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086259.2738568.15642483253868951064.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:34:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If bulkstat doesn't return an error code or any bulkstat records, we've
> hit the end of the filesystem, so return early.  This can happen if the
> inumbers data came from the very last inobt record in the filesystem and
> every inode in that inobt record is freed immediately after INUMBERS.
> There's no bug here, it's just a minor optimization.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

