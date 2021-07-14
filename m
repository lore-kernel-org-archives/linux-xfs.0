Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0377FC07E95
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 00:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA25861361
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 00:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbhGNAee (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 20:34:34 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:41112 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237112AbhGNAee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 20:34:34 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 9A5656B1C6;
        Wed, 14 Jul 2021 10:31:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3So9-006FeM-QS; Wed, 14 Jul 2021 10:31:25 +1000
Date:   Wed, 14 Jul 2021 10:31:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: keep the active perag reference between finish_one
 calls
Message-ID: <20210714003125.GS664593@dread.disaster.area>
References: <20210714000008.GC22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714000008.GC22402@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=gPslhvMjViDbV4-zEFkA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 13, 2021 at 05:00:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The refcount and rmap finish_one functions stash a btree cursor when
> there are multiple ->finish_one calls to be made in a single
> transaction.  This mechanism is how we maintain the AGF lock between
> operations of a single intent item.  Since ag btree cursors now need
> active references to perag structures, we must preserve the perag
> reference when we save the cursor.

Hmmm. The cursor already carries it's own internal reference. So
this:

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   33 ++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_rmap.c     |    8 +++++++-
>  2 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 860a0c9801ba..cfd98958d38c 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1113,13 +1113,16 @@ xfs_refcount_finish_one_cleanup(
>  	int			error)
>  {
>  	struct xfs_buf		*agbp;
> +	struct xfs_perag	*pag;
>  
>  	if (rcur == NULL)
>  		return;
>  	agbp = rcur->bc_ag.agbp;
> +	pag = rcur->bc_ag.pag;
>  	xfs_btree_del_cursor(rcur, error);
>  	if (error)
>  		xfs_trans_brelse(tp, agbp);
> +	xfs_perag_put(pag);

... is just duplicating the reference the cursor already carries and
drops inside xfs_btree_del_cursor().

What problem is this actually fixing?

>  }
>  
>  /*
> @@ -1142,19 +1145,20 @@ xfs_refcount_finish_one(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_btree_cur		*rcur;
>  	struct xfs_buf			*agbp = NULL;
> -	int				error = 0;
> +	struct xfs_perag		*pag;
> +	unsigned long			nr_ops = 0;
> +	xfs_agnumber_t			agno;
>  	xfs_agblock_t			bno;
>  	xfs_agblock_t			new_agbno;
> -	unsigned long			nr_ops = 0;
>  	int				shape_changes = 0;
> -	struct xfs_perag		*pag;
> +	int				error = 0;
>  
> -	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
> +	agno = XFS_FSB_TO_AGNO(mp, startblock);
> +	pag = xfs_perag_get(mp, agno);
>  	bno = XFS_FSB_TO_AGBNO(mp, startblock);
>  
> -	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, startblock),
> -			type, XFS_FSB_TO_AGBNO(mp, startblock),
> -			blockcount);
> +	trace_xfs_refcount_deferred(mp, agno, type,
> +			 XFS_FSB_TO_AGBNO(mp, startblock), blockcount);
>  
>  	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE)) {
>  		error = -EIO;
> @@ -1174,14 +1178,16 @@ xfs_refcount_finish_one(
>  		*pcur = NULL;
>  	}
>  	if (rcur == NULL) {
> -		error = xfs_alloc_read_agf(tp->t_mountp, tp, pag->pag_agno,
> +		error = xfs_alloc_read_agf(mp, tp, agno,
>  				XFS_ALLOC_FLAG_FREEING, &agbp);

Please don't revert these back to using a local variable. The next
step in cleaning up all these agf/agi read functions is to pass the
perag into them rather than the mount/agno pair....

>  		if (error)
>  			goto out_drop;
>  
> +		/* The cursor now owns the AGF buf and perag ref */
>  		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
>  		rcur->bc_ag.refc.nr_ops = nr_ops;
>  		rcur->bc_ag.refc.shape_changes = shape_changes;
> +		pag = NULL;

The cursor takes it's own reference inside
xfs_refcountbt_init_cursor() that covers the perag for the life of
the cursor. THe local get/put covers the perag for this function,
and guarantees that the init_cursor() function can get it's own
reference without blocking because the perag already has active
references.

Also, the cursor doesn't actually own the agbp at all. The active
reference to the agbp is actually carried by the transaction, not
the cursor, and if it is dirty when xfs_trans_brelse() is called,
then transaction reference is not dropped until
xfs_trans_commit()...

Hence I think you're conflating "reference counted object"
with "cursor contains an object pointer" here, and as such the
statements about both objects are incorrect for different reasons...

>  	}
>  	*pcur = rcur;
>  
> @@ -1189,12 +1195,12 @@ xfs_refcount_finish_one(
>  	case XFS_REFCOUNT_INCREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
>  			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
> -		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
> +		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_DECREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
>  			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
> -		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
> +		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_ALLOC_COW:
>  		*new_fsb = startblock + blockcount;
> @@ -1211,10 +1217,11 @@ xfs_refcount_finish_one(
>  		error = -EFSCORRUPTED;
>  	}
>  	if (!error && *new_len > 0)
> -		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno, type,
> -				bno, blockcount, new_agbno, *new_len);
> +		trace_xfs_refcount_finish_one_leftover(mp, agno, type, bno,
> +				blockcount, new_agbno, *new_len);
>  out_drop:
> -	xfs_perag_put(pag);
> +	if (pag)
> +		xfs_perag_put(pag);
>  	return error;

Yup, this just smells wrong.  The local get/put covers the reference
for the local function references, the reference gained in
_init_cursor ensures the perag is referenced for the life of the
cursor across multiple iterations (including duplicated child
cursors that also take their own references).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
