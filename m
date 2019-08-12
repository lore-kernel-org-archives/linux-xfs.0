Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39048 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLQO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:14:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGEGkf137483
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8qdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGDlG7034195
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u9n9h1sj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGEsc7012869
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:54 GMT
Date: Mon, 12 Aug 2019 09:14:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 10/18] xfs: Factor up trans roll from
 xfs_attr3_leaf_setflag
Message-ID: <20190812161452.GY7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-11-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:18PM -0700, Allison Collins wrote:
> New delayed allocation routines cannot be handling
> transactions so factor them up into the calling functions
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 5 +++++
>  fs/xfs/libxfs/xfs_attr_leaf.c | 5 +----
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6bd87e6..7648ceb 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1239,6 +1239,11 @@ xfs_attr_node_removename(
>  		error = xfs_attr3_leaf_setflag(args);
>  		if (error)
>  			goto out;
> +
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			goto out;
> +
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8a6f5df..4a22ced 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2773,10 +2773,7 @@ xfs_attr3_leaf_setflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;
>  }
>  
>  /*
> -- 
> 2.7.4
> 
