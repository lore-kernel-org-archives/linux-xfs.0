Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfCNVFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:05:51 -0400
Subject: [PATCH 19/36] mkfs: validate extent size hint parameters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:05:47 -0700
Message-ID: <155259754740.31886.13886644609473939892.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate extent and cow extent size hints that are passed to mkfs so
that we avoid formatting a filesystem that will never mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d1387ddf..9e1c6ec5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2202,6 +2202,66 @@ validate_rtextsize(
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
@@ -3945,6 +4005,10 @@ main(
 
 	finish_superblock_setup(&cfg, mp, sbp);
 
+	/* Validate the extent size hints now that @mp is fully set up. */
+	validate_extsize_hint(mp, &cli);
+	validate_cowextsize_hint(mp, &cli);
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;
