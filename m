Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:49667 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfHAKFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 06:05:25 -0400
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] xfs: show error code when printing writeback error messages.
Date: Thu,  1 Aug 2019 19:03:46 +0900
Message-Id: <1564653826-8916-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Even without backtraces, including error code should be helpful.

  [  630.162595][ T9218] XFS (sda1): writeback error -12 on sector 131495992
  [  631.718685][ T9432] XFS (sda1): writeback error -12 on sector 131503928
  [  632.015588][  T442] XFS (sda1): writeback error -12 on sector 157773936

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f16d5f196c6b..d2c9076643cf 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -112,7 +112,7 @@ xfs_destroy_ioend(
 
 	if (unlikely(error && !quiet)) {
 		xfs_err_ratelimited(XFS_I(inode)->i_mount,
-			"writeback error on sector %llu", start);
+			"writeback error %d on sector %llu", error, start);
 	}
 }
 
-- 
2.16.5
