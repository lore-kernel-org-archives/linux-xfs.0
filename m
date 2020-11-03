Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50079C2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 19:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 031A4206DC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 19:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wp8gF5lB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgKCT5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 14:57:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgKCT5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 14:57:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3Jt5vE027294;
        Tue, 3 Nov 2020 19:56:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QF1cw4VIgzdzOiUC7yC/yVe/OU9wCniZbc/U3nTLLsQ=;
 b=wp8gF5lBu28c5k7jadh8xVvQfOiGXGivVkQnkh3bS71SvdCfht7O7od0Q8VsGRtGVZy5
 WQfMBVML7Gw0qmkTWwots8B9rCJQC75Qj5i4ZkbPOBUskkv7WwZp3Wx9ChI/ReUBJuLy
 izgBukFW56eClBMZwo8YU2MIljSJNZCSBgdWoXM1yQiu8b8tb8EicN0mNd1iFfiSyIeO
 pbbibwnvSPNNjFTbahQBD2bZcPAqVqFbu3qelgSt9BjFwzbglQ0x6av95Sg/yprGr7u8
 Alrak7j+90S0EWMa5o7EUU5jgfk2UMPJa9kLxdbs0oFrFMchYzIdtfL6W0uEYnFTRETL mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2k8k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 19:56:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3Jsn49067790;
        Tue, 3 Nov 2020 19:56:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf48yyvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 19:56:52 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3Juqwv002076;
        Tue, 3 Nov 2020 19:56:52 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 11:56:52 -0800
Date:   Tue, 3 Nov 2020 11:56:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V10 14/14] xfs: Introduce error injection to allocate
 only minlen size extents for files
Message-ID: <20201103195651.GB7115@magnolia>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
 <20201103150642.2032284-15-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103150642.2032284-15-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=7 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=7 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 08:36:42PM +0530, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> helps userspace test programs to get xfs_bmap_btalloc() to always
