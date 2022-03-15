Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71649C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 06:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345261AbiCOGoF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 02:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345266AbiCOGoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 02:44:02 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DB39CDB
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 23:42:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9CD5D10E4414
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:42:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-005elH-IS
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 17:42:43 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-00D9K1-H2
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 17:42:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: check buffer pin state after locking in delwri_submit
Date:   Tue, 15 Mar 2022 17:42:36 +1100
Message-Id: <20220315064241.3133751-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315064241.3133751-1-david@fromorbit.com>
References: <20220315064241.3133751-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62303565
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=CLV5itarnJPXgn4NHyQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

AIL flushing can get stuck here:

[316649.005769] INFO: task xfsaild/pmem1:324525 blocked for more than 123 seconds.
[316649.007807]       Not tainted 5.17.0-rc6-dgc+ #975
[316649.009186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[316649.011720] task:xfsaild/pmem1   state:D stack:14544 pid:324525 ppid:     2 flags:0x00004000
[316649.014112] Call Trace:
[316649.014841]  <TASK>
[316649.015492]  __schedule+0x30d/0x9e0
[316649.017745]  schedule+0x55/0xd0
[316649.018681]  io_schedule+0x4b/0x80
[316649.019683]  xfs_buf_wait_unpin+0x9e/0xf0
[316649.021850]  __xfs_buf_submit+0x14a/0x230
[316649.023033]  xfs_buf_delwri_submit_buffers+0x107/0x280
[316649.024511]  xfs_buf_delwri_submit_nowait+0x10/0x20
[316649.025931]  xfsaild+0x27e/0x9d0
[316649.028283]  kthread+0xf6/0x120
[316649.030602]  ret_from_fork+0x1f/0x30

in the situation where flushing gets preempted between the unpin
check and the buffer trylock under nowait conditions:

	blk_start_plug(&plug);
	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
		if (!wait_list) {
			if (xfs_buf_ispinned(bp)) {
				pinned++;
				continue;
			}
Here >>>>>>
			if (!xfs_buf_trylock(bp))
				continue;

This means submission is stuck until something else triggers a log
force to unpin the buffer.

To get onto the delwri list to begin with, the buffer pin state has
already been checked, and hence it's relatively rare we get a race
between flushing and encountering a pinned buffer in delwri
submission to begin with. Further, to increase the pin count the
buffer has to be locked, so the only way we can hit this race
without failing the trylock is to be preempted between the pincount
check seeing zero and the trylock being run.

Hence to avoid this problem, just invert the order of trylock vs
pin check. We shouldn't hit that many pinned buffers here, so
optimising away the trylock for pinned buffers should not matter for
performance at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b45e0d50a405..8867f143598e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2094,12 +2094,13 @@ xfs_buf_delwri_submit_buffers(
 	blk_start_plug(&plug);
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		if (!wait_list) {
+			if (!xfs_buf_trylock(bp))
+				continue;
 			if (xfs_buf_ispinned(bp)) {
+				xfs_buf_unlock(bp);
 				pinned++;
 				continue;
 			}
-			if (!xfs_buf_trylock(bp))
-				continue;
 		} else {
 			xfs_buf_lock(bp);
 		}
-- 
2.35.1

