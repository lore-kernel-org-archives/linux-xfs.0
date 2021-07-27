Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC90C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5781C60F9B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhG0XJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhG0XJO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 19:09:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC8860EB2;
        Tue, 27 Jul 2021 23:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627427353;
        bh=ie4LXk7G1KGMmbq2k0wU/xcTJ3OmVxq2HRvAtDlYxqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bIr1nIsvniTV2bB51DXRvMZZqJGah6IgFOMlpDEu/VGQUQvbVcTZn1tN/MclHpeDc
         Hkd3XGma6dLSEczfpDMQ5fAHe0sZ7nBtIfLYBDjC23qyX7alcSo2KW22lwJr2KtKYd
         U9cCwFRC3pQCy9cQ4tUW7DsT7Xh4QmdjUQjBZts4PLTeSzK+mwpvWggNEsH38Z1dvC
         USYUbsCDTZbgX00hPymnFO9kYPlfRNnz+pJHhGHYuXduij48OH7cRG08opwLO2jcHy
         WXd6XWe3AGWZVM72/D/k0SUFEWhJLMpE6j0OSbBZBk1Fq35TaVoc+Cw0GEcY+aVSkr
         dJHcVOPRV+/fw==
Date:   Tue, 27 Jul 2021 16:09:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 11/12] xfs: Extend per-inode extent counter widths
Message-ID: <20210727230913.GU559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-12-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:40PM +0530, Chandan Babu R wrote:
> This commit adds a new 64-bit per-inode data extent counter. However the
> maximum number of extents that a data fork can hold is limited to 2^48
> extents. This feature is available only when
> XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT feature bit is enabled on the
> filesystem. Also, enabling this feature bit causes attr fork extent counter to
> use the 32-bit extent counter that was previously used to hold the data fork
> extent counter. This implies that the attr fork can now occupy a maximum of
> 2^32 extents.
> 
> This commit also exposes the newly introduced XFS_IOC_BULKSTAT_V6 ioctl
> interface to user space.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c        |  8 +++-----
>  fs/xfs/libxfs/xfs_format.h      | 27 ++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_fs.h          |  1 +
>  fs/xfs/libxfs/xfs_inode_buf.c   | 28 ++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_inode_fork.h  | 22 +++++++++++++++++-----
>  fs/xfs/libxfs/xfs_log_format.h  |  3 ++-
>  fs/xfs/scrub/inode_repair.c     | 11 +++++++++--
>  fs/xfs/xfs_inode.c              |  2 +-
>  fs/xfs/xfs_inode_item.c         | 15 +++++++++++++--
>  fs/xfs/xfs_inode_item_recover.c | 25 +++++++++++++++++++------
>  fs/xfs/xfs_ioctl.c              |  3 +++
>  11 files changed, 116 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a27d57ea301c..e05898c9acbc 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -54,18 +54,16 @@ xfs_bmap_compute_maxlevels(
>  	int		whichfork)	/* data or attr fork */
>  {
>  	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
> +	uint64_t	maxblocks;	/* max blocks at this level */

xfs_rfsblock_t?

>  	int		level;		/* btree level */
> -	uint		maxblocks;	/* max blocks at this level */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
>  	int		sz;		/* root block size */
>  
>  	/*
> -	 * The maximum number of extents in a file, hence the maximum number of
> -	 * leaf entries, is controlled by the size of the on-disk extent count,
> -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> -	 * number for the attr fork.
> +	 * The maximum number of extents in a fork, hence the maximum number of
> +	 * leaf entries, is controlled by the size of the on-disk extent count.
>  	 *
>  	 * Note that we can no longer assume that if we are in ATTR1 that the
>  	 * fork offset of all the inodes will be
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 2362cc005cc6..3aa83d75670d 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -485,13 +485,15 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
>  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
>  #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 5)	/* metadata dir tree */
> -#define XFS_SB_FEAT_INCOMPAT_ALL \
> +#define XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT (1 << 6)	/* 64-bit inode fork extent counter */
> +#define XFS_SB_FEAT_INCOMPAT_ALL		\
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>  		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
>  		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
>  		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
> -		 XFS_SB_FEAT_INCOMPAT_METADIR)
> +		 XFS_SB_FEAT_INCOMPAT_METADIR| \

