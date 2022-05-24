Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9595EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 00:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiEXAfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 20:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiEXAfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 20:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC9B9CF39
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 17:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC858615C0
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 00:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA86C385A9;
        Tue, 24 May 2022 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653352541;
        bh=s2FPXIXN5qjvEDwxnb2C2Gfhakkglxiwd0Q8nUnJUfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qypVDJzQcUpkIFVWuYaUSYZZGKGWIMP66z7wjwc4xjv+8pWFVJgwe7t1Lzhb1XryS
         ZtkGF44v4tkAA34QYrTZBOphPpnO2yhsdOWq5M7G5BiTD/6Ue+NIPM50KO80XJVY1l
         zbgNZBgTZLrsVQ8B1IEYFsz4rRrXC3PhMKdcRrw4uJPEs2chAYi+20VSGEUnp2fZXc
         jN8T9JZkcl5H8KP34uf/NNVd34wmi6I/0rG2WmiJ4Og7v/z9zhX2a5MxEWxSDarJKC
         ooa9Q5gyhGDFxPc6kJ9+CwykUGQujFrJn6Uuap4f/y5dqv9tyCfW0BzWV09/00iwXx
         vJCvQIHOb7WIw==
Date:   Mon, 23 May 2022 17:35:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
Message-ID: <YowoXHly0w/kmKv2@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323332197.78886.8893427108008735872.stgit@magnolia>
 <20220523033445.GQ1098723@dread.disaster.area>
 <YovclVb71ZblumWh@magnolia>
 <20220523225643.GU1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523225643.GU1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 08:56:43AM +1000, Dave Chinner wrote:
> On Mon, May 23, 2022 at 12:12:21PM -0700, Darrick J. Wong wrote:
> > On Mon, May 23, 2022 at 01:34:45PM +1000, Dave Chinner wrote:
> > > On Sun, May 22, 2022 at 08:28:42AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > libxfs itself should never be messing with whether or not to enable
> > > > logging for extended attribute updates -- this decision should be made
> > > > on a case-by-case basis by libxfs callers.  Move the code that actually
> > > > enables the log features to xfs_xattr.c, and adjust the callers.
> > > > 
> > > > This removes an awkward coupling point between libxfs and what would be
> > > > libxlog, if the XFS log were actually its own library.  Furthermore, it
> > > > makes bulk attribute updates and inode security initialization a tiny
> > > > bit more efficient, since they now avoid cycling the log feature between
> > > > every single xattr.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_attr.c |   12 +-------
> > > >  fs/xfs/xfs_acl.c         |   10 +++++++
> > > >  fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
> > > >  fs/xfs/xfs_ioctl.h       |    2 +
> > > >  fs/xfs/xfs_ioctl32.c     |    4 ++-
> > > >  fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
> > > >  fs/xfs/xfs_log.c         |   45 --------------------------------
> > > >  fs/xfs/xfs_log.h         |    1 -
> > > >  fs/xfs/xfs_super.h       |    2 +
> > > >  fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  10 files changed, 120 insertions(+), 68 deletions(-)
> > > 
> > > This seems like the wrong way to approach this. I would have defined
> > > a wrapper function for xfs_attr_set() to do the log state futzing,
> > > not moved it all into callers that don't need (or want) to know
> > > anything about how attrs are logged internally....
> > 
> > I started doing this, and within a few hours realized that I'd set upon
> > yet *another* refactoring of xfs_attr_set.  I'm not willing to do that
> > so soon after Allison's refactoring, so I'm dropping this patch.
> 
> I don't see why this ends up being a problem - xfs_attr_set() is
> only called by code in fs/xfs/*.c, so adding a wrapper function
> that just does this:
> 
> int
> xfs_attr_change(
> 	struct xfs_da_args      *args)
> {
> 	struct xfs_mount	*mp = args->dp->i_mount;
> 
> 	if (xfs_has_larp(mp)) {
> 		error = xfs_attr_use_log_assist(mp);
> 		if (error)
> 			return error;
> 	}
> 
> 	error = xfs_attr_set(args);
> 	if (xfs_has_larp(mp))

Race condition here ^^^ if we race with someone changing the debug knob,
we'll either drop something we never took, or leak something we did
take.

> 		xlog_drop_incompat_feat(mp->m_log);
> 	return error;
> }
> 
> into one of the files in fs/xfs will get this out of libxfs, won't
> it?
> 
> What am I missing here?

After the last year and a half I've gotten in the bad habit of trying to
anticipate the likely style objections of various reviewers to try to
get patches into upstream with as few objections as possible, which then
leads me down the path of more and more scope creep from the voices
inside my head:

"These cleanups should be split into smaller changes for easy
backporting."

"Setting xattr arguments via the da_args struct is a mess, make them
function parameters."

"It's nasty to have xfs_attr_change take 7 parameters, just make an
xfs_attrchange_args struct with the pieces we need, and use it to fill
out the da args internally."

"These calling conventions are still crap, transaction allocation
shouldn't even be in libxfs at all!"

"Why don't you make attr_change have its own flags namespace, and then
set attr_filter and attr_flags from that?  This would decouple the
interfaces and make them easier to figure out next time."

"There are too many little xfs_attr functions and it's really hard to
grok what they all do."

OTOH if you'd be willing to take just that attr_change bit above (with
the race condition fixed, I *would* send you that in patch form.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
