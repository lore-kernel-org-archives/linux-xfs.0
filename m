Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LNon2L049929 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:50:49 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66B518C50C
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:50:49 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id t7YKQzrPEdpumPbm for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:50:49 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH XFSPROGS 3/3] mkfs: Link against libuuid after liblkid
Date: Thu, 21 Jul 2011 19:50:37 -0400
Message-Id: <1311292237-4155-3-git-send-email-tytso@mit.edu>
In-Reply-To: <1311292237-4155-1-git-send-email-tytso@mit.edu>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
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
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>

The order in which libraries are searched matters if you are using
static libraries.  Since libblkid uses some functions from libuuid, it
needs to come before libuuid in the link line.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 mkfs/Makefile |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 8b61c2f..75da633 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,10 +11,6 @@ FSTYP = fstyp
 HFILES = xfs_mkfs.h
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXFS)
-LLDFLAGS = -static
-
 ifeq ($(ENABLE_BLKID),yes)
 LLDLIBS += $(LIBBLKID)
 CFLAGS += -DENABLE_BLKID
@@ -23,6 +19,9 @@ LLDLIBS += $(LIBDISK)
 LTDEPENDENCIES += $(LIBDISK)
 endif
 
+LLDLIBS += $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LTDEPENDENCIES += $(LIBXFS)
+LLDFLAGS = -static
 
 LSRCFILES = $(FSTYP).c
 LDIRT = $(FSTYP)
-- 
1.7.4.1.22.gec8e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
