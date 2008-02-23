Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Feb 2008 01:47:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1N9l7C3016924
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 01:47:08 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7108C60C2D0
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 01:47:32 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156]) by cuda.sgi.com with ESMTP id e5tdoLX8aeC31q7P for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 01:47:32 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so518528fga.8
        for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 01:47:31 -0800 (PST)
Message-ID: <47BFEA2E.5010408@gmail.com>
Date: Sat, 23 Feb 2008 11:41:02 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
References: <47B5DD9C.3080906@gmail.com> <47BE6C5C.2000605@sgi.com> <47BE8EE8.5020005@gmail.com> <47BEA1E7.3010107@gmail.com> <20080223000612.GE155259@sgi.com>
In-Reply-To: <20080223000612.GE155259@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------000504010209060101080001"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: lachlan@sgi.com, Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000504010209060101080001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

David Chinner wrote:
> Note the xfs_getsb() call in there - that's what the lazy-count option
> avoids. That's waiting in the transaction subsystem to apply delta's
> to the superblock that is currently locked.
>   

After enabling lazy-count the max latency is 223 msec, average is 19 msec.

1 0 0 add_wait_queue __pollwait datagram_poll do_select __pollwait
default_wake_function __make_request __make_request __mark_inode_dirty
find_busiest_group __set_page_dirty mark_buffer_dirty
2 0 0 add_wait_queue __pollwait datagram_poll do_select __pollwait
default_wake_function read_hpet getnstimeofday ktime_get_ts ktime_get
__mark_inode_dirty __set_page_dirty
28 563051 223732 _xfs_buf_ioapply default_wake_function
xlog_state_get_iclog_space xlog_state_release_iclog xlog_write
xfs_log_write _xfs_trans_commit __mark_inode_dirty igrab xfs_create
xfs_vn_mknod security_inode_permission
1 7716 7716 xfs_buf_get_flags default_wake_function
xlog_state_get_iclog_space xlog_write __mark_inode_dirty kmem_free
xfs_log_write _xfs_trans_commit igrab xfs_create xfs_vn_mknod
security_inode_permission

My "testcase" to reproduce this is:
I have an SVN checkout from here:
http://llvm.org/svn/llvm-project/llvm-gcc-4.2/trunk
I do:
# echo 3 >/proc/sys/vm/drop_caches
$ svn up
$ svn up; svn up; svn up; svn up;
^^^^^the latency shows up here

svn is version 1.4.6
$ mount|grep sda6
/dev/sda6 on / type xfs (rw, noatime, nodiratime, logbufs=8, logbsize=256k)

> Converting to a lazy-count filesystem is experimental right now;
>   

I got a build failure, and when I solved that a segmentation fault.
Luckily it didn't start modifying the partition when that happened, it
was during command-line argument parsing.
When I fixed that it went fine, some files got linked to lost+found,
thats all.

[See log at end of email.]

> http://oss.sgi.com/archives/xfs/2008-02/msg00295.html
>   

Am I the first to test that patch?
Attached the fixed patch I used (renamed 'sbp' to 'sb', and use &val
instead of *val for getsubopt):

Here's the output of xfs_repair, and xfs_info (/dev/sda6 is my / for
Debian, so I've run xfs_repair from Fedora installed on same laptop).

[root@localhost repair]# ./xfs_repair -c lazycount=1 /dev/sda6
Phase 1 - find and verify superblock...
        - Enabling lazy-counters
writing modified primary superblock
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
error following ag 4 unlinked list
error following ag 9 unlinked list
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
b5eb2b90: Badness in key lookup (length)
bp=(bno 3666392, len 16384 bytes) key=(bno 3666392, len 8192 bytes)
        - agno = 3
b54b1b90: Badness in key lookup (length)
bp=(bno 4884000, len 16384 bytes) key=(bno 4884000, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4885232, len 16384 bytes) key=(bno 4885232, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4892544, len 16384 bytes) key=(bno 4892544, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4894976, len 16384 bytes) key=(bno 4894976, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4897280, len 16384 bytes) key=(bno 4897280, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4897328, len 16384 bytes) key=(bno 4897328, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4897440, len 16384 bytes) key=(bno 4897440, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4901504, len 16384 bytes) key=(bno 4901504, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 4913008, len 16384 bytes) key=(bno 4913008, len 8192 bytes)
        - agno = 4
