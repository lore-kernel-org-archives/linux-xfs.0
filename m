Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A798FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 761FE207BB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T89paX/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHSAb4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:31:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgHSAbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:31:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0N4pw104018;
        Wed, 19 Aug 2020 00:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sTBTGSjDElM6VXF8qbV4aNuds0hvHo+4ic2k10iCxBY=;
 b=T89paX/NhAcNzc5Va63mjJwcso9SSsZicfLzad9T9cN2Pk6iSI+pKX5o1QzE5EwlSLWb
 VWMGeXCNmuU5GwoLHEYUK8wA5G0PZYGo67W8zNm0xRVEthzLaYQJosMQ7T0xr0iHLKWw
 f0fRG/gRo/jovaKFE5xLd3tRZ42fgvgx8GGrOgMJuh0qgTng9slTD9ktXscPqgMd7Woq
 7Zp2Kmafd7wdS6uAikKcvRw6gVuWDzTjZASjUsDiUGOQNSPYQ+O2OSh9iHRL5dOTRqix
 StMxe/a1aqJ4tzQHokJOltObpD7U1ddKaHf0OjOk44msKnyJKftOW2WcU3k0DHZhVF3p CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn7tje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:31:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0SFat148782;
        Wed, 19 Aug 2020 00:29:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32xs9nj3fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:29:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07J0ToSM006529;
        Wed, 19 Aug 2020 00:29:50 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:29:50 -0700
Date:   Tue, 18 Aug 2020 17:29:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: re-order AGI updates in unlink list updates
Message-ID: <20200819002948.GX6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-11-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190002
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

On Wed, Aug 12, 2020 at 07:25:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We always access and check the AGI bucket entry for the unlinked
> list even if we are not going to need it either for lookup or remove
> purposes. Move the code that accesses the AGI to the code that
> modifes the AGI, hence keeping the AGI accesses local to the code
> that needs to modify it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 84 ++++++++++++++++------------------------------
>  1 file changed, 28 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b098e5df07e7..4f616e1b64dc 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1918,44 +1918,53 @@ xfs_inactive(
>   */
>  
>  /*
> - * Point the AGI unlinked bucket at an inode and log the results.  The caller
> - * is responsible for validating the old value.
> + * Point the AGI unlinked bucket at an inode and log the results. The caller
> + * passes in the expected current agino the bucket points at via @cur_agino so
> + * we can validate that we are about to remove the inode we expect to be
> + * removing from the AGI bucket.
>   */
> -STATIC int
> +static int
>  xfs_iunlink_update_bucket(
>  	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	struct xfs_buf		*agibp,
> -	xfs_agino_t		old_agino,
> +	xfs_agino_t		cur_agino,

Hm.  So I think I understand the new role of this function better now
that this patch moves into this function the checking of the bucket
pointer and whatnot.  Would it be difficult to merge this patch with
patch 4?

--D

>  	xfs_agino_t		new_agino)
>  {
> -	struct xlog		*log = tp->t_mountp->m_log;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xlog		*log = mp->m_log;
>  	struct xfs_agi		*agi = agibp->b_addr;
> -	xfs_agino_t		old_value;
> +	xfs_agino_t		old_agino;
>  	unsigned int		bucket_index;
>  	int                     offset;
>  
> -	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
> +	ASSERT(xfs_verify_agino_or_null(mp, agno, new_agino));
>  
> +	/*
> +	 * We don't need to traverse the on disk unlinked list to find the
> +	 * previous inode in the list when removing inodes anymore, so we don't
> +	 * use multiple on-disk lists anymore. Hence we always use bucket 0
> +	 * unless we are in log recovery in which case we might be recovering an
> +	 * old filesystem that has multiple buckets.
> +	 */
>  	bucket_index = 0;
> -	/* During recovery, the old multiple bucket index can be applied */
>  	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
> -		ASSERT(old_agino != NULLAGINO);
> +		ASSERT(cur_agino != NULLAGINO);
>  
> -		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
> -			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
> +		if (be32_to_cpu(agi->agi_unlinked[0]) != cur_agino)
> +			bucket_index = cur_agino % XFS_AGI_UNLINKED_BUCKETS;
>  	}
>  
> -	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> -	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
> -			old_value, new_agino);
> -
> -	/* check if the old agi_unlinked head is as expected */
> -	if (old_value != old_agino) {
> +	old_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	if (new_agino == old_agino || cur_agino != old_agino ||
> +	    !xfs_verify_agino_or_null(mp, agno, old_agino)) {
>  		xfs_buf_mark_corrupt(agibp);
>  		return -EFSCORRUPTED;
>  	}
>  
> +	trace_xfs_iunlink_update_bucket(mp, agno, bucket_index,
> +			old_agino, new_agino);
> +
>  	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
>  	offset = offsetof(struct xfs_agi, agi_unlinked) +
>  			(sizeof(xfs_agino_t) * bucket_index);
> @@ -2032,44 +2041,25 @@ xfs_iunlink_insert_inode(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi;
>  	struct xfs_inode	*nip;
> -	xfs_agino_t		next_agino;
> +	xfs_agino_t		next_agino = NULLAGINO;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	int			error;
>  
> -	agi = agibp->b_addr;
> -
> -	/*
> -	 * We don't need to traverse the on disk unlinked list to find the
> -	 * previous inode in the list when removing inodes anymore, so we don't
> -	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
> -	 * Make sure the pointer isn't garbage and that this inode isn't already
> -	 * on the list.
> -	 */
> -	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
> -	if (next_agino == agino ||
> -	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> -		xfs_buf_mark_corrupt(agibp);
> -		return -EFSCORRUPTED;
> -	}
> -
>  	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink);
>  	if (nip) {
> -		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
>  
>  		/*
>  		 * There is already another inode in the bucket, so point this
>  		 * inode to the current head of the list.
>  		 */
> +		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
>  		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
>  						 next_agino);
>  		if (error)
>  			return error;
> -	} else {
> -		ASSERT(next_agino == NULLAGINO);
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> @@ -2122,28 +2112,11 @@ xfs_iunlink_remove_inode(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino = NULLAGINO;
> -	xfs_agino_t		head_agino;
>  	int			error;
>  
> -	agi = agibp->b_addr;
> -
> -	/*
> -	 * We don't need to traverse the on disk unlinked list to find the
> -	 * previous inode in the list when removing inodes anymore, so we don't
> -	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
> -	 * Make sure the head pointer isn't garbage.
> -	 */
> -	head_agino = be32_to_cpu(agi->agi_unlinked[0]);
> -	if (!xfs_verify_agino(mp, agno, head_agino)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -				agi, sizeof(*agi));
> -		return -EFSCORRUPTED;
> -	}
> -
>  	/*
>  	 * Get the next agino in the list. If we are at the end of the list,
>  	 * then the previous inode's i_next_unlinked filed will get cleared.
> @@ -2165,7 +2138,6 @@ xfs_iunlink_remove_inode(
>  					struct xfs_inode, i_unlink)) {
>  		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
>  
> -		ASSERT(head_agino != agino);
>  		return xfs_iunlink_update_inode(tp, pip, agno, agino,
>  						next_agino);
>  	}
> -- 
> 2.26.2.761.g0e0b3e54be
> 
