Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755433AbeEHRWc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 13:22:32 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CDDD730CB6F4
        for <linux-xfs@vger.kernel.org>; Tue,  8 May 2018 17:22:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B19BB30B36E3
        for <linux-xfs@vger.kernel.org>; Tue,  8 May 2018 17:22:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/3] xfs: don't discard on free of unwritten extents
Date: Tue,  8 May 2018 13:22:31 -0400
Message-Id: <20180508172231.53570-4-bfoster@redhat.com>
In-Reply-To: <20180508172231.53570-1-bfoster@redhat.com>
References: <20180508172231.53570-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Unwritten extents by definition have not been written to until they
are converted to normal written extents. If unwritten extents are
freed from a file, it is therefore guaranteed that the blocks have
not been written to since allocation (note that zero range punches
and reallocates blocks).

To cut down on online discards generated from workloads that make
use of preallocation, skip discards of extents if they are in the
unwritten state when the extent is freed.

Note that this optimization does not apply to log recovery, during
which all freed extents are discarded if online discard is enabled.
Also note that it may be possible for a filesystem crash to occur
after write completion of an unwritten extent but before unwritten
conversion such that the extent remains unwritten after log
recovery. Since this pseudo-inconsistency may already be possible
after a crash (consider writing to recently allocated blocks where
the allocation transaction is lost after a crash), this change
shouldn't introduce any fundamental limitations that don't already
exist. In short, on storage stacks where discards are important,
it's good practice to run an occasional fstrim even with online
discard enabled in the filesystem, particularly after a crash.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dfec27b10e7a..24f60ee810e4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5107,7 +5107,8 @@ xfs_bmap_del_extent_real(
 			if (error)
 				goto done;
 		} else {
-			if (bflags & XFS_BMAPI_NODISCARD) {
+			if ((bflags & XFS_BMAPI_NODISCARD) ||
+			    (del->br_state == XFS_EXT_UNWRITTEN)) {
 				xfs_bmap_add_free_nodiscard(mp, dfops,
 					del->br_startblock, del->br_blockcount,
 					NULL);
-- 
2.14.3

