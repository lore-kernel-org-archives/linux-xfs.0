Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636C0C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 16:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbiAXQ5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 11:57:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241196AbiAXQ5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 11:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643043437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y+wGvmvWZugr1QaWPN8eosrn1d/LvfckuUtAxSfPUsw=;
        b=bDskQTGrNlBWTOP6//kJ1ZCM4nkzcPd2oS6SXgnZWx1XxWmQyNVPphhcri4hOY52MCUoFm
        hdGowT6sLhkWWZsF20wK0KOAj39RXwrDVDeiYXGXDF8XuIXqIdGLQnzlBxZPm0Za196hkX
        pfHFtBUPrL7bGbKeHIxIgLbtH4Ng28o=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-6MKhcZgtPqOZzFRZoan_Jg-1; Mon, 24 Jan 2022 11:57:16 -0500
X-MC-Unique: 6MKhcZgtPqOZzFRZoan_Jg-1
Received: by mail-qv1-f72.google.com with SMTP id ib7-20020a0562141c8700b0040812bc4425so18621330qvb.16
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 08:57:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+wGvmvWZugr1QaWPN8eosrn1d/LvfckuUtAxSfPUsw=;
        b=29ScVJNDmrU6jDK4KzOS9YtmSv+vyPxAmA6yGw+2N+t3irc1psI5MqFmr6QjT/mAlt
         ttUNinUZoegFUPaLX4jryMZiua2SD9Eg6/U+Vp1f22JQ/pi7KPzKt/3mma66SEwjLAsF
         zu7cXrRZWGmlQmTjynr+qNwr+aww7fd96VEJKmYqyty63nYGaTbVs/cKPZwtsFekMKFz
         FXiidP0GtNQSS2lft5wkn1FRGDWMvBhNYJuCK5dzuptyVNFNVySHvgQyolCdqeS+g6Js
         gLY6wvrq1zVNEwnRD0qN2ASO91bkSHjNF6Xk0QfFyJaJ+oEVVP1mjQE4jxS36iq2O7bR
         FaPA==
X-Gm-Message-State: AOAM530g1jwdgbPNjyIYnkczmRxnSEcuswL0DLOium0cRQsruJZmU8fZ
        eAJyUfTDerdJJx+kBDaWxGy1K7rY7ecODRrljKbXQp7zu2LXr59+dCprw6TrS1OiRcflg2if/cf
        Ahe9078m4tdeMzq7M0bV8
X-Received: by 2002:a05:622a:130c:: with SMTP id v12mr13369559qtk.76.1643043435186;
        Mon, 24 Jan 2022 08:57:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUMxja0vPGnXEhI63H/JySJOmPk82QlgfNrGAVidvQnJ8rDU2dPDvjPg6LVw23hpVCjvKIxg==
X-Received: by 2002:a05:622a:130c:: with SMTP id v12mr13369536qtk.76.1643043434652;
        Mon, 24 Jan 2022 08:57:14 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id f9sm6121247qkp.94.2022.01.24.08.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:57:14 -0800 (PST)
Date:   Mon, 24 Jan 2022 11:57:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <Ye7aaIUvHFV18yNn@bfoster>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
 <YeVxCXE6hXa1S/ic@bfoster>
 <20220118185647.GB13563@magnolia>
 <Yehvc4g+WakcG1mP@bfoster>
 <20220120003636.GF13563@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120003636.GF13563@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 19, 2022 at 04:36:36PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 19, 2022 at 03:07:15PM -0500, Brian Foster wrote:
