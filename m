Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262CEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 07:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354284AbiCPHqS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 03:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354280AbiCPHqR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 03:46:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E14856201
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 00:45:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 39C7B533602;
        Wed, 16 Mar 2022 18:44:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUOL5-0064MG-2r; Wed, 16 Mar 2022 18:44:59 +1100
Date:   Wed, 16 Mar 2022 18:44:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: Regression in XFS for fsync heavy workload
Message-ID: <20220316074459.GP3927073@dread.disaster.area>
References: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
 <20220316010627.GO3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316010627.GO3927073@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6231957c
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=VwQbUJbxAAAA:8 a=Wl3NpEY5D9dmIcaYMz4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 12:06:27PM +1100, Dave Chinner wrote:
> On Tue, Mar 15, 2022 at 01:49:43PM +0100, Jan Kara wrote:
> > Hello,
> > 
> > I was tracking down a regression in dbench workload on XFS we have
> > identified during our performance testing. These are results from one of
> > our test machine (server with 64GB of RAM, 48 CPUs, SATA SSD for the test
> > disk):
> > 
> > 			       good		       bad
> > Amean     1        64.29 (   0.00%)       73.11 * -13.70%*
> > Amean     2        84.71 (   0.00%)       98.05 * -15.75%*
> > Amean     4       146.97 (   0.00%)      148.29 *  -0.90%*
> > Amean     8       252.94 (   0.00%)      254.91 *  -0.78%*
> > Amean     16      454.79 (   0.00%)      456.70 *  -0.42%*
> > Amean     32      858.84 (   0.00%)      857.74 (   0.13%)
> > Amean     64     1828.72 (   0.00%)     1865.99 *  -2.04%*
> > 
> > Note that the numbers are actually times to complete workload, not
> > traditional dbench throughput numbers so lower is better.
....

> > This should still
> > submit it rather early to provide the latency advantage. Otherwise postpone
> > the flush to the moment we know we are going to flush the iclog to save
> > pointless flushes. But we would have to record whether the flush happened
> > or not in the iclog and it would all get a bit hairy...
> 
> I think we can just set the NEED_FLUSH flag appropriately.
> 
> However, given all this, I'm wondering if the async cache flush was
> really a case of premature optimisation. That is, we don't really
> gain anything by reducing the flush latency of the first iclog write
> wehn we are writing 100-1000 iclogs before the commit record, and it
> can be harmful to some workloads by issuing more flushes than we
> need to.
> 
> So perhaps the right thing to do is just get rid of it and always
> mark the first iclog in a checkpoint as NEED_FLUSH....

So I've run some tests on code that does this, and the storage I've
tested it on shows largely no difference in stream CIL commit and
fsync heavy workloads when comparing synv vs as cache flushes. On
set of tests was against high speed NVMe ssds, the other against
old, slower SATA SSDs.

Jan, can you run the patch below (against 5.17-rc8) and see what
results you get on your modified dbench test?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: drop async cache flushes from CIL commits.

From: Dave Chinner <dchinner@redhat.com>

As discussed here:

https://lore.kernel.org/linux-xfs/20220316010627.GO3927073@dread.disaster.area/T/#t

This is a prototype for removing async cache flushes from the CIL
checkpoint path. Fast NVME storage.

From `dbench -t 30`, current TOT:

clients		async			sync
		BW	Latency		BW	Latency
1		 767.14   0.858		 792.10   0.812
8		2231.18   5.607		2263.24  10.985
16		3023.25   5.779		2999.16   7.087
32		3712.80  11.468		3649.19   9.967
128		5997.98  13.719		6973.84  12.620
512		4256.29 104.050		5089.61  97.548

From `dbench -t 30`, CIL scale:

clients		async			sync
		BW	Latency		BW	Latency
1		 935.18   0.855		 915.64   0.903
8		2404.51   6.873		2341.77   6.511
16		3003.42   6.460		2931.57   6.529
32		3697.23   7.939		3596.28   7.894
128		7237.43  15.495		7217.74  11.588
512		5079.24  90.587		5167.08  95.822

fsmark, 32 threads, create w/ 64 byte xattr w/32k logbsize

	create		chown		unlink
