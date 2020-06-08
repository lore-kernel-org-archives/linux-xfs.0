Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F4FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC39920760
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zkBz6Jn7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgFHRu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:50:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbgFHRuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 13:50:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HkjPr196161;
        Mon, 8 Jun 2020 17:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JK8U1pM8+cLc0if0/3fU0VtQ2wyb/j7rfr2ohCZ1qOY=;
 b=zkBz6Jn7zuaqeYLCz0WkFTdpV8wpVsZAx6sf9Nv00SDJmMC5D9dBc/VG2e5OTxixAuDj
 4UIE43G4WS7fpDJkAgK2+uPo7VS8ZxSP9LTw4P1TjYj7PdvdABxGtXeCwIR8QO6QAJj3
 dfjFs3lOZXYtEothIyMEjqNL2txpFaq1zV+mUltFTpRGHHEui/v7eiFLgXTXwYDvfHSQ
 XSOapdQSMLETgtzjHoW78/qViO8W6jHaZxCfzAbrTZXHET/kNHciB7rNHhI5/WC7PD/Y
 mWV5isS4G9UtaU6jjPoz8U2DXWWxWi45EQ5rNJ3uTWHDi8ru9laIEdacG67wcWgE7smL 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31g33m06v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 17:50:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HllLW110701;
        Mon, 8 Jun 2020 17:50:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31gmqmhpak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 17:50:11 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058HoAtm001765;
        Mon, 8 Jun 2020 17:50:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 10:50:09 -0700
Date:   Mon, 8 Jun 2020 10:50:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 4/7] xfs: Add "Use Dir BMBT height" argument to
 XFS_BM_MAXLEVELS()
Message-ID: <20200608175008.GI1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-5-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:42PM +0530, Chandan Babu R wrote:
> XFS_BM_MAXLEVELS() returns the maximum possible height of BMBT tree for
> either data or attribute fork. For data forks, this commit adds a new
> argument to XFS_BM_MAXLEVELS() to let the users choose between the
> maximum heights of dir and non-dir BMBTs.
> 
> As of this commit, both dir and non-dir BMBTs have the same maximum
> height. A future commit in this series will use 2^27 extent count as the
> input to compute the maximum height of a directory BMBT which will in
> turn cause the maximum heights of dir and non-dir BMBTs to differ.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |  5 ++--
>  fs/xfs/libxfs/xfs_bmap.c        |  5 ++--
>  fs/xfs/libxfs/xfs_bmap_btree.h  |  4 +++-
>  fs/xfs/libxfs/xfs_trans_resv.c  | 25 +++++++++++---------
>  fs/xfs/libxfs/xfs_trans_resv.h  |  4 ++--
>  fs/xfs/libxfs/xfs_trans_space.h | 41 +++++++++++++++++----------------
>  fs/xfs/xfs_bmap_item.c          |  3 ++-
>  fs/xfs/xfs_reflink.c            |  4 ++--
>  8 files changed, 50 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a4b23edf887e..357e29a5a167 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -150,7 +150,7 @@ xfs_attr_calc_size(
>  	 * "local" or "remote" (note: local != inline).
>  	 */
>  	size = xfs_attr_leaf_newentsize(args, local);
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> +	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK, 0);

When would we have a DAENTER space reservation for the data fork on
something that isn't a directory?

Shouldn't you be able to compute the correct 'dbmbt' parameter value
from whichfork?

Can you modify these macros to take the xfs_inode so that we can gate
the logic on i_mode instead of passing magic values 0 and 1 around?
Though... thinking about this more, 1 means "use the slightly smaller
directory bmbt maxlevels", and 0 means "either this is a non directory
or we want worst case calculations", doesn't it...

Zooming out, why do we even care?  While it's true that we might gain
the ability to shave a few blocks off the block reservation when we know
we're dealing with a directory, this adds quite a bit of clutter to get
it.

