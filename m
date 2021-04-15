Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30E1C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 03:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D3F613A9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 03:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhDODxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 23:53:16 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:39063 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhDODxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 23:53:16 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 316AD1140477;
        Thu, 15 Apr 2021 13:52:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWt3k-008bJ5-CK; Thu, 15 Apr 2021 13:52:52 +1000
Date:   Thu, 15 Apr 2021 13:52:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] xfs: check ag is empty
Message-ID: <20210415035252.GK63242@dread.disaster.area>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414195240.1802221-3-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ZEfO5Vk7p6AluBRNLZsA:9 a=GPxcTf2O30FJSDyZ:21 a=1PVju93DjykKkdVg:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 03:52:38AM +0800, Gao Xiang wrote:
> After a perag is stableized as inactive, we could check if such ag
> is empty. In order to achieve that, AGFL is also needed to be
> emptified in advance to make sure that only one freespace extent
> will exist here.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 97 +++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h |  4 ++
>  2 files changed, 101 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 01d4e4d4c1d6..60a8c134c00e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2474,6 +2474,103 @@ xfs_defer_agfl_block(
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>  }
>  
> +int
> +xfs_ag_emptify_agfl(
> +	struct xfs_buf		*agfbp)
> +{
> +	struct xfs_mount	*mp = agfbp->b_mount;
> +	struct xfs_perag	*pag = agfbp->b_pag;
> +	struct xfs_trans	*tp;
> +	int			error;
> +	struct xfs_owner_info	oinfo = XFS_RMAP_OINFO_AG;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, 0, 0,
> +				XFS_TRANS_RESERVE, &tp);
> +	if (error)
> +		return error;
> +
> +	/* attach to the transaction and keep it from unlocked */
> +	xfs_trans_bjoin(tp, agfbp);
> +	xfs_trans_bhold(tp, agfbp);
> +
> +	while (pag->pagf_flcount) {
> +		xfs_agblock_t	bno;
> +		int		error;
> +
> +		error = xfs_alloc_get_freelist(tp, agfbp, &bno, 0);
> +		if (error)
> +			break;
> +
> +		ASSERT(bno != NULLAGBLOCK);
> +		xfs_defer_agfl_block(tp, pag->pag_agno, bno, &oinfo);
> +	}
> +	xfs_trans_set_sync(tp);
> +	xfs_trans_commit(tp);
> +	return error;
> +}

Why do we need to empty the agfl to determine the AG is empty?

> +int
> +xfs_ag_is_empty(
> +	struct xfs_buf		*agfbp)
> +{
> +	struct xfs_mount	*mp = agfbp->b_mount;
> +	struct xfs_perag	*pag = agfbp->b_pag;
> +	struct xfs_agf		*agf = agfbp->b_addr;
> +	struct xfs_btree_cur	*cnt_cur;
> +	xfs_agblock_t		nfbno;
> +	xfs_extlen_t		nflen;
> +	int			error, i;
> +
> +	if (!pag->pag_inactive)
> +		return -EINVAL;
> +
> +	if (pag->pagf_freeblks + pag->pagf_flcount !=
> +	    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
> +		return -ENOTEMPTY;

This is the empty check right here, yes?

Hmmm - this has to fail if the log is in this AG, right? Because we
can't move the log (yet), so we should explicitly be checking that
the log is in this AG before check the amount of free space...

> +
> +	if (pag->pagf_flcount) {
> +		error = xfs_ag_emptify_agfl(agfbp);
> +		if (error)
> +			return error;
> +
> +		if (pag->pagf_freeblks !=
> +		    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
> +			return -ENOTEMPTY;
> +	}
> +
> +	if (pag->pagi_count > 0 || pag->pagi_freecount > 0)
> +		return -ENOTEMPTY;
> +
> +	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > 1 ||
> +	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > 1)
> +		return -ENOTEMPTY;
> +
> +	cnt_cur = xfs_allocbt_init_cursor(mp, NULL, agfbp,
> +					  pag->pag_agno, XFS_BTNUM_CNT);
> +	ASSERT(cnt_cur->bc_nlevels == 1);
> +	error = xfs_alloc_lookup_ge(cnt_cur, 0,
> +				    be32_to_cpu(agf->agf_longest), &i);
> +	if (error || !i)
> +		goto out;
> +
> +	error = xfs_alloc_get_rec(cnt_cur, &nfbno, &nflen, &i);
> +	if (error)
> +		goto out;
> +
> +	if (XFS_IS_CORRUPT(mp, i != 1)) {
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	error = -ENOTEMPTY;
> +	if (nfbno == mp->m_ag_prealloc_blocks &&
> +	    nflen == pag->pagf_freeblks)
> +		error = 0;

Ah, that's why you are trying to empty the AGFL.

This won't work because the AG btree roots can be anywhere in the AG
once the tree has grown beyond a single block. Hence when the AG is
fully empty, the btree root blocks can still break up free space
into multiple extents that are each less than a maximally sized
single extent. e.g. from my workstation:

$ xfs_db -r -c "agf 0" -c "p" /dev/mapper/base-main 
magicnum = 0x58414746
versionnum = 1
seqno = 0
length = 13732864
bnoroot = 29039
cntroot = 922363
rmaproot = 8461704
refcntroot = 6
bnolevel = 2
cntlevel = 2
rmaplevel = 3
....

none of the root blocks are inside the m_ag_prealloc_blocks region
of the AG. m_ag_prealloc_blocks is just for space accounting and
does not imply physical location of the btree root blocks...

Hence I think the only checks that need to be done here are whether
the number of free blocks equals the maximal number of blocks
available in the given AG.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
