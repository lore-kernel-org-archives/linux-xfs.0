Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755482AbeEaP5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 11:57:46 -0400
Date: Thu, 31 May 2018 08:57:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: handle realtime bitmap / summary files as text
Message-ID: <20180531155724.GZ837@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use handle_text to print realtime bitmap / summary file blocks instead
of erroring out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/type.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/type.c b/db/type.c
index 8b2f7b2f..7045d829 100644
--- a/db/type.c
+++ b/db/type.c
@@ -71,8 +71,8 @@ static const typ_t	__typtab[] = {
 	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_INODE, "inode", handle_struct, inode_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
@@ -115,8 +115,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
 		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
 		XFS_SB_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
@@ -161,8 +161,8 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
 		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
 		XFS_SB_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
