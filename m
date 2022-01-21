Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86772C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 17:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351698AbiAUR0L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 12:26:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33212 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244983AbiAUR0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 12:26:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E8E9ECE242B;
        Fri, 21 Jan 2022 17:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F232C340E1;
        Fri, 21 Jan 2022 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642785964;
        bh=fD8nV3Ps5jxu0ngb4Gdj4iWW7L0gDokrkpHov8OYGq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsBVsP5Fp45/HP3Sp+D6K0JFV8ioExGQ/rHYsXP7DSZEnP4+efavTtgLu2UyZOEP/
         XzGiKxd6oyxERE4/fGzRvNoc1ZbIaSGzwvU+NeKQHN0N20NQxUh8B5ajpc+6lvbxzZ
         r7PeEPtu2rwlfQwMF/WVHF5PqL9nIK2QkBRgDcJ7xiFBasU/61OUY1GsLnxIn/hnFe
         xQ86DxPgm1mCkXCuyzaTaAqGqM/r9g4sF156GwaopWn6i1YWsqY8xGw2xprF05wmOH
         w6tk3XJvTR0tC8abzrdVYTTNcqHxS1CT/+seBV+SIZEWVK7vOwFy7HWWPqLxIaC3QF
         EXRiaGPoXIuEA==
Date:   Fri, 21 Jan 2022 09:26:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220121172603.GR13540@magnolia>
References: <20220121142454.1994916-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121142454.1994916-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 09:24:54AM -0500, Brian Foster wrote:
> The XFS inode allocation algorithm aggressively reuses recently
> freed inodes. This is historical behavior that has been in place for
> quite some time, since XFS was imported to mainline Linux. Once the
> VFS adopted RCUwalk path lookups (also some time ago), this behavior
> became slightly incompatible because the inode recycle path doesn't
> isolate concurrent access to the inode from the VFS.
> 
> This has recently manifested as problems in the VFS when XFS happens
> to change the type or properties of a recently unlinked inode while
> still involved in an RCU lookup. For example, if the VFS refers to a
> previous incarnation of a symlink inode, obtains the ->get_link()
> callback from inode_operations, and the latter happens to change to
> a non-symlink type via a recycle event, the ->get_link() callback
> pointer is reset to NULL and the lookup results in a crash.

Hmm, so I guess what you're saying is that if the memory buffer
allocation in ->get_link is slow enough, some other thread can free the
inode, drop it, reallocate it, and reinstantiate it (not as a symlink
this time) all before ->get_link's memory allocation call returns, after
which Bad Things Happen(tm)?

Can the lookup thread end up with the wrong inode->i_ops too?

> To avoid this class of problem, isolate in-core inodes for recycling
> with an RCU grace period. This is the same level of protection the
> VFS expects for inactivated inodes that are never reused, and so
> guarantees no further concurrent access before the type or
> properties of the inode change. We don't want an unconditional
> synchronize_rcu() event here because that would result in a
> significant performance impact to mixed inode allocation workloads.
> 
> Fortunately, we can take advantage of the recently added deferred
> inactivation mechanism to mitigate the need for an RCU wait in most
> cases. Deferred inactivation queues and batches the on-disk freeing
> of recently destroyed inodes, and so significantly increases the
> likelihood that a grace period has elapsed by the time an inode is
> freed and observable by the allocation code as a reuse candidate.
> Capture the current RCU grace period cookie at inode destroy time
> and refer to it at allocation time to conditionally wait for an RCU
> grace period if one hadn't expired in the meantime.  Since only
> unlinked inodes are recycle candidates and unlinked inodes always
> require inactivation,

Any inode can become a recycle candidate (i.e. RECLAIMABLE but otherwise
idle) but I think your point here is that unlinked inodes that become
recycling candidates can cause lookup threads to trip over symlinks, and
that's why we need to assign RCU state and poll on it, right?

(That wasn't a challenge, I'm just making sure I understand this
correctly.)

