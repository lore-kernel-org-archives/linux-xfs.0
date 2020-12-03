Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6464DC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AD5208BA
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502127AbgLCS0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:26:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502109AbgLCS0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 13:26:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3I9h3n047706;
        Thu, 3 Dec 2020 18:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lsB7yB7APeRSSh3gmwi6Bc9Fl+Vp6Mbqb2HaRkXDBcc=;
 b=eY1kSoK9fu8uivsamHwC0vkZk1agYbWSuVPLOfrLZwsIemoHleVHsdhhV6ID6h4YtAsJ
 D0sYr4zgzvn62H5QEmxRkRnveCrkxcfXYN9xJ9OIvOC7EFinB7mKlBZSaUAqNkM4qCug
 P7ed0l6jKM0DnawEaNBcxmphJQHiYHBcTqJG1wtInPYX7xJj888O37xUhmkW6u2BIxyS
 Yt9M0RJvcmSqeT5CX4j2aoyEzX0xb8uzrUG9cbOzIgutH9Vl04S4AoqpbcQh2teFMRQb
 5QtCxL5Rj4C/0hGg1QJaH7lIRzkt/gU1dCdMdcGrMgn+ap4rqCUWrEw7vV25d3ErGer/ +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqykuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 18:25:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IAQ6F119961;
        Thu, 3 Dec 2020 18:25:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540awkjg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 18:25:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3IPj8K001458;
        Thu, 3 Dec 2020 18:25:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 10:25:45 -0800
Date:   Thu, 3 Dec 2020 10:25:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unneeded return value check for
 xfs_rmapbt_init_cursor()
Message-ID: <20201203182544.GB106272@magnolia>
References: <1606984438-13997-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606984438-13997-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=2 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030108
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 04:33:58PM +0800, Joseph Qi wrote:
> Since xfs_rmapbt_init_cursor() can always return a valid cursor, the
> NULL check in caller is unneeded.
> This also keeps the behavior consistent with other callers.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c | 9 ---------
>  fs/xfs/scrub/bmap.c      | 5 -----
>  fs/xfs/scrub/common.c    | 2 --
>  3 files changed, 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 2668ebe..10e0cf99 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2404,10 +2404,6 @@ struct xfs_rmap_query_range_info {
>  			return -EFSCORRUPTED;
>  
>  		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> -		if (!rcur) {
> -			error = -ENOMEM;
> -			goto out_cur;
> -		}
>  	}
>  	*pcur = rcur;
>  
> @@ -2446,11 +2442,6 @@ struct xfs_rmap_query_range_info {
>  		error = -EFSCORRUPTED;
>  	}
>  	return error;
> -
> -out_cur:
> -	xfs_trans_brelse(tp, agbp);
> -
> -	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index fed56d2..dd165c0 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -563,10 +563,6 @@ struct xchk_bmap_check_rmap_info {
>  		return error;
>  
>  	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
> -	if (!cur) {
> -		error = -ENOMEM;
> -		goto out_agf;
> -	}
>  
>  	sbcri.sc = sc;
>  	sbcri.whichfork = whichfork;
> @@ -575,7 +571,6 @@ struct xchk_bmap_check_rmap_info {
>  		error = 0;
>  
>  	xfs_btree_del_cursor(cur, error);
> -out_agf:
>  	xfs_trans_brelse(sc->tp, agf);
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 1887605..6757dc7 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -502,8 +502,6 @@ struct xchk_rmap_ownedby_info {
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
>  		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
>  				agno);
> -		if (!sa->rmap_cur)
> -			goto err;

Would you mind cleaning out the other btree cursor allocation
warts under fs/xfs/scrub/ ?

--D

>  	}
>  
>  	/* Set up a refcountbt cursor for cross-referencing. */
> -- 
> 1.8.3.1
> 
