Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AGcANa087940 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 10:38:10 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id nxdm08F7OlsfSyNp
	for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 08:38:08 -0800 (PST)
Received: by yhpp34 with SMTP id p34so1610580yhp.26
	for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 08:38:08 -0800 (PST)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfstests 271: use xfs_io to truncate file instead of
	truncate(1)
Date: Wed, 11 Jan 2012 00:37:48 +0800
Message-Id: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
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
To: xfs@oss.sgi.com
Cc: Eryu Guan <guaneryu@gmail.com>

Distros(eg. RHEL5) with older version of coreutils have no truncate(1)
command. Use xfs_io instead to avoid "command not found" failures.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 271 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/271 b/271
index 58a7f91..b96d702 100755
--- a/271
+++ b/271
@@ -55,7 +55,7 @@ do
     dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k count=1 seek=$((i*10))
 done
 # truncate last extent
-truncate $SCRATCH_MNT/file --size $((4096* 200))
+$XFS_IO_PROG -F -f -c "truncate $((4096*200))" $SCRATCH_MNT/file
 
 if ! _scratch_unmount; then
 	echo "failed to umount"
-- 
1.7.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
