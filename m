Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF6747F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724723819; cv=none; b=uakguLsKLGR7MTTj5ZllB/+tNFZvtUf7u0lYQdOXQytERlpgmiTGQGrBpp1NFCycilwH1MlsJFen8Nymh2EpZDqVPZSX2vHmpDQ2VZ9z/PzKDoQ7HlDWccNw9quod+REZp7CK9tPJKWY4F1qv9ZgrMnoRo3qjKA952/+HByybEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724723819; c=relaxed/simple;
	bh=tcrqklnwEn5yAJPId8GgURhijpd8OghOnsZKpyxlVks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSi3e6K4Fxd4i2bsOXw6IXrrUzxSPMevo+xgrets/r5RhQThl5lp+H7iwSpEmjD7w8lAhkuRle+vGZ44YRRnhVekTtfLaTWYPtc511Q2MGal0B9aJikrIVJWG4wf84HnXRz+NCX4EAzVxwD/hu3wy4loG/od3cF/Yk27tYUMsFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWOCbhtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWOCbhtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FA5C8B7AF;
	Tue, 27 Aug 2024 01:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724723818;
	bh=tcrqklnwEn5yAJPId8GgURhijpd8OghOnsZKpyxlVks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bWOCbhtPolk9xhc0GG2WOOhES3id8RCSY1HBln/TdJavW0A9IekwhAK44Uj2rCTUZ
	 9t1Xgk3HUW4uDML+zQn5of4ni6Zhv5pparIf2GREgyP4XnsR0u7hXW6MYV66F5tIF5
	 omF2SaMcTmHx769nxWmQ2xe2OTrMMqbVeKVjJDZ6lsqSMvnPR/28eFvePlfQIwuJH6
	 gLeyixYRquil0Cb9QQMGMu2bLD6VV+8a8ceKRgYdLjSVCiYjkVT0HBosKB0H+UKLGG
	 vJhlWxFpAso5JqVaI28OvN+OVZgCGuOh2yeK40ZDK+YIK0G1piJaDSm9K5uEqtHTVf
	 2TpSqIqYqgyoQ==
Date: Mon, 26 Aug 2024 18:56:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
Message-ID: <20240827015658.GE6082@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
 <ZsvFDesdVVdUhI8T@dread.disaster.area>
 <20240826213827.GG865349@frogsfrogsfrogs>
 <Zs0k0y1euPWgWMie@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0k0y1euPWgWMie@dread.disaster.area>

On Tue, Aug 27, 2024 at 10:58:59AM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2024 at 09:58:05AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 22, 2024 at 05:18:02PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Add a dynamic lockdep class key for rtgroup inodes.  This will enable
> > > > lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
> > > > order.  Each class can have 8 subclasses, and for now we will only have
> > > > 2 inodes per group.  This enables rtgroup order and inode order checks
> > > > when nesting ILOCKs.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 52 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > > > index 51f04cad5227c..ae6d67c673b1a 100644
> > > > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > > > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > > > @@ -243,3 +243,55 @@ xfs_rtgroup_trans_join(
> > > >  	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
> > > >  		xfs_rtbitmap_trans_join(tp);
> > > >  }
> > > > +
> > > > +#ifdef CONFIG_PROVE_LOCKING
> > > > +static struct lock_class_key xfs_rtginode_lock_class;
> > > > +
> > > > +static int
> > > > +xfs_rtginode_ilock_cmp_fn(
> > > > +	const struct lockdep_map	*m1,
> > > > +	const struct lockdep_map	*m2)
> > > > +{
> > > > +	const struct xfs_inode *ip1 =
> > > > +		container_of(m1, struct xfs_inode, i_lock.dep_map);
> > > > +	const struct xfs_inode *ip2 =
> > > > +		container_of(m2, struct xfs_inode, i_lock.dep_map);
> > > > +
> > > > +	if (ip1->i_projid < ip2->i_projid)
> > > > +		return -1;
> > > > +	if (ip1->i_projid > ip2->i_projid)
> > > > +		return 1;
> > > > +	return 0;
> > > > +}
> > > 
> > > What's the project ID of the inode got to do with realtime groups?
> > 
> > Each rtgroup metadata file stores its group number in i_projid so that
> > mount can detect if there's a corruption in /rtgroup and we just opened
> > the bitmap from the wrong group.
> > 
> > We can also use lockdep to detect code that locks rtgroup metadata in
> > the wrong order.  Potentially we could use this _cmp_fn to enforce that
> > we always ILOCK in the order bitmap -> summary -> rmap -> refcount based
> > on i_metatype.
> 
> Ok, can we union the i_projid field (both in memory and in the
> on-disk structure) so that dual use of the field is well documented
> by the code?

Sounds good to me.  Does

union {
	xfs_prid_t	i_projid;
	uint32_t	i_metagroup;
};

sound ok?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
