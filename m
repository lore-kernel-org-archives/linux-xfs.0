Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p250M3BX198591 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 18:22:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5040D15819C4
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 16:24:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VviEk7Dc2o29l3fn for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 16:24:54 -0800 (PST)
Message-Id: <20110305002453.815562682@bombadil.infradead.org>
Date: Fri, 04 Mar 2011 19:22:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs_io: add fpunch command for hole punching via fallocate
References: <20110305002222.395571492@bombadil.infradead.org>
Content-Disposition: inline; filename=add-fpunch-command
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

Add a fpunch command which simply uses fallocate to punch a hole for the
given offset and length.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 io/prealloc.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 4 deletions(-)

Index: xfsprogs-dev/io/prealloc.c
===================================================================
--- xfsprogs-dev.orig/io/prealloc.c	2011-03-05 00:07:16.000000000 +0000
+++ xfsprogs-dev/io/prealloc.c	2011-03-05 00:10:37.000000000 +0000
@@ -36,6 +36,7 @@ static cmdinfo_t unresvsp_cmd;
 static cmdinfo_t zero_cmd;
 #if defined(HAVE_FALLOCATE)
 static cmdinfo_t falloc_cmd;
+static cmdinfo_t fpunch_cmd;
 #endif
 
 static int
@@ -183,7 +184,26 @@ fallocate_f(
 	}
 	return 0;
 }
-#endif
+
+static int
+fpunch_f(
+	 int		argc,
+	 char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
+#endif	/* HAVE_FALLOCATE */
 
 void
 prealloc_init(void)
@@ -246,7 +266,16 @@ prealloc_init(void)
 	falloc_cmd.args = _("[-k] [-p] off len");
 	falloc_cmd.oneline =
 		_("allocates space associated with part of a file via fallocate");
-
 	add_command(&falloc_cmd);
-#endif
+
+	fpunch_cmd.name = _("fpunch");
+	fpunch_cmd.cfunc = fpunch_f;
+	fpunch_cmd.argmin = 2;
+	fpunch_cmd.argmax = 2;
+	fpunch_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fpunch_cmd.args = _("off len");
+	fpunch_cmd.oneline =
+		_("de-allocates space assocated with part of a file via fallocate");
+	add_command(&fpunch_cmd);
+#endif	/* HAVE_FALLOCATE */
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
