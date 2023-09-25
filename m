Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E913BCE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjIYV7x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjIYV7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FCEAF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9024C433C9;
        Mon, 25 Sep 2023 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679186;
        bh=gdDgx1w4WjAuKmXTGg8Ftz4Gvw8pJM2EGaTMz0JaMr4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=djSK7Y5zmA/bLnVvzAp8B234/AhCAeEF3hK0254Lmt2ieuJKDtb/jMx93xcq/Yxqe
         08We+quv65f/0bnbKg0pPuRvkGooJHEAUVlWAuP436A9qvpe71ATAb8cDrM9722Dcj
         5f+a1yifeS6DHuhQnWXkdE38uIRBZb71TSYCN1Em1WWE2SGN9ajOSGx805e2+lXvfh
         IEQD4YQR2LAszWijjHYSRz1VgzhorlGCPQ2hisSD/Vdl8YwIAi0N6nsNKB3MGmIWLD
         WtCdiQzHNnbtIfD5JqZ4OlfwE07iWpVYaMmzziSMW358/tDOMNlZSyI2e8wZw75OMw
         BmjVSfAOw+/CQ==
Subject: [PATCH 1/2] xfs_db: dump unlinked buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:45 -0700
Message-ID: <169567918550.2320475.14440929570212364415.stgit@frogsfrogsfrogs>
In-Reply-To: <169567917992.2320475.10415003566794205537.stgit@frogsfrogsfrogs>
References: <169567917992.2320475.10415003566794205537.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new command to dump the resource usage of files in the unlinked
buckets.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/Makefile              |    2 
 db/command.c             |    1 
 db/command.h             |    1 
 db/iunlink.c             |  204 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   19 ++++
 6 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 db/iunlink.c


diff --git a/db/Makefile b/db/Makefile
index 2f95f67075d..d00801ab473 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h obfuscate.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c iunlink.c namei.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index 02f778b9316..2bbd7b0b24f 100644
--- a/db/command.c
+++ b/db/command.c
@@ -141,4 +141,5 @@ init_commands(void)
 	dquot_init();
 	fuzz_init();
 	timelimit_init();
+	iunlink_init();
 }
diff --git a/db/command.h b/db/command.h
index 498983ff92f..a89e71504f9 100644
--- a/db/command.h
+++ b/db/command.h
@@ -34,3 +34,4 @@ extern void		info_init(void);
 extern void		btheight_init(void);
 extern void		timelimit_init(void);
 extern void		namei_init(void);
