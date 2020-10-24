Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1146FC2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 22:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82B42098B
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 22:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rEufx8F8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762509AbgJXW1P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 18:27:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762500AbgJXW1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 18:27:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OML15j191294;
        Sat, 24 Oct 2020 22:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zZTHDFye6VHGojFBE68HQw2p12tEObEUyQqLIgasWNM=;
 b=rEufx8F8rkyGcLginffbYlS0bCUEGgky+mdkEg13CTuM87XItcmLkYO23iiWvemzFeZR
 Tg2bCe3zsbolg6xes+/Vcwd5D+Gnplhzq4OZoRr67SFYPtaSp3SOuJV8PSxIyBbzH3I/
 VLaR70dSxui0ZRXSd5CsKBcLNKlSIuHNZ4bH+R1Z4g7yQfikgqOKvgAmaYwvcK3NSnvL
 seQaTASlenGPzyKDv0BdlssCT7gzo9C1ob+FlZbB2LhqCefgEQdfK1K1mfD/Hvokw8kG
 GUutMw/Aw16LAEPuOtvDo+vb5rTQKCovev5m4qJVkx3PomBV+91PhTSK/GpjneUoPOr+ sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kh57g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 22:27:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OML9vF173017;
        Sat, 24 Oct 2020 22:25:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34c9cra2rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 22:25:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OMP9xj026119;
        Sat, 24 Oct 2020 22:25:09 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 15:25:09 -0700
Subject: Re: [PATCH V7 12/14] xfs: Compute bmap extent alignments in a
 separate function
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-13-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a3948d76-19b2-68a6-d833-b13152fca318@oracle.com>
Date:   Sat, 24 Oct 2020 15:25:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-13-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010240171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240171
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> This commit moves over the code which computes stripe alignment and
> extent size hint alignment into a separate function. Apart from
> xfs_bmap_btalloc(), the new function will be used by another function
> introduced in a future commit.
> 
Ok, the hoist looks equivelent
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
>   1 file changed, 51 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 64c4d0e384a5..935f2d506748 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
>   		args->len);
>   }
>   
> +static void
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
>   STATIC int
>   xfs_bmap_btalloc(
>   	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
>   {
>   	xfs_mount_t	*mp;		/* mount point structure */
>   	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> -	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
>   	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
>   	xfs_agnumber_t	ag;
>   	xfs_alloc_arg_t	args;
> @@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
>   
>   	mp = ap->ip->i_mount;
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
>   	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>   	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> @@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
>   	 * Normal allocation, done through xfs_alloc_vextent.
>   	 */
>   	tryagain = isaligned = 0;
> -	memset(&args, 0, sizeof(args));
> -	args.tp = ap->tp;
> -	args.mp = mp;
>   	args.fsbno = ap->blkno;
>   	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
>   
> @@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
>   		args.total = ap->total;
>   		args.minlen = ap->minlen;
>   	}
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
>   	/*
>   	 * If we are not low on available data blocks, and the underlying
>   	 * logical volume manager is a stripe, and the file offset is zero then
> 
