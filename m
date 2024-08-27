Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6378D2114
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 04:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724732845; cv=none; b=nsdz9ZzT2SKJ2GslC69sp8+oFHEU5a5PZI9OHxmLCd95dOlyrrU20hpWjVtbyIfMSgZPyN/Jut6+4JjN3yFtJ/bCo6ysXRJi2WgMaOJfet1Cz2WvkkpM3ZVRZNorz0YS4D4h42p4odjjjae7IgCtzlO2LxtR/EJ3Si7B8lpoFyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724732845; c=relaxed/simple;
	bh=UKeynDDcGU7wRAeHWy5ZZAoqPwaUgx01eaojQFcT+zI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfLne6oKoobxVipj/7/hBkWD5bkGlEnjEwldOeng9Ilj/R0ZawCF6G9WDzU5Tvyk54yXMYGdB0VFk4fyCp20K9q8C867IWeJFHA5OkZ4Mv6sWdrE5hjbI3VbMwT5JB2wPR/GmWm3OOGmGTn7PxjH1dKl9RunMOhgFJ648qGKMAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUexMK2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUexMK2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C4C8B7DF;
	Tue, 27 Aug 2024 04:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724732844;
	bh=UKeynDDcGU7wRAeHWy5ZZAoqPwaUgx01eaojQFcT+zI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUexMK2rW7Rin8QReOpFLGt/HPhEWX5F0HVyKhdGdyQnIgLrOfraeeiAe9kvoALmJ
	 r8a+SOuvswCGtmMBspzsgGy4re2LXDi31YtCTDMGC+6NjMsh+VIascX3ZLllitxbh8
	 mSAB/MnpyP5ldbS6nT83A407gFcIIKSPCW9oN41zxnUvpNF1pnVq6NCJZ3ovfUCv/u
	 ppxM8v9NYfuRmkmNbJPzWn+wtKHVB+b1mhdVNF4Wkzz6R0s+k6enwxSKh8hhMImlFn
	 JJENjkon2eB/hEJrP5pIChUuJidfkLyBakEuehbmlDKGI7mZZBwBgdRp9Nysor31TB
	 xBpsh8zbJsyjg==
Date: Mon, 26 Aug 2024 21:27:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: factor out a xfs_growfs_check_rtgeom helper
Message-ID: <20240827042724.GI865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>
 <ZsvjQiGQS6WD/rwB@dread.disaster.area>
 <20240826182734.GA865349@frogsfrogsfrogs>
 <Zs0sBGeYgiiKxk4o@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0sBGeYgiiKxk4o@dread.disaster.area>

On Tue, Aug 27, 2024 at 11:29:40AM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2024 at 11:27:34AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2024 at 12:06:58PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 22, 2024 at 05:20:07PM -0700, Darrick J. Wong wrote:
> > > > From: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Split the check that the rtsummary fits into the log into a separate
> > > > helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
> > > > geometry.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > [djwong: avoid division for the 0-rtx growfs check]
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
> > > >  1 file changed, 29 insertions(+), 14 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > > index 61231b1dc4b79..78a3879ad6193 100644
> > > > --- a/fs/xfs/xfs_rtalloc.c
> > > > +++ b/fs/xfs/xfs_rtalloc.c
> > > > @@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
> > > >  	return error;
> > > >  }
> > > >  
> > > > +static int
> > > > +xfs_growfs_check_rtgeom(
> > > > +	const struct xfs_mount	*mp,
> > > > +	xfs_rfsblock_t		rblocks,
> > > > +	xfs_extlen_t		rextsize)
> > > > +{
> > > > +	struct xfs_mount	*nmp;
> > > > +	int			error = 0;
> > > > +
> > > > +	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
> > > > +	if (!nmp)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	/*
> > > > +	 * New summary size can't be more than half the size of the log.  This
> > > > +	 * prevents us from getting a log overflow, since we'll log basically
> > > > +	 * the whole summary file at once.
> > > > +	 */
> > > > +	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
> > > > +		error = -EINVAL;
> > > 
> > > FWIW, the new size needs to be smaller than that, because the "half
> > > the log size" must to include all the log metadata needed to
> > > encapsulate that object. The grwofs transaction also logs inodes and
> > > the superblock, so that also takes away from the maximum size of
> > > the summary file....
> > 
> > <shrug> It's the same logic as what's there now, and there haven't been
> > any bug reports, have there? 
> 
> No, none that I know of - it was just an observation that the code
> doesn't actually guarantee what the comment says it should do.
> 
> > Though I suppose that's just a reduction
> > of what?  One block for the rtbitmap, and (conservatively) two inodes
> > and a superblock?
> 
> The rtbitmap update might touch a lot more than one block. The newly
> allocated space in the rtbitmap inode is initialised to zeros, and
> so the xfs_rtfree_range() call from the growfs code to mark the new
> space free has to write all 1s to that range of the rtbitmap. This
> is all done in a single transaction, so we might actually be logging
> a *lot* of rtbitmap buffers here.
> 
> IIRC, there is a bit per rtextent, so in a 4kB buffer we can mark
> 32768 rtextents free. If they are 4kB each, then that's 128MB of
> space tracked per rtbitmap block. This adds up to roughly 3.5MB of
> log space for the rtbitmap updates per TB of grown rtdev space....
> 
> So, yeah, I think that calculation and comment is inaccurate, but we
> don't have to fix this right now.

The kernel only "frees" the new space one rbmblock at a time, so I think
that's why this calculation has never misfired.  I /think/ that means
that each transaction only ends up logging two rtsummary blocks at a
time?  One to decrement a counter, and again to increment one another
level up?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
