Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AA7C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 22:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiEWW4s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 18:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiEWW4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 18:56:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A2B612D31
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 15:56:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 86EAD10E9BC9;
        Tue, 24 May 2022 08:56:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntGyh-00FbcY-9i; Tue, 24 May 2022 08:56:43 +1000
Date:   Tue, 24 May 2022 08:56:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
Message-ID: <20220523225643.GU1098723@dread.disaster.area>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323332197.78886.8893427108008735872.stgit@magnolia>
 <20220523033445.GQ1098723@dread.disaster.area>
 <YovclVb71ZblumWh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YovclVb71ZblumWh@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628c112c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=TI-TZNY8znSc10U2lckA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 12:12:21PM -0700, Darrick J. Wong wrote:
> On Mon, May 23, 2022 at 01:34:45PM +1000, Dave Chinner wrote:
> > On Sun, May 22, 2022 at 08:28:42AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > libxfs itself should never be messing with whether or not to enable
> > > logging for extended attribute updates -- this decision should be made
> > > on a case-by-case basis by libxfs callers.  Move the code that actually
> > > enables the log features to xfs_xattr.c, and adjust the callers.
> > > 
> > > This removes an awkward coupling point between libxfs and what would be
> > > libxlog, if the XFS log were actually its own library.  Furthermore, it
> > > makes bulk attribute updates and inode security initialization a tiny
> > > bit more efficient, since they now avoid cycling the log feature between
> > > every single xattr.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_attr.c |   12 +-------
> > >  fs/xfs/xfs_acl.c         |   10 +++++++
> > >  fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
> > >  fs/xfs/xfs_ioctl.h       |    2 +
> > >  fs/xfs/xfs_ioctl32.c     |    4 ++-
> > >  fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
> > >  fs/xfs/xfs_log.c         |   45 --------------------------------
> > >  fs/xfs/xfs_log.h         |    1 -
> > >  fs/xfs/xfs_super.h       |    2 +
> > >  fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  10 files changed, 120 insertions(+), 68 deletions(-)
> > 
> > This seems like the wrong way to approach this. I would have defined
> > a wrapper function for xfs_attr_set() to do the log state futzing,
> > not moved it all into callers that don't need (or want) to know
> > anything about how attrs are logged internally....
> 
> I started doing this, and within a few hours realized that I'd set upon
> yet *another* refactoring of xfs_attr_set.  I'm not willing to do that
> so soon after Allison's refactoring, so I'm dropping this patch.

I don't see why this ends up being a problem - xfs_attr_set() is
only called by code in fs/xfs/*.c, so adding a wrapper function
that just does this:

int
xfs_attr_change(
	struct xfs_da_args      *args)
{
	struct xfs_mount	*mp = args->dp->i_mount;

	if (xfs_has_larp(mp)) {
		error = xfs_attr_use_log_assist(mp);
		if (error)
			return error;
	}

	error = xfs_attr_set(args);
	if (xfs_has_larp(mp))
		xlog_drop_incompat_feat(mp->m_log);
	return error;
}

into one of the files in fs/xfs will get this out of libxfs, won't
it?

What am I missing here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
