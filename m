Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A07F7FC
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724708309; cv=none; b=l0Yf3ARLFXO3gdPVTBlnOtXyX7bo7O2Xj0/BUbek3uH8UwAjiacCUF3EJDMyJtKih3Ts0eU7A/Tpcnmfoc4E9f1LMc7ixOntSzsHu0hzEZ6jVCkhetw3TWVUKIhugLkZbvZkDtgyTDC9c0W8NZcr8NoNdpN9xyFPLxeHea2eDCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724708309; c=relaxed/simple;
	bh=j9+7Y84Wh0jO/i012n3SMS2TIx1DZx70p4AZh7iDSuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VG0BkMNsvFLJagfdux7S/38R53zJH/puHozY4S+/vDrNUg6RcYeH7M1kcmImt70vEJaImOuo3TYSDjSmHfj2RmreyVjLn5GucRpYarHCRFoWY6Z/TPYzUywMLrLvPYq+rOu4KfGziqA07LWG9SIBBJ7W1gyAopRpYEr9/6BJ3Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwLyKTpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwLyKTpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A218C8B7B4;
	Mon, 26 Aug 2024 21:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724708308;
	bh=j9+7Y84Wh0jO/i012n3SMS2TIx1DZx70p4AZh7iDSuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pwLyKTpLad9Xjc77PvQr1gW2X8BoEwOE52uF8yDVRGJ+mP7plrJ1kYHnCrgpgF9sH
	 02/AHqYBuhr3o0QTBEqPCdm9U6dcirT49yjDIbf4BpC1pzuH6hHhN93hCb62sOPFZR
	 tMHe2B1NsqltodnCmB1yELH0QN55t1DSDCTiVwXOPAFi4YyRcgaYNa7cRnABn4cXss
	 XtuZdziuSQtJwc5pAUrOLSdUpbaxl6mK5zaeOuFgOIZBXU9hEdl2RkF/nRVDr1ihQ4
	 V6KZoOJU5LNR32EU5XgvncM+qj1ChzIzfbnmL+RFiYxfnF1kP2Y6W9QgCscHP+f9YK
	 mAw16AfDr1Siw==
Date: Mon, 26 Aug 2024 14:38:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
Message-ID: <20240826213827.GG865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
 <ZsvFDesdVVdUhI8T@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsvFDesdVVdUhI8T@dread.disaster.area>

On Mon, Aug 26, 2024 at 09:58:05AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:18:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a dynamic lockdep class key for rtgroup inodes.  This will enable
> > lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
> > order.  Each class can have 8 subclasses, and for now we will only have
> > 2 inodes per group.  This enables rtgroup order and inode order checks
> > when nesting ILOCKs.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > index 51f04cad5227c..ae6d67c673b1a 100644
> > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > @@ -243,3 +243,55 @@ xfs_rtgroup_trans_join(
> >  	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
> >  		xfs_rtbitmap_trans_join(tp);
> >  }
> > +
> > +#ifdef CONFIG_PROVE_LOCKING
> > +static struct lock_class_key xfs_rtginode_lock_class;
> > +
> > +static int
> > +xfs_rtginode_ilock_cmp_fn(
> > +	const struct lockdep_map	*m1,
> > +	const struct lockdep_map	*m2)
> > +{
> > +	const struct xfs_inode *ip1 =
> > +		container_of(m1, struct xfs_inode, i_lock.dep_map);
> > +	const struct xfs_inode *ip2 =
> > +		container_of(m2, struct xfs_inode, i_lock.dep_map);
> > +
> > +	if (ip1->i_projid < ip2->i_projid)
> > +		return -1;
> > +	if (ip1->i_projid > ip2->i_projid)
> > +		return 1;
> > +	return 0;
> > +}
> 
> What's the project ID of the inode got to do with realtime groups?

Each rtgroup metadata file stores its group number in i_projid so that
mount can detect if there's a corruption in /rtgroup and we just opened
the bitmap from the wrong group.

We can also use lockdep to detect code that locks rtgroup metadata in
the wrong order.  Potentially we could use this _cmp_fn to enforce that
we always ILOCK in the order bitmap -> summary -> rmap -> refcount based
on i_metatype.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
