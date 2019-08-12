Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfHLQmm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:42:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGcgo9158961
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:41 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u9nbt8v67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGd7Ng080655
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u9m0abxbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CGgdCV001932
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:39 GMT
Date: Mon, 12 Aug 2019 09:42:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 17/18] xfs: Enable delayed attributes
Message-ID: <20190812164238.GD7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-18-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:25PM -0700, Allison Collins wrote:
> Finally enable delayed attributes in xfs_attr_set and
> xfs_attr_remove.  We only do this for v4 and up since we
> cant add new log entries to old fs versions

...you can't add new log item types to *existing* fs versions, which
includes everything through present-day v5.

This needs a separate feature bit somewhere to prevent existing xfs
drivers from crashing and burning on attri/attrd items.  Most of this
deferred attr code could exist independently from the parent pointer
feature, so I guess you could be the first person to use one of the log
incompat feature bits?  That would be one way to get wider testing of
deferred attrs while we work on parent pointers.

--D

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9931e50..7023734 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -506,6 +506,7 @@ xfs_attr_set(
>  	int			valuelen)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (name->type & ATTR_ROOT) != 0;
> @@ -564,7 +565,20 @@ xfs_attr_set(
>  		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> -	error = xfs_attr_set_args(&args);
> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> +		error = xfs_attr_set_args(&args);
> +	else {
> +		error = xfs_has_attr(&args);
> +
> +		if (error == -EEXIST && (name->type & ATTR_CREATE))
> +			goto out_trans_cancel;
> +
> +		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> +			goto out_trans_cancel;
> +
> +		error = xfs_attr_set_deferred(dp, args.trans, name, value,
> +					      valuelen);
> +	}
>  	if (error)
>  		goto out_trans_cancel;
>  	if (!args.trans) {
> @@ -649,6 +663,7 @@ xfs_attr_remove(
>  	struct xfs_name		*name)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_da_args	args;
>  	int			error;
>  
> @@ -690,7 +705,14 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
> -	error = xfs_attr_remove_args(&args);
> +	error = xfs_has_attr(&args);
> +	if (error == -ENOATTR)
> +		goto out;
> +
> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> +		error = xfs_attr_remove_args(&args);
> +	else
> +		error = xfs_attr_remove_deferred(dp, args.trans, name);
>  	if (error)
>  		goto out;
>  
> -- 
> 2.7.4
> 
