Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:35:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751ZZnn024372
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:35:36 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7005612434AA
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:36:49 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id Serp44RR43fZmMHz for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:36:49 -0700 (PDT)
Date: Tue, 5 Aug 2008 11:36:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 23/26] implement generic xfs_btree_delete/delrec
Message-ID: <20080805013625.GN6119@disturbed>
References: <20080804013550.GX8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013550.GX8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:35:50AM +0200, Christoph Hellwig wrote:
> Make the btree delete code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.
.....
> +STATIC int
> +xfs_btree_update_root(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*bp,
> +	int			level,
> +	union xfs_btree_ptr	*newroot)
> +{
> +	int			error;
> +
> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	XFS_BTREE_STATS_INC(cur, killroot);
> +
> +#ifdef DEBUG
> +	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_CNT) {
> +		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +		struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +
> +		ASSERT(be32_to_cpu(agf->agf_roots[cur->bc_btnum]) ==
> +		       XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
> +	} else if (cur->bc_btnum == XFS_BTNUM_INO) {
> +		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +		struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +		xfs_fsblock_t		fsbno;
> +
> +		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> +				       be32_to_cpu(agi->agi_root));
> +
> +		ASSERT(fsbno == XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)));
> +	}
> +#endif

That's kind of messy - can it be pushed out to a separate debug only
function? Also, why do we check the inobt against a long pointer,
and the allocbt against a short pointer? both are short pointer
btrees, so it doesn't really make sense to me to have different
checks on them...

Otherwise looks pretty good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
