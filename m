Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A68AC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5822B20772
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FRoALDAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgHSAqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:46:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHSAqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:46:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0gGeA067057;
        Wed, 19 Aug 2020 00:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7LAbUIJShtyuWOaEz8BUU6N0T5CdTsFxeeQgF5EwTNg=;
 b=FRoALDAgmKXMCZS/hP3eWM5mIdQsIW4uEOkPJqjc/F5usmlidLX66LEUmPU8GHJxMzHA
 /iQQmL8kn6ci5CK99iX9v8M6vNnFeKRbRAa7uB/6ZHhy9FV1jrYduTkmiuv3fXkmsDZc
 AyxdQi1A5vTckdvt6UVieqCebwFNMbyqwo9agp2DkFCWX3n/4PQEFMl1HrZKEK7jITkr
 9+jWACSrlKZMbu7i/Jup+1JVMIRC2ilkMabx+XwK0OkMZkezfp1yBe8cwY2aEyGlcwGs
 lhcQec9BgxVx5QNW6XhLM9/weyKBNRC3M1hzXA9rZB4y7k25xXvay9Sk1PrG6ix4IsSp Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32x7nmfx01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:46:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0iFug184343;
        Wed, 19 Aug 2020 00:46:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32xs9njd7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:46:00 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0k0qT004153;
        Wed, 19 Aug 2020 00:46:00 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:45:59 -0700
Date:   Tue, 18 Aug 2020 17:45:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reorder iunlink remove operation in xfs_ifree
Message-ID: <20200819004558.GM6107@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-14-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=5 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The O_TMPFILE creation implementation creates a specific order of
> operations for inode allocation/freeing and unlinked list
> modification. Currently both are serialised by the AGI, so the order
> doesn't strictly matter as long as the are both in the same
> transaction.
> 
> However, if we want to move the unlinked list insertions largely
> out from under the AGI lock, then we have to be concerned about the
> order in which we do unlinked list modification operations.
> O_TMPFILE creation tells us this order is inode allocation/free,
> then unlinked list modification.
> 
> Change xfs_ifree() to use this same ordering on unlinked list
> removal. THis way we always guarantee that when we enter the

"This"...

> iunlinked list removal code from this path, we have the already

"have the already locked" ... what do we have locked?  The AGI?

> locked and we don't have to worry about lock nesting AGI reads
> inside unlink list locks because it's already locked and attached to
> the transaction.
> 
> We can do this safely as the inode freeing and unlinked list removal
> are done in the same transaction and hence are atomic operations
> with resepect to log recovery.

"respect"...

With the commit log edited a bit,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ce128ff12762..7ee778bcde06 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2283,14 +2283,13 @@ xfs_ifree_cluster(
>  }
>  
>  /*
> - * This is called to return an inode to the inode free list.
> - * The inode should already be truncated to 0 length and have
> - * no pages associated with it.  This routine also assumes that
> - * the inode is already a part of the transaction.
> + * This is called to return an inode to the inode free list.  The inode should
> + * already be truncated to 0 length and have no pages associated with it.  This
> + * routine also assumes that the inode is already a part of the transaction.
>   *
> - * The on-disk copy of the inode will have been added to the list
> - * of unlinked inodes in the AGI. We need to remove the inode from
> - * that list atomically with respect to freeing it here.
> + * The on-disk copy of the inode will have been added to the list of unlinked
> + * inodes in the AGI. We need to remove the inode from that list atomically with
> + * respect to freeing it here.
>   */
>  int
>  xfs_ifree(
> @@ -2308,13 +2307,16 @@ xfs_ifree(
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	/*
> -	 * Pull the on-disk inode from the AGI unlinked list.
> +	 * Free the inode first so that we guarantee that the AGI lock is going
> +	 * to be taken before we remove the inode from the unlinked list. This
> +	 * makes the AGI lock -> unlinked list modification order the same as
> +	 * used in O_TMPFILE creation.
>  	 */
> -	error = xfs_iunlink_remove(tp, ip);
> +	error = xfs_difree(tp, ip->i_ino, &xic);
>  	if (error)
>  		return error;
>  
> -	error = xfs_difree(tp, ip->i_ino, &xic);
> +	error = xfs_iunlink_remove(tp, ip);
>  	if (error)
>  		return error;
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 
