Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA818BC38
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724697455; cv=none; b=gsR+7dFnXuNAr05mqovu91GYYUuDKL/QYmlWE27eVZ9Ro3MiS0M5UNJL2ILwWt+/k4A6asNfTx7ZkG3LmFh1/XVp1I8FYfO8avCPRm85EYVOReHpq+lG0W2jXKE754eHoMxVY9y/pltiLFaoDNMHWMe8Td7es0M8UQA6ugx2mhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724697455; c=relaxed/simple;
	bh=dA6F3jXmy3yQb9DSVHz48UU3EeZT7ca5FYhAKyV9kcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e9C0+hTCLpH8eZpKLgNuhA4/Nqzfwmvp6hZF9CthCf6qy/D6CcQRRjF8Tv5uLmCwtIlLZSgLxISaz4fKce+Y9jKtndM+5ZBAqxwFfaPmjwwiR5mAGL4GosbmB45f9cos5Ctn5rA3x1g7iZIGC18g73k/T+fyLCYsUs0MGzOWLtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gr3pCZ2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gr3pCZ2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B54FC4FEE8;
	Mon, 26 Aug 2024 18:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724697455;
	bh=dA6F3jXmy3yQb9DSVHz48UU3EeZT7ca5FYhAKyV9kcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gr3pCZ2t7SzmFSrtbuVQvWZUe0QiavKh44UFskxxhBFyfYIvw9mtW2gFQKp5NX8IR
	 NcRgMYIpyZAtOmdG9u3wgjhcHX3FAr8bdMCqtI2xIhf0lxEijhQ3im0o1/pZ+pLsZY
	 yeDLWOx0HP7DErSwlY//NLQct3muFfYl6A378pMkUVaXqOZfJsNsVkT89fzoWxkRRT
	 9pmt7oWH7mnHIKHnH4iQgp8QAM6jmpMzuNtDqe5tARly0XRkkS2RQ27oGJj0deE1Hu
	 vafg6Po1cPzve8LCePAzUILIVB321Wzb63gFgv2p0/M+gmHrCt1z/BVqSs1i4Xdkov
	 4C5VclD2qZ0Ow==
Date: Mon, 26 Aug 2024 11:37:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: support caching rtgroup metadata inodes
Message-ID: <20240826183734.GB865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
 <ZsvdP4IaRNpJcavt@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsvdP4IaRNpJcavt@dread.disaster.area>

On Mon, Aug 26, 2024 at 11:41:19AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:18:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create the necessary per-rtgroup infrastructure that we need to load
> > metadata inodes into memory.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_rtgroup.c |  182 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_rtgroup.h |   28 +++++++
> >  fs/xfs/xfs_mount.h          |    1 
> >  fs/xfs/xfs_rtalloc.c        |   48 +++++++++++
> >  4 files changed, 258 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > index ae6d67c673b1a..50e4a56d749f0 100644
> > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > @@ -30,6 +30,8 @@
> >  #include "xfs_icache.h"
> >  #include "xfs_rtgroup.h"
> >  #include "xfs_rtbitmap.h"
> > +#include "xfs_metafile.h"
> > +#include "xfs_metadir.h"
> >  
> >  /*
> >   * Passive reference counting access wrappers to the rtgroup structures.  If
> > @@ -295,3 +297,183 @@ xfs_rtginode_lockdep_setup(
> >  #else
> >  #define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
> >  #endif /* CONFIG_PROVE_LOCKING */
> > +
> > +struct xfs_rtginode_ops {
> > +	const char		*name;	/* short name */
> > +
> > +	enum xfs_metafile_type	metafile_type;
> > +
> > +	/* Does the fs have this feature? */
> > +	bool			(*enabled)(struct xfs_mount *mp);
> > +
> > +	/* Create this rtgroup metadata inode and initialize it. */
> > +	int			(*create)(struct xfs_rtgroup *rtg,
> > +					  struct xfs_inode *ip,
> > +					  struct xfs_trans *tp,
> > +					  bool init);
> > +};
> 
> What's all this for?
> 
> AFAICT, loading the inodes into the rtgs requires a call to
> xfs_metadir_load() when initialising the rtg (either at mount or
> lazily on the first access to the rtg). Hence I'm not really sure
> what this complexity is needed for, and the commit message is not
> very informative....

