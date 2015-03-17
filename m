Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35E227F54
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC6F68F8040
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GuWgwz4l82gdOE53 for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:18 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/13] xfs_db: add crc manipulation commands
Date: Tue, 17 Mar 2015 15:33:05 -0500
Message-Id: <1426624395-8258-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This adds a new "crc" command to xfs_db for CRC-enabled filesystems.

If a structure has a CRC field, we can validate it, invalidate/corrupt
it, or revalidate/rewrite it:

xfs_db> sb 0
xfs_db> crc -v
crc = 0x796c814f (correct)
xfs_db> crc -i
Metadata CRC error detected at block 0x0/0x200
crc = 0x796c8150 (bad)
xfs_db> crc -r
crc = 0x796c814f (correct)

(-i and -r require "expert" write-capable mode)

This requires temporarily replacing the write verifier with
a dummy which won't recalculate the CRC on the way to disk.

It also required me to write a new flist function, which is
totally foreign to me, so hopefully done right - but it seems
to work here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/Makefile       |    2 +-
 db/command.c      |    2 +
 db/crc.c          |  188 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/crc.h          |   22 ++++++
 db/flist.c        |   34 ++++++++++
 db/flist.h        |    1 +
 db/io.c           |   24 ++++++-
 db/write.h        |    2 +-
 man/man8/xfs_db.8 |   27 ++++++--
 9 files changed, 293 insertions(+), 9 deletions(-)
 create mode 100644 db/crc.c
 create mode 100644 db/crc.h

diff --git a/db/Makefile b/db/Makefile
index fb01bdd..500f94b 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h debug.h \
+	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
diff --git a/db/command.c b/db/command.c
index b7e3165..d44e0a5 100644
--- a/db/command.c
+++ b/db/command.c
@@ -48,6 +48,7 @@
 #include "write.h"
 #include "malloc.h"
 #include "dquot.h"
+#include "crc.h"
 
 cmdinfo_t	*cmdtab;
 int		ncmds;
@@ -123,6 +124,7 @@ init_commands(void)
 	bmap_init();
 	check_init();
 	convert_init();
+	crc_init();
 	debug_init();
 	echo_init();
 	frag_init();
