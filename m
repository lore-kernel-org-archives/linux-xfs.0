Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11883C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 01:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiEXBCy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 21:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiEXBCx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 21:02:53 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0214A0057
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 18:02:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 69FE3534523;
        Tue, 24 May 2022 11:02:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntIwj-00Fdkq-Fm; Tue, 24 May 2022 11:02:49 +1000
Date:   Tue, 24 May 2022 11:02:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
Message-ID: <20220524010249.GX1098723@dread.disaster.area>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323332197.78886.8893427108008735872.stgit@magnolia>
 <20220523033445.GQ1098723@dread.disaster.area>
 <YovclVb71ZblumWh@magnolia>
 <20220523225643.GU1098723@dread.disaster.area>
 <YowoXHly0w/kmKv2@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YowoXHly0w/kmKv2@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628c2eba
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=g29s_Z_B74w-HdgNnHUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 05:35:40PM -0700, Darrick J. Wong wrote:
> On Tue, May 24, 2022 at 08:56:43AM +1000, Dave Chinner wrote:
> > On Mon, May 23, 2022 at 12:12:21PM -0700, Darrick J. Wong wrote:
> > > On Mon, May 23, 2022 at 01:34:45PM +1000, Dave Chinner wrote:
> > > > On Sun, May 22, 2022 at 08:28:42AM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > libxfs itself should never be messing with whether or not to enable
> > > > > logging for extended attribute updates -- this decision should be made
> > > > > on a case-by-case basis by libxfs callers.  Move the code that actually
> > > > > enables the log features to xfs_xattr.c, and adjust the callers.
> > > > > 
> > > > > This removes an awkward coupling point between libxfs and what would be
> > > > > libxlog, if the XFS log were actually its own library.  Furthermore, it
> > > > > makes bulk attribute updates and inode security initialization a tiny
> > > > > bit more efficient, since they now avoid cycling the log feature between
> > > > > every single xattr.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_attr.c |   12 +-------
> > > > >  fs/xfs/xfs_acl.c         |   10 +++++++
> > > > >  fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
> > > > >  fs/xfs/xfs_ioctl.h       |    2 +
> > > > >  fs/xfs/xfs_ioctl32.c     |    4 ++-
> > > > >  fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
> > > > >  fs/xfs/xfs_log.c         |   45 --------------------------------
> > > > >  fs/xfs/xfs_log.h         |    1 -
> > > > >  fs/xfs/xfs_super.h       |    2 +
> > > > >  fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  10 files changed, 120 insertions(+), 68 deletions(-)
> > > > 
> > > > This seems like the wrong way to approach this. I would have defined
> > > > a wrapper function for xfs_attr_set() to do the log state futzing,
> > > > not moved it all into callers that don't need (or want) to know
> > > > anything about how attrs are logged internally....
> > > 
> > > I started doing this, and within a few hours realized that I'd set upon
> > > yet *another* refactoring of xfs_attr_set.  I'm not willing to do that
> > > so soon after Allison's refactoring, so I'm dropping this patch.
> > 
> > I don't see why this ends up being a problem - xfs_attr_set() is
> > only called by code in fs/xfs/*.c, so adding a wrapper function
> > that just does this:
> > 
> > int
> > xfs_attr_change(
> > 	struct xfs_da_args      *args)
> > {
> > 	struct xfs_mount	*mp = args->dp->i_mount;
> > 
> > 	if (xfs_has_larp(mp)) {
> > 		error = xfs_attr_use_log_assist(mp);
> > 		if (error)
> > 			return error;
> > 	}
> > 
> > 	error = xfs_attr_set(args);
> > 	if (xfs_has_larp(mp))
> 
> Race condition here ^^^ if we race with someone changing the debug knob,
> we'll either drop something we never took, or leak something we did
> take.

True, but largely irrelevant for the purposes of demonstration....

> 
> > 		xlog_drop_incompat_feat(mp->m_log);
> > 	return error;
> > }
> > 
> > into one of the files in fs/xfs will get this out of libxfs, won't
> > it?
> > 
> > What am I missing here?
> 
> After the last year and a half I've gotten in the bad habit of trying to
> anticipate the likely style objections of various reviewers to try to
> get patches into upstream with as few objections as possible, which then
> leads me down the path of more and more scope creep from the voices
> inside my head:
> 
> "These cleanups should be split into smaller changes for easy
> backporting."
>
> "Setting xattr arguments via the da_args struct is a mess, make them
> function parameters."
> 
> "It's nasty to have xfs_attr_change take 7 parameters, just make an
> xfs_attrchange_args struct with the pieces we need, and use it to fill
> out the da args internally."
> 
> "These calling conventions are still crap, transaction allocation
> shouldn't even be in libxfs at all!"
> 
> "Why don't you make attr_change have its own flags namespace, and then
> set attr_filter and attr_flags from that?  This would decouple the
> interfaces and make them easier to figure out next time."
> 
> "There are too many little xfs_attr functions and it's really hard to
> grok what they all do."

Yes, I understand that we need to re-layer the attr code to get rid
of all the twisty passages that are all alike, but we don't need to
do that right now and it avoids tying a simple change up in knots
that prevent progress from being made.

[FWIW, I have a basic plan for that - split all the sf/leaf/node
stuff out of xfs_attr_leaf.c into xfs_attr_sf/leaf/node.c, move all
the sf/leaf/node add/remove/change/lookup stuff out of xfs_attr.c
into the above files. High level API is in xfs_attr.c (same as
xfs_dir.c for directories) and everything external interfaces with
that API. Which we can then tailor to just the information needed
to set up attr and da_args inside xfs_attr.c....

Then we can start cleaning up all the internal attr APIs, fix all
the whacky quirks like sf add will do a remove if it's actually a
replace, clean up the lookup interfaces, etc. ]

> OTOH if you'd be willing to take just that attr_change bit above (with
> the race condition fixed, I *would* send you that in patch form.

Yes, I think that's just fine. Simple is often best...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
