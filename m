Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 49ACA7F58
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 23:44:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2611C304064
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 21:44:30 -0700 (PDT)
Received: from s87.loopia.se (s87.loopia.se [194.9.94.112]) by cuda.sgi.com
	with ESMTP id yjvCA7m70iwltkNd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 21:44:28 -0700 (PDT)
From: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 14/15] xfs: fix decimal printf format specifiers prefixed with
	0x
Date: Tue,  5 Aug 2014 21:44:16 -0700
Message-Id: <1407300256-495-1-git-send-email-hans@hanshq.net>
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
To: david@fromorbit.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 fs/xfs/xfs_discard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 13d08a1..b4a2415 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -228,7 +228,7 @@ xfs_discard_extents(
 				GFP_NOFS, 0);
 		if (error && error != -EOPNOTSUPP) {
 			xfs_info(mp,
-	 "discard failed for extent [0x%llu,%u], error %d",
+	 "discard failed for extent [0x%llx,%u], error %d",
 				 (unsigned long long)busyp->bno,
 				 busyp->length,
 				 error);
-- 
2.0.0.526.g5318336

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
