Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfBPAj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 19:39:29 -0500
Date: Fri, 15 Feb 2019 16:39:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: validate extent size hint parameters
Message-ID: <20190216003923.GV32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate extent and cow extent size hints that are passed to mkfs so
that we avoid formatting a filesystem that will never mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 46fd7c25..28d91253 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2222,6 +2222,66 @@ validate_rtextsize(
 	ASSERT(cfg->rtextblocks);
 }
 
+/* Validate the incoming extsize hint as if we were a file. */
+static void
+validate_extsize_hint(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	xfs_failaddr_t		fa;
+	bool			rt;
+	uint16_t		flags = 0;
+
+	rt = (cli->fsx.fsx_xflags & XFS_DIFLAG_RTINHERIT);
+
+	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
+		flags |= XFS_DIFLAG_EXTSIZE;
+
+	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
+			flags);
+	if (rt && fa == NULL)
+		fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize,
+				S_IFREG, flags | XFS_DIFLAG_REALTIME);
+	if (fa == NULL)
+		return;
+
+	if (rt && mp->m_sb.sb_rextsize > 1)
+		fprintf(stderr,
+	_("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
+				(long long)cli->fsx.fsx_extsize,
+				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
+				mp->m_sb.sb_rextsize);
+	else
+		fprintf(stderr,
+	_("illegal extent size hint %lld, must be less than %u.\n"),
+				(long long)cli->fsx.fsx_extsize,
+				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+	usage();
+}
+
+/* Validate the incoming CoW extsize hint as if we were a file. */
+static void
+validate_cowextsize_hint(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	xfs_failaddr_t		fa;
+	uint64_t		flags2 = 0;
+
+	if (cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE)
+		flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
+			S_IFREG, 0, flags2);
+	if (fa == NULL)
+		return;
+
+	fprintf(stderr,
+_("illegal CoW extent size hint %lld, must be less than %u.\n"),
+			(long long)cli->fsx.fsx_cowextsize,
+			min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+	usage();
+}
+
 /*
  * Validate the configured stripe geometry, or is none is specified, pull
  * the configuration from the underlying device.
@@ -3982,6 +4042,10 @@ main(
 
 	finish_superblock_setup(&cfg, mp, sbp);
 
+	/* Validate the extent size hints now that @mp is fully set up. */
+	validate_extsize_hint(mp, &cli);
+	validate_cowextsize_hint(mp, &cli);
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;
