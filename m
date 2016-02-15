Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C7EF7CA3
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:18:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2A36304043
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:18:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UoGKKys2rTwkoF6k for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:53 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000M9-GF
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005G8-FR
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/14] libxfs: Optimize the loop for xfs_bitmap_empty
Date: Mon, 15 Feb 2016 17:18:12 +1100
Message-Id: <1455517105-20033-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Jia He <hejianet@gmail.com>

Source kernel commit 1d4292bfdc77f4f7c520064be15d0c46bd025fd2

If there is any non zero bit in a long bitmap, it can jump out of the
loop and finish the function as soon as possible.

Signed-off-by: Jia He <hejianet@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_bit.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_bit.c b/libxfs/xfs_bit.c
index 8b5b81c..041557a 100644
--- a/libxfs/xfs_bit.c
+++ b/libxfs/xfs_bit.c
@@ -32,13 +32,13 @@ int
 xfs_bitmap_empty(uint *map, uint size)
 {
 	uint i;
-	uint ret = 0;
 
 	for (i = 0; i < size; i++) {
-		ret |= map[i];
+		if (map[i] != 0)
+			return 0;
 	}
 
-	return (ret == 0);
+	return 1;
 }
 
 /*
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
