Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA3EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbiEPDXg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiEPDXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:23:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FA719F96
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB6060EBE
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CB1C385B8;
        Mon, 16 May 2022 03:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671411;
        bh=GOmPsK/dJymb0S4acfxF87qxh+yYKUXbDLoO1QL6gqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qsr+tXjq0GHSb3NSC/nxh2ZKcPz2bkeYsJp5NMCwIciopyXsSsuB9IoELZMMwzeON
         rRHiA38x67RrnnT2NgCfe6pZsk6omwxPYQxGFq1//FVZYIvMfjVMmRpl76vf691cTh
         5+X0iy7hc/v9h6UM2IHC7jwMO11EbMFTx6xDHDrohf9MYg4ZW9jKr32t8c5utQAYxO
         qlYhRYHcCN0cYt7dSTMp/lSsZahmUwJm/RBvCDqZCFpRqURGT+AUYnU5LNyiO3PJJI
         5ylkIHBfVeAuV7cu438jU6OrB/izNeMt8fbOW+EY/yQuZMX+boADt9VlGKmpDYa012
         1iygdE9fqppig==
Date:   Sun, 15 May 2022 20:23:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next tree updated to
 efd409a4329f6927795be5ae080cd3ec8c014f49
Message-ID: <YoHDsvzqx6kx1rzI@magnolia>
References: <20220512060302.GI2306852@dread.disaster.area>
 <Yn7hn9i0Y9Iv1Xjd@magnolia>
 <YoFXYS4SwG/Nze+B@magnolia>
 <20220515222010.GM1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515222010.GM1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 16, 2022 at 08:20:10AM +1000, Dave Chinner wrote:
> On Sun, May 15, 2022 at 12:41:21PM -0700, Darrick J. Wong wrote:
> > On Fri, May 13, 2022 at 03:54:23PM -0700, Darrick J. Wong wrote:
> > > On Thu, May 12, 2022 at 04:03:02PM +1000, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > I've just pushed out a new for-next branch for XFS. You can find it
> > > > here:
> > > > 
> > > > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > > > 
> > > > This update contains the new Logged Attribute Replay functionality
> > > > that Allison has been toiling over for a very long time. She has
> > > > completely restructured how the attribute code works to lay the
> > > > ground work for functionality that require attributes to be
> > > > manipulated as part of complex atomic operations. This update
> > > > includes that functionality as a new experimental feature which can
> > > > be turned on via sysfs knob.
> > > > 
> > > > Great work, Allison, and thank you for all your hard work and help
> > > > during this merge window so we could get to this point!
> > > 
> > > Yay!!
> > > 
> > > I ran this on the fstests cloud overnight, and I noticed complaints from
> > > xfs/434 that we're leaking xfs_da_state objects.  I turned on kmemleak
> > > checking, which pointed out that the removexattr code path seems to be
> > > attaching a da state to the xfs_attr_item structure and never freeing
> > > it. 
> 
> Yes, I suspected that there were issues here from combining the two
> paths - the fill/refill state sidelining changes the way dastate
> paths were used for the removexattr path, and the original set-iter
> path used da_state structures fundamentally differently to the
> remove_iter path. So I'm not surprised that there's a leak somewhere
> in there - KASAN/kmemleak testing was somethign I planned for this
> week, but you've beaten me to turning it on....

<nod> I turned it on early because xfs/434 is still tripping over
leaked dquots, though annoyingly that problem goes away once I turn on
kmemleak.

