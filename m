Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA02B29B0
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 04:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728965525; cv=none; b=dGvsAt8sEechqSIql8CbqtJHe1TNdtodgvNoHtit4XgDz+ixmF1DDFCSX0ZtGKGD5QAiU5kpfsj9+3O8os1IeE+YewLIYzO/uNollzBViHJj6Vi4ZCNyLTuUHPFclzigva6tLrMfex+YXfA7O9oO6DxUxt5M2br93AeOSqaWjvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728965525; c=relaxed/simple;
	bh=Q359rvS3DLePMjubG9N70090DNZRRRvEbSSif2RglJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoLprZ0I8APKkYfgmLCCbnHhMqgFPBVOFXwF7aLrXRAgosN6gcXqDaj9JTfqiKK1vDVaghQrlcIPkpVWxb7ZTzDvECDDBnWeZ3j6KOSKLhNH90s+uSe6dnOn2OuYFSyeiLeNC0vne5lAI/CYSWVjMpG5IeZfsr6PP3U4MJh7UL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kDIowpTi; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kDIowpTi"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20cbcd71012so24648315ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 21:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728965522; x=1729570322; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3uZTjHP9bfumUD0nmZRyoR8s9dRYbeNMneY7h0rxVPg=;
        b=kDIowpTiqI5rOInrDv6v24Rnb9xuwDWRvoZ9k2o+aunyxUNx7Wkl9fx6Vsuer9sAQD
         hHgA6VN4kLpK+haA1g18SMJcqV17yWzzXHwHrwzyf1igNURZzB4UvlqKbHAx55uUPv+2
         Tm8gIh+psyA3rDIOqzRLyz6ilpLWaxQepdO0i/Bqd9CY/HHXuph6//FUYbNC8k4y4KWX
         oYeW0mKKefSHPAw9SUTE6oFiEOiBi7LSTdBxaqcOzozKAZtD/GWJvHqkHcRwH0p+uePG
         Ad9U2tfEw4GQNDZiptirx2U1bPuQRf+Dau4kmpnmuBMsgXVHtq8ZZ6o8tzyHA4P5tuGv
         PMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728965522; x=1729570322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3uZTjHP9bfumUD0nmZRyoR8s9dRYbeNMneY7h0rxVPg=;
        b=Ci8slz6Fit9/cflLPbleRg8z3dmDf8l48U/N29RWvCya5zuKsdxEMEWD21S6R6MkvX
         vtjBvEz1uDuyv0kyuN7SGy0dCfy5G4zsShBS3MhekjzEqStwVbo05g8ybMTb7pCkMQfz
         dOiQFmJDch3XiNNSbltBcqkBnrQrSni7sWRAkk2sv7EXn8x7WQxervmc+CPVSuK0Jjxt
         uohAUYKyuFMwIZe2swuxEiSSvis1toWUwapH+Yo219VMHn/sfjnpMlD9ojRyv+hx+d34
         TEkuNP3Fk37/kf6eb5+d8jRBtDZ8Fqi5RAbPCHNgPxQGt1iYux1LFVpDOhDecw2pYiYY
         c4yA==
X-Gm-Message-State: AOJu0YyJb7MFxqwHNKKD4I0GE0DmtrmV/LO82Oyt9XxA3tMySMtYA4zU
	98x2tdp+RoDD8tgSM8mrKOTTkZKixi3JBhJRPeehwtVfa82/D1l9txMo2qV7wfo=
X-Google-Smtp-Source: AGHT+IHWtWx+e0fiHnsxPfZ+ZFu6AnY0D5y0CtLIQ3O/24dAQ8qwoeeFgP7gCLirD06UmnJjbSKHJg==
X-Received: by 2002:a17:902:c942:b0:20c:81f2:3481 with SMTP id d9443c01a7336-20cbb1ca61dmr140575975ad.22.1728965522080;
        Mon, 14 Oct 2024 21:12:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1803673dsm3208035ad.155.2024.10.14.21.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 21:12:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0Yuc-000yjh-2G;
	Tue, 15 Oct 2024 15:11:58 +1100
Date: Tue, 15 Oct 2024 15:11:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <Zw3rjkSklol5xOzE@dread.disaster.area>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>

On Thu, Oct 10, 2024 at 05:49:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Define the on-disk layout and feature flags for the metadata inode
> directory feature.  Add a xfs_sb_version_hasmetadir for benefit of
> xfs_repair, which needs to know where the new end of the superblock
> lies.

Please just open code xfs_sb_version_hasmetadir() in xfs_repair,
we moved away from loading up the on-disk format definition
headers with these superblock feature helpers quite some time ago.

