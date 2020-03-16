Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4873CC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 19:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9F520772
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 19:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZPsWH3tY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbgCPTkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 15:40:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732413AbgCPTkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 15:40:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GJcn0e163067;
        Mon, 16 Mar 2020 19:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VSDibp6dzPjtsMibPrGzCHx4/m3MjY+WgPmIstqF0uw=;
 b=ZPsWH3tYdVGccCTNmVirhHdvURGsCalYmsVNekK2QHQI/qsBHiHu3ukKXACyp7bVPriX
 KauFWCvOdvanDscylrBg53VzOKqyQkzQqv+CtlOBMB68ntjx33Tkjt/cfyOgfmmC4NZ9
 URRliuQVl2cnHEQablFE+SWRhm80Y4DCUBFsUO2ITll7WYS671in2dDsHCnXKhxzCxD7
 RDNdLYXpdeb6iBYWvwj+EymrSa54+e3qPUNHcCkUCmbdDFo/xyl4JU0i6IWFfXjsEE1N
 8CUjC/V6OT3JosgAbfzb4A/tUOKYuVlKJxqm2uKgmO6TmonmLTbb+4CacER7FPNUQ6D8 Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7krwpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 19:40:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GJVTBr043187;
        Mon, 16 Mar 2020 19:40:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92ahfh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 19:40:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GJecei017233;
        Mon, 16 Mar 2020 19:40:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 12:40:38 -0700
Date:   Mon, 16 Mar 2020 12:40:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/14] xfs: merge xlog_cil_push into xlog_cil_push_work
Message-ID: <20200316194036.GG256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=2
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160083
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:20PM +0100, Christoph Hellwig wrote:
> xlog_cil_push is only called by xlog_cil_push_work, so merge the two
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like a simple enough refactoring,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++---------------------------
>  1 file changed, 18 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..6a6278b8eb2d 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -626,24 +626,26 @@ xlog_cil_process_committed(
>  }
>  
>  /*
> - * Push the Committed Item List to the log. If @push_seq flag is zero, then it
> - * is a background flush and so we can chose to ignore it. Otherwise, if the
> - * current sequence is the same as @push_seq we need to do a flush. If
> - * @push_seq is less than the current sequence, then it has already been
> + * Push the Committed Item List to the log.
> + *
> + * If the current sequence is the same as xc_push_seq we need to do a flush. If
> + * xc_push_seq is less than the current sequence, then it has already been
>   * flushed and we don't need to do anything - the caller will wait for it to
>   * complete if necessary.
>   *
> - * @push_seq is a value rather than a flag because that allows us to do an
> - * unlocked check of the sequence number for a match. Hence we can allows log
> - * forces to run racily and not issue pushes for the same sequence twice. If we
> - * get a race between multiple pushes for the same sequence they will block on
> - * the first one and then abort, hence avoiding needless pushes.
> + * xc_push_seq is checked unlocked against the sequence number for a match.
> + * Hence we can allows log forces to run racily and not issue pushes for the
> + * same sequence twice.  If we get a race between multiple pushes for the same
> + * sequence they will block on the first one and then abort, hence avoiding
> + * needless pushes.
>   */
> -STATIC int
> -xlog_cil_push(
> -	struct xlog		*log)
> +static void
> +xlog_cil_push_work(
> +	struct work_struct	*work)
>  {
> -	struct xfs_cil		*cil = log->l_cilp;
> +	struct xfs_cil		*cil =
> +		container_of(work, struct xfs_cil, xc_push_work);
> +	struct xlog		*log = cil->xc_log;
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*ctx;
>  	struct xfs_cil_ctx	*new_ctx;
> @@ -657,9 +659,6 @@ xlog_cil_push(
>  	xfs_lsn_t		commit_lsn;
>  	xfs_lsn_t		push_seq;
>  
> -	if (!cil)
> -		return 0;
> -
>  	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
> @@ -867,28 +866,19 @@ xlog_cil_push(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/* release the hounds! */
> -	return xfs_log_release_iclog(log->l_mp, commit_iclog);
> +	xfs_log_release_iclog(log->l_mp, commit_iclog);
> +	return;
>  
>  out_skip:
>  	up_write(&cil->xc_ctx_lock);
>  	xfs_log_ticket_put(new_ctx->ticket);
>  	kmem_free(new_ctx);
> -	return 0;
> +	return;
>  
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
>  	xlog_cil_committed(ctx, true);
> -	return -EIO;
> -}
> -
> -static void
> -xlog_cil_push_work(
> -	struct work_struct	*work)
> -{
> -	struct xfs_cil		*cil = container_of(work, struct xfs_cil,
> -							xc_push_work);
> -	xlog_cil_push(cil->xc_log);
>  }
>  
>  /*
> -- 
> 2.24.1
> 
