Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1298k7E236751 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 03:08:46 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56AA51BFF3EE
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2009 01:08:06 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id LH0Il3RAiAJAF97L for
	<xfs@oss.sgi.com>; Mon, 02 Feb 2009 01:08:06 -0800 (PST)
From: =?utf-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] xfstests: Fix *FLAGS passing and dependencies.
Date: Mon,  2 Feb 2009 10:08:04 +0100
Message-Id: <1233565684-462-1-git-send-email-arekm@maven.pl>
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
Cc: root <root@farm.lan>

From: root <root@farm.lan>

Pass *FLAGS in some targets.

Drop LIBHANDLE, LIBATTR and LIBACL from deps since there are in form
"-llibrary".

Signed-off-by: root <root@farm.lan>
---
 src/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index ad4c204..634e1b3 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -58,10 +58,10 @@ genhashnames: genhashnames.o
 nametest: nametest.o $(LIBTEST)
 	$(LINKTEST) $(LIBTEST) $(LDLIBS)
 
-bstat: bstat.o $(LIBHANDLE)
+bstat: bstat.o
 	$(LINKTEST) $(LIBHANDLE) $(LDLIBS)
 
-t_immutable: t_immutable.o $(LIBHANDLE) $(LIBACL)
+t_immutable: t_immutable.o
 	$(LINKTEST) $(LIBACL) $(LIBHANDLE) $(LDLIBS)
 
 loggen:	loggen.o
@@ -82,17 +82,17 @@ multi_open_unlink: multi_open_unlink.o
 #scaleread: scaleread.o $(LDLIBS)
 #	$(LINKTEST)
 
-acl_get: acl_get.o $(LIBACL) $(LIBATTR)
+acl_get: acl_get.o
 	$(LINKTEST) $(LIBACL) $(LIBATTR) $(LDLIBS)
 
-dmiperf: dmiperf.o $(LIBATTR)
+dmiperf: dmiperf.o
 	$(LINKTEST) $(LIBATTR) $(LDLIBS)
 
 preallo_rw_pattern_reader:
-	$(CC) -DREAD iopat.c -o preallo_rw_pattern_reader
+	$(CC) $(GCFLAGS) $(LDFLAGS) -DREAD iopat.c -o preallo_rw_pattern_reader
 
 preallo_rw_pattern_writer:
-	$(CC) -DWRITE iopat.c -o preallo_rw_pattern_writer
+	$(CC) $(GCFLAGS) $(LDFLAGS) -DWRITE iopat.c -o preallo_rw_pattern_writer
 
 ftrunc: ftrunc.o
 	$(LINKTEST)
-- 
1.6.1.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
