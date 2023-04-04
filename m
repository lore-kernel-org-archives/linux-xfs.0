Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E972C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjDDXKg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDDXKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BFA3AB0
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 16:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2750463646
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 23:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8D6C433D2;
        Tue,  4 Apr 2023 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680649831;
        bh=3jDdYC/naZ8iEuHUB0b38SMQVxhdJQNo/PJkbaIid2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVs2Fx5imY7SDmvNluNm378vYHmdLEWgLMxiJlUnboN7I2ZUyuEr+YqNxJtgQ7Tcl
         ECfumWGOR7QiSAkkTS+rG0cgfccD0r2WV27ToFqQiofVUrZXo6I5yrxutztoOGEJ9D
         fQZOTcomvSaguIF8VE6SXcyBbb2tEwGCj4gEVoSaD4Fbm+RhONfIEj4sh1TMRpbuav
         kjfirZE/9tjAaKMutkYWUhZyXNlj8j+MPwPJdvOOvtZp4g/YGLa/68/eLOJNgsio5E
         PeTwvlGPgqnowgo1d+WB2AOOx61iIp8e+y932l1QWFw5gvp5QjDhyMvLD/6+MSHGDR
         UGVIS3aP/AjjA==
Date:   Tue, 4 Apr 2023 16:10:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     allison.henderson@oracle.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE 1/2] xfs-linux: scrub-strengthen-rmap-checking updated
 to 64e6494e1175
Message-ID: <20230404231030.GB110000@frogsfrogsfrogs>
References: <168054442640.1440442.6704636180612529931.stg-ugh@frogsfrogsfrogs>
 <20230404021556.GK3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404021556.GK3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 12:15:56PM +1000, Dave Chinner wrote:
> On Mon, Apr 03, 2023 at 10:55:57AM -0700, Darrick J. Wong wrote:
> > Hi folks,
> > 
> > The scrub-strengthen-rmap-checking branch of my xfs-linux repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> > 
> > has just been updated for your review.
> > 
> > This code snapshot has been rebased against recent upstream, freshly
> > QA'd, and is ready for people to examine.  For veteran readers, the new
> > snapshot can be diffed against the previous snapshot; and for new
> > readers, this is a reasonable place to begin reading.  For the best
> > experience, it is recommended to pull this branch and walk the commits
> > instead of trying to read any patch deluge.
> > 
> > Here's the rebase against 6.3-rc5 of the online fsck design
> > documentation and all pending scrub fixes.  I've fixed most of the
> > low-hanging fruit that Dave commented on in #xfs.
> > 
> > (This isn't a true deluge, since I'm only posting this notice, not the
> > entire patchset.)
> 
> Notes as I go through the code (I'm ignoring the Documentation/
> stuff as Allison has been going through that with a fine toothed
> comb). I'm simply reading the output of:
> 
> $ git reset --hard v6.3-rc5
> $ git merge djwong/scrub-strengthen-rmap-checking
> $ git diff v6.3-rc5.. fs/xfs
> ....
> 
> and commenting as I see things, also leaning on the notes I had from
> the first, much slower, pass I did through this code over the past 3
> weeks.
> 
> ---
> 
> +xfs-$(CONFIG_XFS_DRAIN_INTENTS)        += xfs_drain.o
> 
> "drain" is kinda generic. That shows up like this:
> 
> +               xfs_drain_init(&pag->pag_intents);
> 
> Where it's clear that it's an intent drain. More generically, I think
> this is a deferred work drain which just happens to be a set of
> linked intents.
> 
> We already have the xfs_defer_* namespace for managing deferred
> work chains, so perhaps this API should be named xfs_defer_drain*
> to indicate what subsystem it interacts with.

IOWs,
xfs_defer_drain_init
      "        _free
      "        _grab
      "        _rele
      "        _busy
      "        _wait
      "        _wait_disable
      "        _wait_enable

?

Should be easy enough to fix.