diff --git a/db/crc.c b/db/crc.c
new file mode 100644
index 0000000..b58a594
--- /dev/null
+++ b/db/crc.c
@@ -0,0 +1,188 @@
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/libxfs.h>
+#include "addr.h"
+#include "command.h"
+#include "type.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "flist.h"
+#include "io.h"
+#include "init.h"
+#include "output.h"
+#include "bit.h"
+#include "print.h"
+
+static int crc_f(int argc, char **argv);
+static void crc_help(void);
+
+static const cmdinfo_t crc_cmd =
+	{ "crc", NULL, crc_f, 0, 1, 0, "[-i|-r|-v]",
+	  N_("manipulate crc values for V5 filesystem structures"), crc_help };
+
+void
+crc_init(void)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		add_command(&crc_cmd);
+}
+
+static void
+crc_help(void)
+{
+	dbprintf(_(
+"\n"
+" 'crc' validates, invalidates, or recalculates the crc value for\n"
+" the current on-disk metadata structures in Version 5 filesystems.\n"
+"\n"
+" Usage:  \"crc [-i|-r|-v]\"\n"
+"\n"
+));
+
+}
+
+static int
+crc_f(
+	int		argc,
+	char		**argv)
+{
+	struct xfs_buf_ops nowrite_ops;
+	const struct xfs_buf_ops *stashed_ops = NULL;
+	extern char	*progname;
+	const field_t	*fields;
+	const ftattr_t	*fa;
+	flist_t		*fl;
+	int		invalidate = 0;
+	int		recalculate = 0;
+	int		validate = 0;
+	int		c;
+
+	if (cur_typ == NULL) {
+		dbprintf(_("no current type\n"));
+		return 0;
+	}
+
+	if (cur_typ->fields == NULL) {
+		dbprintf(_("current type (%s) is not a structure\n"),
+			 cur_typ->name);
+		return 0;
+	}
+
+	if (argc) while ((c = getopt(argc, argv, "irv")) != EOF) {
+		switch (c) {
+		case 'i':
+			invalidate = 1;
+			break;
+		case 'r':
+			recalculate = 1;
+			break;
+		case 'v':
+			validate = 1;
+			break;
+		default:
+			dbprintf(_("bad option for crc command\n"));
+			return 0;
+		}
+	} else
+		validate = 1;
+
+	if (invalidate + recalculate + validate > 1) {
+		dbprintf(_("crc command accepts only one option\n"));
+		return 0;
+	}
+
+	if ((invalidate || recalculate) &&
+	    ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode)) {
+		dbprintf(_("%s not in expert mode, writing disabled\n"),
+			progname);
+		return 0;
+	}
+
+	fields = cur_typ->fields;
+
+	/* if we're a root field type, go down 1 layer to get field list */
+	if (fields->name[0] == '\0') {
+		fa = &ftattrtab[fields->ftyp];
+		ASSERT(fa->ftyp == fields->ftyp);
+		fields = fa->subfld;
+	}
+
+	/* Search for a CRC field */
+	fl = flist_find_ftyp(fields, FLDT_CRC);
+	if (!fl) {
+		dbprintf(_("No CRC field found for type %s\n"), cur_typ->name);
+		return 0;
+	}
+
+	/* run down the field list and set offsets into the data */
+	if (!flist_parse(fields, fl, iocur_top->data, 0)) {
+		flist_free(fl);
+		dbprintf(_("parsing error\n"));
+		return 0;
+	}
+
+	if (invalidate) {
+		flist_t		*sfl;
+		int		bit_length;
+		int		parentoffset;
+		int		crc;
+
+		sfl = fl;
+		parentoffset = 0;
+		while (sfl->child) {
+			parentoffset = sfl->offset;
+			sfl = sfl->child;
+		}
+		ASSERT(sfl->fld->ftyp == FLDT_CRC);
+
+		bit_length = fsize(sfl->fld, iocur_top->data, parentoffset, 0);
+		bit_length *= fcount(sfl->fld, iocur_top->data, parentoffset);
+		crc = getbitval(iocur_top->data, sfl->offset, bit_length, BVUNSIGNED);
+		/* Off by one.. */
+		crc = cpu_to_be32(crc + 1);
+		setbitval(iocur_top->data, sfl->offset, bit_length, &crc);
+
+		/* Temporarily remove write verifier to write a bad CRC */
+		stashed_ops = iocur_top->bp->b_ops;
+		nowrite_ops.verify_read = stashed_ops->verify_read;
+		nowrite_ops.verify_write = xfs_dummy_verify;
+		iocur_top->bp->b_ops = &nowrite_ops;
+	}
+
+	if (invalidate || recalculate) {
+		if (invalidate)
+			dbprintf(_("Invalidating CRC:\n"));
+		else
+			dbprintf(_("Recalculating CRC:\n"));
+
+		write_cur();
+		if (stashed_ops)
+			iocur_top->bp->b_ops = stashed_ops;
+		/* re-verify to get proper b_error state */
+		iocur_top->bp->b_ops->verify_read(iocur_top->bp);
+	} else
+		dbprintf(_("Verifying CRC:\n"));
+
+	/* And show us what we've got! */
+	flist_print(fl);
+	print_flist(fl);
+	flist_free(fl);
+	return 0;
+}
diff --git a/db/crc.h b/db/crc.h
new file mode 100644
index 0000000..9f44615
--- /dev/null
+++ b/db/crc.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+struct field;
+
+extern void	crc_init(void);
+extern void	crc_struct(const field_t *fields, int argc, char **argv);
diff --git a/db/flist.c b/db/flist.c
index 33f7da7..fa19f70 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -411,6 +411,40 @@ flist_split(
 	return v;
 }
 
+/*
+ * Given a set of fields, scan for a field of the given type.
+ * Return an flist leading to the first found field
+ * of that type.
+ * Return NULL if no field of the given type is found.
+ */
+flist_t *
+flist_find_ftyp(
+	const field_t *fields,
+	fldt_t	type)
+{
+	flist_t	*fl;
+	const field_t	*f;
+	const ftattr_t  *fa;
+
+	for (f = fields; f->name; f++) {
+		fl = flist_make(f->name);
+		fl->fld = f;
+		if (f->ftyp == type)
+			return fl;
+		fa = &ftattrtab[f->ftyp];
+		if (fa->subfld) {
+			flist_t *nfl;
+			nfl = flist_find_ftyp(fa->subfld, type);
+			if (nfl) {
+				fl->child = nfl;
+				return fl;
+			}
+		}
+		flist_free(fl);
+	}
+	return NULL;
+}
+
 static void
 ftok_free(
 	ftok_t	*ft)
