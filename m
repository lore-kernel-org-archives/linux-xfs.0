Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8DCC47082
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 00:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F74060C3F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 00:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhFAAWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 20:22:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60248 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232081AbhFAAWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 20:22:07 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0C8CB863CC1;
        Tue,  1 Jun 2021 10:20:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lns8t-007W05-8l; Tue, 01 Jun 2021 10:20:23 +1000
Date:   Tue, 1 Jun 2021 10:20:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/5] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210601002023.GY664593@dread.disaster.area>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250086766.490412.9229536536315438431.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250086766.490412.9229536536315438431.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=l0jknusJq8AvmJ2Om44A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:41:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Disentangle the dqrele_all inode grab code from the "generic" inode walk
> grabbing code, and and use the opportunity to document why the dqrele
> grab function does what it does.
> 
> Since dqrele_all is the only user of XFS_ICI_NO_TAG, rename it to
> something more specific for what we're doing.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_icache.h |    4 ++-
>  2 files changed, 62 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 34b8b5fbd60d..5501318b5db0 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -26,6 +26,8 @@
>  
>  #include <linux/iversion.h>
>  
> +static bool xfs_dqrele_inode_grab(struct xfs_inode *ip);
> +

Just mov the function higher up in the file rather than add forward
declarations....

>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -765,6 +767,22 @@ xfs_inode_walk_ag_grab(
>  	return false;
>  }
>  
> +static inline bool
> +xfs_grabbed_for_walk(
> +	int			tag,
> +	struct xfs_inode	*ip,
> +	int			iter_flags)
> +{
> +	switch (tag) {
> +	case XFS_ICI_BLOCKGC_TAG:
> +		return xfs_inode_walk_ag_grab(ip, iter_flags);
> +	case XFS_ICI_DQRELE_NONTAG:
> +		return xfs_dqrele_inode_grab(ip);
> +	default:
> +		return false;
> +	}
> +}

Not really a fan of this XFS_ICI_DQRELE_NONTAG rename. It kinda
smears caller context across the walk API. We really have two
different things here - we want a tagless lookup, and we want a
dquot specific grab function.

This API change just means we're going to have to rename the "no
tag" lookup yet again when we need some other non tag-based lookup.

And I think this is redundant, because....

> +/* Decide if we want to grab this inode to drop its dquots. */
> +static bool
> +xfs_dqrele_inode_grab(
> +	struct xfs_inode	*ip)
> +{
> +	bool			ret = false;
> +
> +	ASSERT(rcu_read_lock_held());
> +
> +	/* Check for stale RCU freed inode */
> +	spin_lock(&ip->i_flags_lock);
> +	if (!ip->i_ino)
> +		goto out_unlock;
> +
> +	/*
> +	 * Skip inodes that are anywhere in the reclaim machinery because we
> +	 * drop dquots before tagging an inode for reclamation.
> +	 */
> +	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
> +		goto out_unlock;
> +
> +	/*
> +	 * The inode looks alive; try to grab a VFS reference so that it won't
> +	 * get destroyed.  If we got the reference, return true to say that
> +	 * we grabbed the inode.
> +	 *
> +	 * If we can't get the reference, then we know the inode had its VFS
> +	 * state torn down and hasn't yet entered the reclaim machinery.  Since
> +	 * we also know that dquots are detached from an inode before it enters
> +	 * reclaim, we can skip the inode.
> +	 */
> +	ret = igrab(VFS_I(ip)) != NULL;
> +
> +out_unlock:
> +	spin_unlock(&ip->i_flags_lock);
> +	return ret;
> +}

This is basically just duplication of xfs_inode_walk_ag_grab()
without the XFS_INODE_WALK_INEW_WAIT check in it. At this point I
just don't see a reason for this function or the
XFS_ICI_DQRELE_NONTAG rename just to use this grab function...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
