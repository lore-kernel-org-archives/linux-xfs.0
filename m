Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F53FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 01:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A18F20738
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 01:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgHXBZk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 21:25:40 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:52578 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727849AbgHXBZj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 21:25:39 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E4698D5BAB1;
        Mon, 24 Aug 2020 11:25:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kA1El-000103-RE; Mon, 24 Aug 2020 11:25:27 +1000
Date:   Mon, 24 Aug 2020 11:25:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200824012527.GP7941@dread.disaster.area>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594159.965217.2504039364311840477.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797594159.965217.2504039364311840477.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=A7yIu_s94ueTpfuYD9AA:9 a=a421RlV_TY06pUPi:21
        a=SirWIMnFauxEfyZP:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:12:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> time epoch).  This enables us to handle dates up to 2486, which solves
> the y2038 problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

....

> @@ -875,6 +888,25 @@ union xfs_timestamp {
>   */
>  #define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
>  
> +/*
> + * Number of seconds between the start of the bigtime timestamp range and the
> + * start of the Unix epoch.
> + */
> +#define XFS_INO_BIGTIME_EPOCH	(-XFS_INO_TIME_MIN)

This is confusing. It's taken me 15 minutes so far to get my head
around this because the reference frame for all these definitions is
not clear. I though these had something to do with nanosecond
timestamp limits because that's what BIGTIME records, but.....

The start of the epoch is a negative number based on the definition
of the on-disk format for the minimum number of seconds that the
"Unix" timestamp format can store?  Why is this not defined in
nanoseconds given that is what is stored on disk?

XFS_INO_BIGTIME_EPOCH = (-XFS_INO_TIME_MIN)
			= (-((int64_t)S32_MIN))
			= (-((int64_t)-2^31))
			= 2^31?

So the bigtime epoch is considered to be 2^31 *seconds* into the
range of the on-disk nanosecond timestamp? Huh?

> +
> +/*
> + * Smallest possible timestamp with big timestamps, which is
> + * Dec 13 20:45:52 UTC 1901.
> + */
> +#define XFS_INO_BIGTIME_MIN	(XFS_INO_TIME_MIN)

Same here. The reference here is "seconds before the Unix epoch",
not the minimum valid on disk nanosecond value.

Oh, these are defining the post-disk-to-in-memory-format conversion
limits? They have nothing to do with on-disk limits nor that on-disk
format is stored in nanosecond? i.e. the reference frame for these
limits is actually still the in-kernel Unix epoch definition?

> +/*
> + * Largest possible timestamp with big timestamps, which is
> + * Jul  2 20:20:25 UTC 2486.
> + */
> +#define XFS_INO_BIGTIME_MAX	((int64_t)((-1ULL / NSEC_PER_SEC) - \
> +					   XFS_INO_BIGTIME_EPOCH))

Urk. This makes my head -hurt-.

It's converting the maximum on-disk format nanosecond count to a
maximum second count then taking away the second count for the epoch
and then casting it to a signed int because the in-memory format for
seconds is signed? Oh, and the 64 bit division is via constants, so
the compiler does it and doesn't need to use something like
div_u64(), right?

Mind you, I'm just guessing here that the "-1ULL" is the
representation of the maximum on-disk nanosecond timestamp here,
because that doesn't seem to be defined anywhere....


> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index cc1316a5fe0c..c59ddb56bb90 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -157,11 +157,25 @@ xfs_imap_to_bp(
>  	return 0;
>  }
>  
> +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
>  void
>  xfs_inode_from_disk_timestamp(
> +	struct xfs_dinode		*dip,
>  	struct timespec64		*tv,
>  	const union xfs_timestamp	*ts)
>  {
> +	if (dip->di_version >= 3 &&
> +	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {

Helper. xfs_dinode_has_bigtime() was what I suggested previously.

> +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> +		uint64_t		s;
> +		uint32_t		n;
> +
> +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> +		tv->tv_nsec = n;
> +		return;
> +	}
> +
>  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
>  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
>  }

I still don't really like the way this turned out :(

> @@ -220,9 +234,9 @@ xfs_inode_from_disk(
>  	 * a time before epoch is converted to a time long after epoch
>  	 * on 64 bit systems.
>  	 */
> -	xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
> -	xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
> -	xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
> +	xfs_inode_from_disk_timestamp(from, &inode->i_atime, &from->di_atime);
> +	xfs_inode_from_disk_timestamp(from, &inode->i_mtime, &from->di_mtime);
> +	xfs_inode_from_disk_timestamp(from, &inode->i_ctime, &from->di_ctime);
>  
>  	to->di_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> @@ -235,9 +249,17 @@ xfs_inode_from_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> -		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> +		xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> +				&from->di_crtime);
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> +		/*
> +		 * Set the bigtime flag incore so that we automatically convert
> +		 * this inode's ondisk timestamps to bigtime format the next
> +		 * time we write the inode core to disk.
> +		 */
> +		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
> +			to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
>  	}

