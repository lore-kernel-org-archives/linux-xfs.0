Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C54C46466
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0646208E4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z3hAwFqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgJFEed (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:34:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgJFEed (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:34:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964OnJj140014;
        Tue, 6 Oct 2020 04:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G8pj/OCCF2CDgyKmY12ngr5dgRY1dp3SaRsFxL3FX+c=;
 b=Z3hAwFqz2nKJWMF6Rl7CwMAPdTLxQe7tZc5oLw96A8zNpIIvdwnI9TjRvvwUSazaJx4r
 MoX0+e1Sy0etBQ1zRzI23XrKqxpFyp20L1jUCSOmL3bpCPiGTuScTO1+UrinpNHw2UAQ
 BO9REdv2dCvkznE093BDozAalci5EqXNpnUJL/yAddMcY0suPFNblvN4SxEb2n3aqZ43
 ANwqupoEoOtfNEFJ7pCH9sTOiUHABGYBnTlNiMN7gsGDBEQp/ZG5m1aLKaw4jMcVo4Rk
 XdHApOK66kQ8eOoKVMKCEi/3SfoGtXwnxy4u0a1WhfPpall6dcinoFPye/HT7XvMa6Bo Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34evje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:34:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964Q6GT079811;
        Tue, 6 Oct 2020 04:34:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y37wawb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:34:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964YPVO011814;
        Tue, 6 Oct 2020 04:34:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:34:25 -0700
Date:   Mon, 5 Oct 2020 21:34:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 12/12] xfs: Introduce error injection to allocate only
 minlen size extents for files
Message-ID: <20201006043424.GS49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-13-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-13-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=7 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=7 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 03, 2020 at 11:26:33AM +0530, Chandan Babu R wrote:
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

Is step #2 required?  What happens if I only turn the knob?

> ENOSPC error code is returned to userspace when there aren't any "one
> block sized" extents left in any of the AGs.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 46 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h    |  1 +
>  fs/xfs/libxfs/xfs_bmap.c     | 26 ++++++++++++++------
>  fs/xfs/libxfs/xfs_errortag.h |  4 +++-
>  fs/xfs/xfs_error.c           |  3 +++
>  5 files changed, 72 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..d8d8ab1478db 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2473,6 +2473,45 @@ xfs_defer_agfl_block(
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>  }
>  
> +STATIC int
> +minlen_freespace_available(

This ought to have an 'xfs_' prefix.

Also, what does this function do?  Does it decide if there's even enough
space to go ahead with a minlen allocation?

> +	struct xfs_alloc_arg	*args,
> +	struct xfs_buf		*agbp,
> +	int			*stat)
> +{
> +	xfs_btree_cur_t		*cnt_cur;

struct xfs_btree_cur	*cnt_cur;

> +	xfs_agblock_t		fbno;
> +	xfs_extlen_t		flen;
> +	int			btree_error = XFS_BTREE_NOERROR;
> +	int			error = 0;
> +
> +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> +			args->agno, XFS_BTNUM_CNT);
> +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> +	if (error) {
> +		btree_error = XFS_BTREE_ERROR;
> +		goto out;
> +	}
> +
> +	ASSERT(*stat == 1);

Is it ok to keep going with stat==0?  Or should we just ... I don't
know?  Bail out with -EFSCORRUPTED?

> +
> +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> +	if (error) {
> +		btree_error = XFS_BTREE_ERROR;
> +		goto out;
> +	}
> +
> +	if (flen == args->minlen)
> +		*stat = 1;
> +	else
> +		*stat = 0;
> +
> +out:
> +	xfs_btree_del_cursor(cnt_cur, btree_error);

Note that due to a sloppy quirk of error handling, you can pass @error
to this function, no need for a separate btree_error.

> +
> +	return error;
> +}
> +
>  /*
>   * Decide whether to use this allocation group for this allocation.
>   * If so, fix up the btree freelist's size.
> @@ -2490,6 +2529,7 @@ xfs_alloc_fix_freelist(
>  	struct xfs_alloc_arg	targs;	/* local allocation arguments */
>  	xfs_agblock_t		bno;	/* freelist block */
>  	xfs_extlen_t		need;	/* total blocks needed in freelist */
> +	int			i;
>  	int			error = 0;
>  
>  	/* deferred ops (AGFL block frees) require permanent transactions */
> @@ -2544,6 +2584,12 @@ xfs_alloc_fix_freelist(
>  	if (!xfs_alloc_space_available(args, need, flags))
>  		goto out_agbp_relse;
>  
> +	if (args->alloc_minlen_only) {
> +		error = minlen_freespace_available(args, agbp, &i);
> +		if (error || !i)
> +			goto out_agbp_relse;
> +	}
> +
>  	/*
>  	 * Make the freelist shorter if it's too long.
>  	 *
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..1d04089b7fb4 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -75,6 +75,7 @@ typedef struct xfs_alloc_arg {
>  	char		wasfromfl;	/* set if allocation is from freelist */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> +	bool		alloc_minlen_only;
>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5156cbd476f2..fab4097e7492 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3510,12 +3510,19 @@ xfs_bmap_btalloc(
>  		ASSERT(ap->length);
>  	}
>  
> +	memset(&args, 0, sizeof(args));
> +
> +	args.alloc_minlen_only = XFS_TEST_ERROR(false, mp,
> +					XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);

Can we just set maxlen = minlen here?

Also, should this debug knob also be applied to rt file allocations?

>  
>  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
>  							ap->tp->t_firstblock);
>  	if (nullfb) {
> -		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> +		if (args.alloc_minlen_only) {
> +			ag = 0;

Hm, so setting this magic knob also makes everyone fight for space in AG 0?

> +			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
> +		} else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
>  		    xfs_inode_is_filestream(ap->ip)) {
>  			ag = xfs_filestream_lookup_ag(ap->ip);
>  			ag = (ag != NULLAGNUMBER) ? ag : 0;
> @@ -3523,10 +3530,12 @@ xfs_bmap_btalloc(
>  		} else {
>  			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
>  		}
> -	} else
> +	} else {
>  		ap->blkno = ap->tp->t_firstblock;
> +	}
>  
> -	xfs_bmap_adjacent(ap);
> +	if (!args.alloc_minlen_only)
> +		xfs_bmap_adjacent(ap);
>  
>  	/*
>  	 * If allowed, use ap->blkno; otherwise must use firstblock since
> @@ -3540,7 +3549,6 @@ xfs_bmap_btalloc(
>  	 * Normal allocation, done through xfs_alloc_vextent.
>  	 */
>  	tryagain = isaligned = 0;
> -	memset(&args, 0, sizeof(args));
>  	args.tp = ap->tp;
>  	args.mp = mp;
>  	args.fsbno = ap->blkno;
> @@ -3549,7 +3557,10 @@ xfs_bmap_btalloc(
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
>  	blen = 0;
> -	if (nullfb) {
> +	if (args.alloc_minlen_only) {
> +		args.type = XFS_ALLOCTYPE_START_AG;
> +		args.total = args.minlen = args.maxlen = ap->minlen;
> +	} else if (nullfb) {
>  		/*
>  		 * Search for an allocation group with a single extent large
>  		 * enough for the request.  If one isn't found, then adjust
> @@ -3595,7 +3606,8 @@ xfs_bmap_btalloc(
>  	 * is only set if the allocation length is >= the stripe unit and the
>  	 * allocation offset is at the end of file.
>  	 */
> -	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
> +	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof &&
> +		!args.alloc_minlen_only) {
>  		if (!ap->offset) {

Yikes, the conditional lines up with the body!

--D

>  			args.alignment = stripe_align;
>  			atype = args.type;
> @@ -3681,7 +3693,7 @@ xfs_bmap_btalloc(
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> -	if (args.fsbno == NULLFSBLOCK && nullfb) {
> +	if (args.fsbno == NULLFSBLOCK && nullfb && !args.alloc_minlen_only) {
>  		args.fsbno = 0;
>  		args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		args.total = ap->minlen;
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
> index 3780b118cc47..028560bb596a 100644
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
> +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent, XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
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
