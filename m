Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FB4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 01:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbiAEBMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiAEBMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:12:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83FFC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 17:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 307B7614BB
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862CEC36AED;
        Wed,  5 Jan 2022 01:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641345133;
        bh=Xfc8IaTgZ07EemwQKxAYXiEqjJ0gOJdaRfTyzLquDsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eZpHzwQlczPh++TJB6TnBq2jPfZFTn37QZftJ6VHAKzpINBoPo4Gjn+WnY7B5i5PC
         tNB/Q3BECdboTa/FRAxCdVYN2r9CLx3jjYo+98OzyPzVIHySi6Jl8qc7kgVoHDD7Bp
         Wf8QdJW7cvHd07367yzijaz0cNdeQR+OBp+SoLFT1RAK8izH86ISbmzGS7G+F9hRrW
         DSFVtwna+RegHUj4Gst/VfKycDHWMBH9VnJ4/SeEXqfvvlvhTbrp4Z72NBZFfQc5QI
         5ZiSDhkx3SrGxAF+AqJOfZC35kp9hHsrcmRTuaRC4ZUaguyzK+n03VrGKTO5OJPvZl
         kCihbMMPhhOEQ==
Date:   Tue, 4 Jan 2022 17:12:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V4 13/20] xfsprogs: Introduce per-inode 64-bit extent
 counters
