Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n68G4bxa235609 for <xfs@oss.sgi.com>; Wed, 8 Jul 2009 11:04:37 -0500
Subject: [PATCH 34/44] includecheck fix: fs/xfs, xfs_iops.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Date: Wed, 08 Jul 2009 21:16:11 +0530
Message-Id: <1247067971.4382.94.camel@ht.satnam>
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
To: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>


fix the following 'make includecheck' warning:

  fs/xfs/linux-2.6/xfs_iops.c: xfs_acl.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 58973bb..793a146 100644
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
