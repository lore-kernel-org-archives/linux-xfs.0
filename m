Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D63697F4E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 01:49:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76871AC007
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 23:49:14 -0800 (PST)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	wfNn9m5up1SWRMHL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 23:49:13 -0800 (PST)
Received: by obbnk6 with SMTP id nk6so16723901obb.2
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 23:49:12 -0800 (PST)
From: Jia He <hejianet@gmail.com>
Subject: [PATCH v2] libxfs: Optimize the loop for xfs_bitmap_empty
Date: Wed, 11 Nov 2015 15:49:01 +0800
Message-Id: <1447228141-17408-1-git-send-email-hejianet@gmail.com>
In-Reply-To: <20151110125403.GC21670@bfoster.bfoster>
References: <20151110125403.GC21670@bfoster.bfoster>
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
Cc: Jia He <hejianet@gmail.com>, Brian Foster <bfoster@redhat.com>

If there is any non zero bit in a long bitmap, it can jump out of the
loop and finish the function as soon as possible.

Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com> 
Cc: Brian Foster <bfoster@redhat.com> 
---
 fs/xfs/libxfs/xfs_bit.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
index 0e8885a..0a94cce 100644
--- a/fs/xfs/libxfs/xfs_bit.c
+++ b/fs/xfs/libxfs/xfs_bit.c
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
