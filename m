Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E47C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 15:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiAXPMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:12:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240599AbiAXPMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 10:12:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643037170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vV80lCJ5KVlXRZiePNC0Sv0xW8xjwAJaIjgeNNFAlsw=;
        b=RV5vX7t1T+bd3dG5bx96p8WmY/h1yrIG6qoH8V0Cvx9rvL0iPk2ZlXIngmTdpkrmvxhho0
        rjhprXeou6DSsqfQfFDEWbXwp77vHnRNsyTmilvwOqru20I09ru7LIi8scrjJ105avuGv3
        AjrboWTJKT/nZSpdG9YZ63AxNbZEG/4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-coubw0vzOnOYHd2dQE-tGA-1; Mon, 24 Jan 2022 10:12:49 -0500
X-MC-Unique: coubw0vzOnOYHd2dQE-tGA-1
Received: by mail-qt1-f197.google.com with SMTP id l15-20020ac84ccf000000b002cf9424cfa5so1890111qtv.7
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 07:12:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vV80lCJ5KVlXRZiePNC0Sv0xW8xjwAJaIjgeNNFAlsw=;
        b=MjvuMVkrBXoOELdJItPCe3vBz420s/M2T8hls0ZC7l68az+7PkoOojwXGMI3cGQJUi
         Q41V4oPhPraZsM898bhw0V1UuRDeBCFv0Q4RhR/s/wsjExgwu9MERcGzd9nfplqLzzTy
         udHSJPWr0blcz+54NvUCBVmS3ZYUr2KQd217J6QVARYxbMqlXd6iD4Q7+u2/iZizNscA
         EN18QTOrwOtEsWNVFF5kAWSVi98cg56DXSICVfKDqW+BiohO8FHoanH1UQ8kAq9qxK1f
         Pap1qCRYEW7EOcC9TAEidBLbuO9AjKG+bhoVNx4KjU8RAT9X9DU+hLwHMNV5GY5df2DG
         6PYA==
X-Gm-Message-State: AOAM5319WmSqLbo1EoLh11lclXCafSTpYVL4nn7QuBe0fD7L+7KIG6gN
        Dkdqmnj+QaEGoGSzf1J4hDKdG6308h5xToLfnyJOroAJ8tqlDARHEJlB7cUFH/0y9Ebw7vMzfEc
        89ZnmRvN3953nlwAdoXfd
X-Received: by 2002:a05:620a:2886:: with SMTP id j6mr11541076qkp.316.1643037168071;
        Mon, 24 Jan 2022 07:12:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw8VqibDWBcp2XlS6PjDzyLG0KZSZRgO7Cxoj2cDzKY6/2wwtBLa7MrzJgE0cllNi5QdhWR/Q==
X-Received: by 2002:a05:620a:2886:: with SMTP id j6mr11541029qkp.316.1643037167601;
        Mon, 24 Jan 2022 07:12:47 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id c11sm7339117qte.28.2022.01.24.07.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:12:47 -0800 (PST)
Date:   Mon, 24 Jan 2022 10:12:45 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <Ye7B7SbCbTPp5jfG@bfoster>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <20220121172603.GR13540@magnolia>
 <Yer8iqBIcwfLwh5s@bfoster>
 <20220122053019.GE947480@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122053019.GE947480@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 09:30:19PM -0800, Paul E. McKenney wrote:
