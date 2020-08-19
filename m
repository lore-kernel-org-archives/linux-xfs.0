Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598D5C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D6B20738
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="spFMZ6Uy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgHSARA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:17:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSAQ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:16:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0CGHd109417;
        Wed, 19 Aug 2020 00:16:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eDJY45w4S6Q6Ca9QNE3/ZK2j012uXWvbnCspIpZKo3A=;
 b=spFMZ6UyvNj+0zVAAA+oSXYWeR7Jv8JT9D0qAp2Z6B8YZ0ZT/5+awNbN6p/B1lJZLUD2
 WAtIm2MYlWh6DZaqCk1TkLBh5qWLWYVD2kKcG6aioupAPCuUubJPJ4rUwxXUDkT+UqGV
 JyZ0S4b8v8GahrORJarEpq5nn3J9TYU/9aF2SN46RShFDkMzylw2WEamu2BcZh6aAHbg
 drDSEKGvqSsAtK1ptMppi8DIsuxmUov+4/rJnY0LB9msl+JzEWe3O6hY0mBQz8Yw5hyl
 HNiM0RPYZYx2Ahjn6EpFjvk6QvpAwzou8xARDrKMeL1bsS+mrm7dOFyu6rYyIQXnZfv9 Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r7w6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:16:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J08Gm7103911;
        Wed, 19 Aug 2020 00:14:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9nhutw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:14:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0Etet003768;
        Wed, 19 Aug 2020 00:14:55 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:14:54 -0700
Date:   Tue, 18 Aug 2020 17:14:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: mapping unlinked inodes is now redundant
Message-ID: <20200819001452.GU6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-8-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We now have a direct pointer to the xfs_inodes in the unlinked
> lists, so we can use the imap built into the inode to read the
> underlying cluster buffer. Hence we can remove all the "lookup by
> agino" code that currently exists in the iunlink list processing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks pretty simple,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 88 ++++++----------------------------------------
>  1 file changed, 10 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2c930de99561..bacd5ae9f5a7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2139,74 +2139,6 @@ xfs_iunlink(
>  	return error;
>  }
>  
> -/* Return the imap, dinode pointer, and buffer for an inode. */
> -STATIC int
> -xfs_iunlink_map_ino(
> -	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	int			error;
> -
> -	imap->im_blkno = 0;
> -	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
> -	if (error) {
> -		xfs_warn(mp, "%s: xfs_imap returned error %d.",
> -				__func__, error);
> -		return error;
> -	}
> -
> -	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
> -	if (error) {
> -		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> -				__func__, error);
> -		return error;
> -	}
> -
> -	return 0;
> -}
> -
> -/*
> - * Walk the unlinked chain from @head_agino until we find the inode that
> - * points to @target_agino.  Return the inode number, map, dinode pointer,
> - * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
> - *
> - * @tp, @pag, @head_agino, and @target_agino are input parameters.
> - * @agino, @imap, @dipp, and @bpp are all output parameters.
> - *
> - * Do not call this function if @target_agino is the head of the list.
> - */
> -STATIC int
> -xfs_iunlink_map_prev(
> -	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		head_agino,
> -	xfs_agino_t		target_agino,
> -	xfs_agino_t		agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp,
> -	struct xfs_perag	*pag)
> -{
> -	int			error;
> -
> -	ASSERT(head_agino != target_agino);
> -	*bpp = NULL;
> -
> -	ASSERT(agino != NULLAGINO);
> -	error = xfs_iunlink_map_ino(tp, agno, agino, imap, dipp, bpp);
> -	if (error)
> -		return error;
> -
> -	if (be32_to_cpu((*dipp)->di_next_unlinked) != target_agino)
> -		return -EFSCORRUPTED;
> -	return 0;
> -}
> -
>  static int
>  xfs_iunlink_remove_inode(
>  	struct xfs_trans	*tp,
> @@ -2215,8 +2147,6 @@ xfs_iunlink_remove_inode(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi;
> -	struct xfs_buf		*last_ibp;
> -	struct xfs_dinode	*last_dip = NULL;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
> @@ -2260,25 +2190,27 @@ xfs_iunlink_remove_inode(
>  	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink)) {
>  
> -		struct xfs_inode *pip;
> -		struct xfs_imap	imap;
> -		xfs_agino_t	prev_agino;
> +		struct xfs_inode	*pip;
> +		xfs_agino_t		prev_agino;
> +		struct xfs_buf		*last_ibp;
> +		struct xfs_dinode	*last_dip = NULL;
>  
>  		ASSERT(head_agino != agino);
>  
>  		pip = list_prev_entry(ip, i_unlink);
>  		prev_agino = XFS_INO_TO_AGINO(mp, pip->i_ino);
>  
> -		/* We need to search the list for the inode being freed. */
> -		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
> -				prev_agino, &imap, &last_dip, &last_ibp,
> -				agibp->b_pag);
> +		error = xfs_imap_to_bp(mp, tp, &pip->i_imap, &last_dip, 
> +						&last_ibp, 0);
>  		if (error)
>  			return error;
>  
> +		if (be32_to_cpu(last_dip->di_next_unlinked) != agino)
> +			return -EFSCORRUPTED;
> +
>  		/* Point the previous inode on the list to the next inode. */
>  		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
> -				last_dip, &imap, next_agino);
> +				last_dip, &pip->i_imap, next_agino);
>  
>  		return 0;
>  	}
> -- 
> 2.26.2.761.g0e0b3e54be
> 
