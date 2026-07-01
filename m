Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6457943635E;
	Wed,  1 Jul 2026 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903255; cv=none; b=XO3MgXaJQMPnSEtjxUYSv1bWx/vlm8xOwQpweLDJcMFmJIS3fL9Li9NBIJaiYkp+drifD1Dvt5XcOdCVFO1KnkiRrcu0YAJNOqVVuET0S49/rrd4YFQTLKLtK9pPrWMgA2KtWA7L60n3TRpYzsCBf4I545Y/bbeeRF3EJwLBCdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903255; c=relaxed/simple;
	bh=j1+TafSTKpIpHEVDPW8tJZ4oE1Lx09XZ0s1k3EoGvDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhlWmRH52DJ9RUrACcpH+/HkHUyB9hh/xXX3tWy7Z+f1G4nBr2uTqQ4Sni24DZ8XEZJH1Q45bulSbohY7JNQsPG9s03frPRVcn2KCsGGo9kE9JLI2K0kTJ8M7JpdhR9oJ196zcGlH8pQBrpuMx4GDTYRTFgbjaVFBAWR3vDrTao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 03B0968BFE; Wed,  1 Jul 2026 12:54:08 +0200 (CEST)
Date: Wed, 1 Jul 2026 12:54:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] formalize and fix disabling the RT subvolume
Message-ID: <20260701105407.GA14404@lst.de>
References: <20260630113526.3601287-1-hch@lst.de> <20260630184018.GB6544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630184018.GB6544@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 30, 2026 at 11:40:18AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 30, 2026 at 01:35:26PM +0200, Christoph Hellwig wrote:
> > Various test unset SCRATCH_RTDEV to avoid dealing with metadata
> > allocations for the RT subvolume in the main device or differences
> > in RT subvolume behavior.  Besides being rather ad-hoc, this unset
> > also fails to disable the internal RT zoned subvolume.
> > 
> > Add a _disable_scratch_realtime helper that not only unsets
> > SCRATCH_RTDEV, but also disables the zoned allocator and with
> > that the internal RT subvolume.
> 
> What if we want to run these tests on the internal rt volume?

Then we need to stop disabling the RT volume for them..

