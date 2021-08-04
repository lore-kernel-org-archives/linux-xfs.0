Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BF2C4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 10:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE85960EE5
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 10:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhHDKqx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 06:46:53 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34664 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237091AbhHDKqv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 06:46:51 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7C9A21B313A;
        Wed,  4 Aug 2021 20:46:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBEPg-00EO33-Dc; Wed, 04 Aug 2021 20:46:16 +1000
Date:   Wed, 4 Aug 2021 20:46:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH] xfs: don't run inodegc flushes when inodegc is not active
Message-ID: <20210804104616.GL2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804032030.GT3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8
        a=ccHITOwOUxjkRM4rX4gA:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

A flush trigger on a frozen filesystem (e.g. from statfs)
will run queued inactivations and assert fail like this:

XFS: Assertion failed: mp->m_super->s_writers.frozen < SB_FREEZE_FS, file: fs/xfs/xfs_icache.c, line: 1861

Bug exposed by xfs/011.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 92006260fe90..f772f2a67a8b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1893,8 +1893,8 @@ xfs_inodegc_worker(
  * wait for the work to finish. Two pass - queue all the work first pass, wait
  * for it in a second pass.
  */
-void
-xfs_inodegc_flush(
+static void
+__xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
 	struct xfs_inodegc	*gc;
@@ -1913,6 +1913,14 @@ xfs_inodegc_flush(
 	}
 }
 
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	if (xfs_is_inodegc_enabled(mp))
+		__xfs_inodegc_flush(mp);
+}
+
 /*
  * Flush all the pending work and then disable the inode inactivation background
  * workers and wait for them to stop.
@@ -1927,7 +1935,7 @@ xfs_inodegc_stop(
 	if (!xfs_clear_inodegc_enabled(mp))
 		return;
 
-	xfs_inodegc_flush(mp);
+	__xfs_inodegc_flush(mp);
 
 	for_each_online_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
