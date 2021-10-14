Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC46EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C98610F8
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhJNWuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 18:50:24 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40461 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhJNWuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 18:50:23 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 80EB51067DA2;
        Fri, 15 Oct 2021 09:48:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9WH-006JGm-Sn; Fri, 15 Oct 2021 09:48:13 +1100
Date:   Fri, 15 Oct 2021 09:48:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/17] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
Message-ID: <20211014224813.GN2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424262046.756780.2366797746965376855.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424262046.756780.2366797746965376855.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6168b3b0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=5EjMf7jUMarBDnzXXm8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:17:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During review of subsequent patches, Dave and I noticed that this
> function doesn't work quite right -- accessing cur->bc_ino depends on
> the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
> isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
> because block 0 of an AG is never part of a btree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/trace.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index c0ef53fe6611..93c13763c15e 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -24,10 +24,11 @@ xchk_btree_cur_fsbno(
>  	if (level < cur->bc_nlevels && cur->bc_bufs[level])
>  		return XFS_DADDR_TO_FSB(cur->bc_mp,
>  				xfs_buf_daddr(cur->bc_bufs[level]));
> -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +
> +	if (level == cur->bc_nlevels - 1 &&
> +	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
>  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);

Ok.

> -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
> -		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
> +

But doesn't this break the tracing code on short pointers as the
tracing code does:

	TP_fast_assign(
		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
		...
		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);


i.e. the tracing will no longer give the correct agno for per-ag
cursors that don't have any buffers attached to them at the current
level?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
