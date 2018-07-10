Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751194AbeGJJlf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jul 2018 05:41:35 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] common/xfs: remove bad xfs_repair -t option
Date: Tue, 10 Jul 2018 17:41:29 +0800
Message-Id: <20180710094129.1052-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

The xfs_repair "-t" option shouldn't be used alone. An interval must
follow the -t option, or xfs_repair will report errors. And only
modify reporting interval is useless, if we don't enable ag_stride.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

I don't know why we must need the -t option for xfs_repair, I can't
find any description to explain it. But I can find an explanation
about why we use "-t" for _xfs_check.

  # xfs_check runs out of memory on large files, so even providing the test
  # option (-t) to avoid indexing the free space trees doesn't make it pass on
  # large filesystems. Avoid it.

The -t option for xfs_repair is totally different with it for
xfs_check, maybe -m option is more useful if we think about the
memory size.

And the -t option need to work with -o ag_stride together. I'd like
to remove the "-t" option directly, due to I really don't know why
we need it, or how to give it a proper number.

If the original author knows why we need it, and can give me some
suggestions, please help.

Thanks,
Zorro

 common/xfs | 1 -
 1 file changed, 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index ecf54bbf..61a3c2d9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -193,7 +193,6 @@ _scratch_xfs_repair()
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
 		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -r$SCRATCH_RTDEV"
-	[ "$LARGE_SCRATCH_DEV" = yes ] && SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
 	$XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
-- 
2.14.4

