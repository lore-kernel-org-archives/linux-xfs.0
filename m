Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20838 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdDKOhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 10:37:43 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3BEbaqt007076
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 14:37:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v3BEbast004285
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 14:37:36 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v3BEbaA5025049
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 14:37:36 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [RFC PATCH v2] xfsprogs/db: add a command for dumping the btree blocks
Date: Tue, 11 Apr 2017 22:37:24 +0800
Message-Id: <1491921444-22784-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently there is no way to dump the whole blocks of btrees in the
xfs_db except manually step through the btree nodes, dumping the blocks
of the whole btree by a command is more convenient than interactive
walking of the tree in some circumstances.

This patch adds a new command to the xfs_db utility called 'treedump',
which can dump the specific btree or dump all btrees of the xfs, below
is an example usage of the command:

sudo xfs_db -r -c "agf 0" -c "addr bnoroot" -c "treedump" /dev/sda1

The blocks of the bnobt tree are dumped to the stdout.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 db/Makefile   |  10 +-
 db/command.c  |   2 +
 db/treedump.c | 361 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/treedump.h |  21 ++++
 4 files changed, 389 insertions(+), 5 deletions(-)
 create mode 100644 db/treedump.c
 create mode 100644 db/treedump.h

diff --git a/db/Makefile b/db/Makefile
index cdc0b99..81eb4c4 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -8,11 +8,11 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
-	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
-	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
-	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
-	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h
+	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h dir2.h \
+	dir2sf.h dquot.h echo.h faddr.h field.h flist.h fprint.h frag.h \
+	freesp.h hash.h help.h init.h inode.h input.h io.h logformat.h \
+	malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
+	text.h treedump.h type.h write.h attrset.h symlink.h fsmap.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index 3d7cfd7..73568b5 100644
--- a/db/command.c
+++ b/db/command.c
@@ -46,6 +46,7 @@
 #include "print.h"
 #include "quit.h"
 #include "sb.h"
+#include "treedump.h"
 #include "write.h"
 #include "malloc.h"
 #include "dquot.h"
@@ -143,6 +144,7 @@ init_commands(void)
 	print_init();
 	quit_init();
 	sb_init();
+	treedump_init();
 	type_init();
 	write_init();
 	dquot_init();
