Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750753AbdAXM6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 07:58:05 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0OCsC58084875
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 07:58:05 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2865qymjt6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 07:58:04 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 24 Jan 2017 07:58:03 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 58987C90041
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 07:57:43 -0500 (EST)
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] xfsprogs: xfs_db: Interpret inode's di_format field as unsigned
Date: Tue, 24 Jan 2017 18:27:53 +0530
Message-Id: <1485262673-22783-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org

On a ppc64 big endian system, xfs_db would print the following,

xfs_db> p
core.magic = 0x494e
core.mode = 0100600
core.version = 3
core.format = -253

This is due to fp_dinode_fmt() interpretting the di_format field as
signed. This commit fixes the bug by passing BVUNSIGNED (instead of
BVSIGNED) as the argument to getbitval(). With this commit applied, we
now get,

xfs_db> p
core.magic = 0x494e
core.mode = 0100600
core.version = 3
core.format = 3 (btree)

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 db/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/inode.c b/db/inode.c
index cac19fc..8b7a41e 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -238,7 +238,7 @@ fp_dinode_fmt(
 	int			i;
 
 	for (i = 0, bitpos = bit; i < count; i++, bitpos += size) {
-		f = (xfs_dinode_fmt_t)getbitval(obj, bitpos, size, BVSIGNED);
+		f = (xfs_dinode_fmt_t)getbitval(obj, bitpos, size, BVUNSIGNED);
 		if (array)
 			dbprintf("%d:", i + base);
 		if (f < 0 || f >= dinode_fmt_name_size)
-- 
2.5.5

