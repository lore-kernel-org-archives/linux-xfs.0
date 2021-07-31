Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72306C432BE
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Jul 2021 04:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BF460F94
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Jul 2021 04:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhGaEVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Jul 2021 00:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234981AbhGaEVU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Jul 2021 00:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F2C660F13;
        Sat, 31 Jul 2021 04:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627705273;
        bh=CYbmkw72Eap22yTopODet7cHzVMyZduQTBjHbg+z7Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XeWfKVDrJcCr79xJv0o3AtlVrlS1F3GP/+KogQR4ktjT/pMYAxV5okhdrYSDC+9I0
         yQ+lkZFk/dVVR2abrSM+LP5xMfcuXtBi5a5a6Qnb/ccFS3ngWXcpV+L/nlEtpe78ob
         c6DI2uGWlLxFLg8cLSuUGXuEgPJVHhzF6xVp2/CFvkWzHXzq7W6ZelkJD1vN8EjmlR
         ufhrHaR4DTdVPFA/xJM2ytYlaVpkEq100L3ut29+AJUCrZE4lp/7Z9+rkUPN8wdKJy
         lR6+/bOzPDPHRqMVuOf+VO2wrpGmwaLilBvgTDHE8kWYskGQbrS8FQj/TFXwuqB7AW
         EtfuzPJ28bRcQ==
Date:   Fri, 30 Jul 2021 21:21:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/20] xfs: defer inode inactivation to a workqueue
Message-ID: <20210731042112.GM3601443@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210730042400.GB2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730042400.GB2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 30, 2021 at 02:24:00PM +1000, Dave Chinner wrote:
> On Thu, Jul 29, 2021 at 11:44:10AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> > defer the inactivation phase to a separate workqueue.  With this change,
> > we can speed up directory tree deletions by reducing the duration of
> > unlink() calls to the directory and unlinked list updates.
> > 
> > By moving the inactivation work to the background, we can reduce the
> > total cost of deleting a lot of files by performing the file deletions
> > in disk order instead of directory entry order, which can be arbitrary.
> > 
> > We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
> > The first flag helps our worker find inodes needing inactivation, and
> > the second flag marks inodes that are in the process of being
> > inactivated.  A concurrent xfs_iget on the inode can still resurrect the
> > inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).
> > 
> > Unfortunately, deferring the inactivation has one huge downside --
> > eventual consistency.  Since all the freeing is deferred to a worker
> > thread, one can rm a file but the space doesn't come back immediately.
> > This can cause some odd side effects with quota accounting and statfs,
> > so we flush inactivation work during syncfs in order to maintain the
> > existing behaviors, at least for callers that unlink() and sync().
> > 
> > For this patch we'll set the delay to zero to mimic the old timing as
> > much as possible; in the next patch we'll play with different delay
> > settings.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> .....
> > +
> > +/* Disable the inode inactivation background worker and wait for it to stop. */
> > +void
> > +xfs_inodegc_stop(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
> > +		return;
> > +
> > +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> > +	trace_xfs_inodegc_stop(mp, __return_address);
> > +}
> 
> FWIW, this introduces a new mount field that does the same thing as the
> m_opstate field I added in my feature flag cleanup series (i.e.
> atomic operational state changes).  Personally I much prefer my
> opstate stuff because this is state, not flags, and the namespace is
> much less verbose...

Yes, well, is that ready to go?  Like, right /now/?  I already bolted
the quotaoff scrapping patchset on the front, after reworking the ENOSPC
retry loops and reworking quota apis before that...

> THere's also conflicts all over the place because of that. All the
> RO checks are busted,

Can we focus on /this/ patchset, then?  What specifically is broken
about the ro checking in it?

And since the shrinkers are always a source of amusement, what /is/ up
with it?  I don't really like having to feed it magic numbers just to
get it to do what I want, which is ... let it free some memory in the
first round, then we'll kick the background workers when the priority
bumps (er, decreases), and hope that's enough not to OOM the box.

--D

> lots of the quota mods in your tree conflict
> with the sb_version_hasfeat -> has_feat conversion, etc.
> 
> We're going to have to reconcile this at some point soon...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
