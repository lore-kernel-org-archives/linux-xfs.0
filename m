Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049741FC7EC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729016742; cv=none; b=fKLsjklxvl9BOnWt7jayd3n5ziZLsAd9a9tRnVBFdmiKQbSzXvjQtbYdEVjcf6bCioT+4g4eQyjEBUfRQm0pVrVy26mbXkRWGYvWlWoj7xCdJrlVYdmLZrz3lYpbDAGtDFzt4/z12pSrrFn+CYnIYvUYY4TvdINZIYb8Fa6O2PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729016742; c=relaxed/simple;
	bh=2+JT7+fOKTIUUgXKxcY3ejNXXz9iqfKSvDqGS0LkMHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItO3JrV7c2dTBVEgMPs3BXSxQXpykoF12gsCXtIxXyOXcZoPdQqPSkQ4VAj+suIM+mOblF1qF1mvhqixvupk9ACc5a3wrMxmyavpo3oOKJA7En2i+AMSY6CcwiywaeAFPUo5Gs71fs0zh0S/RIhBfXQsL1tRz5nxIGEZQeDddS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWG8a++o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWG8a++o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8391C4CEC6;
	Tue, 15 Oct 2024 18:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729016741;
	bh=2+JT7+fOKTIUUgXKxcY3ejNXXz9iqfKSvDqGS0LkMHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWG8a++o9zc33Smaks/Yaq3Cle+RBXQwVBrzthIoCHhOvrt508z1EYrPyiuuX+PiH
	 S83xciQM2Z93XHTmyhrinPkZ4cw/8gYUpRDsG/gvVE5FrjJRQy49NVx06pyBCYY37z
	 DHuZ3rPO2MgBNSjFPlBFvQ4YNgLwjd3o5yHFMBWy8dLnODjeYnjkWY2aUrlY/BIJqU
	 GsoeP+gpbxjT2Hb5wyEUNSO+B/f3aoVBXcoeK9afAsiabMq+GBTGKwB8SF2j2eHPf3
	 NBMixFOKLzNvhlGCjd44sM3sAz8zSJdSp7BQxYj0tyv1gLZg3bv3LRr3RQZc3fwqd3
	 KJLovYn01nlmQ==
Date: Tue, 15 Oct 2024 11:25:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <20241015182541.GE21853@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
 <Zw3rjkSklol5xOzE@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3rjkSklol5xOzE@dread.disaster.area>

On Tue, Oct 15, 2024 at 03:11:58PM +1100, Dave Chinner wrote:
> On Thu, Oct 10, 2024 at 05:49:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Define the on-disk layout and feature flags for the metadata inode
> > directory feature.  Add a xfs_sb_version_hasmetadir for benefit of
> > xfs_repair, which needs to know where the new end of the superblock
> > lies.
> 
> Please just open code xfs_sb_version_hasmetadir() in xfs_repair,
> we moved away from loading up the on-disk format definition
> headers with these superblock feature helpers quite some time ago.

Ok.

> > @@ -790,6 +801,27 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
> >  	return (time64_t)ondisk_seconds - XFS_BIGTIME_EPOCH_OFFSET;
> >  }
> >  
> > +enum xfs_metafile_type {
> > +	XFS_METAFILE_UNKNOWN,		/* unknown */
> > +	XFS_METAFILE_DIR,		/* metadir directory */
> > +	XFS_METAFILE_USRQUOTA,		/* user quota */
> > +	XFS_METAFILE_GRPQUOTA,		/* group quota */
> > +	XFS_METAFILE_PRJQUOTA,		/* project quota */
> > +	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
> > +	XFS_METAFILE_RTSUMMARY,		/* rt summary */
> > +
> > +	XFS_METAFILE_MAX
> > +} __packed;
> 
> Ok, so that's all the initial things that we want to support. How do
> we handle expanding this list of types in future? i.e. does it
> require incompat or rocompat feature bit protection, new inode
> flags, and/or something else?

