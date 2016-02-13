Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 192F07CA2
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 14:26:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1B88304059
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 12:26:28 -0800 (PST)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id 2Uug9ymIj0HF8iD4
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 12:26:25 -0800 (PST)
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] xfs:  fix format specifier , should be %llx and not %llu
Date: Sat, 13 Feb 2016 20:26:22 +0000
Message-Id: <1455395182-4771-1-git-send-email-colin.king@canonical.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

busyp->bno is printed with a %llu format specifier when the
intention is to print a hexadecimal value. Trivial fix to
use %llx instead.  Found with smatch static analysis:

fs/xfs/xfs_discard.c:229 xfs_discard_extents() warn: '0x'
  prefix is confusing together with '%llu' specifier

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/xfs_discard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e85a951..272c3f8 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -227,7 +227,7 @@ xfs_discard_extents(
 				GFP_NOFS, 0);
 		if (error && error != -EOPNOTSUPP) {
 			xfs_info(mp,
-	 "discard failed for extent [0x%llu,%u], error %d",
+	 "discard failed for extent [0x%llx,%u], error %d",
 				 (unsigned long long)busyp->bno,
 				 busyp->length,
 				 error);
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
