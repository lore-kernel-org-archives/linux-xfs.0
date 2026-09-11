Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0891455624
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141091; cv=none; b=dvxdvh0HCfLM84/GKKesTDGLNUzv7i2dXsGqs59SxT6wtfAEugwJslnLu1mUCd398U6PLRy9YTQwRTyUQC1XVG4lYkIDlCFH1hDxQlFoJi6+w0f41UBjCh++XhvuQXjt51j7FW35zVJm6Aa/zI/77KA+V2kbGSI4VhFqN4BN8O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141091; c=relaxed/simple;
	bh=k+8qV/drWV75+QS7JGVy0aSGo683SGrCPHq7d337L7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKLwoYcCxH2cXzq3+YsPUOzeJBwyqoo6uE02HSgXzUP5h4egYN3TVKk9Ayrn2uI6XWYSppEiiAidM94F0piwszKRthtXB330jZ/AKTWgaupSeoHzO3lErq1nuKPwbkcOoeQIgJtTQqg9nPQKE785NYZbrKBFhxoYsl/Bz0iC1AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 020FA68D05; Fri, 11 Sep 2026 17:38:06 +0200 (CEST)
Date: Fri, 11 Sep 2026 17:38:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxfs: don't set mp->m_rtdev_targp when no RT
 devices is provided
Message-ID: <20260911153805.GA27644@lst.de>
References: <20260911144559.1959740-1-hch@lst.de> <20260911144559.1959740-2-hch@lst.de> <20260911145726.GE6265@frogsfrogsfrogs> <20260911151120.GA26893@lst.de> <20260911153026.GF6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911153026.GF6265@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 11, 2026 at 08:30:26AM -0700, Darrick J. Wong wrote:
> > And that is what we get with this patch.  The zeroing is done by
> > zeroing the entire mount structure in the callers of libxfs_mount
> > (don't ask me why..).
> 
> Sorry, but I don't see how we get to m_rtdev_targp==NULL with this
> patch?  The end of libxfs_buftarg_init becomes:

...

> In the case where the rt and data devices are not the same, we create a
> new buftarg object, even if xi->rt.dev == 0.  That only happens if we
> didn't set xi->rt.name to a path, which means that libxfs_device_open
> ignores it:

Yeah, you're right.  We'll have a separate m_rtdev_targp, but it
will have a NULL dev.  rtmount_init rejects this except for xfs_db,
but xfs_db can see a "weird" targp.

> OTOH there are other places that use other checks that clearly assume
> that m_rtdev_targp is always present:
> 
> libxfs/init.c:311:      if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
> libxfs/init.c:1034:     if (mp->m_rtdev_targp != mp->m_ddev_targp)
> libxfs/init.c:1035:             libxfs_buftarg_free(mp->m_rtdev_targp);
> 
> Ok maybe this patch is fine as-is?  But xfsprogs needs a treewide change
> to make the "do we have a rt device attached?" checks match the kernel
> code?

It has passed pretty extensive testing so it must be perfect (TM).
But I agree that another cleanup pass to better match the kernel
sounds like a good idea.  I'll add it to my bucket list.