> > On Tue, Jan 18, 2022 at 10:56:47AM -0800, Darrick J. Wong wrote:
> > > On Mon, Jan 17, 2022 at 08:37:13AM -0500, Brian Foster wrote:
> > > > On Fri, Jan 14, 2022 at 01:30:43PM -0800, Darrick J. Wong wrote:
> > > > > On Fri, Jan 14, 2022 at 02:45:10PM -0500, Brian Foster wrote:
> > > > > > On Fri, Jan 14, 2022 at 09:35:35AM -0800, Darrick J. Wong wrote:
> > > > > > > On Fri, Jan 14, 2022 at 09:38:10AM +1100, Dave Chinner wrote:
> > > > > > > > On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > > > > > > > > We've had reports on distro (pre-deferred inactivation) kernels that
> > > > > > > > > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > > > > > > > > lock when invoked on a frozen XFS fs. This occurs because
> > > > > > > > > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > > > > > > > > transaction alloc for an inode that requires an eofb trim. unfreeze
> > > > > > > > > then blocks on the same lock and the fs is deadlocked.
> > > > > > > > > 
> > > > > > > > > With deferred inactivation, the deadlock problem is no longer
> > > > > > > > > present because ->destroy_inode() no longer blocks whether the fs is
> > > > > > > > > frozen or not. There is still unfortunate behavior in that lookups
> > > > > > > > > of a pending inactive inode spin loop waiting for the pending
> > > > > > > > > inactive state to clear, which won't happen until the fs is
> > > > > > > > > unfrozen. This was always possible to some degree, but is
> > > > > > > > > potentially amplified by the fact that reclaim no longer blocks on
> > > > > > > > > the first inode that requires inactivation work. Instead, we
> > > > > > > > > populate the inactivation queues indefinitely. The side effect can
> > > > > > > > > be observed easily by invoking drop_caches on a frozen fs previously
> > > > > > > > > populated with eofb and/or cowblocks inodes and then running
> > > > > > > > > anything that relies on inode lookup (i.e., ls).
> > > > > > > > > 
> > > > > > > > > To mitigate this behavior, invoke internal blockgc reclaim during
> > > > > > > > > the freeze sequence to guarantee that inode eviction doesn't lead to
> > > > > > > > > this state due to eofb or cowblocks inodes. This is similar to
> > > > > > > > > current behavior on read-only remount. Since the deadlock issue was
> > > > > > > > > present for such a long time, also document the subtle
> > > > > > > > > ->destroy_inode() constraint to avoid unintentional reintroduction
> > > > > > > > > of the deadlock problem in the future.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > > > > ---
> > > > > > > > >  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
> > > > > > > > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > > > > > index c7ac486ca5d3..1d0f87e47fa4 100644
> > > > > > > > > --- a/fs/xfs/xfs_super.c
> > > > > > > > > +++ b/fs/xfs/xfs_super.c
> > > > > > > > > @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
> > > > > > > > >  }
> > > > > > > > >  
> > > > > > > > >  /*
> > > > > > > > > - * Now that the generic code is guaranteed not to be accessing
> > > > > > > > > - * the linux inode, we can inactivate and reclaim the inode.
> > > > > > > > > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > > > > > > > > + * inactivate and reclaim it.
> > > > > > > > > + *
> > > > > > > > > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > > > > > > > > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > > > > > > > > + * allocation in this context. A transaction alloc that blocks on frozen state
> > > > > > > > > + * from a context with ->s_umount held will deadlock with unfreeze.
> > > > > > > > >   */
> > > > > > > > >  STATIC void
> > > > > > > > >  xfs_fs_destroy_inode(
> > > > > > > > > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> > > > > > > > >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > > > > > > > >  	 */
> > > > > > > > >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > > > > > > > > +		struct xfs_icwalk	icw = {0};
> > > > > > > > > +
> > > > > > > > > +		/*
> > > > > > > > > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > > > > > > > > +		 * doesn't leave them sitting in the inactivation queue where
> > > > > > > > > +		 * they cannot be processed.
> > > > > > > > > +		 */
> > > > > > > > > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > > > > > > > > +		xfs_blockgc_free_space(mp, &icw);
> > > > > > > > 
> > > > > > > > Is a SYNC walk safe to run here? I know we run
> > > > > > > > xfs_blockgc_free_space() from XFS_IOC_FREE_EOFBLOCKS under
> > > > > > > > SB_FREEZE_WRITE protection, but here we have both frozen writes and
> > > > > > > > page faults we're running in a much more constrained freeze context
> > > > > > > > here.
> > > > > > > > 
> > > > > > > > i.e. the SYNC walk will keep busy looping if it can't get the
> > > > > > > > IOLOCK_EXCL on an inode that is in cache, so if we end up with an
> > > > > > > > inode locked and blocked on SB_FREEZE_WRITE or SB_FREEZE_PAGEFAULT
> > > > > > > > for whatever reason this will never return....
> > > > > > > 
> > > > > > > Are you referring to the case where one could be read()ing from a file
> > > > > > > into a buffer that's really a mmap'd page from another file while the
> > > > > > > underlying fs is being frozen?
> > > > > > > 
> > > > > > 
> > > > > > I thought this was generally safe as freeze protection sits outside of
> > > > > > the locks, but I'm not terribly sure about the read to a mapped buffer
> > > > > > case. If that allows an iolock holder to block on a pagefault due to
> > > > > > freeze, then SB_FREEZE_PAGEFAULT might be too late for a synchronous
> > > > > > scan (i.e. assuming nothing blocks this earlier or prefaults/pins the
> > > > > > target buffer)..?
> > > > > 
> > > > > I think so.  xfs_file_buffered_read takes IOLOCK_SHARED and calls
> > > > > filemap_read, which calls copy_page_to_iter.  I /think/ the messy iovec
> > > > > code calls copyout, which can then hit a write page fault, which takes
> > > > > us to __xfs_filemap_fault.  That takes SB_PAGEFAULT, which is the
> > > > > opposite order of what now goes on during a freeze.
> > > > > 
> > > > > > > Also, I added this second patch and fstests runtime went up by 30%.
> > > > > > > ISTR Dave commenting that freeze time would go way up when I submitted a
> > > > > > > patch to clean out the cow blocks a few years ago.
> > > > > > > 
> > > > > > 
> > > > > > Do you have any more detailed data on this? I.e., is this an increase
> > > > > > across the board? A smaller set of tests doing many freezes with a
> > > > > > significant runtime increase?
> > > > > 
> > > > > I think it's constrained to tests that run freeze and thaw in a loop,
> > > > > but the increases in those tests are large.
> > > > > 
> > > > > Here's what I see when I run all the tests that mention 'freeze' before
> > > > > applying the patch:
> > > > > 
> > > > > generic/068      46s
> > > > > generic/085      9s
> > > > > generic/280      2s
> > > > > generic/311      53s
> > > > > generic/390      3s
> > > > > generic/459      15s
> > > > > generic/491      2s
> > > > > xfs/006  8s
> > > > > xfs/011  20s
> > > > > xfs/119  6s
> > > > > xfs/264  13s
> > > > > xfs/297  42s
> > > > > xfs/318  2s
> > > > > xfs/325  2s
> > > > > xfs/438  4s
> > > > > xfs/517  46s
> > > > > 
> > > > > And here's after:
> > > > > 
> > > > > generic/068      47s
> > > > > generic/085      17s
> > > > > generic/280      4s
> > > > > generic/311      81s
> > > > > generic/390      4s
> > > > > generic/459      14s
> > > > > generic/491      2s
> > > > > xfs/006  9s
> > > > > xfs/011  21s
> > > > > xfs/119  11s
> > > > > xfs/264  18s
> > > > > xfs/297  31s
> > > > > xfs/318  3s
> > > > > xfs/325  2s
> > > > > xfs/438  5s
> > > > > xfs/517  46s
> > > > > 
> > > > > Most of those tests run in more or less the same amount of time, except
> > > > > for generic/085, generic/311, xfs/119, xfs/264, and xfs/297.  Of those,
> > > > > they all freeze repeatedly except for xfs/119.
> > > > > 
> > > > > I would imagine that the same thing is going on with tests that touch
> > > > > device-mapper, since a dm suspend also freezes the fs, but I didn't
> > > > > check those tests all that thoroughly, since most of the dmerror /
> > > > > dmflakey tests only switch the dm table once or twice per test.
> > > > > 
> > > > 
> > > > I think the test performance is more likely to impacted when there's a
> > > > combination of freeze and some workload that results in the blockgc scan
> > > > having to do work. Of course there will be some impact even with the
> > > > extra call, but that and your followup results that factor out lockdep
> > > > seem a much more reasonable impact to me.
> > > > 
> > > > The way I see it, we can always optimize looping tests that become too
> > > > slow and it's not exactly like tests are designed for runtime efficiency
> > > > in the first place. I feel like I run into new tests all the time that
> > > > don't really consider the broader runtime impact and whether they do
> > > > more work than really necessary. Unless there's some
> > > > immediate/unforeseen/disruptive change (like your initial numbers seemed
> > > > to suggest), this doesn't seem like a primary concern to me.
> > > > 
> > > > > > I'm a little on the fence about this because personally, I'm not
> > > > > > terribly concerned about the performance of a single freeze call. At the
> > > > > > same time, I could see this adding up across hundreds of cycles or
> > > > > > whatever via a test or test suite, and that being potentially annoying
> > > > > > to devs/testers.
> > > > > 
> > > > > Well... yeah.  The net effect on djwong-dev is that a -g all test run
> > > > > went from 3.6h to 4.8h.  It was less bad for tip (2.8 to 3h).
> > > > > 
> > > > > > > Also also looking through the archives[1], Brian once commented that
> > > > > > > cleaning up all this stuff should be done /if/ one decides to mount the
> > > > > > > frozen-snapshot writable at some later point in time.
> > > > > > > 
> > > > > > 
> > > > > > That kind of sounds like the tradeoff of impacting the current/active fs
> > > > > > for the benefit of a snapshot that may or may not be used. If not, then
> > > > > > it's a waste of time. If so, it might be beneficial for the snap to more
> > > > > > accurately reflect the "eventual" state of the original. For cowblocks
> > > > > > perhaps it doesn't matter if the mount/recovery will scan and reclaim.
> > > > > > I'm not as sure for eofblocks, wouldn't the snap persist all that
> > > > > > "intended to be transient" speculative prealloc until/unless said files
> > > > > > are reopened/closed?
> > > > > 
> > > > > Yes, that is the current behavior. :)
> > > > > 
> > > > > I don't know if it's really optimal (it's at least lazy :P) and Eric has
> > > > > tried to shift the balance away from "xfs snapshots take forever to
> > > > > mount".
> > > > > 
> > > > > > > Maybe this means we ought to find a way to remove inodes from the percpu
> > > > > > > inactivation lists?  iget used to be able to pry inodes out of deferred
> > > > > > > inactivation...
> > > > > > > 
> > > > > > 
> > > > > > Seems a reasonable option. Presumably that mitigates the lookup stalling
> > > > > > behavior without the need for any additional scanning work at freeze
> > > > > > time (and maybe eliminates the need for an inodegc flush too), but is
> > > > > > neutral wrt some of the other tradeoffs (like the above). I think the
> > > > > > former is the big question wrt to deferred inactivation whereas the
> > > > > > latter has been the case forever.
> > > > > > 
> > > > > > BTW, should we care at all about somebody dropping the entire cached
> > > > > > working set (worst case) onto these queues if the fs is frozen? Maybe
> > > > > > not if we have to cycle through all these inodes anyways for a full
> > > > > > working set eviction, and presumably a large evictor task (i.e.
> > > > > > drop_caches) will minimize the percpu queue distribution...
> > > > > 
> > > > > I've wondered myself if we really need to dump quite so many inodes onto
> > > > > the inactivation queue while we're frozen.  For posteof blocks we could
> > > > > just leave them attached and hope that inactivation eventually gets
> > > > > them, though that has the unfortunate side effect that space can
> > > > > disappear into the depths.
> > > > > 
> > > > 
> > > > I would really prefer to avoid any sort of approach that leaks post-eof
> > > > space as such. As unlikely as this situation might be, that reintroduces
> > > > paths to the old "where'd my XFS space go?" class of problems this
> > > > infrastructure was originally designed to address. 
> > > > 
> > > > ISTM the currently most viable options we've discussed are:
> > > > 
> > > > 1. Leave things as is, accept potential for lookup stalls while frozen
> > > > and wait and see if this ever really becomes a problem for real users.
> > > 
> > > From a laziness perspective, I like this option. :)
> > > 
> > > But we /do/ have customers who file escalations for every stack trace
> > > they see in dmesg, even if it's merely the hangcheck timer telling them
> > > that a process has stalled on a frozen fs.
> > > 
> > > > 2. Tweak the scan to be async as Dave suggested in his followup mail.
> > > > This changes this patch from a guarantee to more of a mitigation, which
> > > > personally I think is fairly reasonable. We'd still have drained writers
> > > > and faulters by this point in the freeze, so the impact would probably
> > > > be limited to contention with readers of blockgc inodes (though this
> > > > probably should be tested).
> > > 
> > > <nod> Switching to an async scan would ameliorate the situation, but not
> > > solve it.
> > > 
> > > > 3. Darrick's earlier thought to reintroduce inode reuse off the
> > > > inactivation queues. It's not clear to me how involved this might be.
> > > 
> > > I /think/ it's fairly simple to teach xfs_iget to xfs_iget_recycle and
> > > clear NEEDS_INACTIVE from the inode and the inodegc worker to re-check
> > > if an inode is NEEDS_INACTIVE before setting INACTIVATING.
> > > 
> > > A bigger problem might be how to prevent the inode from being reclaimed
> > > until the i_gclist is clear /and/ we know the worker is done with it.
> > > 
> > > > 4-N. I'm sure we can think up any number of other theoretical options
> > > > depending on how involved we want to get. The idea below sounds
> > > > plausible, but at the same time (and if I'm following correctly)
> > > > inventing a new way to free space off inodes purely for the use of
> > > > eviction during freeze sounds excessive wrt to complexity, future
> > > > maintenance burden, etc.
> > > 
> > > Yeah.
> > > 
> > > > Perhaps yet another option could be something like a more granular
> > > > freeze callback that, if specified by the fs, invokes the filesystem at
> > > > each step of the freeze sequence instead of only at the end like
> > > > ->freeze_fs() currently does. IIUC this problem mostly goes away if we
> > > > can run the scan a bit earlier, we could clean up the existing freeze
> > > > wart in ->sync_fs(), and perhaps other filesystems might find that
> > > > similarly useful. Of course this requires more changes outside of xfs..
> > > 
> > > <nod> I wish we could lock out file reads during whole-fs transitions
> > > like freezing and ro remounts, but I bet the community would not be
> > > amenable to adding mnt_want_read type things to all the vfs functions.
> > > 
> > 
> > Err, yeah. That seems potentially more invasive.
> 
> Yep.  Freezes should be fairly infrequent, which means we'd be imposing
> a pretty high penalty on every read ever just for the sake of a
> relatively rare operation.
> 
> > Well, if you wanted to go the freeze api route and are Ok with pulling
> > an async scan as an incremental step (given that the end goal with that
> > approach is a sync blockgc scan), I don't mind taking a stab at the
> > freeze API thing from there. I'm not sure how likely it might be to land
> > a new freeze interface, but in thinking about it a bit we might not need
> > a new callback interface at all since the freeze state is already in the
> > superblock. E.g., consider an optional superblock flag we could set to
> > instruct the VFS to call ->freeze_fs() once per state transition rather
> > than only at the end. With that, we'd check sb->s_writers.frozen at each
> > invocation (like we already do in ->sync_fs()) and DTRT based on the
> > current state. E.g., perhaps with high level logic along the lines of:
> > 
> > SB_FREEZE_WRITE:
> > 	- full sync_fs() and sync blockgc scan
> > SB_FREEZE_PAGEFAULT:
> > 	- async blockgc (for the read -> mapped write case)
> > 	- stop inode/block gc scanners
> > SB_FREEZE_FS:
> > 	- remaining/existing ->fs_freeze() logic
> > 
> > ... and then pull the corresponding hacks out of xfs_fs_sync_fs().
> 
> That sounds like a reasonable place to start.  At some point after the
> merge window closes I'm going to send some patches to -fsdevel to fix
> the problem that sync_filesystem ignores the ->sync_fs() return value,
> but think the conflicts should not be insurmountable.
> 
> > Of course if you wanted to recycle inactive inodes or do something else
> > entirely, then it's probably not worth going down this path..
> 
> I'm a bit partial to /trying/ to recycle inactive inodes because (a)
> it's less tangling with -fsdevel for you and (b) inode scans in the
> online repair patchset got a little weird once xfs_iget lost the ability
> to recycle _NEEDS_INACTIVE inodes...
> 
> OTOH I tried to figure out how to deal with the lockless list that those
> inodes are put on, and I couldn't figure out how to get them off the
> list safely, so that might be a dead end.  If you have any ideas I'm all
> ears. :)
> 

