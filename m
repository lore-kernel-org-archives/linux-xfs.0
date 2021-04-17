Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679E4C43460
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 22:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE9C61245
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 22:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhDQWcd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Apr 2021 18:32:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59616 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235439AbhDQWcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Apr 2021 18:32:32 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EAEF88294F1;
        Sun, 18 Apr 2021 08:32:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lXtTt-00Ctnw-TN; Sun, 18 Apr 2021 08:32:01 +1000
Date:   Sun, 18 Apr 2021 08:32:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210417223201.GU63242@dread.disaster.area>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
 <20210417001941.GC3122276@magnolia>
 <20210417015702.GT63242@dread.disaster.area>
 <20210417022013.GA2266103@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417022013.GA2266103@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=wopbfWX6YrPUIz6aUQUA:9 a=BV5ithnxuq7gPmrf:21 a=SLilBIaixmDSDfAk:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 17, 2021 at 10:20:13AM +0800, Gao Xiang wrote:
> Hi Darrick and Dave,
> 
> On Sat, Apr 17, 2021 at 11:57:02AM +1000, Dave Chinner wrote:
> > On Fri, Apr 16, 2021 at 05:19:41PM -0700, Darrick J. Wong wrote:
> > > On Sat, Apr 17, 2021 at 05:13:20AM +0800, Gao Xiang wrote:
> 
> ...
> 
> > 
> > Nor is it necessary to fix the problem.
> > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > > > index 60e6d255e5e2..423dada3f64c 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > > > > >  
> > > > > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > > > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > > > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > > > > +
> > > > > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > > 
> > > Hmm... is this really needed?  I thought in !lazysbcount mode,
> > > xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
> > > So aren't all three of these updates unnecessary?
> > 
> > Yup, now I understand the issue, the fix is simply to avoid these
> > updates for !lazysb. i.e. it should just be:
> > 
> > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > 	}
> > 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> 
> I did as this because xfs_sb_to_disk() will override them, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/libxfs/xfs_sb.c#n629
> 
> ...
> 	to->sb_icount = cpu_to_be64(from->sb_icount);
> 	to->sb_ifree = cpu_to_be64(from->sb_ifree);
> 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);

> As an alternative, I was once to wrap it as:
> 
> xfs_sb_to_disk() {
> ...
> 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> 		to->sb_icount = cpu_to_be64(from->sb_icount);
> 		to->sb_ifree = cpu_to_be64(from->sb_ifree);
> 		to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> 	}
> ...
> }

This goes back to a commit in 2015 dropping the fields parameter from
xfs_sb_to_disk(). Originally, we only formatted the requested
parameters to the on-disk buffer from the in-memory superblock amd
this was removed in 2015 by commit 4d11a4023940 ("xfs: remove bitfield
based superblock updates") which meant all superblock modification
calls updated the entire on-disk log.

Up to that point, only xfs_log_sbcount() updated the on-disk
counters in the superblock buffer, and only for lazy-count enabled
filesystems. And xfs_bmap_add_attrfork() would only update the
features fields in the superblock, and nothing else. Now every
modification to the sueprblock updates everythign from the in-memory
state.

However, there are two sets of in-memory state for the superblock
accounting - the superblock fields and the per-cpu coutners. The
per-cpu counters are the ones we apply reservations to and the ones
we use for space tracking. The counters in the mp->m_sb are updated
in the same manner as the on-disk counters.

That is, xfs_trans_apply_sb_deltas() only applies deltas to the
directly to the in-memory superblock in the case of !lazy-count, so
these counters are actually a correct representation of the on-disk
value of the accounting when lazy-count=0.

Hence we should always be able to write the counters in mp->m_sb
directly to the on-disk superblock buffer in the case of
lazy-count=0 and the values should be correct. lazy-count=1 only
updates the mp->m_sb counters from the per-cpu counters so that the
on-disk counters aren't wildly inaccruate, and so that when we
unmount/freeze/etc the counters are actually correct.

Long story short, I think xfs_sb_to_disk() always updating the
on-disk superblock from mp->m_sb is safe to do as the counters in
mp->m_sb are updated in the same manner during transaction commit as
the superblock buffer counters for lazy-count=0....

> Yet after I observed the other callers of xfs_sb_to_disk() (e.g. growfs
> and online repair), I think a better modification is the way I proposed
> here, so no need to update xfs_sb_to_disk() and the other callers (since
> !lazysbcount is not recommended at all.)

Yup that's the original reason for having a fields flag to do
condition update of the on-disk buffer from the in-memory state.
Different code has diferrent requirements, but it looked like this
didn't matter for lazy-count filesystems because other checks
avoided the update of m_sb fields. What was missed in that
optimisation was the fact lazy-count=0 never updated the counters
directly.

/me is now wondering why we even bother with !lazy-count anymore.

WE've updated the agr btree block accounting unconditionally since
lazy-count was added, and scrub will always report a mismatch in
counts if they exist regardless of lazy-count. So why don't we just
start ignoring the on-disk value and always use lazy-count based
updates?

We only added it as mkfs option/feature bit because of the recovery
issue with not being able to account for btree blocks properly at
mount time, but now we have mechanisms for counting blocks in btrees
so even that has gone away. So we could actually just turn
on lazy-count at mount time, and we could get rid of this whole
set of subtle conditional behaviours we clearly aren't able to
exercise effectively...

> It's easier to backport and less conflict, and btw !lazysbcount also need
> to be warned out and deprecated from now.

You have to use -m crc=0 to turn off lazycount, and the deprecation
warning should come from -m crc=0...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
