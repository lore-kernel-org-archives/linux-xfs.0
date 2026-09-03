Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E6134D384
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 05:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414252; cv=none; b=AkGFX8EkEBwW0kpws9QBFKIp8KOae/TtDSNN151IlXFlFlP0bIdnsVYimkkcYBNtM7Vr1ml66PW3uKPzYFD0AaFdX4maXn51VrDR0j6MJNb/Lns905/Qt/+0KNDdnNMtyVVakS4k4clhwf1oZhuIszb7zJ481d4RP/TPmq9SRmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414252; c=relaxed/simple;
	bh=lYBvhnat+dY698Ld8zPFz0wufOXM+Qe9Myrne2o/IQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grkZTaPeis8NozaSfHEXRg69R39MnNtmdhA2jE632PImWpN5wL1pCtO6d6F3OCrXRd+N+aKgNpFTe1bjR2DyjAgODzKOvae1Meclvs7eKsZ6um38fkhGDKOLWmZu4IY6D4A1UOT0qtvV7w1ihbNgbhB5oVJmn9VWaRpjw5KBCJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9DE0D6732A; Thu,  3 Sep 2026 07:44:06 +0200 (CEST)
Date: Thu, 3 Sep 2026 07:44:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: flush multiple device caches in parallel in
 xlog_write_iclog
Message-ID: <20260903054406.GA16748@lst.de>
References: <20260902054942.111988-1-hch@lst.de> <20260902054942.111988-7-hch@lst.de> <20260902161858.GT1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902161858.GT1933798@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 09:18:58AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 02, 2026 at 08:49:20AM +0300, Christoph Hellwig wrote:
> > When xlog_write_iclog needs to flush the cache for more than one devices,
> > the current implementations does this sequentially, which adds up the
> > flush latency for all devices.  Switch to kicking off all cache flushes
> > in parallel so that only the longest latency bounds the time of the log
> > I/O.  This removes the REQ_PREFLUSH optimization for the log device,
> > but as that flag is never passed on to the device and just very slightly
> > reduce the latency by queueing the following write from a lower-level
> > context it is trivially shadowed by the latency improvements of the
> > parallel flush commands.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> That looks like a neat trick.  Do you see any performance speedups from
> flushing in parallel?

I haven't really done a benchmark, as all the devices I test multi-device
setups don't expose volatile write caches, so I actually had to create
a synthetic setup to fully test this in qemu.  But I can kick off a run
using say consumer SSDs.  I expect it to significantly speed up fsync
bound workloads.