> ---
> 
> xfs_perag_drain_intents -> xfs_perag_intent_drain()
> xfs_perag_intents_busy -> xfs_perag_intent_busy()
> 
> to keep namespace consistent with _intent_hold/rele() interface.

Ok.

> ---
> 
> xfs_extent_free_get_group(), xfs_extent_free_put_group().
> 
> These are actually grabbing/dropping the perag and bumping the
> deferred work drain count held in the pag->pag_intents. I'd much
> prefer a common interface that looks like:
> 
> xfs_perag_intent_get(mp, agno)
> {
> 	pag = xfs_perag_get(mp, agno);
> 	xfs_perag_intent_hold(pag);
> 	return pag;
> }
> 
> and then we have:
> 
> 	xefi->xefi_pag = xfs_perag_intent_get(mp,
> 				XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
> 
> and:
> 
> 	xfs_perag_intent_put(xefi->xefi_pag);
> 
> instead of the type specific wrappers that all do the same thing.
> 
> IOWs, we have an API where:
> 
> xfs_perag_intent_get()
> xfs_perag_intent_put()
> 
> Are used to get a perag reference with an intent drain hold, and:
> 
> xfs_perag_intent_hold()
> xfs_perag_intent_rele()
> 
> Are used to bump/drop the intent drain count when the intent already
> has a perag reference.
> 
> [ Repeat these comments for all intent _get/put_group() functions. ]

<nod> That makes sense.  I think newbt.c (in part2) is the only caller
that needs to xfs_perag_intent_hold having already gotten its own perag
reference.

> ---
> 
> General observation.
> 
> As a cleanup - not for this patchset - we should pass the perag to
> tracepoints, not the agno vi pag->pag_agno.

I'll do this afterwards so I can contain the pain of dealing with the
ftrace macro hell to a single patch.

> ---
> 
> General observation.
> 
> I like how the perag is migrating outward from the core alloc code
> into the callers (e.g. __xfs_free_extent()) as callers start to
> track perag references themselves. I also like ho9w callers are now
> asking for operations on {perag, agbno, len} tuples instead of
> {fsbno, len} tuples.

I like how that worked out too. :D

Eventually I think I'd like it even more if we could pass perag ref from
one intent to another instead of yet another xfs_perag_get call, but
that can come later.  I think the only place we need to do that are for
bmap updates and the swapext code.

> ---
> 
> xfs_alloc_complain_bad_rec(), xfs_bmap_complain_bad_rec(), et al.
> 
> Should these also dump a trace event recording the bad record?

trace-cmd -e printk to capture the dmesg contents?

Or do you want a specific tracepoint to dump the bad record as an ftrace
thing?

> ---
> 
> General observation.
> 
> ->diff_two_keys() method. Should we rename that ->keycmp()?

Yes, although I'd like to come up with a better name for ->key_diff at
the same time.

> ---
> 
> xfs_rmap_count_owners_helper():
> 
> First delta calc has a cast to (int64_t), second one doesn't. Don't
> both need the same cast (or lack of cast)?
> 
> 	roc->results->nono_matches++;
> 
> Clever name, but it's not a "no no" match (as in a match that should
> never happen) - that's what "badno_matches" are.
> 
> It's a non-owner match, so I think the variable names should be
> "nonowner_matches" and "bad_nonowner_matches" to avoid confusion
> when I next read the code....

Done.

> ---
> 
> xbitmap conversion to use interval trees. The logic looks ok and the
> way the callers use it look fine, but I'm not going to find
> off-by-one bugs in it just by reading the code. It's definitely an
> improvement on the previous code, though.

<nod> I'm hoping the interval trees are fairly bulletproof to off by one
errors.  If nothing else, I haven't found any bugs in here in months.

> ---
> 
> xchk_perag_lock() isn't really locking the perag. It's locking the
> AGF+AGI and ensuring there are no deferred operation chains in
> progress in the AG. xchk_ag_drain_and_lock()?

