Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFBB37FE5
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB83C30408A
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rO1bELwcV2NrWI7o for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWY-0003wx-Iy
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWY-0001N8-Eq
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 44/48] xfs_db: add support for CRC format remote symlinks
Date: Fri,  7 Jun 2013 10:26:07 +1000
Message-Id: <1370564771-4929-45-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/Makefile  |    2 +-
 db/field.c   |    6 +++++
 db/field.h   |    4 +++
 db/symlink.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/symlink.h |   26 +++++++++++++++++++
 db/type.c    |    3 ++-
 6 files changed, 120 insertions(+), 2 deletions(-)
 create mode 100644 db/symlink.c
 create mode 100644 db/symlink.h

diff --git a/db/Makefile b/db/Makefile
index d331964..9485b82 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -12,7 +12,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
-	text.h type.h write.h attrset.h
+	text.h type.h write.h attrset.h symlink.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/field.c b/db/field.c
index 26332f1..e4f6c7d 100644
--- a/db/field.c
+++ b/db/field.c
@@ -34,6 +34,7 @@
 #include "dquot.h"
 #include "dir2.h"
 #include "dir2sf.h"
+#include "symlink.h"
 
 const ftattr_t	ftattrtab[] = {
 	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
@@ -300,6 +301,11 @@ const ftattr_t	ftattrtab[] = {
 	  NULL, NULL },
 	{ FLDT_SB, "sb", NULL, (char *)sb_flds, sb_size, FTARG_SIZE, NULL,
 	  sb_flds },
+
+/* CRC enabled symlink */
+	{ FLDT_SYMLINK_CRC, "symlink", NULL, (char *)symlink_crc_flds,
+	  symlink_size, FTARG_SIZE, NULL, symlink_crc_flds },
+
 	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(__int32_t)), FTARG_SIGNED,
 	  NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
diff --git a/db/field.h b/db/field.h
index 9a12f1c..b97d917 100644
--- a/db/field.h
+++ b/db/field.h
@@ -150,6 +150,10 @@ typedef enum fldt	{
 	FLDT_QCNT,
 	FLDT_QWARNCNT,
 	FLDT_SB,
+
+	/* CRC enabled symlink */
+	FLDT_SYMLINK_CRC,
+
 	FLDT_TIME,
 	FLDT_TIMESTAMP,
 	FLDT_UINT1,
diff --git a/db/symlink.c b/db/symlink.c
new file mode 100644
index 0000000..9f3d0b9
--- /dev/null
+++ b/db/symlink.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2013 Red Hat, Inc.
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
+#include "type.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "bit.h"
+#include "init.h"
+
+
+/*
+ * XXX: no idea how to handle multiple contiguous block symlinks here.
+ */
+static int
+symlink_count(
+	void		*obj,
+	int		startoff)
+{
+	struct xfs_dsymlink_hdr	*hdr = obj;
+
+	ASSERT(startoff == 0);
+
+	if (hdr->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
+		return 0;
+	if (be32_to_cpu(hdr->sl_bytes) + sizeof(*hdr) > mp->m_sb.sb_blocksize)
+		return mp->m_sb.sb_blocksize - sizeof(*hdr);
+	return be32_to_cpu(hdr->sl_bytes);
+}
+
+int
+symlink_size(
+	void	*obj,
+	int	startoff,
+	int	idx)
+{
+	struct xfs_dsymlink_hdr	*hdr = obj;
+
+	ASSERT(startoff == 0);
+	if (hdr->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
+		return 0;
+	return be32_to_cpu(hdr->sl_bytes) + sizeof(*hdr);
+}
+
+const struct field	symlink_crc_hfld[] = {
+	{ "", FLDT_SYMLINK_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(struct xfs_dsymlink_hdr, sl_ ## f))
+#define	SZOF(f)	bitize(sizeof(struct xfs_dsymlink_hdr))
+const struct field	symlink_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_UINT32D, OI(OFF(offset)), C1, 0, TYP_NONE },
+	{ "bytes", FLDT_UINT32D, OI(OFF(bytes)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "data", FLDT_CHARNS, OI(bitize(sizeof(struct xfs_dsymlink_hdr))),
+		symlink_count, FLD_COUNT, TYP_NONE },
+	{ NULL }
+};
+
diff --git a/db/symlink.h b/db/symlink.h
new file mode 100644
index 0000000..86ca842
--- /dev/null
+++ b/db/symlink.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2013 Red Hat, Inc.
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
+#ifndef __XFS_DB_SYMLINK_H
+#define __XFS_DB_SYMLINK_H
+
+extern const struct field	symlink_crc_hfld[];
+extern const struct field	symlink_crc_flds[];
+
+extern int	symlink_size(void *obj, int startoff, int idx);
+
+#endif /* __XFS_DB_SYMLINK_H */
diff --git a/db/type.c b/db/type.c
index 80a584b..64e2ef4 100644
--- a/db/type.c
+++ b/db/type.c
@@ -38,6 +38,7 @@
 #include "dquot.h"
 #include "dir2.h"
 #include "text.h"
+#include "symlink.h"
 
 static const typ_t	*findtyp(char *name);
 static int		type_f(int argc, char **argv);
@@ -91,7 +92,7 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL },
 	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL },
 	{ TYP_SB, "sb", handle_struct, sb_hfld },
-	{ TYP_SYMLINK, "symlink", handle_string, NULL },
+	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld },
 	{ TYP_TEXT, "text", handle_text, NULL },
 	{ TYP_NONE, NULL }
 };
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
