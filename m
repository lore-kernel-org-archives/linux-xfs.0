Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E31C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80DE920663
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pQ/P3lSp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgEDRl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 13:41:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbgEDRl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 13:41:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HbZSI018647
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sFfkPUDbBZArdlsZe+ifVN7viSOj7MRAT0ZedJTmcjY=;
 b=pQ/P3lSpvUEZtwFkCWMOG/hPtH6ushUWAqNJsjmbkNNwF97df1ZnL98srf5PbXwSTw9+
 c6unEne+poTmPzF8d/EmZKt90Qsw16KVyYlExh5XPXPldx02K9vn/Y3UmvNr4RkfQgmc
 t1jRWEh6WAsvq7UaD++THkg90dekvhp/K9tYLqgwhmXipTzStdlOof9pt2wxHAYPVnrq
 T5F6BBqe9tjojfg1pOfPP771FIUzq/DLIT9UjFZ7U5jrsm21hInqdREB6xO7R2sYqrP9
 7BsP3GPC0Q8PyTf7SjxsyBEvH3cZhl3YaJ/5hduIkmJVVnbCTr0OoHRYgJBsnzlzjinr bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r0e0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:41:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HbLjw186621
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:41:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnbbbbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:41:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044HfQFw016082
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:41:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 10:41:25 -0700
Date:   Mon, 4 May 2020 10:41:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 10/24] xfs: Add helper function
 __xfs_attr_rmtval_remove
Message-ID: <20200504174125.GD13783@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-11-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:02PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to
> return EAGAIN for new transactions. We will use this later when we
> introduce delayed attributes.  This function will eventually replace
> xfs_attr_rmtval_remove

Like Brian suggested, this changelog could probably just say that we're
hoisting the loop body into a separate function so that delayed attrs
can manage the transaction rolling.

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4d51969..02d1a44 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
>  	xfs_dablk_t		lblkno;
>  	int			blkcnt;
>  	int			error = 0;
> -	int			done = 0;
> +	int			retval = 0;
>  
>  	trace_xfs_attr_rmtval_remove(args);
>  
> @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
>  	 */
>  	lblkno = args->rmtblkno;
>  	blkcnt = args->rmtblkcnt;
> -	while (!done) {
> -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> -				    XFS_BMAPI_ATTRFORK, 1, &done);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	do {
> +		retval = __xfs_attr_rmtval_remove(args);
> +		if (retval && retval != EAGAIN)
> +			return retval;
>  
>  		/*
>  		 * Close out trans and start the next one in the chain.
> @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
>  		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  		if (error)
>  			return error;
> -	}
> +	} while (retval == -EAGAIN);
> +
>  	return 0;
>  }
> +
> +/*
> + * Remove the value associated with an attribute by deleting the out-of-line
> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * transaction and recall the function

recall the function...?

Oh.  "re-call" the function.

> + */
> +int
> +__xfs_attr_rmtval_remove(

xfs_attr_rmtval_remove_extent() ?

--D

> +	struct xfs_da_args	*args)
> +{
> +	int			error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	error = xfs_defer_finish(&args->trans);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;
> +
> +	return error;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index eff5f95..ee3337b 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
