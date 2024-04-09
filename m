Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566DD38DC9
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712696952; cv=none; b=eGkXDkYFZr5Y1MWH1hMXupPyfQiYRWX2RztpP1NplPYySEsCjQgfW57/HfygLbHQKEl2f61OorwjDfvd01RWO273s14wOSveA1nQkUGf2kCBT8NmStGtNJ5Ps3VHDgLHd1ZV6W3SnPDYUY8voryDMSpwgWAcUm7Abl2ytD/2WA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712696952; c=relaxed/simple;
	bh=3jplTWI0BxSKeWhiQ3OPLeIIslWzaSLQILAGS5mZYQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdcNZqEWuafHXTrkKQhJmVzbSAr7XdQKrIltynQRFIGVVY5GFnStowoUvRV/ByQOEbJelB9DtF7hESm4m7loSeZEUeYElsyK6VTTrJbGq+tz6QPbX7fFpmgrFOSSr88nU3WbliHDNaQq3C7Z3IGyX4SDCOhYgO3YbfXW59HRHRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8JpNUDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8JpNUDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84A6C433F1;
	Tue,  9 Apr 2024 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712696951;
	bh=3jplTWI0BxSKeWhiQ3OPLeIIslWzaSLQILAGS5mZYQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f8JpNUDAbrKlWp4m89km8BIWtx1cd0Jjmlax9kzQeVHO26ElsagiQkA7aGjI2ml54
	 K7/gaYhUrMvIYw98cqwkViQ0KeAOzcEDnbL1K0GI/SsXuMBjxE4nbqen4cEN6wiB5o
	 nbRocXaa0KlQEst674AiwGi8g2VESbo7L56bH8AFP/EtPjwJPHV32ARV7eh5lSF9ed
	 IfeCPCmFPOy0aBDcgsFgxeELKBsnny3GVs9t/gziKqVI8Y6X2RMcRKyxe0X9loBO6V
	 36Wy7kG9XhPZcydkWnB3wlp+JyjwHRigrGpbXej7wOE9j1w2HVY7d9KPHf5XMcyK1s
	 L25yqHhHF/Qfw==
Date: Tue, 9 Apr 2024 14:09:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: hoist multi-fsb allocation unit detection to a
 helper
Message-ID: <20240409210911.GF6390@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
 <171150380216.3216450.3675851752965499332.stgit@frogsfrogsfrogs>
 <ZhMnMWaQueOm+0Td@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhMnMWaQueOm+0Td@dread.disaster.area>

On Mon, Apr 08, 2024 at 09:07:29AM +1000, Dave Chinner wrote:
> On Tue, Mar 26, 2024 at 06:52:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Replace the open-coded logic to decide if a file has a multi-fsb
> > allocation unit to a helper to make the code easier to read.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_bmap_util.c |    4 ++--
> >  fs/xfs/xfs_inode.h     |    9 +++++++++
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 19e11d1da6607..c17b5858fed62 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -542,7 +542,7 @@ xfs_can_free_eofblocks(
> >  	 * forever.
> >  	 */
> >  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> > -	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
> > +	if (xfs_inode_has_bigallocunit(ip))
> >  		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
> 
> This makes no sense with the upcoming forced alignment changes to
> this code.
> 
> That essentially brings "big alloc unit" to the data device based on
> extent size hints, and it will need to do different rounding
> calculations depending on whether it is a RT inode or not. Hence I
> don't think hiding the RT specific allocation/truncation setup like
> this is compatible with those changes - it will simply have to be
> undone before it can be reworked....

So undo it when you and John and Catherine have a full patchset
implementing forced alignment.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
