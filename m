Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782AF29AB;
	Mon,  1 Jul 2024 04:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719809350; cv=none; b=cqMcrSIdv0yvW8XPH/IMFrLyX4m+ifvsmTPtZ1ZX82SmhWp4sWPJ+1j1Hr9I3fnPU43/F1CMpVWHWN0zssP0IGfbizsWHu9Cr5HD66tedYUMtNOSNzTTL253BfWINN10WFj4YHF7TB7hxaBxn8c4mK+OD0nt9gR0KpoB/yFgte0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719809350; c=relaxed/simple;
	bh=Ziwncewm+F+7gGP6+/X0T5LH1JruUDCDKDS46s+vRsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKIvH8dk3RuHaTHKMNuXihlumK9HBFIVlh8542KtasecAmR50K3QAFbDLrfg6kNxgBZlsl1h43HntblGxYCcTeno2hmPiG7hnwk2ELkVauAfDeqeOxjNa1d6A/DSOmXvZ+JCSvuK0nI8P8eOd/yo3WjXiWEmVt7xfeaGDcMtx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H96fLQ+Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H96fLQ+Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xsAvaJIxk4Rm8dv5j1no/y+ULSGMMDw+74ymp2w0nIA=; b=H96fLQ+QKiwqmvJQWeYXlBCzu8
	xPWqDwlofx2xbrvbPg+o1eCBoPFj3csh0N9QsVvQCe1dtSv6DVlWHWTLLX+VgJJl2QB6dxxNKjpCd
	LqbRzWWv/owOEJI6YLVaowVdAENELB/dQP5VIYv2dGntTi71yhJNXtC7gwe4AUOM/+vjxCR1tt4/m
	VJ39qnanU/WN+PcspEnlZx1OU5j3QJ5TvHqsjCtK8mSbRxrCVECGpu5UvbS9gXQdISGZCHeRPft34
	9gQT4Of3b50ePpCODx0bhFPXTW6SEF+09LCj40kCQ5JdEKrGMIu3nuZuSbeu26UoPnRNwatFWUiK1
	wsn4MjaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sO8yN-00000001ge7-1zGd;
	Mon, 01 Jul 2024 04:49:03 +0000
Date: Sun, 30 Jun 2024 21:49:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: alexjlzheng@gmail.com, chandan.babu@oracle.com, djwong@kernel.org,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, alexjlzheng@tencent.com
Subject: Re: [PATCH v3 2/2] xfs: make xfs_log_iovec independent from
 xfs_log_vec and free it early
Message-ID: <ZoI1P1KQzQVVUzny@infradead.org>
References: <20240626044909.15060-1-alexjlzheng@tencent.com>
 <20240626044909.15060-3-alexjlzheng@tencent.com>
 <ZoH9gVVlwMkQO1dm@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoH9gVVlwMkQO1dm@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 01, 2024 at 10:51:13AM +1000, Dave Chinner wrote:
> Here's the logic - the iovec array is largely "free" with the larger
> data allocation.

What the patch does it to free the data allocation, that is the shadow
buffer earlier.  Which would safe a quite a bit of memory indeed ... if
we didn't expect the shadow buffer to be needed again a little later
anyway, which AFAIK is the assumption under which the CIL code operates.

So as asked previously and by you again here I'd love to see numbers
for workloads where this actually is a benefit.

