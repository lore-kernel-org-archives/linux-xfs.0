Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA42gKdh064945 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 21:42:20 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A9F4101469E
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 19:42:18 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id QrWj2WDKJ0PIRTg4
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 19:42:18 -0700 (PDT)
Received: by vws19 with SMTP id 19so560615vws.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 19:42:17 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 2/2] xfstests: meet btrfs fs size requirement in
	_scratch_mkfs_sized()
Date: Fri,  4 Nov 2011 10:38:04 +0800
Message-Id: <1320374284-1534-2-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
References: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
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

btrfs requires at least 256M file system size, so check 'fssize' in
_scratch_mkfs_sized first and give it a proper value. Otherwise
mkfs.btrfs will complain something like

"File system size 267386880 bytes is too small, 256M is required at least"

This makes 015 077 and 083 run on btrfs.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 common.rc |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index e948169..ab61786 100644
--- a/common.rc
+++ b/common.rc
@@ -356,6 +356,11 @@ _scratch_mkfs_sized()
 	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
     btrfs)
+    # btrfs needs at least 256M file system size
+	if [ $fssize -lt $((256*1024*1024)) ]
+	then
+		fssize=$((256*1024*1024))
+	fi
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
 	;;
     *)
-- 
1.7.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
