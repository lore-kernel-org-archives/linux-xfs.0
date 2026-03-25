Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6229279DC2
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 05:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774417394; cv=none; b=SO42VfqX49cXIOFNyL5nfSxo4rfAWuT3CxyyJ/WYZBYbDzJVHJZbEBRciB3w19Rxv5ltZC27IsVLs9ORvW8wwA0ApzHvp1aI4Z92o1qjF3SrUIQ3tucASKOHFOJVHCb8WnetCfryGErfOR9uEKSs+QUk7dDOabL7VLwFOxNIFZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774417394; c=relaxed/simple;
	bh=1Ug8DL+IrWxMGL5pvoxFo5d9AyGaODfECCUikOQWuCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uebre4S4egn/G0uZdI0MAAeaXJuSBv1222oThDFE89f1NKtSUD3Nmko0AW2VZcqNGJzddae9m4svAHUY/B+C02aFgJBL84Ltyj9p1d77OHVhmxSCsGonSXjQrIoU42qcKaT/ItGk8nf34Fhs+KcOhGLm9RNQNauM5JIr47Vnqhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VSumcdlG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VSumcdlG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GP1u4KArGzyyYd3/qIaSpxwR6EFOjOMEMmYI+0kIe44=; b=VSumcdlGSbTW4yOQ576clvDNq4
	RZkzWD54wGPBT/HkUo0eF7sLnVFcrkU/mDAQ1wdD03oMxE4Vbd1bvjA6ypFH0pM3xyH83zxFvBLxy
	aTq2npxqx7Ox7uPZCt52NUCmICACoxSNmA/SDAoGh55FIRWs1sDi9s1TyRsXrgA4iihNtMIdyFw2u
	IrWPnKNEMrVnt3rGCEE+9xhFPR9azjR/sd43GsusF3vGGxel9wD39HnsHxH3FW1kVeWr6gDrJr4Nv
	H8mPYho1A2rFYSU7gI7mOyL/3i5Sy4QP7o+4RewCm1pEqvniOzQzY9O01hZH1WMcXAa01jX/yWeg5
	mERWUPLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5H1I-00000002j2f-3Cw0;
	Wed, 25 Mar 2026 05:43:08 +0000
Date: Tue, 24 Mar 2026 22:43:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/40] libxfs: port various kernel apis from 7.0
Message-ID: <acN17K7gEmXk8hEA@infradead.org>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
 <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>
 <acIsSch9HdMG0P64@infradead.org>
 <20260324171843.GR6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324171843.GR6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 10:18:43AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 23, 2026 at 11:16:41PM -0700, Christoph Hellwig wrote:
> > On Mon, Mar 23, 2026 at 11:41:48AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Port more kernel APIs from Linux 7.0.
> > 
> > A little nitpicky, but this suggeste they were all added in Linux 7.0.
> > At least kmalloc_array is much older than that.
> 
> I'll change it to:
> 
> "Port more kernel APIs from Linux as of 7.0."

Sounds good.

> 
 > > +#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)
> > 
> > Overly long line.
> 
> It is?  On my system it only hits column 78.

You're right, the diff messed up the mid-line tab alignment.

