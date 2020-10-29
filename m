Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC611C4742C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78DB620838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WoC+NGe5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJ2WXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 18:23:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38142 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 18:23:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMF4Mc136026;
        Thu, 29 Oct 2020 22:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=X3Bq7G3xZw1TqFSn3fK/xwIX33lOuQ7xawisFHj3ceo=;
 b=WoC+NGe5VUfBIDj3/DYO/wDJf1zkRgv6H+73nh+6UAPWD9IHMlbtlnCBvkKFiJ6SNaMl
 DJ4aYepM1/ZbliRCWA8wYa9xfNNkHnvk1x6cBrqgl+1NCjdjc1l8WIcVkSmqkJvlhIvM
 uEMqBxauowCME291XeoWHHj1Qar4FIxF8czA3IRoXTVZiBRTgkHgHIKn2XdR/mgghCJc
 DhN1dJ8F3n/3nAYZcqWtyyVZ14XFKWdN1jnV1KPAj7jwmTqH1h7Yr92CiH8nNJFWSn/C
 Bs1XIF0FLGyCmY2uyDi5Es4EPcv1dBYR+2VEI06MA1oNbpsH9SK7o88xNDOygkT0z1RS Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm4cx5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 22:23:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMKQxl043603;
        Thu, 29 Oct 2020 22:23:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1trk5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 22:23:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TMN0bH005894;
        Thu, 29 Oct 2020 22:23:00 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 15:23:00 -0700
Date:   Thu, 29 Oct 2020 15:22:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V8 13/14] xfs: Process allocated extent in a separate
 function
Message-ID: <20201029222259.GN1061252@magnolia>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
 <20201029101348.4442-14-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029101348.4442-14-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=5 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=5 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290152
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 03:43:47PM +0530, Chandan Babu R wrote:
> This commit moves over the code in xfs_bmap_btalloc() which is
> responsible for processing an allocated extent to a new function. Apart
> from xfs_bmap_btalloc(), the new function will be invoked by another
> function introduced in a future commit.
> 
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks like a straightforward hoist.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 74 ++++++++++++++++++++++++----------------
>  1 file changed, 45 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 935f2d506748..88db23afc51c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3509,6 +3509,48 @@ xfs_bmap_compute_alignments(
>  	}
>  }
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
>  STATIC int
>  xfs_bmap_btalloc(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> @@ -3701,36 +3743,10 @@ xfs_bmap_btalloc(
>  			return error;
>  		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
>  	}
> +
>  	if (args.fsbno != NULLFSBLOCK) {
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
>  	} else {
>  		ap->blkno = NULLFSBLOCK;
>  		ap->length = 0;
> -- 
> 2.28.0
> 
