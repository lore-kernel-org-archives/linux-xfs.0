Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5941C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7154560C41
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhJNXTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:19:10 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:42632 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhJNXTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 19:19:10 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 7646C10D1DD;
        Fri, 15 Oct 2021 10:17:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9yA-006JlD-SP; Fri, 15 Oct 2021 10:17:02 +1100
Date:   Fri, 15 Oct 2021 10:17:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/17] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
Message-ID: <20211014231702.GW2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424262046.756780.2366797746965376855.stgit@magnolia>
 <20211014224813.GN2361455@dread.disaster.area>
 <20211014230549.GM24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014230549.GM24307@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6168ba70
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=tfPEP7of1_Icnt5Zq8kA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 04:05:49PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 15, 2021 at 09:48:13AM +1100, Dave Chinner wrote:
> > On Thu, Oct 14, 2021 at 01:17:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > During review of subsequent patches, Dave and I noticed that this
> > > function doesn't work quite right -- accessing cur->bc_ino depends on
> > > the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
> > > isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
> > > because block 0 of an AG is never part of a btree.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/scrub/trace.c |    7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> > > index c0ef53fe6611..93c13763c15e 100644
> > > --- a/fs/xfs/scrub/trace.c
> > > +++ b/fs/xfs/scrub/trace.c
> > > @@ -24,10 +24,11 @@ xchk_btree_cur_fsbno(
> > >  	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> > >  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> > >  				xfs_buf_daddr(cur->bc_bufs[level]));
> > > -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > > +
> > > +	if (level == cur->bc_nlevels - 1 &&
> > > +	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> > >  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
> > 
> > Ok.
> > 
> > > -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
> > > -		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
> > > +
> > 
> > But doesn't this break the tracing code on short pointers as the
> > tracing code does:
> > 
> > 	TP_fast_assign(
> > 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
> > 		...
> > 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
> > 
> > 
> > i.e. the tracing will no longer give the correct agno for per-ag
> > cursors that don't have any buffers attached to them at the current
> > level?
> 
> Hmmm.  By that logic, maybe we should get rid of the (level ==
> cur->bc_nlevels - 1) check entirely so that any cursor without a buffer
> attached at that level will always provide *some* kind of breadcrumb to
> the tracepoints?

Perhaps so.

> I almost did that instead, except for the consideration that if you're
> tracing the online fsck code, you should /probably/ have at least one of
> xchk_stop/xrep_attempt/xchk_done included in the filter list so you can
> be certain of what the kernel is checking.

It doesn't worry me how we resolve this - I just pointed it out
because it's not mentioned in the commit message and I wanted to
make sure it wasn't an oversight. If there are better ways to get
this information from tracepoints and XFS_FSB_TO_AGNO() does
something safe and obvious with NULLFSBLOCK (e.g. ends up as -1)
then as long as there's mention of this change in the commit message
I'm fine with it as it is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