> > > I don't know if the delayed attrs state machine actually needs that
> > > state as it runs through the remove states, but my dumb solution is to
> > > free xfs_attr_item.xattri_da_state (if it's still attached) right before
> > > we free the xfs_attr_item.
> 
> Yeah, I think it used to be freed at the equivalent of XFS_DAS_DONE
> before the integration, so this isn't unreasonable.

<nod>

> > > I also noticed that the attri recovery code doesn't reject unknown bits
> > > in the alfi_op_flags and alfi_attr_flags fields, so I added a couple of
> > > fixpatches to abort log recovery if either of those fields have bits set
> > > that we don't recognize.
> 
> *nod*
> 
> > > While I was poking around in there, I also found a few things that
> > > should probably get cleaned up, such as the alfi_op_flags shouldn't be
> > > in the XFS_ATTR_* namespace since higher level xattr code already uses
> > > it.
> 
> Oh, you mean the name needs changing, not that there's something
> wrong with the code?

Right.   XFS_ATTR_CREATE and XFS_ATTR_OP_FLAGS_SET apply to different
data structures.

> > > Question: the alfi_attr_flags are really just the attr_filter flags from
> > > the da_state structure, right?  I renamed the field and gave the flags
> > > their own XFS_XATTRI_FILTER_* namespace.
> 
> I don't think that's correct. The filter flags contain the on-disk
> namespace for the attribute we are operating on (XFS_ATTR_ROOT,
> XFS_ATTR_SECURE, XFS_ATTR_PARENT, etc). It also contains the LOCAL
> and INCOMPLETE flags, too, which aren't namespace bits but indicate
> on-disk state of the xattr.
> 
> IOWs, they are already well known on-disk flags, and I don't think
> adding a separate namespace for it improves anything - it's
> confusing enough trying to work out how the INCOMPLETE flag
> interacts with XFS_ATTR_NSP_ONDISK_MASK and attr_filter without
> adding a whole new set of names for the same on-disk namespace
> flags...

<nod> Ok, I'll change it to use the same mask for validation that we for
validating xattr keys.

> > > Moving along, I noticed that we weren't creating a separate slab cache
> > > for xfs_attr_item intent items, like we (now) do for the other deferred
> > > work items, so I modified the runtime paths to use a slab cache (the
> > > mega-item created by recovery gets left alone) and rearranged the struct
> > > to reduce its size from 96 to 88 bytes.  Now we can cram 46 items into a
> > > memory page instead of 32!
> 
> Nice cleanup!
> 
> > > Also, I moved the attri and attrd log item cache initialization to
> > > xfs_super.c to go with all the other log intent item cache
> > > initializations, and renamed xfs_attr_item to xfs_attr_intent because
> > > all the other high level deferred work state structures have type names
> > > that end in _intent.
> 
> Ok. I've got "clean up subsystem init" in my notes here, sounds like
> you've already done that. :)

<nod> I'll send out the patches, though (since it's still Sunday night)
I won't get to making the adjustments I just mentioned until tomorrow.

> > > > The other functionality in the merge is the removal of all the quota
> > > > warning infrastructure. The has never been used on Linux and really
> > > > has no way of being used, so these changes clean up and remove the
> > > > remaining pieces we never will use.
> > > 
> > > AFAICT the only tests changes that were needed are to silence the EINVAL
> > > returns when we try to set the quota warning counters in xfs/050,
> > > xfs/153, and xfs/299.  Does that square with everyone else's
> > > experiences?
> 
> Yeah, I think those are the only three. I'll run those patches
> today.

Ok good.

> > > > At this point in the cycle (almost at -rc7) I'm not going to merge
> > > > any more new functionality. I'm planning to spend the next week:
> > > > 
> > > > - more thoroughly testing a wider range of configurations
> > > > - recoveryloop soak testing
> > > > - fixing up all the tests that now fail due to changes merged during
> > > >   the cycle
> > > > - addressing any regressions and failures that I find
> > > 
> > > I finally diagnosed the regressions I was seeing in xfs/314 and xfs/313
> > > on aarch64 all throughout 5.18.
> 
> Yay!
> 
> > > Sooo ... willy (I hope) is soon to become the pagecache maintainer and
> > > clearly disagrees[1] with the current XFS behavior of invalidating and
> > > clearing uptodate on a folio on write error.  I /think/ we can finally
> > > let go of this quirk of ours and make XFS behave just like any other
> > > Linux filesystem, since (AFAICT) there isn't any downside to leaving the
> > > folio uptodate and !dirty.
> 
> Sure, seems like the right time to make things more consistent with
> the rest of the filesystem writeback path behaviours....

<nod>

> > > 
> > > [1] https://lore.kernel.org/linux-xfs/Yg04X73lr5YK5kwH@casper.infradead.org/
> > > 
> > > If the program notices the EIO and redirties the file we go through the
> > > same write paths as we did before; and if the program doesn't care, the
> > > cached contents will remain in RAM until the folio is evicted or someone
> > > dirties it again.  It's true that if nobody redirties the page then the
> > > contents will be lost at some point, but that's already true.
> > > 
> > > I'm testing a patch that removes the part of iomap that clears uptodate
> > > and the part of xfs that invalidates the folio.  We'll see how that
> > > goes.
> 
> What happens to the delalloc extent backing the file offset the
> failed folio covers?

The delalloc reservations still get deleted.  It's just the folio
invalidation and state changes that no longer happen.

