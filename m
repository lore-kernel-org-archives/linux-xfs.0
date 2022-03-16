Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAE9C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 01:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242609AbiCPBXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 21:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239951AbiCPBXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 21:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC895D5D3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 18:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A994AB819AB
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 01:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B08C340E8;
        Wed, 16 Mar 2022 01:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647393745;
        bh=G4zcRE7OJe9L6wLJuvRyQbWW8zviQ035EIk/4wFmnXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=idk4bPq0C101XhfLrxdBwnLbPmPHCQCHrt7NIQJRCpY0NgUpngc0H0iRWGhmkKlig
         vOpZM/4C9RqmtG2XmIeCXWxxUSlzEAi4RWIJs/ycYWwq+0F/x4kLGF/ukJHnxo5eZY
         YLGYDsRUIO70hFp0axT0ZqCFeOsYyyM6vLPl5myxvD1dQZkXxzNw1mP4aXTGsDbtkG
         EYZRKRY4gWbOgCJj/B6BZcQ2SqCVfbLevu9ZUB1d0cwy4IcplhROGIeCxMUWnYnBkx
         I7Oy0g1/WrDK+jck7hML7JaeJ6dmuCxOKhGBC+juRKkbHO04qmcGFIeYgeGgwQCW6N
         gXyw0u9z/P9bg==
Date:   Tue, 15 Mar 2022 18:22:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: xfs_is_shutdown vs xlog_is_shutdown cage fight
Message-ID: <20220316012224.GI8241@magnolia>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-8-david@fromorbit.com>
 <20220315200321.GR8224@magnolia>
 <20220315222016.GN3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315222016.GN3927073@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 09:20:16AM +1100, Dave Chinner wrote:
> On Tue, Mar 15, 2022 at 01:03:21PM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 15, 2022 at 05:42:41PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > I've been chasing a recent resurgence in generic/388 recovery
> > > failure and/or corruption events. The events have largely been
> > 
> > recoveryloop, the gift that keeps on giving...
> 
> *nod*
> 
> > > The fundamental problem here is that we are using the wrong shutdown
> > > checks for log items. We've long conflated mount shutdown with log
> > > shutdown state, and I started separating that recently with the
> > > atomic shutdown state changes in commit b36d4651e165 ("xfs: make
> > > forced shutdown processing atomic"). The changes in that commit
> > > series are directly responsible for being able to diagnose this
> > > issue because it clearly separated mount shutdown from log shutdown.
> > > 
> > > Essentially, once we start cancelling writeback of log items and
> > > removing them from the AIL because the filesystem is shut down, we
> > > *cannot* update the journal because we may have cancelled the items
> > > that pin the tail of the log. That moves the tail of the log
> > > forwards without having written the metadata back, hence we have
> > > corrupt in memory state and writing to the journal propagates that
> > > to the on-disk state.
> > > 
> > > What commit b36d4651e165 makes clear is that log item state needs to
> > > change relative to log shutdown, not mount shutdown. IOWs, anything
> > > that aborts metadata writeback needs to check log shutdown state
> > > because log items directly affect log consistency. Having them check
> > > mount shutdown state introduces the above race condition where we
> > > cancel metadata writeback before the log shuts down.
> > > 
> > > To fix this, this patch works through all log items and converts
> > > shutdown checks to use xlog_is_shutdown() rather than
> > > xfs_is_shutdown(), so that we don't start aborting metadata
> > > writeback before we shut off journal writes.
> > 
> > Once the log has shut down, is there any reason we shouldn't consider
> > the filesystem shut down too?
> > 
> > IOWs, should xfs_is_shutdown be doing something like this:
> > 
> > bool
> > xfs_is_shutdown(struct xfs_mount *mp)
> > {
> > 	return test_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate) ||
> > 		xlog_is_shutdown(mp->m_log);
> > }
> 
> Not necessary - the way the shutdown code runs now we guarantee
> that XFS_OPSTATE_SHUTDOWN is set *before* we set XLOG_IO_ERROR.
> Hence we'll never see XLOG_IO_ERROR without XFS_OPSTATE_SHUTDOWN.
> 
> > I could very easily envision myself reintroducing bugs w.r.t.
> > {xfs,xlog}_is_shutdown because it's not immediately obvious to me
> > (particularly in xfs_buf.c) which one I ought to use.
> 
> Yeah, I can't give you a bright line answer to that right now. We've
> smeared the abstraction between log and mount for a long while now,
> and the result is that it's not clear what is log and what is mount
> functionality.

Ugh, that's going to be messy.

The first silly idea to pop in my head was "Just pass the log into the
code paths that need the log", but that was trivially wrong because
there are things (like the buffer read path) where we actually need it
to keep working so that the AIL can push buffers out to disk after we
set OPSTATE_SHUTDOWN but before XLOG_IO_ERROR...

