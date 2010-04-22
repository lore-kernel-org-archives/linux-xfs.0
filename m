Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGiW89216144 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:44:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B3E74DA439
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:46:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6H8gXHFw44NL92U9 for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:46:32 -0700 (PDT)
Date: Thu, 22 Apr 2010 12:46:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: different error messages for mkfs.xfs -ssize
Message-ID: <20100422164632.GA25662@infradead.org>
References: <20100422153636.GB3822@laptop.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422153636.GB3822@laptop.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On Thu, Apr 22, 2010 at 11:36:36PM +0800, Wengang Wang wrote:
> Hi experts,
> 
> I got different error messages when provide different value for -ssize.
> Why the error messages are different? They are different but no one is
> containing more info than the other.
> 
> [root@desk test-xfsprogs]# mkfs.xfs -ssize=256 /dev/sda10 -f 2>&1 |head -n 1
> illegal sector size 256
> [root@desk test-xfsprogs]# mkfs.xfs -ssize=3072 /dev/sda10 -f 2>&1 |head -n 1
> Illegal value 3072 for -s sectsize option

It's because we have an early test that just tests for the value beeing
negative or not a power of two, and a later one that checks for the
exact range.  The untested patch below cleans this up a bit, but once
I get started on this I might do an even bigger sweep on the mkfs
option parsing and error handling..

Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-04-22 18:32:16.708004506 +0200
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-04-22 18:36:49.217255590 +0200
@@ -1540,8 +1540,6 @@ main(
 						conflict('s', sopts, S_SECTSIZE,
 							 S_SECTLOG);
 					sectorlog = atoi(value);
-					if (sectorlog <= 0)
-						illegal(value, "s sectlog");
 					lsectorlog = sectorlog;
 					sectorsize = 1 << sectorlog;
 					lsectorsize = sectorsize;
@@ -1558,9 +1556,6 @@ main(
 							 S_SECTSIZE);
 					sectorsize = cvtnum(
 						blocksize, sectorsize, value);
-					if (sectorsize <= 0 ||
-					    !ispow2(sectorsize))
-						illegal(value, "s sectsize");
 					lsectorsize = sectorsize;
 					sectorlog =
 						libxfs_highbit32(sectorsize);
@@ -1637,7 +1632,9 @@ main(
 	}
 
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
-	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
+	    sectorsize > XFS_MAX_SECTORSIZE ||
+	    sectorsize > blocksize ||
+	    !ispow2(sectorsize)) {
 		fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
 		usage();
 	}
@@ -1647,7 +1644,9 @@ main(
 		usage();
 	}
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
+	    lsectorsize > XFS_MAX_SECTORSIZE ||
+	    lsectorsize > blocksize ||
+	    !ispow2(lsectorsize)) {
 		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
 		usage();
 	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
