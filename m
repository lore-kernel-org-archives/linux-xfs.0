Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E8FC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 01:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2D061430
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 01:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhDVBpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 21:45:23 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59487 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229740AbhDVBpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 21:45:22 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F01A484B495;
        Thu, 22 Apr 2021 11:44:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lZOOc-001gzX-16; Thu, 22 Apr 2021 11:44:46 +1000
Date:   Thu, 22 Apr 2021 11:44:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210422014446.GZ63242@dread.disaster.area>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
 <20210420215443.GA3047037@xiangao.remote.csb>
 <20210421014526.GY63242@dread.disaster.area>
 <20210421030129.GA3095436@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421030129.GA3095436@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=3_uRt0xjAAAA:8 a=7-415B0cAAAA:8
        a=20KFwNOVAAAA:8 a=jKzYNAsfRhvObH0YQE0A:9 a=6auCuuOFA1vnnNCG:21
        a=-fWEIMhM_uqq8Sar:21 a=CjuIK1q_8ugA:10 a=z1SuboXgGPGzQ8_2mWib:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 11:01:29AM +0800, Gao Xiang wrote:
> On Wed, Apr 21, 2021 at 11:45:26AM +1000, Dave Chinner wrote:
> > On Wed, Apr 21, 2021 at 05:54:43AM +0800, Gao Xiang wrote:
> > #1 is bad because there are cases where we want to write the
> > counters even for !lazysbcount filesystems (e.g. mkfs, repair, etc).
> > 
> > #2 is essentially a hack around the fact that mp->m_sb is not kept
> > up to date in the in-memory superblock for !lazysbcount filesystems.
> > 
> > #3 keeps the in-memory superblock up to date for !lazysbcount case
> > so they are coherent with the on-disk values and hence we only need
> > to update the in-memory superblock counts for lazysbcount
> > filesystems before calling xfs_sb_to_disk().
> > 
> > #3 is my preferred solution.
> > 
> > > That will indeed cause more modification, I'm not quite sure if it's
> > > quite ok honestly. But if you assume that's more clear, I could submit
> > > an alternative instead later.
> > 
> > I think the version you posted doesn't fix the entire problem. It
> > merely slaps a band-aid over the symptom that is being seen, and
> > doesn't address all the non-coherent data that can be written to the
> > superblock here.
> 
> As I explained on IRC as well, I think for !lazysbcount cases, fdblocks,
> icount and ifree are protected by sb buffer lock. and the only users of
> these three are:
>  1) xfs_trans_apply_sb_deltas()
>  2) xfs_log_sb()

That's just a happy accident and not intentional in any way. Just
fixing the case that occurs while holding the sb buffer lock doesn't
actually fix the underlying problem, it just uses this as a bandaid.

> 
> So I've seen no need to update sb_icount, sb_ifree in that way (I mean
> my v2, although I agree it's a bit hacky.) only sb_fdblocks matters.
> 
> But the reason why this patch exist is only to backport to old stable
> kernels, since after [PATCH v2 2/2], we can get rid of all of
> !lazysbcount cases upstream.
> 
> But if we'd like to do more e.g. by taking m_sb_lock, I've seen the
> xfs codebase quite varies these years. and I modified some version
> like http://paste.debian.net/1194481/

I said on IRC that this is what xfs_trans_unreserve_and_mod_sb() is
for. For !lazysbcount filesystems the transaction will be marked
dirty (i.e XFS_TRANS_SB_DIRTY is set) and so we'll always run the
slow path that takes the m_sb_lock and updates mp->m_sb. 

It's faster for me to explain this by patch than any other way. See
below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: update superblock counters correctly for !lazysbcount

From: Dave Chinner <dchinner@redhat.com>

Keep the mount superblock counters up to date for !lazysbcount
filesystems so that when we log the superblock they do not need
updating in any way because they are already correct.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
 fs/xfs/xfs_trans.c     |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9630f9e2f540..7d4c238540d4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -794,9 +794,19 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
-	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	/*
+	 * Lazy sb counters don't update the in-core superblock so do that now.
+	 * If this is at unmount, the counters will be exactly correct, but at
+	 * any other time they will only be ballpark correct because of
+	 * reservations that have been taken out percpu counters. If we have an
+	 * unclean shutdown, this will be corrected by log recovery rebuilding
+	 * the counters from the AGF block counts.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc978011869..438e41931b55 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_fdblocks += blkdelta;
+	mp->m_sb.sb_icount += idelta;
+	mp->m_sb.sb_ifree += ifreedelta;
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
