Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5641158A2B
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712703082; cv=none; b=hGS+Zio6x7xLmKGTVru4YPqBHvF5SyZTD5PinI3R1uJBv1VqN8jbcnTz7LT66ovv9hdvpBzBkg93Gn5SXEq0hzpU1ZObmzOgO8Aa2HQUxicXv4CVgjACA2h01xtrTXQRZEiUJb2XbwNlnnQr8tO+U7iJCAaF9nm/tJeAiUeTm0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712703082; c=relaxed/simple;
	bh=BsK3FWaEKn957dGzXp5ndRl2rM25uu+jzeX9pNxye3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aaqv3H2IYNB4nvKeKJaS1nNxawH8WknnqAWfW9/oig1wT4kfKAsVL3MvCfQVgj5I+FTjfu8mUK1rNzg71qGSGR4+yLpyER5IH2rAq7vOUM20sPRVm+RqHaQ6IDQksYU6ck+ZVqi10zZeISPOYzHVg/MfOGa2KnTnI5cPXYrHRvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHNUgJYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHNUgJYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496DEC433F1;
	Tue,  9 Apr 2024 22:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712703082;
	bh=BsK3FWaEKn957dGzXp5ndRl2rM25uu+jzeX9pNxye3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uHNUgJYSzR7m/86Kbqzzoxni7Y/jLff4bzP0cpBRB6i9QCcFaFMQ2CFqOgxE2FS63
	 Hn+rYLDRvItEC4T9N7GBDygdezBR6Imvxui5Z0fIgsYuFrBNgqrbyoCTYxy6GNHTsz
	 IPW4RyaFD9iGxH9y+WpKsOhzkUoE9MmgoCwevWUT7GGISV/cseJDI6ji6ZwZHcXADY
	 U1f0tH3NWc7Lo1N9HZsdU9c5OQe5UqBEOCVvpWfefd/OxVn2DFAeNX/TlvoOZTfLhR
	 O07B82b96C1HHl3R7Yx2ueqN2gth7FbvHQjQS2XhmVQSk1e2TjH3ygXju/BqoTcQpu
	 WF1s6cLyJHA+Q==
Date: Tue, 9 Apr 2024 15:51:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix an AGI lock acquisition ordering problem in
 xrep_dinode_findmode
Message-ID: <20240409225121.GH6390@frogsfrogsfrogs>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
 <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>
 <ZhMfXA/1YyRDe869@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhMfXA/1YyRDe869@dread.disaster.area>

