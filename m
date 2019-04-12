Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfDLTbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 15:31:33 -0400
Date: Fri, 12 Apr 2019 12:31:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 19/36] mkfs: validate extent size hint parameters
Message-ID: <20190412193126.GJ1019523@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259754740.31886.13886644609473939892.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259754740.31886.13886644609473939892.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate extent and cow extent size hints that are passed to mkfs so
that we avoid formatting a filesystem that will never mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: simulate extsize hint validation on a directory
---
 mkfs/xfs_mkfs.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d1387ddf..d7951faa 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2202,6 +2202,85 @@ validate_rtextsize(
 	ASSERT(cfg->rtextblocks);
 }
 
+/* Validate the incoming extsize hint. */
+static void
+validate_extsize_hint(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	xfs_failaddr_t		fa;
+	uint16_t		flags = 0;
+
+	/*
+	 * First we validate the extent size inherit hint on a directory so
+	 * that we know that we'll be propagating a correct hint and flag to
+	 * new files on the data device.
+	 */
+	if (cli->fsx.fsx_xflags & FS_XFLAG_EXTSZINHERIT)
+		flags |= XFS_DIFLAG_EXTSZINHERIT;
+
+	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFDIR,
+			flags);
+	if (fa) {
+		fprintf(stderr,
+_("illegal extent size hint %lld, must be less than %u.\n"),
+				(long long)cli->fsx.fsx_extsize,
+				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+		usage();
+	}
+
+	/*
+	 * Now we do it again with a realtime file so that we know the hint and
+	 * flag that get passed on to realtime files will be correct.
+	 */
+	if (mp->m_sb.sb_rextsize == 0)
+		return;
+
+	flags = XFS_DIFLAG_REALTIME;
+	if (cli->fsx.fsx_xflags & FS_XFLAG_EXTSZINHERIT)
+		flags |= XFS_DIFLAG_EXTSIZE;
+
+	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
+			flags);
+
+	if (fa) {
+		fprintf(stderr,
+_("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
+				(long long)cli->fsx.fsx_extsize,
+				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
+				mp->m_sb.sb_rextsize);
+		usage();
+	}
+}
+
+/* Validate the incoming CoW extsize hint. */
+static void
+validate_cowextsize_hint(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	xfs_failaddr_t		fa;
+	uint64_t		flags2 = 0;
+
+	/*
+	 * Validate the copy on write extent size inherit hint on a directory
+	 * so that we know that we'll be propagating a correct hint and flag to
+	 * new files on the data device.
+	 */
+	if (cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE)
+		flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+
+	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
+			S_IFDIR, 0, flags2);
+	if (fa) {
+		fprintf(stderr,
+_("illegal CoW extent size hint %lld, must be less than %u.\n"),
+				(long long)cli->fsx.fsx_cowextsize,
+				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+		usage();
+	}
+}
+
 /*
  * Validate the configured stripe geometry, or is none is specified, pull
  * the configuration from the underlying device.
@@ -3945,6 +4024,10 @@ main(
 
 	finish_superblock_setup(&cfg, mp, sbp);
 
+	/* Validate the extent size hints now that @mp is fully set up. */
+	validate_extsize_hint(mp, &cli);
+	validate_cowextsize_hint(mp, &cli);
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;
