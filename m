Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 16:46:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0G0keqw019016
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 16:46:42 -0800
Received: from pcbnaujok (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA21869 for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 11:45:46 +1100
Message-Id: <200701160045.LAA21869@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: FW: REVIEW: 031 QA failure with xfs_repair
Date: Tue, 16 Jan 2007 11:51:06 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 
QA 030 and 031 are failing with xfs_repair as the "zeroed log" is
different 
on IRIX and Linux.

xfs_repair must be coded to handle the different platform log 
formats.

==========================

Need a review please:

383 -> p_rdiff -um libxfs libxlog

========================================================================
===
xfsprogs/libxfs/darwin.c
========================================================================
===

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/darwin.c_1.12     Mon Jan
15 17:30:37 2007
+++ xfsprogs/libxfs/darwin.c    Mon Jan 15 16:53:25 2007
@@ -22,6 +22,7 @@
 #include <sys/ioctl.h>
 #include <xfs/libxfs.h>

+int platform_has_uuid = 0;
 extern char *progname;

 int

========================================================================
===
xfsprogs/libxfs/freebsd.c
========================================================================
===

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/freebsd.c_1.15    Mon Jan
15 17:30:37 2007
+++ xfsprogs/libxfs/freebsd.c   Mon Jan 15 16:53:35 2007
@@ -22,6 +22,7 @@
 #include <sys/mount.h>
 #include <sys/ioctl.h>

+int platform_has_uuid = 0;
 extern char *progname;

 int

========================================================================
===
xfsprogs/libxfs/init.h
========================================================================
===

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/init.h_1.12       Mon Jan
15 17:30:37 2007
+++ xfsprogs/libxfs/init.h      Mon Jan 15 16:52:09 2007
@@ -34,5 +34,6 @@
 extern int platform_align_blockdev (void);
 extern int platform_aio_init (int aio_count);
 extern int platform_nproc(void);
+extern int platform_has_uuid;

 #endif /* LIBXFS_INIT_H */

========================================================================
===
xfsprogs/libxfs/irix.c
========================================================================
===

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/irix.c_1.13       Mon Jan
15 17:30:37 2007
+++ xfsprogs/libxfs/irix.c      Mon Jan 15 16:53:49 2007
@@ -21,6 +21,7 @@
 #include <diskinfo.h>
 #include <sys/sysmp.h>

+int platform_has_uuid = 0;
 extern char *progname;
 extern __int64_t findsize(char *);


========================================================================
===
xfsprogs/libxfs/linux.c
========================================================================
===

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/linux.c_1.16      Mon Jan
15 17:30:37 2007
+++ xfsprogs/libxfs/linux.c     Mon Jan 15 16:53:10 2007
@@ -26,6 +26,7 @@
 #include <sys/mount.h>
 #include <sys/ioctl.h>

+int platform_has_uuid = 1;
 extern char *progname;
 static int max_block_alignment;


========================================================================
===
xfsprogs/libxlog/xfs_log_recover.c
========================================================================
===

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxlog/xfs_log_recover.c_1.30
Mon Jan 15 17:30:37 2007
+++ xfsprogs/libxlog/xfs_log_recover.c  Mon Jan 15 16:54:50 2007
@@ -258,6 +258,7 @@
        uint            first_half_cycle, last_half_cycle;
        uint            stop_on_cycle;
        int             error, log_bbnum = log->l_logBBsize;
+       extern int      platform_has_uuid;

        /* Is the end of the log device zeroed? */
        if ((error = xlog_find_zeroed(log, &first_blk)) == -1) {
@@ -264,7 +265,7 @@
                *return_head_blk = first_blk;

                /* Is the whole lot zeroed? */
-               if (!first_blk) {
+               if (!first_blk && platform_has_uuid) {
                        /* Linux XFS shouldn't generate totally zeroed
logs -
                         * mkfs etc write a dummy unmount record to a
fresh
                         * log so we can store the uuid in there
