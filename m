Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10417C2C6
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610203; cv=none; b=ZAhW7XSWmXHdQK5rUL45I9zhrQmgr/DIkof6Bo+Pwwdm2TRCp+Vef4mNSjed/KzLrQfzjwF0ubXWhESsP61fkA1Q3Ym327ZLdLr0cWK30mlA21iues3cGu9sfm/cF5+F456QCVKETwjov2Eht2gxKDwlWmTw8GELeaHwe1JFkYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610203; c=relaxed/simple;
	bh=SNORg21i68FR1fpHiNS0W/ZuUvi6cT2jyQP56CEEdaQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Smf46fF9Arn/9iNnTgRZrcK3ENHCOly9FI8t/p2aACuYgTStUhlhIFy5Z/f6bIRVPxZ/93A43Q5XLDfZm5I9/WjCTt9q1nr/v7mYtGHTML1t11FWFbYKhfNxTBmrA4VlVVJvAJeMn8Fkk8l8I2znO5qqKyNWqTQWNPrUfzR0kBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcxczYQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcxczYQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB70AC4CEC5;
	Fri, 11 Oct 2024 01:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610202;
	bh=SNORg21i68FR1fpHiNS0W/ZuUvi6cT2jyQP56CEEdaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pcxczYQ6IISQpLqzAmQGqWbVtGEKkHuRE+3t9kLC20lgMPzN7V4xmoTdqZOModQE4
	 Z7bW/FKHtNYKSV07YS2fYOKKYh8lZCzLgU3XGxOIqp12ScPmc8u9PphoCB9ysTulfE
	 3Ro2X5HxJE81H+y4gr+MpM4Hq3d6niFpOMxfYXXX16FNkLONqZn9F2CgFOOqkZ0Mz2
	 D6TZjo0AykY5YjxPgNthipa6IlrC6CYIgBmoe3azeLfxBBussMn1fIEOi8Ynv577Bg
	 DlUVjSMrKdR/UF/93AIR7PSeOGvt+qPH4YcXoPwSIWnCiclTBBzR8AetOJtMp3trek
	 TeHdmIFT/gffA==
Date: Thu, 10 Oct 2024 18:30:02 -0700
Subject: [PATCH 21/43] xfs_db: support dumping realtime group data and
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655688.4184637.8634307769802866984.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow dumping of realtime device superblocks and the new fields in the
primary superblock that were added for rtgroups support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/Makefile  |    1 +
 db/command.c |    2 +
 db/field.c   |   10 ++++++
 db/field.h   |    5 +++
 db/rtgroup.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/rtgroup.h |   15 +++++++++
 db/sb.c      |    8 +++++
 db/type.c    |    6 +++
 db/type.h    |    1 +
 9 files changed, 148 insertions(+)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h


diff --git a/db/Makefile b/db/Makefile
index 83389376c36c46..02eeead25b49d0 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -49,6 +49,7 @@ HFILES = \
 	output.h \
 	print.h \
 	quit.h \
+	rtgroup.h \
 	sb.h \
 	sig.h \
 	strvec.h \
diff --git a/db/command.c b/db/command.c
index 6cda03e9856d84..1b46c3fec08a0e 100644
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
index 946684415f65d3..f70955ef57a323 100644
--- a/db/field.c
+++ b/db/field.c
@@ -23,6 +23,7 @@
 #include "dir2.h"
 #include "dir2sf.h"
 #include "symlink.h"
+#include "rtgroup.h"
 
 #define	PPOFF(f)	bitize(offsetof(struct xfs_parent_rec, f))
 const field_t		parent_flds[] = {
@@ -52,6 +53,13 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_AGNUMBER, "agnumber", fp_num, "%u", SI(bitsz(xfs_agnumber_t)),
 	  FTARG_DONULL, NULL, NULL },
 
+	{ FLDT_RGBLOCK, "rgblock", fp_num, "%u", SI(bitsz(xfs_rgblock_t)),
+	  FTARG_DONULL, NULL, NULL },
+	{ FLDT_RTXLEN, "rtxlen", fp_num, "%u", SI(bitsz(xfs_rtxlen_t)),
+	  FTARG_DONULL, NULL, NULL },
+	{ FLDT_RGNUMBER, "rgnumber", fp_num, "%u", SI(bitsz(xfs_rgnumber_t)),
+	  FTARG_DONULL, NULL, NULL },
+
 /* attr fields */
 	{ FLDT_ATTR, "attr", NULL, (char *)attr_flds, attr_size, FTARG_SIZE,
 	  NULL, attr_flds },