So one of the things that I've been kind of unclear on about the current
deferred inactivation implementation is the primary goal of the percpu
optimization. I obviously can see the value of the percpu list in
general, but how much processing needs to occur in percpu context to
achieve the primary goal?

For example, I can see how a single or small multi threaded sustained
file removal might be batched efficiently, but what happens if said task
happens to bounce around many cpus? What if a system has hundreds of
cpus and enough removal tasks to populate most or all of the queues? Is
it worth having 200 percpu workqueue tasks doing block truncations and
inode frees to a filesystem that might have something like 16-32 AGs?

So I dunno, ISTM that the current implementation can be hyper efficient
for some workloads and perhaps unpredictable for others. As Dave already
alluded to, the tradeoff often times for such hyper efficient structures
is functional inflexibility, which is kind of what we're seeing between
the inability to recycle inodes wrt to this topic as well as potential
optimizations on the whole RCU recycling thing. The only real approach
that comes to mind for managing this kind of infrastructure short of
changing data structures is to preserve the ability to drain and quiesce
it regardless of filesystem state.

For example, I wonder if we could do something like have the percpu
queues amortize insertion into lock protected perag lists that can be
managed/processed accordingly rather than complete the entire
inactivation sequence in percpu context. From there, the perag lists
could be processed by an unbound/multithreaded workqueue that's maybe
more aligned with the AG count on the filesystem than cpu count on the
system.

