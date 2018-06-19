Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38839 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936965AbeFSCli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 22:41:38 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fV6aI-0004vb-Fo
        for linux-xfs@vger.kernel.org; Tue, 19 Jun 2018 12:41:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fV6aI-0005wH-EY
        for linux-xfs@vger.kernel.org; Tue, 19 Jun 2018 12:41:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: transactionless xfs_bunmapi shouldn't do format conversion
Date: Tue, 19 Jun 2018 12:41:27 +1000
Message-Id: <20180619024128.22669-2-david@fromorbit.com>
In-Reply-To: <20180619024128.22669-1-david@fromorbit.com>
References: <20180619024128.22669-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If we are punching out a delalloc extent, xfs_bunmapi() does not
have a transaction context and should not ever need to convert the
on-disk extent format. If such a thing is attempted (e.g. via a
corrupt inode extent count in extent format) then we should abort
with an EFSCORRUPTED error. Unfortunately, we don't do that and
crash instead:

 XFS (loop0): page discard on page 0000000005fd24f3, inode 0x75e5, offset 0.
 ==================================================================
 BUG: KASAN: null-ptr-deref in xfs_alloc_get_freelist+0x115/0x350
 Read of size 8 at addr 0000000000000028 by task a.out/1406
 CPU: 0 PID: 1406 Comm: a.out Not tainted 4.17.0-rc4-kasan #2
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
 Call Trace:
  dump_stack+0x7b/0xb5
  kasan_report+0x10c/0x390
  __asan_load8+0x54/0x90
  xfs_alloc_get_freelist+0x115/0x350
  xfs_alloc_fix_freelist+0x35b/0x830
  xfs_alloc_vextent+0x215/0x990
  xfs_bmap_extents_to_btree+0x30d/0x940
.....

By returning an error here, we avoid such crashes when punching out
a delalloc page because we don't try to fix up an AG freelist
without a transaction. Hence we get an error like so:

XFS (loop0): page discard on page ffffea00040ae640, inode 0x75e5, offset 0.
XFS (loop0): page discard unable to remove delalloc mapping.

And the filesystem continues to operate and the stale mapping is
cleaned up when the inode is reclaimed.

Reported-by: Wen Xu <wen.xu@gatech.edu>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 01628f0c9a0c..6967ce8088d2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5458,10 +5458,18 @@ __xfs_bunmapi(
 		*rlen = end - start + 1;
 
 	/*
-	 * Convert to a btree if necessary.
+	 * Convert the BMBT root format if necessary. This should only occur in
+	 * transaction contexts and not when removing delalloc extents from
+	 * the in-core extent tree. If we don't have a transaction, then we've
+	 * got some form of corruption somewhere, so return an error
+	 * immediately.
 	 */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		ASSERT(cur == NULL);
+		if (!tp) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops,
 			&cur, 0, &tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
@@ -5473,6 +5481,10 @@ __xfs_bunmapi(
 	 */
 	else if (xfs_bmap_wants_extents(ip, whichfork)) {
 		ASSERT(cur != NULL);
+		if (!tp) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		error = xfs_bmap_btree_to_extents(tp, ip, cur, &tmp_logflags,
 			whichfork);
 		logflags |= tmp_logflags;
-- 
2.17.0

