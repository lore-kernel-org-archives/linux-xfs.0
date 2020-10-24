Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE3DC2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 23:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8E22074A
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 23:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hNHm/MJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762899AbgJXXPt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 19:15:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1734911AbgJXXPt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 19:15:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09ONErCF092458;
        Sat, 24 Oct 2020 23:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2HifADlasO8/e8z39weacbEWReKCEfaDYXFG5y4CwOQ=;
 b=hNHm/MJP9/wnRW5t4xVcBoX6BNOkJB7rz4kRyGvguJZr+RJx29Nl2HZIoh15OnhEImKx
 lYzWT+Q8yJ7ticGIVRNUrCjiOReAKhWbILojkgYZ9tIQ5emNs1XxxFuhxKd1xoQVLaBW
 cxlmbg8+wQoF+xi2e8qttrnDA/q1PjUqxcEoebyXPxYN/s/QUMWr38wyXfV3lexTQYMv
 YrA31PwSD+zL8xB0rkHB38gLKCcKTVGmNOsIuQlteOKlyPeaDKQgUvCy19atNBwgisQe
 2c2+TNQnD9YAJVM5DIxDebhyfgUXqmc/URaUo9vVBxhKUXD9xq5uqvzvsXh2ucncb1HT IA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kh6dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 23:15:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09ONAF85086457;
        Sat, 24 Oct 2020 23:15:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34caa97w42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 23:15:40 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09ONFYVb003044;
        Sat, 24 Oct 2020 23:15:34 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 16:15:34 -0700
Subject: Re: [PATCH V7 13/14] xfs: Process allocated extent in a separate
 function
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-14-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c52a9a2b-7e12-af12-bd48-0e95bde7e7ba@oracle.com>
Date:   Sat, 24 Oct 2020 16:15:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-14-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 suspectscore=2 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240179
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> This commit moves over the code in xfs_bmap_btalloc() which is
> responsible for processing an allocated extent to a new function. Apart
> from xfs_bmap_btalloc(), the new function will be invoked by another
> function introduced in a future commit.
> 
Ok, looks helper function looks equivalent

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c | 74 ++++++++++++++++++++++++----------------
>   1 file changed, 45 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 935f2d506748..88db23afc51c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3509,6 +3509,48 @@ xfs_bmap_compute_alignments(
>   	}
>   }
>   
> +static void
> +xfs_bmap_process_allocated_extent(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	xfs_fileoff_t		orig_offset,
> +	xfs_extlen_t		orig_length)
> +{
> +	int			nullfb;
> +
> +	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> +
> +	/*
> +	 * check the allocation happened at the same or higher AG than
> +	 * the first block that was allocated.
> +	 */
> +	ASSERT(nullfb ||
> +		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
> +		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
> +
> +	ap->blkno = args->fsbno;
> +	if (nullfb)
> +		ap->tp->t_firstblock = args->fsbno;
> +	ap->length = args->len;
> +	/*
> +	 * If the extent size hint is active, we tried to round the
> +	 * caller's allocation request offset down to extsz and the
> +	 * length up to another extsz boundary.  If we found a free
> +	 * extent we mapped it in starting at this new offset.  If the
> +	 * newly mapped space isn't long enough to cover any of the
> +	 * range of offsets that was originally requested, move the
> +	 * mapping up so that we can fill as much of the caller's
> +	 * original request as possible.  Free space is apparently
> +	 * very fragmented so we're unlikely to be able to satisfy the
> +	 * hints anyway.
> +	 */
> +	if (ap->length <= orig_length)
> +		ap->offset = orig_offset;
> +	else if (ap->offset + ap->length < orig_offset + orig_length)
> +		ap->offset = orig_offset + orig_length - ap->length;
> +	xfs_bmap_btalloc_accounting(ap, args);
> +}
> +
>   STATIC int
>   xfs_bmap_btalloc(
>   	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> @@ -3701,36 +3743,10 @@ xfs_bmap_btalloc(
>   			return error;
>   		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
>   	}
> +
>   	if (args.fsbno != NULLFSBLOCK) {
> -		/*
> -		 * check the allocation happened at the same or higher AG than
> -		 * the first block that was allocated.
> -		 */
> -		ASSERT(ap->tp->t_firstblock == NULLFSBLOCK ||
> -		       XFS_FSB_TO_AGNO(mp, ap->tp->t_firstblock) <=
> -		       XFS_FSB_TO_AGNO(mp, args.fsbno));
> -
> -		ap->blkno = args.fsbno;
> -		if (ap->tp->t_firstblock == NULLFSBLOCK)
> -			ap->tp->t_firstblock = args.fsbno;
> -		ap->length = args.len;
> -		/*
> -		 * If the extent size hint is active, we tried to round the
> -		 * caller's allocation request offset down to extsz and the
> -		 * length up to another extsz boundary.  If we found a free
> -		 * extent we mapped it in starting at this new offset.  If the
> -		 * newly mapped space isn't long enough to cover any of the
> -		 * range of offsets that was originally requested, move the
> -		 * mapping up so that we can fill as much of the caller's
> -		 * original request as possible.  Free space is apparently
> -		 * very fragmented so we're unlikely to be able to satisfy the
> -		 * hints anyway.
> -		 */
> -		if (ap->length <= orig_length)
> -			ap->offset = orig_offset;
> -		else if (ap->offset + ap->length < orig_offset + orig_length)
> -			ap->offset = orig_offset + orig_length - ap->length;
> -		xfs_bmap_btalloc_accounting(ap, &args);
> +		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
> +			orig_length);
>   	} else {
>   		ap->blkno = NULLFSBLOCK;
>   		ap->length = 0;
> 
