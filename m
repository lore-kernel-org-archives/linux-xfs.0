Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2C184F
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728955282; cv=none; b=JfihJFH1deYX0ePc39nFd6YU4Ha5FGSCtmZXvC2HFuyANww6g+IA2SDz/K2OGTr8sXcmCQqfUla7Ul5xUspnKSBSAtu1Xqe+rz9RKAp53hVatraTQgR+xSF6ZH3FP532uA+Sy5VMUJm4Peh4DqzoXm32YmFRWTYUQzwHsvjP3Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728955282; c=relaxed/simple;
	bh=YCmE6/VnwNI7T3ngO6UoHeiIOPPnhsRmBXDLDL+Hzu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRS5/QglWyTMGYTqZLth44QeSs23YDKV/JjMWqrVXgHv6DYG1sgBO3S9xVGLlgoDiW2DAUM7uwbh4wNH78dzwM9QxGLJ4mjXNmfqcWwQs52plijFi+HweeAGKGm4C9h9Oi12IiTXlhg4lMRGzykO8XM6fy2yo2xH5pYyb3+TD4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0odQdbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0odQdbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEF1C4CEC3;
	Tue, 15 Oct 2024 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728955282;
	bh=YCmE6/VnwNI7T3ngO6UoHeiIOPPnhsRmBXDLDL+Hzu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H0odQdbDTeGNrgwrmM60kfUw/BePqiED/6ApoG6mxG/tNsEYHy8te6dTNCaA64y57
	 DM5unUuYTY78xXz1/nR6vlHRPl+jV1+qQjX1qQMjC97myvdnDFYdZnyJ2wWADiFy+U
	 KEjgn9hUb06shic27AfKh6neZlP13z78UT3trQLzbObaE2xpQI5eXdQGoow9XEGD2n
	 x85mDjYCDOFRVN4AwVLa0TR8u45r1paAERM8zldT00OW1Xu1GTU46ku3D7oDS22cjg
	 VW81wZI1TabYORpSJ7ACCIJw6kfNVKoUWcgGDBuW7RdI44+casAVCarY+kJXkiOpb+
	 kukCjbKGRMVbw==
Date: Mon, 14 Oct 2024 18:21:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/16] xfs: convert extent busy tracking to the generic
 group structure
Message-ID: <20241015012121.GR21853@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641435.4176300.8386911960329501440.stgit@frogsfrogsfrogs>
 <Zw3AqAuiDKKKowCa@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3AqAuiDKKKowCa@dread.disaster.area>

On Tue, Oct 15, 2024 at 12:08:56PM +1100, Dave Chinner wrote:
> On Thu, Oct 10, 2024 at 05:46:48PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Prepare for tracking busy RT extents by passing the generic group
> > structure to the xfs_extent_busy_class tracepoints.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_extent_busy.c |   12 +++++++-----
> >  fs/xfs/xfs_trace.h       |   34 +++++++++++++++++++++-------------
> >  2 files changed, 28 insertions(+), 18 deletions(-)
> 
> Subject is basically the same as the next patch - swap "busy"
> and "extent" and they are the same. Perhaps this should be
> called "Convert extent busy trace points to generic groups".

Done.

> > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > index 2806fc6ab4800d..ff10307702f011 100644
> > --- a/fs/xfs/xfs_extent_busy.c
> > +++ b/fs/xfs/xfs_extent_busy.c
> > @@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
> >  	new->flags = flags;
> >  
> >  	/* trace before insert to be able to see failed inserts */
> > -	trace_xfs_extent_busy(pag, bno, len);
> > +	trace_xfs_extent_busy(&pag->pag_group, bno, len);
> >  
> >  	spin_lock(&pag->pagb_lock);
> >  	rbp = &pag->pagb_tree.rb_node;
> > @@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
> >  		ASSERT(0);
> >  	}
> >  
> > -	trace_xfs_extent_busy_reuse(pag, fbno, flen);
> > +	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
> >  	return true;
> >  
> >  out_force_log:
> >  	spin_unlock(&pag->pagb_lock);
> >  	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
> > -	trace_xfs_extent_busy_force(pag, fbno, flen);
> > +	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
> >  	spin_lock(&pag->pagb_lock);
> >  	return false;
> >  }
> > @@ -496,7 +496,8 @@ xfs_extent_busy_trim(
> >  out:
> >  
> >  	if (fbno != *bno || flen != *len) {
> > -		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
> > +		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
> > +				fbno, flen);
> 
> Also, the more I see this sort of convert, the more I want to see a
> pag_group(args->pag) helper to match with stuff like pag_mount() and
> pag_agno()....

Me too.  I'll schedule /that/ transition for tomorrow, along with the
patch folding that hch asked for.

I'm gonna assume you also want an rtg_group() that does the same for
rtgroups?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