> we only need to poll and assign RCU state in
> the inactivation codepath. Slightly adjust struct xfs_inode to fit
> the new field into padding holes that conveniently preexist in the
> same cacheline as the deferred inactivation list.
> 
> Finally, note that the ideal long term solution here is to
> rearchitect bits of XFS' internal inode lifecycle management such
> that this additional stall point is not required, but this requires
> more thought, time and work to address. This approach restores
> functional correctness in the meantime.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> Here's the RCU fixup patch for inode reuse that I've been playing with,
> re: the vfs patch discussion [1]. I've put it in pretty much the most
> basic form, but I think there are a couple aspects worth thinking about:
> 
> 1. Use and frequency of start_poll_synchronize_rcu() (vs.
> get_state_synchronize_rcu()). The former is a bit more active than the
> latter in that it triggers the start of a grace period, when necessary.
> This currently invokes per inode, which is the ideal frequency in
> theory, but could be reduced, associated with the xfs_inogegc thresholds
> in some manner, etc., if there is good reason to do that.

If you rm -rf $path, do each of the inodes get a separate rcu state, or
do they share?

> 2. The rcu cookie lifecycle. This variant updates it on inactivation
> queue and nowhere else because the RCU docs imply that counter rollover
> is not a significant problem. In practice, I think this means that if an
> inode is stamped at least once, and the counter rolls over, future
> (non-inactivation, non-unlinked) eviction -> repopulation cycles could
> trigger rcu syncs. I think this would require repeated
> eviction/reinstantiation cycles within a small window to be noticeable,
> so I'm not sure how likely this is to occur. We could be more defensive
> by resetting or refreshing the cookie. E.g., refresh (or reset to zero)
> at recycle time, unconditionally refresh at destroy time (using
> get_state_synchronize_rcu() for non-inactivation), etc.
> 
> Otherwise testing is ongoing, but this version at least survives an
> fstests regression run.
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-fsdevel/164180589176.86426.501271559065590169.stgit@mickey.themaw.net/
> 
>  fs/xfs/xfs_icache.c | 11 +++++++++++
>  fs/xfs/xfs_inode.h  |  3 ++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d019c98eb839..4931daa45ca4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -349,6 +349,16 @@ xfs_iget_recycle(
>  	spin_unlock(&ip->i_flags_lock);
>  	rcu_read_unlock();
>  
> +	/*
> +	 * VFS RCU pathwalk lookups dictate the same lifecycle rules for an
> +	 * inode recycle as for freeing an inode. I.e., we cannot repurpose the
> +	 * inode until a grace period has elapsed from the time the previous
> +	 * version of the inode was destroyed. In most cases a grace period has
> +	 * already elapsed if the inode was (deferred) inactivated, but
> +	 * synchronize here as a last resort to guarantee correctness.
> +	 */
> +	cond_synchronize_rcu(ip->i_destroy_gp);
> +
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	error = xfs_reinit_inode(mp, inode);
>  	if (error) {
> @@ -2019,6 +2029,7 @@ xfs_inodegc_queue(
>  	trace_xfs_inode_set_need_inactive(ip);
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags |= XFS_NEED_INACTIVE;
> +	ip->i_destroy_gp = start_poll_synchronize_rcu();

Hmm.  The description says that we only need the rcu synchronization
when we're freeing an inode after its link count drops to zero, because
that's the vector for (say) the VFS inode ops actually changing due to
free/inactivate/reallocate/recycle while someone else is doing a lookup.

I'm a bit puzzled why this unconditionally starts an rcu grace period,
instead of done only if i_nlink==0; and why we call cond_synchronize_rcu
above unconditionally instead of checking for i_mode==0 (or whatever
state the cached inode is left in after it's freed)?

--D

>  	spin_unlock(&ip->i_flags_lock);
>  
>  	gc = get_cpu_ptr(mp->m_inodegc);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c447bf04205a..2153e3edbb86 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -40,8 +40,9 @@ typedef struct xfs_inode {
>  	/* Transaction and locking information. */
>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
>  	mrlock_t		i_lock;		/* inode lock */
> -	atomic_t		i_pincount;	/* inode pin count */
>  	struct llist_node	i_gclist;	/* deferred inactivation list */
> +	unsigned long		i_destroy_gp;	/* destroy rcugp cookie */
> +	atomic_t		i_pincount;	/* inode pin count */
>  
>  	/*
>  	 * Bitsets of inode metadata that have been checked and/or are sick.
> -- 
> 2.31.1
> 
