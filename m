Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68323C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 21:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EE5A2088F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 21:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKTVId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 16:08:33 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39566 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbfKTVId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 16:08:33 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 965173A2319;
        Thu, 21 Nov 2019 08:08:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXXD7-0002A7-2O; Thu, 21 Nov 2019 08:08:25 +1100
Date:   Thu, 21 Nov 2019 08:08:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191120210825.GB4614@dread.disaster.area>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
 <20191105040325.GC4614@dread.disaster.area>
 <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
 <20191106212041.GF4614@dread.disaster.area>
 <d627883a-850c-1ec4-e057-cf9e9b47c50e@hisilicon.com>
 <20191118081212.GT4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118081212.GT4614@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=T9Hc69SieLuhof2lk3kA:9
        a=qyLU5ewVQqYIvHzN:21 a=vBulLvBynwsOmItW:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 18, 2019 at 07:12:12PM +1100, Dave Chinner wrote:
> On Fri, Nov 08, 2019 at 01:58:56PM +0800, Shaokun Zhang wrote:
> > On 2019/11/7 5:20, Dave Chinner wrote:
> > Because percpu_counter_batch was initialized to 256 when there are 128 cpu cores.
> > Then we change the agcount=1024, and it also goes to slow path frequently because
> > mostly there are no 32768 free inodes.
> 
> Hmmm. I had forgotten the batch size increased with CPU count like
> that - I had the thought it was log(ncpus), not linear(ncpus).

[.....]

> Ok, so maybe we just need a small batch size here, like a value of 4
> or 8 just to avoid every inode alloc/free transaction having to pick
> up a global spin lock every time...
> 
> Let me do some testing here...

[....]

> > Agree, I mean that when delta > 0, there is no need to call percpu_counter_compare in
> > xfs_mod_ifree/icount.

Ok, so the percpu_counter_sum() only shows up during a create
workload here, at ~1.5% of the CPU used. only doing the check when
delta < 0 makes no difference to that value. CPU usage of
percpu_counter_sum is noise for all other parts of the workload
workloads, including the "remove files" part of the benchmark.

Hence it is this pattern:

> i.e. The pattern we see on inode allocation is:
> 
> 	icount += 64
> 	ifree += 64
> 	ifree--
> 	....
> 	ifree--
> 	icount += 64
> 	ifree += 64
> 	ifree--
> 	....
> 	ifree--

That is causing the compare CPU usage - all the single decrements
are triggering it because we are operating on a new filesystem that
has no free inodes other than the cluster we just allocated. Hence
avoiding doing the value compare when delta > 0 makes no difference
to CPU usage because most of the modifications are subraction.

> And on inode freeing, we see the opposite:
> 
> 	ifree++
> 	....
> 	ifree++
> 	icount -= 64
> 	ifree -= 64
> 	ifree++
> 	....
> 	ifree++
> 	icount -= 64
> 	ifree -= 64

For freeing, we aren't always freeing from the same inode cluster,
so the ifree count actually goes up quite a bit before it starts
going down as we free clusters. Hence if we keep the batch size
small here, we should mostly stay out of the compare path, and the
"no compare when delta > 0" will also make a substantial difference
here if the ifree count is low.

So, I reduced the batch size to 8, and CPU usage during creates
dropped from 1.5% to 0.6% on a 16p machine. That's a substantial
reduction - if this translates to larger machines, that should bring
CPU usage down under 2%....

I was going to send this patch for you to test, but I left this
email sitting unsent overnight and I thought about it some more.

The reality is, as Christoph said, this ends up being just debug
code because we silently ignore the underflow error on production
kernels. Hence I think the right thing to do is gut the transaction
superblock accounting code so that we need simple asserts and don't
bother trying to behave like it's an error we can actually handle
sanely. This removes the compare from production kernels completely,
so you should see this all go away with the patch below.

The difference in performance on my 16p machine is not significant -
it is within the normal run-to-run variability of the mdtest
benchmark, but the counter compare overhead is gone from the
profiles.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()

From: Dave Chinner <dchinner@redhat.com>

The error handling is only used to fire an assert on debug
kernels, so lets get rid of all the complexity and expensive
stuff that is done to determine if an assert will fire.

Rolling back the changes in the transaction if only one counter
underruns them makes all the other counters incorrect, because we
still have made that change and are committing the transaction.
Hence we can remove all the unwinding, too.

And xfs_mod_icount/xfs_mod_ifree are only called from
xfs_trans_unreserve_and_mod_sb(), so get rid of them and just
directly call the percpu_counter_add/percpu_counter_compare
functions.

Difference in binary size for a production kernel:

Before:
   text    data     bss     dec     hex filename
   9486     184       8    9678    25ce fs/xfs/xfs_trans.o
  10858      89      12   10959    2acf fs/xfs/xfs_mount.o

After:
   text    data     bss     dec     hex filename
   8462     184       8    8654    21ce fs/xfs/xfs_trans.o
  10510      89      12   10611    2973 fs/xfs/xfs_mount.o

So not only does it chop out a lot of source code, it also results
in a binary size reduction of ~1.3kB in a very frequently used
fast path of the filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |  33 ------------
 fs/xfs/xfs_mount.h |   2 -
 fs/xfs/xfs_trans.c | 153 +++++++++++++----------------------------------------
 3 files changed, 37 insertions(+), 151 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3b2b88..c59d8f589eb9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1163,39 +1163,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return xfs_sync_sb(mp, true);
 }
 
