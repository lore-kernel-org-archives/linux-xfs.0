Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D41C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C66214F1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4uMTHwj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgJ2WVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 18:21:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33186 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 18:21:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMFLND043896;
        Thu, 29 Oct 2020 22:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qXCKHaUS5U57w0awlg0R0uj13wDhATs0vk/rS+kqk8o=;
 b=V4uMTHwjX1t9SN4Zh/goSq+kUASzZwO/B+kVgWk6lLjZn0alRVDKZ8NSm7bNmJEMmI0n
 ize1480R/GpeBqOBC/XXMfTT4bAxjL//5+BDzbYyiblksiTA6DccmjjBhDt2i59Y6F0P
 nLfTVcoyB396VxMXFIPQCJEX712N+erpLZfGFPWtkFxFYK8SoEHRLF1/VUqZsOSJefg3
 oTNRP19m0CmLWbxp6X7io4lpvCUmXxwgVQXMxGHbuCRNQ4B9gCQgkV71exNCpXIwl0+O
 jJWGhZ+v/wGltwY/Ot7vUPK5MKIMh6qtfpihriGyuQKzRw5yDHmO5Wu4ol1mkOCEpXnu rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb7fpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 22:21:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMKBvk080915;
        Thu, 29 Oct 2020 22:21:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx6119sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 22:21:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TMLWST005364;
        Thu, 29 Oct 2020 22:21:32 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 15:21:31 -0700
Date:   Thu, 29 Oct 2020 15:21:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V8 12/14] xfs: Compute bmap extent alignments in a
 separate function
Message-ID: <20201029222130.GM1061252@magnolia>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
 <20201029101348.4442-13-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029101348.4442-13-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290152
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 03:43:46PM +0530, Chandan Babu R wrote:
> This commit moves over the code which computes stripe alignment and
> extent size hint alignment into a separate function. Apart from
> xfs_bmap_btalloc(), the new function will be used by another function
> introduced in a future commit.
> 
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
>  1 file changed, 51 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 64c4d0e384a5..935f2d506748 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
>  		args->len);
>  }
>  
> +static void

Why not return stripe_align instead of passing pointers?

> +xfs_bmap_compute_alignments(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	int			*stripe_align)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> +	int			error;
> +
> +	/* stripe alignment for allocation is determined by mount parameters */
> +	*stripe_align = 0;
> +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> +		*stripe_align = mp->m_swidth;
> +	else if (mp->m_dalign)
> +		*stripe_align = mp->m_dalign;
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
> @@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
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

FWIW you might as well clean up the variable declarations while you're
moving this stuff around:

STATIC int
xfs_bmap_btalloc(
	struct xfs_bmalloca	*ap)
{
	struct xfs_mount	*mp = ap->ip->i_mount;
	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };

And then you can get rid of the memset call.

AFAICT there aren't any data dependencies between the parts where we
initialize args.fsbno and where we set args.prod and args.mod, so I
guess this is a reasonable hoist.

Other than those cleanups, this looks ok to me.

--D

>  
> +	xfs_bmap_compute_alignments(ap, &args, &stripe_align);
>  
>  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> @@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
>  	 * Normal allocation, done through xfs_alloc_vextent.
>  	 */
>  	tryagain = isaligned = 0;
> -	memset(&args, 0, sizeof(args));
> -	args.tp = ap->tp;
> -	args.mp = mp;
>  	args.fsbno = ap->blkno;
>  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
>  
> @@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
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
