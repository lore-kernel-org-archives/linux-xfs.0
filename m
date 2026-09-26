Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794793002AB
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402582; cv=none; b=tz/KEeHVCcMSja5qLpHVI7gp63encF+IvGV6idUdBdC66sp5W3I6RKM0vVmcqpDEQHUJQtrsFFwXphosEVHttbsd2LC1SccattQwIBNt0tX1c8br07DnHLLc7hASfp6ujyqF6WpDHL7MzzTD+MzONwDsrIjYPHJBSUvO7xsI9Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402582; c=relaxed/simple;
	bh=6UvnXEwXqKoVLUyYmuvEIKgQMYl5T7ApgFOEZUrPzIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqvPptKKRGmAPt8VBtzdgWIZoEGGhBMnxI1ITsUT9C1BSXI7uXd5p0pFrR69F5PnjarBDIMLDSkoBTjvlkFDh9XcIoZW1pq4OZKUY3U1bOw3WuATQM9uA5bQSyzVc/IdPsdkSu1+6BYQ3PHWlT/p8qJv/H4dAGrntqiMyeb64I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA08568C7B; Sat, 26 Sep 2026 08:02:55 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:02:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] libfrog: improve ramdisk handling in
 platform_flush_device
Message-ID: <20260926060254.GB20636@lst.de>
References: <20260925051336.2997014-1-hch@lst.de> <20260925051336.2997014-10-hch@lst.de> <20260925224720.GX2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925224720.GX2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 03:47:20PM -0700, Darrick J. Wong wrote:
> > +	 * Historically the ram disk driver destroyed all data when BLKFLSBUF
> > +	 * was called.  That has been fixed a long time, but still be careful.
> > +	 */
> > +	if (S_ISBLK(st.st_mode) && major(st.st_rdev) != RAMDISK_MAJOR)
> >  		return ioctl(fd, BLKFLSBUF, 0);
> 
> BLKFLSBUF support on ramdisks hasn't been in the kernel since commit
> ff26956875c2f0 ("brd: remove support for BLKFLSBUF") which was merged in
> 4.10 in late 2016.  Maybe we should remove it?

People use xfsprogs on really old kernels.  Now no one really should
care about data integrity on a ramdisk, but there's not too much downside
of just keeping it, so I'd rather leave it alone.

The real question to be is why we even bother with BLKFLSBUF at all.
It seems to come from e2fsprogs, where that is optionally called from
ext2fs_sync_device with a a comment:

	... and optionally attempt to
	flush the buffer cache.  The latter is basically only useful for
	system benchmarks and for torturing systems in burn-in tests.  :)

but despite that comment, all caller do set that flag.

btrfsprogs and f2fs-tool do not have any calls to BLKFLSBUF.
