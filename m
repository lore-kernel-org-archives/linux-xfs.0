Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D8A47A88C
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 10:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160551; cv=none; b=E7BtGa7nnRzQNngP207MnfyYRAQ1hpkSBYMBBtiA5tTG1z04JpAUo8oF3oGhYnlhwXjNpVcX3/enNlght2fAIF6Jwh9YUy/x1Lrkb700fzlsKlruCMX8hje6Y6U6b3biOdsDAaUvLeGZVV0C6tw9Iotv7C0yxgyUzk9iUyHQuZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160551; c=relaxed/simple;
	bh=8Ydr4QF/Vdgkl4fB9kFfIYAag2cPR80zbrZ6d2txsj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxWy27S9bMQhb8fdr/i8Fa/OvaSM5kcmHgAknD2Jq44UlRgVNhzcZxffEsh192WQT2VbW4/tzz53kjqoDsPmvWAOQEzUBB1Xbb7oqVRyYSjccmSy3AzmUKRS61lDu5xNQ5VMyy0qgPBYjnZChvkzrvk00afMnP3mtv96UK2fJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n236dpWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n236dpWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA351F00893;
	Wed, 23 Sep 2026 10:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160546;
	bh=e5Ao7BgWHkb5zk7lor2Igh8M7KTYmDrEIbtPs21RYpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n236dpWeHpWGx6Hu0wlggVjFy+bDd/2yei2bIar7CWvhBU7t2nMOMDZBh2omRF9iO
	 YKitHd98MrTK0lVWI8lBTxZ7NULxYc6gGOJU0o/IpVqmLTAHieuTEBqmNM9RpMFVwT
	 JRjrOG+q2yItJxX2kF6IazMrFNHKIMhm3LxNHnblWvlaVxdCvSgPNo8Y5/TSJcYhHz
	 M+SVRjQMiNKTyZ5oWE3kz8b4elgWePxR6aXG7UDVXTuNxB3B9w8qsur+NZqvc3HkJ9
	 lsTovEw9f+vnDr7kDdFjmT0NnOaV1xVjnkaE1SNF41/pwnGG/VWdIKA17SaT3xAcuR
	 jhT/IvJgcGGSw==
Date: Wed, 23 Sep 2026 12:49:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <arOjRDxCUZj3FvKP@nidhogg.toxiclabs.cc>
References: <20260917103633.14703-1-cem@kernel.org>
 <20260917103633.14703-3-cem@kernel.org>
 <20260921083356.GB20936@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083356.GB20936@lst.de>

On Mon, Sep 21, 2026 at 10:33:56AM +0200, Christoph Hellwig wrote:
> On Thu, Sep 17, 2026 at 12:35:47PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Once in a while it's useful to know exactly what kind of error caused a
> > transaction to be cancelled.
> > Enable xfs_trans_cancel() to receive an error code to be reported.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> > V3:
> > 	- Kill typedef from __xfs_trans_cancel
> > 	- Remove uneeded wrap of parameter 0
> > V2:
> > 	- Parenthesize macro parameters
> > 
> >  fs/xfs/xfs_trans.c | 8 +++++---
> >  fs/xfs/xfs_trans.h | 6 +++++-
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 5c522790e5be..395c896673fe 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -943,8 +943,9 @@ xfs_trans_commit(
> >   * xfs_trans_commit().
> >   */
> >  void
> > -xfs_trans_cancel(
> > -	struct xfs_trans	*tp)
> > +__xfs_trans_cancel(
> > +	struct xfs_trans	*tp,
> > +	int			error)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xlog		*log = mp->m_log;
> > @@ -971,7 +972,8 @@ xfs_trans_cancel(
> >  	 * here.
> >  	 */
> >  	if (dirty && !xfs_is_shutdown(mp)) {
> > -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
> > +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
> > +				 error, mp);
> >  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> >  	}
> >  #ifdef DEBUG
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index eb83c5dac032..36a49622b870 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -213,6 +213,11 @@ xfs_trans_read_buf(
> >  				      flags, bpp, ops);
> >  }
> >  
> > +void __xfs_trans_cancel(struct xfs_trans *, int);
> > +
> > +#define xfs_trans_cancel(tp) __xfs_trans_cancel((tp), 0)
> > +#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel((tp), (error))
> 
> Can we turn these into inlines instead of macros?

This sounds good.

> 
> And do away with the pointless __xfs_trans_cancel, just implement
> xfs_trans_cancel_error in xfs_trans.c, and wrap xfs_trans_cancel around
> it.

The main reason I created __xfs_trans_cancel was to avoid a fs/xfs/*
change of calls to xfs_trans_cancel().

If you think that's a must, I can do that in this patch, otherwise I'd
prefer to add it on a separate patch just removing the call, without any
logic change.
What do you think?

Cheers.