> @@ -790,6 +801,27 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
>  	return (time64_t)ondisk_seconds - XFS_BIGTIME_EPOCH_OFFSET;
>  }
>  
> +enum xfs_metafile_type {
> +	XFS_METAFILE_UNKNOWN,		/* unknown */
> +	XFS_METAFILE_DIR,		/* metadir directory */
> +	XFS_METAFILE_USRQUOTA,		/* user quota */
> +	XFS_METAFILE_GRPQUOTA,		/* group quota */
> +	XFS_METAFILE_PRJQUOTA,		/* project quota */
> +	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
> +	XFS_METAFILE_RTSUMMARY,		/* rt summary */
> +
> +	XFS_METAFILE_MAX
> +} __packed;

Ok, so that's all the initial things that we want to support. How do
we handle expanding this list of types in future? i.e. does it
require incompat or rocompat feature bit protection, new inode
flags, and/or something else?


> @@ -812,7 +844,10 @@ struct xfs_dinode {
>  	__be16		di_mode;	/* mode and type of file */
>  	__u8		di_version;	/* inode version */
>  	__u8		di_format;	/* format of di_c data */
> -	__be16		di_onlink;	/* old number of links to file */
> +	union {
> +		__be16	di_onlink;	/* old number of links to file */
> +		__be16	di_metatype;	/* XFS_METAFILE_* */
> +	} __packed; /* explicit packing because arm gcc bloats this up */

That's a nasty landmine. Does anything bad happen to the log dinode
with the same compilers?


>  	__be32		di_uid;		/* owner's user id */
>  	__be32		di_gid;		/* owner's group id */
>  	__be32		di_nlink;	/* number of links to file */
> @@ -1092,17 +1127,47 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
>  #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
> -#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
> +#define XFS_DIFLAG2_NREXT64_BIT	4	/* large extent counters */
> +#define XFS_DIFLAG2_METADATA_BIT	63	/* filesystem metadata */

Why bit 63?

> -#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
> -#define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
> -#define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
> -#define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
> -#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
> +#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
> +#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
> +#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
> +#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
> +#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
> +
> +/*
> + * The inode contains filesystem metadata and can be found through the metadata
> + * directory tree.  Metadata inodes must satisfy the following constraints:
> + *
> + * - V5 filesystem (and ftype) are enabled;
> + * - The only valid modes are regular files and directories;
> + * - The access bits must be zero;
> + * - DMAPI event and state masks are zero;
> + * - The user and group IDs must be zero;
> + * - The project ID can be used as a u32 annotation;
> + * - The immutable, sync, noatime, nodump, nodefrag flags must be set.
> + * - The dax flag must not be set.
> + * - Directories must have nosymlinks set.
> + *
> + * These requirements are chosen defensively to minimize the ability of
> + * userspace to read or modify the contents, should a metadata file ever
> + * escape to userspace.
> + *
> + * There are further constraints on the directory tree itself:
> + *
> + * - Metadata inodes must never be resolvable through the root directory;
> + * - They must never be accessed by userspace;
> + * - Metadata directory entries must have correct ftype.
> + *
> + * Superblock-rooted metadata files must have the METADATA iflag set even
> + * though they do not have a parent directory.
> + */
> +#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)

I think the comment might be better placed on the XFS_DIFLAG2_METADATA_BIT
definition. I read through the rework of the DIFLAG2 definitions
from the bit values, and then went "huh, where's the
XFS_DIFLAG2_METADATA definition?". I didn't notice it because it's
separated from the rest of them by a 30 line comment...

So perhaps this would be better to do something like this ....


/* use DAX for this inode */
#define XFS_DIFLAG2_DAX_BIT		0

/* file's blocks may be shared */
#define XFS_DIFLAG2_REFLINK_BIT		1

/* copy on write extent size hint */
#define XFS_DIFLAG2_COWEXTSIZE_BIT	2

/* big timestamps */
#define XFS_DIFLAG2_BIGTIME_BIT		3

/* large extent counters */
#define XFS_DIFLAG2_NREXT64_BIT		4

/*
 * The inode contains filesystem metadata and can be found through the metadata
 * directory tree.  Metadata inodes must satisfy the following constraints:
 *
 * - V5 filesystem (and ftype) are enabled;
 * - The only valid modes are regular files and directories;
 * - The access bits must be zero;
 * - DMAPI event and state masks are zero;
 * - The user and group IDs must be zero;
 * - The project ID can be used as a u32 annotation;
 * - The immutable, sync, noatime, nodump, nodefrag flags must be set.
 * - The dax flag must not be set.
 * - Directories must have nosymlinks set.
 *
 * These requirements are chosen defensively to minimize the ability of
 * userspace to read or modify the contents, should a metadata file ever
 * escape to userspace.
 *
 * There are further constraints on the directory tree itself:
 *
 * - Metadata inodes must never be resolvable through the root directory;
 * - They must never be accessed by userspace;
 * - Metadata directory entries must have correct ftype.
 *
 * Superblock-rooted metadata files must have the METADATA iflag set even
 * though they do not have a parent directory.
 *
 * XXX: why bit 63?
 */
#define XFS_DIFLAG2_METADATA_BIT	63

#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)


>  
>  #define XFS_DIFLAG2_ANY \
>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> -	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
> +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
>  
>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  {
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 79babeac9d7546..cdd6ed4279649d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -215,6 +215,8 @@ xfs_inode_from_disk(
>  		set_nlink(inode, be32_to_cpu(from->di_nlink));
>  		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
>  					be16_to_cpu(from->di_projid_lo);
> +		if (from->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))

		if (xfs_is_metadir_dinode(from)) 

> +			ip->i_metatype = be16_to_cpu(from->di_metatype);
>  	}
>  
>  	i_uid_write(inode, be32_to_cpu(from->di_uid));
> @@ -315,7 +317,10 @@ xfs_inode_to_disk(
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> -	to->di_onlink = 0;
> +	if (xfs_is_metadir_inode(ip))
> +		to->di_metatype = cpu_to_be16(ip->i_metatype);
> +	else
> +		to->di_onlink = 0;
>  
>  	to->di_format = xfs_ifork_format(&ip->i_df);
>  	to->di_uid = cpu_to_be32(i_uid_read(inode));
> @@ -523,9 +528,13 @@ xfs_dinode_verify(
>  	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
>  	 * di_onlink==0, so we can check that.
>  	 */
> -	if (dip->di_version >= 2) {
> +	if (dip->di_version == 2) {
>  		if (dip->di_onlink)
>  			return __this_address;
> +	} else if (dip->di_version >= 3) {
> +		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&

xfs_is_metadir_dinode() again.

> +		    dip->di_onlink)
> +			return __this_address;
>  	}
>  
>  	/* don't allow invalid i_size */
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index ec64eda3bbe2e1..3885ca68d8ae24 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -224,6 +224,8 @@ xfs_inode_inherit_flags2(
>  	}
>  	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
>  		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
> +	if (pip->i_diflags2 & XFS_DIFLAG2_METADATA)
> +		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;

	if (xfs_is_metadir_inode(pip))

> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index d32716fb2fecf7..ec2c694c4083f8 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -421,7 +421,8 @@ xchk_dinode(
>  		break;
>  	case 2:
>  	case 3:
> -		if (dip->di_onlink != 0)
> +		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
> +		    dip->di_onlink != 0)

xfs_is_metadir_dinode() again. Though this is the same check as in
xfs_dinode_verify() so maybe also a helper for that?

>  			xchk_ino_set_corrupt(sc, ino);
>  
>  		if (dip->di_mode == 0 && sc->ip)
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 5da9e1a387a8bb..fdc2f0d058d557 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -521,10 +521,13 @@ STATIC void
>  xrep_dinode_nlinks(
>  	struct xfs_dinode	*dip)
>  {
> -	if (dip->di_version > 1)
> -		dip->di_onlink = 0;
> -	else
> +	if (dip->di_version < 2) {
>  		dip->di_nlink = 0;
> +		return;
> +	}
> +
> +	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
> +		dip->di_onlink = 0;

xfs_is_metadir_dinode() again.

>  }
>  
>  /* Fix any conflicting flags that the verifiers complain about. */
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index be7d4b26aaea3f..4b36dc2c9bf48b 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -65,6 +65,7 @@ typedef struct xfs_inode {
>  		uint16_t	i_flushiter;	/* incremented on flush */
>  	};
>  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
> +	enum xfs_metafile_type	i_metatype;	/* XFS_METAFILE_* */
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
> @@ -276,10 +277,23 @@ static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
>  	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
>  }
>  
> +static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
> +{
> +	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
> +}
> +
>  static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)

Oh, that's going to get confusing. "is_metadir" checks the inode
METADATA flag, and is "is_metadata" checks the superblock METADIR
flag....

Can we change this to higher level function to
xfs_inode_is_internal() or something else that is not easily
confused with checking an inode flag?

> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index dbdab4ce7c44c4..40349333868076 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -175,7 +175,10 @@ xfs_log_dinode_to_disk(
>  	to->di_mode = cpu_to_be16(from->di_mode);
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> -	to->di_onlink = 0;
> +	if (from->di_flags2 & XFS_DIFLAG2_METADATA)
> +		to->di_metatype = cpu_to_be16(from->di_metatype);
> +	else
> +		to->di_onlink = 0;

Just recover the field unconditionally - it's will be zero when
XFS_DIFLAG2_METADATA is not set as this is what you modified the
formatting code to do....

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 457c2d70968d9a..59953278964de9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1733,6 +1733,10 @@ xfs_fs_fill_super(
>  		mp->m_features &= ~XFS_FEAT_DISCARD;
>  	}
>  
> +	if (xfs_has_metadir(mp))
> +		xfs_warn(mp,
> +"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
> +

We really need a 'xfs_mark_experimental(mp, "Metadata directory")'
function to format all these experimental feature warnings the same
way....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
