Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2PHLjlX147725 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 12:21:45 -0500
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 11/16] XFS xfs_trace.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:41 +0100
Message-Id: <1269537767-7553-11-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
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
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, Andrea Gelmini <andrea.gelmini@gelma.net>, Christoph Hellwig <hch@lst.de>

fs/xfs/linux-2.6/xfs_trace.c: xfs_attr_sf.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/xfs/linux-2.6/xfs_trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
index 5a10760..cb840e0 100644
--- a/fs/xfs/linux-2.6/xfs_trace.c
+++ b/fs/xfs/linux-2.6/xfs_trace.c
@@ -41,7 +41,6 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
-#include "xfs_attr_sf.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
-- 
1.7.0.3.296.g9776a

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
