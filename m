Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933178AbdEOKWJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 May 2017 06:22:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B1E480C1A
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2017 10:22:04 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs: bad assertion for delalloc an extent that start at i_size
Date: Mon, 15 May 2017 18:21:50 +0800
Message-Id: <1494843710-15350-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: zlang@redhat.com

By run fsstress long enough time enough in RHEL-7, I find an
assertion failure (harder to reproduce on linux-4.11, but problem
is still there):

  XFS: Assertion failed: (iflags & BMV_IF_DELALLOC) != 0, file: fs/xfs/xfs_bmap_util.c

The assertion is in xfs_getbmap() funciton:

  if (map[i].br_startblock == DELAYSTARTBLOCK &&
-->   map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
          ASSERT((iflags & BMV_IF_DELALLOC) != 0);

When map[i].br_startoff == XFS_B_TO_FSB(mp, XFS_ISIZE(ip)), the
startoff is just at EOF. But we only need to make sure delalloc
extents that are within EOF, not include EOF.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8795e9c..a6d83ea 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -713,7 +713,7 @@ xfs_getbmap(
 			 * extents.
 			 */
 			if (map[i].br_startblock == DELAYSTARTBLOCK &&
-			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			    map[i].br_startoff < XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
 				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
 
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
-- 
2.7.4