On Mon, Apr 08, 2024 at 08:34:04AM +1000, Dave Chinner wrote:
> On Tue, Apr 02, 2024 at 10:18:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While reviewing the next patch which fixes an ABBA deadlock between the
> > AGI and a directory ILOCK, someone asked a question about why we're
> > holding the AGI in the first place.  The reason for that is to quiesce
> > the inode structures for that AG while we do a repair.
> > 
> > I then realized that the xrep_dinode_findmode invokes xchk_iscan_iter,
> > which walks the inobts (and hence the AGIs) to find all the inodes.
> > This itself is also an ABBA vector, since the damaged inode could be in
> > AG 5, which we hold while we scan AG 0 for directories.  5 -> 0 is not
> > allowed.
> > 
> > To address this, modify the iscan to allow trylock of the AGI buffer
> > using the flags argument to xfs_ialloc_read_agi that the previous patch
> > added.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/inode_repair.c |    1 +
> >  fs/xfs/scrub/iscan.c        |   36 +++++++++++++++++++++++++++++++++++-
> >  fs/xfs/scrub/iscan.h        |   15 +++++++++++++++
> >  fs/xfs/scrub/trace.h        |   10 ++++++++--
> >  4 files changed, 59 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> > index eab380e95ef40..35da0193c919e 100644
> > --- a/fs/xfs/scrub/inode_repair.c
> > +++ b/fs/xfs/scrub/inode_repair.c
> > @@ -356,6 +356,7 @@ xrep_dinode_find_mode(
> >  	 * so there's a real possibility that _iscan_iter can return EBUSY.
> >  	 */
> >  	xchk_iscan_start(sc, 5000, 100, &ri->ftype_iscan);
> > +	xchk_iscan_set_agi_trylock(&ri->ftype_iscan);
> >  	ri->ftype_iscan.skip_ino = sc->sm->sm_ino;
> >  	ri->alleged_ftype = XFS_DIR3_FT_UNKNOWN;
> >  	while ((error = xchk_iscan_iter(&ri->ftype_iscan, &dp)) == 1) {
> > diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
> > index 66ba0fbd059e0..736ce7c9de6a8 100644
> > --- a/fs/xfs/scrub/iscan.c
> > +++ b/fs/xfs/scrub/iscan.c
> > @@ -243,6 +243,40 @@ xchk_iscan_finish(
> >  	mutex_unlock(&iscan->lock);
> >  }
> >  
> > +/*
> > + * Grab the AGI to advance the inode scan.  Returns 0 if *agi_bpp is now set,
> > + * -ECANCELED if the live scan aborted, -EBUSY if the AGI could not be grabbed,
> > + * or the usual negative errno.
> > + */
> > +STATIC int
> > +xchk_iscan_read_agi(
> > +	struct xchk_iscan	*iscan,
> > +	struct xfs_perag	*pag,
> > +	struct xfs_buf		**agi_bpp)
> > +{
> > +	struct xfs_scrub	*sc = iscan->sc;
> > +	unsigned long		relax;
> > +	int			ret;
> > +
> > +	if (!xchk_iscan_agi_trylock(iscan))
> > +		return xfs_ialloc_read_agi(pag, sc->tp, 0, agi_bpp);
> > +
> > +	relax = msecs_to_jiffies(iscan->iget_retry_delay);
> > +	do {
> > +		ret = xfs_ialloc_read_agi(pag, sc->tp, XFS_IALLOC_FLAG_TRYLOCK,
> > +				agi_bpp);
> 
> Why is this using xfs_ialloc_read_agi() and not xfs_read_agi()?
> How do we get here without the perag AGI state not already
> initialised?

!finobt filesystems won't have called xfs_ialloc_read_agi to initialize
the incore per-ag reservation during mount.  That's a bit of a corner
case since there shouldn't be /so/ many filesystems without finobt these
days, but it's theoretically possible.

> i.e. if you just use xfs_read_agi(), all the code that has to plumb
> flags into xfs_ialloc_read_agi() goes away and this change because a
> lot less intrusive....
> 
> > +		if (ret != -EAGAIN)
> > +			return ret;
> > +		if (!iscan->iget_timeout ||
> > +		    time_is_before_jiffies(iscan->__iget_deadline))
> > +			return -EBUSY;
> > +
> > +		trace_xchk_iscan_agi_retry_wait(iscan);
> > +	} while (!schedule_timeout_killable(relax) &&
> > +		 !xchk_iscan_aborted(iscan));
> > +	return -ECANCELED;
> > +}
> > +
> >  /*
> >   * Advance ino to the next inode that the inobt thinks is allocated, being
> >   * careful to jump to the next AG if we've reached the right end of this AG's
> > @@ -281,7 +315,7 @@ xchk_iscan_advance(
> >  		if (!pag)
> >  			return -ECANCELED;
> >  
> > -		ret = xfs_ialloc_read_agi(pag, sc->tp, 0, &agi_bp);
> > +		ret = xchk_iscan_read_agi(iscan, pag, &agi_bp);
> >  		if (ret)
> >  			goto out_pag;
> >  
> > diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
> > index 71f657552dfac..c9da8f7721f66 100644
> > --- a/fs/xfs/scrub/iscan.h
> > +++ b/fs/xfs/scrub/iscan.h
> > @@ -59,6 +59,9 @@ struct xchk_iscan {
> >  /* Set if the scan has been aborted due to some event in the fs. */
> >  #define XCHK_ISCAN_OPSTATE_ABORTED	(1)
> >  
> > +/* Use trylock to acquire the AGI */
> > +#define XCHK_ISCAN_OPSTATE_TRYLOCK_AGI	(2)
> > +
> >  static inline bool
> >  xchk_iscan_aborted(const struct xchk_iscan *iscan)
> >  {
> > @@ -71,6 +74,18 @@ xchk_iscan_abort(struct xchk_iscan *iscan)
> >  	set_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
> >  }
> >  
> > +static inline bool
> > +xchk_iscan_agi_trylock(const struct xchk_iscan *iscan)
> > +{
> > +	return test_bit(XCHK_ISCAN_OPSTATE_TRYLOCK_AGI, &iscan->__opstate);
> > +}
> 
> Function does not actually do any locking, but the name implies it
> is actually doing a trylock operation. Perhaps
> xchk_iscan_agi_needs_trylock()?

Ok.  I apologize for the rage of the last few days.  I need a
loooooooong vacation.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
