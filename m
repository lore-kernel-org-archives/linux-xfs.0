Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39CAC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B014206C3
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lWyJH458"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbgFHROW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:14:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56668 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730588AbgFHROV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 13:14:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HBSa6143015;
        Mon, 8 Jun 2020 17:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1QZBDcH6bky7NQ7qZMdgFQ4tEMD2oYdZF5NPVmqRG3A=;
 b=lWyJH458Bjw13JrWxC1+hjdSlfcid7aynk+Vzkbx0rhKAZi1t14dFvN0qGOAEM/FeJKu
 kNLrNqlWGAU9fRbeRtdQ32IYCEfMDIlldldFE7G9hAqAqB+hq1IC9bD9gIpnJ0dSGRJt
 o3O3OvYj3m6HDN1MADvbra8JE0K+bRoaCLintveupTY63BSqubH/PexPH3JKpb/vJm9q
 hutZPa+Hg2ko8OnqrydhuwVVrARs375IGrqjfm0cB6GrxJlZLvcO0qqdeYAX8h1IYhGG
 ypsYEQf2iHZqEGR+xRD1uEFUA525Wi4i+KpM9GKvRX99IbROVngsA/D8Af84LU31E8TI 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31g33m01pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 17:14:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058H3enK102561;
        Mon, 8 Jun 2020 17:14:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31gn2vge3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 17:14:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058HECba017068;
        Mon, 8 Jun 2020 17:14:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 10:14:11 -0700
Date:   Mon, 8 Jun 2020 10:14:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 6/7] xfs: Extend data extent counter to 47 bits
Message-ID: <20200608171410.GF1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-7-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:44PM +0530, Chandan Babu R wrote:
> This commit extends the per-inode data extent counter to 47 bits. The
> length of 47-bits was chosen because,
> Maximum file size = 2^63.
> Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.
> 
> The following changes are made to accomplish this,
> 1. A new ro-compat superblock flag to prevent older kernels from
>    mounting the filesystem in read-write mode. This flag is set for the
>    first time when an inode would end up having more than 2^31 extents.
> 3. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
>    holds the most significant 15 bits of the data extent counter.

On a 1k block V5 fs, the maximum extent count is 2^(63-10) = 2^53.

If you're going to allocate 32 bits of space from di_pad2 to expand the
data fork's nextents, let's use the entire bitspace.

