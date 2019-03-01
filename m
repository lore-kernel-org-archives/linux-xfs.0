Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAX2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOL4Z124312
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:12 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxtsa54y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSAh4022167
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:11 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSA8k021162
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:10 GMT
Subject: [PATCH 12/23] mkfs: validate extent size hint parameters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:09 -0800
Message-ID: <155148288940.16677.2273100850595552446.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
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
