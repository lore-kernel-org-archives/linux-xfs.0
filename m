Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B512F22
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724724093; cv=none; b=WS+j8Zrz6BGTINWWGhR0nAlQjqo700YU7hNcW3echyAbrfUVxw0GXJqA+yTypz/nq2RvVrCMgtRhIrQx5eyccQKRR3RMwyRYi7UqI4D//tEuXs68bXr12IBVbkMUmV1E+vzz5fD+KGs1rpnj0Rh/DQykew/NMQsAbVcMvYAlls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724724093; c=relaxed/simple;
	bh=Guq/cAt5gIGNgct8hynF6ikO2NRwoxGg3E4E/cuNDns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3colxyROPFllAeMS9ej6CFitMjI0thOcO/PCQ89Eirq/eQ9P2XBdmeXo5/nVhXdg79CjXwKL3gY8zFB9SvlUxCNdRcXzEMWL995/OF4ARzYSKp73em0IGxxlUo3LSUTRb8O1x4nIWCyvButOM8YhFlg24tPwigXP3oqqpNsEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtztymC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtztymC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F698C8B7A1;
	Tue, 27 Aug 2024 02:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724724092;
	bh=Guq/cAt5gIGNgct8hynF6ikO2NRwoxGg3E4E/cuNDns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FtztymC/OMjvPhGrTzNSGxGsV0TXhgK++yfhalNs9+Ca3mq9ezQfdaF8pfywpLPAC
	 ElSASGnWdp5z+FhYZWFFC/9+1KqfuhH2OHykFCYsRCK9mSOogcsIXGWIFRIE22fZ8R
	 yNXxY5bjYZsNnH6/dobxStjH1qJRXwvtKZ6Aa1HJoTdevYuBXlvcMUOQcYeYXeMhAN
	 34rVgo7mw9CM6bigyJVXukJiJpAuy5RwwCBO7B9W381EK3nMqMzQDcA+OruTk/bOuh
	 NnBRpVsnCexa79LiPG5Z/OtEqfwPvz4AhwOnMJe8AbBw4VKtqS+ssoV2M4aGmfQx+I
	 LHAn9jXBht3tw==
Date: Mon, 26 Aug 2024 19:01:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>, b@magnolia.djwong.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: support caching rtgroup metadata inodes
Message-ID: <20240827020132.GF6082@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
 <ZsvdP4IaRNpJcavt@dread.disaster.area>
 <20240826183734.GB865349@frogsfrogsfrogs>
 <Zs0mcWjsEzTeAysF@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0mcWjsEzTeAysF@dread.disaster.area>

On Tue, Aug 27, 2024 at 11:05:53AM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2024 at 11:37:34AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2024 at 11:41:19AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 22, 2024 at 05:18:18PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Create the necessary per-rtgroup infrastructure that we need to load
> > > > metadata inodes into memory.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_rtgroup.c |  182 +++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_rtgroup.h |   28 +++++++
> > > >  fs/xfs/xfs_mount.h          |    1 
> > > >  fs/xfs/xfs_rtalloc.c        |   48 +++++++++++
> > > >  4 files changed, 258 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > > > index ae6d67c673b1a..50e4a56d749f0 100644
> > > > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > > > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > > > @@ -30,6 +30,8 @@
> > > >  #include "xfs_icache.h"
> > > >  #include "xfs_rtgroup.h"
> > > >  #include "xfs_rtbitmap.h"
> > > > +#include "xfs_metafile.h"
> > > > +#include "xfs_metadir.h"
> > > >  
> > > >  /*
> > > >   * Passive reference counting access wrappers to the rtgroup structures.  If
> > > > @@ -295,3 +297,183 @@ xfs_rtginode_lockdep_setup(
> > > >  #else
> > > >  #define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
> > > >  #endif /* CONFIG_PROVE_LOCKING */
> > > > +
> > > > +struct xfs_rtginode_ops {
> > > > +	const char		*name;	/* short name */
> > > > +
> > > > +	enum xfs_metafile_type	metafile_type;
> > > > +
> > > > +	/* Does the fs have this feature? */
> > > > +	bool			(*enabled)(struct xfs_mount *mp);
> > > > +
> > > > +	/* Create this rtgroup metadata inode and initialize it. */
> > > > +	int			(*create)(struct xfs_rtgroup *rtg,
> > > > +					  struct xfs_inode *ip,
> > > > +					  struct xfs_trans *tp,
> > > > +					  bool init);
> > > > +};
> > > 
> > > What's all this for?
> > > 
> > > AFAICT, loading the inodes into the rtgs requires a call to
> > > xfs_metadir_load() when initialising the rtg (either at mount or
> > > lazily on the first access to the rtg). Hence I'm not really sure
> > > what this complexity is needed for, and the commit message is not
> > > very informative....
> > 
> > Yes, the creation and mkdir code in here is really to support growfs,
> > mkfs, and repair.  How about I change the commit message to:
> > 
> > "Create the necessary per-rtgroup infrastructure that we need to load
> > metadata inodes into memory and to create directory trees on the fly.
> > Loading is needed by the mounting process.  Creation is needed by
> > growfs, mkfs, and repair."
> 
> IMO it would have been nicer to add this with the patch that
> adds growfs support for rtgs. That way the initial inode loading
> would be much easier to understand and review, and the rest of it
> would have enough context to be able to review it sanely. There
> isn't enough context in this patch to determine if the creation code
> is sane or works correctly....

<nod> I think that's doable.  I also want to change the name to
->init_inode because that's the only thing it can really do at the point
that we're creating inodes in growfs.

> 
> > > > +	path = xfs_rtginode_path(rtg->rtg_rgno, type);
> > > > +	if (!path)
> > > > +		return -ENOMEM;
> > > > +	error = xfs_metadir_load(tp, mp->m_rtdirip, path, ops->metafile_type,
> > > > +			&ip);
> > > > +	kfree(path);
> > > > +
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> > > > +			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
> > > > +		xfs_irele(ip);
> > > > +		return -EFSCORRUPTED;
> > > > +	}
> > > 
> > > We don't support LOCAL format for any type of regular file inodes,
> > > so I'm a little confiused as to why this wouldn't be caught by the
> > > verifier on inode read? i.e.  What problem is this trying to catch,
> > > and why doesn't the inode verifier catch it for us?
> > 
> > This is really more of a placeholder for more refactorings coming down
> > the line for the rtrmap patchset, which will create a new
> > XFS_DINODE_FMT_RMAP.  At that time we'll need to check that an inode
> > that we are loading to be the rmap btree actually has that set.
> 
> Ok, can you leave a comment to indicate this so I don't have to
> remember why this code exists?

Will do.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
