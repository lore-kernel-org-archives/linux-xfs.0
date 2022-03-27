Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E9AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Mar 2022 22:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiC0W5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 18:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiC0W5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 18:57:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48C3D3151C
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 15:55:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8E100533F4E
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 09:55:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nYbnK-00Ag85-UG
        for linux-xfs@vger.kernel.org; Mon, 28 Mar 2022 09:55:35 +1100
Date:   Mon, 28 Mar 2022 09:55:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/6] xfs: xfs: shutdown during log recovery needs to mark the
 log shutdown
Message-ID: <20220327225534.GQ1544202@dread.disaster.area>
References: <20220324002103.710477-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324002103.710477-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6240eb68
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8
        a=yAJUlvxGiVCaNyWj6gcA:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

When a checkpoint writeback is run by log recovery, corruption
propagated from the log can result in writeback verifiers failing
and calling xfs_force_shutdown() from
xfs_buf_delwri_submit_buffers().

This results in the mount being marked as shutdown, but the log does
not get marked as shut down because:

        /*
         * If this happens during log recovery then we aren't using the runtime
         * log mechanisms yet so there's nothing to shut down.
         */
        if (!log || xlog_in_recovery(log))
                return false;

If there are other buffers that then fail (say due to detecting the
mount shutdown), they will now hang in xfs_do_force_shutdown()
waiting for the log to shut down like this:

  __schedule+0x30d/0x9e0
  schedule+0x55/0xd0
  xfs_do_force_shutdown+0x1cd/0x200
  ? init_wait_var_entry+0x50/0x50
  xfs_buf_ioend+0x47e/0x530
  __xfs_buf_submit+0xb0/0x240
  xfs_buf_delwri_submit_buffers+0xfe/0x270
  xfs_buf_delwri_submit+0x3a/0xc0
  xlog_do_recovery_pass+0x474/0x7b0
  ? do_raw_spin_unlock+0x30/0xb0
  xlog_do_log_recovery+0x91/0x140
  xlog_do_recover+0x38/0x1e0
  xlog_recover+0xdd/0x170
  xfs_log_mount+0x17e/0x2e0
  xfs_mountfs+0x457/0x930
  xfs_fs_fill_super+0x476/0x830

xlog_force_shutdown() always needs to mark the log as shut down,
regardless of whether recovery is in progress or not, so that
multiple calls to xfs_force_shutdown() during recovery don't end
up waiting for the log to be shut down like this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6166348ce1d1..5f3f943c34b9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3729,11 +3729,7 @@ xlog_force_shutdown(
 {
 	bool		log_error = (shutdown_flags & SHUTDOWN_LOG_IO_ERROR);
 
-	/*
-	 * If this happens during log recovery then we aren't using the runtime
-	 * log mechanisms yet so there's nothing to shut down.
-	 */
-	if (!log || xlog_in_recovery(log))
+	if (!log)
 		return false;
 
 	/*
@@ -3742,10 +3738,16 @@ xlog_force_shutdown(
 	 * before the force will prevent the log force from flushing the iclogs
 	 * to disk.
 	 *
-	 * Re-entry due to a log IO error shutdown during the log force is
-	 * prevented by the atomicity of higher level shutdown code.
+	 * When we are in recovery, there are no transactions to flush, and
+	 * we don't want to touch the log because we don't want to perturb the
+	 * current head/tail for future recovery attempts. Hence we need to
+	 * avoid a log force in this case.
+	 *
+	 * If we are shutting down due to a log IO error, then we must avoid
+	 * trying to write the log as that may just result in more IO errors and
+	 * an endless shutdown/force loop.
 	 */
-	if (!log_error)
+	if (!log_error && !xlog_in_recovery(log))
 		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
 	/*
