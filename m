Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F3EC29DFB
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 19:32:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E77D8F8039
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 17:32:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BgEAd9YXZ26FvXOO for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 17:32:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGI3p-00088n-9Y
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 10:32:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGI3p-0004qF-8k
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 10:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: set remote symlink buffer type for recovery
Date: Mon,  2 Sep 2013 10:32:00 +1000
Message-Id: <1378081921-18570-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378081921-18570-1-git-send-email-david@fromorbit.com>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The logging of a remote symlink block does not set the buffer type
being logged, and hence on recovery the type of buffer is not
recognised and hence CRCs are not calculated after replay. This
results in log recoery throwing:

XFS (vdc): Unknown buffer type 0

errors, and subsequent reads of the symlink failing CRC
verification. Found via fsstress + godown.

Reported by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2f2a7c0..f622a97 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -41,6 +41,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
+#include "xfs_buf_item.h"
 
 /* ----- Kernel only functions below ----- */
 STATIC int
@@ -363,6 +364,7 @@ xfs_symlink(
 			pathlen -= byte_cnt;
 			offset += byte_cnt;
 
+			xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
 			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
 							(char *)bp->b_addr);
 		}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
