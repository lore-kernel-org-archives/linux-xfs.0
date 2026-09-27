Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D08B3845A7
	for <linux-xfs@vger.kernel.org>; Sun, 27 Sep 2026 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790544634; cv=none; b=fC9m9XpG+yv62WehYatINqaHFGk3BrBBpY0t7QKs5JpsKBa4WyZ8ewSl4epKi8o6UgxxmMrLTHlhUWIyuFNepem5fNc7VTtfTsfGYOpTcgNCixhrWQE/ca4HF1SxIrodpqU7VI1jPLe3nfhQSB7gdBSo20SnfgLQRgRfzrMnFOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790544634; c=relaxed/simple;
	bh=ilTjbBjJKTykdwnZgYF2F7MD9aN82r6fZY6GS/xspko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5ZeetjsCkC4GlbAFryYFJzOXy+M19HYc9AxqRNGT6MxtynpkRb+Ige2lbZWa7+KEqUK+KZ9vILrlk4HZ1CqF7cIGw2wBaXkf0QAr1hxx5GkMIjACxBdT+tVBAZKNtre71uR9N+RnpN5ZEkCTVPgGZ3CvBpa2MdIR8BJMM96w6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7CBZqGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7CBZqGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B375C1F000FF;
	Sun, 27 Sep 2026 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790544632;
	bh=l9y3k8cojKrCsVq+4Bf/+w2KKqqAOzgsgMx8a4Qe8lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d7CBZqGxRS6fgoTOFdbIF8e2pkkzlRIyRhJrAtiTy13bTPK9XDpxfTUjoInMzpfjY
	 xKDQ+QchjtGW/+r1b843VmvCslDC38kTS9HdrGR3r5Vu+K8rCB1AMTEEULC9yl885A
	 DZIiaSXq6J4q4oRjDKoirEBT4E2GivHvqbWj9lsy5+vO+2KXAqL3JrtK510+2PrXMj
	 tEdjry4SifPvM0NGgISYlTDHK38y0bn/fHwI8yK9r+0C8soDacvow+TiZzD0Vao47m
	 xuZAmSJZVYHFp6aBlK2y+aU/l8I83v1yW7rCuX48tC6YXCVUVgrSevCDHnW6bVuQkd
	 AkIVUapgeOi7A==
Date: Mon, 28 Sep 2026 07:30:24 +1000
From: Dave Chinner <dgc@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <armK8JoOOzKMfbHZ@dread>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <aqsN4GOXthkF8rOI@dread>
 <aquJIL3Ztk3KBdHV@shinmob>
 <aqvER2bZyAO6H-4v@shinmob>
 <aqxag3TcgpYYVwTk@dread>
 <aq51WDjHLW3XyPR0@shinmob>
 <arGqH7adMMyhM1pi@dread>
 <arXOOv-OCEUs8xgQ@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arXOOv-OCEUs8xgQ@shinmob>

