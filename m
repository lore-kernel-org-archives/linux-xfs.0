Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752446AbdIRHNm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:13:42 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B77FB8046E
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 07:13:42 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAFCF1895B
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 07:13:41 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfsprogs/db: version command misses RMAPBT feature string
Date: Mon, 18 Sep 2017 15:13:35 +0800
Message-Id: <20170918071335.19365-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When I create a XFS with "rmapbt=1,reflink=1", "xfs_db -c version"
didn't show RMAPBT feature. But REFLINK can be found.

  # mkfs/mkfs.xfs -f -m rmapbt=1,reflink=1 /dev/sda3
  # db/xfs_db -c version /dev/sda3
  versionnum [0xb4a5+0x18a] = V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,REFLINK

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 db/sb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db/sb.c b/db/sb.c
index 8e7722cd..01d94a66 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -694,6 +694,8 @@ version_string(
 		strcat(s, ",SPARSE_INODES");
 	if (xfs_sb_version_hasmetauuid(sbp))
 		strcat(s, ",META_UUID");
+	if (xfs_sb_version_hasrmapbt(sbp))
+		strcat(s, ",RMAPBT");
 	if (xfs_sb_version_hasreflink(sbp))
 		strcat(s, ",REFLINK");
 	return s;
-- 
2.13.5

