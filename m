Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDB5C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E436C20786
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LfdkzVcO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgKBRFj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:05:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgKBRFj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 12:05:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2H4sIE163029;
        Mon, 2 Nov 2020 17:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ml89R8QLRJ/rSnRGFwLqimtrAGtpSWl7RGRD1ht8goU=;
 b=LfdkzVcOd+Z2tc4OR7l6z1bTBOXl+L0kUd7jtCCR0tHD0z8+TB+4QOl5BbAUnkVtv+Vj
 PSs8RHgpe9BL7gzTb6qHvz9PJqCZ1EEHn1qUUGGxe0bTdhPYe5ZxyQpktiCvtt/3/4Jt
 O8/yELoID3E71BeHjFp40MgAlgvF30ugHaYEvykB+/+pFDy6gQsC1kK7I6L9rvHkXRRn
 UpZQgmRy2fvOjMm1dE15myIxjcD/whLo61+8xZvUYdmkm6tNMvZbbwAMK3viEmMDfKBN
 Ns65KXYNgTAB+w0EMEdRWWzl9E/J7Xr/yW/PzhBPh5IHG/dQysBDz0TZelaz2M2xEXRn 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw2d471-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Nov 2020 17:05:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2GkONn046332;
        Mon, 2 Nov 2020 17:05:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34hw0fbgem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Nov 2020 17:05:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A2H5UDx005411;
        Mon, 2 Nov 2020 17:05:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 09:05:29 -0800
Date:   Mon, 2 Nov 2020 09:05:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V9 12/14] xfs: Compute bmap extent alignments in a
 separate function
Message-ID: <20201102170528.GC7123@magnolia>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
 <20201102095048.100956-13-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102095048.100956-13-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=2 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=2 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020130
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 02, 2020 at 03:20:46PM +0530, Chandan Babu R wrote:
> This commit moves over the code which computes stripe alignment and
> extent size hint alignment into a separate function. Apart from
> xfs_bmap_btalloc(), the new function will be used by another function
> introduced in a future commit.
> 
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
> +xfs_bmap_compute_alignments(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	int			*stripe_align)

Uh were you going to change this to return stripe_align?

--D

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