On Fri, Sep 25, 2026 at 10:32:44AM +0900, Shin'ichiro Kawasaki wrote:
> On Sep 22, 2026 / 08:05, Dave Chinner wrote:
> > On Sat, Sep 19, 2026 at 08:53:39PM +0900, Shin'ichiro Kawasaki wrote:
> [...]
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 426a67b813a..8d10ae22884 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -829,7 +829,7 @@ xfs_file_dio_write_atomic(
> > >  	struct kiocb		*iocb,
> > >  	struct iov_iter		*from)
> > >  {
> > > -	unsigned int		iolock = XFS_IOLOCK_SHARED;
> > > +	unsigned int		iolock;
> > >  	ssize_t			ret, ocount = iov_iter_count(from);
> > >  	unsigned int		dio_flags = 0;
> > >  	const struct iomap_ops	*dops;
> > > @@ -844,6 +844,17 @@ xfs_file_dio_write_atomic(
> > >  		dops = &xfs_direct_write_iomap_ops;
> > >  
> > >  retry:
> > > +	/*
> > > +	 * Concurrent atomic write COW submissions under ILOCK can run out
> > > +	 * journal reservation resource and can deadlock with the IO
> > > +	 * completions. To avoid the deadlock, serialize submissions of
> > > +	 * atomic write COW by taking IOLOCK exclusively.
> > > +	 */
> > > +	if (dops == &xfs_atomic_write_cow_iomap_ops)
> > > +		iolock = XFS_IOLOCK_EXCL;
> > > +	else
> > > +		iolock = XFS_IOLOCK_SHARED;
> > > +
> > >  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> > >  	if (ret)
> > >  		return ret;
> > 
> > Urk, that's pretty nasty.
> > 
> > > @@ -853,7 +864,8 @@ xfs_file_dio_write_atomic(
> > >  		goto out_unlock;
> > >  
> > >  	/* Demote similar to xfs_file_dio_write_aligned() */
> > > -	if (iolock == XFS_IOLOCK_EXCL) {
> > > +	if (iolock == XFS_IOLOCK_EXCL &&
> > > +	    dops != &xfs_atomic_write_cow_iomap_ops) {
> > >  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> > >  		iolock = XFS_IOLOCK_SHARED;
> > >  	}
> > 
> > And at this point, we now have several atomic write cow ops specific
> > operations in this function (locking, the retry loop, etc).
> > 
> > This feels much more like there should be a separate function for
> > the software cow path, and the fast path simply calls it on
> > ENOPROTOOPT from the dio submission. That gets rid of all the
> > conditionals and looping from the fast path. i.e
> > 
> > 	if (ocount > xfs_inode_buftarg(ip)->bt_awu_maxocount)
> > 		return xfs_file_dio_write_atomic_cow();
> > 
> > 	/* do normal DIO write */
> > 
> > 	if (error == -ENOPROTOOPT)
> > 		return xfs_file_dio_write_atomic_cow();
> > 	return error;
> > 
> > 
> > That essentially makes xfs_file_dio_write_atomic() and
> > xfs_file_dio_write_aligned() the same code, except for the above two
> > checks, hence they could easily be collapsed back into a common
> > implementation is:
> > 
> > 	if ((iocb->ki_flags & IOCB_ATOMIC) &&
> > 	    ocount > xfs_inode_buftarg(ip)->bt_awu_maxocount)
> > 		return xfs_file_dio_write_atomic_cow();
> > 
> > 	/* do normal DIO write */
> > 
> > 	if (error == -ENOPROTOOPT)
> > 		return xfs_file_dio_write_atomic_cow();
> > 	return error;
> > 
> > That seems like a much more natural breakdown that the current
> > duplication of the DIO write submission code...
> 
> Thanks for the comment. I'll try to factor out the duplication based
> on your idea.
> 
> On the other hand, Darrick suggested antoher solution approach to allocate
> enough space before taking ILOCK by increasing tr_logcount.

No, that doesn't fix anything. tr_logcount is an optimisation to
minimise the number of blocking regrants a -typical- rolling
transaction will take. It trades off an increase in initial write
grant reservation space (i.e. they use more log space) to enable
more transaction rolls without needing to refresh the write grant
for the next operation in the transaction.

IOWs, it will reduce the number of concurrent transactions that can
be running at any given time, but if the deferops intent processing
can still run out of pre-reservation space and block waiting for a
write grant.

Hence increasing tr_logcount just kicks the can down
the road, making it slightly harder to trigger the deadlock at the
cost of lowering modification concurrency in the filesystem.


> I wonder which
> way is the better: "allocate enough space" or "take exclusive IOLOCK". I'll
> do some experiment for the "allocate enough space" approach before working
> on the dupliaction clean up.

"allocate enough space" if not a fix - it's a bandaid. "take
exclusive IOLOCK" reflects the fact that COW operations are
inherently single threaded due to their reliance on holding the
ILOCK_EXCL for long periods of time on both IO submission and IO
completion.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
