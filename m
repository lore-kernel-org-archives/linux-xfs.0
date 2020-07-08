Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389E5C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 22:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1913820772
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 22:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgGHWdc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 18:33:32 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:54332 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgGHWdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 18:33:32 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 4F40ED5A629;
        Thu,  9 Jul 2020 08:33:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtId4-0000si-RL; Thu, 09 Jul 2020 08:33:26 +1000
Date:   Thu, 9 Jul 2020 08:33:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 1/2] xfs: arrange all unlinked inodes into one list
Message-ID: <20200708223326.GO2005@dread.disaster.area>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707135741.487-2-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Nq5i_PvIb6j-hZL2PpsA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 09:57:40PM +0800, Gao Xiang wrote:
> There is no need to keep old multiple short unlink inode buckets
> since we have an in-memory double linked list for all unlinked
> inodes.
> 
> Apart from the perspective of the necessity, the main advantage
> is that the log and AGI update can be reduced since each AG has
> the only one head now, which is implemented in the following patch.
> 
> Therefore, this patch applies the new way in xfs_iunlink() and
> keep the old approach in xfs_iunlink_remove_inode() path as well
> so inode eviction can still work properly in recovery.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ab288424764c..10565fa5ace4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -33,6 +33,7 @@
>  #include "xfs_symlink.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
>  #include "xfs_iunlink_item.h"
> @@ -1955,25 +1956,32 @@ xfs_iunlink_update_bucket(
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
> +		ASSERT(old_agino != NULLAGINO);
> +
> +		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
> +			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
> +	}

Ok, so you are doing this because you changed the function to pass
in an agino rather than a bucket index from the caller context. So
now you have to look up a structure to determine what the caller
context was to determine what the bucket index we need to use is.

Seems like we probably should have kept passing in the bucket index
from the caller because that's where the knowledge of what bucket we
need to update comes from?

And in that case, the higher level code should be checking for the
log recovery case when selecting the bucket, not hiding it deep in
the guts of the code here....

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

This looks like a change of behaviour - it no longer checks against
the inode we are about to add/remove from the list, but instead
checks that old inode is what we found on the list. We're not
concerned that what we found on the list matches what the caller
found on the list and passed us - we're concerned about doing a
double add/remove of the current inode...

> @@ -2001,14 +2009,13 @@ xfs_iunlink_insert_inode(
>  	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
> -	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
>  	 * go on.  Make sure the pointer isn't garbage and that this inode
>  	 * isn't already on the list.
>  	 */
> -	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
>  	if (next_agino == agino ||
>  	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
>  		xfs_buf_mark_corrupt(agibp);
> @@ -2036,7 +2043,7 @@ xfs_iunlink_insert_inode(
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> -	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
> +	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
>  }
>  
>  /*
> @@ -2051,27 +2058,20 @@ xfs_iunlink_remove_inode(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi = agibp->b_addr;
>  	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino = ip->i_next_unlinked;
> -	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
>  	if (ip->i_prev_unlinked == NULLAGINO) {
>  		/* remove from head of list */
> -		if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino) {
> -			xfs_buf_mark_corrupt(agibp);
> -			return -EFSCORRUPTED;
> -		}
>  		if (next_agino == agino ||
>  		    !xfs_verify_agino_or_null(mp, agno, next_agino))
>  			return -EFSCORRUPTED;
>  
> -		error = xfs_iunlink_update_bucket(tp, agno, agibp,
> -					bucket_index, next_agino);
> +		error = xfs_iunlink_update_bucket(tp, agno, agibp, agino, next_agino);
>  		if (error)
> -			return -EFSCORRUPTED;
> +			return error;

i.e. this is the point where we know we need to remove from the head
of the unlinked list and all the bucket selection and verification
should probably remain here...

-- 
Dave Chinner
david@fromorbit.com
