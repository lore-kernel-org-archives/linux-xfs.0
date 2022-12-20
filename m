Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7238C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 16:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiLTQ2L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiLTQ2K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 11:28:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7CE1AA08
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 08:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64B5461467
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 16:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C804CC433F0;
        Tue, 20 Dec 2022 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671553688;
        bh=PnrpduKUc/9lIteXujS2o+3YHyQYwdNBX/h3IlRnJl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=teqNJQtQvKjBgFKxBcHbSN/dLuBepo/XZXXgHs6L8dqdb/IYkTIak7eHg6ESsaFjB
         bPF7uzNzze6WxnA0giywYEt0f7Bxv+50Px13h68qoWo4kP2cu76Q6dWlwveYeofCtS
         bBZGXJChley5ktB7xbiaBJmQB5KZ9WuE3vELfzRP4lBZwucRMDHl30Cg3bh3I2MIhc
         lyzWMFEs24MLMB4463Hn9ZCjBDedZN31OqrbMsjVCpTno7wUPevPPF9dKXD+/xBlhe
         J0A/zqeDRjLpaYrWtzGuT2jlzwU/OxiADhveQvhHG9cE1nxGRnz203nhYNLacstyLD
         7Qt6Uw76E+pdQ==
Date:   Tue, 20 Dec 2022 08:28:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: don't stall background reclaim on inactvation
Message-ID: <Y6HimJkzwH2yG1dq@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149470870.336919.10695086693636688760.stgit@magnolia>
 <20221220044908.GH1971568@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220044908.GH1971568@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 03:49:08PM +1100, Dave Chinner wrote:
> On Mon, Dec 19, 2022 at 04:05:08PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The online fsck stress tests deadlocked a test VM the other night.  The
> > deadlock happened because:
> > 
> > 1. kswapd tried to prune the sb inode list, xfs found that it needed to
> > inactivate an inode and that the queue was long enough that it should
> > wait for the worker.  It was holding shrinker_rwsem.
> > 
> > 2. The inactivation worker allocated a transaction and then stalled
> > trying to obtain the AGI buffer lock.
> > 
> > 3. An online repair function called unregister_shrinker while in
> > transaction context and holding the AGI lock.  It also tried to grab
> > shrinker_rwsem.
> > 
> > #3 shouldn't happen and was easily fixed, but seeing as we designed
> > background inodegc to avoid stalling reclaim, I feel that #1 shouldn't
> > be happening either.  Fix xfs_inodegc_want_flush_work to avoid stalling
> > background reclaim on inode inactivation.
> 
> Yup, I see what you are saying, but I specifically left GFP_KERNEL
> reclaim to throttle on inodegc if necessary.  kswapd runs in
> GFP_KERNEL context - it's the only memory reclaim context where it
> is actually safe to block in this manner in the filesystem. The
> question becomes one of whether we allow kswapd to ignore inodegc
> queue limits.
> 
> Before the background inodegc, we used to do all the xfs_inactive()
> work in ->destroy_inode, directly from the VFS inode cache shrinker
> context run by GFP_KERNEL memory reclaim contexts such as kswapd().
> IOWs, causing kswapd to wait while we run inactivation in the VFS
> inode cache shrinker context is something we've done for a long
> time. kswapd did:
> 
> 	vfs inode shrinker
> 	  destroy inode
> 	    xfs_inactive()
> 	    mark inode inactivated
> 	    update radix tree tags
> 
> And then the XFS inode shrinker walks INACTIVATED inodes and frees
> them.
> 
> Now the code does:
> 
> 	vfs inode shrinker
> 	  NEED_INACTIVE
> 	  -> inodegc queue
> 	     if (throttle needed)
> 		flush_work(gc->work);
> 	  return
> 
> Then some time later in a different context inodegc then runs and
> we do:
> 
> 	xfs_inactive
> 	INACTIVATED
> 
> And then sometime later in a different context the XFS inode
> shrinker walks INACTIVATED inodes and frees them.
> 
> Essentially, without throttling the bulk of the memory freeing work
> is shifted from the immediate GFP_KERNEL reclaim context to some
> later GFP_KERNEL reclaim context.
> 
> For small memory reclaim scans (i.e. low priority shrinker
> invocations) this doesn't matter - we aren't at risk of OOM in these
> situations, and these are the typical situations in which memory
> reclaim is needed. Generally speaking the the background work is
> fast enough that memory is freed before shortages escalate.
> 
> However, when we have large inode caches and a significant memory
> demand event, we get into the situation where reclaim might be
> scanning a hundreds of thousands of cached VFS inodes at a time.

...and the problem with removing the flush_workqueue() calls from
background reclaim is that it doesn't know that xfs will try to push
things out of memory in a different thread, because there's no way to
tell it that we're separately working on freeing XXX bytes?

> We kinda need to stall kswapd in these cases - it may be the only
> reclaim context that can free inodes - and we need to avoid kswapd
> dumping all the freeable inodes on the node to a queue that isn't
> being processed, decided it has no more memory that can be freed
> because all the VFS inodes have gone and there's nothing reclaimable
> on the XFS inode lists, so it declares OOM when we have hundreds of
> thousands of freeable inodes sitting there waiting for inodegc to
> run.

Ah, yep.  XFS has no way to convey this to background reclaim, and
reclaim might not even be able to make much use of that information,
because anyone supplying it could be (a) wrong or (b) unable to free the
objects within whatever timeframe reclaim needs.  Thinking ahead, even
if XFS could give the shrinker an ETA, reclaim would still end up
waiting.  I suppose it might be nice for reclaim to trigger multiple
asynchronous freeings and wait on all of them, but that just shifts the
question to "how does xfs know how long it'll take?" and "how many more
cleverness beans will it take for support to figure out the system has
wedged itself in this weird state?"

Right now we at least get a nice compact stack trace when xfs stalls
background reclaim.

> I note that inodes queued for inodegc are not counted as reclaimable
> XFS inodes, so for the purposes of shrinkers those inodes queued on
> inodegc disappear from the shrinker accounting compeltely. Maybe we
> could consider a separate bug hidden by the inodegc throttling -
> maybe that's the bug that makes throttling kswapd on inodegc
> necessary.
> 
> But this re-inforces my point - I don't think we can just make
> kswapd skip inodegc throttling without further investion into the
> effect on performance under memory pressure as well as OOM killer
> resistance. It's likely a solvable issue, but given how complex and
> subtle the inode shrinker interactions can be, I'd like to make sure
> we don't wake a sleeping dragon here....

Ah, ok.  I'll drop this then.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
