Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EA2C4708F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 19:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7EC1613C1
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 19:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhFATzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 15:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFATzG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 15:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DEBE6023B;
        Tue,  1 Jun 2021 19:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622577204;
        bh=Kn+xm7L0+263Q+pPrjDNjaUNxSJM6DylX5ppu5+SrD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6/IzPi3NlytE1wWsLXNVxGE53YKLxmEeRKRHWa4L9b6gBVQNUWDIMHHwKOnHRJBU
         Klv4TyzxnabvyfjsQX4HLpt09lgJKLst1tcaQp9S+Ywj9XE5mg8gF9WhdcjJR4NNqZ
         EIBVwJUynIPsEVWsiq8+3g8iAjwu14Sh5mDo1w8Zyr8womEuk7D2yz5Y8V/xHiVFcc
         MPDLLpe8mD60i3COdnmlwCf/avwZBhToSc0ov0p1go8A5OadkPw+Wg3xCkThFPjSc7
         mTdnMJF5twROhNUsLAenxOGAHlWb2qkRuPeWXHLUamKFl+9dVQIoYkxmQ144BrZRht
         Haj0rlWxPtFQg==
Date:   Tue, 1 Jun 2021 12:53:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/5] xfs: drop inactive dquots before inactivating inodes
Message-ID: <20210601195324.GC26380@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250087317.490412.346108244268292896.stgit@locust>
 <20210601003506.GZ664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601003506.GZ664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 10:35:06AM +1000, Dave Chinner wrote:
> On Mon, May 31, 2021 at 03:41:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > During quotaoff, the incore inode scan to detach dquots from inodes
> > won't touch inodes that have lost their VFS state but haven't yet been
> > queued for reclaim.  This isn't strictly a problem because we drop the
> > dquots at the end of inactivation, but if we detect this situation
> > before starting inactivation, we can drop the inactive dquots early to
> > avoid delaying quotaoff further.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_super.c |   32 ++++++++++++++++++++++++++++----
> >  1 file changed, 28 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index a2dab05332ac..79f1cd1a0221 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -637,22 +637,46 @@ xfs_fs_destroy_inode(
> >  	struct inode		*inode)
> >  {
> >  	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> >  
> >  	trace_xfs_destroy_inode(ip);
> >  
> >  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> > -	XFS_STATS_INC(ip->i_mount, vn_rele);
> > -	XFS_STATS_INC(ip->i_mount, vn_remove);
> > +	XFS_STATS_INC(mp, vn_rele);
> > +	XFS_STATS_INC(mp, vn_remove);
> > +
> > +	/*
> > +	 * If a quota type is turned off but we still have a dquot attached to
> > +	 * the inode, detach it before processing this inode to avoid delaying
> > +	 * quotaoff for longer than is necessary.
> > +	 *
> > +	 * The inode has no VFS state and hasn't been tagged for any kind of
> > +	 * reclamation, which means that iget, quotaoff, blockgc, and reclaim
> > +	 * will not touch it.  It is therefore safe to do this locklessly
> > +	 * because we have the only reference here.
> > +	 */
> > +	if (!XFS_IS_UQUOTA_ON(mp)) {
> > +		xfs_qm_dqrele(ip->i_udquot);
> > +		ip->i_udquot = NULL;
> > +	}
> > +	if (!XFS_IS_GQUOTA_ON(mp)) {
> > +		xfs_qm_dqrele(ip->i_gdquot);
> > +		ip->i_gdquot = NULL;
> > +	}
> > +	if (!XFS_IS_PQUOTA_ON(mp)) {
> > +		xfs_qm_dqrele(ip->i_pdquot);
> > +		ip->i_pdquot = NULL;
> > +	}
> >  
> >  	xfs_inactive(ip);
> 
> Shouldn't we just make xfs_inactive() unconditionally detatch dquots
> rather than just in the conditional case it does now after attaching
> dquots because it has to make modifications? For inodes that don't
> require any inactivation work, we get the same thing, and for those
> that do running a few extra transactions before dropping the dquots
> isn't going to make a huge difference to the quotaoff latency....

Actually... the previous patch does exactly that.  I'll drop this patch.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
