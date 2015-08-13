Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41B897F51
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 09:11:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03300304032
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 07:10:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GZEAhEuL2vK6whZA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 07:10:59 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id B035F8E3CE
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 14:10:58 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 13/11] xfsprogs: Add a way to compile without blkid
Date: Thu, 13 Aug 2015 16:10:55 +0200
Message-Id: <1439475055-5519-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

Because not all platforms have up-to-date blkid with required
functions, allow at least partial functionality by adding
--enable-blkid=yes/no optional configure argument.

When blkid is disabled, signature detection and device geometry
detection doesn't work.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac         | 10 +++++++++-
 include/builddefs.in |  1 +
 mkfs/xfs_mkfs.c      | 22 +++++++++++++++++++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 9ea8b22..a734926 100644
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
@@ -115,11 +120,14 @@ AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
-AC_HAVE_BLKID_TOPO
 AC_HAVE_READDIR
 AC_HAVE_MNTENT
 AC_HAVE_FLS
 
+if test "$enable_blkid" = yes; then
+AC_HAVE_BLKID_TOPO
+fi
+
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/include/builddefs.in b/include/builddefs.in
index 8851956..f3f8089 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -89,6 +89,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_READLINE	= @enable_readline@
+ENABLE_BLKID	= @enable_blkid@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d349b4f..656c3f9 100644
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
@@ -451,6 +454,19 @@ out_free_probe:
 		_("warning: unable to probe device topology for device %s\n"),
 		device);
 }
+#else /* ifdef ENABLE_BLKID */
+/*
+ * Without blkid, we can't do a good check for signatures.
+ * So instead of some messy attempts, just disable any checks
+ * and always return 'nothing found'.
+ */
+static int
+check_overwrite(
+	char		*device)
+{
+	return 0;
+}
+#endif /* ENABLE_BLKID */
 
 static void get_topology(
 	libxfs_init_t		*xi,
@@ -483,16 +499,20 @@ static void get_topology(
 		} else
 			ft->psectorsize = ft->lsectorsize = BBSIZE;
 	} else {
+#ifdef ENABLE_BLKID
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
 				   &ft->lsectorsize, &ft->psectorsize,
 				   force_overwrite);
+#endif /* ENABLE_BLKID */
 	}
 
 	if (xi->rtname && !xi->risfile) {
 		int sunit, lsectorsize, psectorsize;
 
+#ifdef ENABLE_BLKID
 		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
 				   &lsectorsize, &psectorsize, force_overwrite);
+#endif /* ENABLE_BLKID */
 	}
 }
 
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