@@ -357,6 +365,8 @@ const ftattr_t	ftattrtab[] = {
 	  NULL, NULL },
 	{ FLDT_SB, "sb", NULL, (char *)sb_flds, sb_size, FTARG_SIZE, NULL,
 	  sb_flds },
+	{ FLDT_RTSB, "rtsb", NULL, (char *)rtsb_flds, rtsb_size, FTARG_SIZE,
+	  NULL, rtsb_flds },
 
 /* CRC enabled symlink */
 	{ FLDT_SYMLINK_CRC, "symlink", NULL, (char *)symlink_crc_flds,
diff --git a/db/field.h b/db/field.h
index 9746676a6c7ac9..8797a75f669246 100644
--- a/db/field.h
+++ b/db/field.h
@@ -15,6 +15,10 @@ typedef enum fldt	{
 	FLDT_AGINONN,
 	FLDT_AGNUMBER,
 
+	FLDT_RGBLOCK,
+	FLDT_RTXLEN,
+	FLDT_RGNUMBER,
+
 	/* attr fields */
 	FLDT_ATTR,
 	FLDT_ATTR_BLKINFO,
@@ -167,6 +171,7 @@ typedef enum fldt	{
 	FLDT_QCNT,
 	FLDT_QWARNCNT,
 	FLDT_SB,
+	FLDT_RTSB,
 
 	/* CRC enabled symlink */
 	FLDT_SYMLINK_CRC,
diff --git a/db/rtgroup.c b/db/rtgroup.c
new file mode 100644
index 00000000000000..5cda1a4f35efb6
--- /dev/null
+++ b/db/rtgroup.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
+	{ "rtsb", NULL, rtsb_f, 0, 0, 1, "",
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
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(OFF(pad)), C1, 0, TYP_NONE },
+	{ "fname", FLDT_CHARNS, OI(OFF(fname)), CI(SZC(fname)), 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
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
+" seek to realtime superblock\n"
+"\n"
+" Example:\n"
+"\n"
+" 'rtsb - set location to realtime superblock, set type to 'rtsb'\n"
+"\n"
+" Located in the first block of the realtime volume, the rt superblock\n"
+" contains the base information for the realtime section of a filesystem.\n"
+"\n"
+));
+}
+
+static int
+rtsb_f(
+	int		argc,
+	char		**argv)
+{
+	int		c;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			rtsb_help();
+			return 0;
+		}
+	}
+
+	cur_agno = NULLAGNUMBER;
+
+	ASSERT(typtab[TYP_RTSB].typnm == TYP_RTSB);
+	set_rt_cur(&typtab[TYP_RTSB], XFS_RTSB_DADDR, XFS_FSB_TO_BB(mp, 1),
+			DB_RING_ADD, NULL);
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
index 00000000000000..85960a3fb9f5c9
--- /dev/null
+++ b/db/rtgroup.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
index 0d6076bc7ed408..9f9be6c4e149a9 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -124,8 +124,12 @@ const field_t	sb_flds[] = {
 	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
 	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)),
 		premetadirfld_count, FLD_COUNT, TYP_NONE },
+	{ "rgblklog", FLDT_UINT8D, OI(OFF(rgblklog)), metadirfld_count,
+		FLD_COUNT, TYP_NONE },
 	{ "metadirpad0", FLDT_UINT8X, OI(OFF(metadirpad0)), metadirfld_count,
 		FLD_COUNT, TYP_NONE },
+	{ "metadirpad1", FLDT_UINT16X, OI(OFF(metadirpad1)), metadirfld_count,
+		FLD_COUNT, TYP_NONE },
 	{ "features_compat", FLDT_UINT32X, OI(OFF(features_compat)),
 		C1, 0, TYP_NONE },
 	{ "features_ro_compat", FLDT_UINT32X, OI(OFF(features_ro_compat)),
@@ -141,6 +145,10 @@ const field_t	sb_flds[] = {
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ "metadirino", FLDT_INO, OI(OFF(metadirino)), metadirfld_count,
 	  FLD_COUNT, TYP_INODE },
+	{ "rgcount", FLDT_RGNUMBER, OI(OFF(rgcount)), metadirfld_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "rgextents", FLDT_RTXLEN, OI(OFF(rgextents)), metadirfld_count,
+	  FLD_COUNT, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/type.c b/db/type.c
index efe7044569d357..d875c0c636553b 100644
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
index 397dcf5464c6c8..d4efa4b0fab541 100644
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

