Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE9537F82
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:15:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 118AA8F806F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pAvQqnVY9Dvg5Xf5 for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:48 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Date: Tue, 25 Feb 2014 20:15:27 +0100
Message-Id: <1393355728-12056-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Define fallocate flags such as FALLOC_FL_PUNCH_HOLE and
FALLOC_FL_ZERO_RANGE locally if they do not exist.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index b3c30db..331257e 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -35,8 +35,13 @@
 #endif
 #ifdef FALLOCATE
 #include <linux/falloc.h>
+#ifndef FALLOC_FL_PUNCH_HOLE
+#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
+#endif
+#ifndef FALLOC_FL_ZERO_RANGE
+#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
+#endif
 #endif
-
 #ifndef MAP_FILE
 # define MAP_FILE 0
 #endif
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
