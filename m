Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66AD57FB2
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 08:02:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 551E88F8033
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 06:02:19 -0800 (PST)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
	[209.85.220.42]) by cuda.sgi.com with ESMTP id NEVmiWX9W1r6v8Rp
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 06:02:15 -0800 (PST)
Received: by mail-pa0-f42.google.com with SMTP id kq12so1830402pab.29
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 06:02:14 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] xfstests: use right defrag program path
Date: Fri,  1 Mar 2013 22:17:13 +0800
Message-Id: <1362147433-5788-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In _require_defrag defragmentation command path is fixed.  That will
cause that this test case is skipped in some distributions.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Dave Chinner <david@fromorbit.com>
---
[*NOTE*: this patch is Cc'ed to linux-ext4 mailing list because after
applied it xfstests #218 will fail against 3.8 and dev branch.]

v2 <- v1:
 * Define 'E4DEFRAG_PROG' and 'FILEFRAG_PROG' in common.config with
   set_prog_path

 common.config |  2 ++
 common.defrag | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/common.config b/common.config
index 7174127..9c99bfe 100644
--- a/common.config
+++ b/common.config
@@ -160,6 +160,8 @@ export INDENT_PROG="`set_prog_path indent`"
 export XFS_COPY_PROG="`set_prog_path xfs_copy`"
 export FSTRIM_PROG="`set_prog_path fstrim`"
 export DUMPE2FS_PROG="`set_prog_path dumpe2fs`"
+export FILEFRAG_PROG="`set_prog_path filefrag`"
+export E4DEFRAG_PROG="`set_prog_path e4defrag`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.defrag b/common.defrag
index ea6c14c..9c9eb9b 100644
--- a/common.defrag
+++ b/common.defrag
@@ -24,10 +24,10 @@ _require_defrag()
 {
     case "$FSTYP" in
     xfs)
-        DEFRAG_PROG=/usr/sbin/xfs_fsr
+        DEFRAG_PROG="$XFS_FSR_PROG"
 	;;
     ext4|ext4dev)
-        DEFRAG_PROG=/usr/bin/e4defrag
+        DEFRAG_PROG="$E4DEFRAG_PROG"
 	;;
     btrfs)
 	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
@@ -38,13 +38,13 @@ _require_defrag()
     esac
 
     _require_command $DEFRAG_PROG
-    _require_command /usr/sbin/filefrag
+    _require_command $FILEFRAG_PROG
 }
 
 _extent_count()
 {
-	filefrag $1 | awk '{print $2}'
-	filefrag -v $1  >> $seq.full 2>&1
+	$FILEFRAG_PROG $1 | awk '{print $2}'
+	$FILEFRAG_PROG -v $1  >> $seq.full 2>&1
 }
 
 # Defrag file, check it, and remove it.
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
