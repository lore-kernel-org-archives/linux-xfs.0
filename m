Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7089E14B07A;
	Fri, 23 May 2025 05:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977442; cv=none; b=T8AzWShYr5ka1SDbdsVJdf9jESBlVZv2HLRXol9hGPFHXwWWKsemCCBYWooFGYZ7k6kxwbwdIS8OFLvqdC8eC2Frxk1EumbPGFPPOyJ4bMCO3fNpXNFLDQ0aBsRdgrJtfREb0OAwisbOAdGQvR/j7wTec2Gind5gr2tRgLdih3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977442; c=relaxed/simple;
	bh=9jLg/xNzCUWpNLkthxFU7R5Vz9CKWHZLz00TTlH5zho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0HGRfbeARpeu09aduebgRxKbQ7KSKTu7EFINAIyLIEZRZUTq2O8+QZAU4Yaz4fSl1hJcoWVSRI/50QeeWzFupIqvEdr5/j5bypS5WHk2LehMg9SGeTcoxbE0df+o0BB/zOmSGFgqXoiPncKFW7r8Ji5XiND3nDRSEpyBL+oCUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uj9XzNRC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uj9XzNRC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rKT1HrG6awNU9PCQao3Vn4Zb+u2x8R00rQwYzvwegmw=; b=Uj9XzNRCc0tpEHdRW1tpnzY2u0
	mTZQ7eeB1tR83y/QbRgiYjL2IIFlVLq4Nvcx4gFD3MCmsnX2zjQOTlsdam8Wh1KeoGrIOHP8Cakn4
	XLD8K9i53NhLY2k+9H/lLxwxY0rM4DU95hmzaLXe1IRKD/DnIIhsN7C8CzBh9LajPIEj0dTHkgJTJ
	ihQyl0A+0VnFGXgNBSKgj6C3GomORAO/d7TDQifTRrwaN3gxnRncWbTta92uqmMprE/1xj0SjK8oo
	wiVBaUUDYNWW43Q3swid/d4pXfw0nkjOAdv9u3cCVjoO7o6AcaA5gYDkpigDTrDQZyXdQVg7jxxsz
	RM9CU3JQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKmV-00000002ysX-3kng;
	Fri, 23 May 2025 05:17:19 +0000
Date: Thu, 22 May 2025 22:17:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/273: fix test for internal zoned filesystems
Message-ID: <aDAE32ZJOJmcWAR9@infradead.org>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719409.1398726.5762252044518389370.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719409.1398726.5762252044518389370.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 21, 2025 at 03:41:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For XFS filesystems with internal zoned sections, fsmap reports a u32
> cookie for the device instead of an actual major/minor.  Adjust the test
> accordingly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

