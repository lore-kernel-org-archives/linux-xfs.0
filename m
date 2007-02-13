Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Feb 2007 22:41:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1D6f2m7004649
	for <xfs@oss.sgi.com>; Mon, 12 Feb 2007 22:41:04 -0800
Received: from pcbnaujok (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA27208 for <xfs@oss.sgi.com>; Tue, 13 Feb 2007 17:41:00 +1100
Message-Id: <200702130641.RAA27208@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] XFS metadata dump feature added to xfs_db
Date: Tue, 13 Feb 2007 17:44:07 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_008F_01C74F96.8FAF0850"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_008F_01C74F96.8FAF0850
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

The attached patch adds a metadata dump and restore command to xfs_db. A
script is also supplied called xfs_metadata to make it simpler to
generate a metadump file from the command line.

The purpose of this feature is to allow a user with a corrupted and/or
unrepairable filesystem to generate a compact metadata only image that
is small and compressable that can easily be transferred to us for
analysis.

The command also supports output to stdout, so can be used in the
following fashion:

# xfs_metadump /dev/foo - | bzip2 > /tmp/foo.bz2

A man page update for xfs_db and a new man page for xfs_metadump will be
created before this is checked in.

I will also investigate a "name obfuscation" option that works with the
hash entries in directories and extended attributes. This would be a
future enhancement that won't make this patch.

Regards,
Barry.



------=_NextPart_000_008F_01C74F96.8FAF0850
Content-Type: application/octet-stream;
	name="xfs_metadump.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="xfs_metadump.patch"


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/db/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/db/Makefile	2007-02-13 17:29:33.000000000 +1100
+++ b/xfsprogs/db/Makefile	2007-02-13 11:24:54.820768218 +1100
@@ -11,11 +11,11 @@ HFILES =3D addr.h agf.h agfl.h agi.h attr.
 	bmapbt.h bmroot.h bnobt.h check.h cntbt.h command.h convert.h \
 	dbread.h debug.h dir.h dir2.h dir2sf.h dirshort.h dquot.h echo.h \
 	faddr.h field.h flist.h fprint.h frag.h freesp.h hash.h help.h \
-	init.h inobt.h inode.h input.h io.h malloc.h output.h \
+	init.h inobt.h inode.h input.h io.h malloc.h metadump.h output.h \
 	print.h quit.h sb.h sig.h strvec.h text.h type.h write.h \
 	attrset.h
 CFILES =3D $(HFILES:.h=3D.c)
-LSRCFILES =3D xfs_admin.sh xfs_check.sh xfs_ncheck.sh
+LSRCFILES =3D xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
 LLDLIBS	=3D $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT)
 LTDEPENDENCIES =3D $(LIBXFS) $(LIBXLOG)
 LLDFLAGS +=3D -static
@@ -40,4 +40,5 @@ install: default
 	$(INSTALL) -m 755 xfs_admin.sh $(PKG_BIN_DIR)/xfs_admin
 	$(INSTALL) -m 755 xfs_check.sh $(PKG_BIN_DIR)/xfs_check
 	$(INSTALL) -m 755 xfs_ncheck.sh $(PKG_BIN_DIR)/xfs_ncheck
+	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_BIN_DIR)/xfs_metadump
 install-dev:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/db/command.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/db/command.c	2007-02-13 17:29:33.000000000 +1100
+++ b/xfsprogs/db/command.c	2007-01-30 15:11:45.903970466 +1100
@@ -131,6 +131,7 @@ init_commands(void)
 	inode_init();
 	input_init();
 	io_init();
+	metadump_init();
 	output_init();
 	print_init();
 	quit_init();

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/db/init.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/db/init.c	2007-02-13 17:29:33.000000000 +1100
+++ b/xfsprogs/db/init.c	2007-02-13 16:19:42.359432895 +1100
@@ -107,8 +107,8 @@ init(
 	}
=20
 	if (read_bbs(XFS_SB_DADDR, 1, &bufp, NULL)) {
-		dbprintf(_("%s: %s is invalid (cannot read first 512 bytes)\n"),
-			progname, fsdevice);
+		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
+			"bytes)\n"), progname, fsdevice);
 		exit(1);
 	}
