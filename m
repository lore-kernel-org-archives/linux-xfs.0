Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96AF27CA2
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 18:30:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E547AC001
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 16:30:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ScyCr2ECcGUX37JM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 16:30:05 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 8005443A2C
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 23:30:04 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u7CNU3YF019073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 19:30:04 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V4] xfs_db: add crc manipulation commands
Message-ID: <8cb34b7c-5154-ebb4-7706-1375e94abd74@redhat.com>
Date: Fri, 12 Aug 2016 18:30:03 -0500
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

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

I found this very useful when working with a filesystem image
which was consistent except for a corrupt CRC; the ability to
rewrite the correct CRCs and run repair to validate the fs was
very handy...

V2: Fix whitespace damage, clarify write_cur() changes
a bit w/ code & comments.

V3: Be a bit more verbose with command output

V4: Rebase patch to current tree

diff --git a/db/Makefile b/db/Makefile
index 8260da3..ba4b1a8 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h debug.h \
+	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
diff --git a/db/command.c b/db/command.c
index 3c17a1e..1848d64 100644
--- a/db/command.c
+++ b/db/command.c
@@ -49,6 +49,7 @@
 #include "write.h"
 #include "malloc.h"
 #include "dquot.h"
+#include "crc.h"
 
 cmdinfo_t	*cmdtab;
 int		ncmds;
@@ -124,6 +125,7 @@ init_commands(void)
 	bmap_init();
 	check_init();
 	convert_init();
+	crc_init();
 	debug_init();
 	echo_init();
 	frag_init();
diff --git a/db/flist.c b/db/flist.c
index 84065a2..2530baf 100644
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
index 91cab12..56b4414 100644
--- a/db/io.c
+++ b/db/io.c
@@ -27,6 +27,7 @@
 #include "output.h"
 #include "init.h"
 #include "malloc.h"
+#include "crc.h"
 
 static int	pop_f(int argc, char **argv);
 static void     pop_help(void);
@@ -473,12 +474,14 @@ xfs_verify_recalc_crc(
 void
 write_cur(void)
 {
+	int skip_crc = (iocur_top->bp->b_ops->verify_write == xfs_dummy_verify);
+
 	if (iocur_sp < 0) {
 		dbprintf(_("nothing to write\n"));
 		return;
 	}
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf) {
+	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf && !skip_crc) {
 		libxfs_dinode_calc_crc(mp, iocur_top->data);
 		iocur_top->ino_crc_ok = 1;
 	}
@@ -489,6 +492,19 @@ write_cur(void)
 		write_cur_bbs();
 	else
 		write_cur_buf();
+
+       /* If we didn't write the crc automatically, re-check validity */
+       if (iocur_top->ino_buf && skip_crc) {
+               xfs_dinode_t    *dip;
+               xfs_ino_t       ino;
+
+               dip = iocur_top->data;
+               ino = iocur_top->ino;
+               iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
+                                               mp->m_sb.sb_inodesize,
+                                               XFS_DINODE_CRC_OFF);
+       }
+
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
index ff8f862..894a94e 100644
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
@@ -422,6 +420,25 @@ conversions such as
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
