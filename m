Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1000F7CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:42:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5CDB8F8033
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 12:42:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cMqkK85g5Sz2akgM for
	<xfs@oss.sgi.com>; Tue, 26 Feb 2013 12:42:42 -0800 (PST)
Message-ID: <512D1E3E.9050907@redhat.com>
Date: Tue, 26 Feb 2013 14:42:38 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: handle new mkfs.btrfs -f option cleanly
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, Stefan Behrens <sbehrens@giantdisaster.de>

I added an "-f" option to mkfs.btrfs to force overwrite
of an existing filesystem.  Now on an xfstests run, new
mkfs.btrfs requires it, and old mkfs.btrfs cannot accept
it.

So, add a helper which works out whether -f is needed,
and add it to the MKFS_BTRFS_PROG env. var as necessary,
so that it is an always-included option during the tests.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.config b/common.config
index 57f505d..9f1d309 100644
--- a/common.config
+++ b/common.config
@@ -101,6 +101,17 @@ set_prog_path()
     return 1
 }
 
+# Handle mkfs.btrfs which does (or does not) require -f to overwrite
+set_btrfs_mkfs_prog_path_with_opts()
+{
+	p=`set_prog_path mkfs.btrfs`
+	if grep -q 'force overwrite' $p; then
+		echo "$p -f"
+	else
+		echo $p
+	fi
+}
+
 _fatal()
 {
     echo "$*"
@@ -185,7 +196,7 @@ case "$HOSTOS" in
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
-        export MKFS_BTRFS_PROG="`set_prog_path mkfs.btrfs`"
+        export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
