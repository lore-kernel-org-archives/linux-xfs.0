Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 430707CAE
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:43:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC0078F8035
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QqI09FiwZ2lBjidi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:55 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 08/10] xfs: handle bdev reservation ENOSPC correctly
	from XFS reserved pool
Date: Tue, 12 Apr 2016 12:42:51 -0400
Message-Id: <1460479373-63317-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

The XFS reserved block pool holds blocks from general allocation for
internal purposes. When enabled, these blocks shall also carry a
reservation from the block device to guarantee they are usable.

The reserved pool allocation code currently uses a retry algorithm based
on the available space estimation. It assumes that an inability to
allocate blocks based on the estimation is a transient problem. Now that
block allocation attempts bdev reservation, however, an ENOSPC could
originate from the block device and might not be transient.

Because the retry algorithm cannot distinguish between fs block
allocation and bdev reservation, separate the two operations in this
particular case. If the bdev reservation fails, back off the reservation
delta until something can be reserved or return ENOSPC to the caller.
Once a bdev reservation is made, attempt to allocate blocks from the fs
and return to the original retry algorithm based on the free space
estimation. This prevents infinite retries in the event of a reserved
pool allocation request that cannot be satisfied from a bdev that
supports reservation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fsops.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 87d4b1b..79ae408 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -40,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_filestream.h"
+#include "xfs_thin.h"
 
 /*
  * File system operations
@@ -676,6 +677,7 @@ xfs_reserve_blocks(
 	__uint64_t		request;
 	__int64_t		free;
 	int			error = 0;
+	sector_t		res = 0;
 
 	/* If inval is null, report current values and return */
 	if (inval == (__uint64_t *)NULL) {
@@ -743,6 +745,28 @@ xfs_reserve_blocks(
 			fdblks_delta = delta;
 
 		/*
+		 * Reserve pool blocks must carry a block device reservation (if
+		 * enabled). The block device could be much closer to ENOSPC
+		 * than the fs (i.e., a thin or snap device), so try to reserve
+		 * the bdev space first.
+		 */
+		spin_unlock(&mp->m_sb_lock);
+		if (mp->m_thin_reserve) {
+			while (fdblks_delta) {
+				res = xfs_fsb_res(mp, fdblks_delta, false);
+				error = xfs_thin_reserve(mp, res);
+				if (error != -ENOSPC)
+					break;
+
+				fdblks_delta >>= 1;
+			}
+			if (!fdblks_delta || error) {
+				spin_lock(&mp->m_sb_lock);
+				break;
+			}
+		}
+
+		/*
 		 * We'll either succeed in getting space from the free block
 		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
 		 * things changed while we were calculating fdblks_delta and so
@@ -752,8 +776,9 @@ xfs_reserve_blocks(
 		 * Don't set the reserved flag here - we don't want to reserve
 		 * the extra reserve blocks from the reserve.....
 		 */
-		spin_unlock(&mp->m_sb_lock);
-		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
+		error = __xfs_mod_fdblocks(mp, -fdblks_delta, 0);
+		if (error && mp->m_thin_reserve)
+			xfs_thin_unreserve(mp, res);
 		spin_lock(&mp->m_sb_lock);
 	}
 
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
