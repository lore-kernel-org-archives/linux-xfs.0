Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E8AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 15 May 2022 19:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiEOTlZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 15:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiEOTlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 15:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F04913CF7
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 12:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF3E76112C
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 19:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBE3C385B8;
        Sun, 15 May 2022 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652643682;
        bh=8LVj/O6OA7DKB91WkzvWVKC1KeHG9w5OeGovU3ANq7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UA52PXISy1sJO3XoJoQH8UUYAdz9us/TXHpfGAdqmoC0Kd0Mkf+RBA+fFQa+j3yV7
         BfzyaO8LGx4vfyBqYnm+eStHBe1GuTzDQcnTLapOyKYz/xdbF+o1uoMN6p4WntZLqw
         s7NOKPDDGo8Jghc4rZLRasD0j007Ew6fR4fEo7LNtz8mFroi9QRc/bG6JHiKQx6Fby
         A0Wm0r84lq/H7IBehhfz+vaHcFR0I7wmLwshoM9HS6pIhPdoywfuBjfkiPt/lKoF8s
         hKkQFq6ANzVpIJ+bSgR4J5yaVKuxxAckB26Zz/MCFZTY2IYjYiAo0aHCvtbf3pUYOu
         t0hZxoj12qzow==
Date:   Sun, 15 May 2022 12:41:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next tree updated to
 efd409a4329f6927795be5ae080cd3ec8c014f49
Message-ID: <YoFXYS4SwG/Nze+B@magnolia>
References: <20220512060302.GI2306852@dread.disaster.area>
 <Yn7hn9i0Y9Iv1Xjd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn7hn9i0Y9Iv1Xjd@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 13, 2022 at 03:54:23PM -0700, Darrick J. Wong wrote:
