Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AA919B3F9
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721916859; cv=none; b=Izf1HCJr0AJt08tV5g0cD5TSmIlvK+CHELfIl7YjLtUStCvv3lUjnRpf7Xk5pU1i7qn2NWkB/INOInS1ewViMkW73UubxyzR2fBTNvY1DAkNvN5hHeM6Trrk+f7qDr+pesjEPubgjmsfWyR7bntP3x9fpf+HuzqDlia5OPhi1yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721916859; c=relaxed/simple;
	bh=pYfPrTevNksawFDP7c9MLhZcWCVPxgbVMku1LRbHcOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcVos2O88oRYXkJgxrWwkSooRhtGWjJ0MeDj28hss+CG70x1w5H9ZXaUctE8eIfKsBTYKbK+Xbyvh4dpFlbWRcQOz3l3tcC2nFH1g+3LTSFacf+HvYxxlYM69osmmVcC4SztnIZiUqaTyJcdbepJhpTL0WGBt9TlkDRfHvz9UmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F9E768AFE; Thu, 25 Jul 2024 16:14:13 +0200 (CEST)
Date: Thu, 25 Jul 2024 16:14:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <20240725141413.GA27725@lst.de>
References: <20240724213852.GA612460@frogsfrogsfrogs> <ZqGy5qcZAbHtY61r@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqGy5qcZAbHtY61r@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 25, 2024 at 12:05:26PM +1000, Dave Chinner wrote:
> Maybe I'm missing something important - this doesn't feel like
> on-disk format stuff. Why would having online repair enabled make
> the fileystem unmountable on older kernels?

Yes, that's the downside of the feature flag.

> Hmmm. Could this be implemented with an xattr on the root inode
> that says "self healing allowed"?

The annoying thing about stuff in the public file system namespace
is that chowning the root of a file system to a random user isn't
that uncommon, an that would give that user more privileges than
intended.  So it could not hust be a normal xattr but would have
to be a privileged one, and with my VFS hat on I'd really like
to avoid creating all these toally overloaded random non-user
namespace xattrs that are a complete mess.

One option would be an xattr on the metadir root (once we merge
that, hopefully for 6.12).  That would still require a new ioctl
or whatever interface to change (or carve out an exception to
the attr by handle interface), but it would not require kernel
and tools to fully understand it.

> > Note that administrator-initated scans (e.g. invoking xfs_scrub from the
> > CLI) would not be blocked by this flag.
> > 
> > Question: Should this compat flag control background scrubs as well?
> 
> Probably. scrub is less intrusive, but I can see people wanting to
> avoid it because it can have a perf impact. Could this be done with
> a different xattr on the root inode?

Yes, scrub vs repair should probably be separate.

