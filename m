Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D57137F62
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 03:11:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B56F7304048
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 01:11:09 -0800 (PST)
Received: from mail-pa0-f45.google.com (mail-pa0-f45.google.com
	[209.85.220.45]) by cuda.sgi.com with ESMTP id GWiz9kbf9aFAbrLW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 01:11:08 -0800 (PST)
Received: by mail-pa0-f45.google.com with SMTP id kl14so1703913pab.18
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 01:11:08 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests: use right path in _require_defrag()
Date: Fri,  1 Mar 2013 17:25:59 +0800
Message-Id: <1362129959-4504-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Zheng Liu <wenqing.lz@taobao.com>

In _require_defrag defragmentation command path is fixed.  That will
cause that this test case is skipped in some distributions.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 common.defrag | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/common.defrag b/common.defrag
index ea6c14c..7be8ad9 100644
--- a/common.defrag
+++ b/common.defrag
@@ -24,10 +24,10 @@ _require_defrag()
 {
     case "$FSTYP" in
     xfs)
-        DEFRAG_PROG=/usr/sbin/xfs_fsr
+        DEFRAG_PROG=`which xfs_fsr`
 	;;
     ext4|ext4dev)
-        DEFRAG_PROG=/usr/bin/e4defrag
+        DEFRAG_PROG=`which e4defrag`
 	;;
     btrfs)
 	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
@@ -38,7 +38,7 @@ _require_defrag()
     esac
 
     _require_command $DEFRAG_PROG
-    _require_command /usr/sbin/filefrag
+    _require_command `which filefrag`
 }
 
 _extent_count()
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