iAs I said before, you can't set this flag here - it needs to be
done transactionally when the timestamp is next logged.


> @@ -259,9 +281,19 @@ xfs_inode_from_disk(
>  
>  void
>  xfs_inode_to_disk_timestamp(
> +	struct xfs_icdinode		*from,
>  	union xfs_timestamp		*ts,
>  	const struct timespec64		*tv)
>  {
> +	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {

Shouldn't this also check the inode version number like the dinode
decoder? Perhaps a helper like xfs_inode_has_bigtime(ip)?

> +		uint64_t		t;
> +
> +		t = (uint64_t)(tv->tv_sec + XFS_INO_BIGTIME_EPOCH);

tv_sec can still overflow, right?

		t = (uint64_t)tv->tv_sec + XFS_INO_BIGTIME_EPOCH;

> +		t *= NSEC_PER_SEC;
> +		ts->t_bigtime = cpu_to_be64(t + tv->tv_nsec);
> +		return;
> +	}
> +
>  	ts->t_sec = cpu_to_be32(tv->tv_sec);
>  	ts->t_nsec = cpu_to_be32(tv->tv_nsec);
>  }
> @@ -285,9 +317,9 @@ xfs_inode_to_disk(
>  	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
> -	xfs_inode_to_disk_timestamp(&to->di_atime, &inode->i_atime);
> -	xfs_inode_to_disk_timestamp(&to->di_mtime, &inode->i_mtime);
> -	xfs_inode_to_disk_timestamp(&to->di_ctime, &inode->i_ctime);
> +	xfs_inode_to_disk_timestamp(from, &to->di_atime, &inode->i_atime);
> +	xfs_inode_to_disk_timestamp(from, &to->di_mtime, &inode->i_mtime);
> +	xfs_inode_to_disk_timestamp(from, &to->di_ctime, &inode->i_ctime);
>  	to->di_nlink = cpu_to_be32(inode->i_nlink);
>  	to->di_gen = cpu_to_be32(inode->i_generation);
>  	to->di_mode = cpu_to_be16(inode->i_mode);
> @@ -306,7 +338,8 @@ xfs_inode_to_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> -		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
> +		xfs_inode_to_disk_timestamp(from, &to->di_crtime,
> +				&from->di_crtime);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
> @@ -526,6 +559,11 @@ xfs_dinode_verify(
>  	if (fa)
>  		return fa;
>  
> +	/* bigtime iflag can only happen on bigtime filesystems */
> +	if ((flags2 & (XFS_DIFLAG2_BIGTIME)) &&
> +	    !xfs_sb_version_hasbigtime(&mp->m_sb))

	if (xfs_dinode_has_bigtime(dip) &&
	    !xfs_sb_version_hasbigtime(&mp->m_sb))

> +void xfs_inode_to_disk_timestamp(struct xfs_icdinode *from,
> +		union xfs_timestamp *ts, const struct timespec64 *tv);
>  
>  #endif	/* __XFS_INODE_BUF_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 17c83d29998c..569721f7f9e5 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -373,6 +373,9 @@ union xfs_ictimestamp {
>  		int32_t		t_sec;		/* timestamp seconds */
>  		int32_t		t_nsec;		/* timestamp nanoseconds */
>  	};
> +
> +	/* Nanoseconds since the bigtime epoch. */
> +	uint64_t		t_bigtime;
>  };

Where are we using this again? Right now the timestamps are
converted directly into the VFS inode timestamp fields so we can get
rid of these incore timestamp fields. So shouldn't we be trying to
get rid of this structure rather than adding more functionality to
it?

> @@ -131,6 +131,17 @@ xfs_trans_log_inode(
>  			iversion_flags = XFS_ILOG_CORE;
>  	}
>  
> +	/*
> +	 * If we're updating the inode core or the timestamps and it's possible
> +	 * to upgrade this inode to bigtime format, do so now.
> +	 */
> +	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> +	    xfs_sb_version_hasbigtime(&tp->t_mountp->m_sb) &&
> +	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME)) {

The latter two checks could be wrapped up into a helper named
something obvious like xfs_inode_need_bigtime(ip)?

> +		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> +		flags |= XFS_ILOG_CORE;
> +	}
> +
>  	/*
>  	 * Record the specific change for fdatasync optimisation. This allows
>  	 * fdatasync to skip log forces for inodes that are only timestamp
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 9f036053fdb7..6f00309de2d4 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -190,6 +190,11 @@ xchk_inode_flags2(
>  	if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
>  		goto bad;
>  
> +	/* no bigtime iflag without the bigtime feature */
> +	if (!xfs_sb_version_hasbigtime(&mp->m_sb) &&
> +	    (flags2 & XFS_DIFLAG2_BIGTIME))

