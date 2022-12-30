Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B052AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbiLaCgz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbiLaCgw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:36:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9EA2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA316CE1926
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CA1C433EF;
        Sat, 31 Dec 2022 02:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454207;
        bh=/UJAt3aDN+KetsuabRFFYXmajPC0LlxhxZqk9Ju4NW0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N7+dgSdHXh8D/YBXvxEom6TtPEzgXvaRTKqswshFAPdLNSZkEtTbPfOece/YRPrJj
         N+7vP6uRPhhRmVXQ0T2uyMpHKv6HMw75rhLvhyJOFPP/PCh9R2mc2uZjv158X3vi2P
         IenASN7NGvI/RKJuq7e3ekOXbZGa+qkxA8S/IKVHF2TZX/FEQ+LZavPI85bm8Su0BU
         IFLMhByVz1P7GhVsf9GVuWjFd8p1BZxtkbtpGHmJMI8PrM6hqPnXXTbOwUrkoI5Cuz
         CrteltCmzjo+ZniAsWqZhKmyym5f4M45UwgF3G8F9bbwcjfRzTMYOQ0f+YGc1n1nO6
         s7rMsNsNw8ooQ==
Subject: [PATCH 26/45] xfs_db: support dumping realtime superblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878702.731133.6316048528860784016.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow debugging of realtime superblocks, and add the relevant fields in
the fs superblock that point us at the existence and location of the rt
supers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/Makefile  |    2 +
 db/command.c |    2 +
 db/field.c   |    8 ++++
 db/field.h   |    4 ++
 db/rtgroup.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/rtgroup.h |   15 ++++++++
 db/sb.c      |   15 ++++++++
 db/type.c    |    6 +++
 db/type.h    |    1 +
 9 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h


diff --git a/db/Makefile b/db/Makefile
index dbe79a9a1b1..d22adc2d18d 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -13,7 +13,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
-	fuzz.h
+	fuzz.h rtgroup.h
 CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
 	timelimit.c bmap_inflate.c unlinked.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
diff --git a/db/command.c b/db/command.c
index be6d045a23a..f2b59709848 100644
--- a/db/command.c
+++ b/db/command.c
@@ -39,6 +39,7 @@
 #include "fsmap.h"
 #include "crc.h"
 #include "fuzz.h"
+#include "rtgroup.h"
 
 cmdinfo_t	*cmdtab;
 int		ncmds;
@@ -135,6 +136,7 @@ init_commands(void)
 	output_init();
 	print_init();
 	quit_init();
+	rtsb_init();
 	sb_init();
 	type_init();
 	write_init();
diff --git a/db/field.c b/db/field.c
index a3e47ee81cc..cee5c661595 100644
--- a/db/field.c
+++ b/db/field.c
@@ -23,6 +23,7 @@
 #include "dir2.h"
 #include "dir2sf.h"
 #include "symlink.h"
+#include "rtgroup.h"
 
 const ftattr_t	ftattrtab[] = {
 	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
@@ -44,6 +45,11 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_AGNUMBER, "agnumber", fp_num, "%u", SI(bitsz(xfs_agnumber_t)),
 	  FTARG_DONULL, NULL, NULL },
 
+	{ FLDT_RGBLOCK, "rgblock", fp_num, "%u", SI(bitsz(xfs_rgblock_t)),
+	  FTARG_DONULL, NULL, NULL },
+	{ FLDT_RGNUMBER, "rgnumber", fp_num, "%u", SI(bitsz(xfs_rgnumber_t)),
+	  FTARG_DONULL, NULL, NULL },
+
 /* attr fields */
 	{ FLDT_ATTR, "attr", NULL, (char *)attr_flds, attr_size, FTARG_SIZE,
 	  NULL, attr_flds },
@@ -347,6 +353,8 @@ const ftattr_t	ftattrtab[] = {
 	  NULL, NULL },
 	{ FLDT_SB, "sb", NULL, (char *)sb_flds, sb_size, FTARG_SIZE, NULL,
 	  sb_flds },
