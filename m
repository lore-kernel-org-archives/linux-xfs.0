Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0OEkfGD018063 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 08:46:42 -0600
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A324E1BA9B51
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 06:45:58 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com
	with ESMTP id lS0hd5EdCEGq1qIA for <xfs@oss.sgi.com>;
	Sat, 24 Jan 2009 06:45:58 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id
	n0OEdcIF031843
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 15:39:38 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id n0OEdcEu031841
	for xfs@oss.sgi.com; Sat, 24 Jan 2009 15:39:38 +0100
Date: Sat, 24 Jan 2009 15:39:38 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs_io: fix comment in bmap.c
Message-ID: <20090124143938.GA31680@lst.de>
Mime-Version: 1.0
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

Based on a patch from Tomasz Majkowski <moosh009@gmail.com> in bugzilla
#785.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/io/bmap.c
===================================================================
--- xfsprogs-dev.orig/io/bmap.c	2009-01-24 15:36:56.780113315 +0100
+++ xfsprogs-dev/io/bmap.c	2009-01-24 15:37:17.875168142 +0100
@@ -140,7 +140,7 @@ bmap_f(
 		}
 	}
 
-	map_size = nflag ? nflag+2 : 32;	/* initial guess - 256 */
+	map_size = nflag ? nflag+2 : 32;	/* initial guess - 32 */
 	map = malloc(map_size*sizeof(*map));
 	if (map == NULL) {
 		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
@@ -151,7 +151,7 @@ bmap_f(
 
 
 /*	Try the xfsctl(XFS_IOC_GETBMAPX) for the number of extents specified
- *	by nflag, or the initial guess number of extents (256).
+ *	by nflag, or the initial guess number of extents (32).
  *
  *	If there are more extents than we guessed, use xfsctl
  *	(XFS_IOC_FSGETXATTR[A]) to get the extent count, realloc some more

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
