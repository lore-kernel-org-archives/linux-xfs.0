Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFD7C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344336AbjD0Wt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbjD0Wt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73F2123
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 285B164037
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FC8C433D2;
        Thu, 27 Apr 2023 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635766;
        bh=Z6ErKVKhJ5wAFw0iVlsYRF71ZARsWz1imx4ismlaUCo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C3CvBjdqoZ9QqVmK6gWBpRTbIObGxoYOvFbHurMA+kYH53gfESMshHnIl3sSxYCvN
         Rro/JKZo+oRJqcpy4SiEmKHXRtJiHapYJCS8uIx2rz+lh8esG8vi5P0H04VOsLMXSv
         RfgYOIRmjm7tWWK/YIU4lPetQCmOfCI0iekYjcagmUAp99Hgg+65cYZXwA8oMwx5Qa
         MjQIQpB3TnR32p2SyqlOIrqv/IjRbnrESPM9SXe5SwgRBqycFmUxu2Amq1sZdW6uHW
         80v+EzlkTJgA6PdjfLFz1+RuBiehbPff7hpdDdP+Xn788XzHKT2/npYJALJ1WwlBim
         HLmMnwPmCNA9Q==
Subject: [PATCH 1/4] xfs: explicitly specify cpu when forcing inodegc delayed
 work to run immediately
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:49:26 -0700
Message-ID: <168263576602.1719564.2746529641753015911.stgit@frogsfrogsfrogs>
In-Reply-To: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I've been noticing odd racing behavior in the inodegc code that could
only be explained by one cpu adding an inode to its inactivation llist
at the same time that another cpu is processing that cpu's llist.
Preemption is disabled between get/put_cpu_ptr, so the only explanation
is scheduler mayhem.  I inserted the following debug code into
xfs_inodegc_worker (see the next patch):

	ASSERT(gc->cpu == smp_processor_id());

This assertion tripped during overnight tests on the arm64 machines, but
curiously not on x86_64.  I think we haven't observed any resource leaks
here because the lockfree list code can handle simultaneous llist_add
and llist_del_all functions operating on the same list.  However, the
whole point of having percpu inodegc lists is to take advantage of warm
memory caches by inactivating inodes on the last processor to touch the
inode.

The incorrect scheduling seems to occur after an inodegc worker is
subjected to mod_delayed_work().  This wraps mod_delayed_work_on with
WORK_CPU_UNBOUND specified as the cpu number.  Unbound allows for
scheduling on any cpu, not necessarily the same one that scheduled the
work.

Because preemption is disabled for as long as we have the gc pointer, I
think it's safe to use current_cpu() (aka smp_processor_id) to queue the
delayed work item on the correct cpu.

Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 351849fc18ff..58712113d5d6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2069,7 +2069,8 @@ xfs_inodegc_queue(
 		queue_delay = 0;
 
 	trace_xfs_inodegc_queue(mp, __return_address);
-	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
+	mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+			queue_delay);
 	put_cpu_ptr(gc);
 
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
@@ -2113,7 +2114,8 @@ xfs_inodegc_cpu_dead(
 
 	if (xfs_is_inodegc_enabled(mp)) {
 		trace_xfs_inodegc_queue(mp, __return_address);
-		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
+		mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+				0);
 	}
 	put_cpu_ptr(gc);
 }

