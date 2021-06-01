Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA981C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 00:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7568611CB
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 00:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhFAAhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 20:37:05 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:56924 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232358AbhFAAhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 20:37:04 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6A33A80FC12;
        Tue,  1 Jun 2021 10:35:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnsN8-007WLR-Vh; Tue, 01 Jun 2021 10:35:06 +1000
Date:   Tue, 1 Jun 2021 10:35:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/5] xfs: drop inactive dquots before inactivating inodes
Message-ID: <20210601003506.GZ664593@dread.disaster.area>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250087317.490412.346108244268292896.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250087317.490412.346108244268292896.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=L9fo_5wKkrsjsAQ-HU0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:41:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During quotaoff, the incore inode scan to detach dquots from inodes
> won't touch inodes that have lost their VFS state but haven't yet been
> queued for reclaim.  This isn't strictly a problem because we drop the
> dquots at the end of inactivation, but if we detect this situation
> before starting inactivation, we can drop the inactive dquots early to
> avoid delaying quotaoff further.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |   32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a2dab05332ac..79f1cd1a0221 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -637,22 +637,46 @@ xfs_fs_destroy_inode(
>  	struct inode		*inode)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
>  
>  	trace_xfs_destroy_inode(ip);
>  
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> -	XFS_STATS_INC(ip->i_mount, vn_rele);
> -	XFS_STATS_INC(ip->i_mount, vn_remove);
> +	XFS_STATS_INC(mp, vn_rele);
> +	XFS_STATS_INC(mp, vn_remove);
> +
> +	/*
> +	 * If a quota type is turned off but we still have a dquot attached to
> +	 * the inode, detach it before processing this inode to avoid delaying
> +	 * quotaoff for longer than is necessary.
> +	 *
> +	 * The inode has no VFS state and hasn't been tagged for any kind of
> +	 * reclamation, which means that iget, quotaoff, blockgc, and reclaim
> +	 * will not touch it.  It is therefore safe to do this locklessly
> +	 * because we have the only reference here.
> +	 */
> +	if (!XFS_IS_UQUOTA_ON(mp)) {
> +		xfs_qm_dqrele(ip->i_udquot);
> +		ip->i_udquot = NULL;
> +	}
> +	if (!XFS_IS_GQUOTA_ON(mp)) {
> +		xfs_qm_dqrele(ip->i_gdquot);
> +		ip->i_gdquot = NULL;
> +	}
> +	if (!XFS_IS_PQUOTA_ON(mp)) {
> +		xfs_qm_dqrele(ip->i_pdquot);
> +		ip->i_pdquot = NULL;
> +	}
>  
>  	xfs_inactive(ip);

Shouldn't we just make xfs_inactive() unconditionally detatch dquots
rather than just in the conditional case it does now after attaching
dquots because it has to make modifications? For inodes that don't
require any inactivation work, we get the same thing, and for those
that do running a few extra transactions before dropping the dquots
isn't going to make a huge difference to the quotaoff latency....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
