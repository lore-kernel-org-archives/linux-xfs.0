Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6CFE7F51
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 11:01:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A64BA8F8035
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 09:01:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8XeGeJxXD0qWuA8l (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 09:01:04 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsprogs: blkid is now mandatory
Date: Wed,  1 Jul 2015 18:01:01 +0200
Message-Id: <1435766461-30961-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, sandeen@redhat.com

Because blkid is here for a long time, I hereby propose a patch for removing support
for NOT having blkid. The current support through set of #ifdef is prone to errors like
making a patch just in one of the branches, and according to a recent talk between
Christoph and Eric, it is not necessary to keep it supported.

Remove code for checking ENABLE_BLKID, and the code when ENABLE_BLKID is not defined.
It makes blkid required for compilation.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 Makefile             |  5 ----
 configure.ac         |  6 +----
 doc/INSTALL          | 44 ------------------------------------
 include/builddefs.in |  1 -
 libdisk/Makefile     |  4 ----
 m4/package_blkid.m4  |  7 +++---
 mkfs/Makefile        | 21 ++++-------------
 mkfs/xfs_mkfs.c      | 64 ----------------------------------------------------
 8 files changed, 10 insertions(+), 142 deletions(-)

diff --git a/Makefile b/Makefile
index d04f853..973bd42 100644
--- a/Makefile
+++ b/Makefile
@@ -66,11 +66,6 @@ io: libxcmd libhandle
 quota: libxcmd
 repair: libxlog
 
-
-ifneq ($(ENABLE_BLKID), yes)
-mkfs: libdisk
-endif
-
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
 else
diff --git a/configure.ac b/configure.ac
index ae17c68..108556b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,10 +37,6 @@ AC_ARG_ENABLE(termcap,
 	test $enable_termcap = yes && libtermcap="-ltermcap",)
 AC_SUBST(libtermcap)
 
-# AC_HAVE_BLKID_TOPO below wil find the library & check for topo support
-AC_ARG_ENABLE(blkid,
-[ --enable-blkid=[yes/no] Enable block device id library [default=yes]],,
-	enable_blkid=yes)
 
 AC_ARG_ENABLE(lib64,
 [ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
@@ -111,7 +107,7 @@ AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
-AC_HAVE_BLKID_TOPO($enable_blkid)
+AC_HAVE_BLKID_TOPO(yes)
 AC_HAVE_READDIR
 
 AC_CHECK_SIZEOF([long])
diff --git a/doc/INSTALL b/doc/INSTALL
index ba3472b..ae8b64e 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -48,50 +48,6 @@ Linux Instructions
    before running make or Makepkgs.
 
 
-Mac OS X Instructions
-=====================
-
-0. Note:  since there is no XFS implementation on Mac OS X, you are
-   severely limited in what you can do.  mkfs.xfs(8), xfs_db(8) and 
-   xfs_repair(8) are the only functional tools on this platform, as
-   they do not interact with the XFS kernel code at all.  Still, it
-   can be useful to have access to these utilities from Mac OS X in
-   a dual boot configuration, for example.
-
-1. Configure, build and install the package
-
-   The xfsprogs package uses autoconf/configure and expects a GNU build
-   environment (your platform must at least have both autoconf, make,
-   and glibtool). 
-
-   You will also need to have built and installed the UUID library which
-   is provided by the e2fsprogs source package.
-
-   Building libuuid:
-
-	[download; unzip/untar e2fsprogs; cd e2fsprogs]
-	$ ./configure --prefix=/usr --mandir=/usr/share/man
-	$ make lib/ext2fs/ext2_types.h
-	$ cd lib/uuid
-	$ make
-	$ su root
-	# make install
-	[verify that you now have a /usr/lib/libuuid.a]
-
-   Building xfsprogs:
-
-	[firstly set these environment variables to these values]
-	TAR=/usr/bin/gnutar
-	LIBTOOL=/usr/bin/glibtool
-	INSTALL_GROUP=wheel
-	LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no"
-
-	$ make
-	$ su root
-	# make install
-	[and optionally, for the development libraries and headers]
-	# make install-dev
-
 
 IRIX Instructions
 =================
diff --git a/include/builddefs.in b/include/builddefs.in
index 7e9f53d..e3a546f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -89,7 +89,6 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_READLINE	= @enable_readline@
-ENABLE_BLKID	= @enable_blkid@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
diff --git a/libdisk/Makefile b/libdisk/Makefile
index b058a9f..bbb3c8c 100644
--- a/libdisk/Makefile
+++ b/libdisk/Makefile
@@ -20,11 +20,7 @@ else
 LSRCFILES = $(LINUX_DRIVERS)
 endif
 
-ifneq ($(ENABLE_BLKID), yes)
-default: ltdepend $(LTLIBRARY)
-else
 default:
-endif
 
 include $(BUILDRULES)
 
diff --git a/m4/package_blkid.m4 b/m4/package_blkid.m4
index 44ca2cc..363142c 100644
--- a/m4/package_blkid.m4
+++ b/m4/package_blkid.m4
@@ -11,9 +11,10 @@ AC_DEFUN([AC_HAVE_BLKID_TOPO],
     if test $ac_cv_func_blkid_probe_get_topology = yes; then
       libblkid="-lblkid"
     else
-      libblkd=""
-      enable_blkid="no"
-      AC_SUBST(enable_blkid)
+      echo
+      echo 'FATAL ERROR: could not find a valid BLKID header.'
+      echo 'Install the Block device ID development package.'
+      exit 1
     fi
   fi
   AC_SUBST(libblkid)
diff --git a/mkfs/Makefile b/mkfs/Makefile
index fd1f615..6de2da4 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,15 +11,7 @@ FSTYP = fstyp
 HFILES = xfs_mkfs.h
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-ifeq ($(ENABLE_BLKID),yes)
-LLDLIBS += $(LIBBLKID)
-CFLAGS += -DENABLE_BLKID
-else
-LLDLIBS += $(LIBDISK)
-LTDEPENDENCIES += $(LIBDISK)
-endif
-
-LLDLIBS += $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS)
 LLDFLAGS = -static-libtool-libs
 
@@ -28,15 +20,12 @@ LDIRT = $(FSTYP)
 
 default: depend $(LTCOMMAND)
 
-ifneq ($(ENABLE_BLKID),yes)
-default: $(FSTYP)
-endif
-
 include $(BUILDRULES)
 
-$(FSTYP):
-	@echo "    [CC]     $@"
-	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
+# remove too with !enable_blkid?
+#$(FSTYP):
+#	@echo "    [CC]     $@"
+#	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
 
 install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 83f7749..ddbb509 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -18,12 +18,7 @@
 
 #include <xfs/libxfs.h>
 #include <ctype.h>
-#ifdef ENABLE_BLKID
 #include <blkid/blkid.h>
-#else
-#include <disk/fstyp.h>
-#include <disk/volume.h>
-#endif
 #include "xfs_mkfs.h"
 
 /*
@@ -297,7 +292,6 @@ calc_stripe_factors(
 	}
 }
 
-#ifdef ENABLE_BLKID
 /*
  * Check for existing filesystem or partition table on device.
  * Returns:
@@ -498,64 +492,6 @@ static void get_topology(
 				   &lsectorsize, &psectorsize, force_overwrite);
 	}
 }
-#else /* ENABLE_BLKID */
-static int
-check_overwrite(
-	char		*device)
-{
-	char		*type;
-
-	if (device && *device) {
-		if ((type = fstype(device)) != NULL) {
-			fprintf(stderr,
-				_("%s: %s appears to contain an existing "
-				"filesystem (%s).\n"), progname, device, type);
-			return 1;
-		}
-		if ((type = pttype(device)) != NULL) {
-			fprintf(stderr,
-				_("%s: %s appears to contain a partition "
-				"table (%s).\n"), progname, device, type);
-			return 1;
-		}
-	}
-	return 0;
-}
-
-static void get_topology(
-	libxfs_init_t		*xi,
-	struct fs_topology	*ft,
-	int			force_overwrite)
-{
-
-	char *dfile = xi->volname ? xi->volname : xi->dname;
-	int bsz = BBSIZE;
-
-	if (!xi->disfile) {
-		int fd;
-		long long dummy;
-
-		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
-				&ft->dsunit, &ft->dswidth, &ft->sectoralign);
-		fd = open(dfile, O_RDONLY);
-		/* If this fails we just fall back to BBSIZE */
-		if (fd >= 0) {
-			platform_findsizes(dfile, fd, &dummy, &bsz);
-			close(fd);
-		}
-	}
-
-	ft->lsectorsize = bsz;
-	ft->psectorsize = bsz;
-
-	if (xi->rtname && !xi->risfile) {
-		int dummy1;
-
-		get_subvol_stripe_wrapper(dfile, SVTYPE_RT, &dummy1,
-					  &ft->rtswidth, &dummy1);
-	}
-}
-#endif /* ENABLE_BLKID */
 
 static void
 fixup_log_stripe_unit(
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
