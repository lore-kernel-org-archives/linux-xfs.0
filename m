Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30027 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937001AbdDZUga (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 16:36:30 -0400
Date: Wed, 26 Apr 2017 13:36:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/4] xfs_db: dump metadata btrees via 'btdump'
Message-ID: <20170426203624.GA23371@birch.djwong.org>
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186448580.32572.11952289934147703634.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149186448580.32572.11952289934147703634.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Introduce a new 'btdump' command that can print the contents of all
blocks of any metadata subtree in the filesystem.  This enables
developers and forensic analyst to view a metadata structure without
having to navigate the btree manually.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: various documentation and error message fixes
---
 db/Makefile       |    2 
 db/btdump.c       |  294 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |    1 
 db/command.h      |    2 
 man/man8/xfs_db.8 |   13 ++
 5 files changed, 311 insertions(+), 1 deletion(-)
 create mode 100644 db/btdump.c

diff --git a/db/Makefile b/db/Makefile
index cdc0b99..6618bff 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -13,7 +13,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h
-CFILES = $(HFILES:.h=.c)
+CFILES = $(HFILES:.h=.c) btdump.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/btdump.c b/db/btdump.c
new file mode 100644
index 0000000..3b76e17
--- /dev/null
+++ b/db/btdump.c
@@ -0,0 +1,294 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+#include "io.h"
+#include "type.h"
+#include "input.h"
+
+static void
+btdump_help(void)
+{
+	dbprintf(_(
+"\n"
+" If the cursor points to a btree block, 'btdump' dumps the btree\n"
+" downward from that block.  If the cursor points to an inode,\n"
+" the data fork btree root is selected by default.\n"
+"\n"
+" Options:\n"
+"   -a -- Display an inode's extended attribute fork btree.\n"
+"   -i -- Print internal btree nodes.\n"
+"\n"
+));
+
+}
+
+static int
+eval(
+	const char	*fmt, ...)
+{
+	va_list		ap;
+	char		buf[PATH_MAX];
+	char		**v;
+	int		c;
+	int		ret;
+
+	va_start(ap, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+
+	v = breakline(buf, &c);
+	ret = command(c, v);
+	free(v);
+	return ret;
+}
+
+static bool
+btblock_has_rightsib(
+	struct xfs_btree_block	*block,
+	bool			long_format)
+{
+	if (long_format)
+		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
+	return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
+}
+
+static int
+dump_btlevel(
+	int			level,
+	bool			long_format)
+{
+	xfs_daddr_t		orig_daddr = iocur_top->bb;
+	xfs_daddr_t		last_daddr;
+	unsigned int		nr;
+	int			ret;
+
+	ret = eval("push");
+	if (ret)
+		return ret;
+
+	nr = 1;
+	do {
+		last_daddr = iocur_top->bb;
+		dbprintf(_("%s level %u block %u daddr %llu\n"),
+			 iocur_top->typ->name, level, nr, last_daddr);
+		if (level > 0) {
+			ret = eval("print keys");
+			if (ret)
+				goto err;
+			ret = eval("print ptrs");
+		} else {
+			ret = eval("print recs");
+		}
+		if (ret)
+			goto err;
+		if (btblock_has_rightsib(iocur_top->data, long_format)) {
+			ret = eval("addr rightsib");
+			if (ret)
+				goto err;
+		}
+		nr++;
+	} while (iocur_top->bb != orig_daddr && iocur_top->bb != last_daddr);
+
+	ret = eval("pop");
+	return ret;
+err:
+	eval("pop");
+	return ret;
+}
+
+static int
+dump_btree(
+	bool		dump_node_blocks,
+	bool		long_format)
+{
+	xfs_daddr_t	orig_daddr = iocur_top->bb;
+	xfs_daddr_t	last_daddr;
+	int		level;
+	int		ret;
+
+	ret = eval("push");
+	if (ret)
+		return ret;
+
+	cur_agno = XFS_FSB_TO_AGNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
+	level = xfs_btree_get_level(iocur_top->data);
+	do {
+		last_daddr = iocur_top->bb;
+		if (level > 0) {
+			if (dump_node_blocks) {
+				ret = dump_btlevel(level, long_format);
+				if (ret)
+					goto err;
+			}
+			ret = eval("addr ptrs[1]");
+		} else {
+			ret = dump_btlevel(level, long_format);
+		}
+		if (ret)
+			goto err;
+		level--;
+	} while (level >= 0 &&
+		 iocur_top->bb != orig_daddr &&
+		 iocur_top->bb != last_daddr);
+
+	ret = eval("pop");
+	return ret;
+err:
+	eval("pop");
+	return ret;
+}
+
+static inline int dump_btree_short(bool dump_node_blocks)
+{
+	return dump_btree(dump_node_blocks, false);
+}
+
+static inline int dump_btree_long(bool dump_node_blocks)
+{
+	return dump_btree(dump_node_blocks, true);
+}
+
+static int
+dump_inode(
+	bool			dump_node_blocks,
+	bool			attrfork)
+{
+	char			*prefix;
+	struct xfs_dinode	*dip;
+	int			ret;
+
+	if (attrfork)
+		prefix = "a.bmbt";
+	else if (xfs_sb_version_hascrc(&mp->m_sb))
+		prefix = "u3.bmbt";
+	else
+		prefix = "u.bmbt";
+
+	dip = iocur_top->data;
+	if (attrfork) {
+		if (!dip->di_anextents ||
+		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
+			dbprintf(_("attr fork not in btree format\n"));
+			return 0;
+		}
+	} else {
+		if (!dip->di_nextents ||
+		    dip->di_format != XFS_DINODE_FMT_BTREE) {
+			dbprintf(_("data fork not in btree format\n"));
+			return 0;
+		}
+	}
+
+	ret = eval("push");
+	if (ret)
+		return ret;
+
+	if (dump_node_blocks) {
+		ret = eval("print %s.keys", prefix);
+		if (ret)
+			goto err;
+		ret = eval("print %s.ptrs", prefix);
+		if (ret)
+			goto err;
+	}
+
+	ret = eval("addr %s.ptrs[1]", prefix);
+	if (ret)
+		goto err;
+
+	ret = dump_btree_long(dump_node_blocks);
+	if (ret)
+		goto err;
+
+	ret = eval("pop");
+	return ret;
+err:
+	eval("pop");
+	return ret;
+}
+
+static int
+btdump_f(
+	int		argc,
+	char		**argv)
+{
+	bool		aflag = false;
+	bool		iflag = false;
+	int		c;
+
+	if (cur_typ == NULL) {
+		dbprintf(_("no current type\n"));
+		return 0;
+	}
+	while ((c = getopt(argc, argv, "ai")) != EOF) {
+		switch (c) {
+		case 'a':
+			aflag = true;
+			break;
+		case 'i':
+			iflag = true;
+			break;
+		default:
+			dbprintf(_("bad option for btdump command\n"));
+			return 0;
+		}
+	}
+
+	if (optind != argc) {
+		dbprintf(_("bad options for btdump command\n"));
+		return 0;
+	}
+	if (aflag && cur_typ->typnm != TYP_INODE) {
+		dbprintf(_("attrfork flag doesn't apply here\n"));
+		return 0;
+	}
+
+	switch (cur_typ->typnm) {
+	case TYP_BNOBT:
+	case TYP_CNTBT:
+	case TYP_INOBT:
+	case TYP_FINOBT:
+	case TYP_RMAPBT:
+	case TYP_REFCBT:
+		return dump_btree_short(iflag);
+	case TYP_BMAPBTA:
+	case TYP_BMAPBTD:
+		return dump_btree_long(iflag);
+	case TYP_INODE:
+		return dump_inode(iflag, aflag);
+	default:
+		dbprintf(_("type \"%s\" is not a btree type or inode\n"),
+				cur_typ->name);
+		return 0;
+	}
+}
+
+static const cmdinfo_t btdump_cmd =
+	{ "btdump", "b", btdump_f, 0, 2, 0, "[-a] [-i]",
+	  N_("dump btree"), btdump_help };
+
+void
+btdump_init(void)
+{
+	add_command(&btdump_cmd);
+}
diff --git a/db/command.c b/db/command.c
index 3d7cfd7..c90c85c 100644
--- a/db/command.c
+++ b/db/command.c
@@ -124,6 +124,7 @@ init_commands(void)
 	attrset_init();
 	block_init();
 	bmap_init();
+	btdump_init();
 	check_init();
 	convert_init();
 	crc_init();
diff --git a/db/command.h b/db/command.h
index 4d4807d..9b4ed2d 100644
--- a/db/command.h
+++ b/db/command.h
@@ -39,3 +39,5 @@ extern void		add_command(const cmdinfo_t *ci);
 extern int		command(int argc, char **argv);
 extern const cmdinfo_t	*find_command(const char *cmd);
 extern void		init_commands(void);
+
+extern void		btdump_init(void);
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index b1c341d..eafb602 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -332,6 +332,19 @@ and
 options are used to select the attribute or data
 area of the inode, if neither option is given then both areas are shown.
 .TP
+.B btdump [-a] [-i]
+If the cursor points to a btree node, dump the btree from that block downward.
+If instead the cursor points to an inode, dump the data fork block mapping btree if there is one.
+By default, only records stored in the btree are dumped.
+.RS 1.0i
+.TP 0.4i
+.B \-a
+If the cursor points at an inode, dump the extended attribute block mapping btree, if present.
+.TP
+.B \-i
+Dump all keys and pointers in intermediate btree nodes, and all records in leaf btree nodes.
+.RE
+.TP
 .B check
 See the
 .B blockget
