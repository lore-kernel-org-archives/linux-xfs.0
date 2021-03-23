Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8116CC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 22:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C692619CA
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 22:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhCWWdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 18:33:51 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44099 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233972AbhCWWcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 18:32:07 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 240D0102AD49;
        Wed, 24 Mar 2021 09:31:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOpZ8-005zO9-Hb; Wed, 24 Mar 2021 09:31:58 +1100
Date:   Wed, 24 Mar 2021 09:31:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: create a polled function to force inode
 inactivation
Message-ID: <20210323223158.GI63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543200190.1947934.3117722394191799491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543200190.1947934.3117722394191799491.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=GzCNAF1MnO-VnZI6NMAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22 a=fCgQI5UlmZDRPDxm0A3o:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:06:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a polled version of xfs_inactive_force so that we can force
> inactivation while holding a lock (usually the umount lock) without
> tripping over the softlockup timer.  This is for callers that hold vfs
> locks while calling inactivation, which is currently unmount, iunlink
> processing during mount, and rw->ro remount.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   38 +++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_icache.h |    1 +
>  fs/xfs/xfs_mount.c  |    2 +-
>  fs/xfs/xfs_mount.h  |    5 +++++
>  fs/xfs/xfs_super.c  |    3 ++-
>  5 files changed, 46 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d5f580b92e48..9db2beb4e732 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -25,6 +25,7 @@
>  #include "xfs_ialloc.h"
>  
>  #include <linux/iversion.h>
> +#include <linux/nmi.h>

This stuff goes in fs/xfs/xfs_linux.h, not here.

>  
>  /*
>   * Allocate and initialise an xfs_inode.
> @@ -2067,8 +2068,12 @@ xfs_inodegc_free_space(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	return xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
> +	int			error;
> +
> +	error = xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
>  			xfs_inactive_inode, eofb, XFS_ICI_INACTIVE_TAG);
> +	wake_up(&mp->m_inactive_wait);
> +	return error;
>  }
>  
>  /* Try to get inode inactivation moving. */
> @@ -2138,6 +2143,37 @@ xfs_inodegc_force(
>  	flush_workqueue(mp->m_gc_workqueue);
>  }
>  
> +/*
> + * Force all inode inactivation work to run immediately, and poll until the
> + * work is complete.  Callers should only use this function if they must
> + * inactivate inodes while holding VFS locks, and must be prepared to prevent
> + * or to wait for inodes that are queued for inactivation while this runs.
> + */
> +void
> +xfs_inodegc_force_poll(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno;
> +	bool			queued = false;
> +
> +	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
> +		queued |= xfs_inodegc_force_pag(pag);
> +	if (!queued)
> +		return;
> +
> +	/*
> +	 * Touch the softlockup watchdog every 1/10th of a second while there
> +	 * are still inactivation-tagged inodes in the filesystem.
> +	 */
> +	while (!wait_event_timeout(mp->m_inactive_wait,
> +				   !radix_tree_tagged(&mp->m_perag_tree,
> +						      XFS_ICI_INACTIVE_TAG),
> +				   HZ / 10)) {
> +		touch_softlockup_watchdog();
> +	}
> +}

This looks like a deadlock waiting to be tripped over. As long as
there is something still able to queue inodes for inactivation,
that radix tree tag check will always trigger and put us back to
sleep.

Also, in terms of workqueues, this is a "sync flush" i because we
are waiting for it. e.g. the difference between cancel_work() and
cancel_work_sync() is that the later waits for all the work in
progress to complete before returning and the former doesn't wait...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
