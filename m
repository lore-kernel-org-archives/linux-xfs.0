Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385DBC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 21:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiDCV4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 17:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiDCV4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 17:56:42 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABFFA15A3A
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 14:54:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E7C6F10E55B9;
        Mon,  4 Apr 2022 07:54:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nb8BH-00DQFT-4N; Mon, 04 Apr 2022 07:54:43 +1000
Date:   Mon, 4 Apr 2022 07:54:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: replace xfs_buf_incore with an XBF_NOALLOC flag
 to xfs_buf_get*
Message-ID: <20220403215443.GO1544202@dread.disaster.area>
References: <20220403120119.235457-1-hch@lst.de>
 <20220403120119.235457-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403120119.235457-3-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=624a17a5
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=c1TyfY6AnFl6kXyScNEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 03, 2022 at 02:01:16PM +0200, Christoph Hellwig wrote:
> Replace the special purpose xfs_buf_incore interface with a new
> XBF_NOALLOC flag for the xfs_buf_get* routines.

I think this is the wrong direction to go in the greater scheme of
things. _XBF_NOALLOC needs to be an internal implementation detail
similar to _XBF_PAGES, not exposed as part of the caller API.

That is, xfs_buf_incore() clearly documents the operation "return me
the locked buffer if it currently cached in memory" that the callers
want, while XBF_NOALLOC doesn't clearly mean anything as obvious as
this at the caller level.  Hence I'd prefer this to end up as:

/*
 * Lock and return the buffer that matches the requested range if
 * and only if it is present in the cache already.
 */
static inline struct xfs_buf *
xfs_buf_incore(
	struct xfs_buftarg	*target,
	xfs_daddr_t		blkno,
	size_t			numblks,
	xfs_buf_flags_t		flags)
{
	struct xfs_buf		*bp;
	int			error;
	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);

	error = xfs_buf_get_map(target, &map, 1, _XBF_NOALLOC | flags,
				NULL, &bp);
	if (error)
		return NULL;
	return bp;
}

Then none of the external callers need to be changed, and we don't
introduce new external xfs_buf_get() callers.


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |  6 +++---
>  fs/xfs/scrub/repair.c           |  6 +++---
>  fs/xfs/xfs_buf.c                | 22 +++-------------------
>  fs/xfs/xfs_buf.h                |  5 +----
>  fs/xfs/xfs_qm.c                 |  6 +++---
>  5 files changed, 13 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 3fc62ff92441d5..9aff2ce203c9b6 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -550,10 +550,10 @@ xfs_attr_rmtval_stale(
>  	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
>  		return -EFSCORRUPTED;
>  
> -	bp = xfs_buf_incore(mp->m_ddev_targp,
> +	if (!xfs_buf_get(mp->m_ddev_targp,
>  			XFS_FSB_TO_DADDR(mp, map->br_startblock),
> -			XFS_FSB_TO_BB(mp, map->br_blockcount), incore_flags);
> -	if (bp) {
> +			XFS_FSB_TO_BB(mp, map->br_blockcount),
> +			incore_flags | XBF_NOALLOC, &bp)) {
>  		xfs_buf_stale(bp);
>  		xfs_buf_relse(bp);
>  	}

FWIW, I also think that the this pattern change is a regression.
We've spent the past decade+ moving function calls that return
objects and errors out of if() scope to clean up the code. Reversing
that pattern here doesn't make the code cleaner...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
