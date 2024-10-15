Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DC728691
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729015581; cv=none; b=A7Phodtba5iohdfwGjVQN66aiHC4MLdjwZ5qCSi5D6ZqTcvJZd+PhJbqJb7SFYFbf/W9I/SLxDHMFks4d5NoELlsn3UfcEi6aHUWeuilDOCPpNqAwXiqTANoGMAp5m895mX1MlhyN2qBX+0rSRtEqB0YtjnZMV19tbi8dlpkvtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729015581; c=relaxed/simple;
	bh=HUQzk9K865WWtG5JmM8CtDIlxbNJUw5yixqlW1yMveA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2rQiti7c8BQk47SS37V8uorutLUJYcRuz2IEJvVy05uq97xl3SlDRebYgm6xJ/Xi2qSlm0i3iZ8Qj0lsVUyELvbu/QyjaqXTcTKZhHNjuIKpWn8TwbFzevT4u7pCvhdezg+jmrVfZP89D5xNGiZb06aq2KvaM78NZ0BJVFqaVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luw+e++z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luw+e++z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA4BC4CEC7;
	Tue, 15 Oct 2024 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729015579;
	bh=HUQzk9K865WWtG5JmM8CtDIlxbNJUw5yixqlW1yMveA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luw+e++zOhY5h9owupHpNkOqP8eWkKJ9VozXK8RaMQIvr0ItxKGVb9zfY5SPNM2rr
	 FXR+KKC8ua2yVMZCc/w0WCAWEJx+bamJHiZ9nF4JFDGHLb4zVMV7n5hlWB8QzS7fOB
	 CCxXNamuO0yCSbAxjgfRWMTlEdMCNr2IxnMIlm5yWLslUclwjuHBC9j5aYL0shjlPL
	 XY/ez03d0PJcIsv+71UHwbrDvIe7FcypjZPNVwZWKutvAszXoZ0S8C9zqG2lSt1qu3
	 mYZ4Ub7ueqPadN9DnjKkLZK6cGGXEcCXiTRJ8ddBBGlF5Z/Lz9VEDO+7QyaKdmeEtA
	 3SRGff8gZ25sA==
Date: Tue, 15 Oct 2024 11:06:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/16] xfs: convert extent busy tracking to the generic
 group structure
Message-ID: <20241015180619.GC21853@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641435.4176300.8386911960329501440.stgit@frogsfrogsfrogs>
 <Zw3AqAuiDKKKowCa@dread.disaster.area>
 <20241015012121.GR21853@frogsfrogsfrogs>
 <Zw3WtXJIpXTUdVhr@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3WtXJIpXTUdVhr@dread.disaster.area>

On Tue, Oct 15, 2024 at 01:43:01PM +1100, Dave Chinner wrote:
> On Mon, Oct 14, 2024 at 06:21:21PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 15, 2024 at 12:08:56PM +1100, Dave Chinner wrote:
> > > On Thu, Oct 10, 2024 at 05:46:48PM -0700, Darrick J. Wong wrote:
> > > > From: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Prepare for tracking busy RT extents by passing the generic group
> > > > structure to the xfs_extent_busy_class tracepoints.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_extent_busy.c |   12 +++++++-----
> > > >  fs/xfs/xfs_trace.h       |   34 +++++++++++++++++++++-------------
> > > >  2 files changed, 28 insertions(+), 18 deletions(-)
> > > 
> > > Subject is basically the same as the next patch - swap "busy"
> > > and "extent" and they are the same. Perhaps this should be
> > > called "Convert extent busy trace points to generic groups".
> > 
> > Done.
> > 
> > > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > > index 2806fc6ab4800d..ff10307702f011 100644
> > > > --- a/fs/xfs/xfs_extent_busy.c
> > > > +++ b/fs/xfs/xfs_extent_busy.c
> > > > @@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
> > > >  	new->flags = flags;
> > > >  
> > > >  	/* trace before insert to be able to see failed inserts */
> > > > -	trace_xfs_extent_busy(pag, bno, len);
> > > > +	trace_xfs_extent_busy(&pag->pag_group, bno, len);
> > > >  
> > > >  	spin_lock(&pag->pagb_lock);
> > > >  	rbp = &pag->pagb_tree.rb_node;
> > > > @@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
> > > >  		ASSERT(0);
> > > >  	}
> > > >  
> > > > -	trace_xfs_extent_busy_reuse(pag, fbno, flen);
> > > > +	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
> > > >  	return true;
> > > >  
> > > >  out_force_log:
> > > >  	spin_unlock(&pag->pagb_lock);
> > > >  	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
> > > > -	trace_xfs_extent_busy_force(pag, fbno, flen);
> > > > +	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
> > > >  	spin_lock(&pag->pagb_lock);
> > > >  	return false;
> > > >  }
> > > > @@ -496,7 +496,8 @@ xfs_extent_busy_trim(
> > > >  out:
> > > >  
> > > >  	if (fbno != *bno || flen != *len) {
> > > > -		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
> > > > +		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
> > > > +				fbno, flen);
> > > 
> > > Also, the more I see this sort of convert, the more I want to see a
> > > pag_group(args->pag) helper to match with stuff like pag_mount() and
> > > pag_agno()....
> > 
> > Me too.  I'll schedule /that/ transition for tomorrow, along with the
> > patch folding that hch asked for.
> > 
> > I'm gonna assume you also want an rtg_group() that does the same for
> > rtgroups?
> 
> I hadn't got that far yet, but I think that's probably a good idea.

Ok will do.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
