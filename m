Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2L5S6x4054503 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 00:28:06 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 3J4TpPBFb2481nH4 for
	<xfs@oss.sgi.com>; Tue, 20 Mar 2012 22:28:04 -0700 (PDT)
From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH RESEND] Xfstest: make 218 support btrfs
Date: Wed, 21 Mar 2012 13:26:05 +0800
Message-Id: <1332307565-26036-1-git-send-email-liubo2009@cn.fujitsu.com>
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
Cc: hch@infradead.org, linux-btrfs@vger.kernel.org

Btrfs progs has a defragment tool, so we can test 218 on btrfs now.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 218           |    2 +-
 common.defrag |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/218 b/218
index 53d0b61..77782c6 100755
--- a/218
+++ b/218
@@ -44,7 +44,7 @@ _cleanup()
 . ./common.defrag
 
 # real QA test starts here
-_supported_fs xfs ext4
+_supported_fs xfs ext4 btrfs
 _supported_os Linux
 
 _setup_testdir
diff --git a/common.defrag b/common.defrag
index 4850803..ea6c14c 100644
--- a/common.defrag
+++ b/common.defrag
@@ -29,6 +29,9 @@ _require_defrag()
     ext4|ext4dev)
         DEFRAG_PROG=/usr/bin/e4defrag
 	;;
+    btrfs)
+	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
+	;;
     *)
         _notrun "defragmentation not supported for fstype \"$FSTYP\""
 	;;
-- 
1.6.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
