Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPBLxvq002346 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 05:21:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45F0C15ECD3C
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 03:02:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8RvOA7YeTWalBAnw for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 03:02:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L4vaw-0005yG-Br
	for xfs@oss.sgi.com; Tue, 25 Nov 2008 10:56:38 +0000
Date: Tue, 25 Nov 2008 05:56:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsdump: make help printing a little smarter
Message-ID: <20081125105638.GB21288@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

fprintf returns the number of characters printed, we can use this
for the offsetted lines.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsdump/common/main.c
===================================================================
--- xfs-cmds.orig/xfsdump/common/main.c	2008-11-13 18:39:06.000000000 +0100
+++ xfs-cmds/xfsdump/common/main.c	2008-11-13 18:40:43.000000000 +0100
@@ -960,20 +960,12 @@ main( int argc, char *argv[] )
 void
 usage( void )
 {
-	char linebuf[ 200 ];
 	int pfxsz;
-	int ps;
+	int ps = 0;
 	char *ns = "";
 
-	sprintf( linebuf,
-		 _("%s: usage: %s "),
-		 progname,
-		 basename( progname ));
-	pfxsz = strlen( linebuf );
-	ASSERT( pfxsz < sizeof( linebuf ));
-	ps = 0;
-
-	fprintf( stderr, linebuf );
+	pfxsz = fprintf(stderr, _("%s: usage: %s "),
+				progname, basename(progname));
 
 #ifdef DUMP
 	ULO(_("(dump DMF dualstate files as offline)"),	GETOPT_DUMPASOFFLINE );
Index: xfs-cmds/xfsdump/invutil/invutil.c
===================================================================
--- xfs-cmds.orig/xfsdump/invutil/invutil.c	2008-11-13 18:34:44.000000000 +0100
+++ xfs-cmds/xfsdump/invutil/invutil.c	2008-11-13 18:40:59.000000000 +0100
@@ -1082,18 +1082,12 @@ mmap_n_bytes(int fd, size_t count, bool_
 void
 usage (void)
 {
-    char linebuf[ 200 ];
     int pfxsz;
-    int ps;
+    int ps = 0;
     char *ns = "";
 
-    fprintf( stderr, "%s: %s\n", g_programName, g_programVersion );
-    snprintf( linebuf, sizeof(linebuf), "Usage: %s ", g_programName );
-    pfxsz = strlen( linebuf );
-    assert( pfxsz < sizeof( linebuf ));
-    ps = 0;
-
-    fprintf( stderr, linebuf );
+    fprintf(stderr, "%s: %s\n", g_programName, g_programVersion);
+    pfxsz = fprintf(stderr, "Usage: %s ", g_programName);
 
 #ifdef REVEAL
     ULO( "(output debug information)", GETOPT_DEBUG );

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