> > > > - preparing for an early pull request during the merge window
> > > > 
> > > > I know of one failure that still needs to be analysed when LARP is
> > > > enabled - the new recovery test fails on 1kB block size filesystems
> > > > here. Otherwise, I did not see any unexpected failures during
> > > > overnight testing on default configs, rmapbt=1, all quotas enabled,
> > > > 1kB block size or V4 only testing.
> > > 
> > > Hmm.  I don't test recoveryloop on 1k block filesystems, I guess I
> > > should... :P  Aside from the handful of issues I laid out in this reply,
> > > everything *else* seems pretty solid.  I haven't tried larp mode or
> > > nrext64=1 mode yet though.
> > 
> > I turned on LARP mode Friday night and found a second da state leak and
> > a kernel crash when relogging an xattri log item.
> > 
> > The da state leak happens under a setxattr call to replace an attr.  I
> > think what's going on is that _attr_set_iter finds the old name and
> > removes it without freeing the da state structure.
> 
> Yeah, that'll probably be the same leak as the removexattr you've
> already seen, as replace recovery starts with a remove...

Yup.

> > Once we roll to
> > NODE_ADD state, we call xfs_attr_node_addname_find_attr to (re)compute
> > the location of the new attr in the node-format structure without
> > freeing the old da state structure, so that just leaks.
> 
> *nod*

Yeah.  In the end I decided to clean up xfs_attr_node_hasname's calling
conventions because the whole "maybe pass out a pointer or maybe don't"
was confusing and the source of at least one or two bugs.  

> > The crash seems to be happening when we have a long chain of xattr work
> > racing with another thread making changes elsewhere and flushing the
> > log.  At the start of the delayed attr work, we log an xattri log item,
> > with the caller's name and value buffers attached.  When the CIL
> > commits, we use those buffers to format the log item, and ->iop_commit
> > sets the pointers to NULL.  At this point the other thread(s) manage to
> > write to and flush the log enough times that we end up in a new
> > checkpoint.  Seeing this, the deferred work manager makes the xattr
> > writer relog the xattri log item.  The _relog method tries to memcpy the
> > name and value into a new buffer, but crashes because we already nulled
> > out the pointers, and kaboom.
> 
> I haven't see that one. As I went over the attr intent logging, I
> thought that it needed to be rewritten to use a reference counted
> name/value buffer so that we could elide all the extra CIL shadow
> buffer allocation and copying that is done every time we roll the
> xattr transaction and create a new intent. I was looking at this
> more from an efficiency POV (reduced CPU/memory cost per large xattr
> logged) than a correctness POV, but I suspected there might be
> correctness issues there as well.
> 
> My tentative plan is that we allocate the buffer structure when the
> attri does right now, but we modify the log iovec copy routinues to
> be able to take a stable buffer by reference instead of copying it.
> That way it can propagate into the CIL and it doesn't need to null
> any pointers - when the CIL releases the intent item, it just drops
> the reference on the name/val structure.
> 
> That way the same name/value structure is used repeatedly instead of
> repeated alloc/copy/free, and it's life time is bound by the
> first/last reference rather than a specific execution context as it
> is now with the xattrip.

<nod> I had a feeling that we were likely to end up at refcounted
name/value buffers.  ISTR Allison used to have it written that way but
changed it to the current style on account of review comments, but she
likely remembers that context far better than I.

> > I'm not sure how to fix that -- if nobody flushes the log, the attri
> > items can stick around in memory until the CIL is being committed,
> > right?  But that could be long after the original writer thread has
> > returned to userspace, which means that (a) we can't just not drop the
> > name/value buffer pointers from the xattr_log_item structure at commit
> > time so that relog works, and (b) I think implies UAF bugs during log
> > item formatting, perhaps?
> 
> Yeah, I think you might be right. I hadn't looked quite that deeply
> into this code. I have notes that say "we need to reduce the
> overhead of this" and I'm sure as soon as I started on that I'd
> notice the issues that you've already uncovered.
> 
> That said, I don't think this is essential to fix for the upcoming
> merge window because the experimental tag is intended to allow us
> time to discover and fix these sorts of unexpected problems that
> wider use and testing will uncover.

Yes.  The leaks are (at the moment) a higher priority since I can
hit them in non-larp mode.  I'd also like to resolve the xattr log item
flags checking (even though it's EXPERIMENTAL) because in my experience
it's best to sand down those sharp edges before it ships in a Real Linus
Release. :)

--D

> > <shrug> It's still the weekend here, so that's just my idul
> > speculations.  I'm running the fixpatches through fstests one more time
> > before I start sending them to the list.
> 
> Thanks!
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
