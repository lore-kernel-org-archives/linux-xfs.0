Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE01584A6
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:45:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF61A8F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fEvs1qfCyetXIV7a (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:43 -0700 (PDT)
Subject: [PATCH 137/145] xfs_db: introduce the 'fsmap' command to find what
	owns a set of fsblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:45:09 -0700
Message-ID: <146612790910.16048.446600163243739830.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Introduce a new 'fsmap' command to the fs debugger that will query the
rmap btree to report the file/metadata extents mapped to a range of
physical blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile       |    2 -
 db/command.c      |    2 +
 db/fsmap.c        |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/fsmap.h        |   20 +++++++
 man/man8/xfs_db.8 |    9 +++
 5 files changed, 195 insertions(+), 1 deletion(-)
 create mode 100644 db/fsmap.c
 create mode 100644 db/fsmap.h


diff --git a/db/Makefile b/db/Makefile
index 8260da3..5adea48 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -12,7 +12,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
-	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h
+	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index 3c17a1e..278c357 100644
--- a/db/command.c
+++ b/db/command.c
@@ -49,6 +49,7 @@
 #include "write.h"
 #include "malloc.h"
 #include "dquot.h"
+#include "fsmap.h"
 
 cmdinfo_t	*cmdtab;
 int		ncmds;
@@ -128,6 +129,7 @@ init_commands(void)
 	echo_init();
 	frag_init();
 	freesp_init();
+	fsmap_init();
 	help_init();
 	hash_init();
 	inode_init();
diff --git a/db/fsmap.c b/db/fsmap.c
new file mode 100644
index 0000000..a9de401
--- /dev/null
+++ b/db/fsmap.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#include "fsmap.h"
+#include "output.h"
+#include "init.h"
+
+struct fsmap_info {
+	unsigned long long	nr;
+	xfs_agnumber_t		agno;
+};
+
+static int
+fsmap_fn(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct fsmap_info	*info = priv;
+
+	dbprintf(_("%llu: %u/%u len %u owner %lld offset %llu bmbt %d attrfork %d extflag %d\n"),
+		info->nr, info->agno, rec->rm_startblock,
+		rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+		!!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK),
+		!!(rec->rm_flags & XFS_RMAP_ATTR_FORK),
+		!!(rec->rm_flags & XFS_RMAP_UNWRITTEN));
+	info->nr++;
+
+	return 0;
+}
+
+int
+fsmap_f(
+	int			argc,
+	char			**argv)
+{
+	char			*p;
+	struct fsmap_info	info;
+	xfs_agnumber_t		start_ag;
+	xfs_agnumber_t		end_ag;
+	xfs_agnumber_t		agno;
+	xfs_fsblock_t		start_fsb = 0;
+	xfs_fsblock_t		end_fsb = NULLFSBLOCK;
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
+	struct xfs_btree_cur	*bt_cur;
+	struct xfs_buf		*agbp;
+	int			c;
+	xfs_daddr_t		eofs;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		dbprintf(_("Filesystem does not support reverse mapping btree.\n"));
+		return 0;
+	}
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			dbprintf(_("Bad option for fsmap command.\n"));
+			return 0;
+		}
+	}
+
+	if (argc > optind) {
+		start_fsb = strtoull(argv[optind], &p, 0);
+		if (*p != '\0' || start_fsb >= mp->m_sb.sb_dblocks) {
+			dbprintf(_("Bad fsmap start_fsb %s.\n"), argv[optind]);
+			return 0;
+		}
+	}
+
+	if (argc > optind + 1) {
+		end_fsb = strtoull(argv[optind + 1], &p, 0);
+		if (*p != '\0') {
+			dbprintf(_("Bad fsmap end_fsb %s.\n"), argv[optind + 1]);
+			return 0;
+		}
+	}
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (XFS_FSB_TO_DADDR(mp, end_fsb) >= eofs)
+		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
+
+	low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	low.rm_owner = 0;
+	low.rm_offset = 0;
+	low.rm_flags = 0;
+	high.rm_startblock = -1U;
+	high.rm_owner = ULLONG_MAX;
+	high.rm_offset = ULLONG_MAX;
+	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK | XFS_RMAP_UNWRITTEN;
+
+	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
+	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
+
+	info.nr = 0;
+	for (agno = start_ag; agno <= end_ag; agno++) {
+		if (agno == end_ag)
+			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
+
+		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+		if (error) {
+			dbprintf(_("Error %d while reading AGF.\n"), error);
+			return 0;
+		}
+
+		bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+		if (!bt_cur) {
+			libxfs_putbuf(agbp);
+			dbprintf(_("Not enough memory.\n"));
+			return 0;
+		}
+
+		info.agno = agno;
+		error = xfs_rmapbt_query_range(bt_cur, &low, &high,
+				fsmap_fn, &info);
+		if (error) {
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
+			libxfs_putbuf(agbp);
+			dbprintf(_("Error %d while querying fsmap btree.\n"),
+				error);
+			return 0;
+		}
+
+		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+		libxfs_putbuf(agbp);
+
+		if (agno == start_ag)
+			low.rm_startblock = 0;
+	}
+
+	return 0;
+}
+
+static const cmdinfo_t	fsmap_cmd =
+	{ "fsmap", NULL, fsmap_f, 0, 2, 0,
+	  N_("start_fsb [end_fsb]"),
+	  N_("display reverse mapping(s)"), NULL };
+
+void
+fsmap_init(void)
+{
+	add_command(&fsmap_cmd);
+}
diff --git a/db/fsmap.h b/db/fsmap.h
new file mode 100644
index 0000000..f8aacd3
--- /dev/null
+++ b/db/fsmap.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+extern void	fsmap_init(void);
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index b6d2f64..514e3aa 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -568,6 +568,15 @@ command to convert to and from this form. Block numbers given for file blocks
 .B bmap
 command) are in this form.
 .TP
+.BI "fsmap [ " start " ] [ " end " ]
+Prints the mapping of disk blocks used by an XFS filesystem.  The map
+lists each extent used by files, allocation group metadata,
+journalling logs, and static filesystem metadata, as well as any
+regions that are unused.  All blocks, offsets, and lengths are specified
+in units of 512-byte blocks, no matter what the filesystem's block size is.
+.BI "The optional " start " and " end " arguments can be used to constrain
+the output to a particular range of disk blocks.
+.TP
 .BI hash " string
 Prints the hash value of
 .I string

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
