Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB841C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44DD2065D
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IvOHOCXo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHRXtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:49:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgHRXtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 19:49:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07INgZDF063265;
        Tue, 18 Aug 2020 23:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2wIMg9D8LPctUwMwyFp3l4CwLYIZ8ARpN7p6NZbxaTM=;
 b=IvOHOCXotFyvapJsgFlyTXpbITjigpuo0DnCKXBqstY9E3pAzyu8TiNtjsvwlKFFX38L
 UmIh86uluDy57nA0myX/rZPPp1+jsqov0PTkWO9jFn1UZXFjCXTTywnHuGtoznpsDtNg
 qgfXr65wMbPiFeEyPSDDt0cDoAJxnpGXqiB2iCSBatO4T+B0FsiKG0Ro/3U66t9x1UiI
 2BQKpadJAQpC1vIva/rziX1liArxs+mueZO+VV4r22Wb3Ktt6hT2Ty3baOpgccTyZNJf
 nENNMSkJ8JWHfut3LFsqmkrA6g7mCEUWl3kKvY7dwnpmn8mFEz4YQCVZvbyU4B4s/GI3 Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r7tuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 23:49:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07INmvbX026014;
        Tue, 18 Aug 2020 23:49:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsmxuahn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 23:49:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07INnCRG000649;
        Tue, 18 Aug 2020 23:49:12 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 16:49:12 -0700
Date:   Tue, 18 Aug 2020 16:49:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: factor the xfs_iunlink functions
Message-ID: <20200818234910.GQ6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-4-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:46PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prep work that separates the locking that protects the unlinked list
> from the actual operations being performed. This also helps document
> the fact they are performing list insert  and remove operations. No
> functional code change.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems pretty straightforward.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 92 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 60 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2072bd25989a..f2f502b65691 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2205,35 +2205,20 @@ xfs_iunlink_update_inode(
>  	return error;
>  }
>  
> -/*
> - * This is called when the inode's link count has gone to 0 or we are creating
> - * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> - *
> - * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> - * list when the inode is freed.
> - */
> -STATIC int
> -xfs_iunlink(
> +static int
> +xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi;
> -	struct xfs_buf		*agibp;
>  	xfs_agino_t		next_agino;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> -	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(VFS_I(ip)->i_mode != 0);
> -	trace_xfs_iunlink(ip);
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> -	if (error)
> -		return error;
>  	agi = agibp->b_addr;
>  
>  	/*
> @@ -2274,6 +2259,35 @@ xfs_iunlink(
>  	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
>  }
>  
> +/*
> + * This is called when the inode's link count has gone to 0 or we are creating
> + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> + *
> + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> + * list when the inode is freed.
> + */
> +STATIC int
> +xfs_iunlink(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*agibp;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	int			error;
> +
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
> +	trace_xfs_iunlink(ip);
> +
> +	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> +	error = xfs_read_agi(mp, tp, agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	return xfs_iunlink_insert_inode(tp, agibp, ip);
> +}
> +
>  /* Return the imap, dinode pointer, and buffer for an inode. */
>  STATIC int
>  xfs_iunlink_map_ino(
> @@ -2388,32 +2402,23 @@ xfs_iunlink_map_prev(
>  	return 0;
>  }
>  
> -/*
> - * Pull the on-disk inode from the AGI unlinked list.
> - */
> -STATIC int
> -xfs_iunlink_remove(
> +static int
> +xfs_iunlink_remove_inode(
>  	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi;
> -	struct xfs_buf		*agibp;
>  	struct xfs_buf		*last_ibp;
>  	struct xfs_dinode	*last_dip = NULL;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		head_agino;
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> -	trace_xfs_iunlink_remove(ip);
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> -	if (error)
> -		return error;
>  	agi = agibp->b_addr;
>  
>  	/*
> @@ -2482,6 +2487,29 @@ xfs_iunlink_remove(
>  			next_agino);
>  }
>  
> +/*
> + * Pull the on-disk inode from the AGI unlinked list.
> + */
> +STATIC int
> +xfs_iunlink_remove(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*agibp;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	int			error;
> +
> +	trace_xfs_iunlink_remove(ip);
> +
> +	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> +	error = xfs_read_agi(mp, tp, agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	return xfs_iunlink_remove_inode(tp, agibp, ip);
> +}
> +
>  /*
>   * Look up the inode number specified and if it is not already marked XFS_ISTALE
>   * mark it stale. We should only find clean inodes in this lookup that aren't
> -- 
> 2.26.2.761.g0e0b3e54be
> 
