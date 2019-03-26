Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45636 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbfCZRSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 13:18:24 -0400
Date: Tue, 26 Mar 2019 10:18:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 48/36] mkfs: don't use DIFLAG values for fsx_xflags
Message-ID: <20190326171819.GW1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

mkfs shouldn't be using DIFLAG values where FS_XFLAG values are
required.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e87c692c..19ad1c90 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1451,15 +1451,15 @@ data_opts_parser(
 		break;
 	case D_RTINHERIT:
 		if (getnum(value, opts, subopt))
-			cli->fsx.fsx_xflags |= XFS_DIFLAG_RTINHERIT;
+			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
 		break;
 	case D_PROJINHERIT:
 		cli->fsx.fsx_projid = getnum(value, opts, subopt);
-		cli->fsx.fsx_xflags |= XFS_DIFLAG_PROJINHERIT;
+		cli->fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
 		break;
 	case D_EXTSZINHERIT:
 		cli->fsx.fsx_extsize = getnum(value, opts, subopt);
-		cli->fsx.fsx_xflags |= XFS_DIFLAG_EXTSZINHERIT;
+		cli->fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
 		break;
 	case D_COWEXTSIZE:
 		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
@@ -2212,9 +2212,9 @@ validate_extsize_hint(
 	bool			rt;
 	uint16_t		flags = 0;
 
-	rt = (cli->fsx.fsx_xflags & XFS_DIFLAG_RTINHERIT);
+	rt = (cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT);
 
-	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
+	if (cli->fsx.fsx_xflags & FS_XFLAG_EXTSZINHERIT)
 		flags |= XFS_DIFLAG_EXTSIZE;
 
 	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
