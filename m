Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 May 2007 19:45:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4H2jIfB026826
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 19:45:21 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA03426; Thu, 17 May 2007 12:24:14 +1000
Message-ID: <464BBCCE.8080500@sgi.com>
Date: Thu, 17 May 2007 12:24:14 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: XFSQA: unwritten extent conversion vs synchronous direct
 I/O
References: <20070508065327.GL32602149@melbourne.sgi.com>
In-Reply-To: <20070508065327.GL32602149@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Test to exercise synchronous direct I/O into unwritten extents.
> 
> Cheers,
> 
> Dave.

Would we ever want to adjust the IO_SIZE used in unwritten_sync
from the qa script?

A couple of small changes to fix compiler warnings and provide
info on dio size errors.

Otherwise looks good,
Don


  Index: xfs-cmds/xfstests/src/unwritten_sync.c
  ===================================================================
  --- /dev/null  1970-01-01 00:00:00.000000000 +0000
-+++ xfs-cmds/xfstests/src/unwritten_sync.c     2007-05-07 11:44:38.668980258 +1000
-@@ -0,0 +1,167 @@
++++ xfs-cmds/xfstests/src/unwritten_sync.c     2007-05-17 12:08:21.242781793 +1000
+@@ -0,0 +1,153 @@
  +#include <sys/types.h>
  +#include <fcntl.h>
  +#include <errno.h>
@@ -139,7 +139,9 @@
  +              }
  +
  +              if ((dio.d_miniosz > IO_SIZE) || (dio.d_maxiosz < IO_SIZE)) {
-+                      fprintf(stderr,"Test won't work. Sorry\n");
++                      fprintf(stderr,"Test won't work, iosize out of range \
++                              (dio.d_miniosz=%d, dio.d_maxiosz=%d)\n",
++                              dio.d_miniosz, dio.d_maxiosz);
  +                      exit(1);
  +              }
  +              buf = (char *)memalign(dio.d_mem , IO_SIZE);
@@ -174,23 +176,7 @@
  +              print_getbmapx(file, fd, 0, 0);
  +              close(fd);
  +      }
-+}
-+
-+
-+
-+int
-+get_getbmapx(
-+      const char      *pathname,
-+      int             fd,
-+      struct getbmapx *bmapx)
-+{
-+      int     rc;
-+
-+      rc = ioctl(fd, XFS_IOC_GETBMAPX, bmapx);
-+      if (rc < 0) {
-+              perror("xfs_ioc_getbmapx");
-+              exit(1);
-+      }
++      return 0;
  +}
  +
  +void
@@ -223,8 +209,8 @@
  +                      if (x != array_size) {
  +                              break;  /* end of file */
  +                      }
-+                      if (get_getbmapx(pathname, fd, bmapx) < 0) {
-+                              fprintf(stderr, "getbmapx failed\n");
++                      if (xfsctl(pathname, fd, XFS_IOC_GETBMAPX, bmapx) < 0) {
++                              fprintf(stderr, "XFS_IOC_GETBMAPX failed\n");
  +                              exit(1);
  +                      }
  +                      if (bmapx[0].bmv_entries == 0) {
