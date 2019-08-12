Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50100 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfHLQ2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:28:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGSdAl177018
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0sng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGRwIN131000
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nre2237-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGSiKR017400
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 GMT
Date: Mon, 12 Aug 2019 09:28:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 13/18] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
Message-ID: <20190812162842.GB7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-14-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:21PM -0700, Allison Collins wrote:
> New delayed allocation routines cannot be handling
> transactions so factor them up into the calling functions
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7648ceb..ca57202 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -823,6 +823,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
>  		error = xfs_attr3_leaf_clearflag(args);
> +
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	return error;
>  }
> @@ -1180,6 +1186,12 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			goto out;
> +
> +		 /*
> +		  * Commit the flag value change and start the next trans in
> +		  * series.
> +		  */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	retval = error = 0;

Doesn't this cause us to lose the error code from the roll_inode above?

--D

>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b2d5f62..e3604b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2722,10 +2722,7 @@ xfs_attr3_leaf_clearflag(
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