Yes, that's a much better name.

> ---
> 
> xchk_iget_agi() is a bit nasty. Lets chase that through.
> 
> read/lock AGI
> xfs_iget(tp, NORETRY|UNTRUSTED)
>   cache hit
>     can't get inode because, say, NEEDGC
>     return -EAGAIN
>   cache miss
>     xfs_imap
>       xfs_imap_lookup() (because UNTRUSTED)
>         read AGI
> 	  works only because AGI is locked in this transaction.
> 
> Ok, so the -EAGAIN return is only going to come through cache hit
> path, the cache miss path is not going to deadlock even though it
> needs the AGI we already have locked. Incore lookup will fail with
> EAGAIN if inactivation on the inode is required, and that may remove
> the inode from the unlinked list and hence need the AGI. Hence
> xchk_iget_agi() needs to drop the AGI lock on EAGAIN to allow
> inodegc to make progress and move the inode to IRECLAIMABLE state
> where xfs_iget will be able to return it again if it can lock the
> inode.
> 
> OK. Nasty, but looks like it is deadlock free. The comment above the
> function needs to document this special case handling for xfs_iget()
> returning -EAGAIN and the dependence on having a valid transaction
> context for the cache miss case to avoid deadlocking in
> xfs_imap_lookup() on the AGI lock.

<nod> I'll paste a version of that into xchk_iget_agi().

> ---
> 
> Looks like a lot of commonality between xchk_setup_inode() and
> xchk_iget_for_scrubbing() - same xfs-iget/xfs_iget_agi/xfs_imap
> checking logic - so maybe scope for a common helper function there?

I'll think about this tomorrow when my brain is less tired.  These two
functions are nearly the same, but I think the key difference is:

xchk_iget_for_scrubbing passes up -EFSCORRUPTED if the inode cluster
buffer fails the verifier; the incore verifiers (e.g. attr shortform)
fail to load; or the inobt search under the xfs_imap call fails
buffer verifiers.

xchk_setup_inode, on the other hand, ignores EFSCORRUPTED to try to fix
anything that's wrong with the icluster buffer that prevents the inode
cache from loading the inode.

I think those two could be combined, though that would require a flags
argument to switch the behaviors.

> ---
> 
> scrub/readdir.c
> 
> This looks to be a reimplementation of the normal readdir code just
> with a different callback to process the names that are found. I'd
> prefer not to have two copies of the readdir implementation in the
> code base - is it possible to use the filldir context and the
> existing readdir code to perform the scrub readdir walk function?

I tried to use the filldir code, but it drops the directory ILOCK after
taking the dirent buffer.  This is great for dir_emit since that means
we don't hold ILOCKs while copying things to userspace, but bad for
online fsck because now it has to deal with metadata changing because of
that lock cycling.

I initially thought I could deal with it, but my experiences (especially
with the parent pointers repair code) is that it's /much/ easier to
understand what's going on in repair if we keep the ILOCK for as long as
we possibly can, and document heavily the places where we pick back up
the ILOCK.

You might notice that I did the same thing for listxattr.  There's no
ILOCK cycling going on there, but we don't have to deal with the attr
cursor and whatnot there.  bfoster and I encountered a lot of confusion
trying to make sure all that worked right.

> Maybe that is for a later patchset....
> 
> ---
> 
> That's all I've noticed reading through the code - I'm not going to
> find off-by-one errors in the logic reading through a diff of this
> size:
> 
> 73 files changed, 4976 insertions(+), 1794 deletions(-)
> 
> The code changes largely make sense, the impact on the code outside
> fs/xfs/scrub appears to be largely minimal and there are some good
> cleanups and improvements in the code. I'll start running this
> through my limited QA resources right now (hardware failure has
> taken out my large test machine) but if it's anything like the
> previous version, I don't expect to find any regressions.
>
> I'll probably start on the second set of commits tomorrow....

Ok, thanks!!!

--D

> 
> Cheers,
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
