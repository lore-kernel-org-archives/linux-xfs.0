Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57464 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932485AbcI3U52 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:57:28 -0400
Subject: [PATCH 5/5] xfs_io: fix inode command with "-n" for bogus inode
References: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <26464bd7-f56c-733f-108d-13dca26ceb7c@sandeen.net>
Date: Fri, 30 Sep 2016 15:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

If we ask for the next allocated inode after a number for which
no other inode exists, the bulkstat returns success, but with
count == 0.  If we ignore this fact, we print a garbage result
from bstat.bs_ino in this case, so fix it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/open.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/io/open.c b/io/open.c
index 7d952a0..4279062 100644
--- a/io/open.c
+++ b/io/open.c
@@ -882,10 +882,16 @@ inode_f(
 				exitcode = 1;
 				return 0;
 			}
-		} else if (ret_next)	/* The next inode in use */
-			result_ino = bstat.bs_ino;
-		else			/* The inode we asked about */
+		} else if (ret_next) {
+			/* The next inode in use, or 0 if none */
+			if (*bulkreq.ocount)
+				result_ino = bstat.bs_ino;
+			else
+				result_ino = 0;
+		} else {
+			/* The inode we asked about */
 			result_ino = userino;
+		}
 	}
 
 	if (verbose && result_ino) {
-- 
1.7.1