Message-ID: <20220105011213.GB656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084811.764481-14-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:18:04PM +0530, Chandan Babu R wrote:
> This commit introduces new fields in the on-disk inode format to support
> 64-bit data fork extent counters and 32-bit attribute fork extent
> counters. The new fields will be used only when an inode has
> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
> data fork extent counters and 16-bit attribute fork extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/field.c               |   4 -
>  db/field.h               |   2 -
>  db/inode.c               | 170 ++++++++++++++++++++++++++++++++++++++-
>  libxfs/xfs_format.h      |  22 ++++-
>  libxfs/xfs_inode_buf.c   |  27 ++++++-
>  libxfs/xfs_inode_fork.h  |  10 ++-
>  libxfs/xfs_log_format.h  |  22 ++++-
>  logprint/log_misc.c      |  20 ++++-
>  logprint/log_print_all.c |  18 ++++-
>  repair/dinode.c          |  18 ++++-
>  10 files changed, 279 insertions(+), 34 deletions(-)
> 
> diff --git a/db/field.c b/db/field.c
> index 51268938..1e274ffc 100644
> --- a/db/field.c
> +++ b/db/field.c
> @@ -25,8 +25,6 @@
>  #include "symlink.h"
>  
>  const ftattr_t	ftattrtab[] = {
> -	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
> -	  FTARG_SIGNED, NULL, NULL },
>  	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
>  	  FTARG_DONULL, fa_agblock, NULL },
>  	{ FLDT_AGBLOCKNZ, "agblocknz", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
> @@ -300,8 +298,6 @@ const ftattr_t	ftattrtab[] = {
>  	  FTARG_DONULL, fa_drtbno, NULL },
>  	{ FLDT_EXTLEN, "extlen", fp_num, "%u", SI(bitsz(xfs_extlen_t)), 0, NULL,
>  	  NULL },
> -	{ FLDT_EXTNUM, "extnum", fp_num, "%d", SI(bitsz(xfs_extnum_t)),
> -	  FTARG_SIGNED, NULL, NULL },
>  	{ FLDT_FSIZE, "fsize", fp_num, "%lld", SI(bitsz(xfs_fsize_t)),
>  	  FTARG_SIGNED, NULL, NULL },
>  	{ FLDT_INO, "ino", fp_num, "%llu", SI(bitsz(xfs_ino_t)), FTARG_DONULL,
> diff --git a/db/field.h b/db/field.h
> index 387c189e..614fd0ab 100644
> --- a/db/field.h
> +++ b/db/field.h
> @@ -5,7 +5,6 @@
>   */
>  
>  typedef enum fldt	{
> -	FLDT_AEXTNUM,
>  	FLDT_AGBLOCK,
>  	FLDT_AGBLOCKNZ,
>  	FLDT_AGF,
> @@ -143,7 +142,6 @@ typedef enum fldt	{
>  	FLDT_DRFSBNO,
>  	FLDT_DRTBNO,
>  	FLDT_EXTLEN,
> -	FLDT_EXTNUM,
>  	FLDT_FSIZE,
>  	FLDT_INO,
>  	FLDT_INOBT,
> diff --git a/db/inode.c b/db/inode.c
> index b1f92d36..226797be 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -27,6 +27,14 @@ static int	inode_core_nlinkv2_count(void *obj, int startoff);
>  static int	inode_core_onlink_count(void *obj, int startoff);
>  static int	inode_core_projid_count(void *obj, int startoff);
>  static int	inode_core_nlinkv1_count(void *obj, int startoff);
> +static int	inode_core_big_dextcnt_count(void *obj, int startoff);
> +static int	inode_core_v3_pad_count(void *obj, int startoff);
> +static int	inode_core_v2_pad_count(void *obj, int startoff);
> +static int	inode_core_flushiter_count(void *obj, int startoff);
> +static int	inode_core_big_aextcnt_count(void *obj, int startoff);
> +static int	inode_core_nrext64_pad_count(void *obj, int startoff);
> +static int	inode_core_nextents_count(void *obj, int startoff);
> +static int	inode_core_anextents_count(void *obj, int startoff);
>  static int	inode_f(int argc, char **argv);
>  static int	inode_u_offset(void *obj, int startoff, int idx);
>  static int	inode_u_bmbt_count(void *obj, int startoff);
> @@ -90,18 +98,30 @@ const field_t	inode_core_flds[] = {
>  	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
>  	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
>  	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
> -	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
> +	{ "big_dextcnt", FLDT_UINT64D, OI(COFF(big_dextcnt)),

Any reason we don't leave the display names as nextents and naextents?
I think fstests has a fair amount of hardcoded xfs_db output, right?

> +	  inode_core_big_dextcnt_count, FLD_COUNT, TYP_NONE },
> +	{ "v3_pad", FLDT_UINT8X, OI(OFF(v3_pad)),
> +	  inode_core_v3_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
> +	{ "v2_pad", FLDT_UINT8X, OI(OFF(v2_pad)),
> +	  inode_core_v2_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
>  	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
>  	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
> -	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
> +	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)),
> +	  inode_core_flushiter_count, FLD_COUNT, TYP_NONE },
>  	{ "atime", FLDT_TIMESTAMP, OI(COFF(atime)), C1, 0, TYP_NONE },
>  	{ "mtime", FLDT_TIMESTAMP, OI(COFF(mtime)), C1, 0, TYP_NONE },
>  	{ "ctime", FLDT_TIMESTAMP, OI(COFF(ctime)), C1, 0, TYP_NONE },
>  	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
>  	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
>  	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
> -	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
> -	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
> +	{ "big_aextcnt", FLDT_UINT32D, OI(COFF(big_aextcnt)),
> +	  inode_core_big_aextcnt_count, FLD_COUNT, TYP_NONE },
> +	{ "nrext64_pad", FLDT_UINT16D, OI(COFF(nrext64_pad)),
> +	  inode_core_nrext64_pad_count, FLD_COUNT, TYP_NONE },
> +	{ "nextents", FLDT_UINT32D, OI(COFF(nextents)),
> +	  inode_core_nextents_count, FLD_COUNT, TYP_NONE },
> +	{ "naextents", FLDT_UINT16D, OI(COFF(anextents)),
> +	  inode_core_anextents_count, FLD_COUNT, TYP_NONE },
>  	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
>  	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
>  	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
> @@ -403,6 +423,148 @@ inode_core_projid_count(
>  	return dic->di_version >= 2;
>  }
>  
> +static int
> +inode_core_big_dextcnt_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if (dic->di_version == 3 &&
> +		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))

(dic->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64)) ?

(I forget, does userspace's version of those macros elide constants?)

--D

> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int
> +inode_core_v3_pad_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if ((dic->di_version == 3)
> +		&& !(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
> +		return 8;
> +	else
> +		return 0;
> +}
> +
> +static int
> +inode_core_v2_pad_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if (dic->di_version == 3)
> +		return 0;
> +	else
> +		return 6;
> +}
> +
> +static int
> +inode_core_flushiter_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if (dic->di_version == 3)
> +		return 0;
> +	else
> +		return 1;
> +}
> +
> +static int
> +inode_core_big_aextcnt_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if (dic->di_version == 3 &&
> +		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int
> +inode_core_nrext64_pad_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if (dic->di_version == 3 &&
> +		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int
> +inode_core_nextents_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if ((dic->di_version == 3)
> +		&& (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
> +		return 0;
> +	else
> +		return 1;
> +}
> +
> +static int
> +inode_core_anextents_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_dinode	*dic;
> +
> +	ASSERT(startoff == 0);
> +	ASSERT(obj == iocur_top->data);
> +	dic = obj;
> +
> +	if ((dic->di_version == 3)
> +		&& (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
> +		return 0;
> +	else
> +		return 1;
> +}
> +
>  static int
>  inode_f(
>  	int		argc,
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index bdd13ec9..d4c962fc 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -980,16 +980,30 @@ typedef struct xfs_dinode {
>  	__be32		di_nlink;	/* number of links to file */
>  	__be16		di_projid_lo;	/* lower part of owner's project id */
>  	__be16		di_projid_hi;	/* higher part owner's project id */
> -	__u8		di_pad[6];	/* unused, zeroed space */
> -	__be16		di_flushiter;	/* incremented on flush */
> +	union {
> +		__be64	di_big_dextcnt;	/* NREXT64 data extents */
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
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index 9bddf790..5c6de73b 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -276,6 +276,25 @@ xfs_inode_to_disk_ts(
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
> +	} else {
> +		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> +		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> +	}
> +}
> +
>  void
>  xfs_inode_to_disk(
>  	struct xfs_inode	*ip,
> @@ -293,7 +312,6 @@ xfs_inode_to_disk(
>  	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
>  	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>  
> -	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
>  	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
>  	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
> @@ -304,8 +322,6 @@ xfs_inode_to_disk(
>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
>  	to->di_extsize = cpu_to_be32(ip->i_extsize);
> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
> @@ -320,11 +336,14 @@ xfs_inode_to_disk(
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
> diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
> index 7d5f0015..03036a2c 100644
> --- a/libxfs/xfs_inode_fork.h
> +++ b/libxfs/xfs_inode_fork.h
> @@ -156,14 +156,20 @@ static inline xfs_extnum_t
>  xfs_dfork_data_extents(
>  	struct xfs_dinode	*dip)
>  {
> -	return be32_to_cpu(dip->di_nextents);
> +	if (xfs_dinode_has_nrext64(dip))
> +		return be64_to_cpu(dip->di_big_dextcnt);
> +	else
> +		return be32_to_cpu(dip->di_nextents);
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
> diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
> index c13608aa..8f8c9869 100644
> --- a/libxfs/xfs_log_format.h
> +++ b/libxfs/xfs_log_format.h
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
> +			uint32_t  di_nextents;    /* !NREXT64 data extents */
> +			uint16_t  di_anextents;   /* !NREXT64 attr extents */
> +		} __packed;
> +	};
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 35e926a3..721c2eb5 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -440,6 +440,8 @@ static void
>  xlog_print_trans_inode_core(
>  	struct xfs_log_dinode	*ip)
>  {
> +    xfs_extnum_t		nextents;
> +
>      printf(_("INODE CORE\n"));
>      printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
>  	   ip->di_magic, ip->di_mode, (int)ip->di_version,
> @@ -450,11 +452,21 @@ xlog_print_trans_inode_core(
>  		xlog_extract_dinode_ts(ip->di_atime),
>  		xlog_extract_dinode_ts(ip->di_mtime),
>  		xlog_extract_dinode_ts(ip->di_ctime));
> -    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
> +
> +    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
> +	    nextents = ip->di_big_dextcnt;
> +    else
> +	    nextents = ip->di_nextents;
> +    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
>  	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
> -	   ip->di_extsize, ip->di_nextents);
> -    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
> -	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
> +	   ip->di_extsize, nextents);
> +
> +    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
> +	    nextents = ip->di_big_aextcnt;
> +    else
> +	    nextents = ip->di_anextents;
> +    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
> +	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
>  	   ip->di_dmstate);
>      printf(_("flags 0x%x gen 0x%x\n"),
>  	   ip->di_flags, ip->di_gen);
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index c9c453f6..5e387f38 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -240,7 +240,10 @@ STATIC void
>  xlog_recover_print_inode_core(
>  	struct xfs_log_dinode	*di)
>  {
> -	printf(_("	CORE inode:\n"));
> +	xfs_extnum_t		nextents;
> +	xfs_aextnum_t		anextents;
> +
> +        printf(_("	CORE inode:\n"));
>  	if (!print_inode)
>  		return;
>  	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
> @@ -254,10 +257,19 @@ xlog_recover_print_inode_core(
>  			xlog_extract_dinode_ts(di->di_mtime),
>  			xlog_extract_dinode_ts(di->di_ctime));
>  	printf(_("		flushiter:%d\n"), di->di_flushiter);
> +
> +	if (di->di_flags2 & XFS_DIFLAG2_NREXT64) {
> +		nextents = di->di_big_dextcnt;
> +		anextents = di->di_big_aextcnt;
> +	} else {
> +		nextents = di->di_nextents;
> +		anextents = di->di_anextents;
> +	}
> +
>  	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
> -	     "nextents:%d  anextents:%d\n"), (unsigned long long)
> +	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
>  	       di->di_size, (unsigned long long)di->di_nblocks,
> -	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
> +	       di->di_extsize, nextents, anextents);
>  	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
>  	     "gen:%u\n"),
>  	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 0df84e48..3be2e1d5 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -71,7 +71,12 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
>  	if (xfs_dfork_attr_extents(dino) != 0) {
>  		if (no_modify)
>  			return(1);
> -		dino->di_anextents = cpu_to_be16(0);
> +
> +		if (xfs_dinode_has_nrext64(dino))
> +			dino->di_big_aextcnt = 0;
> +		else
> +			dino->di_anextents = 0;
> +
>  	}
>  
>  	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
> @@ -1818,7 +1823,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			do_warn(
>  _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
>  				lino, dnextents, nextents);
> -			dino->di_nextents = cpu_to_be32(nextents);
> +			if (xfs_dinode_has_nrext64(dino))
> +				dino->di_big_dextcnt = cpu_to_be64(nextents);
> +			else
> +				dino->di_nextents = cpu_to_be32(nextents);
>  			*dirty = 1;
>  		} else  {
>  			do_warn(
> @@ -1841,7 +1849,11 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			do_warn(
>  _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
>  				lino, dnextents, anextents);
> -			dino->di_anextents = cpu_to_be16(anextents);
> +			if (xfs_dinode_has_nrext64(dino))
> +				dino->di_big_aextcnt = cpu_to_be32(anextents);
> +			else
> +				dino->di_anextents = cpu_to_be16(anextents);
> +
>  			*dirty = 1;
>  		} else  {
>  			do_warn(
> -- 
> 2.30.2
> 