diff --git a/db/flist.h b/db/flist.h
index 5c9fba0..3f4b312 100644
--- a/db/flist.h
+++ b/db/flist.h
@@ -37,3 +37,4 @@ extern int	flist_parse(const struct field *fields, flist_t *fl, void *obj,
 			    int startoff);
 extern void	flist_print(flist_t *fl);
 extern flist_t	*flist_scan(char *name);
+extern flist_t	*flist_find_ftyp(const field_t *fields, fldt_t  type);
diff --git a/db/io.c b/db/io.c
index 91858e2..732b320 100644
--- a/db/io.c
+++ b/db/io.c
@@ -27,6 +27,7 @@
 #include "output.h"
 #include "init.h"
 #include "malloc.h"
+#include "crc.h"
 
 static int	pop_f(int argc, char **argv);
 static void     pop_help(void);
@@ -466,22 +467,41 @@ xfs_dummy_verify(
 void
 write_cur(void)
 {
+	int skip_crc = 0;
+
+	if (iocur_top->bp->b_ops &&
+	    iocur_top->bp->b_ops->verify_write == xfs_dummy_verify)
+		skip_crc = 1;
+
 	if (iocur_sp < 0) {
 		dbprintf(_("nothing to write\n"));
 		return;
 	}
 
-	if (iocur_top->ino_buf) {
+	if (iocur_top->ino_buf && !skip_crc) {
 		libxfs_dinode_calc_crc(mp, iocur_top->data);
 		iocur_top->ino_crc_ok = 1;
 	}
-	if (iocur_top->dquot_buf)
+
+	if (iocur_top->dquot_buf && !skip_crc)
 		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	if (iocur_top->bbmap)
 		write_cur_bbs();
 	else
 		write_cur_buf();
+
+	/* If we didn't write the crc automatically, re-check validity */
+	if (iocur_top->ino_buf && skip_crc) {
+		xfs_dinode_t	*dip;
+		xfs_ino_t	ino;
+
+		dip = iocur_top->data;
+		ino = iocur_top->ino;
+		iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
+						mp->m_sb.sb_inodesize,
+						XFS_DINODE_CRC_OFF);
+	} 
 }
 
 void
diff --git a/db/write.h b/db/write.h
index 31e2665..664ddcc 100644
--- a/db/write.h
+++ b/db/write.h
@@ -20,5 +20,5 @@ struct field;
 
 extern void	write_init(void);
 extern void	write_block(const field_t *fields, int argc, char **argv);
-extern void	write_string(const field_t *fields, int argc, char **argv);
 extern void	write_struct(const field_t *fields, int argc, char **argv);
+extern void	write_string(const field_t *fields, int argc, char **argv);
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index d527230..46a1f39 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -87,16 +87,14 @@ or
 .I filename
 read-only. This option is required if the filesystem is mounted.
 It is only necessary to omit this flag if a command that changes data
-.RB ( write ", " blocktrash )
+.RB ( write ", " blocktrash ", " crc )
 is to be used.
 .TP
 .B \-x
 Specifies expert mode.
 This enables the
-.B write
-and
-.B blocktrash
-commands.
+.RB ( write ", " blocktrash ", " crc
+invalidate/revalidate) commands.
 .TP
 .B \-V
 Prints the version number and exits.
@@ -409,6 +407,25 @@ conversions such as
 .I agb
 .BR fsblock .
 .TP
+.B crc [\-i|\-r|\-v]
+Invalidates, revalidates, or validates the CRC (checksum)
+field of the current structure, if it has one.
+This command is available only on CRC-enabled filesystems.
+With no argument, validation is performed.
+Each command will display the resulting CRC value and state.
+.RS 1.0i
+.TP 0.4i
+.B \-i
+Invalidate the structure's CRC value (incrementing it by one),
+and write it to disk.
+.TP
+.B \-r
+Recalculate the current structure's correct CRC value, and write it to disk.
+.TP
+.B \-v
+Validate and display the current value and state of the structure's CRC.
+.RE
+.TP
 .BI "daddr [" d ]
 Set current address to the daddr (512 byte block) given by
 .IR d .
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
