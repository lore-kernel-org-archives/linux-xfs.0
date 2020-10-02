Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD1BC4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EA132074B
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgJBHaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:30:13 -0400
Received: from verein.lst.de ([213.95.11.211]:51346 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBHaN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 03:30:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 37C1E67357; Fri,  2 Oct 2020 09:30:07 +0200 (CEST)
Date:   Fri, 2 Oct 2020 09:30:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5.2 3/3] xfs: fix an incore inode UAF in
 xfs_bui_recover
Message-ID: <20201002073006.GE9900@lst.de>
References: <160140142711.830434.5161910313856677767.stgit@magnolia> <160140144660.830434.10498291551366134327.stgit@magnolia> <20201002042236.GV49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002042236.GV49547@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:22:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bui_item_recover, there exists a use-after-free bug with regards
> to the inode that is involved in the bmap replay operation.  If the
> mapping operation does not complete, we call xfs_bmap_unmap_extent to
> create a deferred op to finish the unmapping work, and we retain a
> pointer to the incore inode.
> 
> Unfortunately, the very next thing we do is commit the transaction and
> drop the inode.  If reclaim tears down the inode before we try to finish
> the defer ops, we dereference garbage and blow up.  Therefore, create a
> way to join inodes to the defer ops freezer so that we can maintain the
> xfs_inode reference until we're done with the inode.
> 
> Note: This imposes the requirement that there be enough memory to keep
> every incore inode in memory throughout recovery.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v5.2: rebase on updated defer capture patches
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   55 ++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_defer.h  |   11 +++++++--
>  fs/xfs/xfs_bmap_item.c     |    8 ++----
>  fs/xfs/xfs_extfree_item.c  |    2 +-
>  fs/xfs/xfs_log_recover.c   |    7 +++++-
>  fs/xfs/xfs_refcount_item.c |    2 +-
>  fs/xfs/xfs_rmap_item.c     |    2 +-
>  7 files changed, 67 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index e19dc1ced7e6..4af5752f9830 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -16,6 +16,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
> +#include "xfs_icache.h"
>  
>  /*
>   * Deferred Operations in XFS
> @@ -553,10 +554,14 @@ xfs_defer_move(
>   * deferred ops state is transferred to the capture structure and the
>   * transaction is then ready for the caller to commit it.  If there are no
>   * intent items to capture, this function returns NULL.
> + *
> + * If inodes are passed in and this function returns a capture structure, the
> + * inodes are now owned by the capture structure.
>   */
>  static struct xfs_defer_capture *
>  xfs_defer_ops_capture(
> -	struct xfs_trans		*tp)
> +	struct xfs_trans		*tp,
> +	struct xfs_inode		*ip)
>  {
>  	struct xfs_defer_capture	*dfc;
>  
> @@ -582,6 +587,12 @@ xfs_defer_ops_capture(
>  	/* Preserve the log reservation size. */
>  	dfc->dfc_logres = tp->t_log_res;
>  
> +	/*
> +	 * Transfer responsibility for unlocking and releasing the inodes to
> +	 * the capture structure.
> +	 */
> +	dfc->dfc_ip = ip;
> +

Maybe rename ip to capture_ip?

> +	ASSERT(ip == NULL || xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
>  	/* If we don't capture anything, commit transaction and exit. */
> +	dfc = xfs_defer_ops_capture(tp, ip);
> +	if (!dfc) {
> +		error = xfs_trans_commit(tp);
> +		if (ip) {
> +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +			xfs_irele(ip);
> +		}
> +		return error;
> +	}

Instead of coming up with our own inode unlocking and release schemes,
can't we just require that the inode is joinged by passing the lock
flags to xfs_trans_ijoin, and piggy back on xfs_trans_commit unlocking
it in that case?
