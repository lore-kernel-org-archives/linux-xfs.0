Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701806107
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712722076; cv=none; b=MfyZyJIsL6wpPVJqRqPQoNkpJypqtAbnSP1hMFocastV5a8RUqd6WzQ90u6iHRjyWFufQFM3ox3NpIgOTqKd8Q/F8BgFICbH68CNpazgygrXCaDLqs9Bxsu11YV94t00y3pIZpKZHclDHBH41SL0GQiUJY+B35BrlpPykFQU/u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712722076; c=relaxed/simple;
	bh=JEPaJLhp36S7Gw06uhY14tCHx+/Z/F7m1TRFdEA37b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2BdB/uY4MbcVcDe6bjZaYxjSkECWyL3fVyAGaiKQZO1lWnI8OKinJ5IeW0Iajc36WZ9MXJFP6nfjh1dWYhUFtQsdSSz7T2IzEDCi6spDsOAXq+AHVug5ecRORInHdwHMfe0q+uGd1z6DYhO6Dc9Xw6yJrvTiXulvLao4jIGVic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14DB668B05; Wed, 10 Apr 2024 06:07:51 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:07:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/8] xfs: do not allocate the entire delalloc extent in
 xfs_bmapi_write
Message-ID: <20240410040750.GA2099@lst.de>
References: <20240408145454.718047-1-hch@lst.de> <20240408145454.718047-9-hch@lst.de> <20240409231601.GJ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409231601.GJ6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 04:16:01PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 08, 2024 at 04:54:54PM +0200, Christoph Hellwig wrote:
> > While trying to convert the entire delalloc extent is a good decision
> > for regular writeback as it leads to larger contigous on-disk extents,
> > but for other callers of xfs_bmapi_write is is rather questionable as
> > it forced them to loop creating new transactions just in case there
> > is no large enough contiguous extent to cover the whole delalloc
> > reservation.
> > 
> > Change xfs_bmapi_write to only allocate the passed in range instead.
> 
> Looking at this... I guess xfs_map_blocks -> xfs_convert_blocks ->
> xfs_bmapi_convert_delalloc -> xfs_bmapi_allocate is now how writeback
> converts delalloc extents before scheduling writeout.  This is how the
> mass-conversions of large da reservations got done before this series,
> and that's still how it works, right?

Yes and yes.

> Whereas xfs_bmapi_write is for targeted conversions only?

targeted is one way to describe it, the other way to look at it is
that xfs_bmapi_write is used where the callers want to allocate
real (or unwritten) extents for a range, which just happens to
convert delalloc as a side-effect as those callers don't want to
deal with delalloc extents.

> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> If yes and yes, then:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

So as mentioned in the cover letter I'm quite worried about the
new behavior we expose here as we always converted delalloc
extents from the start and tried to convert it to the end,
and this now changes that.  So while the changes looks quite
simple they expose a lot of previously untested code and behavior.

It's probably the right thing to do but quite risky, let me know
what you think about it.

