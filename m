Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE840B677
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724696855; cv=none; b=T0c6TUr3VdAk4RKtEJXdJUDArynx1mrNBVnUQ1wQNc8ORtOfqH9Ii7hyfVLITDQZQQCiEGZBp1SAcE7a0fGcdxK0e+bmR1BzyYL7mKZlDSk9xK2MNYqfLyFVSccDQQWZmzZHbJR+M5aFeu1tV0+9DMMPgJgBhcX9HG7U8qgFIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724696855; c=relaxed/simple;
	bh=cMyX3SXb4raDh9jkHOE5onhRgtcTrkQG/QZDNMQHiwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnnzjpqaceswhwLCLYRBDGUIMFxPGawvTlfL/aIc6OBPXqMkXLpqeXzdRK4DoOW683dFMtvP8m9gOzXWsOgO9mTvCx6N3+FLviaGHOAtOrt3fy/4pTgZmjLhPVwn9MeptHOLjcPT+TEp/59QTxFKssM8lrgaATAF3+I88PSSJqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nG1qWyRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nG1qWyRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7DCC8B7A5;
	Mon, 26 Aug 2024 18:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724696855;
	bh=cMyX3SXb4raDh9jkHOE5onhRgtcTrkQG/QZDNMQHiwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nG1qWyRcIi09GXpvCjDEoto6+xdNzPncjeVHd6PsKEAbRaotl4/4e3Ol2dUEBBER5
	 RnbIYi43OMK/ndW+wgQe7DkXRr6vGMrbGluHvrPbciDmNL5k/Lf9KER8S3koOuKpF2
	 eCeZN6ZkwNKhvhos+G4GmthoNglgjXRUyXUZ8dm508n0fgzcbac85od6TMKf8dxSBy
	 fcQjXYkHWbeX+gDGgCbjID6ULbz+LivohzW3JdkEqOsJRCE4E/g2z7sh+r7EyN6MtH
	 4LmrZerUrNpAtXUielxxFNqBSlLJOByjF4NXUnJlkCORvbZD/B8HD/tCZYtIPzUkMx
	 dFy0eh/niBPJQ==
Date: Mon, 26 Aug 2024 11:27:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: factor out a xfs_growfs_check_rtgeom helper
Message-ID: <20240826182734.GA865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>
 <ZsvjQiGQS6WD/rwB@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsvjQiGQS6WD/rwB@dread.disaster.area>

On Mon, Aug 26, 2024 at 12:06:58PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:20:07PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Split the check that the rtsummary fits into the log into a separate
> > helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
> > geometry.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > [djwong: avoid division for the 0-rtx growfs check]
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
> >  1 file changed, 29 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 61231b1dc4b79..78a3879ad6193 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
> >  	return error;
> >  }
> >  
> > +static int
> > +xfs_growfs_check_rtgeom(
> > +	const struct xfs_mount	*mp,
> > +	xfs_rfsblock_t		rblocks,
> > +	xfs_extlen_t		rextsize)
> > +{
> > +	struct xfs_mount	*nmp;
> > +	int			error = 0;
> > +
> > +	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
> > +	if (!nmp)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * New summary size can't be more than half the size of the log.  This
> > +	 * prevents us from getting a log overflow, since we'll log basically
> > +	 * the whole summary file at once.
> > +	 */
> > +	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
> > +		error = -EINVAL;
> 
> FWIW, the new size needs to be smaller than that, because the "half
> the log size" must to include all the log metadata needed to
> encapsulate that object. The grwofs transaction also logs inodes and
> the superblock, so that also takes away from the maximum size of
> the summary file....

<shrug> It's the same logic as what's there now, and there haven't been
any bug reports, have there?  Though I suppose that's just a reduction
of what?  One block for the rtbitmap, and (conservatively) two inodes
and a superblock?

n = nmp->m_rsumblocks + 1 + howmany(inodesize * 2, blocksize) + 1;
if (n > (logblocks / 2))
	return -EINVAL;

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
