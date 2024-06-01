Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A55AD4B
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 04:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717217291; cv=none; b=g4X+q4ZJrOKpSUOJg1BouVODaghogMeEtmoGezR4qDQei6DZqBlAbcpR7AFPSIwnobr6+7b3T/NI3zA3W64gv8OYTjwaoc7Oph9PtXYCF7VwkEJ3cG5a16Dd4uj0es2Pea6TfjURLj0G825PdYstjZEMSR6rO+2JY67BFxToMFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717217291; c=relaxed/simple;
	bh=f27eFlnyqwt5ktV2bqEuueuvQGZtJrQFcs93s3lJXRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoavT3CLlmCjYXe66t3anDIi/r6RcR/wSxMfWGmkEoaszbaPWVDM6vvBO7yeh7BYyeDkLW8Qy1V33KELvRTQNoKaPJIyiizX8s7t1kvj+iXDG67P04gqdbW9lqGuri1Sl3nlvejbvYed8uyuFWzDHK6ZY/ihyVeZT/u7fqLhM7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WmrZDfck; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WmrZDfck"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f27eFlnyqwt5ktV2bqEuueuvQGZtJrQFcs93s3lJXRs=; b=WmrZDfckFqxegVf3zSAEOXp4B2
	rMwvL2UxlyvbY8IBam4aUOn+rWT6jCWTqvJHXkBlYhma7azIdpJ5uMJWIctysXf6Dx+VCe2VQ4kUe
	x2w6p/xYrDRc0gcnOayzYcZlO06po49YQxtIJ/tiIlQZggsolOrL2aaj1s51ht2DvAq9UvXddKU/u
	fr+XNE04BNgoRd3kbwVthO9FF2KV+Kgd/+9fnrwhCsaseImMx/iHpCQTTPZ3WcxVzRLDqWRWdBidK
	ehk8/f8A3D9LT6e86h7yAGc/jO8VeyN+iYD3ks70cY/Z6Y2PcxGQVcvZNB8JpGDs2gmW8/SncIHzO
	Rj64gXAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDGez-0000000ByRF-3rDZ;
	Sat, 01 Jun 2024 04:48:05 +0000
Date: Fri, 31 May 2024 21:48:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 1/1] xfs_io: make MADV_SOFT_OFFLINE conditional
Message-ID: <ZlqoBUiK9WBpDTMr@infradead.org>
References: <20240531195751.15302-1-bage@debian.org>
 <20240531195751.15302-2-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531195751.15302-2-bage@debian.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 31, 2024 at 09:57:51PM +0200, Bastian Germann wrote:
> +#ifdef MADV_SOFT_OFFLINE
> +/* MADV_SOFT_OFFLINE is undefined on mips */

... as of Linux 6.9 */

With that (can probably just be fixed when applying):


Reviewed-by: Christoph Hellwig <hch@lst.de>
