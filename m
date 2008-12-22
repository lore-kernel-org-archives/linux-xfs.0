Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGhuMU006420 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:43:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BB163F8CB
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tVp5uWpWkllil6ZK for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:55 -0800 (PST)
Message-Id: <20081222164354.791535000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/20] Fix build when gettext is enabled
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6299166105039057976=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6299166105039057976==
Content-Disposition: inline; filename=xfsprogs-gettext-fix-build

From: Jakub Bogusz <qboosh@pld-linux.org>

Build fails when gettext is enabled:

progress.c:16: error: initializer element is not constant
progress.c:16: error: (near initialization for ‘rpt_types[0]’)
progress.c:18: error: initializer element is not constant
progress.c:18: error: (near initialization for ‘rpt_types[1]’)
[...]

Fix that using commonly standard N_() macro.

Improvements by Arkadiusz Miśkiewicz <arekm@maven.pl>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 xfsprogs/include/buildrules         |    2 +-
 xfsprogs/include/platform_defs.h.in |    2 +
 xfsprogs/repair/progress.c          |   50 +++++++++++++++++-----------------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/xfsprogs/include/buildrules b/xfsprogs/include/buildrules
index 7155b21..1047ec3 100644
--- a/xfsprogs/include/buildrules
+++ b/xfsprogs/include/buildrules
@@ -40,7 +40,7 @@ endif
 
 ifdef POTHEAD
 $(POTHEAD): $(XGETTEXTFILES)
-	$(XGETTEXT) --language=C --keyword=_ -o $@ $(XGETTEXTFILES)
+	$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
 
 # Generate temp .po files, to check whether translations need updating.
 # Not by default, due to gettext output differences between versions.
diff --git a/xfsprogs/include/platform_defs.h.in b/xfsprogs/include/platform_defs.h.in
index 6682ef6..4f8ebe5 100644
--- a/xfsprogs/include/platform_defs.h.in
+++ b/xfsprogs/include/platform_defs.h.in
@@ -129,8 +129,10 @@ typedef unsigned long long __psunsigned_t;
 #ifdef ENABLE_GETTEXT
 # include <libintl.h>
 # define _(x)                   gettext(x)
+# define N_(x)			 x
 #else
 # define _(x)                   (x)
+# define N_(x)			 x
 # define textdomain(d)          do { } while (0)
 # define bindtextdomain(d,dir)  do { } while (0)
 #endif
diff --git a/xfsprogs/repair/progress.c b/xfsprogs/repair/progress.c
index 0ca9a8a..ff42f82 100644
--- a/xfsprogs/repair/progress.c
+++ b/xfsprogs/repair/progress.c
@@ -13,30 +13,30 @@
 static
 char *rpt_types[] = {
 #define TYPE_INODE 	0
-	_("inodes"),
+	N_("inodes"),
 #define TYPE_BLOCK 	1
-	_("blocks"),
+	N_("blocks"),
 #define TYPE_DIR   	2
-	_("directories"),
+	N_("directories"),
 #define TYPE_AG		3
-	_("allocation groups"),
+	N_("allocation groups"),
 #define TYPE_AGI_BUCKET	4
-	_("AGI unlinked buckets"),
+	N_("AGI unlinked buckets"),
 #define TYPE_EXTENTS	5
-	_("extents"),
+	N_("extents"),
 #define TYPE_RTEXTENTS	6
-	_("realtime extents"),
+	N_("realtime extents"),
 #define TYPE_UNLINKED_LIST 7
-	_("unlinked lists")
+	N_("unlinked lists")
 };
 
 
 static
 char *rpt_fmts[] = {
 #define FMT1 0
-_("        - %02d:%02d:%02d: %s - %llu of %llu %s done\n"),
+N_("        - %02d:%02d:%02d: %s - %llu of %llu %s done\n"),
 #define FMT2 1
-_("        - %02d:%02d:%02d: %s - %llu %s done\n"),
+N_("        - %02d:%02d:%02d: %s - %llu %s done\n"),
 };
 
 typedef struct progress_rpt_s {
@@ -48,35 +48,35 @@ typedef struct progress_rpt_s {
 
 static
 progress_rpt_t progress_rpt_reports[] = {
-{FMT1, _("scanning filesystem freespace"),			/*  0 */
+{FMT1, N_("scanning filesystem freespace"),			/*  0 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, _("scanning agi unlinked lists"),			/*  1 */
+{FMT1, N_("scanning agi unlinked lists"),			/*  1 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT2, _("check uncertain AG inodes"),				/*  2 */
+{FMT2, N_("check uncertain AG inodes"),				/*  2 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_AGI_BUCKET]},
-{FMT1, _("process known inodes and inode discovery"),		/*  3 */
+{FMT1, N_("process known inodes and inode discovery"),		/*  3 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
-{FMT1, _("process newly discovered inodes"),			/*  4 */
+{FMT1, N_("process newly discovered inodes"),			/*  4 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, _("setting up duplicate extent list"),			/*  5 */
+{FMT1, N_("setting up duplicate extent list"),			/*  5 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, _("initialize realtime bitmap"),				/*  6 */
+{FMT1, N_("initialize realtime bitmap"),			/*  6 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_BLOCK]},
-{FMT1, _("reset realtime bitmaps"),				/*  7 */
+{FMT1, N_("reset realtime bitmaps"),				/*  7 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, _("check for inodes claiming duplicate blocks"),		/*  8 */
+{FMT1, N_("check for inodes claiming duplicate blocks"),	/*  8 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
-{FMT1, _("rebuild AG headers and trees"),	 		/*  9 */
+{FMT1, N_("rebuild AG headers and trees"),	 		/*  9 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, _("traversing filesystem"),				/* 10 */
+{FMT1, N_("traversing filesystem"),				/* 10 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT2, _("traversing all unattached subtrees"),			/* 11 */
+{FMT2, N_("traversing all unattached subtrees"),		/* 11 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_DIR]},
-{FMT2, _("moving disconnected inodes to lost+found"),		/* 12 */
+{FMT2, N_("moving disconnected inodes to lost+found"),		/* 12 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_INODE]},
-{FMT1, _("verify and correct link counts"),			/* 13 */
+{FMT1, N_("verify and correct link counts"),			/* 13 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
-{FMT1, _("verify link counts"),					/* 14 */
+{FMT1, N_("verify link counts"),				/* 14 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]}
 };
 
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

-- 


--===============6299166105039057976==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6299166105039057976==--
