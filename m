Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1E1C433ED
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 22:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE3D61026
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 22:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhDRWJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Apr 2021 18:09:08 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:43024 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232023AbhDRWJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 18:09:06 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A4F391AF057;
        Mon, 19 Apr 2021 08:08:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lYFah-00EPyK-5K; Mon, 19 Apr 2021 08:08:31 +1000
Date:   Mon, 19 Apr 2021 08:08:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210418220831.GV63242@dread.disaster.area>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
 <20210417001941.GC3122276@magnolia>
 <20210417015702.GT63242@dread.disaster.area>
 <20210417022013.GA2266103@xiangao.remote.csb>
 <20210417223201.GU63242@dread.disaster.area>
 <20210417235948.GB2266103@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417235948.GB2266103@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=oNa4xhqiV8y4fKZljL4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 18, 2021 at 07:59:48AM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On Sun, Apr 18, 2021 at 08:32:01AM +1000, Dave Chinner wrote:
> > On Sat, Apr 17, 2021 at 10:20:13AM +0800, Gao Xiang wrote:
> 
> ...
> 
> > > > > Hmm... is this really needed?  I thought in !lazysbcount mode,
> > > > > xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
> > > > > So aren't all three of these updates unnecessary?
> > > > 
> > > > Yup, now I understand the issue, the fix is simply to avoid these
> > > > updates for !lazysb. i.e. it should just be:
> > > > 
> > > > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > > 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > > 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > > 	}
> > > > 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > > 
> > > I did as this because xfs_sb_to_disk() will override them, see:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/libxfs/xfs_sb.c#n629
> > > 
> > > ...
> > > 	to->sb_icount = cpu_to_be64(from->sb_icount);
> > > 	to->sb_ifree = cpu_to_be64(from->sb_ifree);
> > > 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> > 
> > > As an alternative, I was once to wrap it as:
> > > 
> > > xfs_sb_to_disk() {
> > > ...
> > > 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > 		to->sb_icount = cpu_to_be64(from->sb_icount);
> > > 		to->sb_ifree = cpu_to_be64(from->sb_ifree);
> > > 		to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> > > 	}
> > > ...
> > > }
> > 
> 
> ...
> 
> > 
> > That is, xfs_trans_apply_sb_deltas() only applies deltas to the
> > directly to the in-memory superblock in the case of !lazy-count, so
> > these counters are actually a correct representation of the on-disk
> > value of the accounting when lazy-count=0.
> > 
> > Hence we should always be able to write the counters in mp->m_sb
> > directly to the on-disk superblock buffer in the case of
> > lazy-count=0 and the values should be correct. lazy-count=1 only
> > updates the mp->m_sb counters from the per-cpu counters so that the
> > on-disk counters aren't wildly inaccruate, and so that when we
> > unmount/freeze/etc the counters are actually correct.
> > 
> > Long story short, I think xfs_sb_to_disk() always updating the
> > on-disk superblock from mp->m_sb is safe to do as the counters in
> > mp->m_sb are updated in the same manner during transaction commit as
> > the superblock buffer counters for lazy-count=0....
> 
> Thanks for your long words, I have to say I don't quite get what's
> your thought here, if my understanding is correct,
> xfs_trans_apply_sb_deltas() for !lazy-count case just directly
> update on-disk superblock (rather than in-memory superblock), see:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_trans.c?h=v5.12-rc2#n501
> 
> 	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
> 		if (tp->t_icount_delta)
> 			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
> 		if (tp->t_ifree_delta)
> 			be64_add_cpu(&sbp->sb_ifree, tp->t_ifree_delta);
> 		if (tp->t_fdblocks_delta)
> 			be64_add_cpu(&sbp->sb_fdblocks, tp->t_fdblocks_delta);
> 		if (tp->t_res_fdblocks_delta)
> 			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
> 	}

Yeah, I think I misread this jumping between diffs, commits, the
historic tree, etc. got tangled up in the twisty, gnarly branches of
the code...

> > /me is now wondering why we even bother with !lazy-count anymore.
> > 
> > WE've updated the agr btree block accounting unconditionally since
> > lazy-count was added, and scrub will always report a mismatch in
> > counts if they exist regardless of lazy-count. So why don't we just
> > start ignoring the on-disk value and always use lazy-count based
> > updates?
> > 
> > We only added it as mkfs option/feature bit because of the recovery
> > issue with not being able to account for btree blocks properly at
> > mount time, but now we have mechanisms for counting blocks in btrees
> > so even that has gone away. So we could actually just turn
> > on lazy-count at mount time, and we could get rid of this whole
> > set of subtle conditional behaviours we clearly aren't able to
> > exercise effectively...
> 
> If my understanding of the words above is correct, maybe that could
> be unfriendly when users turned back to some old kernels. But
> considering lazysbcount has been landed for quite quite long time,
> I think that is practical as 2 patches:
>  1) fix sb counters for !lazysbcount;
>  2) turn on lazysbcount at the mount time from now (and warn users).

Yup, that seems reasonable to me - getting rid of all the
lazysbcount checks everywhere except the mount path would simplify
the code a lot...

> > You have to use -m crc=0 to turn off lazycount, and the deprecation
> > warning should come from -m crc=0...
> 
> Yes, but I think 2030 is too far for this !lazysbcount feature, since
> it seems easy to cause potential bugs. I think maybe we could get rid
> of it as soon as possible.

Yeah, that's why I think we just turn it on unconditionally. It's
already deprecated, and all supported long term kernels support lazy
counters, so there's no reason for needing lazy-count=0 anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