b28ffb90: Badness in key lookup (length)
bp=(bno 6155128, len 16384 bytes) key=(bno 6155128, len 8192 bytes)
        - agno = 5
        - agno = 6
        - agno = 7
b28ffb90: Badness in key lookup (length)
bp=(bno 9788032, len 16384 bytes) key=(bno 9788032, len 8192 bytes)
        - agno = 8
b54b1b90: Badness in key lookup (length)
bp=(bno 10988488, len 16384 bytes) key=(bno 10988488, len 8192 bytes)
        - agno = 9
b54b1b90: Badness in key lookup (length)
bp=(bno 10988632, len 16384 bytes) key=(bno 10988632, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 10991688, len 16384 bytes) key=(bno 10991688, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 11004840, len 16384 bytes) key=(bno 11004840, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 11024648, len 16384 bytes) key=(bno 11024648, len 8192 bytes)
b54b1b90: Badness in key lookup (length)
bp=(bno 11163416, len 16384 bytes) key=(bno 11163416, len 8192 bytes)
        - agno = 10
b28ffb90: Badness in key lookup (length)
bp=(bno 13436152, len 16384 bytes) key=(bno 13436152, len 8192 bytes)
        - agno = 11
        - agno = 12
        - agno = 13
b3fffb90: Badness in key lookup (length)
bp=(bno 15895144, len 16384 bytes) key=(bno 15895144, len 8192 bytes)
b28ffb90: Badness in key lookup (length)
bp=(bno 17122320, len 16384 bytes) key=(bno 17122320, len 8192 bytes)
        - agno = 14
        - agno = 15
b54b1b90: Badness in key lookup (length)
bp=(bno 19270440, len 16384 bytes) key=(bno 19270440, len 8192 bytes)
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 12590082, moving to lost+found
disconnected inode 16777746, moving to lost+found
disconnected inode 16777747, moving to lost+found
disconnected inode 16780239, moving to lost+found
disconnected inode 16794857, moving to lost+found
disconnected inode 16794858, moving to lost+found
disconnected inode 16799733, moving to lost+found
disconnected inode 16799736, moving to lost+found
disconnected dir inode 16804337, moving to lost+found
disconnected inode 16804339, moving to lost+found
disconnected inode 16804430, moving to lost+found
disconnected inode 16804657, moving to lost+found
disconnected inode 16804660, moving to lost+found
disconnected inode 16812738, moving to lost+found
disconnected inode 16835764, moving to lost+found
disconnected inode 16835765, moving to lost+found
disconnected inode 16835766, moving to lost+found
disconnected inode 16835767, moving to lost+found
disconnected dir inode 21072429, moving to lost+found
disconnected inode 33595557, moving to lost+found
disconnected inode 37748903, moving to lost+found
disconnected inode 37748913, moving to lost+found
disconnected inode 37749200, moving to lost+found
disconnected inode 37749210, moving to lost+found
disconnected inode 37749214, moving to lost+found
disconnected inode 37755288, moving to lost+found
disconnected inode 37781598, moving to lost+found
disconnected inode 37781599, moving to lost+found
disconnected inode 37781600, moving to lost+found
disconnected inode 37781601, moving to lost+found
disconnected inode 37821186, moving to lost+found
disconnected inode 37821190, moving to lost+found
disconnected inode 38098758, moving to lost+found
disconnected inode 38098759, moving to lost+found
disconnected inode 38098760, moving to lost+found
disconnected inode 38098762, moving to lost+found
disconnected dir inode 46149094, moving to lost+found
disconnected dir inode 54571931, moving to lost+found
disconnected inode 54571932, moving to lost+found
disconnected inode 54571935, moving to lost+found
disconnected inode 54571936, moving to lost+found
disconnected inode 54571938, moving to lost+found
disconnected inode 58778689, moving to lost+found
disconnected inode 58778691, moving to lost+found
disconnected inode 58778692, moving to lost+found
disconnected inode 58778693, moving to lost+found
disconnected inode 64827392, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 12590082 nlinks from 0 to 2
resetting inode 16804337 nlinks from 0 to 2
resetting inode 21072429 nlinks from 0 to 2
resetting inode 46149094 nlinks from 0 to 2
resetting inode 54571931 nlinks from 0 to 2
done

