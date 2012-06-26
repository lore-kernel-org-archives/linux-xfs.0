Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QEZnt2111595 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 09:35:49 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id vxNBpqaQTfHobhfU
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jun 2012 07:35:48 -0700 (PDT)
Received: by dadg9 with SMTP id g9so8640906dad.26
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 07:35:47 -0700 (PDT)
From: Chen Baozi <baozich@gmail.com>
Subject: [PATCH] xfs: Fix comment typo of xfs_open_devices()
Date: Tue, 26 Jun 2012 22:35:05 +0800
Message-Id: <1340721305-3602-1-git-send-email-baozich@gmail.com>
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
To: bpm@sgi.com
Cc: Chen Baozi <baozich@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Since "get_sb_bdev()" has been changed to "mount_bdev()", fix
the comment accordingly.

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 fs/xfs/xfs_super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0d9de41..3cf4a5c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -649,7 +649,7 @@ xfs_close_devices(
  *
  * We only have to handle opening the log and realtime volumes here if
  * they are present.  The data subvolume has already been opened by
- * get_sb_bdev() and is stored in sb->s_bdev.
+ * mount_bdev() and is stored in sb->s_bdev.
  */
 STATIC int
 xfs_open_devices(
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