> 2. A new inode->di_flags2 flag to indicate that the newly added field
>    contains valid data. This flag is set when one of the following two
>    conditions are met,
>    - When the inode is about to have more than 2^31 extents.
>    - When flushing the incore inode (See xfs_iflush_int()), if
>      the superblock ro-compat flag is already set.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c        | 40 ++++++++--------
>  fs/xfs/libxfs/xfs_format.h      | 30 ++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.c   | 46 +++++++++++++++---
>  fs/xfs/libxfs/xfs_inode_buf.h   |  2 +
>  fs/xfs/libxfs/xfs_inode_fork.c  | 84 ++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_inode_fork.h  |  3 +-
>  fs/xfs/libxfs/xfs_log_format.h  |  5 +-
>  fs/xfs/libxfs/xfs_types.h       |  5 +-
>  fs/xfs/scrub/inode.c            |  9 ++--
>  fs/xfs/xfs_inode.c              |  6 ++-
>  fs/xfs/xfs_inode_item.c         |  5 +-
>  fs/xfs/xfs_inode_item_recover.c | 16 +++++--
>  12 files changed, 184 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f75b70ae7b1f..73e552678adc 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -53,9 +53,9 @@ xfs_bmap_compute_maxlevels(
>  	int		whichfork,	/* data or attr fork */
>  	int		dir_bmbt)	/* Dir or non-dir data fork */
>  {
> +	uint64_t	maxleafents;	/* max leaf entries possible */
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	uint		maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> @@ -477,7 +477,7 @@ xfs_bmap_check_leaf_extents(
>  	if (bp_release)
>  		xfs_trans_brelse(NULL, bp);
>  error_norelse:
> -	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
> +	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
>  		__func__, i);
>  	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> @@ -918,7 +918,7 @@ xfs_bmap_local_to_extents(
>  	xfs_iext_first(ifp, &icur);
>  	xfs_iext_insert(ip, &icur, &rec, 0);
>  
> -	error = xfs_next_set(ip, whichfork, 1);
> +	error = xfs_next_set(tp, ip, whichfork, 1);
>  	if (error)
>  		goto done;
>  
> @@ -1610,7 +1610,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_prev(ifp, &bma->icur);
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
>  
> -		error = xfs_next_set(bma->ip, whichfork, -1);
> +		error = xfs_next_set(bma->tp, bma->ip, whichfork, -1);
>  		if (error)
>  			goto done;
>  
> @@ -1717,7 +1717,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_state = new->br_state;
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  
> -		error = xfs_next_set(bma->ip, whichfork, 1);
> +		error = xfs_next_set(bma->tp, bma->ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -1786,7 +1786,7 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
>  
> -		error = xfs_next_set(bma->ip, whichfork, 1);
> +		error = xfs_next_set(bma->tp, bma->ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -1876,7 +1876,7 @@ xfs_bmap_add_extent_delay_real(
>  		 */
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
>  
> -		error = xfs_next_set(bma->ip, whichfork, 1);
> +		error = xfs_next_set(bma->tp, bma->ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -1965,7 +1965,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
>  		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
>  
> -		error = xfs_next_set(bma->ip, whichfork, 1);
> +		error = xfs_next_set(bma->tp, bma->ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -2172,7 +2172,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &LEFT);
>  
> -		error = xfs_next_set(ip, whichfork, -2);
> +		error = xfs_next_set(tp, ip, whichfork, -2);
>  		if (error)
>  			goto done;
>  
> @@ -2228,7 +2228,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &LEFT);
>  
> -		error = xfs_next_set(ip, whichfork, -1);
> +		error = xfs_next_set(tp, ip, whichfork, -1);
>  		if (error)
>  			goto done;
>  
> @@ -2274,7 +2274,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &PREV);
>  
> -		error = xfs_next_set(ip, whichfork, -1);
> +		error = xfs_next_set(tp, ip, whichfork, -1);
>  		if (error)
>  			goto done;
>  
> @@ -2385,7 +2385,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_update_extent(ip, state, icur, &PREV);
>  		xfs_iext_insert(ip, icur, new, state);
>  
> -		error = xfs_next_set(ip, whichfork, 1);
> +		error = xfs_next_set(tp, ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -2464,7 +2464,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_next(ifp, icur);
>  		xfs_iext_insert(ip, icur, new, state);
>  
> -		error = xfs_next_set(ip, whichfork, 1);
> +		error = xfs_next_set(tp, ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -2519,7 +2519,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_insert(ip, icur, &r[1], state);
>  		xfs_iext_insert(ip, icur, &r[0], state);
>  
> -		error = xfs_next_set(ip, whichfork, 2);
> +		error = xfs_next_set(tp, ip, whichfork, 2);
>  		if (error)
>  			goto done;
>  
> @@ -2838,7 +2838,7 @@ xfs_bmap_add_extent_hole_real(
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &left);
>  
> -		error = xfs_next_set(ip, whichfork, -1);
> +		error = xfs_next_set(tp, ip, whichfork, -1);
>  		if (error)
>  			goto done;
>  
> @@ -2940,7 +2940,7 @@ xfs_bmap_add_extent_hole_real(
>  		 */
>  		xfs_iext_insert(ip, icur, new, state);
>  
> -		error = xfs_next_set(ip, whichfork, 1);
> +		error = xfs_next_set(tp, ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -5140,7 +5140,7 @@ xfs_bmap_del_extent_real(
>  		xfs_iext_remove(ip, icur, state);
>  		xfs_iext_prev(ifp, icur);
>  
> -		error = xfs_next_set(ip, whichfork, -1);
> +		error = xfs_next_set(tp, ip, whichfork, -1);
>  		if (error)
>  			goto done;
>  
> @@ -5252,7 +5252,7 @@ xfs_bmap_del_extent_real(
>  		} else
>  			flags |= xfs_ilog_fext(whichfork);
>  
> -		error = xfs_next_set(ip, whichfork, 1);
> +		error = xfs_next_set(tp, ip, whichfork, 1);
>  		if (error)
>  			goto done;
>  
> @@ -5722,7 +5722,7 @@ xfs_bmse_merge(
>  	 * Update the on-disk extent count, the btree if necessary and log the
>  	 * inode.
>  	 */
> -	error = xfs_next_set(ip, whichfork, -1);
> +	error = xfs_next_set(tp, ip, whichfork, -1);
>  	if (error)
>  		goto done;
>  
> @@ -6113,7 +6113,7 @@ xfs_bmap_split_extent(
>  	xfs_iext_next(ifp, &icur);
>  	xfs_iext_insert(ip, &icur, &new, 0);
>  
> -	error = xfs_next_set(ip, whichfork, 1);
> +	error = xfs_next_set(tp, ip, whichfork, 1);
>  	if (error)
>  		goto del_cursor;
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b42a52bfa1e9..91bee33aa988 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -449,10 +449,12 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> +#define XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR (1 << 3)	/* 47bit data extents */

I wonder if we could come up with a better name for this...

DFORK_EXTENTHI

Hmm...

BIG_DFORK

Hmmm...

ULTRAFRAG

There we go.  "XFS with UltraFrag, part of this complete g@m3r t00lk1t." ;)

...

(What do you think of the second suggestion?)

>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> +		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> @@ -563,6 +565,18 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>  }
>  
> +static inline bool xfs_sb_version_has47bitext(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_ro_compat &
> +			XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR);
> +}
> +
> +static inline void xfs_sb_version_add47bitext(struct xfs_sb *sbp)
> +{
> +	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR;
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> @@ -873,7 +887,7 @@ typedef struct xfs_dinode {
>  	__be64		di_size;	/* number of bytes in file */
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> -	__be32		di_nextents;	/* number of extents in data fork */
> +	__be32		di_nextents_lo;	/* number of extents in data fork */
>  	__be16		di_anextents;	/* number of extents in attribute fork*/
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
> @@ -891,7 +905,8 @@ typedef struct xfs_dinode {
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__be32		di_nextents_hi;
> +	__u8		di_pad2[8];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_timestamp_t	di_crtime;	/* time created */
> @@ -992,10 +1007,6 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))
>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> @@ -1061,12 +1072,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
>  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
> +#define XFS_DIFLAG2_47BIT_NEXTENTS_BIT 3 /* Uses di_nextents_hi field */
>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
>  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
> +#define XFS_DIFLAG2_47BIT_NEXTENTS (1 << XFS_DIFLAG2_47BIT_NEXTENTS_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
> -	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)
> +	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> +	 XFS_DIFLAG2_47BIT_NEXTENTS)
>  
>  /*
>   * Inode number format:
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 6f84ea85fdd8..8b89fe080f70 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -307,7 +307,8 @@ xfs_inode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> +	to->di_nextents_lo = cpu_to_be32(xfs_ifork_nextents(&ip->i_df) &
> +					0xffffffffU);
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> @@ -322,6 +323,10 @@ xfs_inode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> +			to->di_nextents_hi
> +				= cpu_to_be32(xfs_ifork_nextents(&ip->i_df)
> +					>> 32);

/me kinda hates the indentation here, would a convenience variable
reduce the amount of linewrapping here?

Oh, right, we're in a new epoch now; just go past 80 columns.

>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> @@ -360,7 +365,7 @@ xfs_log_dinode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(from->di_nextents);
> +	to->di_nextents_lo = cpu_to_be32(from->di_nextents_lo);
>  	to->di_anextents = cpu_to_be16(from->di_anextents);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
> @@ -375,6 +380,9 @@ xfs_log_dinode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> +			to->di_nextents_hi =
> +				cpu_to_be32(from->di_nextents_hi);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> @@ -391,7 +399,9 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents;
> +
> +	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -462,6 +472,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t		nextents;
> +	int64_t			nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -492,10 +504,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> +	nextents += xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
>  	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	if (mode && nextents > nblocks)
>  		return __this_address;
>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -716,3 +730,23 @@ xfs_inode_validate_cowextsize(
>  
>  	return NULL;
>  }
> +
> +xfs_extnum_t
> +xfs_dfork_nextents(
> +	struct xfs_sb		*sbp,
> +	struct xfs_dinode	*dip,
> +	int			whichfork)
> +{
> +	xfs_extnum_t		nextents;
> +
> +	if (whichfork == XFS_DATA_FORK) {
> +		nextents = be32_to_cpu(dip->di_nextents_lo);
> +		if (xfs_sb_version_has_v3inode(sbp)
> +			&& (dip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS))

Please don't align the second line of the if test with the if body.

Or maybe just create a "xfs_inode_has_big_dfork" helper to encapsulate
this, like we do for reflink/hascow/realtime inodes.

> +			nextents |= (u64)(be32_to_cpu(dip->di_nextents_hi))
> +				<< 32;
> +		return nextents;
> +	} else {
> +		return be16_to_cpu(dip->di_anextents);

I suspect you could reduce the indenting here by inverting the logic,
e.g.

	if (attr fork)
		return be16_to_cpu(anextents);

	nextents = be32_to_cpu(nextents_lo);
	if (xfs_inode_has_big_dfork())
		nextents += be32_to_cpu(nextents_hi);
	return nextents;

> +	}
> +}
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 865ac493c72a..4583db53b933 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -65,5 +65,7 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
>  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
> +xfs_extnum_t xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip,
> +		int whichfork);
>  
>  #endif	/* __XFS_INODE_BUF_H__ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 3bf5a2c391bd..ec682e2d5bcb 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -10,6 +10,7 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> +#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> @@ -103,21 +104,22 @@ xfs_iformat_extents(
>  	int			whichfork)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_sb		*sb = &mp->m_sb;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	xfs_extnum_t		nex = xfs_dfork_nextents(sb, dip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
>  	struct xfs_bmbt_irec	new;
> -	int			i;
> +	xfs_extnum_t		i;
>  
>  	/*
>  	 * If the number of extents is unreasonable, then something is wrong and
>  	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>  	 */
>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
> -		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
> +		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %llu).",
>  			(unsigned long long) ip->i_ino, nex);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
>  				"xfs_iformat_extents(1)", dip, sizeof(*dip),
> @@ -233,7 +235,11 @@ xfs_iformat_data_fork(
>  	 * depend on it.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents_lo);
> +	if (ip->i_d.di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> +		ip->i_df.if_nextents |=
> +			((u64)(be32_to_cpu(dip->di_nextents_hi)) << 32);
> +
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -729,31 +735,73 @@ xfs_ifork_verify_local_attr(
>  	return 0;
>  }
>  
> +static int
> +xfs_next_set_data(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_ifork	*ifp,
> +	int			delta)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_extnum_t		nr_exts;
> +
> +	nr_exts = ifp->if_nextents + delta;
> +
> +	if ((delta > 0 && nr_exts > MAXEXTNUM)
> +		|| (delta < 0 && nr_exts > ifp->if_nextents))
> +		return -EOVERFLOW;
> +
> +	if (ifp->if_nextents <= MAXEXTNUM31BIT &&
> +		nr_exts > MAXEXTNUM31BIT &&
> +		!(ip->i_d.di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS) &&
> +		xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		if (!xfs_sb_version_has47bitext(&mp->m_sb)) {

Urk.  Again, don't indent the if test logic and the if body statements
to the same level.

> +			bool log_sb = false;
> +
> +			spin_lock(&mp->m_sb_lock);
> +			if (!xfs_sb_version_has47bitext(&mp->m_sb)) {
> +				xfs_sb_version_add47bitext(&mp->m_sb);
> +				log_sb = true;
> +			}
> +			spin_unlock(&mp->m_sb_lock);
> +
> +			if (log_sb)
> +				xfs_log_sb(tp);
> +		}

Hm, dynamic filesystem upgrade.  This probably ought to log something to
dmesg about the upgrade.  It might also be a better to make this a
separate helper so that it's not triply-indented.

> +
> +		ip->i_d.di_flags2 |= XFS_DIFLAG2_47BIT_NEXTENTS;
> +	}
> +
> +	ifp->if_nextents = nr_exts;
> +
> +	return 0;
> +}
> +
>  int
>  xfs_next_set(
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	int			delta)
>  {
>  	struct xfs_ifork	*ifp;
>  	int64_t			nr_exts;
> -	int64_t			max_exts;
> +	int			error = 0;
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> -		max_exts = MAXEXTNUM;
> -	else if (whichfork == XFS_ATTR_FORK)
> -		max_exts = MAXAEXTNUM;
> -	else
> -		ASSERT(0);
> -
> -	nr_exts = ifp->if_nextents + delta;
> -	if ((delta > 0 && nr_exts > max_exts)
> -		|| (delta < 0 && nr_exts < 0))
> -		return -EOVERFLOW;
> +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
> +		error = xfs_next_set_data(tp, ip, ifp, delta);
> +	} else if (whichfork == XFS_ATTR_FORK) {
> +		nr_exts = ifp->if_nextents + delta;
> +		if ((delta > 0 && nr_exts > MAXAEXTNUM)
> +			|| (delta < 0 && nr_exts < 0))
> +			return -EOVERFLOW;
>  
> -	ifp->if_nextents = nr_exts;
> +		ifp->if_nextents = nr_exts;
> +	} else {
> +		ASSERT(0);
> +	}
>  
> -	return 0;
> +	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index a84ae42ace79..c74fa6371cc8 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -173,5 +173,6 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
>  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
>  
> -int xfs_next_set(struct xfs_inode *ip, int whichfork, int delta);
> +int xfs_next_set(struct xfs_trans *tp, struct xfs_inode *ip, int whichfork,
> +		int delta);
>  #endif	/* __XFS_INODE_FORK_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index e3400c9c71cd..879aadff7692 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -396,7 +396,7 @@ struct xfs_log_dinode {
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> -	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> +	uint32_t	di_nextents_lo;	/* number of extents in data fork */
>  	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
> @@ -414,7 +414,8 @@ struct xfs_log_dinode {
>  	xfs_lsn_t	di_lsn;		/* flush sequence */
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> -	uint8_t		di_pad2[12];	/* more padding for future expansion */
> +	uint32_t	di_nextents_hi;
> +	uint8_t		di_pad2[8];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_ictimestamp_t di_crtime;	/* time created */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 0a3041ad5bec..c68ff2178976 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -12,7 +12,7 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
>  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
>  typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
> @@ -59,7 +59,8 @@ typedef void *		xfs_failaddr_t;
>   * Max values for extlen, extnum, aextnum.
>   */
>  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> +#define	MAXEXTNUM31BIT	((xfs_extnum_t)0x7fffffff)	/* 31 bits */
> +#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffffffff)	/* 47 bits */
>  #define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
>  #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
>  
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 6d483ab29e63..be41fd242ff2 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -205,8 +205,8 @@ xchk_dinode(
>  	struct xfs_mount	*mp = sc->mp;
>  	size_t			fork_recs;
>  	unsigned long long	isize;
> +	xfs_extnum_t		nextents;
>  	uint64_t		flags2;
> -	uint32_t		nextents;
>  	uint16_t		flags;
>  	uint16_t		mode;
>  
> @@ -354,7 +354,7 @@ xchk_dinode(
>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>  
>  	/* di_nextents */
> -	nextents = be32_to_cpu(dip->di_nextents);
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
>  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -464,6 +464,7 @@ xchk_inode_xref_bmap(
>  	struct xfs_scrub	*sc,
>  	struct xfs_dinode	*dip)
>  {
> +	xfs_mount_t		*mp = sc->mp;

struct xfs_mount.  The structure typedefs usages are deprecated and
we're trying to get rid of them (slowly).

--D

>  	xfs_extnum_t		nextents;
>  	xfs_filblks_t		count;
>  	xfs_filblks_t		acount;
> @@ -477,14 +478,14 @@ xchk_inode_xref_bmap(
>  			&nextents, &count);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents < be32_to_cpu(dip->di_nextents))
> +	if (nextents < xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
>  			&nextents, &acount);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 64f5f9a440ae..4418a66cf6d6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3748,7 +3748,7 @@ xfs_iflush_int(
>  				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %Lu, "
> -			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
> +			"total extents = %llu, nblocks = %Ld, ptr "PTR_FMT,
>  			__func__, ip->i_ino,
>  			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
>  			ip->i_d.di_nblocks, ip);
> @@ -3785,6 +3785,10 @@ xfs_iflush_int(
>  	    xfs_ifork_verify_local_attr(ip))
>  		goto flush_out;
>  
> +	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> +		&& xfs_sb_version_has47bitext(&mp->m_sb))
> +		ip->i_d.di_flags2 |= XFS_DIFLAG2_47BIT_NEXTENTS;
> +
>  	/*
>  	 * Copy the dirty parts of the inode into the on-disk inode.  We always
>  	 * copy out the core of the inode, because if the inode is dirty at all
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ba47bf65b772..6f27ac7c8631 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -326,7 +326,7 @@ xfs_inode_to_log_dinode(
>  	to->di_size = from->di_size;
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
> -	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> +	to->di_nextents_lo = xfs_ifork_nextents(&ip->i_df) & 0xffffffffU;
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> @@ -344,6 +344,9 @@ xfs_inode_to_log_dinode(
>  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
>  		to->di_flags2 = from->di_flags2;
>  		to->di_cowextsize = from->di_cowextsize;
> +		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> +			to->di_nextents_hi =
> +				xfs_ifork_nextents(&ip->i_df) >> 32;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 10ef5ddf5429..8d64b861fb66 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -134,6 +134,7 @@ xlog_recover_inode_commit_pass2(
>  	struct xfs_log_dinode		*ldip;
>  	uint				isize;
>  	int				need_free = 0;
> +	xfs_extnum_t			nextents;
>  
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
> @@ -255,16 +256,23 @@ xlog_recover_inode_commit_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> +
> +	nextents = ldip->di_nextents_lo;
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +		ldip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> +		nextents |= ((u64)(ldip->di_nextents_hi) << 32);
> +
> +	nextents += ldip->di_anextents;
> +
> +	if (unlikely(nextents > ldip->di_nblocks)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>  			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents + ldip->di_anextents,
> -			ldip->di_nblocks);
> +			nextents, ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> -- 
> 2.20.1
> 
