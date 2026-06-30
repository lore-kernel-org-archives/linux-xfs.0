Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3BF37EFE5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782836941; cv=none; b=VlDm3VvUBuM2u4wBH8KFQ8rK9BBEwt/F+onK2IagJAoc8QG0Jq01G7jNGOgRKh3QafVgV/OyjD4Ka78at+3twk6tDslDv6vE6KLuQD2WD/6k2plOKjrwbocxX/WCiKvRR9jH8/+Wg6ykLoc8tsnbA4PAZNqk0ml0u+nNfMEFLRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782836941; c=relaxed/simple;
	bh=csBCps9G06/uDLUs+aSCP2v8Cim0LGdwEhe8+PXil7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXC+U/1NyGO5ch6iGdoYaRtXvOxoIDPONOIPX4QYF6BLzLSObBF4l7dIlCvZCgAxpHghtOP5TPUDfJ9M89dEv+MpHQVDGBIgIMAO/XuUCBoPO1kstP80TqEb2My5f8aLkcI6v8wACCg99+cZDbPqmlZWWxyLOaBBp2Va34d14ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wi1SWqOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wi1SWqOA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A27161F000E9;
	Tue, 30 Jun 2026 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782836939;
	bh=lmWVVfE/N375932bh6HZnUzBHS7YZlbuAFMsBpBquBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wi1SWqOAHMq5V0KjueXQEcdaVkz+ZXGyd9nV4OcePelPt6eYIz85MrYWy+/16llP4
	 H2Ut/DWfeYYdrJjJBwT4lItOrcIkug15F0hSNzmYN4eTKh6VkoSPpeoHxx40Lj+jiM
	 489A8PZ9N8Top8B20ngJxkRC4YoAdNwVt1HpqWzYp/adZ1fKDr17g2P9YpORrYrd7I
	 TH58LoQxjPd5Uzdzw9w/8t1NtCeXgzWrPJ1oTMgDRUFniMcwJ9iLwe/dIi+Mi8lDag
	 wV8aMwG05PDV3nZIuxrJwTzZ6s3zeDIKPFPlN/dfJLfKoPsTA2rtA0gmUlGD51cEiH
	 Ft3r/MIt5BYrA==
Date: Tue, 30 Jun 2026 09:28:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] mkfs: fix hardlink detection in directory import code
Message-ID: <20260630162859.GD6526@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
 <178278129879.858323.12870914276080297674.stgit@frogsfrogsfrogs>
 <20260630053852.GD21007@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630053852.GD21007@lst.de>

On Tue, Jun 30, 2026 at 07:38:52AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 29, 2026 at 06:03:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There's a serious problem in the hardlink detection code in the new mkfs
> > protofile functionality that copies a directory tree into the new
> > filesystem.  It's been long established that hardlinks can only be
> > detected by comparing st_ino *and* st_dev, but the new code doesn't do
> > that.
> 
> Yes.
> 
> > Fix the detector, and stop passing struct stat objects by
> > value(!) since they are quite large.
> 
> Without looking at the code I suspect the compiler silently passes
> them by references as long as the functions are static, but it's
> still good to fix this up.
> 
> >  static void
> >  writetimestamps(
> >  	struct xfs_inode	*ip,
> > -	struct stat		*statbuf)
> > +	const struct stat	*statbuf)
> 
> It also seems to constify a few things :)

Yeah, I'll modify the commit message to state that we pass around const
statbuf pointers because none of the protofile code needs to modify them
once we've sampled the open fd.

> > -	hardlink_tracker.entries[hardlink_tracker.count].src_ino = src_ino;
> > +	hardlink_tracker.entries[hardlink_tracker.count].src_dev = filestat->st_dev;
> > +	hardlink_tracker.entries[hardlink_tracker.count].src_ino = filestat->st_ino;
> >  	hardlink_tracker.entries[hardlink_tracker.count].dst_ino = dst_ino;
> 
> A bunch of overly long lines.  This would probably benefit from
> a local variable for the tracker entry.

and add a convenience variable here to reduce the long lines.

> Otherwise looks good, although I would have split it into a few patches.

<nod> I'll go fix the statbuf pointers separately then.

--D
