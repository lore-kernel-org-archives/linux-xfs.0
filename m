Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TAbBkD063581 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 05:37:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFD1C8EC793
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:39:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Y8JnGBEu5QAqeHCj for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:39:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O7R9I-0002kR-5l
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:39:16 +0000
Date: Thu, 29 Apr 2010 06:39:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix fiemap-tester when build without fallocate
Message-ID: <20100429103916.GA10535@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Make sure at least the tests passing -p0 like xfstests 225 can work when
built without fallocate support.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/src/fiemap-tester.c
===================================================================
--- xfstests-dev.orig/src/fiemap-tester.c	2010-04-29 10:32:52.000000000 +0000
+++ xfstests-dev/src/fiemap-tester.c	2010-04-29 10:35:11.000000000 +0000
@@ -37,14 +37,10 @@ static void
 usage(void)
 {
 	printf("Usage: fiemap-tester [-m map] [-r number of runs] [-s seed] [-q]");
-#ifdef HAVE_FALLOCATE
 	printf("[-p preallocate (1/0)] ");
-#endif
 	printf("filename\n");
 	printf("  -m map    : generate a file with the map given and test\n");
-#ifdef HAVE_FALLOCATE
 	printf("  -p 0/1    : turn block preallocation on or off\n");
-#endif
 	printf("  -r count  : number of runs to execute (default infinity)\n");
 	printf("  -s seed   : seed for random map generator (default 1)\n");
 	printf("  -q        : be quiet about non-errors\n");
@@ -513,9 +509,10 @@ main(int argc, char **argv)
 		case 'p':
 			prealloc = atoi(optarg);;
 #ifndef HAVE_FALLOCATE
-			if (prealloc)
+			if (prealloc) {
 				printf("Not built with preallocation support\n");
-			usage();
+				usage();
+			}
 #endif
 			break;
 		case 'q':

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
