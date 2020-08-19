Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFA8C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 138AF20772
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:23:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q178lvJA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgHSAXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:23:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSAXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:23:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0NZ4P104135;
        Wed, 19 Aug 2020 00:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qNNZcR6C7GZTHRY4aW3rwUYuZbpQhM8RoSOhC0R9vQk=;
 b=q178lvJA0Oh7c93YX673j5/smIELeVAi4jpJIGrg5q2asgDr9uHp9BaZb70hytqDX8Il
 W8RSFmH23dgf7PSWnJ032nipeR/h3qTARqc1WiBgVp4xuINAScRvZdYjvnucDhI8XyqB
 Zm/4ot/dAg3x0xuYJPFgiL1HuRXZbqJW8x2MOZEw+9P9U6lHoVEU713irkW9kBjrSn3X
 +QWHn5i1hVQkMylEs4veO7QwTLoiOBzme/YHgl53Pow+0Ekp+BByO2RpsSBgopYXLo0Z
 3AmUofMKTIpDVvhL+Snojhvr7yxgNHcOYZy/GH+sxJHcRgmXAcjGuFNLQrgE2kVMD0Zx vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn7t1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:23:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0HlrI133105;
        Wed, 19 Aug 2020 00:23:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 330pvhsy52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:23:34 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0NYfB019916;
        Wed, 19 Aug 2020 00:23:34 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:23:34 -0700
Date:   Tue, 18 Aug 2020 17:23:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: validate the unlinked list pointer on update
Message-ID: <20200819002332.GW6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-10-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Factor this check into xfs_iunlink_update_inode() when are updating
> the code. This replaces the checks that were removed in previous
> patches as bits of functionality were removed from the update
> process.

I had wondered about that, though I saw it end up in xfs_iunlink_item.c
so I hadn't thought too much about that.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 38 ++++++++++++++------------------------
>  1 file changed, 14 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4dde1970f7cd..b098e5df07e7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1998,6 +1998,7 @@ xfs_iunlink_update_inode(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_agnumber_t		agno,
> +	xfs_agino_t		old_agino,
>  	xfs_agino_t		next_agino)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> @@ -2011,6 +2012,13 @@ xfs_iunlink_update_inode(
>  	if (error)
>  		return error;
>  
> +	if (be32_to_cpu(dip->di_next_unlinked) != old_agino) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +					sizeof(*dip), __this_address);
> +		xfs_trans_brelse(tp, ibp);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/* Ok, update the new pointer. */
>  	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
>  			ibp, dip, &ip->i_imap, next_agino);
> @@ -2056,7 +2064,8 @@ xfs_iunlink_insert_inode(
>  		 * There is already another inode in the bucket, so point this
>  		 * inode to the current head of the list.
>  		 */
> -		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino);
> +		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
> +						 next_agino);
>  		if (error)
>  			return error;
>  	} else {
> @@ -2147,37 +2156,18 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	/* Clear the on disk next unlinked pointer for this inode. */
> -	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO);
> +	error = xfs_iunlink_update_inode(tp, ip, agno, next_agino, NULLAGINO);
>  	if (error)
>  		return error;
>  
>  
>  	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink)) {
> -
> -		struct xfs_inode	*pip;
> -		xfs_agino_t		prev_agino;
> -		struct xfs_buf		*last_ibp;
> -		struct xfs_dinode	*last_dip = NULL;
> +		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
>  
>  		ASSERT(head_agino != agino);
> -
> -		pip = list_prev_entry(ip, i_unlink);
> -		prev_agino = XFS_INO_TO_AGINO(mp, pip->i_ino);
> -
> -		error = xfs_imap_to_bp(mp, tp, &pip->i_imap, &last_dip, 
> -						&last_ibp, 0);
> -		if (error)
> -			return error;
> -
> -		if (be32_to_cpu(last_dip->di_next_unlinked) != agino)
> -			return -EFSCORRUPTED;
> -
> -		/* Point the previous inode on the list to the next inode. */
> -		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
> -				last_dip, &pip->i_imap, next_agino);
> -
> -		return 0;
> +		return xfs_iunlink_update_inode(tp, pip, agno, agino,
> +						next_agino);
>  	}
>  
>  	/* Point the head of the list to the next unlinked inode. */
> -- 
> 2.26.2.761.g0e0b3e54be
> 
