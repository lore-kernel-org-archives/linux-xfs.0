Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:41377 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdKWMIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 07:08:34 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH] xfs: handle register_shrinker error
Date: Thu, 23 Nov 2017 13:08:28 +0100
Message-Id: <20171123120828.31881-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

xfs_alloc_buftarg doesn't handle register_shrinker error path. While it
is unlikely to trigger it is not impossible especially with large NUMAs.
Let's handle the failure to make the code more robust.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---

Hi,
this is not tested but it looks quite straightforward. There is one more
unchecked register_shrinker in xfs_qm_init_quotainfo but my absolute
lack of familiarity with the code didn't allow me to come up with a
mechanical fix like this one.

 fs/xfs/xfs_buf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4db6e8d780f6..dd0e18af990c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1827,7 +1827,10 @@ xfs_alloc_buftarg(
 	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
 	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
-	register_shrinker(&btp->bt_shrinker);
+	if (register_shrinker(&btp->bt_shrinker)) {
+		percpu_counter_destroy(&btp->bt_io_count);
+		goto error;
+	}
 	return btp;
 
 error:
-- 
2.15.0

