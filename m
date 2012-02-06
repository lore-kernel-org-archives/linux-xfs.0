Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q168Slel114167 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 02:28:48 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id grhz2JJmLL8EFhjf for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 00:28:46 -0800 (PST)
From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/3][RESEND] xfstests: make 218 support btrfs
Date: Mon, 6 Feb 2012 16:27:48 +0800
Message-Id: <1328516869-19474-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
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
To: linux-btrfs@vger.kernel.org
Cc: hch@infradead.org, xfs@oss.sgi.com

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