diff --git a/db/treedump.c b/db/treedump.c
new file mode 100644
index 0000000..ee728da
--- /dev/null
+++ b/db/treedump.c
@@ -0,0 +1,361 @@
+/*
+ * Copyright (c) 2017 Oracle.
+ * All Rights Reserved.
+ *
+ * Author: Shan Hai <shan.hai@oracle.com>
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
+#include "libxfs.h"
+#include "command.h"
+#include "io.h"
+#include "type.h"
+#include "fprint.h"
+#include "faddr.h"
+#include "field.h"
+#include "input.h"
+#include "output.h"
+#include "init.h"
+
+static int
+treedump_f(
+	int			argc,
+	char			**argv);
+
+static void
+dump_level(
+	xfs_agnumber_t		agno,
+	struct xfs_btree_block  *block);
+
+static void
+dump_leaves(
+	xfs_agnumber_t		agno,
+	struct xfs_btree_block	*block);
+
+static void
+dump_btree(
+	xfs_agnumber_t		agno,
+	struct xfs_btree_block	*block);
+
+static void treedump_help(void);
+
+static const cmdinfo_t	treedump_cmd =
+	{ "treedump", NULL, treedump_f, 0, 2, 0,
+	  N_("[-d] [-a]"),
+	  N_("dump the btree blocks"), treedump_help };
+
+static void
+treedump_help(void)
+{
+	dbprintf(_(
+"\n"
+" 'treedump' prints the blocks of the specified filesystem btree\n"
+"\n"
+" Examples:\n"
+"\n"
+" agf agfno\n"
+" addr bnoroot\n"
+" treedump\n"
+"\n"
+" inode ino\n"
+" treedump -d (data fork)\n"
+" treedump -a (attr fork)\n"
+"\n"
+));
+
+}
+
+static void run_command(char *str)
+{
+	int	c;
+	char	**argv;
+	char	cmd[1024];
+
+	strcpy(cmd, str);
+	argv = breakline(cmd, &c);
+	command(c, argv);
+}
+
+static void 
+dump_fork(int	whichfork)
+{
+	xfs_fsblock_t		fsbno;
+	xfs_dinode_t		*dip;
+	xfs_bmdr_block_t	*dib;
+	xfs_bmdr_key_t		*kp;
+	xfs_bmdr_ptr_t		*pp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			i;
+	
+	dip = iocur_top->data;
+	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
+	level = be16_to_cpu(dib->bb_level);
+	nrecs = be16_to_cpu(dib->bb_numrecs);
+	
+	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
+	if (maxrecs <= 0) {
+		dbprintf(_("an empty (%s) fork in inode %lld\n"),
+			(whichfork == XFS_DATA_FORK) ? "data" : "attr",
+			(long long)iocur_top->ino);
+		return;
+	}
+
+	if (nrecs > maxrecs) {
+		dbprintf(_("invalid numrecs (%u) in inode %lld\n"),
+			 nrecs, (long long)iocur_top->ino);
+		return;
+	}
+
+	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
+
+	dbprintf(_("level = %d\n"), level);
+	dbprintf(_("keys[1-%d] = [startoff] "), nrecs);
+	for (i = 1; i <= nrecs; i++) {
+		kp = XFS_BMDR_KEY_ADDR(dib, i);
+		dbprintf(_("%d:[%ld] "), i, be64_to_cpu(kp->br_startoff));
+	}
+
+	dbprintf(_("\nptrs[1-%d] = "), nrecs);
+	for (i = 0; i < nrecs; i++)
+		dbprintf(_("%d:%ld "), i+1, be64_to_cpu(pp[i]));
+
+	dbprintf(_("\n"));
+
+	push_cur();
+	for (i = 0; i < nrecs; i++) {
+		fsbno = be64_to_cpu(pp[i]);
+		set_cur(&typtab[TYP_BMAPBTD], XFS_FSB_TO_DADDR(mp, fsbno),
+			blkbb, DB_RING_IGN, NULL);
+		if (!iocur_top->data) {
+			dbprintf(_("cannot read fsblock %lu\n"), fsbno);
+			return;
+		}
+		dump_btree(cur_agno, iocur_top->data);
+	}
+	pop_cur();
+}
+
+/* ARGSUSED */
+static int
+treedump_f(
+	int	argc,
+	char	**argv)
+{
+	int	c;
+	int	whichfork = -1;
+
+	if (!iocur_top->data) {
+		dbprintf(_("no btree/inode \n"));
+		return 0;
+	}
+
+	/* btrees except inode data/attr fork */
+	if (cur_typ->typnm != TYP_INODE) {
+		dump_btree(cur_agno, iocur_top->data);
+		return 0;
+	}
+
+	/* below is for inode data/attr fork */
+	while ((c = getopt(argc, argv, "ad")) != EOF) {
+		switch (c) {
+		case 'a':
+			whichfork = XFS_ATTR_FORK;
+			break;
+		case 'd':
+			whichfork = XFS_DATA_FORK;
+			break;
+		default:
+			dbprintf(_("bad option for treedump command\n"));
+			return 0;
+		}
+	}
+
+	/* all/empty options */
+	if (argc > 2 || whichfork < 0) {
+		dump_fork(XFS_DATA_FORK);
+		dump_fork(XFS_ATTR_FORK);
+	} else {
+		dump_fork(whichfork);
+	}
+
+	return 0;
+}
+
+void
+treedump_init(void)
+{
+	add_command(&treedump_cmd);
+}
+
+static void dump_level(
+	xfs_agnumber_t		agno,
+	struct xfs_btree_block	*block)
+{
+	xfs_agblock_t	agbno;
+	const typ_t	*typ = cur_typ;
+
+	run_command("print level keys ptrs");
+
+	push_cur();
+	for (;;) {
+		agbno = be32_to_cpu(block->bb_u.s.bb_rightsib);
+		if (agbno == NULLAGBLOCK)
+			break;
+
+		set_cur(&typtab[typ->typnm], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			blkbb, DB_RING_IGN, NULL);
+
+		if (!iocur_top->data) {
+			dbprintf(_("cannot read block %u/%u\n"), agno, agbno);
+			return;
+		}
+
+		run_command("print keys ptrs");
+
+		block = iocur_top->data;
+		typ = cur_typ;
+	}
+	pop_cur();
+}
+
+static void dump_leaves(
+	xfs_agnumber_t		agno,
+	struct xfs_btree_block	*block)
+{
+	xfs_agblock_t	agbno;
+	const typ_t	*typ = cur_typ;
+
+	for (;;) {
+		run_command("print level recs");
+
+		agbno = be32_to_cpu(block->bb_u.s.bb_rightsib);
+		if (agbno == NULLAGBLOCK)
+			break;
+
+		set_cur(&typtab[typ->typnm], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			blkbb, DB_RING_IGN, NULL);
+
+		if (!iocur_top->data) {
+			dbprintf(_("cannot read block %u/%u\n"), agno, agbno);
+			return;
+		}
+
+		block = iocur_top->data;
+		typ = cur_typ;
+	}
+}
+
+static void
+dump_btree(
+	xfs_agnumber_t		agno,
+	struct xfs_btree_block	*block)
+{
+	int			i;
+	const typ_t		*typ = cur_typ;
+	xfs_agblock_t		agbno = -1;
+	int 			level = be16_to_cpu(block->bb_level);
+	xfs_alloc_ptr_t		*allocp;
+	xfs_inobt_ptr_t		*inobtp;
+	xfs_refcount_ptr_t	*refcntp;
+	xfs_rmap_ptr_t          *rmapp;
+
+	int			magic;
+
+	for (i = level; i > 0; i--) {
+		dump_level(agno, block);
+
+		agbno = be32_to_cpu(block->bb_u.s.bb_leftsib);
+		if (agbno == NULLAGBLOCK)
+			break;
+
+		set_cur(&typtab[typ->typnm], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			blkbb, DB_RING_IGN, NULL);
+
+		if (!iocur_top->data) {
+			dbprintf(_("cannot read block %u/%u\n"), agno, agbno);
+			return;
+		}
+
+		block = iocur_top->data;
+		typ = cur_typ;
+	}
+
+	level = be16_to_cpu(block->bb_level);
+	magic = be32_to_cpu(block->bb_magic);
+
+	switch (magic) {
+	case XFS_ABTB_MAGIC:
+	case XFS_ABTB_CRC_MAGIC:
+	case XFS_ABTC_MAGIC:
+	case XFS_ABTC_CRC_MAGIC:
+		allocp = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
+		agbno = be32_to_cpu(allocp[0]);
+		if (level > 0)
+			set_cur(&typtab[TYP_BNOBT],
+				XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb,
+				DB_RING_IGN, NULL);
+		break;
+	case XFS_BMAP_MAGIC:
+	case XFS_BMAP_CRC_MAGIC:
+		/* nothing */
+		break;
+	case XFS_FIBT_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+		inobtp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
+		agbno = be32_to_cpu(inobtp[0]);
+		if (level > 0)
+			set_cur(&typtab[TYP_INOBT],
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				blkbb, DB_RING_IGN, NULL);
+		break;
+	case XFS_IBT_MAGIC:
+	case XFS_IBT_CRC_MAGIC:
+		inobtp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
+		agbno = be32_to_cpu(inobtp[0]);
+		if (level > 0)
+			set_cur(&typtab[TYP_INOBT],
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				blkbb, DB_RING_IGN, NULL);
+		break;
+	case XFS_REFC_CRC_MAGIC:
+		refcntp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
+		agbno = be32_to_cpu(refcntp[0]);
+		if (level > 0)
+			set_cur(&typtab[TYP_REFCBT],
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				blkbb, DB_RING_IGN, NULL);
+		break;
+	case XFS_RMAP_CRC_MAGIC:
+		rmapp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
+		agbno = be32_to_cpu(rmapp[0]);
+		if (level > 0)
+			set_cur(&typtab[TYP_RMAPBT],
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				blkbb, DB_RING_IGN, NULL);
+		break;
+	default:
+		dbprintf(_("bad magic number %u\n"), magic);
+		return;
+	}
+
+	if (!iocur_top->data) {
+		dbprintf(_("cannot read block %u/%u\n"), agno, agbno);
+		return;
+	}
+	
+	dump_leaves(agno, iocur_top->data);
+}
diff --git a/db/treedump.h b/db/treedump.h
new file mode 100644
index 0000000..b8f31e4
--- /dev/null
+++ b/db/treedump.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (c) 2017 Oracle.
+ * All Rights Reserved.
+ *
+ * Author: Shan Hai <shan.hai@oracle.com>
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
+extern void	treedump_init(void);
-- 
2.7.4

