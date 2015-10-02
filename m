Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FD7D7F56
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 70F238F8035
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oLMcMVpbRmCACSGM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id A6E36C0B64A1
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvBF031600
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 14/18] xfs_copy: check for dirty log on non-duplicate copies
Date: Fri,  2 Oct 2015 14:19:51 -0400
Message-Id: <1443809995-20395-15-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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

xfs_copy either copies the log as-is or formats the log of the target(s)
based on whether duplicate copy mode is enabled. The target log is
formatted when non-duplicate mode is enabled because copies gain a new
fs UUID and the new UUID must be stamped into the log.

When non-duplicate mode is enabled, however, xfs_copy does not check
whether the source filesystem log is actually clean. If the source log
is dirty, the target filesystem is silently created with a clean log and
thus ends up in a potentially corrupted state.

Update xfs_copy to check the source log state and fail the copy if in
non-duplicate mode and the log is dirty. Encourage the user to mount the
filesystem or run xfs_repair to clear the log. Note that the log is
scanned unconditionally as opposed to only in non-duplicate mode because
v5 superblock log format support requires the current cycle number to
format the log correctly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 Makefile        |  2 +-
 copy/Makefile   |  4 ++--
 copy/xfs_copy.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 19fb8c5..fca0a42 100644
--- a/Makefile
+++ b/Makefile
@@ -81,7 +81,7 @@ growfs: libxcmd
 io: libxcmd libhandle
 quota: libxcmd
 repair: libxlog
-
+copy: libxlog
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/copy/Makefile b/copy/Makefile
index beabbd4..e630b17 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_copy
 CFILES = xfs_copy.c
 HFILES = xfs_copy.h
 
-LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
-LTDEPENDENCIES = $(LIBXFS)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 949be5f..f3e5288 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -23,6 +23,7 @@
 #include <signal.h>
 #include <stdarg.h>
 #include "xfs_copy.h"
+#include "libxlog.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
@@ -128,6 +129,12 @@ do_message(int flags, int code, const char *fmt, ...)
 			exit(1); \
 		} while (0)
 
+/* workaround craziness in the xlog routines */
+int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
+{
+	return 0;
+}
+
 void
 check_errors(void)
 {
@@ -522,6 +529,7 @@ main(int argc, char **argv)
 	ag_header_t	ag_hdr;
 	xfs_mount_t	*mp;
 	xfs_mount_t	mbuf;
+	struct xlog	xlog;
 	xfs_buf_t	*sbp;
 	xfs_sb_t	*sb;
 	xfs_agnumber_t	num_ags, agno;
@@ -717,6 +725,31 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
+
+	/*
+	 * Set up the mount pointer to access the log and check whether the log
+	 * is clean. Fail on a dirty or corrupt log in non-duplicate mode
+	 * because the log is formatted as part of the copy and we don't want to
+	 * destroy data. We also need the current log cycle to format v5
+	 * superblock logs correctly.
+	 */
+	memset(&xlog, 0, sizeof(struct xlog));
+	mp->m_log = &xlog;
+	c = xlog_is_dirty(mp, mp->m_log, &xargs, 0);
+	if (!duplicate) {
+		if (c == 1) {
+			do_log(_(
+"Error: source filesystem log is dirty. Mount the filesystem to replay the\n"
+"log, unmount and retry xfs_copy.\n"));
+			exit(1);
+		} else if (c < 0) {
+			do_log(_(
+"Error: could not determine the log head or tail of the source filesystem.\n"
+"Mount the filesystem to replay the log or run xfs_repair.\n"));
+			exit(1);
+		}
+	}
+
 	source_blocksize = mp->m_sb.sb_blocksize;
 	source_sectorsize = mp->m_sb.sb_sectsize;
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