Yes, the creation and mkdir code in here is really to support growfs,
mkfs, and repair.  How about I change the commit message to:

"Create the necessary per-rtgroup infrastructure that we need to load
metadata inodes into memory and to create directory trees on the fly.
Loading is needed by the mounting process.  Creation is needed by
growfs, mkfs, and repair."

> > +static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
> > +};
> > +
> > +/* Return the shortname of this rtgroup inode. */
> > +const char *
> > +xfs_rtginode_name(
> > +	enum xfs_rtg_inodes	type)
> > +{
> > +	return xfs_rtginode_ops[type].name;
> > +}
> > +
> > +/* Should this rtgroup inode be present? */
> > +bool
> > +xfs_rtginode_enabled(
> > +	struct xfs_rtgroup	*rtg,
> > +	enum xfs_rtg_inodes	type)
> > +{
> > +	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
> > +
> > +	if (!ops->enabled)
> > +		return true;
> > +	return ops->enabled(rtg->rtg_mount);
> > +}
> > +
> > +/* Load and existing rtgroup inode into the rtgroup structure. */
> > +int
> > +xfs_rtginode_load(
> > +	struct xfs_rtgroup	*rtg,
> > +	enum xfs_rtg_inodes	type,
> > +	struct xfs_trans	*tp)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	const char		*path;
> > +	struct xfs_inode	*ip;
> > +	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
> > +	int			error;
> > +
> > +	if (!xfs_rtginode_enabled(rtg, type))
> > +		return 0;
> > +
> > +	if (!mp->m_rtdirip)
> > +		return -EFSCORRUPTED;
> > +
> > +	path = xfs_rtginode_path(rtg->rtg_rgno, type);
> > +	if (!path)
> > +		return -ENOMEM;
> > +	error = xfs_metadir_load(tp, mp->m_rtdirip, path, ops->metafile_type,
> > +			&ip);
> > +	kfree(path);
> > +
> > +	if (error)
> > +		return error;
> > +
> > +	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> > +			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
> > +		xfs_irele(ip);
> > +		return -EFSCORRUPTED;
> > +	}
> 
> We don't support LOCAL format for any type of regular file inodes,
> so I'm a little confiused as to why this wouldn't be caught by the
> verifier on inode read? i.e.  What problem is this trying to catch,
> and why doesn't the inode verifier catch it for us?

This is really more of a placeholder for more refactorings coming down
the line for the rtrmap patchset, which will create a new
XFS_DINODE_FMT_RMAP.  At that time we'll need to check that an inode
that we are loading to be the rmap btree actually has that set.

> > +	if (XFS_IS_CORRUPT(mp, ip->i_projid != rtg->rtg_rgno)) {
> > +		xfs_irele(ip);
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> > +	xfs_rtginode_lockdep_setup(ip, rtg->rtg_rgno, type);
> > +	rtg->rtg_inodes[type] = ip;
> > +	return 0;
> > +}
> > +
> > +/* Release an rtgroup metadata inode. */
> > +void
> > +xfs_rtginode_irele(
> > +	struct xfs_inode	**ipp)
> > +{
> > +	if (*ipp)
> > +		xfs_irele(*ipp);
> > +	*ipp = NULL;
> > +}
> > +
> > +/* Add a metadata inode for a realtime rmap btree. */
> > +int
> > +xfs_rtginode_create(
> > +	struct xfs_rtgroup		*rtg,
> > +	enum xfs_rtg_inodes		type,
> > +	bool				init)
> 
> This doesn't seem to belong in this patchset...
> 
> ....
> 
> > +/* Create the parent directory for all rtgroup inodes and load it. */
> > +int
> > +xfs_rtginode_mkdir_parent(
> > +	struct xfs_mount	*mp)
> 
> Or this...
> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
