Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6S8S4IA246811 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:28:04 -0500
Received: from mort.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10DAE1D8E8E7
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:28:02 -0700 (PDT)
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id mDkowBKHZmaACUQK for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 01:28:02 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 4/4] xfstests: Add support for btrfs in 079
Date: Thu, 28 Jul 2011 10:28:01 +0200
Message-Id: <0cbb002def872039fd8c0bb90ceb5f6bf0e15b02.1311776403.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311776403.git.sbehrens@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
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

Added btrfs to the list of supported filesystems for test 079.
In src/t_immutable.c which is compiled for Linux only, add support for
btrfs by replacing the ioctl(EXT2_IOC_SETFLAGS) with
ioctl(FS_IOC_SETFLAGS) which is defined to be the same.
Afterwards in src/t_immutable.c in function fsetflag(), share the code
branch for the ext2 case also for the btrfs case.
Furthermore, added missing call to ioctl(FS_IOC_GETFLAGS) to the ext3
and btrfs code branch, this was a difference to the way the XFS code
branch was implemented.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 079               |    4 ++--
 src/t_immutable.c |   23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/079 b/079
index 6c43fe7..02f7607 100755
--- a/079
+++ b/079
@@ -46,7 +46,7 @@ _cleanup()
 . ./common.filter
 . ./common.attr
 
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os Linux
 
 _require_attrs
@@ -55,7 +55,7 @@ _require_scratch
 [ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
 
 # real QA test starts here
-_scratch_mkfs_xfs 2>&1 >/dev/null || _fail "mkfs failed"
+_scratch_mkfs 2>&1 >/dev/null || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 
 echo "*** starting up"
diff --git a/src/t_immutable.c b/src/t_immutable.c
index 7bb3154..9be0c2e 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -41,6 +41,8 @@
 #include <xfs/xfs.h>
 #include <xfs/handle.h>
 #include <xfs/jdm.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
 
 #define EXT2_SUPER_MAGIC	0xEF53
 #define EXT2_IMMUTABLE_FL       0x00000010
@@ -55,18 +57,18 @@ extern const char *__progname;
 
 static int fsetflag(const char *path, int fd, int on, int immutable)
 {
-     int e2flags = 0;
+     int fsflags = 0;
      struct fsxattr attr;
      struct statfs stfs;
      int xfsfl;
-     int e2fl;
+     int fsfl;
 
      if (immutable) {
 	  xfsfl = XFS_XFLAG_IMMUTABLE;
-	  e2fl = EXT2_IMMUTABLE_FL;
+	  fsfl = FS_IMMUTABLE_FL;
      } else {
 	  xfsfl = XFS_XFLAG_APPEND;
-	  e2fl = EXT2_APPEND_FL;
+	  fsfl = FS_APPEND_FL;
      }
 
      if (fstatfs(fd, &stfs) != 0)
@@ -85,12 +87,17 @@ static int fsetflag(const char *path, int fd, int on, int immutable)
 	       close(fd);
 	       return 1;
 	  }
-     } else if (stfs.f_type == EXT2_SUPER_MAGIC) {
+     } else if (stfs.f_type == EXT2_SUPER_MAGIC ||
+	        stfs.f_type == BTRFS_SUPER_MAGIC) {
+	  if (ioctl(fd, FS_IOC_GETFLAGS, &fsflags) < 0) {
+	       close(fd);
+	       return 1;
+	  }
 	  if (on)
-	       e2flags |= e2fl;
+	       fsflags |= fsfl;
 	  else
-	       e2flags &= ~e2fl;
-	  if (ioctl(fd, EXT2_IOC_SETFLAGS, &e2flags) < 0) {
+	       fsflags &= ~fsfl;
+	  if (ioctl(fd, FS_IOC_SETFLAGS, &fsflags) < 0) {
 	       close(fd);
 	       return 1;
 	  }
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
