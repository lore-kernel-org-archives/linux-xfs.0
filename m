Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85F4E7F47
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2014 16:57:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72E26304039
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2014 14:57:50 -0800 (PST)
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1]) by
	cuda.sgi.com with ESMTP id y1C7PQ8zJempeFt4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2014 14:57:46 -0800 (PST)
From: Romain Naour <romain.naour@openwide.fr>
Subject: [PATCH] xfsprogs: do not do any dynamic linking of libtool libraries
Date: Mon, 29 Dec 2014 23:57:42 +0100
Message-Id: <1419893862-32431-1-git-send-email-romain.naour@openwide.fr>
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
Cc: Romain Naour <romain.naour@openwide.fr>

if --disable-static and --enable-shared are given on the command
line, the link with xfsprogs's internal libraries fail because
they have been dynamically compiled.

Hence the following error:
ld: attempted static link of dynamic object `../libxcmd/.libs/libxcmd.so'

xfsprogs rely on the original behaviour of -static which was modified in
Buildroot by [1].
But since commit [2] the build of xfsprogs tools is broken because they try
to link statically with the static libuuid library (util-linux), which is not
build for shared only build.

The use of -static-libtool-libs allows to fallback to the dynamic linking for
libuuid only:

LD_TRACE_LOADED_OBJECTS=1 xfs_copy
	linux-gate.so.1 =>  (0xf7793000)
	libuuid.so.1 => /lib/libuuid.so.1 (0x465e1000)
	libpthread.so.0 => /lib/libpthread.so.0 (0x46db1000)
	librt.so.1 => /lib/librt.so.1 (0x46f21000)
	libc.so.6 => /lib/libc.so.6 (0x46bf1000)
	/lib/ld-linux.so.2 (0x46bce000)

[1] http://git.buildroot.net/buildroot/commit/?id=97703978ac870ce2b14ad144f8e082de82aa2c64
[2] http://git.buildroot.net/buildroot/commit/?id=f1d3e09895b245da9d54bbaef36e5de95269034e

Signed-off-by: Romain Naour <romain.naour@openwide.fr>
---
 copy/Makefile     | 2 +-
 db/Makefile       | 2 +-
 growfs/Makefile   | 2 +-
 io/Makefile       | 2 +-
 logprint/Makefile | 2 +-
 mkfs/Makefile     | 2 +-
 repair/Makefile   | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/copy/Makefile b/copy/Makefile
index 54f6dfb..beabbd4 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -11,7 +11,7 @@ HFILES = xfs_copy.h
 
 LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
 LTDEPENDENCIES = $(LIBXFS)
-LLDFLAGS = -static
+LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
 
diff --git a/db/Makefile b/db/Makefile
index bae6154..fb01bdd 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -18,7 +18,7 @@ LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
-LLDFLAGS += -static
+LLDFLAGS += -static-libtool-libs
 
 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
diff --git a/growfs/Makefile b/growfs/Makefile
index 88cbf4f..19616de 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -19,7 +19,7 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
 LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD)
-LLDFLAGS = -static
+LLDFLAGS = -static-libtool-libs
 LSRCFILES = xfs_info.sh
 
 default: depend $(LTCOMMAND)
diff --git a/io/Makefile b/io/Makefile
index 82593a6..a08a782 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -15,7 +15,7 @@ CFILES = init.c \
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
-LLDFLAGS = -static
+LLDFLAGS = -static-libtool-libs
 
 ifeq ($(HAVE_FADVISE),yes)
 CFILES += fadvise.c
diff --git a/logprint/Makefile b/logprint/Makefile
index 2d656a4..7bcf27f 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -14,7 +14,7 @@ CFILES = logprint.c \
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
-LLDFLAGS = -static
+LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
 
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 75da633..fd1f615 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -21,7 +21,7 @@ endif
 
 LLDLIBS += $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS)
-LLDFLAGS = -static
+LLDFLAGS = -static-libtool-libs
 
 LSRCFILES = $(FSTYP).c
 LDIRT = $(FSTYP)
diff --git a/repair/Makefile b/repair/Makefile
index 17a30fd..6d84ade 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -22,7 +22,7 @@ CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
-LLDFLAGS = -static
+LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
