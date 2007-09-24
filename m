Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 02:20:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8O9KMQ3028531
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 02:20:24 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA12690 for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 19:20:25 +1000
Message-ID: <46F78159.5080907@sgi.com>
Date: Mon, 24 Sep 2007 19:20:25 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Review: fix mount flags as printed by xfsidbg
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

The xfs mount flags have recently undergone some changes.
Update the xfsidbg xmount command to print them correctly.

Don

--- 2.6.x-xfs.orig/fs/xfs/xfsidbg.c
+++ 2.6.x-xfs/fs/xfs/xfsidbg.c
@@ -6403,25 +6403,25 @@ xfsidbg_xmount(xfs_mount_t *mp)
  	static char *xmount_flags[] = {
  		"WSYNC",	/* 0x0001 */
  		"INO64",	/* 0x0002 */
-		"UNUSED_4",	/* 0x0004 */
-		"UNUSED_8",	/* 0x0008 */
+		"DMAPI",	/* 0x0004 */
+		"WAS_CLEAN",	/* 0x0008 */
  		"FSSHUTDOWN",	/* 0x0010 */
  		"NOATIME",	/* 0x0020 */
  		"RETERR",	/* 0x0040 */
  		"NOALIGN",	/* 0x0080 */
  		"ATTR2",	/* 0x0100 */
-		"UNUSED_200",	/* 0x0200 */
+		"GRPID",	/* 0x0200 */
  		"NORECOVERY",	/* 0x0400 */
  		"SHARED",	/* 0x0800 */
  		"DFLT_IOSIZE",	/* 0x1000 */
  		"OSYNCISOSYNC",	/* 0x2000 */
  		"32BITINODES",	/* 0x4000 */
-		"32BITINOOPT",	/* 0x8000 */
+		"SMALL_INUMS",	/* 0x8000 */
  		"NOUUID",	/* 0x10000 */
  		"BARRIER",	/* 0x20000 */
  		"IDELETE",	/* 0x40000 */
  		"SWALLOC",	/* 0x80000 */
-		"UNUSED_100000", /* 0x100000 */
+		"RDONLY", 	/* 0x100000 */
  		"DIRSYNC",	/* 0x200000 */
  		"COMPAT_IOSIZE",/* 0x400000 */
  		NULL
