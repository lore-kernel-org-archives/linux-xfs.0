Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657E9C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 21:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240990AbiCRVU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 17:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiCRVUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 17:20:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEED1DE6F4
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 14:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3CDAB82579
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 21:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAB5C340E8;
        Fri, 18 Mar 2022 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647638343;
        bh=8Ud/V9HvogdGgvRNKAbBROXkmfXjAky0Utsi065lLRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sujj/yYx1KV4pZfeYKpmdZM4sd9qkFpbU9bxPyij7l1KDIlFAxwNrdbEbXhlrEclU
         +Wq45rnVZO8+FtH5hBj4GfoPW9goDr7MbaEfebSXvt0m/V61NLEvnbMulMJcKqP2b4
         kra6z9pWqrbOWUhg4PH/G/EV7f0N4SeqUYCl/yW8or++0gtu/zSBXTUZLv6Bw+EHoi
         HxIDgBUAhFWgWCxDznCDHpO4E5MqIgzXeQtHlMKbHe4otjaRvURsCu0HTb0YjmYj1z
         z2jkQLuDj8MzIpUgh8XUdTjMtwtPMyAmrEZ3Xx7PnPvc7l/KbuKLQinSIUKHAGDDBO
         z7Z2xGqs5Vffg==
Date:   Fri, 18 Mar 2022 14:19:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 5/6] xfs: don't report reserved bnobt space as available
Message-ID: <20220318211900.GF8224@magnolia>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755208338.4194202.6258724683699525828.stgit@magnolia>
 <YjR45Cocvq23N157@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjR45Cocvq23N157@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 08:19:48AM -0400, Brian Foster wrote:
> On Thu, Mar 17, 2022 at 02:21:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On a modern filesystem, we don't allow userspace to allocate blocks for
> > data storage from the per-AG space reservations, the user-controlled
> > reservation pool that prevents ENOSPC in the middle of internal
> > operations, or the internal per-AG set-aside that prevents ENOSPC.
> > Since we now consider free space btree blocks as unavailable for
> > allocation for data storage, we shouldn't report those blocks via statfs
> > either.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsops.c |    3 +--
> >  fs/xfs/xfs_mount.h |   13 +++++++++++++
> >  fs/xfs/xfs_super.c |    4 +---
> >  3 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 998b54c3c454..74e9b8558162 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -508,6 +508,19 @@ xfs_fdblocks_available(
> >  	return free;
> >  }
> >  
> > +/* Same as above, but don't take the slow path. */
> > +static inline int64_t
> > +xfs_fdblocks_available_fast(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int64_t			free;
> > +
> > +	free = percpu_counter_read_positive(&mp->m_fdblocks);
> > +	free -= mp->m_alloc_set_aside;
> > +	free -= atomic64_read(&mp->m_allocbt_blks);
> > +	return free;
> > +}
> > +
> 
> No objection to the behavior change, but the point of the helper should
> be to simplify things and reduce duplication. Here it seems we're going
> to continue duplicating the set aside calculation, just in separate
> helpers because different contexts apparently have different ways of
> reading the free space counters (?).
> 
> If that's the case and we want an _available() helper, can we create a
> single helper that takes the fdblocks count as a parameter and returns
> the final "available" value so the helper can be used more broadly and
> consistently? (Or factor out the common bits into an internal helper and
> turn these two into simple parameter passing wrappers if you really want
> to keep the api as such).

In the end, I deleted xfs_fdblocks_avail* so the only new function is
the xfs_fdblocks_unavailable() that I mentioned in the last reply.

It does make the patches smaller...

--D

> Brian
> 
> >  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
> >  				 bool reserved);
> >  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d84714e4e46a..7b6c147e63c4 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -791,7 +791,6 @@ xfs_fs_statfs(
> >  	uint64_t		fakeinos, id;
> >  	uint64_t		icount;
> >  	uint64_t		ifree;
> > -	uint64_t		fdblocks;
> >  	xfs_extlen_t		lsize;
> >  	int64_t			ffree;
> >  
> > @@ -806,7 +805,6 @@ xfs_fs_statfs(
> >  
> >  	icount = percpu_counter_sum(&mp->m_icount);
> >  	ifree = percpu_counter_sum(&mp->m_ifree);
> > -	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> >  
> >  	spin_lock(&mp->m_sb_lock);
> >  	statp->f_bsize = sbp->sb_blocksize;
> > @@ -815,7 +813,7 @@ xfs_fs_statfs(
> >  	spin_unlock(&mp->m_sb_lock);
> >  
> >  	/* make sure statp->f_bfree does not underflow */
> > -	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
> > +	statp->f_bfree = max_t(int64_t, xfs_fdblocks_available(mp), 0);
> >  	statp->f_bavail = statp->f_bfree;
> >  
> >  	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> > 
> 
