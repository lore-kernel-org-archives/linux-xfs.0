Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBAFC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 04:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiBYE7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 23:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBYE7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 23:59:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BAC179A23
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 20:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18228618F7
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 04:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E0C340E7;
        Fri, 25 Feb 2022 04:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645765110;
        bh=5ZIkCBjHiGRRsgIwX2gpgX06vmFP+7gCgkROjuuGbHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kBtjqxEXJLMyJQxLLzyeSqktgH0aA6SAXU+ZpEK5Kq7Y43+kCgvlXvE+EYZmaXSBh
         YAVe5rY4iRqOa3V0l0nHIszs0Ft3rFkaI7fRU0P4OYbxcCxAAhuR1YzibHOI+q71NC
         gsXk29jJ2/tZFydi1mw7CrXMON2boB05Y+lXe2XrqgDTczKOcwFP+HSHxgOfGksPvb
         tvJlpr5KX2RRPnyjxjshGE8tEJaf3F6AY8kJwf4XUhTwDs1qRKc2JZQmWYDJk+Yndi
         r037KAnnsyb1l5TvvNGDv19FWw9cqABKh1VGsjpkkAaDhhptAU2NJbg7heX1Okhi/9
         tcTsOYbtRjeFA==
Date:   Thu, 24 Feb 2022 20:58:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V6 12/17] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <20220225045829.GJ8338@magnolia>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
 <20220224130211.1346088-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224130211.1346088-13-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 24, 2022 at 06:32:06PM +0530, Chandan Babu R wrote:
> This commit introduces new fields in the on-disk inode format to support
> 64-bit data fork extent counters and 32-bit attribute fork extent
> counters. The new fields will be used only when an inode has
> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
> data fork extent counters and 16-bit attribute fork extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>