async   1m41s		1m16s		2m03s
sync	1m40s		1m19s		1m54s

async log iops: up to 17kiops
async log b/w: up to 570MB/s

sync log iops: up to 18kiops
sync log b/w: up to 600MB/s

Ok, so there's really no difference from async flushes on really
fast storage.

Slower storage:

From `dbench -t 30`, CIL scale:

clients		async			sync
		BW	Latency		BW	Latency
1		  78.59  15.792		  83.78  10.729
8		 367.88  92.067		 404.63  59.943
16		 564.51  72.524		 602.71  76.089
32		 831.66 105.984		 870.26 110.482
128		1659.76 102.969		1624.73  91.356
512		2135.91 223.054		2603.07 161.160

fsmark, 16 threads, create w/32k logbsize

	create		unlink
async   5m06s		4m15s
sync	5m00s		4m22s


Mostly no change here, either. Possibly a bit better fsync overload
behaviour with sync flushes.

I think we can probably just get rid of async flushes altogether for
the moment. It looked necessary when developing the code, but seems
to be complexity we don't actually need now that it's settled down a
bit and all the bugs have been flushed out.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 83a039762b81..14746253805b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -705,11 +705,21 @@ xlog_cil_set_ctx_write_state(
 		 * The LSN we need to pass to the log items on transaction
 		 * commit is the LSN reported by the first log vector write, not
 		 * the commit lsn. If we use the commit record lsn then we can
-		 * move the tail beyond the grant write head.
+		 * move the grant write head beyond the tail LSN and overwrite
+		 * it.
 		 */
 		ctx->start_lsn = lsn;
 		wake_up_all(&cil->xc_start_wait);
 		spin_unlock(&cil->xc_push_lock);
+
+		/*
+		 * Make sure the metadata we are about to overwrite in the log
+		 * has been flushed to stable storage before this iclog is
+		 * issued.
+		 */
+		spin_lock(&cil->xc_log->l_icloglock);
+		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
+		spin_unlock(&cil->xc_log->l_icloglock);
 		return;
 	}
 
@@ -888,10 +898,10 @@ xlog_cil_push_work(
 	struct xfs_trans_header thdr;
 	struct xfs_log_iovec	lhdr;
 	struct xfs_log_vec	lvhdr = { NULL };
-	xfs_lsn_t		preflush_tail_lsn;
+//	xfs_lsn_t		preflush_tail_lsn;
 	xfs_csn_t		push_seq;
 	struct bio		bio;
-	DECLARE_COMPLETION_ONSTACK(bdev_flush);
+//	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 	bool			push_commit_stable;
 
 	new_ctx = xlog_cil_ctx_alloc();
@@ -974,9 +984,9 @@ xlog_cil_push_work(
 	 * before the iclog write. To detect whether the log tail moves, sample
 	 * the tail LSN *before* we issue the flush.
 	 */
-	preflush_tail_lsn = atomic64_read(&log->l_tail_lsn);
-	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
-				&bdev_flush);
+//	preflush_tail_lsn = atomic64_read(&log->l_tail_lsn);
+//	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
+//				&bdev_flush);
 
 	/*
 	 * Pull all the log vectors off the items in the CIL, and remove the
@@ -1058,7 +1068,7 @@ xlog_cil_push_work(
 	 * Before we format and submit the first iclog, we have to ensure that
 	 * the metadata writeback ordering cache flush is complete.
 	 */
-	wait_for_completion(&bdev_flush);
+//	wait_for_completion(&bdev_flush);
 
 	error = xlog_cil_write_chain(ctx, &lvhdr);
 	if (error)
@@ -1118,7 +1128,8 @@ xlog_cil_push_work(
 	if (push_commit_stable &&
 	    ctx->commit_iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(log, ctx->commit_iclog, 0);
-	xlog_state_release_iclog(log, ctx->commit_iclog, preflush_tail_lsn);
+//	xlog_state_release_iclog(log, ctx->commit_iclog, preflush_tail_lsn);
+	xlog_state_release_iclog(log, ctx->commit_iclog, 0);
 
 	/* Not safe to reference ctx now! */
 
