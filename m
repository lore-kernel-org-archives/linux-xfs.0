Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 02:20:56 -0700 (PDT)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l839Ko4p011542
	for <xfs@oss.sgi.com>; Mon, 3 Sep 2007 02:20:51 -0700
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id 96955E7BD
	for <xfs@oss.sgi.com>; Mon,  3 Sep 2007 11:20:51 +0200 (CEST)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 24959-04 for <xfs@oss.sgi.com>; Mon,  3 Sep 2007 11:20:40 +0200 (CEST)
Received: from [192.168.51.2] (lw-pc002.intra.frontsite.de [192.168.51.2])
	by mail.pawisda.de (Postfix) with ESMTP id 29277BE7E
	for <xfs@oss.sgi.com>; Mon,  3 Sep 2007 11:20:40 +0200 (CEST)
Message-ID: <46DBD1E7.4030701@linworks.de>
Date: Mon, 03 Sep 2007 11:20:39 +0200
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: Re: [PATCH] Implement ioctl to mark AGs as "don't use/use"
References: <1182939325.5313.12.camel@localhost> <20070628045049.GF989688@sgi.com> <46838CAE.9030808@linworks.de> <20070629005417.GF31489@sgi.com>
In-Reply-To: <20070629005417.GF31489@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------020905060609070803010108"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020905060609070803010108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

David Chinner wrote:
> OOC, do you have any test code for this? xfs_io would be the tool to
> teach this ioctl to....
>   
I've implemented this on xfs_io, and tested, and it works :)

Attached are the modifications needed to the xfsprogs source tree in form of a diff against the CVS tree.

In a short time all the patches that I submitted will be available together under an url, so that they are not scattered across the mailing list.

-- 
Rubén Porras
LinWorks GmbH


--------------020905060609070803010108
Content-Type: text/x-patch;
 name="xfsprogs.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfsprogs.diff"

diff -rNu xfs-cmds/xfsprogs/include/xfs_ag.h /home/ldap/campo/xfs-cmds/xfsprogs/include/xfs_ag.h
--- xfs-cmds/xfsprogs/include/xfs_ag.h	2007-05-22 17:59:41.000000000 +0200
+++ /home/ldap/campo/xfs-cmds/xfsprogs/include/xfs_ag.h	2007-08-31 14:08:51.975160695 +0200
@@ -69,6 +69,7 @@
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	__be32		agf_flags;	/* persistent AG state flags */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -83,7 +84,8 @@
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_NUM_BITS	12
+#define	XFS_AGF_FLAGS		0x00001000
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 /* disk block (xfs_daddr_t) in the AG */
@@ -196,8 +198,17 @@
 	lock_t		pagb_lock;	/* lock for pagb_list */
 #endif
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+   	__u32		 pagf_flags;	/* persistent AG state flags */
 } xfs_perag_t;
 
+typedef struct xfs_ioc_agflags
+{
+	xfs_agnumber_t	ag;
+	__u32		flags;
+} xfs_ioc_agflags_t;
+
+#define XFS_AGF_FLAGS_ALLOC_DENY	(1<<0)
+
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
 #define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
 	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
