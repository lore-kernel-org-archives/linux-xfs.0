Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA60C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiLaAX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:23:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2EBE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:23:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D43261D26
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF013C433D2;
        Sat, 31 Dec 2022 00:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446234;
        bh=vGjuTmgAY7ciClEAtFodE2N1YeL1p3vF1T8IVqda+lI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DvxN1qW2o8FxLfMCKKxGEjl7xsz8pU9cFt2+P1yHH3wXWC3fgYHPQWQ01Z9EgIC6x
         RfK/I3zrKH+GZt6hZC4Cr/QitJ1tq6s0p3nLGoEGOLNku8Y3znQTfUm/7NH1sbDodz
         0uXkkewh1/eqsbxsqaMPVG5M8rHeoCRqiZ2hplk0RFMGyoW+WDkmrXTFPgGbh2Fqla
         6F+sL1eyEQO/sUJhzNUFdl8tCqYDmHPZGmTG7ypZs4FCEG6x7dKO57qI1DMOr0C1JG
         e6cSW/iDC7xKsJxJxnvPpQJtfw1DjjyFTkJK7+olT8wjNer9tmo8od1tuFsLKNRyAb
         Ho48ueI0c7lKQ==
Subject: [PATCH 1/1] xfs_db: dump unlinked buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:04 -0800
Message-ID: <167243868475.714425.16739756969268341840.stgit@magnolia>
In-Reply-To: <167243868463.714425.14936757185529800411.stgit@magnolia>
References: <167243868463.714425.14936757185529800411.stgit@magnolia>
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
---
 db/Makefile       |    2 -
 db/command.c      |    1 
 db/command.h      |    1 
 db/unlinked.c     |  204 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   19 +++++
 5 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 db/unlinked.c


diff --git a/db/Makefile b/db/Makefile
index de4ab1d4bf5..dbe79a9a1b1 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -15,7 +15,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
 CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
-	timelimit.c bmap_inflate.c
+	timelimit.c bmap_inflate.c unlinked.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
diff --git a/db/command.c b/db/command.c
index 88401ef5b44..be6d045a23a 100644
--- a/db/command.c
+++ b/db/command.c
@@ -142,4 +142,5 @@ init_commands(void)
 	fuzz_init();
 	timelimit_init();
 	bmapinflate_init();
+	unlinked_init();
 }
diff --git a/db/command.h b/db/command.h
index c35258a72a9..85be8b622f0 100644
--- a/db/command.h
+++ b/db/command.h
@@ -35,3 +35,4 @@ extern void		btheight_init(void);
 extern void		timelimit_init(void);
 extern void		namei_init(void);
 extern void		bmapinflate_init(void);
+extern void		unlinked_init(void);
diff --git a/db/unlinked.c b/db/unlinked.c
new file mode 100644
index 00000000000..5b7df811601
--- /dev/null
+++ b/db/unlinked.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+unlinked_f(
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
+			dbprintf(_("Bad option for unlinked command.\n"));
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
+static const cmdinfo_t	unlinked_cmd =
+	{ "unlinked", NULL, unlinked_f, 0, -1, 0,
+	  N_("[-a agno] [-b bucket] [-q] [-v]"),
+	  N_("dump chain of unlinked inode buckets"), NULL };
+
+void
+unlinked_init(void)
+{
+	add_command(&unlinked_cmd);
+}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index d67bf1e79da..43c7db5e225 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -959,6 +959,25 @@ Print the timestamps in the current locale's date and time format instead of
 raw seconds since the Unix epoch.
 .RE
 .TP
+.BI "unlinked [-a " agno " ] [-b " bucket " ] [-q] [-v]"
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
 .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
 Set the filesystem universally unique identifier (UUID).
 The filesystem UUID can be used by