*Some* sort of feature flag, yes.  It's the same as any other dinode
extension -- the developer has to decide on a new incompat/rocompat flag
as appropriate.

> 
> > @@ -812,7 +844,10 @@ struct xfs_dinode {
> >  	__be16		di_mode;	/* mode and type of file */
> >  	__u8		di_version;	/* inode version */
> >  	__u8		di_format;	/* format of di_c data */
> > -	__be16		di_onlink;	/* old number of links to file */
> > +	union {
> > +		__be16	di_onlink;	/* old number of links to file */
> > +		__be16	di_metatype;	/* XFS_METAFILE_* */
> > +	} __packed; /* explicit packing because arm gcc bloats this up */
> 
> That's a nasty landmine. Does anything bad happen to the log dinode
> with the same compilers?

As hch said, no it doesn't, because we don't log di_onlink anymore.

> 
> >  	__be32		di_uid;		/* owner's user id */
> >  	__be32		di_gid;		/* owner's group id */
> >  	__be32		di_nlink;	/* number of links to file */
> > @@ -1092,17 +1127,47 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
> >  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
> >  #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
> > -#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
> > +#define XFS_DIFLAG2_NREXT64_BIT	4	/* large extent counters */
> > +#define XFS_DIFLAG2_METADATA_BIT	63	/* filesystem metadata */
> 
> Why bit 63?

I use high numbered bits for development code on the assumption that it
will take years to get through the review process and I don't want to
deal with the merge conflicts and cached fs image conflicts that will
happen if some other feature gets merged ahead of the one I'm working
on.  If and when the patchset gets close to finished I go through and
change them to the next available value.

This one should get changed from 63 to 5.  Most recently, I wasn't sure
if forcealign and atomicwrites would get merged first.

> > -#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
> > -#define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
> > -#define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
> > -#define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
> > -#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
> > +#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
> > +#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
> > +#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
> > +#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
> > +#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
> > +
> > +/*
> > + * The inode contains filesystem metadata and can be found through the metadata
> > + * directory tree.  Metadata inodes must satisfy the following constraints:
> > + *
> > + * - V5 filesystem (and ftype) are enabled;
> > + * - The only valid modes are regular files and directories;
> > + * - The access bits must be zero;
> > + * - DMAPI event and state masks are zero;
> > + * - The user and group IDs must be zero;
> > + * - The project ID can be used as a u32 annotation;
> > + * - The immutable, sync, noatime, nodump, nodefrag flags must be set.
> > + * - The dax flag must not be set.
> > + * - Directories must have nosymlinks set.
> > + *
> > + * These requirements are chosen defensively to minimize the ability of
> > + * userspace to read or modify the contents, should a metadata file ever
> > + * escape to userspace.
> > + *
> > + * There are further constraints on the directory tree itself:
> > + *
> > + * - Metadata inodes must never be resolvable through the root directory;
> > + * - They must never be accessed by userspace;
> > + * - Metadata directory entries must have correct ftype.
> > + *
> > + * Superblock-rooted metadata files must have the METADATA iflag set even
> > + * though they do not have a parent directory.
> > + */
> > +#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
> 
> I think the comment might be better placed on the XFS_DIFLAG2_METADATA_BIT
> definition. I read through the rework of the DIFLAG2 definitions
> from the bit values, and then went "huh, where's the
> XFS_DIFLAG2_METADATA definition?". I didn't notice it because it's
> separated from the rest of them by a 30 line comment...
> 
> So perhaps this would be better to do something like this ....
> 
> 
> /* use DAX for this inode */
> #define XFS_DIFLAG2_DAX_BIT		0
> 
> /* file's blocks may be shared */
> #define XFS_DIFLAG2_REFLINK_BIT		1
> 
> /* copy on write extent size hint */
> #define XFS_DIFLAG2_COWEXTSIZE_BIT	2
> 
> /* big timestamps */
> #define XFS_DIFLAG2_BIGTIME_BIT		3
> 
> /* large extent counters */
> #define XFS_DIFLAG2_NREXT64_BIT		4
> 
> /*
>  * The inode contains filesystem metadata and can be found through the metadata
>  * directory tree.  Metadata inodes must satisfy the following constraints:
>  *
>  * - V5 filesystem (and ftype) are enabled;
>  * - The only valid modes are regular files and directories;
>  * - The access bits must be zero;
>  * - DMAPI event and state masks are zero;
>  * - The user and group IDs must be zero;
>  * - The project ID can be used as a u32 annotation;
>  * - The immutable, sync, noatime, nodump, nodefrag flags must be set.
>  * - The dax flag must not be set.
>  * - Directories must have nosymlinks set.
>  *
>  * These requirements are chosen defensively to minimize the ability of
>  * userspace to read or modify the contents, should a metadata file ever
>  * escape to userspace.
>  *
>  * There are further constraints on the directory tree itself:
>  *
>  * - Metadata inodes must never be resolvable through the root directory;
>  * - They must never be accessed by userspace;
>  * - Metadata directory entries must have correct ftype.
>  *
>  * Superblock-rooted metadata files must have the METADATA iflag set even
>  * though they do not have a parent directory.
>  *
>  * XXX: why bit 63?
>  */
> #define XFS_DIFLAG2_METADATA_BIT	63
> 
> #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
> #define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
> #define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
> #define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
> #define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
> #define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)

Yeah, that's better.  I'll change that.

> 
> >  
> >  #define XFS_DIFLAG2_ANY \
> >  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> > -	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
> > +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
> >  
> >  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
> >  {
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 79babeac9d7546..cdd6ed4279649d 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -215,6 +215,8 @@ xfs_inode_from_disk(
> >  		set_nlink(inode, be32_to_cpu(from->di_nlink));
> >  		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
> >  					be16_to_cpu(from->di_projid_lo);
> > +		if (from->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))
> 
> 		if (xfs_is_metadir_dinode(from)) 

Ok.

> > +			ip->i_metatype = be16_to_cpu(from->di_metatype);
> >  	}
> >  
> >  	i_uid_write(inode, be32_to_cpu(from->di_uid));
> > @@ -315,7 +317,10 @@ xfs_inode_to_disk(
> >  	struct inode		*inode = VFS_I(ip);
> >  
> >  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > -	to->di_onlink = 0;
> > +	if (xfs_is_metadir_inode(ip))
> > +		to->di_metatype = cpu_to_be16(ip->i_metatype);
> > +	else
> > +		to->di_onlink = 0;
> >  
> >  	to->di_format = xfs_ifork_format(&ip->i_df);
> >  	to->di_uid = cpu_to_be32(i_uid_read(inode));
> > @@ -523,9 +528,13 @@ xfs_dinode_verify(
> >  	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
> >  	 * di_onlink==0, so we can check that.
> >  	 */
> > -	if (dip->di_version >= 2) {
> > +	if (dip->di_version == 2) {
> >  		if (dip->di_onlink)
> >  			return __this_address;
> > +	} else if (dip->di_version >= 3) {
> > +		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
> 
> xfs_is_metadir_dinode() again.
> 
> > +		    dip->di_onlink)
> > +			return __this_address;
> >  	}
> >  
> >  	/* don't allow invalid i_size */
> > diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> > index ec64eda3bbe2e1..3885ca68d8ae24 100644
> > --- a/fs/xfs/libxfs/xfs_inode_util.c
> > +++ b/fs/xfs/libxfs/xfs_inode_util.c
> > @@ -224,6 +224,8 @@ xfs_inode_inherit_flags2(
> >  	}
> >  	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
> >  		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
> > +	if (pip->i_diflags2 & XFS_DIFLAG2_METADATA)
> > +		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
> 
> 	if (xfs_is_metadir_inode(pip))
> 
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index d32716fb2fecf7..ec2c694c4083f8 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -421,7 +421,8 @@ xchk_dinode(
> >  		break;
> >  	case 2:
> >  	case 3:
> > -		if (dip->di_onlink != 0)
> > +		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
> > +		    dip->di_onlink != 0)
> 
> xfs_is_metadir_dinode() again. Though this is the same check as in
> xfs_dinode_verify() so maybe also a helper for that?

xfs_dinode_verify_onlink?

Dunno, it seems a little silly to add a helper for a format that we're
turning off by default in 11 months and removing in 5 years.

Eh whatever I don't feel like arguing.

> >  			xchk_ino_set_corrupt(sc, ino);
> >  
> >  		if (dip->di_mode == 0 && sc->ip)
> > diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> > index 5da9e1a387a8bb..fdc2f0d058d557 100644
> > --- a/fs/xfs/scrub/inode_repair.c
> > +++ b/fs/xfs/scrub/inode_repair.c
> > @@ -521,10 +521,13 @@ STATIC void
> >  xrep_dinode_nlinks(
> >  	struct xfs_dinode	*dip)
> >  {
> > -	if (dip->di_version > 1)
> > -		dip->di_onlink = 0;
> > -	else
> > +	if (dip->di_version < 2) {
> >  		dip->di_nlink = 0;
> > +		return;
> > +	}
> > +
> > +	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
> > +		dip->di_onlink = 0;
> 
> xfs_is_metadir_dinode() again.
> 
> >  }
> >  
> >  /* Fix any conflicting flags that the verifiers complain about. */
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index be7d4b26aaea3f..4b36dc2c9bf48b 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -65,6 +65,7 @@ typedef struct xfs_inode {
> >  		uint16_t	i_flushiter;	/* incremented on flush */
> >  	};
> >  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
> > +	enum xfs_metafile_type	i_metatype;	/* XFS_METAFILE_* */
> >  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
> >  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> >  	struct timespec64	i_crtime;	/* time created */
> > @@ -276,10 +277,23 @@ static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
> >  	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> >  }
> >  
> > +static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
> > +{
> > +	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
> > +}
> > +
> >  static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
> 
> Oh, that's going to get confusing. "is_metadir" checks the inode
> METADATA flag, and is "is_metadata" checks the superblock METADIR
> flag....
> 
> Can we change this to higher level function to
> xfs_inode_is_internal() or something else that is not easily
> confused with checking an inode flag?

But there's already xfs_internal_inum, which only covers sb-rooted
metadata inodes.  I guess first we have to rename that to xfs_is_sb_inum
in a separate patch, and then this one can add xfs_inode_is_internal.

> > diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> > index dbdab4ce7c44c4..40349333868076 100644
> > --- a/fs/xfs/xfs_inode_item_recover.c
> > +++ b/fs/xfs/xfs_inode_item_recover.c
> > @@ -175,7 +175,10 @@ xfs_log_dinode_to_disk(
> >  	to->di_mode = cpu_to_be16(from->di_mode);
> >  	to->di_version = from->di_version;
> >  	to->di_format = from->di_format;
> > -	to->di_onlink = 0;
> > +	if (from->di_flags2 & XFS_DIFLAG2_METADATA)
> > +		to->di_metatype = cpu_to_be16(from->di_metatype);
> > +	else
> > +		to->di_onlink = 0;
> 
> Just recover the field unconditionally - it's will be zero when
> XFS_DIFLAG2_METADATA is not set as this is what you modified the
> formatting code to do....

Ok.

> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 457c2d70968d9a..59953278964de9 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1733,6 +1733,10 @@ xfs_fs_fill_super(
> >  		mp->m_features &= ~XFS_FEAT_DISCARD;
> >  	}
> >  
> > +	if (xfs_has_metadir(mp))
> > +		xfs_warn(mp,
> > +"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
> > +
> 
> We really need a 'xfs_mark_experimental(mp, "Metadata directory")'
> function to format all these experimental feature warnings the same
> way....

We already have xfs_warn_mount for functionality that isn't sb feature
bits.  Maybe xfs_warn_feat?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
