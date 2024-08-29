Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31D018A6DF
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 22:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724971601; cv=none; b=Qk4CZBgwa5AIJA9zuNm3lXoBzqmc11uxQvnFqKlkHPIoo4reD8PMELVH+gYkmkhHwNZ6TVald3PxE/wLwSsWLBW5G9dy4oQ4TAPeuAteGcTTLwO1iV6J4frXJcsh8CRkEmUp+6F+RGtHwtb9QlZKDcIOCIPyrVCEzO5r43b9t4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724971601; c=relaxed/simple;
	bh=Ha8Iv9ET87U2hCpVx1EFxLJcwEWt2j4HGPhy2kbbwT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mx30E/U2A8ygMDqxaBml+xPHfyNdqQU2p63jSXaE+pCR7avbwrrXYVBYz7K7/MwdTKkAJQGd0NGsfTpoTz9yaAsSUOJnYQUmjyP9l81FhLN6q0aj4/7qkuq231eOWYz3JBHU/PIqo2RHfxLh7ICqJ6ckLHy2bvAJGHAtnKRoLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvnDCAFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvnDCAFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1ECC4CEC1;
	Thu, 29 Aug 2024 22:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724971600;
	bh=Ha8Iv9ET87U2hCpVx1EFxLJcwEWt2j4HGPhy2kbbwT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LvnDCAFscXQOiKhCrwbsR4Ukeqa2s3QEYUOZCR7VVMoWl2JS5oemgI+8po0i0UJw1
	 xdqNk8zAo7JMhzflV6japc471xbgErn8jwaw8XKguRBOom+XQyQ+oBD4v3dYmtG5y4
	 csU0KjUx/RZGPfksQi+dw4XVBbn6LtJcyMNpcmChkI7XfP3qjSA8D+xVw6ssiSzj94
	 G+xB9OclC/7EzqwAdEuAfj4NcOcaklbeqQ614KfYTTygjPnBzf4RU9pUe41JoKMZsA
	 iGDP6sVB0HrZZB+UlGYSmG2Z7Qq26otSLTFgA1k8r39HZX/PtGap3nf0l3cTPKvp+n
	 Iw9udG30frwtQ==
Date: Thu, 29 Aug 2024 15:46:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/10] xfs: refactor creation of bmap btree roots
Message-ID: <20240829224639.GT6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131627.2291268.8798821424165754100.stgit@frogsfrogsfrogs>
 <Zs/ZNSQ74BOefzUm@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs/ZNSQ74BOefzUm@dread.disaster.area>

On Thu, Aug 29, 2024 at 12:13:09PM +1000, Dave Chinner wrote:
> On Tue, Aug 27, 2024 at 04:35:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've created inode fork helpers to allocate and free btree
> > roots, create a new bmap btree helper to create a new bmbt root, and
> > refactor the extents <-> btree conversion functions to use our new
> > helpers.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       |   20 ++++++--------------
> >  fs/xfs/libxfs/xfs_bmap_btree.c |   13 +++++++++++++
> >  fs/xfs/libxfs/xfs_bmap_btree.h |    2 ++
> >  3 files changed, 21 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 00cac756c9566..e3922cf75381c 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -614,7 +614,7 @@ xfs_bmap_btree_to_extents(
> >  	xfs_trans_binval(tp, cbp);
> >  	if (cur->bc_levels[0].bp == cbp)
> >  		cur->bc_levels[0].bp = NULL;
> > -	xfs_iroot_realloc(ip, -1, whichfork);
> > +	xfs_iroot_free(ip, whichfork);
> 
> I feel like the "whichfork" interface is unnecessary here. We
> already have the ifp in all cases here, and so
> 
> 	xfs_iroot_free(ifp);
> 
> avoids the need to look up the ifp again in xfs_iroot_free().

Yeah, that makes sense.

> The same happens with xfs_iroot_alloc() - the callers already have
> the ifp in a local variable, so...
> 
> >  	ASSERT(ifp->if_broot == NULL);
> >  	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> >  	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > @@ -655,19 +655,10 @@ xfs_bmap_extents_to_btree(
> >  	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
> >  
> >  	/*
> > -	 * Make space in the inode incore. This needs to be undone if we fail
> > -	 * to expand the root.
> > -	 */
> > -	xfs_iroot_realloc(ip, 1, whichfork);
> > -
> > -	/*
> > -	 * Fill in the root.
> > -	 */
> > -	block = ifp->if_broot;
> > -	xfs_bmbt_init_block(ip, block, NULL, 1, 1);
> > -	/*
> > -	 * Need a cursor.  Can't allocate until bb_level is filled in.
> > +	 * Fill in the root, create a cursor.  Can't allocate until bb_level is
> > +	 * filled in.
> >  	 */
> > +	xfs_bmbt_iroot_alloc(ip, whichfork);
> 
> .... this becomes xfs_bmbt_iroot_alloc(ip, ifp);
> 
> i.e. once we already have an ifp resolved for the fork, it makes no
> sense to pass whichfork down the stack instead of the ifp...

Makes sense here too, will change both.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
