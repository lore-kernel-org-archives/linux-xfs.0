Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39476 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeKHFm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 00:42:56 -0500
Received: by mail-yb1-f196.google.com with SMTP id j9-v6so7362611ybj.6
        for <linux-xfs@vger.kernel.org>; Wed, 07 Nov 2018 12:11:01 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 1/2] xfs: change xfs_buf_ioapply_map to STATIC
Date: Wed,  7 Nov 2018 15:10:54 -0500
Message-Id: <20181107201055.25883-2-josef@toxicpanda.com>
In-Reply-To: <20181107201055.25883-1-josef@toxicpanda.com>
References: <20181107201055.25883-1-josef@toxicpanda.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kernel-team@fb.com, linux-xfs@vger.kernel.org

In order to make error injection triggering easier make
xfs_buf_ioapply_map STATIC so it's noinline and can be kprobe'ed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b21ea2ba768d..341bdb55b650 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1327,7 +1327,7 @@ xfs_buf_bio_end_io(
 	bio_put(bio);
 }
 
-static void
+STATIC void
 xfs_buf_ioapply_map(
 	struct xfs_buf	*bp,
 	int		map,
-- 
2.14.3
