Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfHLQDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:03:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFxIU4122670
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:46 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u9nbt8n2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CG2f7m177570
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u9m0aareq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CG2rNo022351
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:02:53 GMT
Date: Mon, 12 Aug 2019 09:02:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 07/18] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
Message-ID: <20190812160252.GV7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-8-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:15PM -0700, Allison Collins wrote:
> Since delayed operations cannot roll transactions, factor
> up the transaction handling into the calling function
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 10 ++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 72af8e2..f36c792 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -752,6 +752,11 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			return error;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> @@ -1090,6 +1095,11 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			goto out;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8d2e11f..8a6f5df 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2891,10 +2891,5 @@ xfs_attr3_leaf_flipflags(
>  			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -
>  	return error;
>  }
> -- 
> 2.7.4
> 
