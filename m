Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D38C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 19:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D48F613BC
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 19:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhFATwd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 15:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFATwd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 15:52:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95761613BD;
        Tue,  1 Jun 2021 19:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622577051;
        bh=slREzSQ+8kMAKuMj1jYj3oNjY8BHYPALV8eNtr45sJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rXlgVHXREdF21+k3iEZVZwth84Phb2x7fEVnlCASYxLP61eE26lEj36WXRgR1JfEZ
         a2dZna1kCwFAcwZUavV0wC/6VkFZMJqWZ6N7bYbyhKIHHWN8eeqQSca4fS2bPLbBhx
         kYYjajjwtbc5NTCPocbP98H/bCzR8tJ30AaOMJobzI+m+E7dFSWWjQIKIO9z9YDuQW
         +AmYps3+XkW/L/tLbyGEcTuoitkIIK8NS9Uxf3wUFMQfkYq9zaIMJxmG6gpcQ2U1MV
         ks6Ab++fK4DZDyr9VOBUicYGxpiK8vQmYVo1LG7AxtVmvHPkcaNeRg1p8ePp9ZVKtx
         /EVn9aRlmJC/A==
Date:   Tue, 1 Jun 2021 12:50:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/5] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210601195051.GB26380@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250086766.490412.9229536536315438431.stgit@locust>
 <20210601002023.GY664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601002023.GY664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 10:20:23AM +1000, Dave Chinner wrote:
> On Mon, May 31, 2021 at 03:41:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Disentangle the dqrele_all inode grab code from the "generic" inode walk
> > grabbing code, and and use the opportunity to document why the dqrele
> > grab function does what it does.
> > 
> > Since dqrele_all is the only user of XFS_ICI_NO_TAG, rename it to
> > something more specific for what we're doing.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/xfs_icache.h |    4 ++-
> >  2 files changed, 62 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 34b8b5fbd60d..5501318b5db0 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -26,6 +26,8 @@
> >  
> >  #include <linux/iversion.h>
> >  
> > +static bool xfs_dqrele_inode_grab(struct xfs_inode *ip);
> > +
> 
> Just mov the function higher up in the file rather than add forward
> declarations....

Ugh, this will cause churn that will ripple through this and the next
iwalk refactoring patchsets and deferred inactivation.  Can I please
please please defer the churn cleanup until the end of all that?

> 
> >  /*
> >   * Allocate and initialise an xfs_inode.
> >   */
> > @@ -765,6 +767,22 @@ xfs_inode_walk_ag_grab(
> >  	return false;
> >  }
> >  
> > +static inline bool
> > +xfs_grabbed_for_walk(
> > +	int			tag,
> > +	struct xfs_inode	*ip,
> > +	int			iter_flags)
> > +{
> > +	switch (tag) {
> > +	case XFS_ICI_BLOCKGC_TAG:
> > +		return xfs_inode_walk_ag_grab(ip, iter_flags);
> > +	case XFS_ICI_DQRELE_NONTAG:
> > +		return xfs_dqrele_inode_grab(ip);
> > +	default:
> > +		return false;
> > +	}
> > +}
> 
> Not really a fan of this XFS_ICI_DQRELE_NONTAG rename. It kinda
> smears caller context across the walk API. We really have two
> different things here - we want a tagless lookup, and we want a
> dquot specific grab function.
> 
> This API change just means we're going to have to rename the "no
> tag" lookup yet again when we need some other non tag-based lookup.
> 
> And I think this is redundant, because....
> 
> > +/* Decide if we want to grab this inode to drop its dquots. */
> > +static bool
> > +xfs_dqrele_inode_grab(
> > +	struct xfs_inode	*ip)
> > +{
> > +	bool			ret = false;
> > +
> > +	ASSERT(rcu_read_lock_held());
> > +
> > +	/* Check for stale RCU freed inode */
> > +	spin_lock(&ip->i_flags_lock);
> > +	if (!ip->i_ino)
> > +		goto out_unlock;
> > +
> > +	/*
> > +	 * Skip inodes that are anywhere in the reclaim machinery because we
> > +	 * drop dquots before tagging an inode for reclamation.
> > +	 */
> > +	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
> > +		goto out_unlock;
> > +
> > +	/*
> > +	 * The inode looks alive; try to grab a VFS reference so that it won't
> > +	 * get destroyed.  If we got the reference, return true to say that
> > +	 * we grabbed the inode.
> > +	 *
> > +	 * If we can't get the reference, then we know the inode had its VFS
> > +	 * state torn down and hasn't yet entered the reclaim machinery.  Since
> > +	 * we also know that dquots are detached from an inode before it enters
> > +	 * reclaim, we can skip the inode.
> > +	 */
> > +	ret = igrab(VFS_I(ip)) != NULL;
> > +
> > +out_unlock:
> > +	spin_unlock(&ip->i_flags_lock);
> > +	return ret;
> > +}
> 
> This is basically just duplication of xfs_inode_walk_ag_grab()
> without the XFS_INODE_WALK_INEW_WAIT check in it. At this point I
> just don't see a reason for this function or the
> XFS_ICI_DQRELE_NONTAG rename just to use this grab function...

Ugh.  I should have sent the /next/ iwalk refactoring series along with
this one so that it would become more obvious that the end goal is to
seal all the incore inode walk code in xfs_icache.c, since there are
only four of them (reclaim, inodegc, blockgc, quotaoff) and the grab
functions for all four are just different enough that it's not really
worth it to keep them combined in one function full of conditionals.

Once that's done, the only user of xfs_inode_walk_ag_grab is the blockgc
code and I can rename it.

Ofc the reason I held back is that the next series adds 8 more iwalk
cleanup patches, and the more patches I send all at once the longer it
takes for anyone to start looking at it.  I /still/ can't figure out the
balance between risking overwhelming everyone with too many patches vs.
sending insufficient patches to convey where I'm really going with
something.

<shrug> I might just ping you on irc so that we can have a conversation
about this and summarize whatever we come up with for the list.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