+	{ FLDT_RTSB, "rtsb", NULL, (char *)rtsb_flds, rtsb_size, FTARG_SIZE,
+	  NULL, rtsb_flds },
 
 /* CRC enabled symlink */
 	{ FLDT_SYMLINK_CRC, "symlink", NULL, (char *)symlink_crc_flds,
diff --git a/db/field.h b/db/field.h
index 634742a572c..226753490ad 100644
--- a/db/field.h
+++ b/db/field.h
@@ -15,6 +15,9 @@ typedef enum fldt	{
 	FLDT_AGINONN,
 	FLDT_AGNUMBER,
 
+	FLDT_RGBLOCK,
+	FLDT_RGNUMBER,
+
 	/* attr fields */
 	FLDT_ATTR,
 	FLDT_ATTR_BLKINFO,
@@ -166,6 +169,7 @@ typedef enum fldt	{
 	FLDT_QCNT,
 	FLDT_QWARNCNT,
 	FLDT_SB,
+	FLDT_RTSB,
 
 	/* CRC enabled symlink */
 	FLDT_SYMLINK_CRC,
diff --git a/db/rtgroup.c b/db/rtgroup.c
new file mode 100644
index 00000000000..c4debc1d394
--- /dev/null
+++ b/db/rtgroup.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxlog.h"
+#include "command.h"
+#include "type.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "io.h"
+#include "sb.h"
+#include "bit.h"
+#include "output.h"
+#include "init.h"
+#include "rtgroup.h"
+
+#define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
+
+static int	rtsb_f(int argc, char **argv);
+static void     rtsb_help(void);
+
+static const cmdinfo_t	rtsb_cmd =
+	{ "rtsb", NULL, rtsb_f, 0, 1, 1, N_("[rgno]"),
+	  N_("set current address to realtime sb header"), rtsb_help };
+
+void
+rtsb_init(void)
+{
+	if (xfs_has_rtgroups(mp))
+		add_command(&rtsb_cmd);
+}
+
+#define	OFF(f)	bitize(offsetof(struct xfs_rtsb, rsb_ ## f))
+#define	SZC(f)	szcount(struct xfs_rtsb, rsb_ ## f)
+const field_t	rtsb_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magicnum)), C1, 0, TYP_NONE },
+	{ "blocksize", FLDT_UINT32D, OI(OFF(blocksize)), C1, 0, TYP_NONE },
+	{ "rblocks", FLDT_DRFSBNO, OI(OFF(rblocks)), C1, 0, TYP_NONE },
+	{ "rextents", FLDT_DRTBNO, OI(OFF(rextents)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	{ "rextsize", FLDT_AGBLOCK, OI(OFF(rextsize)), C1, 0, TYP_NONE },
+	{ "rgblocks", FLDT_RGBLOCK, OI(OFF(rgblocks)), C1, 0, TYP_NONE },
+	{ "rgcount", FLDT_RGNUMBER, OI(OFF(rgcount)), C1, 0, TYP_NONE },
+	{ "rbmblocks", FLDT_EXTLEN, OI(OFF(rbmblocks)), C1, 0, TYP_NONE },
+	{ "fname", FLDT_CHARNS, OI(OFF(fname)), CI(SZC(fname)), 0, TYP_NONE },
+	{ "blocklog", FLDT_UINT8D, OI(OFF(blocklog)), C1, 0, TYP_NONE },
+	{ "sectlog", FLDT_UINT8D, OI(OFF(sectlog)), C1, 0, TYP_NONE },
+	{ "rextslog", FLDT_UINT8D, OI(OFF(rextslog)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+const field_t	rtsb_hfld[] = {
+	{ "", FLDT_RTSB, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+static void
+rtsb_help(void)
+{
+	dbprintf(_(
+"\n"
+" set realtime group superblock\n"
+"\n"
+" Example:\n"
+"\n"
+" 'rtsb 7' - set location to 7th realtime group superblock, set type to 'rtsb'\n"
+"\n"
+" Located in the first block of each realtime group, the rt superblock\n"
+" contains the base information for the realtime section of a filesystem.\n"
+" The superblock in allocation group 0 is the primary.  The copies in the\n"
+" remaining realtime groups only serve as backup for filesystem recovery.\n"
+"\n"
+));
+}
+
+static int
+rtsb_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_rtblock_t	rtbno;
+	xfs_rgnumber_t	rgno = 0;
+	char		*p;
+
+	if (argc > 1) {
+		rgno = (xfs_rgnumber_t)strtoul(argv[1], &p, 0);
+		if (*p != '\0' || rgno >= mp->m_sb.sb_rgcount) {
+			dbprintf(_("bad realtime group number %s\n"), argv[1]);
+			return 0;
+		}
+	}
+	cur_agno = NULLAGNUMBER;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+
+	ASSERT(typtab[TYP_RTSB].typnm == TYP_RTSB);
+	set_rt_cur(&typtab[TYP_RTSB], xfs_rtb_to_daddr(mp, rtbno),
+			XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+	return 0;
+}
+
+int
+rtsb_size(
+	void	*obj,
+	int	startoff,
+	int	idx)
+{
+	return bitize(mp->m_sb.sb_blocksize);
+}
diff --git a/db/rtgroup.h b/db/rtgroup.h
new file mode 100644
index 00000000000..49077bee141
--- /dev/null
+++ b/db/rtgroup.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef DB_RTGROUP_H_
+#define DB_RTGROUP_H_
+
+extern const struct field	rtsb_flds[];
+extern const struct field	rtsb_hfld[];
+
+extern void	rtsb_init(void);
+extern int	rtsb_size(void *obj, int startoff, int idx);
+
+#endif /* DB_RTGROUP_H_ */
diff --git a/db/sb.c b/db/sb.c
index d7df55e02e9..fa0706d3676 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -74,6 +74,17 @@ rootino_count(
 	return xfs_has_metadir(mp) ? 0 : 1;
 }
 
+/*
+ * Counts superblock fields that only exist when realtime groups are enabled.
+ */
+static int
+rtgroups_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_rtgroups(mp) ? 1 : 0;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -91,6 +102,10 @@ const field_t	sb_flds[] = {
 	  TYP_INODE },
 	{ "rsumino", FLDT_INO, OI(OFF(rsumino)), rootino_count, FLD_COUNT,
 	  TYP_INODE },
+	{ "rgblocks", FLDT_RGBLOCK, OI(OFF(rgblocks)), rtgroups_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "rgcount", FLDT_RGNUMBER, OI(OFF(rgcount)), rtgroups_count,
+	  FLD_COUNT, TYP_NONE },
 	{ "rextsize", FLDT_AGBLOCK, OI(OFF(rextsize)), C1, 0, TYP_NONE },
 	{ "agblocks", FLDT_AGBLOCK, OI(OFF(agblocks)), C1, 0, TYP_NONE },
 	{ "agcount", FLDT_AGNUMBER, OI(OFF(agcount)), C1, 0, TYP_NONE },
diff --git a/db/type.c b/db/type.c
index efe7044569d..d875c0c6365 100644
--- a/db/type.c
+++ b/db/type.c
@@ -28,6 +28,7 @@
 #include "text.h"
 #include "symlink.h"
 #include "fuzz.h"
+#include "rtgroup.h"
 
 static const typ_t	*findtyp(char *name);
 static int		type_f(int argc, char **argv);
@@ -60,6 +61,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTSB, "rtsb", handle_struct, rtsb_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
@@ -102,6 +104,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTSB, "rtsb", handle_struct, rtsb_hfld, &xfs_rtsb_buf_ops,
+		XFS_SB_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
 		XFS_SB_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
@@ -146,6 +150,8 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTSB, "rtsb", handle_struct, rtsb_hfld, &xfs_rtsb_buf_ops,
+		XFS_SB_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
 		XFS_SB_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
diff --git a/db/type.h b/db/type.h
index 397dcf5464c..d4efa4b0fab 100644
--- a/db/type.h
+++ b/db/type.h
@@ -30,6 +30,7 @@ typedef enum typnm
 	TYP_LOG,
 	TYP_RTBITMAP,
 	TYP_RTSUMMARY,
+	TYP_RTSB,
 	TYP_SB,
 	TYP_SYMLINK,
 	TYP_TEXT,

