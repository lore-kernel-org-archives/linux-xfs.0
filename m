Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD048E0DB
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791298805; cv=none; b=ueyLMH4yN6sWAoMkU/eAaWLFCjMx8Vlfw2ANt/gepVG3EMDa6RR0nnv0OnqayvGPHUNH+eSTNq0BqaAGps/LWRWKSQKARdIxd3CgtKRlj8Rr3TGm6yiTIurlTG1o1/Wx1OBafqNthiOOTL5RWAaL+PtG6jk1ERElrkugVE3yPoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791298805; c=relaxed/simple;
	bh=gXEdxuYT68TqrwB0a5CowI3vd37eR93fJ/sZxPM9C1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOdurWs6vFrMyfrhvRPqt5JvYAQ96NmXhkFYp6Z1X+u2YQva2HFsJdgLo/ugjxUQ3cR4wPSpR6QFUP++NjxPBLcx7xQ0oiWeleH5p6MZI4Cc0UQh9BnysdY2MXHkmJ38xvRzHeIXYQAG86fZ8xYz2Ox2THZHWYEoYAuUrLtJniE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnlJBDlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnlJBDlc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 498D01F0089B;
	Tue,  6 Oct 2026 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791298803;
	bh=FdOIVGp17xn3bs6WTTYmiXBUv6uHOz2amcV2CTcvgOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cnlJBDlcZHNyU0bvd+PiY4hyL6hAirKE5kAzRO/EA9Sk+/ecZwfcGEJPGIA2/+7eR
	 JDqEtSFVXxrXUdZUUQGWn/Lv6w18ZJ9g2syDyCAucymIeVJu72Lih2Yq3HTtLB/M4L
	 zK3WEIy7D1y1vFffjNC55xKiFIEQoFK6LReK+QzY1yUhOm1zXDqKv+DOwv4nQegPgF
	 nGuZYl7pTlmhN56OaDCpCo/1/J2VCxkPpxwlByJO89VcYX6Xo/a0LZtyfjy5DtgSjp
	 dZeaxb+lFamZciA+4dlx8SerDqDdpUq6vQX9Qk+wlSSC9ElgI+XrwTIKxmdHf1K98V
	 Np7VtB4bjz9eA==
Date: Tue, 6 Oct 2026 08:00:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Norbert Szetei <norbert@doyensec.com>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix exchange-range-to-eof file size exchange
Message-ID: <20261006150001.GY2705364@frogsfrogsfrogs>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
 <asSiXW4XxBl8Kivw@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asSiXW4XxBl8Kivw@dread>

On Tue, Oct 06, 2026 at 06:25:17PM +1100, Dave Chinner wrote:
> On Mon, Oct 05, 2026 at 10:09:14PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Norbert Szetei posted a patch containing an incomplete description of a
> > bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
> > exchange-range into modifying a file so that it has shared blocks
> > starting beyond EOF, which is never allowed because files never have
> > written data beyond EOF, and you can only share written data blocks.
> > This is key to all the incorrect behavior that follows.
> ....
> > 
> > Having confused the file sizes, the PoC uses a second exchange-range
> > call on what looks like a non-reflinked single-block file.  Because the
> > file size is set incorrectly, exchange-range thinks it's exchanging the
> > full contents of two files and clears the reflink flag on the broken
> > file.
> 
> Hmmm, another "exchrange reflink flag coherency" bug.
> 
> Aside from fixing this specific issue, how can we prevent
> other/future logic bugs from failing to set the reflink flag
> appropriately and so never expose such a bug to userspace again?
> 
> I'm thinking that we should not try to swap the reflink flag along
> with the extents. Instead, if one of the files had the reflink flag
> set before the swap, then we scan scan the extents of both files
> after the swap for shared extents and set the reflink flags for each
> file appropriately.  EXCHRANGE isn't really performance sensitive,
> so the cost of the refcount scans shouldn't be an issue.
> 
> Setting the flags this way means it doesn't matter what file shared
> extent(s) ends up in, the inode(s) that owns it(them) will always
> have the reflink flag set correctly. Hence there is no way to use
> EXCHRANGE creatively to expose this "didn't COW when it should have'
> class of corruption bugs ever again...

That is what Norbert's patch actually does.  If you think removing
xfs_exchmaps_clear_reflink and all the stuff that calls it is a good
idea (and it probably is!) then let's move that discussion and review to
that patch's thread.

> > That enables an extending write of the broken file to rewrite the
> > shared block that's just past EOF.  This has become known colloquially
> > as refluxfs.
> > 
> > Once the file sizes are set correctly, the second exchange-range no
> > longer thinks that it's doing a full-contents swap, so it won't clear
> > the reflink flag on either of its file arguments.
> > 
> > Link: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
> > Reported-by: Norbert Szetei <norbert@doyensec.com>
> > Cc: <stable@vger.kernel.org> # v6.10
> > Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
> >  fs/xfs/xfs_exchrange.c       |   10 ++++++----
> >  2 files changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> > index 6a66b6075e0af4..c9d9464e9d39f5 100644
> > --- a/fs/xfs/libxfs/xfs_exchmaps.c
> > +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> > @@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
> >  	const struct xfs_exchmaps_req	*req)
> >  {
> >  	struct xfs_exchmaps_intent	*xmi;
> > +	struct xfs_mount		*mp = req->ip1->i_mount;
> >  	unsigned int			rs = 0;
> >  
> >  	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
> > @@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
> >  	}
> >  
> >  	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
> > +		loff_t	off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
> > +		loff_t	off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
> > +
> >  		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
> > -		xmi->xmi_isize1 = req->ip2->i_disk_size;
> > -		xmi->xmi_isize2 = req->ip1->i_disk_size;
> > +		xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
> > +		xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
> >  	}
> 
> I think this really needs a comment to explain why the calculation
> is structured this way. I think it is trying to set the file sizes
> to the "destination offset" + "swap length from other file" because
> the ranges in each file might be different lengths, but I could be
> wrong...

That's correct.  I'll add that as a code comment.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 
