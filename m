Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92106C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2E661090
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhJNXH4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhJNXHz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 19:07:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A557F6108B;
        Thu, 14 Oct 2021 23:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634252749;
        bh=a59R0YLbeXjH5akMkUIvATUQeYElBx5L12gBl7zalG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AjSZtFV7732Y2hR3cgOZJh1OrmW9MvVfKinAePkxKPOgTobH5hxM5IFv2zXiBmD03
         6xdEmbuUSRrfGZRHwT2K2rVVdMtiZVxqllCnOI4U5I/IV2T3/CnXdUNOThTJfTWNB8
         U6GLGEUiPjSSdb4BWgPf0SbTViobGcRNAfP8iAcVG9WDuO9zhGyzEsG5eLZlcq5lQU
         jNub7UpZuvXSxPMWrHo/xdCHXdWFMiLO/3QTFFLnVO08T9IxbV5RFgBJZqx1PoQLAC
         tvhP0IzaXmrxwb5zY/ctCXNmRAJoXjGdcrItrpmRkOWV/plJh1d2bob3Pm3CzP3SK6
         yDhcSQCPZy/Uw==
Date:   Thu, 14 Oct 2021 16:05:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/17] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
Message-ID: <20211014230549.GM24307@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424262046.756780.2366797746965376855.stgit@magnolia>
 <20211014224813.GN2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014224813.GN2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 15, 2021 at 09:48:13AM +1100, Dave Chinner wrote:
> On Thu, Oct 14, 2021 at 01:17:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > During review of subsequent patches, Dave and I noticed that this
> > function doesn't work quite right -- accessing cur->bc_ino depends on
> > the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
> > isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
> > because block 0 of an AG is never part of a btree.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/trace.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> > index c0ef53fe6611..93c13763c15e 100644
> > --- a/fs/xfs/scrub/trace.c
> > +++ b/fs/xfs/scrub/trace.c
> > @@ -24,10 +24,11 @@ xchk_btree_cur_fsbno(
> >  	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> >  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> >  				xfs_buf_daddr(cur->bc_bufs[level]));
> > -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > +
> > +	if (level == cur->bc_nlevels - 1 &&
> > +	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> >  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
> 
> Ok.
> 
> > -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
> > -		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
> > +
> 
> But doesn't this break the tracing code on short pointers as the
> tracing code does:
> 
> 	TP_fast_assign(
> 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
> 		...
> 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
> 
> 
> i.e. the tracing will no longer give the correct agno for per-ag
> cursors that don't have any buffers attached to them at the current
> level?

Hmmm.  By that logic, maybe we should get rid of the (level ==
cur->bc_nlevels - 1) check entirely so that any cursor without a buffer
attached at that level will always provide *some* kind of breadcrumb to
the tracepoints?

I almost did that instead, except for the consideration that if you're
tracing the online fsck code, you should /probably/ have at least one of
xchk_stop/xrep_attempt/xchk_done included in the filter list so you can
be certain of what the kernel is checking.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
