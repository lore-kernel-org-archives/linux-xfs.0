Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61040C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B28F207FB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YDjhiiRZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgHSAAJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:00:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgHSAAJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:00:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07INuwao061319;
        Wed, 19 Aug 2020 00:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CRIIfV4MDHdIMuA46uDIOV5pBobPmRTaUMGQGReM7QM=;
 b=YDjhiiRZM18oExzAtLDyzJBqsonVBdy2x1R4gxTAtlDC9wG54kr2qhFnlUaFtgpZPsA3
 YLhYQfpIaFB0gNqHBa309vp5rfFufiwAyqj3JdO1gRwIkYgqBrNkUDsaQc/UOPHKArUE
 gK5Dy6zNsFrEMrNasnSdPd13whZBWhUOUeLtVcQwycNURJfLvQ3BU9QJUVh3xWQXCNNr
 ei45Ny0XZgCUtkbhuBDavfyODpQ2GBml6HhiwxM2U27JkfW7C+mfp4TLlTF8T9qEOXfb
 Wa2Vu75vcAMyGDeaZ7mHtQlf7lFehCKVaKCzueE5kB6SfiGFool3GoqoPbilRGQ/uh8g Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn7r7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:00:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07INwvMM048570;
        Wed, 19 Aug 2020 00:00:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32xsmxug66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:00:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07J003nn027118;
        Wed, 19 Aug 2020 00:00:03 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:00:03 -0700
Date:   Tue, 18 Aug 2020 16:59:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: arrange all unlinked inodes into one list
Message-ID: <20200818235959.GR6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:47PM +1000, Dave Chinner wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> We currently keep unlinked lists short on disk by hashing the inodes
> across multiple buckets. We don't need to ikeep them short anymore
> as we no longer need to traverse the entire to remove an inode from
> it. The in-memory back reference index provides the previous inode
> in the list for us instead.
> 
> Log recovery still has to handle existing filesystems that use all
> 64 on-disk buckets so we detect and handle this case specially so
> that so inode eviction can still work properly in recovery.
> 
> [dchinner: imported into parent patch series early on and modified
> to fit cleanly. ]
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 49 +++++++++++++++++++++++++++-------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f2f502b65691..fa92bdf6e0da 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -33,6 +33,7 @@
>  #include "xfs_symlink.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
>  
> @@ -2092,25 +2093,32 @@ xfs_iunlink_update_bucket(
>  	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	struct xfs_buf		*agibp,
> -	unsigned int		bucket_index,
> +	xfs_agino_t		old_agino,
>  	xfs_agino_t		new_agino)
>  {
> +	struct xlog		*log = tp->t_mountp->m_log;
>  	struct xfs_agi		*agi = agibp->b_addr;
>  	xfs_agino_t		old_value;
> -	int			offset;
> +	unsigned int		bucket_index;
> +	int                     offset;
>  
>  	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
>  
> +	bucket_index = 0;
> +	/* During recovery, the old multiple bucket index can be applied */
> +	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {

Does the flag test need parentheses?

It feels a little funny that we pass in old_agino (having gotten it from
agi_unlinked) and then compare it with agi_unlinked, but as the commit
log points out, I guess this is a wart of having to support the old
unlinked list behavior.  It makes sense to me that if we're going to
change the unlinked list behavior we could be a little more careful
about double-checking things.

Question: if a newer kernel crashes with a super-long unlinked list and
the fs gets recovered on an old kernel, will this lead to insanely high
recovery times?  I think the answer is no, because recovery is single
threaded and the hash only existed to reduce AGI contention during
normal unlinking operations?

--D

> +		ASSERT(old_agino != NULLAGINO);
> +
> +		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
> +			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
> +	}
> +
>  	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
>  	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
>  			old_value, new_agino);
>  
> -	/*
> -	 * We should never find the head of the list already set to the value
> -	 * passed in because either we're adding or removing ourselves from the
> -	 * head of the list.
> -	 */
> -	if (old_value == new_agino) {
> +	/* check if the old agi_unlinked head is as expected */
> +	if (old_value != old_agino) {
>  		xfs_buf_mark_corrupt(agibp);
>  		return -EFSCORRUPTED;
>  	}
> @@ -2216,17 +2224,18 @@ xfs_iunlink_insert_inode(
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
>  	agi = agibp->b_addr;
>  
>  	/*
> -	 * Get the index into the agi hash table for the list this inode will
> -	 * go on.  Make sure the pointer isn't garbage and that this inode
> -	 * isn't already on the list.
> +	 * We don't need to traverse the on disk unlinked list to find the
> +	 * previous inode in the list when removing inodes anymore, so we don't
> +	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
> +	 * Make sure the pointer isn't garbage and that this inode isn't already
> +	 * on the list.
>  	 */
> -	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
>  	if (next_agino == agino ||
>  	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
>  		xfs_buf_mark_corrupt(agibp);
> @@ -2256,7 +2265,7 @@ xfs_iunlink_insert_inode(
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> -	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
> +	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
>  }
>  
>  /*
> @@ -2416,16 +2425,17 @@ xfs_iunlink_remove_inode(
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		head_agino;
> -	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
>  	agi = agibp->b_addr;
>  
>  	/*
> -	 * Get the index into the agi hash table for the list this inode will
> -	 * go on.  Make sure the head pointer isn't garbage.
> +	 * We don't need to traverse the on disk unlinked list to find the
> +	 * previous inode in the list when removing inodes anymore, so we don't
> +	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
> +	 * Make sure the head pointer isn't garbage.
>  	 */
> -	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	head_agino = be32_to_cpu(agi->agi_unlinked[0]);
>  	if (!xfs_verify_agino(mp, agno, head_agino)) {
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  				agi, sizeof(*agi));
> @@ -2483,8 +2493,7 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	/* Point the head of the list to the next unlinked inode. */
> -	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> -			next_agino);
> +	return xfs_iunlink_update_bucket(tp, agno, agibp, agino, next_agino);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 