> On Fri, Jan 21, 2022 at 01:33:46PM -0500, Brian Foster wrote:
> > On Fri, Jan 21, 2022 at 09:26:03AM -0800, Darrick J. Wong wrote:
> > > On Fri, Jan 21, 2022 at 09:24:54AM -0500, Brian Foster wrote:
> > > > The XFS inode allocation algorithm aggressively reuses recently
> > > > freed inodes. This is historical behavior that has been in place for
> > > > quite some time, since XFS was imported to mainline Linux. Once the
> > > > VFS adopted RCUwalk path lookups (also some time ago), this behavior
> > > > became slightly incompatible because the inode recycle path doesn't
> > > > isolate concurrent access to the inode from the VFS.
> > > > 
> > > > This has recently manifested as problems in the VFS when XFS happens
> > > > to change the type or properties of a recently unlinked inode while
> > > > still involved in an RCU lookup. For example, if the VFS refers to a
> > > > previous incarnation of a symlink inode, obtains the ->get_link()
> > > > callback from inode_operations, and the latter happens to change to
> > > > a non-symlink type via a recycle event, the ->get_link() callback
> > > > pointer is reset to NULL and the lookup results in a crash.
> > > 
> > > Hmm, so I guess what you're saying is that if the memory buffer
> > > allocation in ->get_link is slow enough, some other thread can free the
> > > inode, drop it, reallocate it, and reinstantiate it (not as a symlink
> > > this time) all before ->get_link's memory allocation call returns, after
> > > which Bad Things Happen(tm)?
> > > 
> > > Can the lookup thread end up with the wrong inode->i_ops too?
> > > 
> > 
> > We really don't need to even get into the XFS symlink code to reason
> > about the fundamental form of this issue. Consider that an RCU walk
> > starts, locates a symlink inode, meanwhile XFS recycles that inode into
> > something completely different, then the VFS loads and calls
> > ->get_link() (which is now NULL) on said inode and explodes. So the
> > presumption is that the VFS uses RCU protection to rely on some form of
> > stability of the inode (i.e., that the inode memory isn't freed,
> > callback vectors don't change, etc.).
> > 
> > Validity of the symlink content is a variant of that class of problem,
> > likely already addressed by the recent inline symlink change, but that
> > doesn't address the broader issue.
> > 
> > > > To avoid this class of problem, isolate in-core inodes for recycling
> > > > with an RCU grace period. This is the same level of protection the
> > > > VFS expects for inactivated inodes that are never reused, and so
> > > > guarantees no further concurrent access before the type or
> > > > properties of the inode change. We don't want an unconditional
> > > > synchronize_rcu() event here because that would result in a
> > > > significant performance impact to mixed inode allocation workloads.
> > > > 
> > > > Fortunately, we can take advantage of the recently added deferred
> > > > inactivation mechanism to mitigate the need for an RCU wait in most
> > > > cases. Deferred inactivation queues and batches the on-disk freeing
> > > > of recently destroyed inodes, and so significantly increases the
> > > > likelihood that a grace period has elapsed by the time an inode is
> > > > freed and observable by the allocation code as a reuse candidate.
> > > > Capture the current RCU grace period cookie at inode destroy time
> > > > and refer to it at allocation time to conditionally wait for an RCU
> > > > grace period if one hadn't expired in the meantime.  Since only
> > > > unlinked inodes are recycle candidates and unlinked inodes always
> > > > require inactivation,
> > > 
> > > Any inode can become a recycle candidate (i.e. RECLAIMABLE but otherwise
> > > idle) but I think your point here is that unlinked inodes that become
> > > recycling candidates can cause lookup threads to trip over symlinks, and
> > > that's why we need to assign RCU state and poll on it, right?
> > > 
> > 
> > Good point. When I wrote the commit log I was thinking of recycled
> > inodes as "reincarnated" inodes, so that wording could probably be
> > improved. But yes, the code is written minimally/simply so I was trying
> > to document that it's unlinked -> freed -> reallocated inodes that we
> > really care about here.
> > 
> > WRT to symlinks, I was trying to use that as an example and not
> > necessarily as the general reason for the patch. I.e., the general
> > reason is that the VFS uses rcu protection for inode stability (just as
> > for the inode free path), and the symlink thing is just an example of
> > how things can go wrong in the current implementation without it.
> > 
> > > (That wasn't a challenge, I'm just making sure I understand this
> > > correctly.)
> > > 
> > > > we only need to poll and assign RCU state in
> > > > the inactivation codepath. Slightly adjust struct xfs_inode to fit
> > > > the new field into padding holes that conveniently preexist in the
> > > > same cacheline as the deferred inactivation list.
> > > > 
> > > > Finally, note that the ideal long term solution here is to
> > > > rearchitect bits of XFS' internal inode lifecycle management such
> > > > that this additional stall point is not required, but this requires
> > > > more thought, time and work to address. This approach restores
> > > > functional correctness in the meantime.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > Hi all,
> > > > 
> > > > Here's the RCU fixup patch for inode reuse that I've been playing with,
> > > > re: the vfs patch discussion [1]. I've put it in pretty much the most
> > > > basic form, but I think there are a couple aspects worth thinking about:
> > > > 
> > > > 1. Use and frequency of start_poll_synchronize_rcu() (vs.
> > > > get_state_synchronize_rcu()). The former is a bit more active than the
> > > > latter in that it triggers the start of a grace period, when necessary.
> > > > This currently invokes per inode, which is the ideal frequency in
> > > > theory, but could be reduced, associated with the xfs_inogegc thresholds
> > > > in some manner, etc., if there is good reason to do that.
> > > 
> > > If you rm -rf $path, do each of the inodes get a separate rcu state, or
> > > do they share?
> > 
> > My previous experiments on a teardown grace period had me thinking
> > batching would occur, but I don't recall which RCU call I was using at
> > the time so I'd probably have to throw a tracepoint in there to dump
> > some of the grace period values and double check to be sure. (If this is
> > not the case, that might be a good reason to tweak things as discussed
> > above).
> 
> An RCU grace period typically takes some milliseconds to complete, so a
> great many inodes would end up being tagged for the same grace period.
> For example, if "rm -rf" could delete one file per microsecond, the
> first few thousand files would be tagged with one grace period,
> the next few thousand with the next grace period, and so on.
> 
> In the unlikely event that RCU was totally idle when the "rm -rf"
> started, the very first file might get its own grace period, but
> they would batch in the thousands thereafter.
> 

Great, thanks for the info.

> On start_poll_synchronize_rcu() vs. get_state_synchronize_rcu(), if
> there is always other RCU update activity, get_state_synchronize_rcu()
> is just fine.  So if XFS does a call_rcu() or synchronize_rcu() every
> so often, all you need here is get_state_synchronize_rcu()().
> 
> Another approach is to do a start_poll_synchronize_rcu() every 1,000
> events, and use get_state_synchronize_rcu() otherwise.  And there are
> a lot of possible variations on that theme.
> 
> But why not just try always doing start_poll_synchronize_rcu() and
> only bother with get_state_synchronize_rcu() if that turns out to
> be too slow?
> 

Ack, that makes sense to me. We use call_rcu() to free inode memory and
obviously will have a sync in the lookup path after this patch, but that
is a consequence of the polling we add at the same time. I'm not sure
that's enough activity on our own so I'd probably prefer to keep things
simple, use the start_poll_*() variant from the start, and then consider
further start/get filtering like you describe above if it ever becomes a
problem.

> > > > 2. The rcu cookie lifecycle. This variant updates it on inactivation
> > > > queue and nowhere else because the RCU docs imply that counter rollover
> > > > is not a significant problem. In practice, I think this means that if an
> > > > inode is stamped at least once, and the counter rolls over, future
> > > > (non-inactivation, non-unlinked) eviction -> repopulation cycles could
> > > > trigger rcu syncs. I think this would require repeated
> > > > eviction/reinstantiation cycles within a small window to be noticeable,
> > > > so I'm not sure how likely this is to occur. We could be more defensive
> > > > by resetting or refreshing the cookie. E.g., refresh (or reset to zero)
> > > > at recycle time, unconditionally refresh at destroy time (using
> > > > get_state_synchronize_rcu() for non-inactivation), etc.
> 
> Even on a 32-bit system that is running RCU grace periods as fast as they
> will go, it will take about 12 days to overflow that counter.  But if
> you have an inode sitting on the list for that long, yes, you could
> see unnecessary synchronous grace-period waits.
> 
> Would it help if there was an API that gave you a special cookie value
> that cond_synchronize_rcu() and friends recognized as "already expired"?
> That way if poll_state_synchronize_rcu() says that original cookie
> has expired, you could replace that cookie value with one that would
> stay expired.  Maybe a get_expired_synchronize_rcu() or some such?
> 

Hmm.. so I think this would be helpful if we were to stamp the inode
conditionally (i.e. unlinked inodes only) on eviction because then we
wouldn't have to worry about clearing the cookie if said inode happens
to be reallocated and then run through one or more eviction -> recycle
sequences after a rollover of the grace period counter. With that sort
of scheme, the inode could be sitting in cache for who knows how long
with a counter that was conditionally synced against many days (or
weeks?) prior, from whenever it was initially reallocated.

However, as Dave points out that we probably want to poll RCU state on
every inode eviction, I suspect that means this is less of an issue. An
inode must be evicted for it to become a recycle candidate, and so if we
update the inode unconditionally on every eviction, then I think the
recycle code should always see the most recent cookie value and we don't
have to worry much about clearing it.

I think it's technically possible for an inode to sit in an inactivation
queue for that sort of time period, but that would probably require the
filesystem go idle or drop to low enough activity that a spurious rcu
sync here or there is probably not a big deal. So all in all, I suspect
if we already had such a special cookie variant of the API that was
otherwise functionally equivalent, I'd probably use it to cover that
potential case, but it's not clear to me atm that this use case
necessarily warrants introduction of such an API...

Brian

> 							Thanx, Paul
> 
> > > > Otherwise testing is ongoing, but this version at least survives an
> > > > fstests regression run.
> > > > 
> > > > Brian
> > > > 
> > > > [1] https://lore.kernel.org/linux-fsdevel/164180589176.86426.501271559065590169.stgit@mickey.themaw.net/
> > > > 
> > > >  fs/xfs/xfs_icache.c | 11 +++++++++++
> > > >  fs/xfs/xfs_inode.h  |  3 ++-
> > > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index d019c98eb839..4931daa45ca4 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > > @@ -349,6 +349,16 @@ xfs_iget_recycle(
> > > >  	spin_unlock(&ip->i_flags_lock);
> > > >  	rcu_read_unlock();
> > > >  
> > > > +	/*
> > > > +	 * VFS RCU pathwalk lookups dictate the same lifecycle rules for an
> > > > +	 * inode recycle as for freeing an inode. I.e., we cannot repurpose the
> > > > +	 * inode until a grace period has elapsed from the time the previous
> > > > +	 * version of the inode was destroyed. In most cases a grace period has
> > > > +	 * already elapsed if the inode was (deferred) inactivated, but
> > > > +	 * synchronize here as a last resort to guarantee correctness.
> > > > +	 */
> > > > +	cond_synchronize_rcu(ip->i_destroy_gp);
> > > > +
> > > >  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> > > >  	error = xfs_reinit_inode(mp, inode);
> > > >  	if (error) {
> > > > @@ -2019,6 +2029,7 @@ xfs_inodegc_queue(
> > > >  	trace_xfs_inode_set_need_inactive(ip);
> > > >  	spin_lock(&ip->i_flags_lock);
> > > >  	ip->i_flags |= XFS_NEED_INACTIVE;
> > > > +	ip->i_destroy_gp = start_poll_synchronize_rcu();
> > > 
> > > Hmm.  The description says that we only need the rcu synchronization
> > > when we're freeing an inode after its link count drops to zero, because
> > > that's the vector for (say) the VFS inode ops actually changing due to
> > > free/inactivate/reallocate/recycle while someone else is doing a lookup.
> > > 
> > 
> > Right..
> > 
> > > I'm a bit puzzled why this unconditionally starts an rcu grace period,
> > > instead of done only if i_nlink==0; and why we call cond_synchronize_rcu
> > > above unconditionally instead of checking for i_mode==0 (or whatever
> > > state the cached inode is left in after it's freed)?
> > > 
> > 
> > Just an attempt to start simple and/or make any performance
> > test/problems more blatant. I probably could have tagged this RFC. My
> > primary goal with this patch was to establish whether the general
> > approach is sane/viable/acceptable or we need to move in another
> > direction.
> > 
> > That aside, I think it's reasonable to have explicit logic around the
> > unlinked case if we want to keep it restricted to that, though I would
> > probably implement that as a conditional i_destroy_gp assignment and let
> > the consumer context key off whether that field is set rather than
> > attempt to infer unlinked logic (and then I guess reset it back to zero
> > so it doesn't leak across reincarnation). That also probably facilitates
> > a meaningful tracepoint to track the cases that do end up syncing, which
> > helps with your earlier question around batching, so I'll look into
> > those changes once I get through broader testing
> > 
> > Brian
> > 
> > > --D
> > > 
> > > >  	spin_unlock(&ip->i_flags_lock);
> > > >  
> > > >  	gc = get_cpu_ptr(mp->m_inodegc);
> > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > index c447bf04205a..2153e3edbb86 100644
> > > > --- a/fs/xfs/xfs_inode.h
> > > > +++ b/fs/xfs/xfs_inode.h
> > > > @@ -40,8 +40,9 @@ typedef struct xfs_inode {
> > > >  	/* Transaction and locking information. */
> > > >  	struct xfs_inode_log_item *i_itemp;	/* logging information */
> > > >  	mrlock_t		i_lock;		/* inode lock */
> > > > -	atomic_t		i_pincount;	/* inode pin count */
> > > >  	struct llist_node	i_gclist;	/* deferred inactivation list */
> > > > +	unsigned long		i_destroy_gp;	/* destroy rcugp cookie */
> > > > +	atomic_t		i_pincount;	/* inode pin count */
> > > >  
> > > >  	/*
> > > >  	 * Bitsets of inode metadata that have been checked and/or are sick.
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> > 
> 