# xfs_info /dev/sda6
meta-data=/dev/sda6              isize=256    agcount=16, agsize=152617 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2441872, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096 
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0



Best regards,
--Edwin

--------------000504010209060101080001
Content-Type: text/x-diff;
 name="xfs_repair_working.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_repair_working.patch"

Index: globals.h
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/repair/globals.h,v
retrieving revision 1.21
diff -u -r1.21 globals.h
--- globals.h	16 Jul 2007 15:55:26 -0000	1.21
+++ globals.h	23 Feb 2008 09:09:40 -0000
@@ -116,6 +116,8 @@
 EXTERN int	log_spec;		/* Log dev specified as option */
 EXTERN char	*rt_name;		/* Name of realtime device */
 EXTERN int	rt_spec;		/* Realtime dev specified as option */
+EXTERN int	convert_lazy_count;	/* Convert lazy-count mode on/off */
+EXTERN int	lazy_count;		/* What to set if to if converting */
 
 /* misc status variables */
 
Index: phase1.c
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/repair/phase1.c,v
retrieving revision 1.11
diff -u -r1.11 phase1.c
--- phase1.c	16 Jul 2007 15:53:42 -0000	1.11
+++ phase1.c	23 Feb 2008 09:09:40 -0000
@@ -91,6 +91,26 @@
 		primary_sb_modified = 1;
 	}
 
+	/*
+	 * apply any version changes or conversions after the primary
+	 * superblock has been verified or repaired
+	 */
+	if (convert_lazy_count) {
+		if (lazy_count && !xfs_sb_version_haslazysbcount(sb)) {
+			sb->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+			sb->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			primary_sb_modified = 1;
+			do_log(_("        - Enabling lazy-counters\n"));
+		} else
+		if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
+			sb->sb_features2 &= ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			do_log(_("        - Disabling lazy-counters\n"));
+			primary_sb_modified = 1;
+		} else
+			do_log(_("        - Lazy-counters are already %s\n"),
+				lazy_count ? _("enabled") : _("disabled"));
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));
Index: xfs_repair.c
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/repair/xfs_repair.c,v
retrieving revision 1.31
diff -u -r1.31 xfs_repair.c
--- xfs_repair.c	19 Jul 2007 16:04:12 -0000	1.31
+++ xfs_repair.c	23 Feb 2008 09:09:43 -0000
@@ -47,7 +47,7 @@
  */
 
 /*
- * -o (user-supplied override options)
+ * -o: user-supplied override options
  */
 
 char *o_opts[] = {
@@ -64,15 +64,25 @@
 	NULL
 };
 
+/*
+ * -c: conversion options
+ */
+
+char *c_opts[] = {
+#define CONVERT_LAZY_COUNT	0
+	"lazycount",
+	NULL
+};
+
+
 static int	ihash_option_used;
 static int	bhash_option_used;
 
 static void
 usage(void)
 {
-	do_warn(
-_("Usage: %s [-nLvV] [-o subopt[=value]] [-l logdev] [-r rtdev] devname\n"),
-		progname);
+	do_warn(_("Usage: %s [-nLPvV] [-c subopt=value] [-o subopt[=value]] "
+		"[-l logdev] [-r rtdev] devname\n"), progname);
 	exit(1);
 }
 
@@ -191,7 +201,7 @@
 	 * XXX have to add suboption processing here
 	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
 	 */
-	while ((c = getopt(argc, argv, "o:fl:r:LnDvVdPMt:")) != EOF)  {
+	while ((c = getopt(argc, argv, "c:o:fl:r:LnDvVdPMt:")) != EOF)  {
 		switch (c) {
 		case 'D':
 			dumpcore = 1;
@@ -234,6 +244,22 @@
 				}
 			}
 			break;
+		case 'c':
+			p = optarg;
+			while (*p) {
+				char *val;
+
+				switch (getsubopt(&p, (constpp)c_opts, &val)) {
+				case CONVERT_LAZY_COUNT:
+					lazy_count = (int)strtol(val, 0, 0);
+					convert_lazy_count = 1;
+					break;
+				default:
+					unknown('c', val);
+					break;
+				}
+			}
+			break;
 		case 'l':
 			log_name = optarg;
 			log_spec = 1;

--------------000504010209060101080001--
