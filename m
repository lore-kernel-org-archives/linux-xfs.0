Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38033 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfDJImg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 04:42:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id j26so1128963pgl.5
        for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2019 01:42:35 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] xfs,fstrim: fix to return correct minlen
Date: Wed, 10 Apr 2019 17:42:28 +0900
Message-Id: <1554885748-7071-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

This patch tries to address two problems:

1) return @minlen we used to trim to
user space.

2) return EINVAL if granularity is larger than
avg size, even most of cases, granularity is small(4K),
but if devices return a lager granularity for some reaons
(testing, bugs etc), fstrim should return failure directly.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/xfs/xfs_discard.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 93f07edafd81..66702b03587a 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -164,6 +164,8 @@ xfs_ioc_trim(
 	if (copy_from_user(&range, urange, sizeof(range)))
 		return -EFAULT;
 
+	range.minlen = max_t(u64, granularity, range.minlen);
+	minlen = BTOBB(range.minlen);
 	/*
 	 * Truncating down the len isn't actually quite correct, but using
 	 * BBTOB would mean we trivially get overflows for values
@@ -178,7 +180,6 @@ xfs_ioc_trim(
 
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
-	minlen = BTOBB(max_t(u64, granularity, range.minlen));
 
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
 		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
-- 
2.20.1