Can we get all these open coded checks wrapped up into a single
helper?

> +		xchk_dinode_nsec(sc, ino, dip, &dip->di_crtime);
>  		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
>  		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
>  				flags2);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..bbc309bc70c4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -841,6 +841,8 @@ xfs_ialloc(
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
>  		ip->i_d.di_flags2 = 0;
> +		if (xfs_sb_version_hasbigtime(&mp->m_sb))
> +			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;

Rather than calculate the initial inode falgs on every allocation,
shouldn't we just have the defaults pre-calculated at mount time?

>  		ip->i_d.di_cowextsize = 0;
>  		ip->i_d.di_crtime = tv;
>  	}
> @@ -2717,7 +2719,11 @@ xfs_ifree(
>  
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
> -	ip->i_d.di_flags2 = 0;
> +	/*
> +	 * Preserve the bigtime flag so that di_ctime accurately stores the
> +	 * deletion time.
> +	 */
> +	ip->i_d.di_flags2 &= XFS_DIFLAG2_BIGTIME;

Oh, that's a nasty wart.

>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
> @@ -3503,6 +3509,13 @@ xfs_iflush(
>  			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
>  		goto flush_out;
>  	}
> +	if (xfs_sb_version_hasbigtime(&mp->m_sb) &&
> +	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME)) {
> +		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
> +			"%s: bad inode %Lu, bigtime unset, ptr "PTR_FMT,
> +			__func__, ip->i_ino, ip);
> +		goto flush_out;
> +	}

Why is this a fatal corruption error? if the bigtime flag is not
set, we can still store and read the timestamp if it is within
the unix epoch range...

