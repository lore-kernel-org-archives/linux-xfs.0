Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750859AbcKFSX1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Nov 2016 13:23:27 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] fstests: make xfs_io mandatory
Date: Mon,  7 Nov 2016 02:23:21 +0800
Message-Id: <1478456601-7085-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

_test_inode_flag() and _test_inode_extsz() use "which $XFS_IO_PROG"
to check if xfs_io command is available. And "-i" option was added
to XFS_IO_PROG varibable by commit 54659ecdb575 ("fstests: run
xfs_io with -i option if supported"). So the command becomes "which
/usr/sbin/xfs_io -i", and it stops and waits for input from stdin,
because "-i" option of "which" means "Read aliases from stdin".

I've seen xfs/008 hang when testing with latest xfsprogs, where
xfs_io has "-i" support.

Fix it by removing the xfs_io command detections, and making xfs_io
mandatory in common/config.

Also fix the indentions in these functions, use tab instead of
spaces, while we're at it.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/config |  4 +++-
 common/rc     | 24 ++++++++++--------------
 tests/xfs/094 |  1 -
 tests/xfs/103 |  1 -
 4 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/common/config b/common/config
index 168f46c..0b6cf01 100644
--- a/common/config
+++ b/common/config
@@ -158,11 +158,13 @@ export DF_PROG="`set_prog_path df`"
 [ "$DF_PROG" = "" ] && _fatal "df not found"
 [ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T -P"
 
+export XFS_IO_PROG="`set_prog_path xfs_io`"
+[ "$XFS_IO_PROG" = "" ] && _fatal "xfs_io not found"
+
 export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
 export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
-export XFS_IO_PROG="`set_prog_path xfs_io`"
 export XFS_SCRUB_PROG="`set_prog_path xfs_scrub`"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
diff --git a/common/rc b/common/rc
index a84efe4..088ede6 100644
--- a/common/rc
+++ b/common/rc
@@ -2896,30 +2896,26 @@ _populate_fs()
 #
 _test_inode_flag()
 {
-    flag=$1
-    file=$2
+	flag=$1
+	file=$2
 
-    if which $XFS_IO_PROG >/dev/null; then
-        if $XFS_IO_PROG -r -c 'lsattr -v' "$file" | grep -q "$flag" ; then
-	    return 0
-        fi
-    fi
-    return 1
+	if $XFS_IO_PROG -r -c 'lsattr -v' "$file" | grep -q "$flag" ; then
+		return 0
+	fi
+	return 1
 }
 
 # query the given files extsize allocator hint in bytes (if any)
 #
 _test_inode_extsz()
 {
-    file=$1
-    blocks=""
+	file=$1
+	blocks=""
 
-    if which $XFS_IO_PROG >/dev/null; then
 	blocks=`$XFS_IO_PROG -r -c 'stat' "$file" | \
 		awk '/^xattr.extsize =/ { print $3 }'`
-    fi
-    [ -z "$blocks" ] && blocks="0"
-    echo $blocks
+	[ -z "$blocks" ] && blocks="0"
+	echo $blocks
 }
 
 # scratch_dev_pool should contain the disks pool for the btrfs raid
diff --git a/tests/xfs/094 b/tests/xfs/094
index cee42d6..bf9eb2f 100755
--- a/tests/xfs/094
+++ b/tests/xfs/094
@@ -46,7 +46,6 @@ _supported_fs xfs
 _supported_os IRIX Linux
 _require_realtime
 _require_scratch
-_require_command "$XFS_IO_PROG" xfs_io
 
 _filter_realtime_flag()
 {
diff --git a/tests/xfs/103 b/tests/xfs/103
index cbe884f..48b8c59 100755
--- a/tests/xfs/103
+++ b/tests/xfs/103
@@ -66,7 +66,6 @@ _filter_noymlinks_flag()
 # real QA test starts here
 _supported_os Linux IRIX
 _supported_fs xfs
-_require_command "$XFS_IO_PROG" xfs_io
 _require_scratch
 
 _create_scratch
-- 
2.7.4

