Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28188 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdGaVHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2017 17:07:19 -0400
Subject: [PATCH 4/7] xfs_db: dump dir/attr btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Jul 2017 14:07:13 -0700
Message-ID: <150153523353.26081.1989249017494623271.stgit@magnolia>
In-Reply-To: <150153520589.26081.8786864874176090813.stgit@magnolia>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Dump the directory or extended attribute btree contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/btdump.c       |  251 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    1 
 2 files changed, 252 insertions(+)


diff --git a/db/btdump.c b/db/btdump.c
index 3b76e17..e351202 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -227,6 +227,252 @@ dump_inode(
 	return ret;
 }
 
+static bool
+dir_has_rightsib(
+	void				*block,
+	int				level)
+{
+	struct xfs_dir3_icleaf_hdr	lhdr;
+	struct xfs_da3_icnode_hdr	nhdr;
+
+	if (level > 0) {
+		M_DIROPS(mp)->node_hdr_from_disk(&nhdr, block);
+		return nhdr.forw != 0;
+	}
+	M_DIROPS(mp)->leaf_hdr_from_disk(&lhdr, block);
+	return lhdr.forw != 0;
+}
+
+static int
+dir_level(
+	void				*block)
+{
+	struct xfs_dir3_icleaf_hdr	lhdr;
+	struct xfs_da3_icnode_hdr	nhdr;
+
+	switch (((struct xfs_da_intnode *)block)->hdr.info.magic) {
+	case cpu_to_be16(XFS_DIR2_LEAF1_MAGIC):
+	case cpu_to_be16(XFS_DIR2_LEAFN_MAGIC):
+		M_DIROPS(mp)->leaf_hdr_from_disk(&lhdr, block);
+		return 0;
+	case cpu_to_be16(XFS_DA_NODE_MAGIC):
+		M_DIROPS(mp)->node_hdr_from_disk(&nhdr, block);
+		return nhdr.level;
+	default:
+		return -1;
+	}
+}
+
+static int
+dir3_level(
+	void				*block)
+{
+	struct xfs_dir3_icleaf_hdr	lhdr;
+	struct xfs_da3_icnode_hdr	nhdr;
+
+	switch (((struct xfs_da_intnode *)block)->hdr.info.magic) {
+	case cpu_to_be16(XFS_DIR3_LEAF1_MAGIC):
+	case cpu_to_be16(XFS_DIR3_LEAFN_MAGIC):
+		M_DIROPS(mp)->leaf_hdr_from_disk(&lhdr, block);
+		return 0;
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		M_DIROPS(mp)->node_hdr_from_disk(&nhdr, block);
+		return nhdr.level;
+	default:
+		return -1;
+	}
+}
+
+static bool
+attr_has_rightsib(
+	void				*block,
+	int				level)
+{
+        struct xfs_attr_leafblock	lhdr;
+	struct xfs_da3_icnode_hdr	nhdr;
+
+	if (level > 0) {
+		M_DIROPS(mp)->node_hdr_from_disk(&nhdr, block);
+		return nhdr.forw != 0;
+	}
+	xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, &lhdr, block);
+	return lhdr.hdr.info.forw != 0;
+}
+
+static int
+attr_level(
+	void				*block)
+{
+        struct xfs_attr_leafblock	lhdr;
+	struct xfs_da3_icnode_hdr	nhdr;
+
+	switch (((struct xfs_da_intnode *)block)->hdr.info.magic) {
+	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
+		xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, &lhdr, block);
+		return 0;
+	case cpu_to_be16(XFS_DA_NODE_MAGIC):
+		M_DIROPS(mp)->node_hdr_from_disk(&nhdr, block);
+		return nhdr.level;
+	default:
+		return -1;
+	}
+}
+
+static int
+attr3_level(
+	void				*block)
+{
+        struct xfs_attr_leafblock	lhdr;
+	struct xfs_da3_icnode_hdr	nhdr;
+
+	switch (((struct xfs_da_intnode *)block)->hdr.info.magic) {
+	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+		xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, &lhdr, block);
+		return 0;
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		M_DIROPS(mp)->node_hdr_from_disk(&nhdr, block);
+		return nhdr.level;
+	default:
+		return -1;
+	}
+}
+
+struct dabprinter {
+	const char		*print_node_entries;
+	const char		*print_leaf_entries;
+	const char		*go_node_forward;
+	const char		*go_leaf_forward;
+	const char		*go_down;
+	bool			(*has_rightsib)(void *, int);
+	int			(*level)(void *);
+};
+
+static struct dabprinter attr_print = {
+	.print_node_entries	= "btree",
+	.print_leaf_entries	= "entries nvlist",
+	.go_node_forward	= "hdr.info.forw",
+	.go_leaf_forward	= "hdr.info.forw",
+	.go_down		= "btree[0].before",
+	.has_rightsib		= attr_has_rightsib,
+	.level			= attr_level,
+};
+
+static struct dabprinter attr3_print = {
+	.print_node_entries	= "btree",
+	.print_leaf_entries	= "entries nvlist",
+	.go_node_forward	= "hdr.info.hdr.forw",
+	.go_leaf_forward	= "hdr.info.hdr.forw",
+	.go_down		= "btree[0].before",
+	.has_rightsib		= attr_has_rightsib,
+	.level			= attr3_level,
+};
+
+static struct dabprinter dir_print = {
+	.print_node_entries	= "nbtree",
+	.print_leaf_entries	= "lents",
+	.go_node_forward	= "nhdr.info.hdr.forw",
+	.go_leaf_forward	= "lhdr.info.hdr.forw",
+	.go_down		= "nbtree[0].before",
+	.has_rightsib		= dir_has_rightsib,
+	.level			= dir_level,
+};
+
+static struct dabprinter dir3_print = {
+	.print_node_entries	= "nbtree",
+	.print_leaf_entries	= "lents",
+	.go_node_forward	= "nhdr.info.forw",
+	.go_leaf_forward	= "lhdr.info.forw",
+	.go_down		= "nbtree[0].before",
+	.has_rightsib		= dir_has_rightsib,
+	.level			= dir3_level,
+};
+
+static int
+dump_dablevel(
+	int			level,
+	struct dabprinter	*dbp)
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
+		ret = eval("print %s", level > 0 ? dbp->print_node_entries :
+						   dbp->print_leaf_entries);
+		if (ret)
+			goto err;
+		if (dbp->has_rightsib(iocur_top->data, level)) {
+			ret = eval("addr %s", level > 0 ? dbp->go_node_forward :
+							  dbp->go_leaf_forward);
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
+dump_dabtree(
+	bool				dump_node_blocks,
+	struct dabprinter		*dbp)
+{
+	xfs_daddr_t			orig_daddr = iocur_top->bb;
+	xfs_daddr_t			last_daddr;
+	int				level;
+	int				ret;
+
+	ret = eval("push");
+	if (ret)
+		return ret;
+
+	cur_agno = XFS_FSB_TO_AGNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
+	level = dbp->level(iocur_top->data);
+	if (level < 0) {
+		printf(_("Current location is not part of a dir/attr btree.\n"));
+		goto err;
+	}
+
+	do {
+		last_daddr = iocur_top->bb;
+		if (level > 0) {
+			if (dump_node_blocks) {
+				ret = dump_dablevel(level, dbp);
+				if (ret)
+					goto err;
+			}
+			ret = eval("addr %s", dbp->go_down);
+		} else {
+			ret = dump_dablevel(level, dbp);
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
 static int
 btdump_f(
 	int		argc,
@@ -234,6 +480,7 @@ btdump_f(
 {
 	bool		aflag = false;
 	bool		iflag = false;
+	bool		crc = xfs_sb_version_hascrc(&mp->m_sb);
 	int		c;
 
 	if (cur_typ == NULL) {
@@ -276,6 +523,10 @@ btdump_f(
 		return dump_btree_long(iflag);
 	case TYP_INODE:
 		return dump_inode(iflag, aflag);
+	case TYP_ATTR:
+		return dump_dabtree(iflag, crc ? &attr3_print : &attr_print);
+	case TYP_DIR2:
+		return dump_dabtree(iflag, crc ? &dir3_print : &dir_print);
 	default:
 		dbprintf(_("type \"%s\" is not a btree type or inode\n"),
 				cur_typ->name);
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 6a97504..b3129f7 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -335,6 +335,7 @@ area of the inode, if neither option is given then both areas are shown.
 .B btdump [-a] [-i]
 If the cursor points to a btree node, dump the btree from that block downward.
 If instead the cursor points to an inode, dump the data fork block mapping btree if there is one.
+If the cursor points to a directory or extended attribute btree node, dump that.
 By default, only records stored in the btree are dumped.
 .RS 1.0i
 .TP 0.4i

