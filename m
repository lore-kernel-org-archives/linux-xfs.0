Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAX2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NORxA124373
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:36 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxtsa560-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:36 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSZnB022698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:35 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NSYoq007979
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:35 GMT
Subject: [PATCH 16/23] xfs_db: fix finobt record decoding when sparse inodes
 enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:33 -0800
Message-ID: <155148291379.16677.16422787097321462419.stgit@magnolia>
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
