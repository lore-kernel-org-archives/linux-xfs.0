Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbfCNVF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:05:56 -0400
Subject: [PATCH 20/36] xfs_db: fix finobt record decoding when sparse inodes
 enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:05:53 -0700
Message-ID: <155259755345.31886.7689089384611545119.stgit@magnolia>
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

Use the sparse inobt record field decoder (inobt_spcrc_hfld) to decode
finobt records when sparse inodes are enabled.  Otherwise, xfs_db
prints out bogus things like:

recs[1] = [startino,freecount,free]
1:[214720,16429,0xfffffffffff80000]

There can never be 16429 records in an inode btree record; instead it
should print:

recs[1] = [startino,holemask,count,freecount,free]
1:[214720,0,64,45,0xfffffffffff80000]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/type.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/type.c b/db/type.c
index f5f65042..d42935a2 100644
--- a/db/type.c
+++ b/db/type.c
@@ -107,7 +107,7 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
 		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_spcrc_hfld,
 		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