+extern void		iunlink_init(void);
diff --git a/db/iunlink.c b/db/iunlink.c
new file mode 100644
index 00000000000..303b5dafb7d
--- /dev/null
+++ b/db/iunlink.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+
+static xfs_filblks_t
+count_rtblocks(
+	struct xfs_inode	*ip)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	xfs_filblks_t		count = 0;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	int			error;
+
+	error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	if (error) {
+		dbprintf(
+_("could not read AG %u agino %u extents, err=%d\n"),
+				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+				error);
+		return 0;
+	}
+
+	for_each_xfs_iext(ifp, &icur, &got)
+		if (!isnullstartblock(got.br_startblock))
+			count += got.br_blockcount;
+	return count;
+}
+
+static xfs_agino_t
+get_next_unlinked(
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	bool			verbose)
+{
+	struct xfs_buf		*ino_bp;
+	struct xfs_dinode	*dip;
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	xfs_agino_t		ret;
+	int			error;
+
+	ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	if (error)
+		goto bad;
+
+	if (verbose) {
+		xfs_filblks_t	blocks, rtblks = 0;
+
+		if (XFS_IS_REALTIME_INODE(ip))
+			rtblks = count_rtblocks(ip);
+		blocks = ip->i_nblocks - rtblks;
+
+		dbprintf(_(" blocks %llu rtblocks %llu\n"),
+				blocks, rtblks);
+	} else {
+		dbprintf("\n");
+	}
+
+	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
+	if (error)
+		goto bad;
+
+	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
+	ret = be32_to_cpu(dip->di_next_unlinked);
+	libxfs_buf_relse(ino_bp);
+
+	return ret;
+bad:
+	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
+	return NULLAGINO;
+}
+
+static void
+dump_unlinked_bucket(
+	xfs_agnumber_t	agno,
+	struct xfs_buf	*agi_bp,
+	unsigned int	bucket,
+	bool		quiet,
+	bool		verbose)
+{
+	struct xfs_agi	*agi = agi_bp->b_addr;
+	xfs_agino_t	agino;
+	unsigned int	i = 0;
+
+	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+	if (agino != NULLAGINO)
+		dbprintf(_("AG %u bucket %u agino %u"), agno, bucket, agino);
+	else if (!quiet && agino == NULLAGINO)
+		dbprintf(_("AG %u bucket %u agino NULL\n"), agno, bucket);
+
+	while (agino != NULLAGINO) {
+		agino = get_next_unlinked(agno, agino, verbose);
+		if (agino != NULLAGINO)
+			dbprintf(_("    [%u] agino %u"), i++, agino);
+		else if (!quiet && agino == NULLAGINO)
+			dbprintf(_("    [%u] agino NULL\n"), i++);
+	}
+}
+
+static void
+dump_unlinked(
+	struct xfs_perag	*pag,
+	unsigned int		bucket,
+	bool			quiet,
+	bool			verbose)
+{
+	struct xfs_buf		*agi_bp;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	int			error;
+
+	error = -libxfs_ialloc_read_agi(pag, NULL, &agi_bp);
+	if (error) {
+		dbprintf(_("AGI %u: %s\n"), agno, strerror(errno));
+		return;
+	}
+
+	if (bucket != -1U) {
+		dump_unlinked_bucket(agno, agi_bp, bucket, quiet, verbose);
+		goto relse;
+	}
+
+	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
+		dump_unlinked_bucket(agno, agi_bp, bucket, quiet, verbose);
+	}
+
+relse:
+	libxfs_buf_relse(agi_bp);
+}
+
+static int
+dump_iunlinked_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
+	unsigned int		bucket = -1U;
+	bool			quiet = false;
+	bool			verbose = false;
+	int			c;
+
+	while ((c = getopt(argc, argv, "a:b:qv")) != EOF) {
+		switch (c) {
+		case 'a':
+			agno = atoi(optarg);
+			if (agno >= mp->m_sb.sb_agcount) {
+				dbprintf(_("Unknown AG %u, agcount is %u.\n"),
+						agno, mp->m_sb.sb_agcount);
+				return 0;
+			}
+			break;
+		case 'b':
+			bucket = atoi(optarg);
+			if (bucket >= XFS_AGI_UNLINKED_BUCKETS) {
+				dbprintf(_("Unknown bucket %u, max is 63.\n"),
+						bucket);
+				return 0;
+			}
+			break;
+		case 'q':
+			quiet = true;
+			break;
+		case 'v':
+			verbose = true;
+			break;
+		default:
+			dbprintf(_("Bad option for dump_iunlinked command.\n"));
+			return 0;
+		}
+	}
+
+	if (agno != NULLAGNUMBER) {
+		struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
+
+		dump_unlinked(pag, bucket, quiet, verbose);
+		libxfs_perag_put(pag);
+		return 0;
+	}
+
+	for_each_perag(mp, agno, pag)
+		dump_unlinked(pag, bucket, quiet, verbose);
+
+	return 0;
+}
+
+static const cmdinfo_t	dump_iunlinked_cmd =
+	{ "dump_iunlinked", NULL, dump_iunlinked_f, 0, -1, 0,
+	  N_("[-a agno] [-b bucket] [-q] [-v]"),
+	  N_("dump chain of unlinked inode buckets"), NULL };
+
+void
+iunlink_init(void)
+{
+	add_command(&dump_iunlinked_cmd);
+}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 026aa510ca1..ddba5c7c71d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -125,6 +125,7 @@
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
+#define xfs_imap_to_bp			libxfs_imap_to_bp
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 60dcdc52cba..2d6d0da4d7b 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -579,6 +579,25 @@ print the current debug option bits. These are for the use of the implementor.
 .BI "dquot [" \-g | \-p | \-u ] " id"
 Set current address to a group, project or user quota block for the given ID. Defaults to user quota.
 .TP
+.BI "dump_iunlinked [-a " agno " ] [-b " bucket " ] [-q] [-v]"
+Dump the contents of unlinked buckets.
+
+Options include:
+.RS 1.0i
+.TP 0.4i
+.B \-a
+Print only this AG's unlinked buckets.
+.TP 0.4i
+.B \-b
+Print only this bucket within each AGI.
+.TP 0.4i
+.B \-q
+Only print the essentials.
+.TP 0.4i
+.B \-v
+Print resource usage of each file on the unlinked lists.
+.RE
+.TP
 .BI "echo [" arg "] ..."
 Echo the arguments to the output.
 .TP

