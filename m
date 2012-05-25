Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PEkWsc129355 for <xfs@oss.sgi.com>; Fri, 25 May 2012 09:46:32 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id nucHK5TrEWx0OR84 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 07:46:30 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: rename to configure.ac
Date: Fri, 25 May 2012 16:46:28 +0200
Message-Id: <1337957188-3489-1-git-send-email-jengelh@inai.de>
In-Reply-To: <alpine.LNX.2.01.1205251641430.14283@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1205251641430.14283@frira.zrqbmnf.qr>
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
Cc: hch@infradead.org, jengelh@inai.de

This is simply the modern recommended name. (As a side note, it also
selects the right syntax coloring because .ac tells more than .in.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in |  119 ----------------------------------------------------------
 2 files changed, 119 insertions(+), 119 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..664c0e9
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,119 @@
+AC_INIT(include/libxfs.h)
+AC_PREREQ(2.50)
+AC_CONFIG_AUX_DIR([.])
+AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_HEADER(include/platform_defs.h)
+AC_PREFIX_DEFAULT(/usr)
+
+AC_PROG_LIBTOOL
+
+AC_ARG_ENABLE(shared,
+[ --enable-shared=[yes/no] Enable use of shared libraries [default=yes]],,
+	enable_shared=yes)
+AC_SUBST(enable_shared)
+
+AC_ARG_ENABLE(gettext,
+[ --enable-gettext=[yes/no] Enable alternate language support [default=yes]],,
+	enable_gettext=yes)
+AC_SUBST(enable_gettext)
+
+AC_ARG_ENABLE(readline,
+[ --enable-readline=[yes/no] Enable readline command editing [default=no]],
+	test $enable_readline = yes && libreadline="-lreadline",
+	enable_readline=no)
+AC_SUBST(libreadline)
+AC_SUBST(enable_readline)
+
+AC_ARG_ENABLE(editline,
+[ --enable-editline=[yes/no] Enable editline command editing [default=no]],
+	test $enable_editline = yes && libeditline="-ledit",
+	enable_editline=no)
+AC_SUBST(libeditline)
+AC_SUBST(enable_editline)
+
+AC_ARG_ENABLE(termcap,
+[ --enable-termcap=[yes/no] Enable terminal capabilities library [default=no]],
+	test $enable_termcap = yes && libtermcap="-ltermcap",)
+AC_SUBST(libtermcap)
+
+# AC_HAVE_BLKID_TOPO below wil find the library & check for topo support
+AC_ARG_ENABLE(blkid,
+[ --enable-blkid=[yes/no] Enable block device id library [default=yes]],,
+	enable_blkid=yes)
+
+AC_ARG_ENABLE(lib64,
+[ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
+	enable_lib64=yes)
+AC_SUBST(enable_lib64)
+
+#
+# If the user specified a libdir ending in lib64 do not append another
+# 64 to the library names.
+#
+base_libdir=`basename "$libdir"`
+case $base_libdir in
+lib64)
+  enable_lib64=no
+esac
+
+#
+# Some important tools should be installed into the root partitions.
+#
+# Check whether exec_prefix=/usr: and install them to /sbin in that
+# case.  If the user choses a different prefix assume he just wants
+# a local install for testing and not a system install.
+#
+case $exec_prefix:$prefix in
+NONE:NONE | NONE:/usr | /usr:*)
+  root_sbindir='/sbin'
+  root_libdir="/${base_libdir}"
+  ;;
+*)
+  root_sbindir="${sbindir}"
+  root_libdir="${libdir}"
+  ;;
+esac
+
+AC_SUBST([root_sbindir])
+AC_SUBST([root_libdir])
+
+# Find localized files.  Don't descend into any "dot directories"
+# (like .git or .pc from quilt).  Strangely, the "-print" argument
+# to "find" is required, to avoid including such directories in the
+# list.
+LOCALIZED_FILES=""
+for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -type f -print || exit 1`; do
+    LOCALIZED_FILES="$LOCALIZED_FILES \$(TOPDIR)/$lfile"
+done
+AC_SUBST(LOCALIZED_FILES)
+
+AC_PACKAGE_GLOBALS(xfsprogs)
+AC_PACKAGE_UTILITIES(xfsprogs)
+AC_MULTILIB($enable_lib64)
+
+AC_PACKAGE_NEED_AIO_H
+AC_PACKAGE_NEED_LIO_LISTIO
+
+AC_PACKAGE_NEED_UUID_H
+AC_PACKAGE_NEED_UUIDCOMPARE
+
+AC_PACKAGE_NEED_PTHREAD_H
+AC_PACKAGE_NEED_PTHREADMUTEXINIT
+
+AC_HAVE_FADVISE
+AC_HAVE_MADVISE
+AC_HAVE_MINCORE
+AC_HAVE_SENDFILE
+AC_HAVE_GETMNTENT
+AC_HAVE_GETMNTINFO
+AC_HAVE_FALLOCATE
+AC_HAVE_FIEMAP
+AC_HAVE_BLKID_TOPO($enable_blkid)
+
+AC_TYPE_PSINT
+AC_TYPE_PSUNSIGNED
+AC_TYPE_U32
+AC_SIZEOF_POINTERS_AND_LONG
+AC_MANUAL_FORMAT
+
+AC_OUTPUT(include/builddefs)
diff --git a/configure.in b/configure.in
deleted file mode 100644
index 664c0e9..0000000
--- a/configure.in
+++ /dev/null
@@ -1,119 +0,0 @@
-AC_INIT(include/libxfs.h)
-AC_PREREQ(2.50)
-AC_CONFIG_AUX_DIR([.])
-AC_CONFIG_MACRO_DIR([m4])
-AC_CONFIG_HEADER(include/platform_defs.h)
-AC_PREFIX_DEFAULT(/usr)
-
-AC_PROG_LIBTOOL
-
-AC_ARG_ENABLE(shared,
-[ --enable-shared=[yes/no] Enable use of shared libraries [default=yes]],,
-	enable_shared=yes)
-AC_SUBST(enable_shared)
-
-AC_ARG_ENABLE(gettext,
-[ --enable-gettext=[yes/no] Enable alternate language support [default=yes]],,
-	enable_gettext=yes)
-AC_SUBST(enable_gettext)
-
-AC_ARG_ENABLE(readline,
-[ --enable-readline=[yes/no] Enable readline command editing [default=no]],
-	test $enable_readline = yes && libreadline="-lreadline",
-	enable_readline=no)
-AC_SUBST(libreadline)
-AC_SUBST(enable_readline)
-
-AC_ARG_ENABLE(editline,
-[ --enable-editline=[yes/no] Enable editline command editing [default=no]],
-	test $enable_editline = yes && libeditline="-ledit",
-	enable_editline=no)
-AC_SUBST(libeditline)
-AC_SUBST(enable_editline)
-
-AC_ARG_ENABLE(termcap,
-[ --enable-termcap=[yes/no] Enable terminal capabilities library [default=no]],
-	test $enable_termcap = yes && libtermcap="-ltermcap",)
-AC_SUBST(libtermcap)
-
-# AC_HAVE_BLKID_TOPO below wil find the library & check for topo support
-AC_ARG_ENABLE(blkid,
-[ --enable-blkid=[yes/no] Enable block device id library [default=yes]],,
-	enable_blkid=yes)
-
-AC_ARG_ENABLE(lib64,
-[ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
-	enable_lib64=yes)
-AC_SUBST(enable_lib64)
-
-#
-# If the user specified a libdir ending in lib64 do not append another
-# 64 to the library names.
-#
-base_libdir=`basename "$libdir"`
-case $base_libdir in
-lib64)
-  enable_lib64=no
-esac
-
-#
-# Some important tools should be installed into the root partitions.
-#
-# Check whether exec_prefix=/usr: and install them to /sbin in that
-# case.  If the user choses a different prefix assume he just wants
-# a local install for testing and not a system install.
-#
-case $exec_prefix:$prefix in
-NONE:NONE | NONE:/usr | /usr:*)
-  root_sbindir='/sbin'
-  root_libdir="/${base_libdir}"
-  ;;
-*)
-  root_sbindir="${sbindir}"
-  root_libdir="${libdir}"
-  ;;
-esac
-
-AC_SUBST([root_sbindir])
-AC_SUBST([root_libdir])
-
-# Find localized files.  Don't descend into any "dot directories"
-# (like .git or .pc from quilt).  Strangely, the "-print" argument
-# to "find" is required, to avoid including such directories in the
-# list.
-LOCALIZED_FILES=""
-for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -type f -print || exit 1`; do
-    LOCALIZED_FILES="$LOCALIZED_FILES \$(TOPDIR)/$lfile"
-done
-AC_SUBST(LOCALIZED_FILES)
-
-AC_PACKAGE_GLOBALS(xfsprogs)
-AC_PACKAGE_UTILITIES(xfsprogs)
-AC_MULTILIB($enable_lib64)
-
-AC_PACKAGE_NEED_AIO_H
-AC_PACKAGE_NEED_LIO_LISTIO
-
-AC_PACKAGE_NEED_UUID_H
-AC_PACKAGE_NEED_UUIDCOMPARE
-
-AC_PACKAGE_NEED_PTHREAD_H
-AC_PACKAGE_NEED_PTHREADMUTEXINIT
-
-AC_HAVE_FADVISE
-AC_HAVE_MADVISE
-AC_HAVE_MINCORE
-AC_HAVE_SENDFILE
-AC_HAVE_GETMNTENT
-AC_HAVE_GETMNTINFO
-AC_HAVE_FALLOCATE
-AC_HAVE_FIEMAP
-AC_HAVE_BLKID_TOPO($enable_blkid)
-
-AC_TYPE_PSINT
-AC_TYPE_PSUNSIGNED
-AC_TYPE_U32
-AC_SIZEOF_POINTERS_AND_LONG
-AC_MANUAL_FORMAT
-
-AC_OUTPUT(include/builddefs)
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
