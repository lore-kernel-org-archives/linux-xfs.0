Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbdDKOMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:12:53 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Date: Tue, 11 Apr 2017 16:12:37 +0200
Message-Id: <20170411141237.9274-3-jtulak@redhat.com>
In-Reply-To: <20170411141237.9274-1-jtulak@redhat.com>
References: <20170411141237.9274-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

A dirty log in an obfuscated dump means that a corruption can happen
when replaying the log (which contains unobfuscated data). Warn the user
about this possibility.

The xlog workaround is copy&paste solution from repair/phase2.c and
other tools, because the function is not implemented in libxlog.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mdrestore/Makefile        |  4 +--
 mdrestore/xfs_mdrestore.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index 5171306..6355df9 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -8,8 +8,8 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_mdrestore
 CFILES = xfs_mdrestore.c
 
-LLDLIBS = $(LIBXFS) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
-LTDEPENDENCIES = $(LIBXFS)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
 LLDFLAGS = -static
 
 default: depend $(LTCOMMAND)
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0d399f1..3797955 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -17,6 +17,7 @@
  */
 
 #include "libxfs.h"
+#include "libxlog.h"
 #include "xfs_metadump.h"
 
 char 		*progname;
@@ -190,6 +191,87 @@ perform_restore(
 	free(metablock);
 }
 
+/* workaround craziness in the xlog routines */
+int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
+{
+	return 0;
+}
+
+/*
+ * Warn if we just wrote a dump with a dirty log.
+ */
+void
+test_dirty_log(
+	bool	is_target_file,
+	char*	target_name)
+{
+	struct xfs_sb	*sbp;
+	struct xfs_buf	*bp;
+	struct xfs_mount	xmount;
+	struct xfs_mount	*mp;
+	struct xlog		xlog;
+	libxfs_init_t		x;
+
+	x.isreadonly = LIBXFS_ISREADONLY;
+	if (is_target_file) {
+		x.dname = target_name;
+		x.disfile = true;
+	} else {
+		x.disfile = false;
+		x.volname = target_name;
+	}
+
+	if (!libxfs_init(&x)) {
+		fatal(_("\nfatal error -- couldn't initialize XFS library\n"),
+		      strerror(errno));
+	}
+
+	memset(&xmount, 0, sizeof(struct xfs_mount));
+	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
+	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
+			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
+
+	if (!bp || bp->b_error) {
+		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
+			"bytes)\n"), progname, target_name);
+		exit(1);
+	}
+
+	/* copy SB from buffer to in-core, converting architecture as we go */
+	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
+	libxfs_putbuf(bp);
+	libxfs_purgebuf(bp);
+
+	sbp = &xmount.m_sb;
+	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
+			  LIBXFS_MOUNT_DEBUGGER);
+	if (!mp) {
+		fprintf(stderr,
+			_("%s: restored device %s unusable (not an XFS filesystem?)\n"),
+			progname, target_name);
+		exit(1);
+	}
+
+	switch (xlog_is_dirty(mp, &xlog, &x,0)) {
+		case -1:
+			/* An error occured and we can't read the log. */
+			fprintf(stderr,
+			_("Warning: can't discern a log.\n"));
+			break;
+		case 1:
+			/* The log is dirty, warn. */
+			fprintf(stderr,
+			_("Warning: The log is dirty. If the image was obfuscated, "
+			  "an attempt to replay the log may lead to corruption.\n"));
+			break;
+		case 0:
+			 /* Everything is ok. */
+			break;
+	}
+
+}
+
+
 static void
 usage(void)
 {
@@ -271,5 +353,7 @@ main(
 	if (src_f != stdin)
 		fclose(src_f);
 
+	test_dirty_log(is_target_file, argv[optind]);
+
 	return 0;
 }
-- 
2.1.4

