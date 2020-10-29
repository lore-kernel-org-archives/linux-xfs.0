Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C827C55178
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D33872076B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTqtl3y8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgJ2WeD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 18:34:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42190 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgJ2WeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 18:34:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMTIZ9074755;
        Thu, 29 Oct 2020 22:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HV1VN8SZrJ5bsXheZdnRMH0C+yHr0ZndAETMMQZUths=;
 b=UTqtl3y8bEfxJVksJeLHgbWDmQS7/tjWcvoYgFibwKpxFyVYmrNEbsoHcuPFfaSopM6U
 b23j2/LGe+zOTGSraBAHkuRXB+KpB9L0I5k1NM2+J8t7CC99QKUfcqtAk1s1Q9Rha6Ww
 +pVCsaIMg6/pSSBTEO9it8tnqIaPMOvKmX5CkPUyadfrc95B3ypXTG7/yHC00F5lqQiB
 DTAfVmafrcVCJfF1IEgmaMuuueoSEo2YycllI94oVWWd3SANQeU7zGPyEQoRzk9oIlfI
 kHBSJqN0Plxv4d12A9r6tulsG9J/KSAAn+PXb9wB3u7AkyVFg45m+tprpHzfnQK8aF4P Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb7gka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 22:33:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMUBcD116425;
        Thu, 29 Oct 2020 22:33:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx611m9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 22:33:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TMXnTx017417;
        Thu, 29 Oct 2020 22:33:50 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 15:33:49 -0700
Date:   Thu, 29 Oct 2020 15:33:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V8 14/14] xfs: Introduce error injection to allocate only
 minlen size extents for files
Message-ID: <20201029223348.GO1061252@magnolia>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
 <20201029101348.4442-15-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029101348.4442-15-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=7 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=7
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290154
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 03:43:48PM +0530, Chandan Babu R wrote:
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

I don't see any new ENOSPC returns in this patch.  Does this comment
merely confirm that we'll return ENOSPC when we run out of space, like
all the other allocators?

Or is there another subtlety to this statement?  Such as ... we'll
return ENOSPC when there are no more single-block free space extents,
even if there are still larger chunks of free space?

Also, I thought this patch made it so that we always allocate minlen,
which doesn't necessarily mean single blocks?

> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h    |   3 ++
>  fs/xfs/libxfs/xfs_bmap.c     | 100 +++++++++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_errortag.h |   4 +-
>  fs/xfs/xfs_error.c           |   3 ++
>  5 files changed, 150 insertions(+), 10 deletions(-)
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
> index 88db23afc51c..74e148cc41b2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3474,11 +3474,13 @@ xfs_bmap_compute_alignments(
>  	int			error;
>  
>  	/* stripe alignment for allocation is determined by mount parameters */
> -	*stripe_align = 0;
> -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> -		*stripe_align = mp->m_swidth;
> -	else if (mp->m_dalign)
> -		*stripe_align = mp->m_dalign;
> +	if (stripe_align) {
> +		*stripe_align = 0;
> +		if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> +			*stripe_align = mp->m_swidth;
> +		else if (mp->m_dalign)
> +			*stripe_align = mp->m_dalign;
> +	}
>  
>  	if (ap->flags & XFS_BMAPI_COWFORK)
>  		align = xfs_get_cowextsz_hint(ap->ip);
> @@ -3551,6 +3553,71 @@ xfs_bmap_process_allocated_extent(
>  	xfs_bmap_btalloc_accounting(ap, args);
>  }
>  
> +#ifdef DEBUG
> +static int
> +xfs_bmap_exact_minlen_extent_alloc(
> +	struct xfs_bmalloca	*ap)
> +{
> +	struct xfs_alloc_arg	args;
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	xfs_fileoff_t		orig_offset;
> +	xfs_extlen_t		orig_length;
> +	int			error;
> +
> +	ASSERT(ap->length);
> +	orig_offset = ap->offset;
> +	orig_length = ap->length;
> +
> +	memset(&args, 0, sizeof(args));
> +	args.alloc_minlen_only = 1;
> +	args.tp = ap->tp;
> +	args.mp = mp;
> +
> +	xfs_bmap_compute_alignments(ap, &args, NULL);
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
> +#endif

Urgh, I don't like how the else bodies below are split by the
prepreprocessor directives.  Could you add an #else clause here to

#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)

so that we don't need to do that splitting below?

The rest looks ok though.

--D

> +
>  STATIC int
>  xfs_bmap_btalloc(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> @@ -4112,7 +4179,13 @@ xfs_bmap_alloc_userdata(
>  			return xfs_bmap_rtalloc(bma);
>  	}
>  
> -	return xfs_bmap_btalloc(bma);
> +#ifdef DEBUG
> +	if (unlikely(XFS_TEST_ERROR(false, mp,
> +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +		return xfs_bmap_exact_minlen_extent_alloc(bma);
> +	else
> +#endif
> +		return xfs_bmap_btalloc(bma);
>  }
>  
>  static int
> @@ -4148,10 +4221,19 @@ xfs_bmapi_allocate(
>  	else
>  		bma->minlen = 1;
>  
> -	if (bma->flags & XFS_BMAPI_METADATA)
> -		error = xfs_bmap_btalloc(bma);
> -	else
> +	if (bma->flags & XFS_BMAPI_METADATA) {
> +#ifdef DEBUG
> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> +				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +			error = xfs_bmap_exact_minlen_extent_alloc(bma);
> +		else
> +#endif
> +			error = xfs_bmap_btalloc(bma);
> +
> +
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
