Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4DE87F5F
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F3BFAC001
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dj8j2GdcclUXZXqH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:43 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 01/11] xfsprogs: Add a way to compile without blkid
Date: Wed, 26 Aug 2015 14:02:25 +0200
Message-Id: <1440590555-20463-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Because not all platforms have up-to-date blkid with required
functions, allow at least partial functionality by adding
--enable-blkid=yes/no optional configure argument.

When blkid is disabled, signature detection and device geometry
detection doesn't work.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac         | 10 +++++++++-
 include/builddefs.in |  5 +++++
 mkfs/xfs_mkfs.c      | 37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 665b65f..0446620 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,6 +26,11 @@ AC_ARG_ENABLE(gettext,
 	enable_gettext=yes)
 AC_SUBST(enable_gettext)
 
+AC_ARG_ENABLE(blkid,
+[ --enable-blkid=[yes/no] Enable use of block device id library [default=yes]],,
+	enable_blkid=yes)
+AC_SUBST(enable_blkid)
+
 AC_ARG_ENABLE(readline,
 [ --enable-readline=[yes/no] Enable readline command editing [default=no]],
 	test $enable_readline = yes && libreadline="-lreadline",
@@ -117,9 +122,12 @@ AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_MNTENT
 AC_HAVE_FLS
-AC_HAVE_BLKID_TOPO
 AC_HAVE_READDIR
 
+if test "$enable_blkid" = yes; then
+AC_HAVE_BLKID_TOPO
+fi
+
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/include/builddefs.in b/include/builddefs.in
index 8851956..6c16a65 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -89,6 +89,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_READLINE	= @enable_readline@
+ENABLE_BLKID	= @enable_blkid@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
@@ -138,6 +139,10 @@ endif
 ifeq ($(HAVE_MNTENT),yes)
 PCFLAGS+= -DHAVE_MNTENT
 endif
+ifeq ($(ENABLE_BLKID),yes)
+PCFLAGS+= -DENABLE_BLKID
+endif
+
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d993fc0..5964eaf 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -18,7 +18,9 @@
 
 #include "libxfs.h"
 #include <ctype.h>
-#include <blkid/blkid.h>
+#ifdef ENABLE_BLKID
+#  include <blkid/blkid.h>
+#endif /* ENABLE_BLKID */
 #include "xfs_mkfs.h"
 
 /*
@@ -298,6 +300,7 @@ calc_stripe_factors(
  *	 0 for nothing found
  *	-1 for internal error
  */
+#ifdef ENABLE_BLKID
 static int
 check_overwrite(
 	char		*device)
@@ -451,6 +454,38 @@ out_free_probe:
 		_("warning: unable to probe device topology for device %s\n"),
 		device);
 }
+#else /* ifdef ENABLE_BLKID */
+/*
+ * Without blkid, we can't do a good check for signatures.
+ * So instead of some messy attempts, just disable any checks
+ * and always return 'nothing found'.
+ */
+#  warning BLKID is disabled, so signature detection and block device\
+ access are not working!
+static int
+check_overwrite(
+	char		*device)
+{
+	return 1;
+}
+
+static void blkid_get_topology(
+	const char	*device,
+	int		*sunit,
+	int		*swidth,
+	int		*lsectorsize,
+	int		*psectorsize,
+	int		force_overwrite)
+{
+	/*
+	 * Shouldn't make any difference (no blkid = no block device access),
+	 * but make sure this dummy replacement returns with at least some
+	 * sanity.
+	 */
+	*lsectorsize = *psectorsize = 512;
+}
+
+#endif /* ENABLE_BLKID */
 
 static void get_topology(
 	libxfs_init_t		*xi,
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
