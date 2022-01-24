Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8A6C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 15:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243215AbiAXPCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240244AbiAXPCd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 10:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643036553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8EquiIcUBJfn8xcqQL5HufGk41Op3sdFjRnJQbDAs8=;
        b=YNXTY8sjkGEd+DMncRYkZ0lY6OYCFI15IRZXDsGM+jRaTw9fBueljPz3JAoncBzfXoGOqi
        UgmK5ANOIfQLAoLzedpoImJMuzXxKuudgd2VYAkqcdTfc/XIytVVPhOy/UZVAH5GDTOnuT
        qWKD+81CSEeu0dthnSfZedywGSIwKU0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-8Vd8xz3WN6G3N3lNO4S6_A-1; Mon, 24 Jan 2022 10:02:32 -0500
X-MC-Unique: 8Vd8xz3WN6G3N3lNO4S6_A-1
Received: by mail-qk1-f197.google.com with SMTP id b13-20020a05620a270d00b0047ba5ddde8dso12472022qkp.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 07:02:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E8EquiIcUBJfn8xcqQL5HufGk41Op3sdFjRnJQbDAs8=;
        b=eRwncEU35zG5vEQtoMMvr6izdLoGWpny2Oi5g98pzNkeH3G8wcI/x9U2ycRTiHWB32
         AqgCsKmOhKE4me7LQddCsFbqainOBOUwkpgIKZaaZlXEJ8B1zwNvwgTXGfpYgX8VM41s
         pavvJG3YqY79KV5ZgP2d+tNschxCZeueKQRokKpCx5sJE9tB00+9v1S85BI+QADis9lJ
         4VUNjbgqZw62vQYzqcP6NWFdhCqokxDMhLAQDpzGwsfNRktKRmeiYSQywO40JGH19wXr
         b7T1uUANELxjS2IFiHxXdPF2MC8+eKQF8YyJajr9XZbNjZnYhUJLyIUUaAYAvK+v5lMH
         NXog==
X-Gm-Message-State: AOAM532xz3CV6b6Ba4zLedwVVzoGiVw74J4aPzO+0D2ZI92qcq16I6qw
        A/R41eRPL/T60C333dUVQD75/FxvYxDfrRm3ePvyIXmfWVoL3j+nl/p8hX6ttn7DSEOgoWc6cvx
        KICxctpxvO1/uy3iOcLKwiYaSAStU1bbmn3rZ0GXHwHNneGQp2Epv33ujgRiknJM9T0dS0wg=
X-Received: by 2002:a05:6214:c22:: with SMTP id a2mr12044807qvd.112.1643036550778;
        Mon, 24 Jan 2022 07:02:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNa9VV4aeR0cBjNt9B3fsuOxQGJbUorLWhJO4QneUIHZdgH4UMrDx6YX7oXruOjGv6CByNDw==
X-Received: by 2002:a05:6214:c22:: with SMTP id a2mr12044717qvd.112.1643036549979;
        Mon, 24 Jan 2022 07:02:29 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id j14sm7770487qkp.70.2022.01.24.07.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:02:29 -0800 (PST)
Date:   Mon, 24 Jan 2022 10:02:27 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <Ye6/g+XMSyp9vYvY@bfoster>
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
> 
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
> require inactivation, we only need to poll and assign RCU state in
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
> 
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

FYI, I modified my repeated alloc/free test to do some batching and form
it into something more able to measure the potential side effect / cost
of the grace period sync. The test is a single threaded, file alloc/free
loop using a variable per iteration batch size. The test runs for ~60s
and reports how many total files were allocated/freed in that period
with the specified batch size. Note that this particular test ran
without any background workload. Results are as follows:

	files		baseline	test

	1		38480		38437
	4		126055		111080
	8		218299		134469
	16		306619		141968
	32		397909		152267
	64		418603		200875
	128		469077		289365
	256		684117		566016
	512		931328		878933
	1024		1126741		1118891

The first column shows the batch size of the test run while the second
and third show results (averaged across three test runs) for the
baseline (5.16.0-rc5) and test kernels. This basically shows that as the
inactivation queue more efficiently batches removals, the number of
stalls on the allocation side increase accordingly and thus slow the
task down. This becomes significant by around 8 files per alloc/free
iteration and seems to recover at around 512 files per iteration.
Outside of those values, the additional overhead appears to be mostly
masked.

I'm not sure how realistic this sort of symmetric/predictable workload
is in the wild, but this is more designed to show potential impact of
the change. The delay cost can be shifted to the remove side to some
degree if we wanted to go that route. E.g., a quick experiment to add an
rcu sync in the inactivation path right before the inode is freed allows
this test to behave much more in line with baseline up through about the
256 file mark, after which point results start to fall off as I suspect
we start to measure stalls in the remove side.

That's just a test of a quick hack, however. Since there is no real
urgency to inactivate an unlinked inode (it has no potential users until
it's freed), I suspect that result can be further optimized to absorb
the cost of an rcu delay by deferring the steps that make the inode
available for reallocation in the first place. In theory if that can be
made completely asynchronous, then there is no real latency cost at all
because nothing can use the inode until it's ultimately free on disk.
However in reality we must have thresholds and whatnot to ensure the
outstanding queue cannot grow out of control. My previous experiments
suggest that an RCU delay on the inactivation side is measureable via a
simple 'rm -rf' with the current thresholds, but can be mitigated if the
pipeline/thresholds are tuned up a bit to accomodate the added delay.
This has more complexity and tradeoffs, but IMO, this is something we
should be thinking about at least as a next step to something like this
patch.

Brian

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

