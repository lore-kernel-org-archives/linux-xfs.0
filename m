Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m177199.ym.163.com ([123.58.177.199]:23388 "EHLO
        m177199.ym.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbeBXLaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 06:30:10 -0500
From: Yang Joseph <joseph.yang@xtaotech.com>
Subject: xfs_repair: add '-F' option to ignore writable mount checking
Message-ID: <5A914B45.8080200@xtaotech.com>
Date: Sat, 24 Feb 2018 19:23:49 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, nathans@debian.org
Cc: linux-xfs@vger.kernel.org

hello,

Before the repair process, xfs_repair will check if user specified 
device already
has a writable mountpoint. And it will stat all the mountpoints of the 
system. If there
is a dead mountpoint, this checking will be blocked and xfs_repair will 
enter 'D' state.

So, if user can make sure there is no writable mountpoint, xfs_repair 
can skip
this checking. This PR add a new option '-F' to do this job.

Your suggestions are appreciated!

Yang Honggang

---------------- patch begin --------------------

diff --git a/include/libxfs.h b/include/libxfs.h
index c5fb396..9d5d3ee 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -112,6 +112,8 @@ typedef struct libxfs_xinit {
         int             rcreat;         /* try to create realtime 
subvolume */
         int             setblksize;     /* attempt to set device blksize */
         int             usebuflock;     /* lock xfs_buf_t's - for MT 
usage */
+       int             force_repair; /* ignore writable mount checking */
+
                                 /* output results */
         dev_t           ddev;           /* device for data subvolume */
         dev_t           logdev;         /* device for log subvolume */
diff --git a/libxfs/init.c b/libxfs/init.c
index 7bde8b7..8c0b418 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -199,7 +199,8 @@ libxfs_device_close(dev_t dev)
  }

  static int
-check_open(char *path, int flags, char **rawfile, char **blockfile)
+check_open(char *path, int flags, char **rawfile, char **blockfile,
+    int force_repair)
  {
         int readonly = (flags & LIBXFS_ISREADONLY);
         int inactive = (flags & LIBXFS_ISINACTIVE);
@@ -225,7 +226,8 @@ check_open(char *path, int flags, char **rawfile, 
char **blockfile)
         if (!readonly && !inactive && platform_check_ismounted(path, 
*blockfile, NULL, 1))
                 return 0;

-       if (inactive && check_isactive(path, *blockfile, 
((readonly|dangerously)?1:0)))
+       if (inactive && !force_repair && check_isactive(path, *blockfile,
+            ((readonly|dangerously)?1:0)))
                 return 0;

         return 1;
@@ -270,7 +272,7 @@ libxfs_init(libxfs_init_t *a)
         radix_tree_init();

         if (a->volname) {
- if(!check_open(a->volname,flags,&rawfile,&blockfile))
+               if(!check_open(a->volname, flags, &rawfile, &blockfile, 
a->force_repair))
                         goto done;
                 fd = open(rawfile, O_RDONLY);
                 dname = a->dname = a->volname;
@@ -284,7 +286,7 @@ libxfs_init(libxfs_init_t *a)
                         platform_findsizes(dname, a->dfd, &a->dsize,
                                            &a->dbsize);
                 } else {
-                       if (!check_open(dname, flags, &rawfile, &blockfile))
+                       if (!check_open(dname, flags, &rawfile, 
&blockfile, a->force_repair))
                                 goto done;
                         a->ddev = libxfs_device_open(rawfile,
                                         a->dcreat, flags, a->setblksize);
@@ -302,7 +304,7 @@ libxfs_init(libxfs_init_t *a)
                         platform_findsizes(dname, a->logfd, &a->logBBsize,
                                            &a->lbsize);
                 } else {
-                       if (!check_open(logname, flags, &rawfile, 
&blockfile))
+                       if (!check_open(logname, flags, &rawfile, 
&blockfile, a->force_repair))
                                 goto done;
                         a->logdev = libxfs_device_open(rawfile,
                                         a->lcreat, flags, a->setblksize);
@@ -320,7 +322,7 @@ libxfs_init(libxfs_init_t *a)
                         platform_findsizes(dname, a->rtfd, &a->rtsize,
                                            &a->rtbsize);
                 } else {
-                       if (!check_open(rtname, flags, &rawfile, 
&blockfile))
+                       if (!check_open(rtname, flags, &rawfile, 
&blockfile, a->force_repair))
                                 goto done;
                         a->rtdev = libxfs_device_open(rawfile,
                                         a->rcreat, flags, a->setblksize);
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 85e4dc9..78e1125 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -4,7 +4,7 @@ xfs_repair \- repair an XFS filesystem
  .SH SYNOPSIS
  .B xfs_repair
  [
-.B \-dfLnPv
+.B \-dfLnPvF
  ] [
  .B \-m
  .I maxmem
@@ -162,6 +162,9 @@ ag_stride is enabled.
  .B \-v
  Verbose output.  May be specified multiple times to increase verbosity.
  .TP
+.B \-F
+Force to repair, ignore writable mount checking.
+.TP
  .B \-d
  Repair dangerously. Allow
  .B xfs_repair
diff --git a/repair/globals.h b/repair/globals.h
index c7bbe6f..085ea0f 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -104,6 +104,7 @@ EXTERN char *rt_name;               /* Name of 
realtime device */
  EXTERN int     rt_spec;                /* Realtime dev specified as 
option */
  EXTERN int     convert_lazy_count;     /* Convert lazy-count mode 
on/off */
  EXTERN int     lazy_count;             /* What to set if to if 
converting */
+EXTERN int     force_repair;           /* ignore writable mount checking */

  /* misc status variables */

diff --git a/repair/init.c b/repair/init.c
index 609229c..a3b4539 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -90,6 +90,8 @@ xfs_init(libxfs_init_t *args)
         args->usebuflock = do_prefetch;
         args->setblksize = 0;
         args->isdirect = LIBXFS_DIRECT;
+       args->force_repair = force_repair;
+
         if (no_modify)
                 args->isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);
         else if (dangerously)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b2dd91b..81864c3 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -97,6 +97,7 @@ usage(void)
  "  -o subopts   Override default behaviour, refer to man page.\n"
  "  -t interval  Reporting interval in seconds.\n"
  "  -d           Repair dangerously.\n"
+"  -F           Force to repair, ignore writable mount checking.\n"
  "  -V           Reports version and exits.\n"), progname);
         exit(1);
  }
@@ -214,12 +215,13 @@ process_args(int argc, char **argv)
         ag_stride = 0;
         thread_count = 1;
         report_interval = PROG_RPT_DEFAULT;
+       force_repair = 0;

         /*
          * XXX have to add suboption processing here
          * attributes, quotas, nlinks, aligned_inos, sb_fbits
          */
-       while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPt:")) != EOF)  {
+       while ((c = getopt(argc, argv, "c:o:fl:m:r:LnDvVdPt:F")) != EOF)  {
                 switch (c) {
                 case 'D':
                         dumpcore = 1;
@@ -329,6 +331,9 @@ process_args(int argc, char **argv)
                 case 't':
                         report_interval = (int)strtol(optarg, NULL, 0);
                         break;
+               case 'F':
+                       force_repair = 1;
+                       break;
                 case '?':
                         usage();
                 }
---------------- patch end ----------------
