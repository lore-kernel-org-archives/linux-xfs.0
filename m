Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4D9C388F7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 19:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DD420E65
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 19:51:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZGNdYrrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgKCTvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 14:51:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729716AbgKCTvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 14:51:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3JmvDb021069;
        Tue, 3 Nov 2020 19:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=70cOlRsEDv96tWy2T97tVzJZyUdwqIIG5yWDwim0awY=;
 b=ZGNdYrrDyMlSYtsPjO8dEXWB5IehF/ge8ryG9FH3bUBaXsULBZ76uOrwpVeToGzqhM7e
 7jCWVICGEGdoq+1qB+HtlAmnKJ8WHTpyA70BaxJgyjPSh+P6fvLxNA4NWCbDKoWDuXcU
 /8qzRIZjM4h3qEPCHJrEbWutDtPyu+TPgEtHztjkzgmL1oyauqH6YhBT14aORRa6T37L
 1/Q7EDJ93R9LImLkeqcR+urXsFGpa6lXI5pSMeOibXAPNUW2LuelFXKJ5BSRSqUw0hPD
 ruwQdd7o/nvrKtLm5+YgIzKrof0E+asi5Eyy/fihTCdaZIRjITVEsg9LOk3U/UcNyqAt gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2k7u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 19:51:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3JonPa049021;
        Tue, 3 Nov 2020 19:51:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34jf48ysxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 19:51:18 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A3JpGQj030710;
        Tue, 3 Nov 2020 19:51:17 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 11:51:16 -0800
Date:   Tue, 3 Nov 2020 11:51:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V10 12/14] xfs: Compute bmap extent alignments in a
 separate function
Message-ID: <20201103195114.GA7115@magnolia>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
 <20201103150642.2032284-13-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103150642.2032284-13-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=2 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030133
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 08:36:40PM +0530, Chandan Babu R wrote:
> This commit moves over the code which computes stripe alignment and
> extent size hint alignment into a separate function. Apart from
> xfs_bmap_btalloc(), the new function will be used by another function
> introduced in a future commit.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks fine at last :)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Could you please add a fsstress style test that sets the errortag to see
what kinds of, uh, testing artifacts fall out of that mode?

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 89 +++++++++++++++++++++++-----------------
>  1 file changed, 52 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 64c4d0e384a5..5032539d5e85 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3463,13 +3463,59 @@ xfs_bmap_btalloc_accounting(
>  		args->len);
>  }
>  
> +static int
> +xfs_bmap_compute_alignments(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> +	int			stripe_align = 0;
> +	int			error;
> +
> +	/* stripe alignment for allocation is determined by mount parameters */
> +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> +		stripe_align = mp->m_swidth;
> +	else if (mp->m_dalign)
> +		stripe_align = mp->m_dalign;
> +
> +	if (ap->flags & XFS_BMAPI_COWFORK)
> +		align = xfs_get_cowextsz_hint(ap->ip);
> +	else if (ap->datatype & XFS_ALLOC_USERDATA)
> +		align = xfs_get_extsz_hint(ap->ip);
> +	if (align) {
> +		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> +						align, 0, ap->eof, 0, ap->conv,
> +						&ap->offset, &ap->length);
> +		ASSERT(!error);
> +		ASSERT(ap->length);
> +	}
> +
> +	/* apply extent size hints if obtained earlier */
> +	if (align) {
> +		args->prod = align;
> +		div_u64_rem(ap->offset, args->prod, &args->mod);
> +		if (args->mod)
> +			args->mod = args->prod - args->mod;
> +	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> +		args->prod = 1;
> +		args->mod = 0;
> +	} else {
> +		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> +		div_u64_rem(ap->offset, args->prod, &args->mod);
> +		if (args->mod)
> +			args->mod = args->prod - args->mod;
> +	}
> +
> +	return stripe_align;
> +}
> +
>  STATIC int
>  xfs_bmap_btalloc(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
>  {
>  	xfs_mount_t	*mp;		/* mount point structure */
>  	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> -	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
>  	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
>  	xfs_agnumber_t	ag;
>  	xfs_alloc_arg_t	args;
> @@ -3489,25 +3535,11 @@ xfs_bmap_btalloc(
>  
>  	mp = ap->ip->i_mount;
>  
> -	/* stripe alignment for allocation is determined by mount parameters */
> -	stripe_align = 0;
> -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> -		stripe_align = mp->m_swidth;
> -	else if (mp->m_dalign)
> -		stripe_align = mp->m_dalign;
> -
> -	if (ap->flags & XFS_BMAPI_COWFORK)
> -		align = xfs_get_cowextsz_hint(ap->ip);
> -	else if (ap->datatype & XFS_ALLOC_USERDATA)
> -		align = xfs_get_extsz_hint(ap->ip);
> -	if (align) {
> -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> -						align, 0, ap->eof, 0, ap->conv,
> -						&ap->offset, &ap->length);
> -		ASSERT(!error);
> -		ASSERT(ap->length);
> -	}
> +	memset(&args, 0, sizeof(args));
> +	args.tp = ap->tp;
> +	args.mp = mp;
>  
> +	stripe_align = xfs_bmap_compute_alignments(ap, &args);
>  
>  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> @@ -3538,9 +3570,6 @@ xfs_bmap_btalloc(
>  	 * Normal allocation, done through xfs_alloc_vextent.
>  	 */
>  	tryagain = isaligned = 0;
> -	memset(&args, 0, sizeof(args));
> -	args.tp = ap->tp;
> -	args.mp = mp;
>  	args.fsbno = ap->blkno;
>  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
>  
> @@ -3571,21 +3600,7 @@ xfs_bmap_btalloc(
>  		args.total = ap->total;
>  		args.minlen = ap->minlen;
>  	}
> -	/* apply extent size hints if obtained earlier */
> -	if (align) {
> -		args.prod = align;
> -		div_u64_rem(ap->offset, args.prod, &args.mod);
> -		if (args.mod)
> -			args.mod = args.prod - args.mod;
> -	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> -		args.prod = 1;
> -		args.mod = 0;
> -	} else {
> -		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> -		div_u64_rem(ap->offset, args.prod, &args.mod);
> -		if (args.mod)
> -			args.mod = args.prod - args.mod;
> -	}
> +
>  	/*
>  	 * If we are not low on available data blocks, and the underlying
>  	 * logical volume manager is a stripe, and the file offset is zero then
> -- 
> 2.28.0
> 