=20
@@ -118,7 +118,7 @@ init(
=20
 	sbp =3D &xmount.m_sb;
 	if (sbp->sb_magicnum !=3D XFS_SB_MAGIC) {
-		dbprintf(_("%s: unexpected XFS SB magic number 0x%08x\n"),
+		fprintf(stderr, _("%s: unexpected XFS SB magic number 0x%08x\n"),
 			progname, sbp->sb_magicnum);
 	}
=20
@@ -128,8 +128,8 @@ init(
 		mp =3D libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
 				LIBXFS_MOUNT_DEBUGGER);
 		if (!mp) {
-			dbprintf(_("%s: device %s unusable (not an XFS filesystem?)\n"),
-			progname, fsdevice);
+			fprintf(stderr, _("%s: device %s unusable (not an XFS "
+				"filesystem?)\n"), progname, fsdevice);
 			exit(1);
 		}
 	}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/db/metadump.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/db/metadump.c	2007-02-13 17:29:33.000000000 +1100
+++ b/xfsprogs/db/metadump.c	2007-02-13 16:15:18.160445693 +1100
@@ -0,0 +1,1195 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
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
+#include "bmap.h"
+#include "command.h"
+#include "metadump.h"
+#include "io.h"
+#include "output.h"
+#include "type.h"
+#include "init.h"
+#include "sig.h"
+
+/* copy all metadata structures to/from a file */
+
+static int	metadump_f(int argc, char **argv);
+static int	metarestore_f(int argc, char **argv);
+static void	metadump_help(void);
+
+#define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
+
+/*
+ * metadump commands issue info/wornings/errors to standard error as
+ * metadump supports stdout as a destination (and from stdin for restore).
+ *
+ * All static functions return zero on failure, while the public functions
+ * return zero on success.
+ */
+
+static const cmdinfo_t	metadump_cmd =3D
+	{ "metadump", NULL, metadump_f, 0, -1, 0,
+		"[-e] [-g] [-w] filename",
+		"dump metadata to a file", metadump_help };
+
+static const cmdinfo_t	metarestore_cmd =3D
+	{ "metarestore", NULL, metarestore_f, 0, -1, 0,
+		"[-g] filename",
+		"restore metadata from a file", NULL };
+
+typedef struct xfs_metablock {
+	__be32		mb_magic;
+	__be16		mb_count;
+	__uint8_t	mb_blocklog;
+	__uint8_t	mb_reserved;
+	/* followed by an array of xfs_daddr_t */
+} xfs_metablock_t;
+
+static int		fd;	/* metadump file */
+
+static xfs_metablock_t 	*metablock;	/* header + index + buffers */
+static __be64		*block_index;
+static char		*block_buffer;
+
+static int		num_indicies;
+static int		cur_index;
+
+static int		show_progress =3D 0;
+static int		stop_on_read_error =3D 0;
+static int		wflag =3D 0;
+static int		progress_since_warning =3D 0;
+
+void
+metadump_init(void)
+{
+	add_command(&metadump_cmd);
+	if (expert_mode)
+		add_command(&metarestore_cmd);
+}
+
+static void
+metadump_help(void)
+{
+	dbprintf(
+"\n"
+" The 'metadump' command dumps the known metadata to a compact file suitab=
le\n"
+" for compressing and sending to an XFS maintainer for corruption analysis=
 \n"
+" or xfs_repair failures.\n\n"
+" There are 3 options:\n"
+"   -e -- Ignore read errors and keep going\n"
+"   -g -- Display dump progress\n"
+"   -w -- Show warnings of bad metadata information\n"
+"\n");
+}
+
+static void
+print_warning(const char *fmt, ...)
+{
+	char		buf[200];
+	va_list		ap;
+
+	if (seenint())
+		return;
+
+	va_start(ap, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+	buf[sizeof(buf)-1] =3D '\0';
+
+	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
+			progname, buf);
+	progress_since_warning =3D 0;
+}
+
+static void
+print_progress(const char *fmt, ...)
+{
+	char		buf[60];
+	va_list		ap;
+	FILE		*f;
+
+	if (seenint())
+		return;
+
+	va_start(ap, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+	buf[sizeof(buf)-1] =3D '\0';
+
+	f =3D (fd =3D=3D STDOUT_FILENO) ? stderr : stdout;
+	fprintf(f, "\r%-59s", buf);
+	fflush(f);
+	progress_since_warning =3D 1;
+}
+
+/*
+ * A complete dump file will have a "zero" entry in the last index block,
+ * even if the dump is exactly aligned, the last index will be full of
+ * zeros. If the last index entry is non-zero, the dump is incomplete.
+ * Correspondingly, the last chunk will have a count < num_indicies.
+ */
+
+static int
+write_index(void)
+{
+	/*
+	 * write index block and following data blocks (streaming)
+	 */
+	metablock->mb_count =3D cpu_to_be16(cur_index);
+	if (write(fd, metablock, (cur_index + 1) << BBSHIFT) =3D=3D -1) {
+		print_warning("error writing to file: %s", strerror(errno));
+		return 0;
+	}
+
+	memset(block_index, 0, num_indicies * sizeof(__be64));
+	cur_index =3D 0;
+	return 1;
+}
+
+static int
+write_buf(
+	iocur_t		*buf)
+{
+	char		*data;
+	__int64_t	off;
+	int		i;
+
+	for (i =3D 0, off =3D buf->bb, data =3D buf->data;
+			i < buf->blen;
+			i++, off++, data +=3D BBSIZE) {
+		block_index[cur_index] =3D cpu_to_be64(off);
+		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
+		if (++cur_index =3D=3D num_indicies) {
+			if (!write_index())
+				return 0;
+		}
+	}
+	return !seenint();
+}
+
+
+static int
+scan_btree(
+	xfs_agnumber_t	agno,
+	xfs_agblock_t	agbno,
+	int		level,
+	typnm_t		btype,
+	void		*arg,
+	int		(*func)(xfs_btree_hdr_t		*bthdr,
+				xfs_agnumber_t		agno,
+				xfs_agblock_t		agbno,
+				int			level,
+				typnm_t			btype,
+				void			*arg))
+{
+	push_cur();
+	set_cur(&typtab[btype], XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb,
+			DB_RING_IGN, NULL);
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read %s block %u/%u", typtab[btype].name,
+				agno, agbno);
+		return !stop_on_read_error;
+	}
+	if (!write_buf(iocur_top))
+		return 0;
+
+	if (!(*func)(iocur_top->data, agno, agbno, level - 1, btype, arg))
+		return 0;
+
+	pop_cur();
+	return 1;
+}
+
+/* free space tree copy routines */
+
+static int
+valid_bno(
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	typnm_t			btype)
+{
+	if (bno > 0 && bno <=3D mp->m_sb.sb_agblocks)
+		return 1;
+
+	if (wflag)
+		print_warning("invalid block number (%u) in %s block %u/%u",
+				bno, typtab[btype].name, agno, agbno);
+	return 0;
+}
+
+static int
+scanfunc_freesp(
+	xfs_btree_hdr_t		*bthdr,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_alloc_ptr_t		*pp;
+	int			i;
+	int			nrecs;
+
+	if (level =3D=3D 0)
+		return 1;
+
+	nrecs =3D be16_to_cpu(bthdr->bb_numrecs);
+	if (nrecs > mp->m_alloc_mxr[1]) {
+		if (wflag)
+			print_warning("invalid nrecs (%u) in %s block %u/%u",
+					nrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp =3D XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize, xfs_alloc, bthdr, 1,
+			mp->m_alloc_mxr[1]);
+	for (i =3D 0; i < nrecs; i++) {
+		if (!valid_bno(be32_to_cpu(pp[i]), agno, agbno, btype))
+			continue;
+		if (!scan_btree(agno, be32_to_cpu(pp[i]), level, btype, arg,
+				scanfunc_freesp))
+			return 0;
+	}
+	return 1;
+}
+
+static int
+copy_free_bno_btree(
+	xfs_agnumber_t	agno,
+	xfs_agf_t	*agf)
+{
+	xfs_agblock_t	root;
+	int		levels;
+
+	root =3D be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	levels =3D be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+
+	/* validate root and levels before processing the tree */
+	if (root =3D=3D 0 || root > mp->m_sb.sb_agblocks) {
+		if (wflag)
+			print_warning("invalid block number (%u) in bnobt "
+					"root in agf %u", root, agno);
+		return 1;
+	}
+	if (levels >=3D XFS_BTREE_MAXLEVELS) {
+		if (wflag)
+			print_warning("invalid level (%u) in bnobt root "
+					"in agf %u", levels, agno);
+		return 1;
+	}
+
+	return scan_btree(agno, root, levels, TYP_BNOBT, agf, scanfunc_freesp);
+}
+
+static int
+copy_free_cnt_btree(
+	xfs_agnumber_t	agno,
+	xfs_agf_t	*agf)
+{
+	xfs_agblock_t	root;
+	int		levels;
+
+	root =3D be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	levels =3D be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+
+	/* validate root and levels before processing the tree */
+	if (root =3D=3D 0 || root > mp->m_sb.sb_agblocks) {
+		if (wflag)
+			print_warning("invalid block number (%u) in cntbt "
+					"root in agf %u", root, agno);
+		return 1;
+	}
+	if (levels >=3D XFS_BTREE_MAXLEVELS) {
+		if (wflag)
+			print_warning("invalid level (%u) in cntbt root "
+					"in agf %u", levels, agno);
+		return 1;
+	}
+
+	return scan_btree(agno, root, levels, TYP_CNTBT, agf, scanfunc_freesp);
+}
+
+/* inode copy routines */
+
+static int
+process_bmbt_reclist(
+	xfs_bmbt_rec_t 		*rp,
+	int 			numrecs,
+	typnm_t			btype)
+{
+	int			i;
+	xfs_dfiloff_t		o;
+	xfs_dfsbno_t		s;
+	xfs_dfilblks_t		c;
+	int			f;
+
+	if (btype =3D=3D TYP_DATA)
+		return 1;
+
+	for (i =3D 0; i < numrecs; i++, rp++) {
+		convert_extent(rp, &o, &s, &c, &f);
+
+		push_cur();
+		set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
+				DB_RING_IGN, NULL);
+		if (iocur_top->data =3D=3D NULL) {
+			print_warning("cannot read %s block %u/%u",
+					typtab[btype].name,
+					XFS_FSB_TO_AGNO(mp, s),
+					XFS_FSB_TO_AGBNO(mp, s));
+			if (stop_on_read_error)
+				return 0;
+		} else {
+			if (!write_buf(iocur_top))
+				return 0;
+		}
+		pop_cur();
+	}
+
+	return 1;
+}
+
+static int
+scanfunc_bmap(
+	xfs_btree_hdr_t		*bthdr,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)	/* ptr to itype */
+{
+	int			i;
+	xfs_bmbt_ptr_t		*pp;
+	xfs_bmbt_rec_t		*rp;
+	int			nrecs;
+
+	nrecs =3D be16_to_cpu(bthdr->bb_numrecs);
+
+	if (level =3D=3D 0) {
+		if (nrecs > mp->m_bmap_dmxr[0]) {
+			if (wflag)
+				print_warning("invalid numrecs (%u) in %s "
+						"block %u/%u", nrecs,
+						typtab[btype].name, agno, agbno);
+			return 1;
+		}
+		rp =3D XFS_BTREE_REC_ADDR(mp->m_sb.sqb_blocksize, xfs_bmbt, bthdr,
+					1, mp->m_bmap_dmxr[0]);
+
+		return process_bmbt_reclist(rp, nrecs, *(typnm_t*)arg);
+	}
+
+	if (nrecs > mp->m_bmap_dmxr[1]) {
+		if (wflag)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+					nrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+	pp =3D XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt, bthdr, 1,
+				mp->m_bmap_dmxr[1]);
+	for (i =3D 0; i < nrecs; i++) {
+		xfs_agnumber_t	ag;
+		xfs_agblock_t	bno;
+
+		ag =3D XFS_FSB_TO_AGNO(mp, be64_to_cpu(pp[i]));
+		bno =3D XFS_FSB_TO_AGBNO(mp, be64_to_cpu(pp[i]));
+
+		if (bno =3D=3D 0 || bno > mp->m_sb.sb_agblocks ||
+				ag > mp->m_sb.sb_agcount) {
+			if (wflag)
+				print_warning("invalid block number (%u/%u) "
+						"in %s block %u/%u", ag, bno,
+						typtab[btype].name, agno, agbno);
+			continue;
+		}
+
+		if (!scan_btree(ag, bno, level, btype, arg, scanfunc_bmap))
+			return 0;
+	}
+	return 1;
+}
+
+static int
+process_btinode(
+	xfs_ino_t		ino,
+	xfs_dinode_t 		*dip,
+	typnm_t			itype)
+{
+	xfs_bmdr_block_t	*dib;
+	int			i;
+	xfs_bmbt_ptr_t		*pp;
+	xfs_bmbt_rec_t		*rp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			whichfork;
+	typnm_t			btype;
+
+	whichfork =3D (itype =3D=3D TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
+	btype =3D (itype =3D=3D TYP_ATTR) ? TYP_BMAPBTA : TYP_BMAPBTD;
+
+	dib =3D (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
+	level =3D be16_to_cpu(dib->bb_level);
+	nrecs =3D be16_to_cpu(dib->bb_numrecs);
+
+	if (level > XFS_BM_MAXLEVELS(mp, whichfork)) {
+		if (wflag)
+			print_warning("invalid level (%u) in inode %lld %s "
+					"root", level, (long long)ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	if (level =3D=3D 0) {
+		rp =3D XFS_BTREE_REC_ADDR(XFS_DFORK_SIZE(dip, mp, whichfork),
+				xfs_bmdr, dib, 1, XFS_BTREE_BLOCK_MAXRECS(
+					XFS_DFORK_SIZE(dip, mp, whichfork),
+					xfs_bmdr, 1));
+
+		return process_bmbt_reclist(rp, nrecs, itype);
+	}
+
+	maxrecs =3D XFS_BTREE_BLOCK_MAXRECS(XFS_DFORK_SIZE(dip, mp, whichfork),
+			xfs_bmdr, 0);
+	if (nrecs > maxrecs) {
+		if (wflag)
+			print_warning("invalid numrecs (%u) in inode %lld %s "
+					"root", nrecs, (long long)ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	pp =3D XFS_BTREE_PTR_ADDR(XFS_DFORK_SIZE(dip, mp, whichfork), xfs_bmdr,
+			dib, 1, maxrecs);
+	for (i =3D 0; i < nrecs; i++) {
+		xfs_agnumber_t	ag;
+		xfs_agblock_t	bno;
+
+		ag =3D XFS_FSB_TO_AGNO(mp, be64_to_cpu(pp[i]));
+		bno =3D XFS_FSB_TO_AGBNO(mp, be64_to_cpu(pp[i]));
+
+		if (bno =3D=3D 0 || bno > mp->m_sb.sb_agblocks ||
+				ag > mp->m_sb.sb_agcount) {
+			if (wflag)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s root", ag,
+						bno, (long long)ino,
+						typtab[btype].name);
+			continue;
+		}
+
+		if (!scan_btree(ag, bno, level, btype, &itype, scanfunc_bmap))
+			return 0;
+	}
+	return 1;
+}
+
+static int
+process_exinode(
+	xfs_dinode_t 		*dip,
+	typnm_t			itype)
+{
+	int			whichfork;
+
+	whichfork =3D (itype =3D=3D TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
+
+	return process_bmbt_reclist(
+			(xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork),
+			XFS_DFORK_NEXTENTS_HOST(dip, whichfork), itype);
+}
+
+static int
+process_inode_data(
+	xfs_ino_t		ino,
+	xfs_dinode_t		*dip,
+	typnm_t			itype)
+{
+	switch (dip->di_core.di_format) {
+		case XFS_DINODE_FMT_EXTENTS:
+			return process_exinode(dip, itype);
+
+		case XFS_DINODE_FMT_BTREE:
+			return process_btinode(ino, dip, itype);
+	}
+	return 1;
+}
+
+static int
+process_inode(
+	xfs_agnumber_t		agno,
+	xfs_agino_t 		agino,
+	xfs_dinode_t 		*dip)
+{
+	xfs_dinode_core_t       odic;
+	xfs_ino_t		lino;
+	int			success;
+
+	/* convert the core */
+	memcpy(&odic, &dip->di_core, sizeof(xfs_dinode_core_t));
+	libxfs_xlate_dinode_core((xfs_caddr_t)&odic, &dip->di_core, 1);
+
+	success =3D 1;
+	lino =3D XFS_AGINO_TO_INO(mp, agno, agino);
+
+	/* copy appropriate data fork metadata */
+	switch (dip->di_core.di_mode & S_IFMT) {
+		case S_IFDIR:
+			success =3D process_inode_data(lino, dip, TYP_DIR2);
+			break;
+		case S_IFLNK:
+			success =3D process_inode_data(lino, dip, TYP_SYMLINK);
+			break;
+		default:
+			success =3D process_inode_data(lino, dip, TYP_DATA);
+	}
+
+	/* copy extended attributes if they exist */
+	if (success && dip->di_core.di_forkoff) {
+		switch (dip->di_core.di_aformat) {
+			case XFS_DINODE_FMT_EXTENTS:
+				success =3D process_exinode(dip, TYP_ATTR);
+				break;
+
+			case XFS_DINODE_FMT_BTREE:
+				success =3D process_btinode(lino, dip, TYP_ATTR);
+				break;
+		}
+	}
+
+	/* restore the core back to it's original endianess */
+	memcpy(&dip->di_core, &odic, sizeof(xfs_dinode_core_t));
+	return success;
+}
+
+static __uint32_t	inodes_copied =3D 0;
+
+static int
+copy_inode_chunk(
+	xfs_agnumber_t 		agno,
+	xfs_inobt_rec_t 	*rp)
+{
+	xfs_agino_t 		agino;
+	int			off;
+	xfs_agblock_t		agbno;
+	int			i;
+
+	agino =3D be32_to_cpu(rp->ir_startino);
+	agbno =3D XFS_AGINO_TO_AGBNO(mp, agino);
+	off =3D XFS_INO_TO_OFFSET(mp, agino);
+
+	push_cur();
+	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)),
+			DB_RING_IGN, NULL);
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read inode block %u/%u", agno, agbno);
+		return !stop_on_read_error;
+	}
+
+	/*
+	 * scan through inodes and copy any btree extent lists, directory
+	 * contents and extended attributes.
+	 */
+
+	for (i =3D 0; i < XFS_INODES_PER_CHUNK; i++) {
+		xfs_dinode_t            *dip;
+
+		if (XFS_INOBT_IS_FREE_DISK(rp, i))
+			continue;
+
+		dip =3D (xfs_dinode_t *)((char *)iocur_top->data +
+				((off + i) << mp->m_sb.sb_inodelog));
+
+		if (!process_inode(agno, agino + i, dip))
+			return 0;
+	}
+
+	if (!write_buf(iocur_top))
+		return 0;
+
+	inodes_copied +=3D XFS_INODES_PER_CHUNK;
+
+	if (show_progress)
+		print_progress("Copied %u of %u inodes (%u of %u AGs)",
+				inodes_copied, mp->m_sb.sb_icount, agno,
+				mp->m_sb.sb_agcount);
+
+	pop_cur();
+
+	return 1;
+}
+
+static int
+scanfunc_ino(
+	xfs_btree_hdr_t		*bthdr,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_inobt_rec_t		*rp;
+	xfs_inobt_ptr_t		*pp;
+	int			i;
+
+	if (level =3D=3D 0) {
+		rp =3D XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_inobt,
+				bthdr, 1, mp->m_inobt_mxr[0]);
+		for (i =3D 0; i < be16_to_cpu(bthdr->bb_numrecs); i++, rp++) {
+			if (!copy_inode_chunk(agno, rp))
+				return 0;
+		}
+	} else {
+		pp =3D XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize, xfs_inobt,
+				bthdr, 1, mp->m_inobt_mxr[1]);
+		for (i =3D 0; i < be16_to_cpu(bthdr->bb_numrecs); i++) {
+			if (!valid_bno(be32_to_cpu(pp[i]), agno, agbno, btype))
+				continue;
+			if (!scan_btree(agno, be32_to_cpu(pp[i]), level,
+					btype, arg, scanfunc_ino))
+				return 0;
+		}
+	}
+	return 1;
+}
+
+static int
+copy_inodes(
+	xfs_agnumber_t		agno,
+	xfs_agi_t		*agi)
+{
+	xfs_agblock_t		root;
+	int			levels;
+
+	root =3D be32_to_cpu(agi->agi_root);
+	levels =3D be32_to_cpu(agi->agi_level);
+
+	/* validate root and levels before processing the tree */
+	if (root =3D=3D 0 || root > mp->m_sb.sb_agblocks) {
+		if (wflag)
+			print_warning("invalid block number (%u) in inobt "
+					"root in agi %u", root, agno);
+		return 1;
+	}
+	if (levels >=3D XFS_BTREE_MAXLEVELS) {
+		if (wflag)
+			print_warning("invalid level (%u) in inobt root "
+					"in agi %u", levels, agno);
+		return 1;
+	}
+
+	return scan_btree(agno, root, levels, TYP_INOBT, agi, scanfunc_ino);
+}
+
+static int
+scan_ag(
+	xfs_agnumber_t	agno)
+{
+	xfs_agf_t	*agf;
+	xfs_agi_t	*agi;
+
+	/* copy the superblock of the AG */
+	push_cur();
+	set_cur(&typtab[TYP_SB], XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
+	if (!iocur_top->data) {
+		print_warning("cannot read superblock for ag %u", agno);
+		if (stop_on_read_error)
+			return 0;
+	} else {
+		if (!write_buf(iocur_top))
+			return 0;
+	}
+
+	/* copy the AG free space btree root */
+	push_cur();
+	set_cur(&typtab[TYP_AGF], XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
+	agf =3D iocur_top->data;
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read agf block for ag %u", agno);
+		if (stop_on_read_error)
+			return 0;
+	} else {
+		if (!write_buf(iocur_top))
+			return 0;
+	}
+
+	/* copy the AG inode btree root */
+	push_cur();
+	set_cur(&typtab[TYP_AGI], XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
+	agi =3D iocur_top->data;
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read agi block for ag %u", agno);
+		if (stop_on_read_error)
+			return 0;
+	} else {
+		if (!write_buf(iocur_top))
+			return 0;
+	}
+
+	/* copy the AG free list header */
+	push_cur();
+	set_cur(&typtab[TYP_AGFL], XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read agfl block for ag %u", agno);
+		if (stop_on_read_error)
+			return 0;
+	} else {
+		if (!write_buf(iocur_top))
+			return 0;
+	}
+	pop_cur();
+
+	/* copy AG free space btrees */
+	if (agf) {
+		if (show_progress)
+			print_progress("Copying free space trees of AG %u",
+					agno);
+		if (!copy_free_bno_btree(agno, agf))
+			return 0;
+		if (!copy_free_cnt_btree(agno, agf))
+			return 0;
+	}
+
+	/* copy inode btrees and the inodes and their associated metadata */
+	if (agi) {
+		if (!copy_inodes(agno, agi))
+			return 0;
+	}
+
+	pop_cur();
+	pop_cur();
+	pop_cur();
+
+	return 1;
+}
+
+static int
+copy_ino(
+	xfs_ino_t		ino,
+	typnm_t			itype)
+{
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_agino_t		agino;
+	xfs_dinode_t		*dip;
+	xfs_dinode_core_t	tdic;
+	int			offset;
+
+	if (ino =3D=3D 0)
+		return 1;
+
+	agno =3D XFS_INO_TO_AGNO(mp, ino);
+	agino =3D XFS_INO_TO_AGINO(mp, ino);
+	agbno =3D XFS_AGINO_TO_AGBNO(mp, agino);
+	offset =3D XFS_AGINO_TO_OFFSET(mp, agino);
+
+	if (agno >=3D mp->m_sb.sb_agcount || agbno >=3D mp->m_sb.sb_agblocks ||
+			offset >=3D mp->m_sb.sb_inopblock) {
+		if (wflag)
+			print_warning("invalid %s inode number (%lld)",
+					typtab[itype].name, (long long)ino);
+		return 1;
+	}
+
+	push_cur();
+	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			blkbb, DB_RING_IGN, NULL);
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read %s inode %lld",
+				typtab[itype].name, (long long)ino);
+		return !stop_on_read_error;
+	}
+	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
+
+	dip =3D iocur_top->data;
+	libxfs_xlate_dinode_core((xfs_caddr_t)&dip->di_core, &tdic, 1);
+	memcpy(&dip->di_core, &tdic, sizeof(xfs_dinode_core_t));
+
+	return process_inode_data(ino, dip, itype);
+}
+
+
+static int
+copy_sb_inodes(void)
+{
+	if (!copy_ino(mp->m_sb.sb_rbmino, TYP_RTBITMAP))
+		return 0;
+
+	if (!copy_ino(mp->m_sb.sb_rsumino, TYP_RTSUMMARY))
+		return 0;
+
+	if (!copy_ino(mp->m_sb.sb_uquotino, TYP_DQBLK))
+		return 0;
+
+	return copy_ino(mp->m_sb.sb_gquotino, TYP_DQBLK);
+}
+
+static int
+copy_log(void)
+{
+	if (show_progress)
+		print_progress("Copying log");
+
+	push_cur();
+	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	if (iocur_top->data =3D=3D NULL) {
+		print_warning("cannot read log");
+		return !stop_on_read_error;
+	}
+	return write_buf(iocur_top);
+}
+
+static int
+metadump_f(
+	int 		argc,
+	char 		**argv)
+{
+	xfs_agnumber_t	agno;
+	int		c;
+	int		start_iocur_sp;
+
+	exitcode =3D 1;
+	show_progress =3D 0;
+	wflag =3D 0;
+	stop_on_read_error =3D 0;
+
+	if (mp->m_sb.sb_magicnum !=3D XFS_SB_MAGIC) {
+		print_warning("bad superblock magic number %x, giving up",
+				mp->m_sb.sb_magicnum);
+		return 0;
+	}
+
+	while ((c =3D getopt(argc, argv, "egw")) !=3D EOF) {
+		switch (c) {
+			case 'e':
+				stop_on_read_error =3D 1;
+				break;
+			case 'g':
+				show_progress =3D 1;
+				break;
+			case 'w':
+				wflag =3D 1;
+				break;
+			default:
+				print_warning("bad option for metadump command");
+				return 0;
+		}
+	}
+
+	if (optind !=3D argc - 1) {
+		print_warning("too few options for metadump (no filename given)");
+		return 0;
+	}
+
+	metablock =3D (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
+	if (metablock =3D=3D NULL) {
+		print_warning("memory allocation failure");
+		return 0;
+	}
+	metablock->mb_blocklog =3D BBSHIFT;
+	metablock->mb_magic =3D cpu_to_be32(XFS_MD_MAGIC);
+
+	block_index =3D (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
+	block_buffer =3D (char *)metablock + BBSIZE;
+	num_indicies =3D (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
+	cur_index =3D 0;
+	start_iocur_sp =3D iocur_sp;
+
+	if (strcmp(argv[optind], "-") =3D=3D 0) {
+		if (isatty(STDOUT_FILENO)) {
+			print_warning("cannot write to a terminal");
+			free(metablock);
+			return 0;
+		}
+		fd =3D STDOUT_FILENO;
+	} else {
+		fd =3D open(argv[optind], O_WRONLY | O_CREAT | O_TRUNC, 0666);
+		if (fd =3D=3D -1) {
+			print_warning("cannot create dump file");
+			free(metablock);
+			return 0;
+		}
+	}
+
+	exitcode =3D 0;
+
+	for (agno =3D 0; agno < mp->m_sb.sb_agcount; agno++) {
+		if (!scan_ag(agno)) {
+			exitcode =3D 1;
+			break;
+		}
+	}
+
+	/* copy realtime and quota inode contents */
+	if (!exitcode)
+		exitcode =3D !copy_sb_inodes();
+
+	/* copy log if it's internal */
+	if ((mp->m_sb.sb_logstart !=3D 0) && !exitcode)
+		exitcode =3D !copy_log();
+
+	/* write the remaining index */
+	if (!exitcode)
+		exitcode =3D !write_index();
+
+	if (fd !=3D STDOUT_FILENO)
+		close(fd);
+
+	/* cleanup iocur stack */
+	while (iocur_sp > start_iocur_sp)
+		pop_cur();
+
+	free(metablock);
+
+	if (progress_since_warning)
+		fputc('\n', (fd =3D=3D STDOUT_FILENO) ? stderr : stdout);
+
+	return 0;
+}
+
+static void
+remount(
+	xfs_sb_t		*sb)
+{
+	libxfs_umount(mp);
+
+	if (!libxfs_mount(mp, sb, x.ddev, x.logdev, x.rtdev,
+			LIBXFS_MOUNT_ROOTINOS | LIBXFS_MOUNT_DEBUGGER)) {
+		if (!libxfs_mount(mp, sb, x.ddev, x.logdev, x.rtdev,
+				LIBXFS_MOUNT_DEBUGGER)) {
+			print_warning("cannot remount the filesystem");
+			exit(1);
+		}
+	}
+	blkbb =3D 1 << mp->m_blkbb_log;
+}
+
+static int
+perform_restore(void)
+{
+	xfs_metablock_t		tmb;
+	int			bsize;
+	xfs_sb_t		sb;
+	int			bbpb;
+	__int64_t		bbs_read;
+	int			success;
+
+	/*
+	 * read in first block (superblock 0), set "inprogress" flag for it,
+	 * read in the rest of the file, and if complete, clear SB 0's
+	 * "inprogress flag"
+	 */
+
+	if (read(fd, &tmb, sizeof(tmb)) =3D=3D -1) {
+		print_warning("error reading from file: %s", strerror(errno));
+		return 0;
+	}
+
+	if (be32_to_cpu(tmb.mb_magic) !=3D XFS_MD_MAGIC) {
+		print_warning("specified file is not a metadata dump");
+		return 0;
+	}
+
+	bsize =3D 1 << tmb.mb_blocklog;
+	metablock =3D (xfs_metablock_t *)calloc(bsize + 1, bsize);
+	if (metablock =3D=3D NULL) {
+		print_warning("memory allocation failure");
+		return 0;
+	}
+	metablock->mb_count =3D be16_to_cpu(tmb.mb_count);
+	metablock->mb_blocklog =3D tmb.mb_blocklog;
+
+	num_indicies =3D (bsize - sizeof(xfs_metablock_t)) / sizeof(__be64);
+
+	if (metablock->mb_count =3D=3D 0 || metablock->mb_count > num_indicies) {
+		print_warning("bad block count: %u", metablock->mb_count);
+		return 0;
+	}
+
+	block_index =3D (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
+	block_buffer =3D (char *)metablock + bsize;
+
+	if (read(fd, block_index, bsize - sizeof(tmb)) =3D=3D -1) {
+		print_warning("error reading from file: %s", strerror(errno));
+		return 0;
+	}
+
+	if (be64_to_cpu(block_index[0]) !=3D XFS_AG_DADDR(mp, 0, XFS_SB_DADDR)) {
+		print_warning("first block is not the primary superblock");
+		return 0;
+	}
+
+	if (read(fd, block_buffer,
+			metablock->mb_count << metablock->mb_blocklog) =3D=3D -1) {
+		print_warning("error reading from file: %s", strerror(errno));
+		return 0;
+	}
+
+	libxfs_xlate_sb(block_buffer, &sb, 1, XFS_SB_ALL_BITS);
+
+	if (sb.sb_magicnum !=3D XFS_SB_MAGIC) {
+		print_warning("bad magic number for primary superblock");
+		return 0;
+	}
+
+	/* purge all cached data before writing to device */
+	libxfs_bcache_purge();
+	libxfs_icache_purge();
+
+	((xfs_sb_t*)block_buffer)->sb_inprogress =3D 1;
+	cur_index =3D 1 << (sb.sb_sectlog - BBSHIFT);
+
+	if (write_bbs(XFS_SB_DADDR, cur_index, block_buffer, NULL)) {
+		print_warning("error writing primary superblock: %s",
+				strerror(errno));
+		return 0;
+	}
+
+	bbpb =3D 1 << (metablock->mb_blocklog - BBSHIFT);
+	bbs_read =3D 0;
+	success =3D 0;
+
+
+	/* write the rest of the file out */
+	for (;;) {
+		if (show_progress &&  (bbs_read & 2047) =3D=3D 0)
+			print_progress("%lld MB read", bbs_read >> 11);
+
+		for (; cur_index < metablock->mb_count; cur_index++) {
+			if (write_bbs(be64_to_cpu(block_index[cur_index]),
+					bbpb, &block_buffer[cur_index <<
+							metablock->mb_blocklog],
+					NULL)) {
+				print_warning("error writing block %llu: %s",
+					be64_to_cpu(block_index[cur_index]),
+						strerror(errno));
+				remount(&sb);
+				return 0;
+			}
+		}
+		if (metablock->mb_count < num_indicies) {
+			success =3D 1;
+			break;
+		}
+
+		if (read(fd, metablock, bsize) =3D=3D -1) {
+			print_warning("error reading from file: %s",
+					strerror(errno));
+			break;
+		}
+		if (metablock->mb_count =3D=3D 0) {
+			success =3D 1;
+			break;
+		}
+
+		metablock->mb_count =3D be16_to_cpu(metablock->mb_count);
+
+		if (read(fd, block_buffer, metablock->mb_count <<
+				metablock->mb_blocklog) =3D=3D -1) {
+			print_warning("error reading from file: %s",
+					strerror(errno));
+			break;
+		}
+
+		bbs_read +=3D bbpb;
+
+		cur_index =3D 0;
+		if (seenint())
+			break;
+	}
+
+	if (progress_since_warning)
+		fputc('\n', (fd =3D=3D STDOUT_FILENO) ? stderr : stdout);
+
+	if (success) {
+		memset(block_buffer, 0, sb.sb_sectsize);
+		sb.sb_inprogress =3D 0;
+		libxfs_xlate_sb(block_buffer, &sb, 0, XFS_SB_ALL_BITS);
+		if (write_bbs(XFS_SB_DADDR, 1 << (sb.sb_sectlog - BBSHIFT),
+				block_buffer, NULL)) {
+			print_warning("error writing primary superblock: %s",
+					strerror(errno));
+			success =3D 0;
+		}
+	}
+	remount(&sb);
+
+	return success;
+}
+
+static int
+metarestore_f(
+	int 		argc,
+	char 		**argv)
+{
+	int		c;
+
+	exitcode =3D 1;
+	show_progress =3D 0;
+
+	while ((c =3D getopt(argc, argv, "g")) !=3D EOF) {
+		switch (c) {
+			case 'g':
+				show_progress =3D 1;
+				break;
+			default:
+				print_warning("bad option for metarestore "
+						"command");
+				return 0;
+		}
+	}
+
+	if (optind !=3D argc - 1) {
+		print_warning("too few options for metarestore (no filename "
+				"given)");
+		return 0;
+	}
+
+	if (strcmp(argv[optind], "-") =3D=3D 0) {
+		if (isatty(STDIN_FILENO)) {
+			print_warning("cannot read from a terminal");
+			return 0;
+		}
+		fd =3D STDIN_FILENO;
+	} else {
+		fd =3D open(argv[optind], O_RDONLY, 0666);
+		if (fd =3D=3D -1) {
+			print_warning("cannot open dump file");
+			return 0;
+		}
+	}
+
+	metablock =3D NULL;
+
+	exitcode =3D !perform_restore();
+
+	if (metablock !=3D NULL)
+		free(metablock);
+
+	if (fd !=3D STDIN_FILENO)
+		close(fd);
+
+	return 0;
+}
+

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/db/metadump.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/db/metadump.h	2007-02-13 17:29:33.000000000 +1100
+++ b/xfsprogs/db/metadump.h	2007-01-30 15:14:58.453299539 +1100
@@ -0,0 +1,19 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
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
+extern void	metadump_init(void);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/db/xfs_metadump.sh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/db/xfs_metadump.sh	2007-02-13 17:29:33.000000000 +1100
+++ b/xfsprogs/db/xfs_metadump.sh	2007-02-13 16:05:27.003359183 +1100
@@ -0,0 +1,37 @@
+#!/bin/sh -f
+#
+# Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+OPTS=3D" "
+DBOPTS=3D" "
+USAGE=3D"Usage: xfs_metadump [-efgwV] [-l logdev] source target"
+
+while getopts "efgl:wV" c
+do
+	case $c in
+	e)	OPTS=3D$OPTS"-e ";;
+	g)	OPTS=3D$OPTS"-g ";;
+	w)	OPTS=3D$OPTS"-w ";;
+	f)	DBOPTS=3D$DBOPTS" -f";;
+	l)	DBOPTS=3D$DBOPTS" -l "$OPTARG" ";;
+	V)	xfs_db -p xfs_metadump -V
+		status=3D$?
+		exit $status
+		;;
+	\?)	echo $USAGE 1>&2
+		exit 2
+		;;
+	esac
+done
+set -- extra $@
+shift $OPTIND
+case $# in
+	2)	xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1
+		status=3D$?
+		;;
+	*)	echo $USAGE 1>&2
+		exit 2
+		;;
+esac
+exit $status

------=_NextPart_000_008F_01C74F96.8FAF0850--
