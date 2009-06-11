Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BMG6qw174446 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 17:16:06 -0500
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] xfs: fix freeing memory in xfs_getbmap()
Date: Thu, 11 Jun 2009 17:16:25 -0500
Message-Id: <1244758585-18141-1-git-send-email-felixb@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Hedi Berriche <hedi@sgi.com>

Regression from commit 28e211700a81b0a934b6c7a4b8e7dda843634d2f.
Need to free temporary buffer allocated in xfs_getbmap().

Signed-off-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Hedi Berriche <hedi@sgi.com>
---
 fs/xfs/xfs_bmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4b0f6ef..7928b99 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6086,6 +6086,7 @@ xfs_getbmap(
 			break;
 	}
 
+	kmem_free(out);
 	return error;
 }
 
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
