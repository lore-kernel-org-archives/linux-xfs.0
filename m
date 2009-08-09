Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n79Er39B000584 for <xfs@oss.sgi.com>; Sun, 9 Aug 2009 09:53:05 -0500
Subject: [PATCH] XFS: includecheck fix for fs/xfs/xfs_iops.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Sun, 09 Aug 2009 20:23:12 +0530
Message-Id: <1249829592.2957.22.camel@ht.satnam>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com


fix the following 'make includecheck' warning:

  fs/xfs/linux-2.6/xfs_iops.c: xfs_acl.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 8070b34..626b474 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -43,7 +43,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
-- 
1.6.0.6


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
