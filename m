Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42314 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbeLaTSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 14:18:53 -0500
Date: Mon, 31 Dec 2018 11:18:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: fix finobt record decoding when sparse inodes enabled
Message-ID: <20181231191848.GB20475@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

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
index d0234c57..f5f65042 100644
--- a/db/type.c
+++ b/db/type.c
@@ -151,7 +151,7 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
 		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_spcrc_hfld,
 		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