diff -rNu xfs-cmds/xfsprogs/include/xfs_fs.h /home/ldap/campo/xfs-cmds/xfsprogs/include/xfs_fs.h
--- xfs-cmds/xfsprogs/include/xfs_fs.h	2007-06-28 18:00:13.000000000 +0200
+++ /home/ldap/campo/xfs-cmds/xfsprogs/include/xfs_fs.h	2007-08-31 15:19:21.107148402 +0200
@@ -499,6 +499,8 @@
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GET_AGF_FLAGS	     _IOWR('X', 126, struct xfs_ioc_agflags)
+#define XFS_IOC_SET_AGF_FLAGS	     _IOW ('X', 127, struct xfs_ioc_agflags)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff -rNu xfs-cmds/xfsprogs/io/agflags.c /home/ldap/campo/xfs-cmds/xfsprogs/io/agflags.c
--- xfs-cmds/xfsprogs/io/agflags.c	1970-01-01 01:00:00.000000000 +0100
+++ /home/ldap/campo/xfs-cmds/xfsprogs/io/agflags.c	2007-08-31 13:56:48.861921728 +0200
@@ -0,0 +1,126 @@
+ /*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include <xfs/xfs_types.h>
+#include <xfs/xfs_inum.h>
+#include <xfs/xfs_ag.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t agflags_cmd;
+
+static void
+agflags_help(void)
+{
+	printf(_(
+"\n"
+" get or set the diferent flags of a given AG\n"
+"\n"
+" Example:\n"
+" 'agflags -d 0 -a 10' - unset the flag XFS_AGF_FLAGS_ALLOC_DENY from the AG\n"
+" number 10\n"
+"\n"));
+}
+
+int
+agflags_valid_ag(
+		 int ag)
+{
+  xfs_fsop_geom_t fsgeo;
+
+  if (ag < 0) 
+	  return 0;
+
+  if (xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY, &fsgeo) < 0) {
+	  fprintf(stderr, _("%s: cannot get geometry of fs: %s\n"),
+		  progname, strerror(errno));
+	  exitcode = 1;
+	  return 0;
+  }
+  
+  return (ag <= fsgeo.agcount);
+}
+
+int
+agflags_f(
+	  int		argc,
+	  char		**argv)
+{
+	xfs_ioc_agflags_t	ioc_flags;
+	unsigned int		dflag;
+	int			opt;
+	int			set = 0;
+
+	while ((opt = getopt(argc, argv, "d:a:")) != -1) {
+		switch (opt) {
+		case 'a': /* AG number. */
+			ioc_flags.ag = atoi(optarg);
+			break;
+		case 'd': /* (Un)set XFS_AGF_FLAGS_ALLOC_DENY */
+			dflag = atoi(optarg);
+                        if (dflag != 0 && dflag != 1)
+                                return command_usage(&agflags_cmd);
+			set = 1;
+			break;
+		default: /* ? */
+			return command_usage(&agflags_cmd);
+		}
+	}
+
+        if (! agflags_valid_ag(ioc_flags.ag)) {
+                fprintf(stderr, _("%s: AG number %d is not valid\n"),
+                        progname, ioc_flags.ag);
+                return 0;
+        }
+
+        if (set)
+                ioc_flags.flags = dflag;
+
+        int ioctl;
+	ioctl = set ? XFS_IOC_SET_AGF_FLAGS : XFS_IOC_GET_AGF_FLAGS;
+
+	if (xfsctl(file->name, file->fd, ioctl, &ioc_flags) < 0) {
+		fprintf(stderr,
+			_("%s: cannot %s flags %d on ag %d at %s: %s\n"),
+			progname, set ? "get" : "set", ioc_flags.flags,
+			ioc_flags.ag, file->name, strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	return 0;
+}
+
+void
+agflags_init(void)
+{
+	agflags_cmd.name    = _("agflags");
+	agflags_cmd.cfunc   = agflags_f;
+	agflags_cmd.argmin  = 2;
+	agflags_cmd.argmax  = 4;
+	agflags_cmd.flags   = CMD_NOMAP_OK;
+	agflags_cmd.args    = _("[-d 0|1] -a agno");
+	agflags_cmd.oneline = _("Get or set the flags of an AG");
+	agflags_cmd.help    = agflags_help;
+
+	if (expert)
+		add_command(&agflags_cmd);
+}
diff -rNu xfs-cmds/xfsprogs/io/init.c /home/ldap/campo/xfs-cmds/xfsprogs/io/init.c
--- xfs-cmds/xfsprogs/io/init.c	2007-07-24 18:07:17.000000000 +0200
+++ /home/ldap/campo/xfs-cmds/xfsprogs/io/init.c	2007-08-31 14:10:19.697443490 +0200
@@ -54,6 +54,7 @@
 static void
 init_commands(void)
 {
+	agflags_init();
 	attr_init();
 	bmap_init();
 	fadvise_init();
diff -rNu xfs-cmds/xfsprogs/io/Makefile /home/ldap/campo/xfs-cmds/xfsprogs/io/Makefile
--- xfs-cmds/xfsprogs/io/Makefile	2006-06-17 08:12:23.000000000 +0200
+++ /home/ldap/campo/xfs-cmds/xfsprogs/io/Makefile	2007-08-13 10:42:08.536364577 +0200
@@ -10,7 +10,8 @@
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c mmap.c \
-	open.c parent.c pread.c prealloc.c pwrite.c shutdown.c truncate.c
+	open.c parent.c pread.c prealloc.c pwrite.c shutdown.c truncate.c \
+	agflags.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff -rNu xfs-cmds/xfsprogs/man/man8/xfs_io.8 /home/ldap/campo/xfs-cmds/xfsprogs/man/man8/xfs_io.8
--- xfs-cmds/xfsprogs/man/man8/xfs_io.8	2007-07-27 17:49:00.000000000 +0200
+++ /home/ldap/campo/xfs-cmds/xfsprogs/man/man8/xfs_io.8	2007-08-31 14:05:51.175595207 +0200
@@ -524,6 +524,15 @@
 .IP
 .B [NOTE: Not currently operational on Linux.]
 .PD
+.TP
+.BR agflags " [ \-d " 0|1 " ] \-a " agno
+This command get or set the different flags of the given AG. In moment the
+only modifiable flag is XFS_AGF_FLAGS_ALLOC_DENY.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-d 
+0 or 1 to (un)set XFS_AGF_FLAGS_ALLOC_DENY.
 
 .SH SEE ALSO
 .BR mkfs.xfs (8),

--------------020905060609070803010108--
