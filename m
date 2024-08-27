Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAEF23BB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 04:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724732826; cv=none; b=YFeWjOfXvsSDzuiJ9g8FFBV4hnmk1hPtUVP7HtF33yvZcaufHBgVZrn9wOqVBZtjnbmdUNKvm20B4LCYH6hgxzelPVCa0Z0N3Hx+LY8WTOeYmhSaLIxR+bXJzRN4m0dhbsFv4h7qNYlRyWEGS5+dSm/oGQ6NMwu7ftqVPbkLC2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724732826; c=relaxed/simple;
	bh=fPtNiuQ1cAPa/m1AKE2c4g/qiVyM9ojszkXEDz5iDpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTSKUkGKAXIiWst1QSrI7L0GgDh8C2uAW0n5OEeLX0IArRDQg9lDzbFfvhK3tjj9GL/gRvR1KVNhtpAnMV41R4ABlrNyLbIRBCdzvMXwrmWLGt/zqakSz077+Um440SQ1TXIwf2eHnhMIidkwF8YwnkA2DlRP0yDqJVadmfRCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dttqGy+V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dttqGy+V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Qz4NzsLOCgDN/msGKb72AfD1npZJw/xJTAB6vjmt9w=; b=dttqGy+VbB403QiHLQd1A0ln4j
	WVFcUR8dswHdiu0wTaaodeAWfVN6O44HFI3j09TYmAdd9khAai9ZP07J9DJFnEdckN0SXTpk8jNID
	gwCGOQ+8Dz4w7rD+wiYfM0/HleP6o8mSXlV83t57uILJtoDRd+UbK3TYzdOaIH3xpa85jR60j9iYH
	ZiCgaILbhMcEBrlTkwjukmKSOYmGRUklS3GTexcATxHVlSiGcKGIBZ7YSRIfWSItnxHqJB0tg9Qph
	pfZFyCQzpMl5UQ76Gzd7dg5FuEmZTBN/AkS+7xBNT86s0C7gCJicn55mp/ElD9pgUtYkHAW4o5VNa
	pT0ArJQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sinnL-00000009h91-3VHC;
	Tue, 27 Aug 2024 04:27:03 +0000
Date: Mon, 26 Aug 2024 21:27:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <Zs1Vl38sptZSkvXk@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826191404.GC865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 12:14:04PM -0700, Darrick J. Wong wrote:
> They're not sparse like fsbnos on the data device, they're laid end to
> end.  IOWs, it's a straight linear translation.  If you have an rtgroup
> that is 50 blocks long, then rtgroup 1 starts at (50 * blocksize).

Except with the zone capacity features on ZNS devices, where they
already are sparse.  But that's like 200 patches away from the state
here..

> group 0 on a !rtg filesystem can be 64-bits in block/rt count.  This is
> a /very/ annoying pain point -- if you actually created such a
> filesystem it actually would never work because the rtsummary file would
> be created undersized due to an integer overflow, but the verifiers
> never checked any of that, and due to the same underflow the rtallocator
> would search the wrong places and (eventually) fall back to a dumb
> linear scan.
> 
> Soooooo this is an obnoxious usecase (broken large !rtg filesystems)
> that we can't just drop, though I'm pretty sure there aren't any systems
> in the wild.

So, do we really need to support that?  I think we've always supported
a 64-bit block count, so we'll have to support that, but if a > 32bit
extent count was always broken maybe we should simply stop to pretend
to support it?

> > What's the maximum valid rtg number? We're not ever going to be
> > supporting 2^32 - 2 rtgs, so what is a realistic maximum we can cap
> > this at and validate it at?
> 
> /me shrugs -- the smallest AG size on the data device is 16M, which
> technically speaking means that one /could/ format 2^(63-24) groups,
> or order 39.
> 
> Realistically with the maximum rtgroup size of 2^31 blocks, we probably
> only need 2^(63 - (31 + 10)) = 2^22 rtgroups max on a 1k fsblock fs.

Note that with zoned file system later on we are bound by hardware
size.  SMR HDDs by convention some with 256MB zones.  This is a bit
on the small side, but grouping multiple of those into a RT group
would be a major pain.  I hope the hardware size will eventually
increase, maybe when they move to 3-digit TB capcity points.

