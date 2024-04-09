Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E0E38DC9
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 21:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712697174; cv=none; b=F+zqZ0/WtyDyAu1CCYTTyYMYzWJEE5j93db8BG8z5ABT1EI1RvyPzT3xxo3R978ckqs8er6eeUlt25Rnj7RVh0XDGzaqVMH5uLZgYorlq2jM+Qsv0JBIlVXEj0ab6PdEUUSdzXxTG7KKtGPMvhYOq5Zi9Rwq7lTs9y/ooq+kCeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712697174; c=relaxed/simple;
	bh=/IyutyKHW7R5/8nsID+KbqbBvpp3qXOFkwxM28/P5Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eo+75C6wdP9I47DqR2i6ctfTmRen0rlY9YZy97Jp0Gkt5+dgU2ZTlkrZUgrPUrS2ubR70Ta5C7KJB4TXrgQhSNBbxjqpuTzCgjz99LPxON9d/IsSJYej4vZgQm3SzFTK4mhVPzP8djNxy/S7mDxBqS/9p635/wpvGHdmbAyTfNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqsAu2Y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqsAu2Y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE75C433C7;
	Tue,  9 Apr 2024 21:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712697174;
	bh=/IyutyKHW7R5/8nsID+KbqbBvpp3qXOFkwxM28/P5Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gqsAu2Y4zeo2m7J5RH2N6QQ2OKuDwIylo2JIoxy50gdnrH1LMeQfYKzDxXxDxJC4a
	 vGChkysWaoknonTnlyxMWCVMEG7U8QJlwBkh8Lkq6x2USuizppXhGQFYmL2dJ90WyC
	 +SKpHAt8KwYjecZuGfjUtNGm0aM5c5lKc5KKChvmapwA88ok1WWrRHgWNL33aAkCwK
	 b46MCq72fPKM5OPSTVtfiEb6iM2NtRq3X+Eft8bnCewDT9CBTjQt1y30AFbFOyX28F
	 yR32Sqq/wLt1QC9ZH5xUIJz1voi0OnncoxrMy7VI/frTJkIymPBGU6jipcB5MEXX0W
	 Dp/dG+bK4aLdQ==
Date: Tue, 9 Apr 2024 14:12:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: create a log incompat flag for atomic file
 mapping exchanges
Message-ID: <20240409211253.GG6390@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380715.3216674.13307875397061790548.stgit@frogsfrogsfrogs>
 <ZhMpc58ZiQOPWBQE@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhMpc58ZiQOPWBQE@dread.disaster.area>

On Mon, Apr 08, 2024 at 09:17:07AM +1000, Dave Chinner wrote:
> On Tue, Mar 26, 2024 at 06:53:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a log incompat flag so that we only attempt to process file
> > mapping exchange log items if the filesystem supports it, and a geometry
> > flag to advertise support if it's present or could be present.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
> >  fs/xfs/libxfs/xfs_fs.h     |    3 +++
> >  fs/xfs/libxfs/xfs_sb.c     |    3 +++
> >  fs/xfs/xfs_exchrange.c     |   31 +++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_exchrange.h     |    2 ++
> >  5 files changed, 52 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 2b2f9050fbfbb..753adde56a2d0 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -391,6 +391,12 @@ xfs_sb_has_incompat_feature(
> >  }
> >  
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
> > +
> > +/*
> > + * Log contains file mapping exchange log intent items which are not otherwise
> > + * protected by an INCOMPAT/RO_COMPAT feature flag.
> > + */
> > +#define XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS (1 << 1)
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> >  	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
> > @@ -423,6 +429,13 @@ static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
> >  		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> >  }
> >  
> > +static inline bool xfs_sb_version_haslogexchmaps(struct xfs_sb *sbp)
> > +{
> > +	return xfs_sb_is_v5(sbp) &&
> > +		(sbp->sb_features_log_incompat &
> > +		 XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS);
> > +}
> > +
> >  static inline bool
> >  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
> >  {
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 8a1e30cf4dc88..ea07fb7b89722 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -240,6 +240,9 @@ typedef struct xfs_fsop_resblks {
> >  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
> >  #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
> >  
> > +/* file range exchange available to userspace */
> > +#define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE	(1 << 24)
> > +
> >  /*
> >   * Minimum and maximum sizes need for growth checks.
> >   *
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index d991eec054368..c2d86faeee61b 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -26,6 +26,7 @@
> >  #include "xfs_health.h"
> >  #include "xfs_ag.h"
> >  #include "xfs_rtbitmap.h"
> > +#include "xfs_exchrange.h"
> >  
> >  /*
> >   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> > @@ -1258,6 +1259,8 @@ xfs_fs_geometry(
> >  	}
> >  	if (xfs_has_large_extent_counts(mp))
> >  		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
> > +	if (xfs_exchrange_possible(mp))
> > +		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
> >  	geo->rtsectsize = sbp->sb_blocksize;
> >  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
> >  
> > diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> > index a575e26ae1a58..620cf1eb7464b 100644
> > --- a/fs/xfs/xfs_exchrange.c
> > +++ b/fs/xfs/xfs_exchrange.c
> > @@ -15,6 +15,37 @@
> >  #include "xfs_exchrange.h"
> >  #include <linux/fsnotify.h>
> >  
> > +/*
> > + * If the filesystem has relatively new features enabled, we're willing to
> > + * upgrade the filesystem to have the EXCHMAPS log incompat feature.
> > + * Technically we could do this with any V5 filesystem, but let's not deal
> > + * with really old kernels.
> > + */
> 
> Please document tnis in the commit message - this decision needs to
> be seen by anyone reading the commit history rather than the code...

This is irrelevant seeing as this whole patchset now uses a regular
incompat bit, but who actually reads *only* the commit history and
ignores the code?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
