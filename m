Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71AVNIX262008 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 05:31:23 -0500
Received: from ysabell.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66B551EAD0E1
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 03:31:21 -0700 (PDT)
Received: from ysabell.rzone.de (ysabell.rzone.de [81.169.144.237]) by
	cuda.sgi.com with ESMTP id CBwpPzNwH72nwG2L for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2011 03:31:21 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v3 2/2] xfstests: make t_immutable and 079 filesystem-agnostic
Date: Mon,  1 Aug 2011 12:31:20 +0200
Message-Id: <02e31e7d245bc027ff32962e04cc94f3c9c09cef.1312193821.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1312193821.git.sbehrens@giantdisaster.de>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1312193821.git.sbehrens@giantdisaster.de>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
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
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Changed the test 079 to be generic for all filesystems and to be
executed for all filesystems.
In src/t_immutable.c which is compiled for Linux only, replaced the
old style XFS and ext2 specific code for setting the append-only and
immutable flags by generic code that makes use of the
ioctl(FS_IOC_SETFLAGS) and ioctl(FS_IOC_GETFLAGS).
Therefore the check for the specific filesystem type was removed.
FS_IOC_GETFLAGS/FS_IOC_SETFLAGS is always used. This code is inside an
'#ifdef FS_IOC_SETFLAGS' block in order to never fail compilation.
Without support for FS_IOC_SETFLAGS, the test completes with _notrun.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 079               |   12 +++++++--
 src/t_immutable.c |   66 +++++++++++++++++-----------------------------------
 2 files changed, 31 insertions(+), 47 deletions(-)

diff --git a/079 b/079
index 6c43fe7..8f6e179 100755
--- a/079
+++ b/079
@@ -46,7 +46,7 @@ _cleanup()
 . ./common.filter
 . ./common.attr
 
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _require_attrs
@@ -55,10 +55,16 @@ _require_scratch
 [ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
 
 # real QA test starts here
-_scratch_mkfs_xfs 2>&1 >/dev/null || _fail "mkfs failed"
+_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 
 echo "*** starting up"
-$timmutable -c $SCRATCH_MNT/$seq
+$timmutable -c $SCRATCH_MNT/$seq >$tmp.out 2>&1
+if grep -q 'Operation not supported' $tmp.out; then
+    rm -f $tmp.out
+    _notrun "Setting immutable/append flag not supported"
+fi
+cat $tmp.out
+rm -f $tmp.out
 status=$?
 exit
diff --git a/src/t_immutable.c b/src/t_immutable.c
index 7bb3154..87ffc75 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -41,11 +41,8 @@
 #include <xfs/xfs.h>
 #include <xfs/handle.h>
 #include <xfs/jdm.h>
-
-#define EXT2_SUPER_MAGIC	0xEF53
-#define EXT2_IMMUTABLE_FL       0x00000010
-#define EXT2_APPEND_FL          0x00000020
-#define EXT2_IOC_SETFLAGS	_IOW('f', 2, long)
+#include <linux/fs.h>
+#include <linux/magic.h>
 
 #ifndef XFS_SUPER_MAGIC
 #define XFS_SUPER_MAGIC 0x58465342
@@ -55,52 +52,33 @@ extern const char *__progname;
 
 static int fsetflag(const char *path, int fd, int on, int immutable)
 {
-     int e2flags = 0;
-     struct fsxattr attr;
-     struct statfs stfs;
-     int xfsfl;
-     int e2fl;
-
-     if (immutable) {
-	  xfsfl = XFS_XFLAG_IMMUTABLE;
-	  e2fl = EXT2_IMMUTABLE_FL;
-     } else {
-	  xfsfl = XFS_XFLAG_APPEND;
-	  e2fl = EXT2_APPEND_FL;
-     }
+#ifdef FS_IOC_SETFLAGS
+     int fsflags = 0;
+     int fsfl;
 
-     if (fstatfs(fd, &stfs) != 0)
+     if (ioctl(fd, FS_IOC_GETFLAGS, &fsflags) < 0) {
+	  close(fd);
 	  return 1;
-
-     if (stfs.f_type == XFS_SUPER_MAGIC) {
-	  if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &attr) < 0) {
-	       close(fd);
-	       return 1;
-	  }
-	  if (on)
-	       attr.fsx_xflags |= xfsfl;
-	  else
-	       attr.fsx_xflags &= ~xfsfl;
-	  if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &attr) < 0) {
-	       close(fd);
-	       return 1;
-	  }
-     } else if (stfs.f_type == EXT2_SUPER_MAGIC) {
-	  if (on)
-	       e2flags |= e2fl;
-	  else
-	       e2flags &= ~e2fl;
-	  if (ioctl(fd, EXT2_IOC_SETFLAGS, &e2flags) < 0) {
-	       close(fd);
-	       return 1;
-	  }
-     } else {
-	  errno = EOPNOTSUPP;
+     }
+     if (immutable)
+	  fsfl = FS_IMMUTABLE_FL;
+     else
+	  fsfl = FS_APPEND_FL;
+     if (on)
+	  fsflags |= fsfl;
+     else
+	  fsflags &= ~fsfl;
+     if (ioctl(fd, FS_IOC_SETFLAGS, &fsflags) < 0) {
 	  close(fd);
 	  return 1;
      }
      close(fd);
      return 0;
+#else
+     errno = EOPNOTSUPP;
+     close(fd);
+     return 1;
+#endif
 }
 
 static int add_acl(const char *path, const char *acl_text)
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