>  	if (*local) {
>  		if (size > (args->geo->blksize / 2)) {
>  			/* Double split possible */
> @@ -163,7 +163,8 @@ xfs_attr_calc_size(
>  		 */
>  		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>  		nblks += dblocks;
> -		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> +		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks,
> +				XFS_ATTR_FORK, 0);
>  	}
>  
>  	return nblks;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 01e2b543b139..8b0029b3cecf 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -182,13 +182,14 @@ xfs_bmap_worst_indlen(
>  	mp = ip->i_mount;
>  	maxrecs = mp->m_bmap_dmxr[0];
>  	for (level = 0, rval = 0;
> -	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
> +	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0);
>  	     level++) {
>  		len += maxrecs - 1;
>  		do_div(len, maxrecs);
>  		rval += len;
>  		if (len == 1)
> -			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
> +			return rval +
> +				XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0) -
>  				level - 1;
>  		if (level == 0)
>  			maxrecs = mp->m_bmap_dmxr[1];
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 72bf74c79fb9..a047be5883d1 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -79,7 +79,9 @@ struct xfs_trans;
>  /*
>   * Maximum number of bmap btree levels.
>   */
> -#define XFS_BM_MAXLEVELS(mp,w)		((mp)->m_bm_maxlevels[(w)])
> +#define XFS_BM_MAXLEVELS(mp,w,use_dir_bmbt) \
> +	((!(use_dir_bmbt)) ? \
> +		(mp)->m_bm_maxlevels[(w)] : (mp)->m_bm_dir_maxlevel)

Also, if you /are/ going to mess with these macros, can you please turn
them into static inline functions?  Typechecking would be nice.

--D

>  /*
>   * Prototypes for xfs_bmap.c to call.
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index b44b521c605c..39cfca1b71b6 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -265,14 +265,14 @@ xfs_calc_write_reservation(
>  	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
>  
>  	t1 = xfs_calc_inode_res(mp, 1) +
> -	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
> +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0), blksz) +
>  	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
>  	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
>  
>  	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
>  		t2 = xfs_calc_inode_res(mp, 1) +
> -		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
> -				     blksz) +
> +		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0),
> +			blksz) +
>  		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
>  		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
>  		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
> @@ -313,7 +313,8 @@ xfs_calc_itruncate_reservation(
>  	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
>  
>  	t1 = xfs_calc_inode_res(mp, 1) +
> -	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0) + 1,
> +			     blksz);
>  
>  	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
>  	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> @@ -592,7 +593,7 @@ xfs_calc_growrtalloc_reservation(
>  	struct xfs_mount	*mp)
>  {
>  	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
> +		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0),
>  				 XFS_FSB_TO_B(mp, 1)) +
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> @@ -669,7 +670,7 @@ xfs_calc_addafork_reservation(
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
>  		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
> -		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
> +		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK, 0) + 1,
>  				 XFS_FSB_TO_B(mp, 1)) +
>  		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
>  				 XFS_FSB_TO_B(mp, 1));
> @@ -691,7 +692,7 @@ xfs_calc_attrinval_reservation(
>  	struct xfs_mount	*mp)
>  {
>  	return max((xfs_calc_inode_res(mp, 1) +
> -		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
> +		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK, 0),
>  				     XFS_FSB_TO_B(mp, 1))),
>  		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
>  		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> @@ -717,10 +718,11 @@ xfs_calc_attrset_reservation(
>  	int			bmbt_blks;
>  
>  	da_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> -	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
> +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK, 0);
>  
>  	max_rmt_blks = xfs_attr3_rmt_blocks(mp, XATTR_SIZE_MAX);
> -	bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, max_rmt_blks, XFS_ATTR_FORK);
> +	bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, max_rmt_blks,
> +			XFS_ATTR_FORK, 0);
>  
>  	return XFS_DQUOT_LOGRES(mp) +
>  		xfs_calc_inode_res(mp, 1) +
> @@ -752,8 +754,9 @@ xfs_calc_attrrm_reservation(
>  		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
>  				      XFS_FSB_TO_B(mp, 1)) +
>  		     (uint)XFS_FSB_TO_B(mp,
> -					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
> -		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
> +				XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK, 0)) +
> +		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK, 0),
> +				     0)),
>  		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
>  		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
>  				      XFS_FSB_TO_B(mp, 1))));
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index f50996ae18e6..d64989eeebd7 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -61,10 +61,10 @@ struct xfs_trans_resv {
>   */
>  #define	XFS_DIROP_LOG_RES(mp)	\
>  	(XFS_FSB_TO_B(mp, XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK)) + \
> -	 (XFS_FSB_TO_B(mp, XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)))
> +	 (XFS_FSB_TO_B(mp, XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK, 1) + 1)))
>  #define	XFS_DIROP_LOG_COUNT(mp)	\
>  	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
> -	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
> +	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK, 1) + 1)
>  
>  /*
>   * Various log count values.
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index b559af70cf51..c51d809a16b1 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -25,15 +25,16 @@
>  
>  #define XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)    \
>  		(((mp)->m_alloc_mxr[0]) - ((mp)->m_alloc_mnr[0]))
> -#define	XFS_EXTENTADD_SPACE_RES(mp,w)	(XFS_BM_MAXLEVELS(mp,w) - 1)
> -#define XFS_NEXTENTADD_SPACE_RES(mp,b,w)\
> +#define	XFS_EXTENTADD_SPACE_RES(mp,w,dbmbt)	\
> +	(XFS_BM_MAXLEVELS(mp,w,dbmbt) - 1)
> +#define XFS_NEXTENTADD_SPACE_RES(mp,b,w,dbmbt)		   \
>  	(((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
>  	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
> -	  XFS_EXTENTADD_SPACE_RES(mp,w))
> +		XFS_EXTENTADD_SPACE_RES(mp,w,dbmbt))
>  
>  /* Blocks we might need to add "b" mappings & rmappings to a file. */
> -#define XFS_SWAP_RMAP_SPACE_RES(mp,b,w)\
> -	(XFS_NEXTENTADD_SPACE_RES((mp), (b), (w)) + \
> +#define XFS_SWAP_RMAP_SPACE_RES(mp,b,w)	    \
> +	(XFS_NEXTENTADD_SPACE_RES((mp), (b), (w), 0) +	\
>  	 XFS_NRMAPADD_SPACE_RES((mp), (b)))
>  
>  #define	XFS_DAENTER_1B(mp,w)	\
> @@ -47,19 +48,19 @@
>  	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 1))
>  #define	XFS_DAENTER_BLOCKS(mp,w)	\
>  	(XFS_DAENTER_1B(mp,w) * XFS_DAENTER_DBS(mp,w))
> -#define	XFS_DAENTER_BMAP1B(mp,w)	\
> -	XFS_NEXTENTADD_SPACE_RES(mp, XFS_DAENTER_1B(mp, w), w)
> -#define	XFS_DAENTER_BMAPS(mp,w)		\
> -	(XFS_DAENTER_DBS(mp,w) * XFS_DAENTER_BMAP1B(mp,w))
> -#define	XFS_DAENTER_SPACE_RES(mp,w)	\
> -	(XFS_DAENTER_BLOCKS(mp,w) + XFS_DAENTER_BMAPS(mp,w))
> -#define	XFS_DAREMOVE_SPACE_RES(mp,w)	XFS_DAENTER_BMAPS(mp,w)
> +#define	XFS_DAENTER_BMAP1B(mp,w,dbmbt)	\
> +	XFS_NEXTENTADD_SPACE_RES(mp, XFS_DAENTER_1B(mp, w), w, dbmbt)
> +#define	XFS_DAENTER_BMAPS(mp,w,dbmbt)	\
> +	(XFS_DAENTER_DBS(mp,w) * XFS_DAENTER_BMAP1B(mp,w,dbmbt))
> +#define	XFS_DAENTER_SPACE_RES(mp,w,dbmbt)	\
> +	(XFS_DAENTER_BLOCKS(mp,w) + XFS_DAENTER_BMAPS(mp,w,dbmbt))
> +#define	XFS_DAREMOVE_SPACE_RES(mp,w,dbmbt)	XFS_DAENTER_BMAPS(mp,w,dbmbt)
>  #define	XFS_DIRENTER_MAX_SPLIT(mp,nl)	1
>  #define	XFS_DIRENTER_SPACE_RES(mp,nl)	\
> -	(XFS_DAENTER_SPACE_RES(mp, XFS_DATA_FORK) * \
> +	(XFS_DAENTER_SPACE_RES(mp, XFS_DATA_FORK, 1) *	\
>  	 XFS_DIRENTER_MAX_SPLIT(mp,nl))
>  #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
> -	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
> +	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK, 1)
>  #define	XFS_IALLOC_SPACE_RES(mp)	\
>  	(M_IGEO(mp)->ialloc_blks + \
>  	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
> @@ -69,26 +70,26 @@
>   * Space reservation values for various transactions.
>   */
>  #define	XFS_ADDAFORK_SPACE_RES(mp)	\
> -	((mp)->m_dir_geo->fsbcount + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK))
> +	((mp)->m_dir_geo->fsbcount + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK, 0))
>  #define	XFS_ATTRRM_SPACE_RES(mp)	\
> -	XFS_DAREMOVE_SPACE_RES(mp, XFS_ATTR_FORK)
> +	XFS_DAREMOVE_SPACE_RES(mp, XFS_ATTR_FORK, 0)
>  /* This macro is not used - see inline code in xfs_attr_set */
>  #define	XFS_ATTRSET_SPACE_RES(mp, v)	\
> -	(XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) + XFS_B_TO_FSB(mp, v))
> +	(XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK, 0) + XFS_B_TO_FSB(mp, v))
>  #define	XFS_CREATE_SPACE_RES(mp,nl)	\
>  	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
>  #define	XFS_DIOSTRAT_SPACE_RES(mp, v)	\
> -	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
> +	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK, 0) + (v))
>  #define	XFS_GROWFS_SPACE_RES(mp)	\
>  	(2 * (mp)->m_ag_maxlevels)
>  #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
> -	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
> +	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK, 0))
>  #define	XFS_LINK_SPACE_RES(mp,nl)	\
>  	XFS_DIRENTER_SPACE_RES(mp,nl)
>  #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
>  	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
>  #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
> -	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
> +	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK, 0) + \
>  	 XFS_DQUOT_CLUSTER_SIZE_FSB)
>  #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
>  	XFS_IALLOC_SPACE_RES(mp)
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 6736c5ab188f..0a8a8377a150 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -482,7 +482,8 @@ xfs_bui_item_recover(
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> -			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> +			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK, 0), 0,
> +			0, &tp);
>  	if (error)
>  		return error;
>  	/*
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 107bf2a2f344..fd35a0bf2c47 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -614,7 +614,7 @@ xfs_reflink_end_cow_extent(
>  		return 0;
>  	}
>  
> -	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK, 0);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
>  			XFS_TRANS_RESERVE, &tp);
>  	if (error)
> @@ -1017,7 +1017,7 @@ xfs_reflink_remap_extent(
>  	}
>  
>  	/* Start a rolling transaction to switch the mappings */
> -	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> +	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK, 0);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
>  		goto out;
> -- 
> 2.20.1
> 