I suspect something like that would allow for a more ideal combination
of performance and flexibility because then the percpu component never
has to freeze at all, it can just continue to drain into the perag lists
based on specified heuristic. Processing of the aggregated lists would
have to stop on freeze of course, but from there we'd at least have a
lock protected data structure to allow things like lookup to pull inodes
off for recycling purposes, online repair (?), etc., or for the
inactivation workqueue to skip inodes that might still be waiting on a
grace period to expire before they should be freed and made reallocation
candidates (including intelligence on when to most efficiently wait on a
grace period). (And maybe in the future this could tie in with your
earlier thought about making inactivation more granular in terms of
separating inode truncation from block and inode freeing so more work
can be done per AG lock cycle, etc.).

Of course, this would most likely have to come at some performance cost
as compared to the current, lockless implementation. The question to me
is more what is the cost in order to achieve the desired flexibility?
I.e., if we could preserve 80% of the performance benefit of the current
implementation with additional flexibility of lifting some of the work
out of the percpu tasks, would that be worth it? I'm not really sure
what all of the tradeoffs are here because of my questions above around
the goals of the implementation, etc. I'm sure I'm missing other context
as well, so that is mostly just my current handwavy thinking about how
to possibly accomplish some of these functional goals without having to
completely change out the existing data structure...

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > > COW mappings are attached incore to the inode cow fork but the refcount
> > > > > btree ondisk, so in principle for frozen inodes we could move the cow
> > > > > mappings to an internal bitmap, let the inode go, and free the abandoned
> > > > > cow blocks at thaw time.
> > > > > 
> > > > > Unlinked inodes with no active refcount can of course block in the queue
> > > > > forever; userspace can't have those back.
> > > > > 
> > > > > --D
> > > > > 
> > > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > [1] https://lore.kernel.org/linux-xfs/20190117181406.GF37591@bfoster/
> > > > > > > 
> > > > > > > --D
> > > > > > > 
> > > > > > > > Cheers,
> > > > > > > > 
> > > > > > > > Dave.
> > > > > > > > -- 
> > > > > > > > Dave Chinner
> > > > > > > > david@fromorbit.com
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

