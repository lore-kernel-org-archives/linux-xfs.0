Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C333CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 05:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA53E60F94
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 05:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhJMFmr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 01:42:47 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58653 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237831AbhJMFmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 01:42:46 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 4D5AF5E7FE5;
        Wed, 13 Oct 2021 16:40:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maX0L-005esh-Oq; Wed, 13 Oct 2021 16:40:41 +1100
Date:   Wed, 13 Oct 2021 16:40:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 09/15] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20211013054041.GB2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408160334.4151249.13708314780740357223.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408160334.4151249.13708314780740357223.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6166715a
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=FmUyGns8pnrEQl046vYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:33:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> To support future btree code, we need to be able to size btree cursors
> dynamically for very large btrees.  Switch the maxlevels computation to
> use the precomputed values in the superblock, and create cursors that
> can handle a certain height.  For now, we retain the btree cursor zone
> that can handle up to 9-level btrees, and create larger cursors (which
> shouldn't happen currently) from the heap as a failsafe.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    3 ++-
>  fs/xfs/libxfs/xfs_btree.h          |   13 +++++++++++--
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 ++-
>  fs/xfs/libxfs/xfs_refcount_btree.c |    3 ++-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    3 ++-
>  fs/xfs/xfs_super.c                 |    4 ++--
>  7 files changed, 22 insertions(+), 9 deletions(-)

minor nit:

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 43766e5b680f..b8761a2fc24b 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -94,6 +94,12 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
>  
>  #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
>  
> +/*
> + * The btree cursor zone hands out cursors that can handle up to this many
> + * levels.  This is the known maximum for all btree types.
> + */
> +#define XFS_BTREE_CUR_ZONE_MAXLEVELS	(9)

XFS_BTREE_CUR_CACHE_MAXLEVELS	9

Otherwise looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