-/*
- * Deltas for the inode count are +/-64, hence we use a large batch size
- * of 128 so we don't need to take the counter lock on every update.
- */
-#define XFS_ICOUNT_BATCH	128
-int
-xfs_mod_icount(
-	struct xfs_mount	*mp,
-	int64_t			delta)
-{
-	percpu_counter_add_batch(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
-	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
-		ASSERT(0);
-		percpu_counter_add(&mp->m_icount, -delta);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-int
-xfs_mod_ifree(
-	struct xfs_mount	*mp,
-	int64_t			delta)
-{
-	percpu_counter_add(&mp->m_ifree, delta);
-	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
-		ASSERT(0);
-		percpu_counter_add(&mp->m_ifree, -delta);
-		return -EINVAL;
-	}
-	return 0;
-}
-
 /*
  * Deltas for the block count can vary from 1 to very large, but lock contention
  * only occurs on frequent small block count updates such as in the delayed
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fdb60e09a9c5..0324412238ba 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -438,8 +438,6 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
 				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
-extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
-extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f4795fdb7389..7632868bdc92 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -527,57 +527,51 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-STATIC int
+static void
 xfs_sb_mod8(
 	uint8_t			*field,
 	int8_t			delta)
 {
 	int8_t			counter = *field;
 
+	if (!delta)
+		return;
 	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
+	ASSERT(counter >= 0);
 	*field = counter;
-	return 0;
 }
 
-STATIC int
+static void
 xfs_sb_mod32(
 	uint32_t		*field,
 	int32_t			delta)
 {
 	int32_t			counter = *field;
 
+	if (!delta)
+		return;
 	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
+	ASSERT(counter >= 0);
 	*field = counter;
-	return 0;
 }
 
-STATIC int
+static void
 xfs_sb_mod64(
 	uint64_t		*field,
 	int64_t			delta)
 {
 	int64_t			counter = *field;
 
+	if (!delta)
+		return;
 	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
+	ASSERT(counter >= 0);
 	*field = counter;
-	return 0;
 }
 
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
- * and apply superblock counter changes to the in-core superblock.  The
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
+ * apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
@@ -586,7 +580,12 @@ xfs_sb_mod64(
  * used block counts are not updated in the on disk superblock. In this case,
  * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
  * still need to update the incore superblock with the changes.
+ *
+ * Deltas for the inode count are +/-64, hence we use a large batch size of 128
+ * so we don't need to take the counter lock on every update.
  */
+#define XFS_ICOUNT_BATCH	128
+
 void
 xfs_trans_unreserve_and_mod_sb(
 	struct xfs_trans	*tp)
@@ -622,20 +621,21 @@ xfs_trans_unreserve_and_mod_sb(
 	/* apply the per-cpu counters */
 	if (blkdelta) {
 		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		if (error)
-			goto out;
+		ASSERT(!error);
 	}
 
 	if (idelta) {
-		error = xfs_mod_icount(mp, idelta);
-		if (error)
-			goto out_undo_fdblocks;
+		percpu_counter_add_batch(&mp->m_icount, idelta,
+					 XFS_ICOUNT_BATCH);
+		if (idelta < 0)
+			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
+							XFS_ICOUNT_BATCH) >= 0);
 	}
 
 	if (ifreedelta) {
-		error = xfs_mod_ifree(mp, ifreedelta);
-		if (error)
-			goto out_undo_icount;
+		percpu_counter_add(&mp->m_ifree, ifreedelta);
+		if (ifreedelta < 0)
+			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
@@ -643,95 +643,16 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
-	if (rtxdelta) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
-		if (error)
-			goto out_undo_ifree;
-	}
-
-	if (tp->t_dblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
-		if (error)
-			goto out_undo_frextents;
-	}
-	if (tp->t_agcount_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
-		if (error)
-			goto out_undo_dblocks;
-	}
-	if (tp->t_imaxpct_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
-		if (error)
-			goto out_undo_agcount;
-	}
-	if (tp->t_rextsize_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
-				     tp->t_rextsize_delta);
-		if (error)
-			goto out_undo_imaxpct;
-	}
-	if (tp->t_rbmblocks_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
-				     tp->t_rbmblocks_delta);
-		if (error)
-			goto out_undo_rextsize;
-	}
-	if (tp->t_rblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
-		if (error)
-			goto out_undo_rbmblocks;
-	}
-	if (tp->t_rextents_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
-				     tp->t_rextents_delta);
-		if (error)
-			goto out_undo_rblocks;
-	}
-	if (tp->t_rextslog_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
-				     tp->t_rextslog_delta);
-		if (error)
-			goto out_undo_rextents;
-	}
-	spin_unlock(&mp->m_sb_lock);
-	return;
-
-out_undo_rextents:
-	if (tp->t_rextents_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
-out_undo_rblocks:
-	if (tp->t_rblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
-out_undo_rbmblocks:
-	if (tp->t_rbmblocks_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
-out_undo_rextsize:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
-out_undo_imaxpct:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
-out_undo_agcount:
-	if (tp->t_agcount_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
-out_undo_dblocks:
-	if (tp->t_dblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
-out_undo_frextents:
-	if (rtxdelta)
-		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
-out_undo_ifree:
+	xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
+	xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
+	xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
+	xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
+	xfs_sb_mod32(&mp->m_sb.sb_rextsize, tp->t_rextsize_delta);
+	xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, tp->t_rbmblocks_delta);
+	xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
+	xfs_sb_mod64(&mp->m_sb.sb_rextents, tp->t_rextents_delta);
+	xfs_sb_mod8(&mp->m_sb.sb_rextslog, tp->t_rextslog_delta);
 	spin_unlock(&mp->m_sb_lock);
-	if (ifreedelta)
-		xfs_mod_ifree(mp, -ifreedelta);
-out_undo_icount:
-	if (idelta)
-		xfs_mod_icount(mp, -idelta);
-out_undo_fdblocks:
-	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
-out:
-	ASSERT(error == 0);
 	return;
 }
 