> allocate minlen sized extents.
> 
> This is required for test programs which need a guarantee that minlen
> extents allocated for a file do not get merged with their existing
> neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> Directories, Xattrs and extension of realtime inodes need this since the
> file offset at which the extents are being allocated cannot be
> explicitly controlled from userspace.
> 
> One way to use this error tag is to,
> 1. Consume all of the free space by sequentially writing to a file.
> 2. Punch alternate blocks of the file. This causes CNTBT to contain
>    sufficient number of one block sized extent records.
> 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> After step 3, xfs_bmap_btalloc() will issue space allocation
> requests for minlen sized extents only.
> 
> ENOSPC error code is returned to userspace when there aren't any "one
> block sized" extents left in any of the AGs.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h    |   3 +
>  fs/xfs/libxfs/xfs_bmap.c     | 124 ++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_errortag.h |   4 +-
>  fs/xfs/xfs_error.c           |   3 +
>  5 files changed, 159 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..a7c4eb1d71d5 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2473,6 +2473,47 @@ xfs_defer_agfl_block(
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>  }
>  
> +#ifdef DEBUG
> +/*
> + * Check if an AGF has a free extent record whose length is equal to
> + * args->minlen.
> + */
> +STATIC int
> +xfs_exact_minlen_extent_available(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_buf		*agbp,
> +	int			*stat)
> +{
> +	struct xfs_btree_cur	*cnt_cur;
> +	xfs_agblock_t		fbno;
> +	xfs_extlen_t		flen;
> +	int			error = 0;
> +
> +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> +			args->agno, XFS_BTNUM_CNT);
> +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> +	if (error)
> +		goto out;
> +
> +	if (*stat == 0) {
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> +	if (error)
> +		goto out;
> +
> +	if (*stat == 1 && flen != args->minlen)
> +		*stat = 0;
> +
> +out:
> +	xfs_btree_del_cursor(cnt_cur, error);
> +
> +	return error;
> +}
> +#endif
> +
>  /*
>   * Decide whether to use this allocation group for this allocation.
>   * If so, fix up the btree freelist's size.
> @@ -2544,6 +2585,15 @@ xfs_alloc_fix_freelist(
>  	if (!xfs_alloc_space_available(args, need, flags))
>  		goto out_agbp_relse;
>  
> +#ifdef DEBUG
> +	if (args->alloc_minlen_only) {
> +		int stat;
> +
> +		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
> +		if (error || !stat)
> +			goto out_agbp_relse;
> +	}
> +#endif
>  	/*
>  	 * Make the freelist shorter if it's too long.
>  	 *
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..a4427c5775c2 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
>  	char		wasfromfl;	/* set if allocation is from freelist */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> +#ifdef DEBUG
> +	bool		alloc_minlen_only; /* allocate exact minlen extent */
> +#endif
>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f6cd33684571..4717c5f1808e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3552,35 +3552,102 @@ xfs_bmap_process_allocated_extent(
>  	xfs_bmap_btalloc_accounting(ap, args);
>  }
>  
> +#ifdef DEBUG
> +static int
> +xfs_bmap_exact_minlen_extent_alloc(
> +	struct xfs_bmalloca	*ap)
> +{
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> +	xfs_fileoff_t		orig_offset;
> +	xfs_extlen_t		orig_length;
> +	int			error;
> +
> +	ASSERT(ap->length);
> +
> +	if (ap->minlen != 1) {
> +		ap->blkno = NULLFSBLOCK;
> +		ap->length = 0;
> +		return 0;
> +	}
> +
> +	orig_offset = ap->offset;
> +	orig_length = ap->length;
> +
> +	args.alloc_minlen_only = 1;
> +
> +	xfs_bmap_compute_alignments(ap, &args);
> +
> +	if (ap->tp->t_firstblock == NULLFSBLOCK) {
> +		/*
> +		 * Unlike the longest extent available in an AG, we don't track
> +		 * the length of an AG's shortest extent.
> +		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
> +		 * hence we can afford to start traversing from the 0th AG since
> +		 * we need not be concerned about a drop in performance in
> +		 * "debug only" code paths.
> +		 */
> +		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
> +	} else {
> +		ap->blkno = ap->tp->t_firstblock;
> +	}
> +
> +	args.fsbno = ap->blkno;
> +	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> +	args.type = XFS_ALLOCTYPE_FIRST_AG;
> +	args.total = args.minlen = args.maxlen = ap->minlen;
> +
> +	args.alignment = 1;
> +	args.minalignslop = 0;
> +
> +	args.minleft = ap->minleft;
> +	args.wasdel = ap->wasdel;
> +	args.resv = XFS_AG_RESV_NONE;
> +	args.datatype = ap->datatype;
> +
> +	error = xfs_alloc_vextent(&args);
> +	if (error)
> +		return error;
> +
> +	if (args.fsbno != NULLFSBLOCK) {
> +		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
> +			orig_length);
> +	} else {
> +		ap->blkno = NULLFSBLOCK;
> +		ap->length = 0;
> +	}
> +
> +	return 0;
> +}
> +#else
> +
> +#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
> +
> +#endif
> +
>  STATIC int
>  xfs_bmap_btalloc(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
>  {
> -	xfs_mount_t	*mp;		/* mount point structure */
> -	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> -	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
> -	xfs_agnumber_t	ag;
> -	xfs_alloc_arg_t	args;
> -	xfs_fileoff_t	orig_offset;
> -	xfs_extlen_t	orig_length;
> -	xfs_extlen_t	blen;
> -	xfs_extlen_t	nextminlen = 0;
> -	int		nullfb;		/* true if ap->firstblock isn't set */
> -	int		isaligned;
> -	int		tryagain;
> -	int		error;
> -	int		stripe_align;
> +	struct xfs_mount	*mp = ap->ip->i_mount;	/* mount point structure */
> +	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> +	xfs_alloctype_t		atype = 0;		/* type for allocation routines */

I'll remove these comments ("bmap alloc argument struct", "mount point
structure", "type for allocation routines") that don't add much.

> +	xfs_agnumber_t		fb_agno;		/* ag number of ap->firstblock */
> +	xfs_agnumber_t		ag;
> +	xfs_fileoff_t		orig_offset;
> +	xfs_extlen_t		orig_length;
> +	xfs_extlen_t		blen;
> +	xfs_extlen_t		nextminlen = 0;
> +	int			nullfb; /* true if ap->firstblock isn't set */
> +	int			isaligned;
> +	int			tryagain;
> +	int			error;
> +	int			stripe_align;
>  
>  	ASSERT(ap->length);
>  	orig_offset = ap->offset;
>  	orig_length = ap->length;
>  
> -	mp = ap->ip->i_mount;
> -
> -	memset(&args, 0, sizeof(args));
> -	args.tp = ap->tp;
> -	args.mp = mp;
> -
>  	stripe_align = xfs_bmap_compute_alignments(ap, &args);
>  
>  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> @@ -4113,7 +4180,11 @@ xfs_bmap_alloc_userdata(
>  			return xfs_bmap_rtalloc(bma);
>  	}
>  
> -	return xfs_bmap_btalloc(bma);
> +	if (unlikely(XFS_TEST_ERROR(false, mp,
> +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +		return xfs_bmap_exact_minlen_extent_alloc(bma);
> +	else
> +		return xfs_bmap_btalloc(bma);

Minor nit: no need for the "else return" here, you can just do:

	if (unlikely(...))
		return xfs_bmap_exact_minlen_extent_alloc(bma);
	return xfs_bmap_btalloc(bma);

I'll just fix those on their way into my testing tree, but please make
the changes to your dev branch if you end up sending a v11.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  }
>  
>  static int
> @@ -4149,10 +4220,15 @@ xfs_bmapi_allocate(
>  	else
>  		bma->minlen = 1;
>  
> -	if (bma->flags & XFS_BMAPI_METADATA)
> -		error = xfs_bmap_btalloc(bma);
> -	else
> +	if (bma->flags & XFS_BMAPI_METADATA) {
> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> +				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +			error = xfs_bmap_exact_minlen_extent_alloc(bma);
> +		else
> +			error = xfs_bmap_btalloc(bma);
> +	} else {
>  		error = xfs_bmap_alloc_userdata(bma);
> +	}
>  	if (error || bma->blkno == NULLFSBLOCK)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 1c56fcceeea6..6ca9084b6934 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -57,7 +57,8 @@
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>  #define XFS_ERRTAG_BUF_IOERROR				35
>  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> -#define XFS_ERRTAG_MAX					37
> +#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> +#define XFS_ERRTAG_MAX					38
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -99,5 +100,6 @@
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>  #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> +#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 3780b118cc47..185b4915b7bf 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_IUNLINK_FALLBACK,
>  	XFS_RANDOM_BUF_IOERROR,
>  	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> +	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>  	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> +	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>  	NULL,
>  };
>  
> -- 
> 2.28.0
> 
