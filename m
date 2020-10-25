Return-Path: <SRS0=dP94=EA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF18FC2D0A3
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Oct 2020 01:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B10222C4
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Oct 2020 01:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P2U6qDs/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766584AbgJYBXG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 21:23:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53290 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1766583AbgJYBXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 21:23:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09P1K6NE029866;
        Sun, 25 Oct 2020 01:22:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5QenSdJQcj58tueiP3iG21vXiH86R+GnkGII5+7C7k0=;
 b=P2U6qDs/kbRC5xJw9bRMOUDuoXV+FC+8Dg9qlVVX4L/IHAy0spYrY5uKqSK0J0PCDRqD
 hPWGxKVaQmL0earKdUwKdwNg51r+4aUUqimuHhwPmnUwWXNm1R8WcUK2cT26MMFaxJ5O
 hNP0763X45Z2y/jf78+/h9Oupc/hmvXtvqNnbFEpaOkqWB1+DVkrvNhpCJ7eo1rto5CK
 u9bbPXa3FVUIZLU06daKJE/FCC0jMinR2NpQ0eunBCOAJJ41hbeQbLpftiEAFt325M0V
 m5D5+8SIaphG0Y7k1h841rw5IH9UxopPe2jWb/G4MyPMmefWzdaMSxLTj39mALDHXInz xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sahd3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 01:22:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09P1KFPw086818;
        Sun, 25 Oct 2020 01:22:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwuj9ctf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 01:22:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09P1Ms3I005490;
        Sun, 25 Oct 2020 01:22:54 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 18:22:54 -0700
Subject: Re: [PATCH V7 14/14] xfs: Introduce error injection to allocate only
 minlen size extents for files
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-15-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <8878dee5-c3d4-0bf5-ead9-d4682fafdf6f@oracle.com>
Date:   Sat, 24 Oct 2020 18:22:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-15-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250006
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
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
>     sufficient number of one block sized extent records.
> 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> After step 3, xfs_bmap_btalloc() will issue space allocation
> requests for minlen sized extents only.
> 
> ENOSPC error code is returned to userspace when there aren't any "one
> block sized" extents left in any of the AGs.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++++++
>   fs/xfs/libxfs/xfs_alloc.h    |   3 ++
>   fs/xfs/libxfs/xfs_bmap.c     | 100 +++++++++++++++++++++++++++++++----
>   fs/xfs/libxfs/xfs_errortag.h |   4 +-
>   fs/xfs/xfs_error.c           |   3 ++
>   5 files changed, 150 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..8e132f8b9cc4 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2473,6 +2473,47 @@ xfs_defer_agfl_block(
>   	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>   }
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
>   /*
>    * Decide whether to use this allocation group for this allocation.
>    * If so, fix up the btree freelist's size.
> @@ -2544,6 +2585,15 @@ xfs_alloc_fix_freelist(
>   	if (!xfs_alloc_space_available(args, need, flags))
>   		goto out_agbp_relse;
>   
> +#ifdef DEBUG
> +	if (args->alloc_minlen_only) {
> +		int i;
Just a nit: I think "i" seems like a bit of an odd name here.  I think I 
might have called it stat to match its parameter name.  Other than that, 
I think the rest looks ok.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Allison
> +
> +		error = xfs_exact_minlen_extent_available(args, agbp, &i);
> +		if (error || !i)
> +			goto out_agbp_relse;
> +	}
> +#endif
>   	/*
>   	 * Make the freelist shorter if it's too long.
>   	 *
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..a4427c5775c2 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
>   	char		wasfromfl;	/* set if allocation is from freelist */
>   	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>   	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> +#ifdef DEBUG
> +	bool		alloc_minlen_only; /* allocate exact minlen extent */
> +#endif
>   } xfs_alloc_arg_t;
>   
>   /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 88db23afc51c..74e148cc41b2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3474,11 +3474,13 @@ xfs_bmap_compute_alignments(
>   	int			error;
>   
>   	/* stripe alignment for allocation is determined by mount parameters */
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
>   	if (ap->flags & XFS_BMAPI_COWFORK)
>   		align = xfs_get_cowextsz_hint(ap->ip);
> @@ -3551,6 +3553,71 @@ xfs_bmap_process_allocated_extent(
>   	xfs_bmap_btalloc_accounting(ap, args);
>   }
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
> +
>   STATIC int
>   xfs_bmap_btalloc(
>   	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> @@ -4112,7 +4179,13 @@ xfs_bmap_alloc_userdata(
>   			return xfs_bmap_rtalloc(bma);
>   	}
>   
> -	return xfs_bmap_btalloc(bma);
> +#ifdef DEBUG
> +	if (unlikely(XFS_TEST_ERROR(false, mp,
> +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +		return xfs_bmap_exact_minlen_extent_alloc(bma);
> +	else
> +#endif
> +		return xfs_bmap_btalloc(bma);
>   }
>   
>   static int
> @@ -4148,10 +4221,19 @@ xfs_bmapi_allocate(
>   	else
>   		bma->minlen = 1;
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
>   		error = xfs_bmap_alloc_userdata(bma);
> +	}
>   	if (error || bma->blkno == NULLFSBLOCK)
>   		return error;
>   
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 1c56fcceeea6..6ca9084b6934 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -57,7 +57,8 @@
>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>   #define XFS_ERRTAG_BUF_IOERROR				35
>   #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> -#define XFS_ERRTAG_MAX					37
> +#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> +#define XFS_ERRTAG_MAX					38
>   
>   /*
>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -99,5 +100,6 @@
>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>   #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>   #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> +#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>   
>   #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 3780b118cc47..185b4915b7bf 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
>   	XFS_RANDOM_IUNLINK_FALLBACK,
>   	XFS_RANDOM_BUF_IOERROR,
>   	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> +	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>   };
>   
>   struct xfs_errortag_attr {
> @@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>   XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>   XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>   
>   static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>   	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>   	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> +	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>   	NULL,
>   };
>   
> 
