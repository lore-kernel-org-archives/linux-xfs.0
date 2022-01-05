Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B646EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 01:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiAEBER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:04:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42450 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiAEBEQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:04:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6535D61614
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E2BC36AE0;
        Wed,  5 Jan 2022 01:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641344655;
        bh=ZAz7L/sy0ShdUygoDxNI4utBtG2HAevd0TFx+4PSvfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mV5Ac8IdcCV0B401XAyZaikqh/uP8sD0JdG059ZRpYWBfgNcibn5wPrp3nLBXbPsH
         ICTwxiQJuMT09pgfxWXBHB32zVOyxfQFUnz6FigKJyheyP9/h2ooM6vM4XmrOtM8F3
         MgmW6tcOk36EQHRXEi3v/7nLoFKD9gYErXncYAykVATgE6FY5urXJcWgqX9VLRroA7
         iURSZUQtzfnvgmsqtp7aqp52XXD9IrPtIZmPTZs+edAPahHyutqj0I+NtHrCZjKYkD
         0jqFNAJKlYbsmBrIyGcuiBTYkygQfSpOswKfxi/jEEmTgud8S4/gFdZOx0EmpjQMYt
         Gy53fUpMReGhQ==
Date:   Tue, 4 Jan 2022 17:04:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V4 12/16] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <20220105010415.GH31606@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-13-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:15PM +0530, Chandan Babu R wrote:
> This commit introduces new fields in the on-disk inode format to support
> 64-bit data fork extent counters and 32-bit attribute fork extent
> counters. The new fields will be used only when an inode has
> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
> data fork extent counters and 16-bit attribute fork extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h      | 22 +++++++--
>  fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
>  fs/xfs/libxfs/xfs_inode_fork.h  | 10 ++++-
>  fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
>  fs/xfs/xfs_inode_item.c         | 23 ++++++++--
>  fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
>  6 files changed, 176 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index eff86f6c4c99..2868cec1154d 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -792,16 +792,30 @@ struct xfs_dinode {
>  	__be32		di_nlink;	/* number of links to file */
>  	__be16		di_projid_lo;	/* lower part of owner's project id */
>  	__be16		di_projid_hi;	/* higher part owner's project id */
> -	__u8		di_pad[6];	/* unused, zeroed space */
> -	__be16		di_flushiter;	/* incremented on flush */
> +	union {
> +		__be64	di_big_dextcnt;	/* NREXT64 data extents */

Hm.  I was expecting "__be64 di_big_nextents" and "__be32
di_big_naextents" but I'm not sure if you're just following what Dave
suggested back in September or if there's a reason to deviate?

> +		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
> +		struct {
> +			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
> +			__be16	di_flushiter;	/* V2 inode incremented on flush */
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
> +		struct {
> +			__be32	di_big_aextcnt; /* NREXT64 attr extents */
> +			__be16	di_nrext64_pad; /* NREXT64 unused, zero */
> +		} __packed;
> +		struct {
> +			__be32	di_nextents;	/* !NREXT64 data extents */
> +			__be16	di_anextents;	/* !NREXT64 attr extents */
> +		} __packed;
> +	};
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 34f360a38603..fe21e9808f80 100644
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
> +		to->di_big_dextcnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
> +		to->di_big_aextcnt = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
> +		/*
> +		 * We might be upgrading the inode to use larger extent counters
> +		 * than was previously used. Hence zero the unused field.
> +		 */
> +		to->di_nrext64_pad = cpu_to_be16(0);

If you upgrade the inode to DIFLAG_NREXT64 in xfs_trans_log_inode, won't
zeroing xfs_log_dinode.di_nrext64_pad also clean out the xfs_dinode
field?

For that matter, what /was/ the resolution of the discussion about how
log recovery should work w.r.t. changing the nrext64 inode flag?  I
thought that the inode/transaction LSN checks during recovery suffice to
prevent recovery of pre-change values into a post-change ondisk inode?

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
> +		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
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
> +xfs_dinode_verify_nextents(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dip)
> +{
> +	if (xfs_dinode_has_nrext64(dip)) {
> +		if (!xfs_has_nrext64(mp))
> +			return __this_address;
> +		if (dip->di_nrext64_pad != 0)
> +			return __this_address;
> +	} else {
> +		if (dip->di_version == 3 && dip->di_big_dextcnt != 0)
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
> +	fa = xfs_dinode_verify_nextents(mp, dip);
> +	if (fa)
> +		return fa;
> +
>  	nextents = xfs_dfork_data_extents(dip);
>  	nextents += xfs_dfork_attr_extents(dip);
>  	nblocks = be64_to_cpu(dip->di_nblocks);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 0cfc351648f9..fa5143fb889b 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -156,14 +156,20 @@ static inline xfs_extnum_t
>  xfs_dfork_data_extents(
>  	struct xfs_dinode	*dip)
>  {
> -	return be32_to_cpu(dip->di_nextents);
> +	if (xfs_dinode_has_nrext64(dip))
> +		return be64_to_cpu(dip->di_big_dextcnt);
> +	else
> +		return be32_to_cpu(dip->di_nextents);

No need for the else in these helpers.

>  }
>  
>  static inline xfs_extnum_t
>  xfs_dfork_attr_extents(
>  	struct xfs_dinode	*dip)
>  {
> -	return be16_to_cpu(dip->di_anextents);
> +	if (xfs_dinode_has_nrext64(dip))
> +		return be32_to_cpu(dip->di_big_aextcnt);
> +	else
> +		return be16_to_cpu(dip->di_anextents);
>  }
>  
>  static inline xfs_extnum_t
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index fd66e70248f7..46aed637c98b 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -388,16 +388,30 @@ struct xfs_log_dinode {
>  	uint32_t	di_nlink;	/* number of links to file */
>  	uint16_t	di_projid_lo;	/* lower part of owner's project id */
>  	uint16_t	di_projid_hi;	/* higher part of owner's project id */
> -	uint8_t		di_pad[6];	/* unused, zeroed space */
> -	uint16_t	di_flushiter;	/* incremented on flush */
> +	union {
> +		uint64_t	di_big_dextcnt;	/* NREXT64 data extents */
> +		uint8_t		di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
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
> +		struct {
> +			uint32_t  di_big_aextcnt; /* NREXT64 attr extents */
> +			uint16_t  di_nrext64_pad; /* NREXT64 unused, zero */
> +		} __packed;
> +		struct {
> +			uint32_t  di_nextents;	  /* !NREXT64 data extents */
> +			uint16_t  di_anextents;	  /* !NREXT64 attr extents */
> +		} __packed;
> +	};
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 90d8e591baf8..82f4b9bb871b 100644
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
> +		to->di_big_dextcnt = xfs_ifork_nextents(&ip->i_df);
> +		to->di_big_aextcnt = xfs_ifork_nextents(ip->i_afp);
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
> +		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
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
> index 767a551816a0..7434ad4772dc 100644
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
> +		to->di_big_dextcnt = cpu_to_be64(from->di_big_dextcnt);
> +		to->di_big_aextcnt = cpu_to_be32(from->di_big_aextcnt);
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
> +		memcpy(to->di_v3_pad, from->di_v3_pad, sizeof(to->di_v3_pad));
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
> +		if (ldip->di_version == 3 && ldip->di_big_dextcnt != 0) {
> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
> +				     XFS_ERRLEVEL_LOW, mp, ldip,
> +				     sizeof(*ldip));
> +			xfs_alert(mp,
> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
> +				"ino %Ld, ldip->di_big_dextcnt = %llu",
> +				__func__, item, dip, bp, in_f->ilf_ino,
> +				ldip->di_big_dextcnt);
> +			error = -EFSCORRUPTED;
> +			goto out_release;
> +		}
> +	}
> +
> +	if (xfs_log_dinode_has_nrext64(ldip)) {
> +		nextents = ldip->di_big_dextcnt;
> +		anextents = ldip->di_big_aextcnt;
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