> On Thu, May 12, 2022 at 04:03:02PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I've just pushed out a new for-next branch for XFS. You can find it
> > here:
> > 
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > 
> > This update contains the new Logged Attribute Replay functionality
> > that Allison has been toiling over for a very long time. She has
> > completely restructured how the attribute code works to lay the
> > ground work for functionality that require attributes to be
> > manipulated as part of complex atomic operations. This update
> > includes that functionality as a new experimental feature which can
> > be turned on via sysfs knob.
> > 
> > Great work, Allison, and thank you for all your hard work and help
> > during this merge window so we could get to this point!
> 
> Yay!!
> 
> I ran this on the fstests cloud overnight, and I noticed complaints from
> xfs/434 that we're leaking xfs_da_state objects.  I turned on kmemleak
> checking, which pointed out that the removexattr code path seems to be
> attaching a da state to the xfs_attr_item structure and never freeing
> it.  I don't know if the delayed attrs state machine actually needs that
> state as it runs through the remove states, but my dumb solution is to
> free xfs_attr_item.xattri_da_state (if it's still attached) right before
> we free the xfs_attr_item.
> 
> I also noticed that the attri recovery code doesn't reject unknown bits
> in the alfi_op_flags and alfi_attr_flags fields, so I added a couple of
> fixpatches to abort log recovery if either of those fields have bits set
> that we don't recognize.
> 
> While I was poking around in there, I also found a few things that
> should probably get cleaned up, such as the alfi_op_flags shouldn't be
> in the XFS_ATTR_* namespace since higher level xattr code already uses
> it.
> 
> Question: the alfi_attr_flags are really just the attr_filter flags from
> the da_state structure, right?  I renamed the field and gave the flags
> their own XFS_XATTRI_FILTER_* namespace.
> 
> Moving along, I noticed that we weren't creating a separate slab cache
> for xfs_attr_item intent items, like we (now) do for the other deferred
> work items, so I modified the runtime paths to use a slab cache (the
> mega-item created by recovery gets left alone) and rearranged the struct
> to reduce its size from 96 to 88 bytes.  Now we can cram 46 items into a
> memory page instead of 32!
> 
> Also, I moved the attri and attrd log item cache initialization to
> xfs_super.c to go with all the other log intent item cache
> initializations, and renamed xfs_attr_item to xfs_attr_intent because
> all the other high level deferred work state structures have type names
> that end in _intent.
> 
> > The other functionality in the merge is the removal of all the quota
> > warning infrastructure. The has never been used on Linux and really
> > has no way of being used, so these changes clean up and remove the
> > remaining pieces we never will use.
> 
> AFAICT the only tests changes that were needed are to silence the EINVAL
> returns when we try to set the quota warning counters in xfs/050,
> xfs/153, and xfs/299.  Does that square with everyone else's
> experiences?
> 
> > At this point in the cycle (almost at -rc7) I'm not going to merge
> > any more new functionality. I'm planning to spend the next week:
> > 
> > - more thoroughly testing a wider range of configurations
> > - recoveryloop soak testing
> > - fixing up all the tests that now fail due to changes merged during
> >   the cycle
> > - addressing any regressions and failures that I find
> 
> I finally diagnosed the regressions I was seeing in xfs/314 and xfs/313
> on aarch64 all throughout 5.18.  Matthew Wilcox turned on multipage
> folios for 5.18-rc1, which (as we talked about late last night on IRC)
> now has some bad interactions with writeback failures.  TLDR: if we
> create a gigantic folio, dirty it, and writeback fails on even a single
> sector, we'll toss the *entire* folio, even if that's hundreds of KB.
> 
> In my triage, I observed that aarch64 will create 256k folios to cache a
> file that has alternating 64k sections of holes and shared blocks.  For
> the file under test in xfs/314, 512k-576k is shared, 576k-640k is a
> hole, 640k-704k is shared, etc.  The program dirties 640k-1280k (which
> marks the folio covering 512-768k dirty), sets an error injection point
> on an rmap update, and fsyncs to initiate writeback.
> 
> Writeback seems to issue writes for the first 128K of the folio ok.  I
> suspect that it's overwriting the extent mapped to 512k-576k with the
> same contents, which is sorta dorky since it's unnecessary.  Next it
> writes 576k-640k, which requires allocating a delalloc region, which
> causes the fs to go down as soon as it issues the rmap update for the
> new allocation.  This causes the fs to go down, so iomap tries to call
> xfs_discard_folio to abort the writeback.  That in turn calls
> iomap_invalidate_folio, which sees that it's dealing with a multipage
> folio and invalidates the whole thing.
> 
> While writeback is still ongoing!
> 
> This I think is the root cause of the debug assertions tripping during
> ioend completion -- writeback tore down the iop, and now ioend can't
> find it and doesn't know what to do.  The folio invalidation makes
> things worse, since now umount will trip over the partially uptodate
> folios if they're still there at unmount time.
> 
> Sooo ... willy (I hope) is soon to become the pagecache maintainer and
> clearly disagrees[1] with the current XFS behavior of invalidating and
> clearing uptodate on a folio on write error.  I /think/ we can finally
> let go of this quirk of ours and make XFS behave just like any other
> Linux filesystem, since (AFAICT) there isn't any downside to leaving the
> folio uptodate and !dirty.
> 
> [1] https://lore.kernel.org/linux-xfs/Yg04X73lr5YK5kwH@casper.infradead.org/
> 
> If the program notices the EIO and redirties the file we go through the
> same write paths as we did before; and if the program doesn't care, the
> cached contents will remain in RAM until the folio is evicted or someone
> dirties it again.  It's true that if nobody redirties the page then the
> contents will be lost at some point, but that's already true.
> 
> I'm testing a patch that removes the part of iomap that clears uptodate
> and the part of xfs that invalidates the folio.  We'll see how that
> goes.
> 
> > - preparing for an early pull request during the merge window
> > 
> > I know of one failure that still needs to be analysed when LARP is
> > enabled - the new recovery test fails on 1kB block size filesystems
> > here. Otherwise, I did not see any unexpected failures during
> > overnight testing on default configs, rmapbt=1, all quotas enabled,
> > 1kB block size or V4 only testing.
> 
> Hmm.  I don't test recoveryloop on 1k block filesystems, I guess I
> should... :P  Aside from the handful of issues I laid out in this reply,
> everything *else* seems pretty solid.  I haven't tried larp mode or
> nrext64=1 mode yet though.

I turned on LARP mode Friday night and found a second da state leak and
a kernel crash when relogging an xattri log item.

The da state leak happens under a setxattr call to replace an attr.  I
think what's going on is that _attr_set_iter finds the old name and
removes it without freeing the da state structure.  Once we roll to
NODE_ADD state, we call xfs_attr_node_addname_find_attr to (re)compute
the location of the new attr in the node-format structure without
freeing the old da state structure, so that just leaks.

The crash seems to be happening when we have a long chain of xattr work
racing with another thread making changes elsewhere and flushing the
log.  At the start of the delayed attr work, we log an xattri log item,
with the caller's name and value buffers attached.  When the CIL
commits, we use those buffers to format the log item, and ->iop_commit
sets the pointers to NULL.  At this point the other thread(s) manage to
write to and flush the log enough times that we end up in a new
checkpoint.  Seeing this, the deferred work manager makes the xattr
writer relog the xattri log item.  The _relog method tries to memcpy the
name and value into a new buffer, but crashes because we already nulled
out the pointers, and kaboom.

I'm not sure how to fix that -- if nobody flushes the log, the attri
items can stick around in memory until the CIL is being committed,
right?  But that could be long after the original writer thread has
returned to userspace, which means that (a) we can't just not drop the
name/value buffer pointers from the xattr_log_item structure at commit
time so that relog works, and (b) I think implies UAF bugs during log
item formatting, perhaps?

<shrug> It's still the weekend here, so that's just my idul
speculations.  I'm running the fixpatches through fstests one more time
before I start sending them to the list.

--D

> > I would appreciate it if everyone could spend some cycles over the
> > next week running tests against this for-next branch. we've merged a
> > *lot* of new code this cycle so any extra test coverage we can get
> > at this time will help ensure we find regressions sooner rather than
> > later.
> > 
> > If I've missed anything that I should have picked up for this cycle,
> > please let me know ASAP so we can determine an appropriate merge
> > plan for it.
> 
> I've just sent my cleanup patches to the fstests cloud so you should
> have it Sunday(ish).
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > 
> > 
> > The following changes since commit 86810a9ebd9e69498524c57a83f1271ade56ded8:
> > 
> >   Merge branch 'guilt/xfs-5.19-fuzz-fixes' into xfs-5.19-for-next (2022-05-04 12:38:02 +1000)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > 
> > for you to fetch changes up to efd409a4329f6927795be5ae080cd3ec8c014f49:
> > 
> > ----------------------------------------------------------------
> > Head Commit:
> > 
> > efd409a4329f Merge branch 'xfs-5.19-quota-warn-remove' into xfs-5.19-for-next
> > 
> > ----------------------------------------------------------------
> > Allison Henderson (14):
> >       xfs: Fix double unlock in defer capture code
> >       xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
> >       xfs: Set up infrastructure for log attribute replay
> >       xfs: Implement attr logging and replay
> >       xfs: Skip flip flags for delayed attrs
> >       xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
> >       xfs: Remove unused xfs_attr_*_args
> >       xfs: Add log attribute error tag
> >       xfs: Add larp debug option
> >       xfs: Merge xfs_delattr_context into xfs_attr_item
> >       xfs: Add helper function xfs_attr_leaf_addname
> >       xfs: Add helper function xfs_init_attr_trans
> >       xfs: add leaf split error tag
> >       xfs: add leaf to node error tag
> > 
> > Catherine Hoang (3):
> >       xfs: remove quota warning limit from struct xfs_quota_limits
> >       xfs: remove warning counters from struct xfs_dquot_res
> >       xfs: don't set quota warning values
> > 
> > Dave Chinner (20):
> >       xfs: avoid empty xattr transaction when attrs are inline
> >       xfs: initialise attrd item to zero
> >       xfs: make xattri_leaf_bp more useful
> >       xfs: rework deferred attribute operation setup
> >       xfs: separate out initial attr_set states
> >       xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
> >       xfs: consolidate leaf/node states in xfs_attr_set_iter
> >       xfs: split remote attr setting out from replace path
> >       xfs: XFS_DAS_LEAF_REPLACE state only needed if !LARP
> >       xfs: remote xattr removal in xfs_attr_set_iter() is conditional
> >       xfs: clean up final attr removal in xfs_attr_set_iter
> >       xfs: xfs_attr_set_iter() does not need to return EAGAIN
> >       xfs: introduce attr remove initial states into xfs_attr_set_iter
> >       xfs: switch attr remove to xfs_attri_set_iter
> >       xfs: remove xfs_attri_remove_iter
> >       xfs: use XFS_DA_OP flags in deferred attr ops
> >       xfs: ATTR_REPLACE algorithm with LARP enabled needs rework
> >       xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify
> >       xfs: can't use kmem_zalloc() for attribute buffers
> >       Merge branch 'xfs-5.19-quota-warn-remove' into xfs-5.19-for-next
> > 
> >  fs/xfs/Makefile                 |    1 +
> >  fs/xfs/libxfs/xfs_attr.c        | 1641 ++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
> >  fs/xfs/libxfs/xfs_attr.h        |  198 ++++++++++--
> >  fs/xfs/libxfs/xfs_attr_leaf.c   |   64 +++-
> >  fs/xfs/libxfs/xfs_attr_remote.c |   37 +--
> >  fs/xfs/libxfs/xfs_attr_remote.h |    6 +-
> >  fs/xfs/libxfs/xfs_da_btree.c    |    4 +
> >  fs/xfs/libxfs/xfs_da_btree.h    |   10 +-
> >  fs/xfs/libxfs/xfs_defer.c       |   24 +-
> >  fs/xfs/libxfs/xfs_defer.h       |    3 +
> >  fs/xfs/libxfs/xfs_errortag.h    |    8 +-
> >  fs/xfs/libxfs/xfs_format.h      |    9 +-
> >  fs/xfs/libxfs/xfs_log_format.h  |   45 ++-
> >  fs/xfs/libxfs/xfs_log_recover.h |    2 +
> >  fs/xfs/libxfs/xfs_quota_defs.h  |    1 -
> >  fs/xfs/scrub/common.c           |    2 +
> >  fs/xfs/xfs_acl.c                |    4 +-
> >  fs/xfs/xfs_attr_item.c          |  824 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_attr_item.h          |   46 +++
> >  fs/xfs/xfs_attr_list.c          |    1 +
> >  fs/xfs/xfs_dquot.c              |   15 +-
> >  fs/xfs/xfs_dquot.h              |    8 -
> >  fs/xfs/xfs_error.c              |    9 +
> >  fs/xfs/xfs_globals.c            |    1 +
> >  fs/xfs/xfs_ioctl.c              |    4 +-
> >  fs/xfs/xfs_ioctl32.c            |    2 +
> >  fs/xfs/xfs_iops.c               |    2 +
> >  fs/xfs/xfs_log.c                |   41 +++
> >  fs/xfs/xfs_log.h                |    1 +
> >  fs/xfs/xfs_log_cil.c            |   35 +-
> >  fs/xfs/xfs_log_priv.h           |   34 ++
> >  fs/xfs/xfs_log_recover.c        |    2 +
> >  fs/xfs/xfs_ondisk.h             |    2 +
> >  fs/xfs/xfs_qm.c                 |    9 -
> >  fs/xfs/xfs_qm.h                 |    5 -
> >  fs/xfs/xfs_qm_syscalls.c        |   26 +-
> >  fs/xfs/xfs_quotaops.c           |    8 +-
> >  fs/xfs/xfs_sysctl.h             |    1 +
> >  fs/xfs/xfs_sysfs.c              |   24 ++
> >  fs/xfs/xfs_trace.h              |   32 +-
> >  fs/xfs/xfs_trans_dquot.c        |    3 +-
> >  fs/xfs/xfs_xattr.c              |    2 +-
> >  42 files changed, 2180 insertions(+), 1016 deletions(-)
> >  create mode 100644 fs/xfs/xfs_attr_item.c
> >  create mode 100644 fs/xfs/xfs_attr_item.h
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
