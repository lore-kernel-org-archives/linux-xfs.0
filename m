Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB17CC3A59D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 00:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8823F2086C
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 00:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Khfaf2Xu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfHQA2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 20:28:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfHQA2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 20:28:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H0Ewj0162544;
        Sat, 17 Aug 2019 00:28:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iugJU/vuRyz4dar+pKjXWYjt6XJD8ud6bhA9xnS31Us=;
 b=Khfaf2XuCkZBmwRBKSBPHPyS8Poq2pf1uvqj2Jtg+x9ji2T7ODWfUiQlhJtOlLkhLHVM
 cF7vBELyOHT/seFmcU9NCSCzyli2KYooOJzta6b4klUwo54H0w9ottVIYX2JWWqeCJcu
 oM4f5T0Sfvo0FY2725vJ4JF6/d/J867ON784lj6GCLC8f3yVqPYddBUQo0Nhqrx+an3m
 PP9BG4qBmk/GTU0hPDR1eRxorCpG+OzId6DsiD+sBOJI429EkBxLo3dBlogV4KLWG8F5
 RnQCzQ7UKdCeQHFAusmLmJFJP1oxK5UoeM0veNwSmwtNQdvSY4RmoAQmycrnQaoqM80U PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvpu7tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 00:28:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H0RUSu150658;
        Sat, 17 Aug 2019 00:28:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ue6qcggag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 00:28:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7H0SFpC017758;
        Sat, 17 Aug 2019 00:28:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 17:28:15 -0700
Date:   Fri, 16 Aug 2019 17:28:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs: refactor successful AG allocation accounting
 code
Message-ID: <20190817002814.GK15186@magnolia>
References: <20190815125538.49570-1-bfoster@redhat.com>
 <20190815125538.49570-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815125538.49570-5-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908170000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 15, 2019 at 08:55:38AM -0400, Brian Foster wrote:
> The higher level allocation code is unnecessarily split across
> xfs_alloc_ag_vextent() and xfs_alloc_ag_vextent_type(). In
> preparation for condensing this code, factor out the AG accounting
> bits and move the caller down after the generic allocation structure
> and function definitions to pick them up without the need for
> declarations. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 75 +++++++++++++++++++++++----------------
>  1 file changed, 45 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d550aa5597bf..4ae4cfa0ed7f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1364,6 +1364,48 @@ xfs_alloc_ag_vextent_near(
>  	return error;
>  }
>  
> +/*
> + * Various AG accounting updates for a successful allocation. This includes
> + * updating the rmapbt, AG free block accounting and AG reservation accounting.
> + */
> +STATIC int
> +xfs_alloc_ag_vextent_accounting(
> +	struct xfs_alloc_arg	*args)
> +{
> +	int			error = 0;
> +
> +	ASSERT(args->agbno != NULLAGBLOCK);
> +	ASSERT(args->len >= args->minlen);
> +	ASSERT(args->len <= args->maxlen);
> +	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
> +	ASSERT(args->agbno % args->alignment == 0);
> +
> +	/* if not file data, insert new block into the reverse map btree */
> +	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
> +		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
> +				       args->agbno, args->len, &args->oinfo);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (!args->wasfromfl) {
> +		error = xfs_alloc_update_counters(args->tp, args->pag,
> +						  args->agbp,
> +						  -((long)(args->len)));
> +		if (error)
> +			return error;
> +
> +		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
> +					      args->agbno, args->len));
> +	}
> +
> +	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
> +
> +	XFS_STATS_INC(args->mp, xs_allocx);
> +	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
> +	return error;
> +}
> +
>  /*
>   * Allocate a variable extent in the allocation group agno.
>   * Type and bno are used to determine where in the allocation group the
> @@ -1402,38 +1444,11 @@ xfs_alloc_ag_vextent(
>  		ASSERT(0);
>  		/* NOTREACHED */
>  	}
> -
> -	if (error || args->agbno == NULLAGBLOCK)
> +	if (error)
>  		return error;
>  
> -	ASSERT(args->len >= args->minlen);
> -	ASSERT(args->len <= args->maxlen);
> -	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
> -	ASSERT(args->agbno % args->alignment == 0);
> -
> -	/* if not file data, insert new block into the reverse map btree */
> -	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
> -		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
> -				       args->agbno, args->len, &args->oinfo);
> -		if (error)
> -			return error;
> -	}
> -
> -	if (!args->wasfromfl) {
> -		error = xfs_alloc_update_counters(args->tp, args->pag,
> -						  args->agbp,
> -						  -((long)(args->len)));
> -		if (error)
> -			return error;
> -
> -		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
> -					      args->agbno, args->len));
> -	}
> -
> -	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
> -
> -	XFS_STATS_INC(args->mp, xs_allocx);
> -	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
> +	if (args->agbno != NULLAGBLOCK)
> +		error = xfs_alloc_ag_vextent_accounting(args);
>  	return error;
>  }
>  
> -- 
> 2.20.1
> 
