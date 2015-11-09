Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CC517F37
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 08:32:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF88BAC004
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 06:32:06 -0800 (PST)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	zYX1brBbA7SUVb1V (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 06:32:05 -0800 (PST)
Received: by obbza9 with SMTP id za9so141320197obb.1
	for <xfs@oss.sgi.com>; Mon, 09 Nov 2015 06:32:04 -0800 (PST)
From: Jia He <hejianet@gmail.com>
Subject: [PATCH] libxfs: Optimize the loop for xfs_bitmap_empty
Date: Mon,  9 Nov 2015 22:31:22 +0800
Message-Id: <1447079482-10650-1-git-send-email-hejianet@gmail.com>
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

If there is any non zero bit in a long bitmap, it can jump out of the for 
loop and finish the function as soon as possible.

Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com> 
Cc: Brian Foster <bfoster@redhat.com> 
---
 fs/xfs/libxfs/xfs_bit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
index 0e8885a..84614b0 100644
--- a/fs/xfs/libxfs/xfs_bit.c
+++ b/fs/xfs/libxfs/xfs_bit.c
@@ -36,6 +36,8 @@ xfs_bitmap_empty(uint *map, uint size)
 
 	for (i = 0; i < size; i++) {
 		ret |= map[i];
+		if (ret != 0)
+			return 0;
 	}
 
 	return (ret == 0);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