> 
> > Another way to put this is: what needs to succeed between the point
> > where we set OPSTATE_SHUTDOWN and XLOG_IO_ERROR?  Is the answer to that
> > "any log IO that was initiated right up until we actually set
> > XLOG_IO_ERROR"?
> 
> That's one half - the other half is....
> 
> > Which means random parts of the buffer cache, and the
> > inode/dquot flush code?
> > 
> > IOWs the log flush and any AIL writeback that was in progress?
> 
> ... yeah, this.
> 
> Like the CIL, the AIL belongs to the log, not to the mount.
> Similarly, log items belong to the log, not the transaction
> subsystem. The transaction subsystem is the interface layer between
> the mount and the log - code from above that interacts with
> transaction knows only about mounts and so they all use
> xfs_is_shutdown().
> 
> The transactions interface with the log via log tickets and log
> items, which are provided by the log, not the transaction subsystem.
> Anything that operates on or manages the log, log tickets or log
> items should typically use xlog_is_shutdown().
> 
> This means subsystems that are used both from the mount and log
> log levels (e.g. xfs_buf.c) has a difficult line to straddle.
> However, it's worth noting that high level transaction buffer read side 
> does mount shutdown checks (e.g. in xfs_trans_read_buf_map()) and
> so that largely allows the low level buffer code to only have to
> care about log level shutdowns. Hence the check in
> __xfs_buf_submit() is converted to a log level check so that it
> doesn't abort buffer log item writeback before the log is shut down.

...which I agree is why we can't make bright line statements about which
one you're supposed to use.  There's no convenient hierarchy to make it
obvious which is which, since xfs and its log are rather <cough>
codependent.

> Hence I think working out what the right thing to do is short term
> pain while we work through re-establishing the log vs mount
> abstractions correctly.

Hm.  In the /really/ short term, for each callsite you switch to
xlog_is_shutdown, can you make sure there's a comment saying why we need
to query the log and not the fs shutdown state?  I think you've done
that for /most/ of the sites where it really matters, but
xfs_buf_read_map and xfs_reclaim_inode were a bit subtle.

As I said on IRC just now, the guideline I'm thinking of is "xfs_*
functions use xfs_is_shutdown; functions called under xlog_* use
xlog_is_shutdown; and anywhere those two rules aren't apply should
probably have a comment".

My goal here is to give the rest of us enough breadcrumbs that we don't
mess up log recovery while you work on getting the rest of your stuff
merged:

> I've got various patchsets I've been working on over the past year
> that clean a fair bit of this this up. However, they are kindai
> intertwined through the patchsets that provide CIL scalability,
> intent whiteouts, in-memory iunlink intents, log ticket cleanups,
> log ticket/grant head scalability (byte tracking, not LSNs), moving
> AIL push targeting into the AIL instead of setting targets from
> transaction reservation, moving iclogs behind the CIL and removing
> log force shenanigans, etc. because I've done cleanups as I've
> touched various bits of the code...

...while not making you make so many non-documentation changes such that
rebasing your dev branch becomes a huge nightmare because you had to
extricate/rearrange a ton of cleanups.

(Heck, even a terse comment that merely affirms that we're checking for
log death and this isn't the usual "checking for fs death, urrrk" would
be enough to make me think carefully about touching such a line... :))

> 
> > > @@ -3659,7 +3660,7 @@ xfs_iflush_cluster(
> > >  		 * AIL, leaving a dirty/unpinned inode attached to the buffer
> > >  		 * that otherwise looks like it should be flushed.
> > >  		 */
> > > -		if (xfs_is_shutdown(mp)) {
> > > +		if (xlog_is_shutdown(mp->m_log)) {
> > >  			xfs_iunpin_wait(ip);
> > >  			xfs_iflush_abort(ip);
> > >  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > > @@ -3685,9 +3686,19 @@ xfs_iflush_cluster(
> > >  	}
> > >  
> > >  	if (error) {
> > > +		/*
> > > +		 * Shutdown first so we kill the log before we release this
> > > +		 * buffer. If it is an INODE_ALLOC buffer and pins the tail
> > 
> > Does inode flush failure leading to immediate shutdown need to happen
> > with the dquot code too?  I /think/ we don't?  Because all we do is
> > remove the dirty flag on the dquot and kill the log?
> 
> The dquot flush code already does an immediate shutdown on flush
> failure, too. see xfs_qm_dqflush():
> 
> out_abort:
> 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
> 	xfs_trans_ail_delete(lip, 0);
> 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);

Ah right.  So I think the logic in this patch looks ok, but a little
more commenting would help, esp. given how much I've already tripped
over this on IRC. ;)

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