Oh hey, this /definitely/ branches off djwong-dev. :)

> +		 XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT)

Hm.  I don't think we're ever going to want to support more than u48
extent counts because that's a lot of memory consumption.  It might be
safe to call this by a shorter name, e.g.

	BIGBMAP?
	SUPERSPARSE?	(no, too long)
	EXT64		(beat that, ext4!)
	NREXT64

I kinda like BIGBMAP since it's actually pronounceable...

>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -591,6 +593,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
>  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
>  }
>  
> +static inline bool xfs_sb_version_hasextcount_64bit(struct xfs_sb *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT);
> +}
> +
>  static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
>  {
>  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> @@ -1039,6 +1047,16 @@ typedef struct xfs_dinode {
>  	__be64		di_size;	/* number of bytes in file */
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> +
> +	/*
> +	 * On a extcnt64bit filesystem, di_nextents64 holds the data fork
> +	 * extent count, di_nextents32 holds the attr fork extent count,
> +	 * and di_nextents16 must be zero.
> +	 *
> +	 * Otherwise, di_nextents32 holds the data fork extent count,
> +	 * di_nextents16 holds the attr fork extent count, and di_nextents64
> +	 * must be zero.

(See earlier comments about reusing di_pad[6])

> +	 */
>  	__be32		di_nextents32;	/* number of extents in data fork */
>  	__be16		di_nextents16;	/* number of extents in attribute fork*/
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> @@ -1057,7 +1075,8 @@ typedef struct xfs_dinode {
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__u8		di_pad2[4];	/* more padding for future expansion */
> +	__be64		di_nextents64;
>  
>  	/* fields only written to during inode creation */
>  	xfs_timestamp_t	di_crtime;	/* time created */
> @@ -1113,6 +1132,8 @@ enum xfs_dinode_fmt {
>   * Max values for extlen and disk inode's extent counters.
>   */
>  #define	MAXEXTLEN		((uint32_t)0x1fffff) /* 21 bits */
> +#define XFS_IFORK_EXTCNT_MAXU48	((uint64_t)0xffffffffffff) /* Unsigned 48-bits */
> +#define XFS_IFORK_EXTCNT_MAXU32	((uint32_t)0xffffffff)	/* Unsigned 32-bits */
>  #define XFS_IFORK_EXTCNT_MAXS32 ((int32_t)0x7fffffff)  /* Signed 32-bits */
>  #define XFS_IFORK_EXTCNT_MAXS16 ((int16_t)0x7fff)      /* Signed 16-bits */
>  
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 756be4ff5996..57f67445f095 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -858,6 +858,7 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_BULKSTAT_V5	     _IOR ('X', 127, struct xfs_bulkstat_req)
>  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
>  /*	FIEXCHANGE_RANGE ----------- hoisted 129	 */
> +#define XFS_IOC_BULKSTAT_V6	     _IOR ('X', 130, struct xfs_bulkstat_req)

(See earlier comments about adding flags to xfs_bulk_ireq so we don't
have to rev the ioctl definitions yet again.)

>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 65d753e16007..28e49394edbb 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -291,6 +291,7 @@ xfs_inode_to_disk(
>  	struct xfs_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> @@ -313,8 +314,6 @@ xfs_inode_to_disk(
>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
>  	to->di_extsize = cpu_to_be32(ip->i_extsize);
> -	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> -	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
> @@ -334,6 +333,19 @@ xfs_inode_to_disk(
>  		to->di_version = 2;
>  		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
>  	}
> +
> +	if (xfs_sb_version_hasextcount_64bit(sbp)) {
> +		to->di_nextents64 = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
> +		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));

Hmm, yes, these really should be separate helpers like what we did for
timestamps.

> +		/*
> +		 * xchk_dinode() passes an uninitialized disk inode. Hence,
> +		 * clear di_nextents16 field explicitly.

So fix xchk_dinode.

> +		 */
> +		to->di_nextents16 = cpu_to_be16(0);
> +	} else {
> +		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> +		to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> +	}
>  }
>  
>  static xfs_failaddr_t
> @@ -386,14 +398,22 @@ xfs_dfork_nextents(
>  	xfs_extnum_t		*nextents)
>  {
>  	int			error = 0;
> +	bool			has_64bit_extcnt;
> +
> +	has_64bit_extcnt = xfs_sb_version_hasextcount_64bit(&mp->m_sb);
> +
> +	if (has_64bit_extcnt && dip->di_nextents16 != 0)
> +		return -EFSCORRUPTED;

I think if you follow my suggestions to encode the upper 32/16 bits of
the extent counters in di_pad, the need for error codes (and patch 6) go
away completely.

>  
>  	switch (whichfork) {
>  	case XFS_DATA_FORK:
> -		*nextents = be32_to_cpu(dip->di_nextents32);
> +		*nextents = has_64bit_extcnt ? be64_to_cpu(dip->di_nextents64)
> +			: be32_to_cpu(dip->di_nextents32);
>  		break;
>  
>  	case XFS_ATTR_FORK:
> -		*nextents = be16_to_cpu(dip->di_nextents16);
> +		*nextents = has_64bit_extcnt ? be32_to_cpu(dip->di_nextents32)
> +			: be16_to_cpu(dip->di_nextents16);
>  		break;
>  
>  	default:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 1eda2163603e..ffdd2abcd73c 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -21,9 +21,9 @@ struct xfs_ifork {
>  		void		*if_root;	/* extent tree root */
>  		char		*if_data;	/* inline file data */
>  	} if_u1;
> +	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	int8_t			if_format;	/* format of this fork */
> -	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  };
>  
>  /*
> @@ -135,10 +135,22 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  
>  static inline xfs_extnum_t xfs_iext_max(struct xfs_mount *mp, int whichfork)
>  {
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> -		return XFS_IFORK_EXTCNT_MAXS32;
> -	else
> -		return XFS_IFORK_EXTCNT_MAXS16;
> +	bool has_64bit_extcnt = xfs_sb_version_hasextcount_64bit(&mp->m_sb);
> +
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +	case XFS_COW_FORK:
> +		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU48
> +			: XFS_IFORK_EXTCNT_MAXS32;
> +
> +	case XFS_ATTR_FORK:
> +		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU32
> +			: XFS_IFORK_EXTCNT_MAXS16;
> +
> +	default:
> +		ASSERT(0);
> +		return 0;
> +	}
>  }
>  
>  struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index ca8e4ad8312a..9b5d64708ed1 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -420,7 +420,8 @@ struct xfs_log_dinode {
>  	xfs_lsn_t	di_lsn;		/* flush sequence */
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> -	uint8_t		di_pad2[12];	/* more padding for future expansion */
> +	uint8_t		di_pad2[4];	/* more padding for future expansion */
> +	uint64_t	di_nextents64; /* higher part of data fork extent count */

Similarly, I think you should reuse di_pad in the log dinode for the
high bits of the extent count fields.

--D

>  
>  	/* fields only written to during inode creation */
>  	xfs_log_timestamp_t di_crtime;	/* time created */
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 4d773a16f886..dde6b700e891 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -736,7 +736,10 @@ xrep_dinode_zap_dfork(
>  {
>  	trace_xrep_dinode_zap_dfork(sc, dip);
>  
> -	dip->di_nextents32 = 0;
> +	if (xfs_sb_version_hasextcount_64bit(&sc->mp->m_sb))
> +		dip->di_nextents64 = 0;
> +	else
> +		dip->di_nextents32 = 0;
>  
>  	/* Special files always get reset to DEV */
>  	switch (mode & S_IFMT) {
> @@ -823,7 +826,11 @@ xrep_dinode_zap_afork(
>  	trace_xrep_dinode_zap_afork(sc, dip);
>  
>  	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
> -	dip->di_nextents16 = 0;
> +
> +	if (xfs_sb_version_hasextcount_64bit(&sc->mp->m_sb))
> +		dip->di_nextents32 = 0;
> +	else
> +		dip->di_nextents16 = 0;
>  
>  	dip->di_forkoff = 0;
>  	dip->di_mode = cpu_to_be16(mode & ~0777);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4070fb01350c..19d525093702 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2511,7 +2511,7 @@ xfs_iflush(
>  				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %llu, "
> -			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
> +			"total extents = %llu, nblocks = %lld, ptr "PTR_FMT,
>  			__func__, ip->i_ino,
>  			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
>  			ip->i_nblocks, ip);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f54ce7468ba1..3fa73100484b 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -364,6 +364,7 @@ xfs_inode_to_log_dinode(
>  	struct xfs_log_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = XFS_DINODE_MAGIC;
> @@ -385,8 +386,6 @@ xfs_inode_to_log_dinode(
>  	to->di_size = ip->i_disk_size;
>  	to->di_nblocks = ip->i_nblocks;
>  	to->di_extsize = ip->i_extsize;
> -	to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
> -	to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_flags = ip->i_diflags;
> @@ -402,6 +401,16 @@ xfs_inode_to_log_dinode(
>  		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
>  		to->di_flags2 = ip->i_diflags2;
>  		to->di_cowextsize = ip->i_cowextsize;
> +		if (xfs_sb_version_hasextcount_64bit(sbp)) {
> +			to->di_nextents64 = xfs_ifork_nextents(&ip->i_df);
> +			to->di_nextents32 = xfs_ifork_nextents(ip->i_afp);
> +			to->di_nextents16 = 0;
> +		} else {
> +			to->di_nextents64 = 0;
> +			to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
> +			to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
> +		}
> +
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> @@ -410,6 +419,8 @@ xfs_inode_to_log_dinode(
>  	} else {
>  		to->di_version = 2;
>  		to->di_flushiter = ip->i_flushiter;
> +		to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
> +		to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 40af9d1265c7..fcf360c03bc1 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -166,8 +166,6 @@ xfs_log_dinode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents32 = cpu_to_be32(from->di_nextents32);
> -	to->di_nextents16 = cpu_to_be16(from->di_nextents16);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -181,12 +179,17 @@ xfs_log_dinode_to_disk(
>  							  from->di_crtime);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_nextents64 = cpu_to_be64(from->di_nextents64);
> +		to->di_nextents32 = cpu_to_be32(from->di_nextents32);
> +		to->di_nextents16 = cpu_to_be16(from->di_nextents16);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &from->di_uuid);
>  		to->di_flushiter = 0;
>  	} else {
> +		to->di_nextents32 = cpu_to_be32(from->di_nextents32);
> +		to->di_nextents16 = cpu_to_be16(from->di_nextents16);
>  		to->di_flushiter = cpu_to_be16(from->di_flushiter);
>  	}
>  }
> @@ -202,6 +205,8 @@ xlog_recover_inode_commit_pass2(
>  	struct xfs_mount		*mp = log->l_mp;
>  	struct xfs_buf			*bp;
>  	struct xfs_dinode		*dip;
> +	xfs_extnum_t                    nextents;
> +	xfs_aextnum_t                   anextents;
>  	int				len;
>  	char				*src;
>  	char				*dest;
> @@ -332,16 +337,24 @@ xlog_recover_inode_commit_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents32 + ldip->di_nextents16 > ldip->di_nblocks)) {
> +
> +	if (xfs_sb_version_hasextcount_64bit(&mp->m_sb)) {
> +		nextents = ldip->di_nextents64;
> +		anextents = ldip->di_nextents32;
> +	} else {
> +		nextents = ldip->di_nextents32;
> +		anextents = ldip->di_nextents16;
> +	}
> +
> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>  			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents32 + ldip->di_nextents16,
> -			ldip->di_nblocks);
> +			nextents + anextents, ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 19964b394dc4..2d44aa655f41 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1901,6 +1901,9 @@ xfs_file_ioctl(
>  	case XFS_IOC_BULKSTAT_V5:
>  		return xfs_ioc_bulkstat(filp, cmd, arg,
>  				XFS_BULKSTAT_VERSION_V5);
> +	case XFS_IOC_BULKSTAT_V6:
> +		return xfs_ioc_bulkstat(filp, cmd, arg,
> +				XFS_BULKSTAT_VERSION_V6);
>  	case XFS_IOC_INUMBERS:
>  		return xfs_ioc_inumbers(mp, cmd, arg,
>  				XFS_INUMBERS_VERSION_V5);
> -- 
> 2.30.2
> 
