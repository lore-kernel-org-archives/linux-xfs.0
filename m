Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p250M3ot198593 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 18:22:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 837291AECD9D
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 16:24:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AB6QG5gByoW81w55 for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 16:24:55 -0800 (PST)
Message-Id: <20110305002453.629027892@bombadil.infradead.org>
Date: Fri, 04 Mar 2011 19:22:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs_io: add -p for hole punching to falloc command
References: <20110305002222.395571492@bombadil.infradead.org>
Content-Disposition: inline; filename=add-fallocate-punch-support
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
Cc: josef@redhat.com

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 io/prealloc.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

Index: xfsprogs-dev/io/prealloc.c
===================================================================
--- xfsprogs-dev.orig/io/prealloc.c	2010-09-11 19:49:44.000000000 +0000
+++ xfsprogs-dev/io/prealloc.c	2011-03-05 00:07:16.000000000 +0000
@@ -25,6 +25,10 @@
 #include "init.h"
 #include "io.h"
 
+#ifndef FALLOC_FL_PUNCH_HOLE
+#define FALLOC_FL_PUNCH_HOLE	0x02
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -154,11 +158,14 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "k")) != EOF) {
+	while ((c = getopt(argc, argv, "kp")) != EOF) {
 		switch (c) {
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
+		case 'p':
+			mode = FALLOC_FL_PUNCH_HOLE;
+			break;
 		default:
 			command_usage(&falloc_cmd);
 		}
@@ -236,7 +243,7 @@ prealloc_init(void)
 	falloc_cmd.argmin = 2;
 	falloc_cmd.argmax = -1;
 	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	falloc_cmd.args = _("[-k] off len");
+	falloc_cmd.args = _("[-k] [-p] off len");
 	falloc_cmd.oneline =
 		_("allocates space associated with part of a file via fallocate");
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