>  
>  	/*
>  	 * Inode item log recovery for v2 inodes are dependent on the
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index cec6d4d82bc4..c38af3eea48f 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -298,9 +298,16 @@ xfs_inode_item_format_attr_fork(
>  /* Write a log_dinode timestamp into an ondisk inode timestamp. */
>  static inline void
>  xfs_log_dinode_to_disk_ts(
> +	struct xfs_log_dinode		*from,
>  	union xfs_timestamp		*ts,
>  	const union xfs_ictimestamp	*its)
>  {
> +	if (from->di_version >= 3 &&
> +	    (from->di_flags2 & XFS_DIFLAG2_BIGTIME)) {

helper.

> +		ts->t_bigtime = cpu_to_be64(its->t_bigtime);
> +		return;
> +	}
> +
>  	ts->t_sec = cpu_to_be32(its->t_sec);
>  	ts->t_nsec = cpu_to_be32(its->t_nsec);
>  }
> @@ -322,9 +329,9 @@ xfs_log_dinode_to_disk(
>  	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
>  	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
>  
> -	xfs_log_dinode_to_disk_ts(&to->di_atime, &from->di_atime);
> -	xfs_log_dinode_to_disk_ts(&to->di_mtime, &from->di_mtime);
> -	xfs_log_dinode_to_disk_ts(&to->di_ctime, &from->di_ctime);
> +	xfs_log_dinode_to_disk_ts(from, &to->di_atime, &from->di_atime);
> +	xfs_log_dinode_to_disk_ts(from, &to->di_mtime, &from->di_mtime);
> +	xfs_log_dinode_to_disk_ts(from, &to->di_ctime, &from->di_ctime);
>  
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> @@ -340,7 +347,7 @@ xfs_log_dinode_to_disk(
>  
>  	if (from->di_version == 3) {
>  		to->di_changecount = cpu_to_be64(from->di_changecount);
> -		xfs_log_dinode_to_disk_ts(&to->di_crtime, &from->di_crtime);
> +		xfs_log_dinode_to_disk_ts(from, &to->di_crtime, &from->di_crtime);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(from->di_ino);
> @@ -356,9 +363,19 @@ xfs_log_dinode_to_disk(
>  /* Write an incore inode timestamp into a log_dinode timestamp. */
>  static inline void
>  xfs_inode_to_log_dinode_ts(
> +	struct xfs_icdinode		*from,
>  	union xfs_ictimestamp		*its,
>  	const struct timespec64		*ts)
>  {
> +	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {
> +		uint64_t		t;
> +
> +		t = (uint64_t)(ts->tv_sec + XFS_INO_BIGTIME_EPOCH);
> +		t *= NSEC_PER_SEC;
> +		its->t_bigtime = t + ts->tv_nsec;

helper,

> +		return;
> +	}
> +
>  	its->t_sec = ts->tv_sec;
>  	its->t_nsec = ts->tv_nsec;
>  }
> @@ -381,9 +398,9 @@ xfs_inode_to_log_dinode(
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	memset(to->di_pad3, 0, sizeof(to->di_pad3));
> -	xfs_inode_to_log_dinode_ts(&to->di_atime, &inode->i_atime);
> -	xfs_inode_to_log_dinode_ts(&to->di_mtime, &inode->i_mtime);
> -	xfs_inode_to_log_dinode_ts(&to->di_ctime, &inode->i_ctime);
> +	xfs_inode_to_log_dinode_ts(from, &to->di_atime, &inode->i_atime);
> +	xfs_inode_to_log_dinode_ts(from, &to->di_mtime, &inode->i_mtime);
> +	xfs_inode_to_log_dinode_ts(from, &to->di_ctime, &inode->i_ctime);
>  	to->di_nlink = inode->i_nlink;
>  	to->di_gen = inode->i_generation;
>  	to->di_mode = inode->i_mode;
> @@ -405,7 +422,7 @@ xfs_inode_to_log_dinode(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = inode_peek_iversion(inode);
> -		xfs_inode_to_log_dinode_ts(&to->di_crtime, &from->di_crtime);
> +		xfs_inode_to_log_dinode_ts(from, &to->di_crtime, &from->di_crtime);
>  		to->di_flags2 = from->di_flags2;
>  		to->di_cowextsize = from->di_cowextsize;
>  		to->di_ino = ip->i_ino;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd..13396c3665d1 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1190,7 +1190,8 @@ xfs_flags2diflags2(
>  	unsigned int		xflags)
>  {
>  	uint64_t		di_flags2 =
> -		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> +		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
> +				      XFS_DIFLAG2_BIGTIME));
>  
>  	if (xflags & FS_XFLAG_DAX)
>  		di_flags2 |= XFS_DIFLAG2_DAX;
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 7158a8de719f..3e0c677cff15 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -25,6 +25,9 @@ xfs_check_limits(void)
>  	/* make sure timestamp limits are correct */
>  	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
>  	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_EPOCH,			2147483648LL);
> +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_MIN,			-2147483648LL);

That still just doesn't look right to me :/

This implies that the epoch is 2^32 seconds after then minimum
supported time (2038), when in fact it is only 2^31 seconds after the
minimum supported timestamp (1970). :/

> +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_MAX,			16299260425LL);

Hmmm. I got 16299260424 when I just ran this through a simple calc.
Mind you, no calculator app I found could handle unsigned 64 bit
values natively (signed 64 bit is good enough for everyone!) so
maybe I got an off-by one here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