Looks good!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h      | 33 ++++++++++++--
>  fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
>  fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
>  fs/xfs/libxfs/xfs_log_format.h  | 33 ++++++++++++--
>  fs/xfs/xfs_inode_item.c         | 23 ++++++++--
>  fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
>  6 files changed, 196 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d3dfd45c39e0..1a5b194da191 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -792,16 +792,41 @@ struct xfs_dinode {
>  	__be32		di_nlink;	/* number of links to file */
>  	__be16		di_projid_lo;	/* lower part of owner's project id */
>  	__be16		di_projid_hi;	/* higher part owner's project id */
> -	__u8		di_pad[6];	/* unused, zeroed space */
> -	__be16		di_flushiter;	/* incremented on flush */
> +	union {
> +		/* Number of data fork extents if NREXT64 is set */
> +		__be64	di_big_nextents;
> +
> +		/* Padding for V3 inodes without NREXT64 set. */
> +		__be64	di_v3_pad;
> +
> +		/* Padding and inode flush counter for V2 inodes. */
> +		struct {
> +			__u8	di_v2_pad[6];
> +			__be16	di_flushiter;
> +		};
> +	};
>  	xfs_timestamp_t	di_atime;	/* time last accessed */
>  	xfs_timestamp_t	di_mtime;	/* time last modified */
>  	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
>  	__be64		di_size;	/* number of bytes in file */
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> -	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	union {
> +		/*
> +		 * For V2 inodes and V3 inodes without NREXT64 set, this
> +		 * is the number of data and attr fork extents.
> +		 */
> +		struct {
> +			__be32	di_nextents;
> +			__be16	di_anextents;
> +		} __packed;
> +
> +		/* Number of attr fork extents if NREXT64 is set. */
> +		struct {
> +			__be32	di_big_anextents;
> +			__be16	di_nrext64_pad;
> +		} __packed;
> +	} __packed;
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 34f360a38603..a11d3ea5ebfe 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -279,6 +279,25 @@ xfs_inode_to_disk_ts(
>  	return ts;
>  }
>  
> +static inline void
> +xfs_inode_to_disk_iext_counters(
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*to)
> +{
> +	if (xfs_inode_has_nrext64(ip)) {
> +		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
> +		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
> +		/*
> +		 * We might be upgrading the inode to use larger extent counters
> +		 * than was previously used. Hence zero the unused field.
> +		 */
> +		to->di_nrext64_pad = cpu_to_be16(0);
> +	} else {
> +		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> +		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> +	}
> +}
> +
>  void
>  xfs_inode_to_disk(
>  	struct xfs_inode	*ip,
> @@ -296,7 +315,6 @@ xfs_inode_to_disk(
>  	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
>  	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>  
> -	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
>  	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
>  	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
> @@ -307,8 +325,6 @@ xfs_inode_to_disk(
>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
>  	to->di_extsize = cpu_to_be32(ip->i_extsize);
> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
> @@ -323,11 +339,14 @@ xfs_inode_to_disk(
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
> -		to->di_flushiter = 0;
> +		to->di_v3_pad = 0;
>  	} else {
>  		to->di_version = 2;
>  		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
> +		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
>  	}
> +
> +	xfs_inode_to_disk_iext_counters(ip, to);
>  }
>  
>  static xfs_failaddr_t
> @@ -397,6 +416,24 @@ xfs_dinode_verify_forkoff(
>  	return NULL;
>  }
>  
> +static xfs_failaddr_t
> +xfs_dinode_verify_nrext64(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dip)
> +{
> +	if (xfs_dinode_has_nrext64(dip)) {
> +		if (!xfs_has_nrext64(mp))
> +			return __this_address;
> +		if (dip->di_nrext64_pad != 0)
> +			return __this_address;
> +	} else if (dip->di_version >= 3) {
> +		if (dip->di_v3_pad != 0)
> +			return __this_address;
> +	}
> +
> +	return NULL;
> +}
> +
>  xfs_failaddr_t
>  xfs_dinode_verify(
>  	struct xfs_mount	*mp,
> @@ -440,6 +477,10 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	fa = xfs_dinode_verify_nrext64(mp, dip);
> +	if (fa)
> +		return fa;
> +
>  	nextents = xfs_dfork_data_extents(dip);
>  	nextents += xfs_dfork_attr_extents(dip);
>  	nblocks = be64_to_cpu(dip->di_nblocks);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index e56803436c61..8e6221e32660 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -156,6 +156,9 @@ static inline xfs_extnum_t
>  xfs_dfork_data_extents(
>  	struct xfs_dinode	*dip)
>  {
> +	if (xfs_dinode_has_nrext64(dip))
> +		return be64_to_cpu(dip->di_big_nextents);
> +
>  	return be32_to_cpu(dip->di_nextents);
>  }
>  
> @@ -163,6 +166,9 @@ static inline xfs_extnum_t
>  xfs_dfork_attr_extents(
>  	struct xfs_dinode	*dip)
>  {
> +	if (xfs_dinode_has_nrext64(dip))
> +		return be32_to_cpu(dip->di_big_anextents);
> +
>  	return be16_to_cpu(dip->di_anextents);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index fd66e70248f7..12234a880e94 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -388,16 +388,41 @@ struct xfs_log_dinode {
>  	uint32_t	di_nlink;	/* number of links to file */
>  	uint16_t	di_projid_lo;	/* lower part of owner's project id */
>  	uint16_t	di_projid_hi;	/* higher part of owner's project id */
> -	uint8_t		di_pad[6];	/* unused, zeroed space */
> -	uint16_t	di_flushiter;	/* incremented on flush */
> +	union {
> +		/* Number of data fork extents if NREXT64 is set */
> +		uint64_t	di_big_nextents;
> +
> +		/* Padding for V3 inodes without NREXT64 set. */
> +		uint64_t	di_v3_pad;
> +
> +		/* Padding and inode flush counter for V2 inodes. */
> +		struct {
> +			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
> +			uint16_t di_flushiter;	/* V2 inode incremented on flush */
> +		};
> +	};
>  	xfs_log_timestamp_t di_atime;	/* time last accessed */
>  	xfs_log_timestamp_t di_mtime;	/* time last modified */
>  	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> -	uint32_t	di_nextents;	/* number of extents in data fork */
> -	uint16_t	di_anextents;	/* number of extents in attribute fork*/
> +	union {
> +		/*
> +		 * For V2 inodes and V3 inodes without NREXT64 set, this
> +		 * is the number of data and attr fork extents.
> +		 */
> +		struct {
> +			uint32_t  di_nextents;
> +			uint16_t  di_anextents;
> +		} __packed;
> +
> +		/* Number of attr fork extents if NREXT64 is set. */
> +		struct {
> +			uint32_t  di_big_anextents;
> +			uint16_t  di_nrext64_pad;
> +		} __packed;
> +	} __packed;
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 90d8e591baf8..0d2fe38dc6e5 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -358,6 +358,21 @@ xfs_copy_dm_fields_to_log_dinode(
>  	}
>  }
>  
> +static inline void
> +xfs_inode_to_log_dinode_iext_counters(
> +	struct xfs_inode	*ip,
> +	struct xfs_log_dinode	*to)
> +{
> +	if (xfs_inode_has_nrext64(ip)) {
> +		to->di_big_nextents = xfs_ifork_nextents(&ip->i_df);
> +		to->di_big_anextents = xfs_ifork_nextents(ip->i_afp);
> +		to->di_nrext64_pad = 0;
> +	} else {
> +		to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> +		to->di_anextents = xfs_ifork_nextents(ip->i_afp);
> +	}
> +}
> +
>  static void
>  xfs_inode_to_log_dinode(
>  	struct xfs_inode	*ip,
> @@ -373,7 +388,6 @@ xfs_inode_to_log_dinode(
>  	to->di_projid_lo = ip->i_projid & 0xffff;
>  	to->di_projid_hi = ip->i_projid >> 16;
>  
> -	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	memset(to->di_pad3, 0, sizeof(to->di_pad3));
>  	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode->i_atime);
>  	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode->i_mtime);
> @@ -385,8 +399,6 @@ xfs_inode_to_log_dinode(
>  	to->di_size = ip->i_disk_size;
>  	to->di_nblocks = ip->i_nblocks;
>  	to->di_extsize = ip->i_extsize;
> -	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> -	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_flags = ip->i_diflags;
> @@ -406,11 +418,14 @@ xfs_inode_to_log_dinode(
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
> -		to->di_flushiter = 0;
> +		to->di_v3_pad = 0;
>  	} else {
>  		to->di_version = 2;
>  		to->di_flushiter = ip->i_flushiter;
> +		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
>  	}
> +
> +	xfs_inode_to_log_dinode_iext_counters(ip, to);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 767a551816a0..c35796a4e9c5 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -148,6 +148,22 @@ static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
>  	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
>  }
>  
> +static inline void
> +xfs_log_dinode_to_disk_iext_counters(
> +	struct xfs_log_dinode	*from,
> +	struct xfs_dinode	*to)
> +{
> +	if (xfs_log_dinode_has_nrext64(from)) {
> +		to->di_big_nextents = cpu_to_be64(from->di_big_nextents);
> +		to->di_big_anextents = cpu_to_be32(from->di_big_anextents);
> +		to->di_nrext64_pad = cpu_to_be16(from->di_nrext64_pad);
> +	} else {
> +		to->di_nextents = cpu_to_be32(from->di_nextents);
> +		to->di_anextents = cpu_to_be16(from->di_anextents);
> +	}
> +
> +}
> +
>  STATIC void
>  xfs_log_dinode_to_disk(
>  	struct xfs_log_dinode	*from,
> @@ -164,7 +180,6 @@ xfs_log_dinode_to_disk(
>  	to->di_nlink = cpu_to_be32(from->di_nlink);
>  	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
>  	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
> -	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
>  
>  	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
>  	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
> @@ -173,8 +188,6 @@ xfs_log_dinode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -192,10 +205,13 @@ xfs_log_dinode_to_disk(
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &from->di_uuid);
> -		to->di_flushiter = 0;
> +		to->di_v3_pad = from->di_v3_pad;
>  	} else {
>  		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> +		memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
>  	}
> +
> +	xfs_log_dinode_to_disk_iext_counters(from, to);
>  }
>  
>  STATIC int
> @@ -209,6 +225,8 @@ xlog_recover_inode_commit_pass2(
>  	struct xfs_mount		*mp = log->l_mp;
>  	struct xfs_buf			*bp;
>  	struct xfs_dinode		*dip;
> +	xfs_extnum_t                    nextents;
> +	xfs_aextnum_t                   anextents;
>  	int				len;
>  	char				*src;
>  	char				*dest;
> @@ -348,21 +366,60 @@ xlog_recover_inode_commit_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> +
> +	if (xfs_log_dinode_has_nrext64(ldip)) {
> +		if (!xfs_has_nrext64(mp) || (ldip->di_nrext64_pad != 0)) {
> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> +				     XFS_ERRLEVEL_LOW, mp, ldip,
> +				     sizeof(*ldip));
> +			xfs_alert(mp,
> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
> +				"ino %Ld, xfs_has_nrext64(mp) = %d, "
> +				"ldip->di_nrext64_pad = %u",
> +				__func__, item, dip, bp, in_f->ilf_ino,
> +				xfs_has_nrext64(mp), ldip->di_nrext64_pad);
> +			error = -EFSCORRUPTED;
> +			goto out_release;
> +		}
> +	} else {
> +		if (ldip->di_version == 3 && ldip->di_big_nextents != 0) {
> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
> +				     XFS_ERRLEVEL_LOW, mp, ldip,
> +				     sizeof(*ldip));
> +			xfs_alert(mp,
> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
> +				"ino %Ld, ldip->di_big_dextcnt = %llu",
> +				__func__, item, dip, bp, in_f->ilf_ino,
> +				ldip->di_big_nextents);
> +			error = -EFSCORRUPTED;
> +			goto out_release;
> +		}
> +	}
> +
> +	if (xfs_log_dinode_has_nrext64(ldip)) {
> +		nextents = ldip->di_big_nextents;
> +		anextents = ldip->di_big_anextents;
> +	} else {
> +		nextents = ldip->di_nextents;
> +		anextents = ldip->di_anextents;
> +	}
> +
> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>  			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents + ldip->di_anextents,
> -			ldip->di_nblocks);
> +			nextents + anextents, ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
>  	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(8)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
> @@ -374,7 +431,7 @@ xlog_recover_inode_commit_pass2(
>  	}
>  	isize = xfs_log_dinode_size(mp);
>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(9)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
> -- 
> 2.30.2
> 
