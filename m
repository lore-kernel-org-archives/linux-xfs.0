Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB25C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D639B20738
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kcCPDGTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHSAVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:21:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSAVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:21:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0HVhj100256;
        Wed, 19 Aug 2020 00:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Kv2c1p5Q6yvZU61wMaqwzBwsq3qGk81V+P8yu2RUiHA=;
 b=kcCPDGTvgJOt4Lt7mL4cUDMffrjHLQzhenmShzGhKN+LW+0P/YMZo0Io3fOuWeyBMeUq
 M+VzgYnSBQVrf7kA81w24ZyfyZeUHjfOGotTWDTw7sUMjeMj77FN5QPcNPuLM48AVt2n
 KZf/RYnXDZxxyYsWE3ecVH7SEfO+Ipeo3UjMYb4gNCYd/rLmFv04JwtTOwq1wXjF6a4a
 VunCIKaas1UEP3wNE0axM3goGO22GxaSpsro2voqNrkPp22m16wG+2QLAdW8rmfsVG0P
 ySLOuI2uY2KuKosVClvxrMj2kzoqiq6KOFXtGicOPnbxRo/JqSPC+upLAGbEbBStM/0d kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn7swc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:21:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0IGGU095132;
        Wed, 19 Aug 2020 00:19:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfsgjxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:19:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0JVnG017825;
        Wed, 19 Aug 2020 00:19:31 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:19:30 -0700
Date:   Tue, 18 Aug 2020 17:19:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs: updating i_next_unlinked doesn't need to
 return old value
Message-ID: <20200819001928.GV6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-9-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We already know what the next inode in the unlinked list is supposed
> to be from the in-memory list, so we do not need to look it up first
> from the current inode to be able to update in memory list
> pointers...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 63 +++++++++++-----------------------------------
>  1 file changed, 14 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bacd5ae9f5a7..4dde1970f7cd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1998,13 +1998,11 @@ xfs_iunlink_update_inode(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_agnumber_t		agno,
> -	xfs_agino_t		next_agino,
> -	xfs_agino_t		*old_next_agino)
> +	xfs_agino_t		next_agino)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_dinode	*dip;
>  	struct xfs_buf		*ibp;
> -	xfs_agino_t		old_value;
>  	int			error;
>  
>  	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> @@ -2013,37 +2011,10 @@ xfs_iunlink_update_inode(
>  	if (error)
>  		return error;
>  
> -	/* Make sure the old pointer isn't garbage. */
> -	old_value = be32_to_cpu(dip->di_next_unlinked);
> -	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		error = -EFSCORRUPTED;
> -		goto out;
> -	}
> -
> -	/*
> -	 * Since we're updating a linked list, we should never find that the
> -	 * current pointer is the same as the new value, unless we're
> -	 * terminating the list.
> -	 */
> -	*old_next_agino = old_value;
> -	if (old_value == next_agino) {
> -		if (next_agino != NULLAGINO) {
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -					dip, sizeof(*dip), __this_address);
> -			error = -EFSCORRUPTED;
> -		}
> -		goto out;
> -	}
> -
>  	/* Ok, update the new pointer. */
>  	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
>  			ibp, dip, &ip->i_imap, next_agino);
>  	return 0;
> -out:
> -	xfs_trans_brelse(tp, ibp);
> -	return error;
>  }
>  
>  static int
> @@ -2079,19 +2050,15 @@ xfs_iunlink_insert_inode(
>  	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink);
>  	if (nip) {
> -		xfs_agino_t		old_agino;
> -
>  		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
>  
>  		/*
>  		 * There is already another inode in the bucket, so point this
>  		 * inode to the current head of the list.
>  		 */
> -		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino,
> -				&old_agino);
> +		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino);
>  		if (error)
>  			return error;
> -		ASSERT(old_agino == NULLAGINO);
>  	} else {
>  		ASSERT(next_agino == NULLAGINO);
>  	}
> @@ -2149,7 +2116,7 @@ xfs_iunlink_remove_inode(
>  	struct xfs_agi		*agi;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	xfs_agino_t		next_agino;
> +	xfs_agino_t		next_agino = NULLAGINO;
>  	xfs_agino_t		head_agino;
>  	int			error;
>  
> @@ -2169,23 +2136,21 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	/*
> -	 * Set our inode's next_unlinked pointer to NULL and then return
> -	 * the old pointer value so that we can update whatever was previous
> -	 * to us in the list to point to whatever was next in the list.
> +	 * Get the next agino in the list. If we are at the end of the list,
> +	 * then the previous inode's i_next_unlinked filed will get cleared.

                                                    "field"

With that fixed,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	 */
> -	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
> +	if (ip != list_last_entry(&agibp->b_pag->pag_ici_unlink_list,
> +					struct xfs_inode, i_unlink)) {
> +		struct xfs_inode *nip = list_next_entry(ip, i_unlink);
> +
> +		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
> +	}
> +
> +	/* Clear the on disk next unlinked pointer for this inode. */
> +	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO);
>  	if (error)
>  		return error;
>  
> -#ifdef DEBUG
> -	{
> -	struct xfs_inode *nip = list_next_entry(ip, i_unlink);
> -	if (nip)
> -		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
> -	else
> -		ASSERT(next_agino == NULLAGINO);
> -	}
> -#endif
>  
>  	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink)) {
> -- 
> 2.26.2.761.g0e0b3e54be
> 
