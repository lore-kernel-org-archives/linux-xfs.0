Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAOJKuSS036452 for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 13:20:56 -0600
Received: from hades.usersys.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 368F81E9DC3D
	for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 11:20:54 -0800 (PST)
Received: from hades.usersys.redhat.com (186.215.132.159.static.gvt.net.br
	[186.215.132.159]) by cuda.sgi.com with ESMTP id
	TTYAITenB4NW2ZvD for <xfs@oss.sgi.com>;
	Thu, 24 Nov 2011 11:20:54 -0800 (PST)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] libxfs: Get Physical Sector Size instead of Logical Sector
	size
Date: Thu, 24 Nov 2011 17:20:51 -0200
Message-Id: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>

xfsprogs (mainly mkfs) is using the logical sector size of a volume to initialize
the filesystem, which, even in devices using Advanced Format, it can get a 512
bytes sector size if it is set as the logical sector size.
This patch changes the ioctl to get the physical sector size, independent of the
logical size.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/linux.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 2e07d54..0bc49dd 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -39,6 +39,9 @@ static int max_block_alignment;
 #ifndef BLKSSZGET
 # define BLKSSZGET	_IO(0x12,104)
 #endif
+#ifndef BLKPBSZGET
+# define BLKPBSZGET _IO(0x12,123)
+#endif
 
 #ifndef RAMDISK_MAJOR
 #define RAMDISK_MAJOR	1	/* ramdisk major number */
@@ -165,7 +168,7 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 		*sz = (long long)tmpsize;
 	}
 
-	if (ioctl(fd, BLKSSZGET, bsz) < 0) {
+	if (ioctl(fd, BLKPBSZGET, bsz) < 0) {
 		fprintf(stderr, _("%s: warning - cannot get sector size "
 				"from block device %s: %s\n"),
 			progname, path, strerror(errno));
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
